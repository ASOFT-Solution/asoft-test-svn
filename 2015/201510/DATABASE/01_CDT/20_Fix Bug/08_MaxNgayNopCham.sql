use [CDT]

declare @sysTableID int

-- VATinGTBS
select @sysTableID = sysTableID from sysTable where TableName = N'VATinGTBS'
update sysField set MaxValue = 999999 where sysTableID = @sysTableID and FieldName = N'NopCham' and isnull(MaxValue, 0) <> 999999
