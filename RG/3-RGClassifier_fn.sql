USE master
GO
CREATE FUNCTION [dbo].[RGClassifier_fn]() 
RETURNS sysname
WITH SCHEMABINDING
AS
BEGIN
DECLARE @grp_name sysname
	IF (SUSER_NAME() in ('<login_name_to_be_governered>'))
	SET @grp_name = 'TEST' -- the WORKLOAD GROUP created in step 2
	ELSE SET @grp_name = 'default' -- the default WORKLOAD GROUP
    RETURN @grp_name
END;