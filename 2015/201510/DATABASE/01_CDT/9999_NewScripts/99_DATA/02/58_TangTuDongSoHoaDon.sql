-- [ACC_CANAVIET] Số hóa đơn ko tự động tăng trong màn hình Hóa đơn dịch vụ
USE [CDT]

declare @sysTableID int,
		@EditMask varchar(50)

select @sysTableID = sysTableID from sysTable
					where TableName = 'MT31'

set @EditMask = '0000001'

Update sysField set EditMask = @EditMask
where sysTableID = @sysTableID
and FieldName = 'SoHoaDon'
and EditMask = N'&'