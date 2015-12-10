-- Thay đổi mã số trong bảng cân đối kế toán cho khớp với HTKK
-- 1) Bảng cân đối kế toán
declare @sysReportID int

select @sysReportID = sysReportID from [CDT].[dbo].sysReport
where ReportName = N'Bảng cân đối kế toán'

Update [sysFormReport] set MaSo = '433'
where sysReportID = @sysReportID and MaSo = '432' and ChiTieu = N' 2. Nguồn kinh phí đã hình thành TSCĐ'

Update [sysFormReport] set MaSo = '4322'
where sysReportID = @sysReportID and MaSo = '4312' and ChiTieu = N'   1.2'

Update [sysFormReport] set MaSo = '4321'
where sysReportID = @sysReportID and MaSo = '4311' and ChiTieu = N'   1.1'

Update [sysFormReport] set MaSo = '432'
where sysReportID = @sysReportID and MaSo = '431' and ChiTieu = N' 1. Nguồn kinh phí'

Update [sysFormReport] set CachTinh = N'@432+@433'
where sysReportID = @sysReportID and MaSo = '430' and ChiTieu = N'II. Nguồn kinh phí và quỹ khác' and CachTinh = N'@431+@432'