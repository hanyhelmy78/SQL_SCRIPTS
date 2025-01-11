/*
Import-Module FailoverClusters
Get-ClusterResource -Cluster ruh1abpcls #Get-ClusterParameter
Get-ClusterResource ABP-ISELL | Set-ClusterParameter RegisterAllProvidersIP 0   
Get-ClusterResource ABP-ISELL | Set-ClusterParameter HostRecordTTL 300  
Stop-ClusterResource ABP-ISELL  
Start-ClusterResource ABP-ISELL  
Start-Clustergroup <yourListenerGroupName>
*/