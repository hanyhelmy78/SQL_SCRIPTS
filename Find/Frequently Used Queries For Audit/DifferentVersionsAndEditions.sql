DECLARE @TSql NVARCHAR(MAX) = '';

SELECT @TSql = @TSql + 'SELECT TOP(1) *' +CHAR(13)+CHAR(10)+
    'FROM OPENQUERY([' + data_source + '],' +CHAR(13)+CHAR(10)+
    '''SELECT CURRENT_TIMESTAMP AS [CURRENT_TIMESTAMP], ' +CHAR(13)+CHAR(10)+
    'dec.local_net_address,' +CHAR(13)+CHAR(10)+
    'REPLACE(LEFT(@@VERSION, PATINDEX(''''% - %'''', @@VERSION)), ''''Microsoft SQL Server '''', '''''''') AS [@@VERSION],' +CHAR(13)+CHAR(10)+
    'SERVERPROPERTY(''''ProductLevel'''') AS ProductLevel, ' +CHAR(13)+CHAR(10)+
    'SERVERPROPERTY(''''Edition'''') AS Edition, ' +CHAR(13)+CHAR(10)+
    'SERVERPROPERTY(''''ProductVersion'''') AS ProductVersion,' +CHAR(13)+CHAR(10)+
    'CAST(SERVERPROPERTY(N''''MachineName'''') AS VARCHAR) AS MachineName' +CHAR(13)+CHAR(10)+
    'FROM sys.dm_exec_connections AS dec' +CHAR(13)+CHAR(10)+
    'WHERE dec.session_id = @@SPID;'') UNION ALL' + CHAR(13) + CHAR(10)
FROM sys.servers
WHERE data_source <> @@SERVERNAME
AND product = 'SQL Server'
ORDER BY data_source;

--Trim off last occurrence of UNION ALL' + CHAR(13) + CHAR(10)
SET @TSql = LEFT(@TSql, LEN(@TSql) - 12);

PRINT(@Tsql);
EXEC (@Tsql);