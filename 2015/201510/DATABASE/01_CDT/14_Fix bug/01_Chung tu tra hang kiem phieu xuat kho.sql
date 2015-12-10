use [CDT]

declare @sysMTTableID as int 
declare @sysTHTableID as int 
declare @sysWTableID as int 
declare @sysWFieldVTID as int 
declare @sysCTableID as int 
declare @sysCFieldVTID as int 

-- TableID bang Master
select @sysMTTableID = sysTableID from sysTable
where TableName = 'MT24'

-- TableID bang BLVT
select @sysTHTableID = sysTableID from sysTable
where TableName = 'BLVT'

-- TableID bang da map sai fieldID: DT23
select @sysWTableID = sysTableID from sysTable
where TableName = 'DT23'

-- Lay fieldID dang map sai
select @sysWFieldVTID = sysFieldID from sysField where sysTableID = @sysWTableID and FieldName = 'MaVT'

-- TableID bang dung
select @sysCTableID = sysTableID from sysTable
where TableName = 'DT24'

-- Lay fieldID cot MaVT dung
select @sysCFieldVTID = sysFieldID from sysField where sysTableID = @sysCTableID and FieldName = 'MaVT'

Update sysDataConfigDt set dtFieldID = @sysCFieldVTID
where blConfigDetailID = 
(select blConfigDetailID from sysDataConfigDt configdt
inner join sysDataConfig config on configdt.blConfigID = config.blConfigID
where mtTableID = @sysMTTableID and NhomDK = 'PXT1' and sysTableID = @sysTHTableID and dtFieldID = @sysWFieldVTID)