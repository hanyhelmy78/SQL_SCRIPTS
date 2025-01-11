SELECT * FROM sys.fn_get_audit_file ('c:\audit\*.sqlaudit',default,default);

SELECT action_id, 
    count(*) COUNT
FROM sys.fn_get_audit_file ('c:\audit\*.sqlaudit',default,default)
group by action_id;