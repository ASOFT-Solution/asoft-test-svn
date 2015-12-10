use [CDT]

declare @sysTableID int

select @sysTableID = sysTableID from sysTable where TableName = N'MT23'

update sysField set Visible = 0 where sysTableID = @sysTableID and FieldName = N'MaThueNK'

select @sysTableID = sysTableID from sysTable where TableName = N'DT23'

update sysField set FormulaDetail = NULL where sysTableID = @sysTableID and FieldName = N'MaThueNkCt'