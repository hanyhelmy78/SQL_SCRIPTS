
select  Has_Perms_By_Name(N'dbo.HIS_ReturnDetail', 'Object', 'ALTER') as ALT_Per, 
	    Has_Perms_By_Name(N'dbo.HIS_ReturnDetail', 'Object', 'VIEW DEFINITION') as View_def_Per, 
		Has_Perms_By_Name(N'dbo.HIS_ReturnDetail', 'Object', 'CONTROL') as Contr_Per 