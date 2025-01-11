-- MaxTransferSize x BufferCount = Memory needed by restore, if you do not have the needed amount of memory on your server you will get errors!

RESTORE DATABASE [RestoreTest] 
FROM DISK = N'I:\Backup\RestoreTest_one_nc.bak' 
 WITH MAXTRANSFERSIZE = 20971520, -- 20 mb 4194304, -- 4 MB 
	  BUFFERCOUNT = 50, -- INCREASE PERFORMANCE
	  STATS = 5
GO