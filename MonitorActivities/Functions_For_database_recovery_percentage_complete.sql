USE [master]
GO
declare @sql varchar(max), @drop varchar(500), @replace bit = 0

-----------------------------------------------------------------------------------------------------------

set @sql = 'CREATE OR ALTER Function [dbo].[numberSize]
(@number numeric(20,2), @type varchar(1))
returns varchar(100)
as
begin
declare @return varchar(100), @B numeric, @K numeric, @M numeric, @G numeric, @T numeric, @bb float
set @b  = 1024
set @k  = 1048576
set @m  = 1073741824
set @g  = 1099511627776
set @t  = 1125899906842624
set @bb = 1152921504606846976

if @type = ''B''
begin
select @return = 
case when @number < 0 then 
case 
when ABS(@number) between    0 and @B  then cast(round(cast(@number as float)/1,2) as varchar)+'' Bytes''
when ABS(@number) between @b+0 and @K  then cast(round(cast(@number as float)/1024,2) as varchar)+'' KB''
when ABS(@number) between @k+0 and @M  then cast(round(cast(@number as float)/1024/1024,2) as varchar)+'' MB''
when ABS(@number) between @m+0 and @G  then cast(round(cast(@number as float)/1024/1024/1024,2) as varchar)+'' GB''
when ABS(@number) between @g+0 and @T  then cast(round(cast(@number as float)/1024/1024/1024/1024,2) as varchar)+'' TB''
when ABS(@number) between @T+0 and @bb then cast(round(cast(@number as float)/1024/1024/1024/1024/1024,2) as varchar)+'' BB''
end
else
case 
when @number between    0 and @B  then cast(round(cast(@number as float)/1,2) as varchar)+'' Bytes''
when @number between @b+0 and @K  then cast(round(cast(@number as float)/1024,2) as varchar)+'' KB''
when @number between @k+0 and @M  then cast(round(cast(@number as float)/1024/1024,2) as varchar)+'' MB''
when @number between @m+0 and @G  then cast(round(cast(@number as float)/1024/1024/1024,2) as varchar)+'' GB''
when @number between @g+0 and @T  then cast(round(cast(@number as float)/1024/1024/1024/1024,2) as varchar)+'' TB''
when @number between @T+0 and @bb then cast(round(cast(@number as float)/1024/1024/1024/1024/1024,2) as varchar)+'' BB''
end
end
end

else if @type = ''K''
begin
select @return = 
case when @number < 0 then 
case 
when ABS(@number) between    0 and @B then cast(round(cast(@number as float)/1,2) as varchar)+'' KB''
when ABS(@number) between @b+0 and @K then cast(round(cast(@number as float)/1024,2) as varchar)+'' MB''
when ABS(@number) between @k+0 and @M then cast(round(cast(@number as float)/1024/1024,2) as varchar)+'' GB''
when ABS(@number) between @m+0 and @G then cast(round(cast(@number as float)/1024/1024/1024,2) as varchar)+'' TB''
when ABS(@number) between @G+0 and @T then cast(round(cast(@number as float)/1024/1024/1024/1024,2) as varchar)+'' BB''
end
else
case 
when @number between    0 and @B then cast(round(cast(@number as float)/1,2) as varchar)+'' KB''
when @number between @b+0 and @K then cast(round(cast(@number as float)/1024,2) as varchar)+'' MB''
when @number between @k+0 and @M then cast(round(cast(@number as float)/1024/1024,2) as varchar)+'' GB''
when @number between @m+0 and @G then cast(round(cast(@number as float)/1024/1024/1024,2) as varchar)+'' TB''
when @number between @G+0 and @T then cast(round(cast(@number as float)/1024/1024/1024/1024,2) as varchar)+'' BB''
end
end
end

else if @type = ''M''
begin
select @return = 
case when @number < 0 then 
case 
when ABS(@number) between    0 and @B then cast(round(cast(@number as float)/1,2) as varchar)+'' MB''
when ABS(@number) between @b+0 and @K then cast(round(cast(@number as float)/1024,2) as varchar)+'' GB''
when ABS(@number) between @k+0 and @M then cast(round(cast(@number as float)/1024/1024,2) as varchar)+'' TB''
when ABS(@number) between @M+0 and @G then cast(round(cast(@number as float)/1024/1024/1024,2) as varchar)+'' BB''
end
else
case 
when @number between    0 and @B then cast(round(cast(@number as float)/1,2) as varchar)+'' MB''
when @number between @b+0 and @K then cast(round(cast(@number as float)/1024,2) as varchar)+'' GB''
when @number between @k+0 and @M then cast(round(cast(@number as float)/1024/1024,2) as varchar)+'' TB''
when @number between @M+0 and @G then cast(round(cast(@number as float)/1024/1024/1024,2) as varchar)+'' BB''
end
end
end

else if @type = ''G''
begin
select @return = 
case when @number < 0 then 
case 
when ABS(@number)  between    0 and @B then cast(round(cast(@number as float)/1,2) as varchar)+'' GB''
when ABS(@number)  between @b+0 and @K then cast(round(cast(@number as float)/1024,2) as varchar)+'' TB''
when ABS(@number)  between @k+0 and @M then cast(round(cast(@number as float)/1024/1024,2) as varchar)+'' BB''
end
else
case 
when @number between    0 and @B then cast(round(cast(@number as float)/1,2) as varchar)+'' GB''
when @number between @b+0 and @K then cast(round(cast(@number as float)/1024,2) as varchar)+'' TB''
when @number between @k+0 and @M then cast(round(cast(@number as float)/1024/1024,2) as varchar)+'' BB''
end
end
end

else if @type = ''T''
begin
select @return = 
case when @number < 0 then 
case 
when ABS(@number) between    0 and @B then cast(round(cast(@number as float)/1,2) as varchar)+'' TB''
when ABS(@number) between @b+0 and @k then cast(round(cast(@number as float)/1024,2) as varchar)+'' BB''
end
else
case 
when @number between    0 and @B then cast(round(cast(@number as float)/1,2) as varchar)+'' TB''
when @number between @b+0 and @k then cast(round(cast(@number as float)/1024,2) as varchar)+'' BB''
end
end
end

return @return
end'

if (select count(*) from sys.objects where object_id = object_id('[dbo].[numberSize]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Scalar-valued	Function [dbo].[numberSize] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[numberSize]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[numberSize]'
	exec(@drop)
	exec(@sql)
	print('Scalar-valued	Function [dbo].[numberSize] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('numberSize') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Scalar-valued	Function [dbo].[numberSize] has created successfully')
end

-----------------------------------------------------------------------------------------------------------

set @sql = 'CREATE OR ALTER Function [dbo].[Format]
(@P_Number decimal(35,6), @P_Round int)
returns varchar(50)
as
begin
declare 
@round int, 
@number varchar(50),
@result varchar(50),
@round_exist int

set @number = @P_Number
set @round = @P_Round

select @round_exist = count(*)
from (
select @number number)a
where number like ''%.%''

if @round_exist > 0
begin
if @round >= 0 
begin
select @result = 
case len(substring(number,1,charindex(''.'',number)-1)) 
when 1  then substring(number,1,charindex(''.'',number)-1)+ case @round when 0 then ''.0'' else ''.''+substring(number,charindex(''.'',number)+1,@round) end 
when 2  then substring(number,1,charindex(''.'',number)-1)+ case @round when 0 then ''.0'' else ''.''+substring(number,charindex(''.'',number)+1,@round) end 
when 3  then substring(number,1,charindex(''.'',number)-1)+ case @round when 0 then ''.0'' else ''.''+substring(number,charindex(''.'',number)+1,@round) end 
when 4  then substring(number,1,1)+'',''+substring(number,2,3) +''.''+substring(number,charindex(''.'',number)+1,case @round when 0 then len(number) else @round end) 
when 5  then substring(number,1,2)+'',''+substring(number,3,3) +''.''+substring(number,charindex(''.'',number)+1,case @round when 0 then len(number) else @round end) 
when 6  then substring(number,1,3)+'',''+substring(number,4,3) +''.''+substring(number,charindex(''.'',number)+1,case @round when 0 then len(number) else @round end)
when 7  then substring(number,1,1)+'',''+substring(number,2,3) +'',''+substring(number,5,3)+''.''+substring(number,charindex(''.'',number)+1,case @round when 0 then len(number) else @round end) 
when 8  then substring(number,1,2)+'',''+substring(number,3,3) +'',''+substring(number,6,3)+''.''+substring(number,charindex(''.'',number)+1,case @round when 0 then len(number) else @round end) 
when 9  then substring(number,1,3)+'',''+substring(number,4,3) +'',''+substring(number,7,3)+''.''+substring(number,charindex(''.'',number)+1,case @round when 0 then len(number) else @round end) 
when 10 then substring(number,1,1)+'',''+substring(number,2,3) +'',''+substring(number,5,3)+'',''+substring(number,8,3)+''.''+substring(number,charindex(''.'',number)+1,case @round when 0 then len(number) else @round end) 
when 11 then substring(number,1,2)+'',''+substring(number,3,3) +'',''+substring(number,6,3)+'',''+substring(number,9,3)+''.''+substring(number,charindex(''.'',number)+1,case @round when 0 then len(number) else @round end) 
when 12 then substring(number,1,3)+'',''+substring(number,4,3) +'',''+substring(number,7,3)+'',''+substring(number,10,3)+''.''+substring(number,charindex(''.'',number)+1,case @round when 0 then len(number) else @round end)
when 13 then substring(number,1,1)+'',''+substring(number,2,3) +'',''+substring(number,5,3)+'',''+substring(number,8,3)+'',''+substring(number,11,3)+''.''+substring(number,charindex(''.'',number)+1,case @round when 0 then len(number) else @round end) end
from (
select @number number)a
end
else
begin
select @result = 
case len(substring(number,1,charindex(''.'',number)-1)) 
when 1 then substring(number,1,charindex(''.'',number)-1)
when 2 then substring(number,1,charindex(''.'',number)-1)
when 3 then substring(number,1,charindex(''.'',number)-1)
when 4 then substring(number,1,1)+'',''+substring(number,2,3) 
when 5 then substring(number,1,2)+'',''+substring(number,3,3)
when 6 then substring(number,1,3)+'',''+substring(number,4,3)
when 7 then substring(number,1,1)+'',''+substring(number,2,3)+'',''+substring(number,5,3) 
when 8  then substring(number,1,2)+'',''+substring(number,3,3)+'',''+substring(number,6,3)
when 9  then substring(number,1,3)+'',''+substring(number,4,3)+'',''+substring(number,7,3)
when 10 then substring(number,1,1)+'',''+substring(number,2,3)+'',''+substring(number,5,3)+'',''+substring(number,8,3)
when 11 then substring(number,1,2)+'',''+substring(number,3,3)+'',''+substring(number,6,3)+'',''+substring(number,9,3)
when 12 then substring(number,1,3)+'',''+substring(number,4,3)+'',''+substring(number,7,3)+'',''+substring(number,10,3)
when 13 then substring(number,1,1)+'',''+substring(number,2,3)+'',''+substring(number,5,3)+'',''+substring(number,8,3)+'',''+substring(number,11,3) end
from (
select @number number)a
end
end
else
begin
select @result = 
case len(substring(number,1,charindex(''.'',number)-1)) 
when 1 then substring(number,1,charindex(''.'',number)-1)
when 2 then substring(number,1,charindex(''.'',number)-1)
when 3 then substring(number,1,charindex(''.'',number)-1)
when 4 then substring(number,1,1)+'',''+substring(number,2,3) 
when 5 then substring(number,1,2)+'',''+substring(number,3,3)
when 6 then substring(number,1,3)+'',''+substring(number,4,3)
when 7 then substring(number,1,1)+'',''+substring(number,2,3)+'',''+substring(number,5,3) 
when 8  then substring(number,1,2)+'',''+substring(number,3,3)+'',''+substring(number,6,3)
when 9  then substring(number,1,3)+'',''+substring(number,4,3)+'',''+substring(number,7,3)
when 10 then substring(number,1,1)+'',''+substring(number,2,3)+'',''+substring(number,5,3)+'',''+substring(number,8,3)
when 11 then substring(number,1,2)+'',''+substring(number,3,3)+'',''+substring(number,6,3)+'',''+substring(number,9,3)
when 12 then substring(number,1,3)+'',''+substring(number,4,3)+'',''+substring(number,7,3)+'',''+substring(number,10,3)
when 13 then substring(number,1,1)+'',''+substring(number,2,3)+'',''+substring(number,5,3)+'',''+substring(number,8,3)+'',''+substring(number,11,3) end
from (
select @number number)a
end

return @result 
end'
if (select count(*) from sys.objects where object_id = object_id('dbo.Format') and schema_id = 1) > 0 and @replace = 0
begin
	print('Scalar-valued	Function [dbo].[Format] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('dbo.Format') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[Format]'
	exec(@drop)
	exec(@sql)
	print('Scalar-valued	Function [dbo].[Format] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[Format]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Scalar-valued	Function [dbo].[Format] has created successfully')
end

-----------------------------------------------------------------------------------------------------------

set	@sql = 'CREATE OR ALTER Function [dbo].[Separator]
(@str nvarchar(max), @sepr nvarchar(100))
returns @table table (id int identity(1,1), [value] nvarchar(max))
as
begin
declare 
@word   nvarchar(max), 
@len    int, 
@s_ind  int, 
@f_ind  int,
@loop   int = 0

set @len  = LEN(@str)
set @f_ind = 1

while @f_ind > 0
begin
set @f_ind = case when charindex(@sepr,@str)-1 < 0 then 0 else charindex(@sepr,@str)-1 end
set @s_ind = charindex(@sepr,@str) + len(@sepr)
set @len   = len(@str)
set @word  = case when substring(@str , 1, @f_ind) = '''' then @str else substring(@str , 1, @f_ind) end
if len(@sepr) > 1
begin
	set @word  = case when @loop = 0 then @word else substring(@word, len(@sepr) , len(@word)) end
end
set @str   = substring(@str , @s_ind- len(@sepr)+1, len(@str))
insert into @table 
select @word
set @loop =+1
end

return
end'

if (select count(*) from sys.objects where object_id = object_id('[dbo].[Separator]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Table-valued	Function [dbo].[Separator] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[Separator]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[Separator]'
	exec(@drop)
	exec(@sql)
	print('Table-valued	Function [dbo].[Separator] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[Separator]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Table-valued	Function [dbo].[Separator] has created successfully')
end

-----------------------------------------------------------------------------------------------------------

set @sql = 'CREATE OR ALTER Function [dbo].[vertical_array]
(@string nvarchar(max), @sep nvarchar(5), @position int)
returns nvarchar(max)
as
begin

declare @result nvarchar(max), @loop int = 0, @len int = 1, @inserted int = 0
while @inserted < @position
begin
select @len = charindex(@sep,substring(@string,case when @loop = 0 then 1 else @loop + 1 end,len(@string)))
select @result = substring(@string, @loop + 1, case @len when 0 then len(@string) else @len - 1 end)
set @loop = @loop + @len
set @inserted = @inserted + 1
end

return @result
end'
if (select count(*) from sys.objects where object_id = object_id('[dbo].[vertical_array]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Scalar-valued	Function [dbo].[vertical_array] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[vertical_array]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[vertical_array]'
	exec(@drop)
	exec(@sql)
	print('Scalar-valued	Function [dbo].[vertical_array] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[vertical_array]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Scalar-valued	Function [dbo].[vertical_array] has created successfully')
end

-----------------------------------------------------------------------------------------------------------

set @sql = 'CREATE OR ALTER Function [dbo].[gBulk](@row_number int, @number_expression float)
returns int
as
begin
return CEILING(@row_number / (@number_expression * 1.000000001))
end'

if (select count(*) from sys.objects where object_id = object_id('[dbo].[gBulk]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Scalar-valued	Function [dbo].[gBulk] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[gBulk]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[gBulk]'
	exec(@drop)
	exec(@sql)
	print('Scalar-valued	Function [dbo].[gBulk] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[gBulk]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Scalar-value Function [dbo].[gBulk] has created successfully')
end

-----------------------------------------------------------------------------------------------------------

set @sql = 'CREATE OR ALTER Function [dbo].[freq_interval] 
(@interval int)
returns @bit_map_result table (bit_value int, flag int)
as
begin
declare 
@bit_value int, 
@flag int,
@bit int = 0

declare @bit_map table (id int, bit_value int)
insert into @bit_map values (1,1),(2,2),(3,4),(4,8),(5,16),(6,32),(7,64)
declare int_cursor cursor fast_forward
for
select bit_value
from @bit_map
where bit_value <= @interval
order by id desc

open int_cursor
fetch next from int_cursor into @bit_value
while @@FETCH_STATUS = 0
begin

set @flag = case when @bit + @bit_value <= @interval then 1 else 0 end
set @bit = case when @bit + @bit_value <= @interval and @flag = 1 then @bit + @bit_value else @bit end

insert into @bit_map_result 
select @bit_value, @flag 

fetch next from int_cursor into @bit_value
end
close int_cursor
deallocate int_cursor

return
end'

if (select count(*) from sys.objects where object_id = object_id('[dbo].[freq_interval]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Table-valued	Function [dbo].[freq_interval] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[freq_interval]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[freq_interval]'
	exec(@drop)
	exec(@sql)
	print('Table-valued	Function [dbo].[freq_interval] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[freq_interval]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Table-valued	Function [dbo].[freq_interval] has created successfully')
end

-----------------------------------------------------------------------------------------------------------

set @sql = 'CREATE OR ALTER Function [dbo].[day_interval]
(@interval int)
returns varchar(200)
as 
begin
declare @days varchar(200)

select @days = isnull(@days+'', '','''')+ case bit_value 
when 1  then ''Sunday''
when 2  then ''Monday''
when 4  then ''Tuesday''
when 8  then ''Wednesday''
when 16 then ''Thursday''
when 32 then ''Friday''
when 64 then ''Saturday''
end
from master.dbo.freq_interval(95)
where flag = 1
order by bit_value

return @days

end'

if (select count(*) from sys.objects where object_id = object_id('[dbo].[day_interval]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Scalar-valued	Function [dbo].[day_interval] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[day_interval]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[day_interval]'
	exec(@drop)
	exec(@sql)
	print('Scalar-valued	Function [dbo].[day_interval] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[day_interval]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Scalar-valued	Function [dbo].[day_interval] has created successfully')
end

-----------------------------------------------------------------------------------------------------------

set @sql = 'CREATE OR ALTER Function [dbo].[virtical_array]
(@string varchar(max), @sep varchar(5), @position int)
returns varchar(max)
as
begin

declare @result varchar(max), @loop int = 0, @len int = 1, @inserted int = 0
while @inserted < @position
begin
select @len = charindex(@sep,substring(@string,case when @loop = 0 then 1 else @loop + 1 end,len(@string)))
select @result = substring(@string, @loop + 1, case @len when 0 then len(@string) else @len - 1 end)
set @loop = @loop + @len
set @inserted = @inserted + 1
end

return @result
end'
if (select count(*) from sys.objects where object_id = object_id('[dbo].[virtical_array]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Scalar-valued	Function [dbo].[virtical_array] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[virtical_array]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[virtical_array]'
	exec(@drop)
	exec(@sql)
	print('Scalar-valued	Function [dbo].[virtical_array] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[virtical_array]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Scalar-valued	Function [dbo].[virtical_array] has created successfully')
end

-----------------------------------------------------------------------------------------------------------

set @sql = 'CREATE OR ALTER Function [dbo].[Win_Version] (@type int)
returns varchar(255)
as
begin
declare @result varchar(255)
select @result = case 
when @type = 0 then win_version 
when @type = 1 then master.dbo.vertical_array(win_version,'' '',3) end
from (
select case win_version
when ''Windows NT 6.0'' then ''Windows Server 2008''
when ''Windows NT 6.1'' then ''Windows Server 2008 R2''
when ''Windows NT 6.2'' then ''Windows Server 2012''
when ''Windows NT 6.3'' then ''Windows Server 2012 R2''
else win_version end win_version
from (
select 
ltrim(rtrim(substring(@@version , charindex('' on '',@@version) + len('' on ''), charindex(''<'', @@version) - charindex('' on '',@@version) - len('' on '')))) win_version)a)b

return @result
end
'
if (select count(*) from sys.objects where object_id = object_id('[dbo].[Win_Version]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Scalar-valued Function [dbo].[Win_Version] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[Win_Version]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[Win_Version]'
	exec(@drop)
	exec(@sql)
	print('Scalar-valued Function [dbo].[Win_Version] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[Win_Version]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Scalar-valued Function [dbo].[Win_Version] has created successfully')
end

-----------------------------------------------------------------------------------------------------------

set @sql = 'CREATE OR ALTER Function [dbo].[duration]
(@type varchar(5) = ''s'', @number float)
returns varchar(50)
as
begin
declare @duration varchar(50)
if @type = ''ms''
begin
select @duration = 
cast(day(convert(varchar(30), dateadd(ms, @number, ''2000-01-01''), 121)) - 1 as varchar)+''d ''+
[dbo].vertical_array(convert(varchar(10), dateadd(ms, @number, ''2000-01-01''), 108),'':'',1)+''h:''+
[dbo].vertical_array(convert(varchar(10), dateadd(ms, @number, ''2000-01-01''), 108),'':'',2)+''m:''+
case len(cast(cast(((@number / 1000.0 / (60.0)) - cast((@number / 1000.0 / (60.0)) as int)) * (60) as int)as varchar(10))) 
when 1 then ''0''+cast(cast(((@number / 1000.0 / (60.0)) - cast((@number / 1000.0 / (60.0)) as int)) * (60) as int)as varchar(10))
when 2 then +cast(cast(((@number / 1000.0 / (60.0)) - cast((@number / 1000.0 / (60.0)) as int)) * (60) as int)as varchar(10))
end+''s.''+ 
case len(cast(cast(1000 * ((((@number / 1000.0 / (60.0)) - cast((@number / 1000.0 / (60.0)) as int)) * (60)) - cast(((@number / 1000.0 / (60.0)) - cast((@number / 1000.0 / (60.0)) as int)) * (60) as int)) as int)as varchar(10)))
when 1 then ''00''+cast(cast(1000 * ((((@number / 1000.0 / (60.0)) - cast((@number / 1000.0 / (60.0)) as int)) * (60)) - cast(((@number / 1000.0 / (60.0)) - cast((@number / 1000.0 / (60.0)) as int)) * (60) as int)) as int)as varchar(10))
when 2 then ''0''+cast(cast(1000 * ((((@number / 1000.0 / (60.0)) - cast((@number / 1000.0 / (60.0)) as int)) * (60)) - cast(((@number / 1000.0 / (60.0)) - cast((@number / 1000.0 / (60.0)) as int)) * (60) as int)) as int)as varchar(10))
when 3 then cast(cast(1000 * ((((@number / 1000.0 / (60.0)) - cast((@number / 1000.0 / (60.0)) as int)) * (60)) - cast(((@number / 1000.0 / (60.0)) - cast((@number / 1000.0 / (60.0)) as int)) * (60) as int)) as int)as varchar(10))
end+''ms''
end
else if @type = ''s''
begin
select @duration = 
cast(day(convert(varchar(30), dateadd(s, @number, ''2000-01-01''), 121)) - 1 as varchar)+''d ''+
[dbo].vertical_array(convert(varchar(10), dateadd(s, @number, ''2000-01-01''), 108),'':'',1)+''h:''+
[dbo].vertical_array(convert(varchar(10), dateadd(s, @number, ''2000-01-01''), 108),'':'',2)+''m:''+
[dbo].vertical_array(convert(varchar(10), dateadd(s, @number, ''2000-01-01''), 108),'':'',3)+''s''
end

return @duration
end'
if (select count(*) from sys.objects where object_id = object_id('[dbo].[duration]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Scalar-valued Function [dbo].[duration] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[duration]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[duration]'
	exec(@drop)
	exec(@sql)
	print('Scalar-valued Function [dbo].[duration] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[duration]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Scalar-valued Function [dbo].[duration] has created successfully')
end

-----------------------------------------------------------------------------------------------------------

set @sql = 'CREATE OR ALTER Function [dbo].[fn_oneline]
(
@text				varchar(max), 
@separator			varchar(10), 
@one_line			bit,
@with_square		int,
@with_brackets		int,
@with_text_before	int,
@text_before		varchar(max)
)
returns @table table ([value] varchar(max))
as
begin

declare @result varchar(max)
select @result = isnull(@result+@separator,'''') + case 
when @with_square + @with_brackets + @with_text_before = 1 then ''['' + value + '']'' 
when @with_square + @with_brackets + @with_text_before = 2 then ''('' + value + '')'' 
when @with_square + @with_brackets + @with_text_before = 4 then @text_before + value  
when @with_square + @with_brackets + @with_text_before = 5 then @text_before + ''['' + value + '']''
when @with_square + @with_brackets + @with_text_before = 6 then @text_before + ''('' + value + '')''
else value end
from master.dbo.Separator(@text,(select CHAR(10)))
order by id

set @result = replace(replace(replace(convert(varbinary(max), @result),0x0D,0x20),'' ]'','']''),'' )'','')'')

if @one_line = 1
begin
insert into @table select @result
end
else
begin
insert into @table
select ltrim(rtrim(value))
from master.dbo.Separator(@result,@separator)
order by id
end

return

end'
if (select count(*) from sys.objects where object_id = object_id('[dbo].[fn_oneline]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Table-valued	Function [dbo].[fn_oneline] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[fn_oneline]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[fn_oneline]'
	exec(@drop)
	exec(@sql)
	print('Table-valued	Function [dbo].[fn_oneline] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[fn_oneline]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Table-valued	Function [dbo].[fn_oneline] has created successfully')
end
-----------------------------------------------------------------------------------------------------------

set @sql = 'CREATE OR ALTER Function [dbo].[ToNumberSize](@number varchar(20))
returns float
as
begin
declare @size float, @type varchar(10), @bignumber float

select 
@size = substring(@number,1,charindex('' '',@number)-1),
@type = substring(@number,charindex('' '',@number)+1,len(@number))

select @bignumber = @size * case @type 
when ''Byte'' then 1.0
when ''KB''   then power(1024.0,1)
when ''MB''   then power(1024.0,2)
when ''GB''   then power(1024.0,3)
when ''TB''   then power(1024.0,4)
end

return @bignumber
end'
if (select count(*) from sys.objects where object_id = object_id('[dbo].[ToNumberSize]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Scalar-valued	Function [dbo].[ToNumberSize] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[ToNumberSize]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[ToNumberSize]'
	exec(@drop)
	exec(@sql)
	print('Scalar-valued Function [dbo].[ToNumberSize] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[ToNumberSize]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Scalar-valued Function [dbo].[ToNumberSize] has created successfully')
end
-----------------------------------------------------------------------------------------------------------

set @sql = 'create OR ALTER function [dbo].[time_to_complete]
(@current float, @target float, @start_time datetime)
returns varchar(50)
as
begin
declare @percent_complete float, @time_to_complete varchar(50)
select @percent_complete = (@current / (@target + .00001)) * 100.0
select @time_to_complete = 
dbo.duration(''s'',
case when @percent_complete = 0 then 0 else case when 
cast((100.0 / (round(@percent_complete,15) + .00001)) 
* 
datediff(s, @start_time, getdate()) as int)
-
datediff(s, @start_time, getdate())
< 0 then 0 else
cast((100.0 / (round(@percent_complete,15) + .00001)) 
* 
datediff(s, @start_time, getdate()) as int)
-
datediff(s, @start_time, getdate())
end end
) 

return @time_to_complete
end'
if (select count(*) from sys.objects where object_id = object_id('[dbo].[time_to_complete]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Scalar-valued Function [dbo].[time_to_complete] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[time_to_complete]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[time_to_complete]'
	exec(@drop)
	exec(@sql)
	print('Scalar-valued Function [dbo].[time_to_complete] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[time_to_complete]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Scalar-valued Function [dbo].[time_to_complete] has created successfully')
end
-----------------------------------------------------------------------------------------------------------

set @sql = 'CREATE OR ALTER Function [dbo].[time_to_complete_pct]
(@percent_complete float, @start_time datetime)
returns varchar(50)
as
begin
declare @time_to_complete varchar(50)
select @time_to_complete = 
dbo.duration(''s'',
case when @percent_complete = 0 then 0 else case when 
cast((100.0 / (round(@percent_complete,15) + .00001)) 
* 
datediff(s, @start_time, getdate()) as int)
-
datediff(s, @start_time, getdate())
< 0 then 0 else
cast((100.0 / (round(@percent_complete,15) + .00001)) 
* 
datediff(s, @start_time, getdate()) as int)
-
datediff(s, @start_time, getdate())
end end
) 

return @time_to_complete
end'
if (select count(*) from sys.objects where object_id = object_id('[dbo].[time_to_complete_pct]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Scalar-valued Function [dbo].[time_to_complete_pct] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[time_to_complete_pct]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[time_to_complete_pct]'
	exec(@drop)
	exec(@sql)
	print('Scalar-valued Function [dbo].[time_to_complete_pct] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[time_to_complete_pct]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Scalar-valued	Function [dbo].[time_to_complete_pct] has created successfully')
end
-----------------------------------------------------------------------------------------------------------

set @sql = 'CREATE OR ALTER Function [dbo].[date_yyyymmddhhmiss]
(@unformatted_date varchar(20))
returns varchar(30)
as
begin
declare @date varchar(30)
select @date = convert(varchar(10),convert(datetime,left(@unformatted_date, 8), 111),120)+'' ''+
substring(right(@unformatted_date, 6),1,2)+'':''+
substring(right(@unformatted_date, 6),3,2)+'':''+
substring(right(@unformatted_date, 6),5,2)

return @date
end'

if (select count(*) from sys.objects where object_id = object_id('[dbo].[date_yyyymmddhhmiss]') and schema_id = 1) > 0 and @replace = 0
begin
	print('Scalar-valued Function [dbo].[date_yyyymmddhhmiss] already exists')
end
else 
if (select count(*) from sys.objects where object_id = object_id('[dbo].[date_yyyymmddhhmiss]') and schema_id = 1) > 0 and @replace = 1
begin
	set @drop = 'DROP Function [dbo].[date_yyyymmddhhmiss]'
	exec(@drop)
	exec(@sql)
	print('Scalar-valued Function [dbo].[date_yyyymmddhhmiss] has created successfully')
end
else
if (select count(*) from sys.objects where object_id = object_id('[dbo].[date_yyyymmddhhmiss]') and schema_id = 1) = 0 and @replace = 0
begin
	exec(@sql)
	print('Scalar-valued Function [dbo].[date_yyyymmddhhmiss] has created successfully')
END