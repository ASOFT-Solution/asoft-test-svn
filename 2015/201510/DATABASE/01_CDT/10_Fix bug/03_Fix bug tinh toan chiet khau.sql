use [CDT]
declare @sysTableID as varchar(50)

-- Tong chiet khau
select @sysTableID = sysTableID from sysTable 
where TableName = 'MT32'

Update sysField set Formula = 'Sum(@CKNT)'
where sysTableID = @sysTableID
and FieldName = 'TCKNT'


-- Chiet khau chi tiet
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT32'

Update sysField set Formula = NULL
where sysTableID = @sysTableID
and FieldName = 'CK'

select * from sysField
where sysTableID = @sysTableID
and FieldName = 'CK'