USE msdb
GO
SELECT NAME, SUSER_SNAME(owner_sid) AS JobOwner
FROM dbo.sysjobs