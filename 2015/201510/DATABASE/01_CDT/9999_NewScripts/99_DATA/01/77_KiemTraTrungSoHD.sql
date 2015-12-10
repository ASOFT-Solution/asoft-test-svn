use [CDT]

declare @sysTable as int

-- Bỏ ràng buộc Duy nhất field SoHoaDon trong MT32

-- Hóa đơn bán hàng
select @sysTable = sysTableID from sysTable where TableName = 'MT32' and sysPackageID = 8

Update sysField set IsUnique = 0
where sysTableID = @sysTable
and FieldName = 'SoHoaDon'
and IsUnique = 1