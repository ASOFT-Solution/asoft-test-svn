use [CDT]

declare @sysTableID int

-- DT12
select @sysTableID = sysTableID from sysTable
where TableName = 'DT12'

Update sysField set LabelName = N'Nhà cung cấp', LabelName2 = N'Supplier'
where FieldName = 'MaKHCt'
and sysTableID = @sysTableID and LabelName = N'Khách hàng'

Update sysField set LabelName = N'Tên nhà cung cấp', LabelName2 = N'Name of supplier'
where FieldName = 'TenKHCt'
and sysTableID = @sysTableID and LabelName = N'Tên khách hàng'

-- DT21
select @sysTableID = sysTableID from sysTable
where TableName = 'DT21'

Update sysField set LabelName = N'Nhà cung cấp', LabelName2 = N'Supplier'
where FieldName = 'MaKHCt'
and sysTableID = @sysTableID and LabelName = N'Khách hàng'

Update sysField set LabelName = N'Tên nhà cung cấp', LabelName2 = N'Name of supplier'
where FieldName = 'TenKHCt'
and sysTableID = @sysTableID and LabelName = N'Tên khách hàng'

-- Người lập
declare @sysSiteIDSTD as int

select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

if isnull(@sysSiteIDSTD,'') <> ''
BEGIN
Update sysConfig set DienGiai = N'Người lập'
where sysSiteID = @sysSiteIDSTD and _Key = 'NguoiLap' and DienGiai = N'Huỳnh Trung Dũng'
END

-- Update [Số Seri] -> [Ký hiệu hóa đơn]
Update sysField set LabelName = N'Ký hiệu hóa đơn'
where LabelName = N'Số Seri'
