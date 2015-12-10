use [CDT]

declare @sysTableMVatID as int
select @sysTableMVatID = sysTableID from sysTable where TableName = 'MVATIn' and sysPackageID = 8

update sysField 
set EditMask = N'##'
where FieldName = 'KyBKMV' 
and sysTableID = @sysTableMVatID

update sysField 
set MaxValue = 9999,
MinValue = 1900,
DefaultValue = NULL
where FieldName = 'NamBKMV' 
and sysTableID = @sysTableMVatID