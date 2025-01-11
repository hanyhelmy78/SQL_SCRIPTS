WITH    qry	AS 
( SELECT 
-- Retrieve the database_id from inside the XML document
theNodes.event_data.value
    ('(data[@name="database_id"]/value)[1]','int') 
AS database_id FROM
(SELECT CONVERT(XML, event_data) 
    event_data -- convert the text field to XML
FROM	-- reads the information in the event files
sys.fn_xe_file_target_read_file
   ('c:\BadSplits\badsplits*.xel',NULL, NULL, NULL)
) theData
CROSS APPLY theData.event_data.nodes
   ('//event') theNodes ( event_data ))
SELECT	DB_NAME(database_id) ,COUNT(*) AS total
FROM	qry
GROUP BY DB_NAME(database_id) 
   -- group the result by database
ORDER BY total DESC

-- Once you know the database with the most page splits; you need to identify the objects that are causing the problem.

WITH qry AS
	(SELECT
theNodes.event_data.value
   ('(data[@name="database_id"]/value)[1]','int') 
     AS database_id,
theNodes.event_data.value
   ('(data[@name="alloc_unit_id"]/value)[1]','varchar(30)') 
     AS alloc_unit_id,
theNodes.event_data.value
   ('(data[@name="context"]/text)[1]','varchar(30)') 
     AS context
	FROM 
		(SELECT CONVERT(XML,event_data) event_data
		FROM
	sys.fn_xe_file_target_read_file
		('c:\BadSplits\badsplits*.xel', NULL, NULL, NULL)) theData
   CROSS APPLY theData.event_data.nodes('//event') 
               theNodes(event_data) )
SELECT name,context,COUNT(*) AS total 
  -- The count of splits by objects
FROM qry,sys.allocation_units au, sys.partitions p, sys.objects ob
WHERE qry.alloc_unit_id=au.allocation_unit_id 
  AND au.container_id=p.hobt_id AND p.object_id=ob.object_id
  AND (au.type=1 or au.type=3) AND
	db_name(database_id)='MDW' -- Filter by the database
GROUP BY name,context -- group by object name and context
ORDER BY name

-- Now that we know which table is causing the most page splits, you can analyze its indexes to solve the problem.