USE ABP_SFA_BMB
SELECT DISTINCT OBJECT_NAME(OBJECT_ID) AS [Object_Name], last_user_update --,*
FROM sys.dm_db_index_usage_stats 
WHERE database_id = DB_ID('ABP_SFA_BMB') -- PUT DATABASE NAME HERE
AND OBJECT_ID=OBJECT_ID('ABP_Route_Client_Divisions') -- TABLE NAME
ORDER BY last_user_update DESC