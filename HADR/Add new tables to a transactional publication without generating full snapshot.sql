USE <DB_NAME> -- Put your puplisher database name here
GO
EXEC sp_helppublication <publication_name> -- Put your publication database name here
GO
--************ STOP the Log Reader Agent First <<-- *************************

EXEC sp_changepublication
@publication = '<publication_name>',
@property = N'allow_anonymous',
@value = 'false'
GO
EXEC sp_changepublication
@publication = '<publication_name>',
@property = N'immediate_sync',
@value = 'false'
GO

EXEC sp_addarticle 
      @publication = <publication_name>, 
      @article = <New_Table_Name>, -- Put your New Table name here
      @source_object = <New_Table_Name>,
      @force_invalidate_snapshot=1
GO

EXEC sp_refreshsubscriptions @publication = N'<publication_name>'
GO
-- START Snapshot Agent Using Replication Monitor *********************

--************ START the Log Reader Agent <-- *************************

EXEC sp_changepublication
@publication = N'<publication_name>',
@property = N'immediate_sync',
@value = 'TRUE'
GO
EXEC sp_changepublication
@publication = N'<publication_name>',
@property = N'allow_anonymous',
@value = 'TRUE'
GO

EXEC sp_helppublication <publication_name>

/* How to remove a table from existing replication 
EXEC sp_droparticle 
	 @publication = <publication_name>, 
	 @article = <New_Table_Name>,
	 @force_invalidate_snapshot = 1; 
*/