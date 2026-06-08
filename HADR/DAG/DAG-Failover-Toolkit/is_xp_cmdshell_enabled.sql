/*
    Detect if xp_cmdshell is enabled via sys.sp_configure.
*/
GO
SET NOCOUNT ON;
DECLARE @is_xp_cmdshell_enabled         bit;
DECLARE @is_advanced_options_enabled    bit;
DECLARE @enable_cmd                     nvarchar(max);

SET @is_advanced_options_enabled = COALESCE(
                                                (
                                                    SELECT CONVERT(nvarchar(11), c.value_in_use)
                                                    FROM sys.configurations c
                                                    WHERE c.name = N'advanced options'
                                                )
                                            , 0);

SET @is_xp_cmdshell_enabled = COALESCE(
                                        (
                                            SELECT CONVERT(nvarchar(11), c.value_in_use)
                                            FROM sys.configurations c
                                            WHERE c.name = N'xp_cmdshell'
                                        )
                                    , 0);

IF @is_xp_cmdshell_enabled = 0
BEGIN
    IF '$(EnableXpCmdshellIfRequired)' = 'YES'
    BEGIN
        IF @is_advanced_options_enabled = 0
        BEGIN
            SET @enable_cmd = N'EXEC sys.sp_configure ''advanced options'', 1;RECONFIGURE;';
            EXEC sys.sp_executesql @enable_cmd;
            PRINT N'Enabled "Advanced Options" via sys.sp_configure';
        END
        SET @enable_cmd = N'EXEC sys.sp_configure ''xp_cmdshell'', 1;RECONFIGURE;';
        EXEC sys.sp_executesql @enable_cmd;
        PRINT N'Enabled "xp_cmdshell" via sys.sp_configure';
    END
    ELSE
    BEGIN
        PRINT N'xp_cmdshell is not enabled in the SQL Server System Configuration.';
        PRINT N'Enable it via EXEC sys.sp_configure ''xp_cmdshell'', 1; RECONFIGURE;';
    END
END
GO
