---Genrate Read_Write Script for all databases

Select 'SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
ALTER DATABASE ['+name+'] SET SINGLE_USER WITH NO_WAIT
GO
ALTER DATABASE ['+name+'] SET Read_Write WITH NO_WAIT
GO 
ALTER DATABASE ['+name+']SET MULTI_USER WITH NO_WAIT
GO'
from Sys.Databases where Database_Id > 4 and state_desc = 'ONLINE' AND NAME <> ''
