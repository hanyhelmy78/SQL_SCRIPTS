--look at all data files 
use master
go
SELECT name, state_desc, physical_name, m.is_read_only, size, growth
FROM sys.master_files m
WHERE database_id = db_id('AdventureWorksDW2016')

--Step 1 change the file location to the new disk/location
ALTER DATABASE AdventureWorksDW2016 MODIFY FILE (NAME='AdventureWorksDW2016_Data_05', filename='C:\DataFiles\AdventureWorksDW2016\NEW\AdventureWorksDW2016_Data_05.ndf')

--look again at all data files 
SELECT name, state_desc, physical_name, m.is_read_only, size, growth
FROM sys.master_files m
WHERE database_id = db_id('AdventureWorksDW2016')

--step 2 taking the file in an offile state 
ALTER DATABASE AdventureWorksDW2016 MODIFY FILE (NAME='AdventureWorksDW2016_Data_05', OFFLINE);

--look again at all data files 
SELECT name, state_desc, physical_name, m.is_read_only, size, growth
FROM sys.master_files m
WHERE database_id = db_id('AdventureWorksDW2016')

--step 3 move the files physicaly from the old path to the new one

--step 4 online the file again by restore the file with recovery
RESTORE DATABASE [AdventureWorksDW2016] 
FILE = 'AdventureWorksDW2016_Data_05'
WITH RECOVERY

--look again at all data files 
SELECT name, state_desc, physical_name, m.is_read_only, size, growth
FROM sys.master_files m
WHERE database_id = db_id('AdventureWorksDW2016')