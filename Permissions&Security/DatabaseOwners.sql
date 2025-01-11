select suser_sname(owner_sid) as 'Owner', state_desc, * from sys.databases
--sp_helpdb