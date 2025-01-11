USE [HISGENX]
GO 
-- DDL Trigger
CREATE TRIGGER BlockDDL
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS 
BEGIN 
  -- This assume the account used by the application is not a member of the sysadmin role (it better not be)
  IF NOT(IS_SRVROLEMEMBER('sysadmin') = 1)
  BEGIN 
    ROLLBACK TRAN;
  END;
END;
GO 