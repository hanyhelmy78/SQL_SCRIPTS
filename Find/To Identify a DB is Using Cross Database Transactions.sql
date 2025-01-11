-- SELECT 1 FROM fn_dblog(NULL, NULL) WHERE Operation = 'LOP_PREP_XACT' AND [Master XDESID] <> '0000:00000000'

IF EXISTS(SELECT 1 FROM fn_dblog(NULL, NULL) WHERE Operation = 'LOP_PREP_XACT' AND [Master DBID] <> 0)
PRINT 'Based on the active part of the transaction log read, there is evidence that this database has participated in cross-database transactions.'
ELSE
PRINT 'Based on the active part of the transaction log read, there is no evidence of this database having participated in cross-database transactions.'