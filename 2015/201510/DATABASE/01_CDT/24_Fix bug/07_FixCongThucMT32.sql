use [CDT]
declare @sysTableID as varchar(50)

-- Tong chiet khau
select @sysTableID = sysTableID from sysTable 
where TableName = 'MT32'

Update sysField set Formula = 'Sum(@CK)'
where sysTableID = @sysTableID
and FieldName = 'TCK'