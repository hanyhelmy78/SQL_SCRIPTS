declare @Date1 datetime = '2012-08-28 11:53:00',
		@Date2 datetime = '2012-08-29 13:25:00'
		
select  DATEDIFF (DAY, @Date1, @Date2),
		CAST(@Date2 - @Date1 as int),
-- when CASTing DATETIME value to INT datatype, times after 12:00 will be roubded to the next day!		
		CAST(@Date2 as int) - CAST(@Date1 as int),
		CAST(CAST(@Date2 as float) - CAST(@Date1 as float) AS int)		