use ABP_BMB
select STATS_DATE(so.object_id, index_id) StatsDate
, si.name IndexName
, so.Name TableName
, so.object_id, si.index_id
from sys.indexes si
inner join sys.tables so on so.object_id = si.object_id
order by StatsDate desc