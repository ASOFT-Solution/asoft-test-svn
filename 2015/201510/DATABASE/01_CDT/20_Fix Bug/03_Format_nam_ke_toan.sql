use [CDT]

declare @sysTableMVatID as int
select @sysTableMVatID = sysTableID from sysTable where TableName = 'MVATIn' and sysPackageID = 8

if exists (select top 1 1 from sysField where FieldName = 'NamBKMV' and sysTableID = @sysTableMVatID)
UPDATE [sysField] set [EditMask] = '####' where FieldName = 'NamBKMV' and sysTableID = @sysTableMVatID