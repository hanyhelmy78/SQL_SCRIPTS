EXECUTE AS LOGIN = 'coreBio' --Change This
SELECT [name]
FROM MASTER.sys.databases
WHERE HAS_DBACCESS([name]) = 1
REVERT