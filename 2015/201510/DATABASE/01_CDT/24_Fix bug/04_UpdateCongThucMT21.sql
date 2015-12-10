use [CDT]

declare @sysTableID int

-- Hóa đơn dịch vụ
select @sysTableID = sysTableID from sysTable
where TableName = 'MT21'

Update sysField set Formula = N'@TtienH+@Tthue-@TotalCK'
where sysTableID = @sysTableID and fieldName = 'Ttien'

Update sysField set Formula = N'@TtienHNT+@TthueNT-@TotalCKNT'
where sysTableID = @sysTableID and fieldName = 'TtienNT'