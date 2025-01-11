USE [master]
GO

CREATE WORKLOAD GROUP [TEST] WITH(group_max_requests=0, 
		importance=Low, 
		request_max_cpu_time_sec=0, 
		request_max_memory_grant_percent=30, 
		request_memory_grant_timeout_sec=0, 
		max_dop=1) USING [TEST]
GO