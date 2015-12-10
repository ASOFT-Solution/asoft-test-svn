USE [CDT]

declare @sysTableID int

select @sysTableID = sysTableID from sysTable
where TableName = 'DMVT'

Update sysField set MinValue = 2
where sysTableID = @sysTableID and FieldName = 'Tonkho' and MinValue = 1
