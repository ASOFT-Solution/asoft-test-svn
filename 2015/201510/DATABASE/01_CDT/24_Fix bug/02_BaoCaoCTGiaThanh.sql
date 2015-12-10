USE [CDT]

DECLARE @sysReportID INT

SELECT @sysReportID = sysReportID FROM [sysReport] WHERE ReportName = N'Báo cáo chi tiết giá thành sản phẩm'

Update sysReport
set Query = N'declare @manhom nvarchar(20)
declare @Ngayct datetime
set @Ngayct =@@ngayct
declare @Ngayct1 datetime
declare @Ngayct2 datetime
set @ngayct1=dbo.LayNgayDauthang(@ngayct)
set @ngayct2=dbo.LayNgayGhiSo(@ngayct)
set @manhom=@@NhomGT
declare @sql nvarchar(4000)

-- Giản đơn chuẩn
if @manhom = ''GDC''
BEGIN
set @sql= N''select  a.MaSP [Mã sản phẩm],b.tenvt [Tên sản phẩm],a.soluong as [Số lượng nhập kho],a.dddk as [Dở dang đầu kỳ],a.gdnvl [Chi phí nguyên vật liệu],a.gdluong [Chi phí nhân công trực tiếp],a.gdsxc [Chi phí sản xuất chung],a.ddck [Dở dang cuối kỳ],a.Gia [Giá thành] from cogia'' + @manhom + '' a inner join dmvt b on a.masp=b.mavt where ngayct between   cast('''''' + convert(nvarchar,@ngayct1) + '''''' as datetime) and cast('''''' + convert(nvarchar,@ngayct2) + '''''' as datetime)''
END
-- Hệ số chuẩn
else if @manhom = ''HSC'' 
BEGIN
set @sql= N''select  a.MaSP [Mã sản phẩm],b.tenvt [Tên sản phẩm],a.soluong as [Số lượng nhập kho],a.dddk as [Dở dang đầu kỳ],a.hsnvl [Chi phí nguyên vật liệu],a.hsluong [Chi phí nhân công trực tiếp],a.hssxc [Chi phí sản xuất chung],a.ddck [Dở dang cuối kỳ],a.Gia [Giá thành] from cogia'' + @manhom + '' a inner join dmvt b on a.masp=b.mavt where ngayct between   cast('''''' + convert(nvarchar,@ngayct1) + '''''' as datetime) and cast('''''' + convert(nvarchar,@ngayct2) + '''''' as datetime)''
END
-- Định mức chuẩn
else
BEGIN
set @sql= N''select  a.MaSP [Mã sản phẩm],b.tenvt [Tên sản phẩm],a.soluong as [Số lượng nhập kho],a.dddk as [Dở dang đầu kỳ],a.dmnvl [Chi phí nguyên vật liệu],a.dmluong [Chi phí nhân công trực tiếp],a.dmsxc [Chi phí sản xuất chung],a.ddck [Dở dang cuối kỳ],a.Gia [Giá thành] from cogia'' + @manhom + '' a inner join dmvt b on a.masp=b.mavt where ngayct between   cast('''''' + convert(nvarchar,@ngayct1) + '''''' as datetime) and cast('''''' + convert(nvarchar,@ngayct2) + '''''' as datetime)''
END
exec(@sql)'
where sysReportID = @sysReportID