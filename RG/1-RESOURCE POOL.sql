USE [master]
GO

CREATE RESOURCE POOL [TEST] WITH(min_cpu_percent=0, 
		max_cpu_percent=10, 
		min_memory_percent=0, 
		max_memory_percent=25, 
		cap_cpu_percent=100, 
		AFFINITY SCHEDULER = AUTO, 
		min_iops_per_volume=0, 
		max_iops_per_volume=0)
GO