--Create the partition scheme and function, align this to the number of CPU cores 1:1 up to 32 core computer
-- so for below this is aligned to 4 core system
CREATE PARTITION FUNCTION [pf_hash4] (tinyint) AS RANGE LEFT FOR VALUES (0, 1, 2, 3, 4)

CREATE PARTITION SCHEME [ps_hash4] 
AS PARTITION [pf_hash4] ALL 
TO ([PRIMARY])

-- Add the computed column to the existing table (this is an OFFLINE operation)
-- Consider using bulk loading techniques to speed it up
ALTER TABLE Movement_Details
ADD [HashValue] AS (CONVERT([tinyint], abs(binary_checksum(Movement_Code)%(4)),(0))) PERSISTED NOT NULL
--Create the index on the new partitioning scheme
CREATE UNIQUE CLUSTERED INDEX [Indx_Movement_Code_HashValue]
ON Movement_Details([Line_ID],[Movement_Code] ASC, [HashValue])
ON ps_hash4(HashValue)