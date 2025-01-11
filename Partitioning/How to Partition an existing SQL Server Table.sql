/* How to Partition an existing SQL Server Table: http://www.mssqltips.com/sqlservertip/2888/how-to-partition-an-existing-sql-server-table/

Since we are going to partition the table using a clustered index and our table already has a clustered index defined;
then we'll need to drop this clustered index first and recreate the constraint using a non-clustered index.

BUT THE PROBLEM HERE IS THAT ALL OUR CLUSTERED INDEXES ARE PRIMARY KEYS WHICH BEING REFERENCED BY TOO MANY OTHER TABLES AS FOREIGN KEYS CONSTRAINTS, 
MEANING WE NEED TO DROP ALL THOSE DEPENDENT KEYS FIRST BEFORE WE CAN DROP THE PK CLUSTERED INDEX WHICH IS ALMOST IMPOSSIBLE.

THE OTHER WAY IS TO CREATE A NEW EMPTY PARTIOTINED TABLE, THEN INSERT THE DATA FROM THE EXISTING TABLE TO THE NEW ONE AND DO A TABLE RENAME.

if you are concerned about the downtime required to perform this task and you are using SQL Server Enterprise Edition;
you could use the ONLINE=ON option of the CREATE INDEX statement to minimize any downtime for your application. 
Keep in mind that you may see some performance degradation while the index is being rebuilt using the ONLINE option.
*/

ALTER TABLE Movement_Details DROP CONSTRAINT PK_Movement_Details_1
GO

ALTER TABLE Movement_Details ADD CONSTRAINT PK_Movement_Details_1 PRIMARY KEY NONCLUSTERED (
	[Line_ID] ASC,
	[Movement_Code] ASC
)
WITH (STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, IGNORE_DUP_KEY = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO

CREATE CLUSTERED INDEX Indx_Movement_Details_Stamp_Date ON Movement_Details(Stamp_Date) -- The Date Column
WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, DATA_COMPRESSION = PAGE) 
ON PartSc_Date(Stamp_Date)
GO