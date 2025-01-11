Select  name,
		page_verify_option,
		page_verify_option_desc
From sys.databases
order by name

--Select DATABASEPROPERTYEX('HISGENX','IsTornPageDetectionEnabled');