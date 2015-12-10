use [CDT]

declare @sysTableID int

-- MT36
select @sysTableID = sysTableID from sysTable where TableName = N'MT36'
update sysField set DefaultValue = 'CTT' where sysTableID = @sysTableID and FieldName = N'MaCt' and isnull(DefaultValue, '') <> 'CTT'
