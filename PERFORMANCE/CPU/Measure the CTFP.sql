/*
https://michaeljswart.com/2022/01/measure-the-effect-of-cost-threshold-for-parallelism/
What Next?
Keep track of the queries you see whose estimated cost is below the new threshold you’re considering (50). Especially keep track of the average_query_cpu_in_Seconds.
Then make the CTFP change and compare the average_query_cpu_in_Seconds before and after. Remember to use the sql_hash as the key because the plan_hash will have changed.
*/
WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
SELECT 
	sql_text.[text] as sqltext,
	qp.query_plan,
	xml_values.subtree_cost as estimated_query_cost_in_query_bucks,
	qs.last_dop,
	CAST((qs.total_worker_time/(qs.execution_count + 0.0)) as money)/1000/1000 as average_query_cpu_in_Seconds,
	qs.total_worker_time,
	qs.execution_count,
	qs.query_hash,
	qs.query_plan_hash,
	qs.plan_handle,
	qs.sql_handle	
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
CROSS APPLY sys.dm_exec_query_plan (qs.plan_handle) qp
CROSS APPLY 
	(
		SELECT SUBSTRING(st.[text],(qs.statement_start_offset + 2) / 2,
		(CASE 
			WHEN qs.statement_end_offset = -1  THEN LEN(CONVERT(NVARCHAR(MAX),st.[text])) * 2
			ELSE qs.statement_end_offset + 2
			END - qs.statement_start_offset) / 2)
	) as sql_text([text])
OUTER APPLY 
	( 
		SELECT 
			n.c.value('@QueryHash', 'NVARCHAR(30)')  as query_hash,
			n.c.value('@StatementSubTreeCost', 'FLOAT')  as subtree_cost
		FROM qp.query_plan.nodes('//StmtSimple') as n(c)
	) xml_values
WHERE qs.last_dop > 1
AND sys.fn_varbintohexstr(qs.query_hash) = xml_values.query_hash
AND execution_count > 10
ORDER BY xml_values.subtree_cost
OPTION (RECOMPILE);