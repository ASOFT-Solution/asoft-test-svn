use [CDT]

declare @sysTableID int

select @sysTableID = sysTableID from sysTable
where TableName = 'MT33'

Update sysField set Formula = N'sum(@ThueNT)'
where sysTableID = @sysTableID and FieldName = 'TthueNT' and Formula = N'-sum(@ThueNT)'

Update sysField set Formula = N'Sum(@Thue)'
where sysTableID = @sysTableID and FieldName = 'Tthue' and Formula = N'-Sum(@Thue)'

select @sysTableID = sysTableID from sysTable
where TableName = 'MT24'

Update sysField set Formula = N'sum(@ThueNT)'
where sysTableID = @sysTableID and FieldName = 'TthueNT' and Formula = N'-sum(@ThueNT)'

Update sysField set Formula = N'Sum(@Thue)'
where sysTableID = @sysTableID and FieldName = 'Tthue' and Formula = N'-Sum(@Thue)'