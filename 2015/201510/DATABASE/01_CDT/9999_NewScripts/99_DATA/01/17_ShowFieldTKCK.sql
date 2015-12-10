use [CDT]

declare @sysTableID int

-- MT31
select @sysTableID = sysTableID from sysTable
where TableName = 'MT31'

Update sysField set SmartView = 1
where sysTableID = @sysTableID
and FieldName = 'TKCK' and SmartView = 0

-- MT33
select @sysTableID = sysTableID from sysTable
where TableName = 'MT33'

Update sysField set SmartView = 1
where sysTableID = @sysTableID
and FieldName = 'TKCK' and SmartView = 0