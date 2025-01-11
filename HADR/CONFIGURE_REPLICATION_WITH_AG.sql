-- STEP 1 RUN IN ALL SEC NODES ********
USE master;  
GO  
EXEC sys.sp_adddistributor  
    @distributor = 'RUH1ISellRABC',  
    @password = 'pepsi-123';
--==========================================
-- STEP 2 RUN IN THE REPORTING SERVER
USE distribution;  
GO  
EXEC sp_redirect_publisher   
@original_publisher = 'ABC-ISELL',  -- ABC-ISELL
@publisher_db = 'ABP_SFA_BMB',  
@redirected_publisher = 'RUH1ABCDB'; -- RUH1ABCDB
--===================================================
-- STEP 3 RUN IN THE REPORTING SERVER
USE distribution;  
GO  
DECLARE @redirected_publisher sysname = 'RUH1ABCDB';  
EXEC sys.sp_validate_replica_hosts_as_publishers  
    @original_publisher = 'ABC-ISELL',  
    @publisher_db = 'ABP_SFA_BMB',  
    @redirected_publisher = @redirected_publisher output;
SELECT @redirected_publisher