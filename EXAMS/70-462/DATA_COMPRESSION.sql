use dental4u
go
create table Aeroplanes (Model varchar(max)) 
with (data_compression = row)

create table Helicopters (Model varchar(max)) 
with (data_compression = page)

DBCC SQLPERF (LOGSPACE)