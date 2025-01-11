select * from sys.sysprocesses where cmd like 'LAZY WRITER' or cmd like '%Ghost%' or cmd like 'RESOURCE MONITOR'

--Lazy Writer thread >>>>>>> Check if any memory pressure on the server 
--Resource Monitor thread >> Check if any memory pressure on the server
--Ghost cleanup thread >>>>> Check if the user deleted large number of rows
--========================================================================================
-- traces running on the server
select * from sys.traces