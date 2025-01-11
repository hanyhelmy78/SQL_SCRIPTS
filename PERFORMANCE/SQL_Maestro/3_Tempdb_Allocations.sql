-- SQL Server Performance Tuning Fast Track Video Course
-- https://www.SQLMaestros.com

-- 3_Module_3_The_Awesome_Foursome_CPU_Memory_IO_Tempdb
--- 3_4_Tempdb_Troubleshooting
---- 2_Tempdb_Allocations_Monitoring
----- 1_Tempdb_Allocations.sql

select top 10
t1.session_id,
t1.request_id,
t1.task_alloc,
     t1.task_dealloc, 
    (SELECT SUBSTRING(text, t2.statement_start_offset/2 + 1,
          (CASE WHEN statement_end_offset = -1
              THEN LEN(CONVERT(nvarchar(max),text)) * 2
                   ELSE statement_end_offset
              END - t2.statement_start_offset)/2)
     FROM sys.dm_exec_sql_text(sql_handle)) AS query_text,
 (SELECT query_plan from sys.dm_exec_query_plan(t2.plan_handle)) as query_plan
 
from      (Select session_id, request_id,
sum(internal_objects_alloc_page_count +   user_objects_alloc_page_count) as task_alloc,
sum (internal_objects_dealloc_page_count + user_objects_dealloc_page_count) as task_dealloc
       from sys.dm_db_task_space_usage
       group by session_id, request_id) as t1,
       sys.dm_exec_requests as t2
where t1.session_id = t2.session_id and
(t1.request_id = t2.request_id) and
      t1.session_id > 50
order by t1.task_alloc DESC


-- Thank you :)
-- SQL Server Performance Tuning Fast Track Video Course
-- https://www.SQLMaestros.com
