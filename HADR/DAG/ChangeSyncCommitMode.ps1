function Get-AgSanityCheck {
 
#.PARAMETERS
param(
    [Parameter(Mandatory)]
    [int]$ShowMe
)

$report = $ShowMe
if ([string]::IsNullOrEmpty($ShowMe)) 
   {
      Write-Host "Please provide me with all parameters."
      return
   }
#+-------------------+----------------------------+
#|    Parameters     |     Descriptions           |
#+-------------------+----------------------------+
#|                   | 0 = only run the script    |
#| $report           | 1 = show only Format-List  |
#|                   | 2 = show only Ou-GridView  |
#|                   | 3 = all above              |
#+-------------------+----------------------------+
#
# Variables
$service = [System.Collections.ArrayList]@() 
$serviceName = [System.Collections.ArrayList]@()
$table = New-Object System.Collections.ArrayList;
$ag_table = New-Object System.Collections.ArrayList;
$Go_or_NOGo_table = New-Object System.Collections.ArrayList;
$service += (get-service -name "*sql*" | where {$_.DisplayName -like "SQL Server (*"} | where-object {$_.Status -eq "Running"} | select Name| sort DisplayName).name

if ($service.gettype().name -eq "string")
{
    $serviceName.add($service) | out-null
}
else
{
    for ($s = 0; $s -lt $service.count; $s++)
    {
        if ($service -like "*$*")
        {
            $serviceName += $service[$s].tostring().substring($service[$s].tostring().indexof("$")+1,$service[$s].length - $service[$s].tostring().indexof("$")-1)
        }
        else
        {
            $serviceName += $service[$s].tostring()
        }
    }
}

$localhost = (hostname)
for ($in = 0; $in -lt $serviceName.count; $in++)
{
    $v_instance = $serviceName[$in].tostring()
    $v = (get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL').$v_instance
    $port = (get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$v\MSSQLServer\SuperSocketNetLib\Tcp\IPAll").TcpPort
    $ServerInstanceWithPort = $localhost+","+$port
    $database = "master"

    $AgNameQuery = "SET NOCOUNT ON; Select name FROM sys.availability_groups where is_distributed = 0"

    $AG_AG_Name = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $AgNameQuery
    $AG_Names += $AG_AG_Name | where {$_ -notlike "*---*" -and $_ -notlike "*name*"}
    if ($AG_Names.count -gt 0 )
    {
        foreach ($a in $AG_Names)
        {
            $ListenerNameQuery = "SET NOCOUNT ON; Select l.dns_name
            FROM sys.availability_group_listeners l inner join sys.availability_group_listener_ip_addresses ip
            ON l.listener_id = ip.listener_id
            inner join sys.availability_groups ag
            on l.group_id = ag.group_id
            WHERE ip.state = 1 and ag.name = '$a'"

            $AG_LName = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $ListenerNameQuery
            $ListenerName = $AG_LName | where {$_ -notlike "*---*" -and $_ -notlike "*dns_name*"}

            $ListenerPortQuery = "SET NOCOUNT ON; Select l.port
            FROM sys.availability_group_listeners l inner join sys.availability_group_listener_ip_addresses ip
            ON l.listener_id = ip.listener_id
            inner join sys.availability_groups ag
            on l.group_id = ag.group_id
            WHERE ip.state = 1 and ag.name = '$a'"
            $AG_LPort = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $ListenerPortQuery
            $ListenerPort = $AG_LPort | where {$_ -notlike "*---*" -and $_ -notlike "*port*"}

            $ag_table += [pscustomobject]@{
                        AvailabilityGroup = $a.Trim();
                        InstanceName = $v_instance;
                        InstncePort  = $port;
                        ListenerName = $ListenerName.Trim();
                        ListenerPort = $ListenerPort.Trim()
                        }
        }
    }
}

$pct = 0
$total = 8.0
for ($in = 0; $in -lt $ag_table.count; $in++)
{
    $AG_Name = ($ag_table[$in] | select AvailabilityGroup).AvailabilityGroup
    $ListenerName = ($ag_table[$in] | select ListenerName).ListenerName
    $ListenerPort = ($ag_table[$in] | select ListenerPort).ListenerPort
    $ServerInstanceWithPort = $ListenerName.Trim()+","+$ListenerPort.Trim()

    $Go_or_NoGoQuery = "SET NOCOUNT ON; select case 
                        when connected_state + synchronization_health + is_pending_secondary_suspend + is_failover_ready = 0
                        then 'passed' else 'Not ready' end Go_or_NoGo
                        from (
                        select 
                        sum(case connected_state_desc when 'CONNECTED' then 0 else 1 end) connected_state, 
                        sum(case synchronization_health_desc when 'HEALTHY' then 0 else 1 end) synchronization_health,
                        sum(case cast(is_pending_secondary_suspend as int) when 0 then 0 else 1 end) is_pending_secondary_suspend
                        from sys.dm_hadr_availability_replica_states ars inner join sys.availability_groups ag
                        on ars.group_id = ag.group_id
                        inner join sys.dm_hadr_database_replica_cluster_states dbrcs
                        on dbrcs.replica_id = ars.replica_id
                        where ag.name = '$AG_Name')a
                        cross apply (select 
                        case when count(*) = sum(cast(is_failover_ready as int)) then 0 else 1 end is_failover_ready
                        from sys.dm_hadr_database_replica_cluster_states dbrcs
                        inner join sys.dm_hadr_availability_replica_states ars
                        on dbrcs.replica_id = ars.replica_id
                        inner join sys.availability_groups ag
                        on ars.group_id = ag.group_id
                        where ars.is_local = 1
                        and ag.name = '$AG_Name') rep"

         $PercentComplete = ((($pct+1.0)/($total*$ag_table.count))*100.0)
         Write-Progress -PercentComplete $PercentComplete -Status "In-Progress $PercentComplete%" -Activity "Sanity Check Availability Groups"
         $AG_status = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $Go_or_NoGoQuery
         $Go_or_NoGo = $AG_status | where {$_ -notlike "*---*" -and $_ -notlike "*Go_or_NoGo*"}

    $Go_or_NoGoQuery = "SET NOCOUNT ON; select 
                        case sum(case connected_state_desc when 'CONNECTED' then 0 else 1 end) 
                        when 0 then 'Yes' else 'No' end Connected
                        from sys.dm_hadr_availability_replica_states ars inner join sys.availability_groups ag
                        on ars.group_id = ag.group_id
                        inner join sys.dm_hadr_database_replica_cluster_states dbrcs
                        on dbrcs.replica_id = ars.replica_id
                        where ag.name = '$AG_Name'"

           $PercentComplete = ((($pct+2.0)/($total*$ag_table.count))*100.0)
           Write-Progress -PercentComplete $PercentComplete -Status "In-Progress $PercentComplete%" -Activity "Sanity Check Availability Groups"
           $AG_status = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $Go_or_NoGoQuery
           $CONNECTED = $AG_status | where {$_ -notlike "*---*" -and $_ -notlike "*Connected*"}

    $Go_or_NoGoQuery = "SET NOCOUNT ON; select 
                        case sum(case synchronization_health_desc 
                        when 'HEALTHY' then 0 else 1 end) when 0 then 'Yes' else 'No' end All_Replicas_Sync
                        from sys.dm_hadr_availability_replica_states ars inner join sys.availability_groups ag
                        on ars.group_id = ag.group_id
                        inner join sys.dm_hadr_database_replica_cluster_states dbrcs
                        on dbrcs.replica_id = ars.replica_id
                        where ag.name = '$AG_Name'"

            $PercentComplete = ((($pct+3.0)/($total*$ag_table.count))*100.0)
            Write-Progress -PercentComplete $PercentComplete -Status "In-Progress $PercentComplete%" -Activity "Sanity Check Availability Groups"
            $AG_status = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $Go_or_NoGoQuery
            $HEALTHY = $AG_status | where {$_ -notlike "*---*" -and $_ -notlike "*All_Replicas_Sync*"}

    $Go_or_NoGoQuery = "SET NOCOUNT ON; select 
                        case sum(case cast(is_pending_secondary_suspend as int) 
                        when 0 then 0 else 1 end) when 0 then 'Yes' else 'No' end no_pending_secondary_suspend
                        from sys.dm_hadr_availability_replica_states ars inner join sys.availability_groups ag
                        on ars.group_id = ag.group_id
                        inner join sys.dm_hadr_database_replica_cluster_states dbrcs
                        on dbrcs.replica_id = ars.replica_id
                        where ag.name = '$AG_Name'"

            $PercentComplete = ((($pct+4.0)/($total*$ag_table.count))*100.0)
            Write-Progress -PercentComplete $PercentComplete -Status "In-Progress $PercentComplete%" -Activity "Sanity Check Availability Groups"
            $AG_status = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $Go_or_NoGoQuery
            $pending = $AG_status | where {$_ -notlike "*---*" -and $_ -notlike "*no_pending_secondary_suspend*"}

    $Go_or_NoGoQuery = "SET NOCOUNT ON; select 
                        case when count(*) = sum(cast(is_failover_ready as int)) 
                        then 'Yes' else 'No' end all_databases_ready_for_failover
                        from sys.dm_hadr_database_replica_cluster_states dbrcs
                        inner join sys.dm_hadr_availability_replica_states ars
                        on dbrcs.replica_id = ars.replica_id
                        inner join sys.availability_groups ag
                        on ars.group_id = ag.group_id
                        where ars.is_local = 1
                        and ag.name = '$AG_Name'"

            $PercentComplete = ((($pct+5.0)/($total*$ag_table.count))*100.0)
            Write-Progress -PercentComplete $PercentComplete -Status "In-Progress $PercentComplete%" -Activity "Sanity Check Availability Groups"
            $AG_status = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $Go_or_NoGoQuery
            $ready = $AG_status | where {$_ -notlike "*---*" -and $_ -notlike "*all_databases_ready_for_failover*"}

    $Go_or_NoGoQuery = "SET NOCOUNT ON; SELECT ag.name AS DAC_AGName
                        FROM sys.availability_groups ag
                        INNER JOIN sys.availability_replicas ar 
                        ON ag.group_id = ar.group_id
                        INNER JOIN sys.dm_hadr_availability_replica_states ars 
                        ON ar.replica_id = ars.replica_id
                        where ag.is_distributed = 1
                        and ag.name in (
                        SELECT ag.name AS AGName
                        FROM sys.availability_groups ag
                        INNER JOIN sys.availability_replicas ar 
                        ON ag.group_id = ar.group_id
                        INNER JOIN sys.dm_hadr_availability_replica_states ars 
                        ON ar.replica_id = ars.replica_id
                        where ag.is_distributed = 1
                        and ar.replica_server_name  = '$AG_Name')
                        and ar.replica_server_name != '$AG_Name'"

            $PercentComplete = ((($pct+6.0)/($total*$ag_table.count))*100.0)
            Write-Progress -PercentComplete $PercentComplete -Status "In-Progress $PercentComplete%" -Activity "Sanity Check Availability Groups"
            $AG_status = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $Go_or_NoGoQuery
            $dac = $AG_status | where {$_ -notlike "*---*" -and $_ -notlike "*DAC_AGName*"}
            if ([string]::IsNullOrEmpty($dac)) 
            {
              $dac = "NA"
            }

    $Go_or_NoGoQuery = "SET NOCOUNT ON; SELECT ar.replica_server_name AG_Name
                        FROM sys.availability_groups ag
                        INNER JOIN sys.availability_replicas ar 
                        ON ag.group_id = ar.group_id
                        INNER JOIN sys.dm_hadr_availability_replica_states ars 
                        ON ar.replica_id = ars.replica_id
                        where ag.is_distributed = 1
                        and ag.name in (
                        SELECT ag.name AS AGName
                        FROM sys.availability_groups ag
                        INNER JOIN sys.availability_replicas ar 
                        ON ag.group_id = ar.group_id
                        INNER JOIN sys.dm_hadr_availability_replica_states ars 
                        ON ar.replica_id = ars.replica_id
                        where ag.is_distributed = 1
                        and ar.replica_server_name  = '$AG_Name')
                        and ar.replica_server_name != '$AG_Name'"

            $PercentComplete = ((($pct+7.0)/($total*$ag_table.count))*100.0)
            Write-Progress -PercentComplete $PercentComplete -Status "In-Progress $PercentComplete%" -Activity "Sanity Check Availability Groups"
            $AG_status = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $Go_or_NoGoQuery
            $sec_ag = $AG_status | where {$_ -notlike "*---*" -and $_ -notlike "*AG_Name*"}
            if ([string]::IsNullOrEmpty($sec_ag)) 
            {
              $sec_ag = "NA"
            }
    $Go_or_NoGoQuery = "SET NOCOUNT ON; SELECT case 
                        when ars.synchronization_health_desc = 'HEALTHY'
                        and ars.connected_state_desc = 'CONNECTED' then 'Yes' else 'No' 
                        end SecondaryReady
                        FROM sys.availability_groups ag
                        INNER JOIN sys.availability_replicas ar 
                        ON ag.group_id = ar.group_id
                        INNER JOIN sys.dm_hadr_availability_replica_states ars 
                        ON ar.replica_id = ars.replica_id
                        where ag.is_distributed = 1
                        and ag.name in (
                        SELECT ag.name AS AGName
                        FROM sys.availability_groups ag
                        INNER JOIN sys.availability_replicas ar 
                        ON ag.group_id = ar.group_id
                        INNER JOIN sys.dm_hadr_availability_replica_states ars 
                        ON ar.replica_id = ars.replica_id
                        where ag.is_distributed = 1
                        and ar.replica_server_name  = '$AG_Name')
                        and ar.replica_server_name != '$AG_Name'"

            $PercentComplete = ((($pct+8.0)/($total*$ag_table.count))*100.0)
            Write-Progress -PercentComplete $PercentComplete -Status "In-Progress $PercentComplete%" -Activity "Sanity Check Availability Groups"
            $AG_status = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $Go_or_NoGoQuery
            $sec_ready = $AG_status | where {$_ -notlike "*---*" -and $_ -notlike "*SecondaryReady*"}
            if ([string]::IsNullOrEmpty($sec_ready)) 
            {
              $sec_ready = "NA"
            }

            $Go_or_NOGo_table += [pscustomobject]@{
            AGName = $AG_Name.Trim();
            LstnrName = $ListenerName.Trim();
            LstnrPort = $ListenerPort.Trim();
            RepsConnected = $CONNECTED.Trim();
            RepsSync = $HEALTHY.Trim();
            NoPndngSec = $pending.Trim();
            DBsReadyFailover = $ready.Trim();
            Status = $Go_or_NoGo.Trim();
            DACName = $dac.Trim();
            SecndryAG = $sec_ag.Trim();
            IsSecndryReady = $sec_ready.Trim()
            }
    $pct += $total
}

if ($report -eq 0)
{
    $Go_or_NOGo_table
}
elseif ($report -eq 1)
{
    $Go_or_NOGo_table | fl
}
elseif ($report -eq 2)
{
    $Go_or_NOGo_table | Out-GridView
}
elseif ($report -eq 3)
{
    $Go_or_NOGo_table | fl
    $Go_or_NOGo_table | Out-GridView
}
}

###########Change Secondary AG to Synchronous_COMMIT Mode scope###########

if (Test-Path variable:ag_table) {rv ag_table} 
$ag_table = New-Object System.Collections.ArrayList;
$AgSanityCheck = Get-AgSanityCheck -ShowMe 0 

$ag_table += ($AgSanityCheck | 
where {$_.Status -eq "Passed" -and $_.IsSecndryReady -eq "Yes"} | 
Select-Object AGName,LstnrName,LstnrPort,DACName,SecndryAG,IsSecndryReady)

for ($in = 0; $in -lt $ag_table.count; $in++)
{
    $PrimaryLName = ($ag_table[$in] | select LstnrName).LstnrName
    $PrimaryLPort = ($ag_table[$in] | select LstnrPort).LstnrPort
    $DACName = ($ag_table[$in] | select DACName).DACName
    $SecondaryAG = ($ag_table[$in] | select SecndryAG).SecndryAG
    $database = "master"
    $ServerInstanceWithPort = $PrimaryLName.Trim()+","+$PrimaryLPort.Trim()
    $DACName = $DACName.Trim()
    $SecondaryAG = $SecondaryAG.Trim()
        
    $AgDacPrimaryReplicaQuery = "SET NOCOUNT ON; SELECT @@servername PrimaryReplicaName;"
    $AG_status = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $AgDacPrimaryReplicaQuery
    $PrimaryReplica = $AG_status | where {$_ -notlike "*---*" -and $_ -notlike "*PrimaryReplicaName*"}
    $PrimaryReplica = $PrimaryReplica.Trim()

    $SyncSecondaryAgQuery = "ALTER AVAILABILITY GROUP [$DACName]
    MODIFY AVAILABILITY GROUP ON '$SecondaryAG'
    WITH (AVAILABILITY_MODE = SYNCHRONOUS_COMMIT);"
    $AG_status = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $SyncSecondaryAgQuery
    $AG_status

    if ([string]::IsNullOrEmpty($AG_status)) 
    {
        Write-Host "The Secondary AG " -ForegroundColor Green -NoNewline
        Write-Host $SecondaryAG  -ForegroundColor Yellow -NoNewline
        Write-Host " of Distributed AG " -ForegroundColor Green -NoNewline
        Write-Host $DACName -ForegroundColor Yellow -NoNewline
        Write-Host " has been successfully altered to " -ForegroundColor Green -NoNewline
        Write-Host "SYNCHRONOUS_COMMIT" -ForegroundColor Cyan -NoNewline
        Write-Host " AVAILABILITY_MODE." -ForegroundColor Green
    }

    $AgDagCheckSyncQuery = "SET NOCOUNT ON; SELECT case when 
    (count(*) * 4) = (sum(drs.synchronization_state + drs.synchronization_health + cast(drs.is_suspended as int)))
    and
    count(*) = sum(cast(drs.is_commit_participant as int))
    then 'Yes' else 'Not yet' end Dag_Sec_Ag_ready_to_failover
    FROM sys.availability_groups ag
    inner join sys.dm_hadr_database_replica_states drs 
    on ag.group_id = drs.group_id
    where ag.is_distributed = 1
    and ag.name = '$DACName';"
    
    $SecondaryAgSyncStatus = "Not yet"
    while ($SecondaryAgSyncStatus -eq "Not yet") 
    {    
        $AG_status = sqlcmd -S $ServerInstanceWithPort -d $database -E -Q $AgDagCheckSyncQuery
        $SecondaryAgSyncStatus = $AG_status | where {$_ -notlike "*---*" -and $_ -notlike "*Dag_Sec_Ag_ready_to_failover*"}
        Write-Host $SecondaryAgSyncStatus -ForegroundColor Yellow
        Start-Sleep 1
    }

    Write-Host "The Secondary AG " -ForegroundColor Green -NoNewline
    Write-Host $SecondaryAG  -ForegroundColor Yellow -NoNewline
    Write-Host " of Distributed AG " -ForegroundColor Green -NoNewline
    Write-Host $DACName -ForegroundColor Yellow -NoNewline
    Write-Host " has been " -ForegroundColor Green -NoNewline
    Write-Host "confirmed" -ForegroundColor Green -BackgroundColor Black -NoNewline
    Write-Host " to have changed to " -ForegroundColor Green -NoNewline
    Write-Host "SYNCHRONOUS_COMMIT" -ForegroundColor Cyan -BackgroundColor Black -NoNewline
    Write-Host " AVAILABILITY_MODE." -ForegroundColor Green

}
