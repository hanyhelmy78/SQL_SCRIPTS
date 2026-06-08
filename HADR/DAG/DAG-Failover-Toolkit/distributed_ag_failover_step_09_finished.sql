/*
    Modify the DNS CNAME
*/
GO

:CONNECT $(Primary)
/* step 04a also provides @primary_name and @secondary_name via parse_server_names.sql */
:r ./distributed_ag_failover_step_04a_confirm_committed_lsn.sql
IF @last_hardened_lsn <> N''
BEGIN
    SET NOCOUNT ON;
    DECLARE @hostname                       varchar(1000);
    DECLARE @cmd                            varchar(1000);
    DECLARE @output TABLE
    (
        [output] varchar(1000) NULL
    );
    DECLARE @IsDnsServerModuleInstalledCmd  varchar(1000);
    DECLARE @IsDnsServerModuleInstalled     bit = 0;
    DECLARE @return                         int = 0;

    /*
        Determine the DNS target: the new primary after failover/failback.
        @primary_name and @secondary_name are bare hostnames provided by
        parse_server_names.sql (included via step 04a).
    */
    IF '$(TestMode)' = 'FailOver'
    BEGIN
        SET @hostname = LOWER(@secondary_name);
        PRINT N'$(Secondary)';
    END
    ELSE
    BEGIN
        SET @hostname = LOWER(@primary_name);
        PRINT N'$(Primary)';
    END

    SET @hostname = COALESCE(@hostname, '');
    /*
        Build the powershell command
    */
    SET @cmd = 'PowerShell.exe -c Add-DnsServerResourceRecordCName -ComputerName "$(DNSServer)" -Name "$(CName)" -HostNameAlias "' + @hostname + '.$(DNSZone)" -ZoneName "$(DNSZone)" -TimeToLive "$(TTL)"';

    /*
        This command confirms if the target server has the DnsServer powershell module installed.
        You can install the module by adding the RSAT DNS Server Tools package to the server.
    */
    SET @IsDnsServerModuleInstalledCmd = 'PowerShell -c (Get-Module -ListAvailable -Name DnsServer).Count';

    INSERT INTO @output([output])
    EXEC sys.xp_cmdshell @IsDnsServerModuleInstalledCmd;

    SET @IsDnsServerModuleInstalled = COALESCE((SELECT COUNT(1) FROM @output o WHERE o.[output] = '1'), 0);

    IF @IsDnsServerModuleInstalled = 1
    BEGIN
        DECLARE @current_cname_cmd varchar(1000);
        DECLARE @txt varchar(1000);
        SET @current_cname_cmd = 'PowerShell.exe -c (Get-DnsServerResourceRecord -ComputerName "$(DNSServer)" -Name "$(Cname)" -ZoneName "$(DNSZone)").RecordData.HostNameAlias';
        PRINT 'Currently, the $(CName) is pointing at :';
        INSERT INTO @output ([output])
        EXEC @return = sys.xp_cmdshell @current_cname_cmd;
        DECLARE cur CURSOR LOCAL READ_ONLY STATIC FORWARD_ONLY
        FOR
        SELECT o.[output]
        FROM @output o;
        OPEN cur;
        FETCH NEXT FROM cur INTO @txt;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT @txt;
            FETCH NEXT FROM cur INTO @txt;
        END
        CLOSE cur;
        DEALLOCATE cur;

        IF @return = 0
        BEGIN
            PRINT 'Updating DNS CName $(CName).$(DNSZone) to ' + @hostname + '.$(DNSZone) via PowerShell';
            EXEC sys.xp_cmdshell @cmd;
        END
        ELSE
        BEGIN
            PRINT N'A non-zero return code was passed back from PowerShell - please inspect the output above to determine the problem.  You will need to manually update the cname with the below command:';
            PRINT @cmd;
        END
    END
    ELSE
    BEGIN
        PRINT N'PowerShell on ' + CONVERT(nvarchar(128), SERVERPROPERTY(N'ComputerNamePhysicalNetbios')) + N' does not have the DnsServer module installed.  You''ll need to manually update the DNS CName via the following command:';
        PRINT @cmd;
    END
END
GO