/*
    Extract bare hostnames from $(Primary) and $(Secondary) sqlcmd variables.

    Handles these connection string formats:
        SERVER              -> SERVER
        SERVER\INSTANCE     -> SERVER
        SERVER,PORT         -> SERVER
        SERVER.domain.com   -> SERVER

    Declares @primary_name and @secondary_name as sysname variables.
    This file is a batch fragment; do not add GO statements.
*/
DECLARE @primary_name sysname = N'$(Primary)';
IF @primary_name LIKE N'%.%'
BEGIN
    SET @primary_name = LEFT(@primary_name, CHARINDEX(N'.', @primary_name) - 1);
END
ELSE IF @primary_name LIKE N'%\\%' ESCAPE N'\'
BEGIN
    SET @primary_name = LEFT(@primary_name, CHARINDEX(N'\', @primary_name) - 1);
END
ELSE IF @primary_name LIKE N'%,%'
BEGIN
    SET @primary_name = LEFT(@primary_name, CHARINDEX(N',', @primary_name) - 1);
END

DECLARE @secondary_name sysname = N'$(Secondary)';
IF @secondary_name LIKE N'%.%'
BEGIN
    SET @secondary_name = LEFT(@secondary_name, CHARINDEX(N'.', @secondary_name) - 1);
END
ELSE IF @secondary_name LIKE N'%\\%' ESCAPE N'\'
BEGIN
    SET @secondary_name = LEFT(@secondary_name, CHARINDEX(N'\', @secondary_name) - 1);
END
ELSE IF @secondary_name LIKE N'%,%'
BEGIN
    SET @secondary_name = LEFT(@secondary_name, CHARINDEX(N',', @secondary_name) - 1);
END
