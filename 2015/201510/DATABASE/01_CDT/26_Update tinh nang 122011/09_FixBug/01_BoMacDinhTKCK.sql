use [CDT]
Declare @sysTableID int

select @sysTableID = sysTableID from sysTable
where TableName = 'MT31'

Update sysField set DefaultValue = NULL
where sysTableID = @sysTableID and FieldName = 'TKCK' and DefaultValue = '521'

select @sysTableID = sysTableID from sysTable
where TableName = 'MT32'

Update sysField set DefaultValue = NULL
where sysTableID = @sysTableID and FieldName = 'TKCK' and DefaultValue = '521'