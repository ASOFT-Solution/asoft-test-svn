use [CDT]

Update sysReport Set Query = N'declare @manhom nvarchar(20)
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
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[cogiaGDC]'') AND type in (N''U''))
	set @sql= N''select  a.MaSP [Mã sản phẩm],b.tenvt [Tên sản phẩm],a.soluong as [Số lượng nhập kho],a.dddk as [Dở dang đầu kỳ],a.gdnvl [Chi phí nguyên vật liệu],a.gdluong [Chi phí nhân công trực tiếp],a.gdsxc [Chi phí sản xuất chung],a.ddck [Dở dang cuối kỳ],a.Gia [Giá thành] from cogia'' + @manhom + '' a inner join dmvt b on a.masp=b.mavt where ngayct between   cast('''''' + convert(nvarchar,@ngayct1) + '''''' as datetime) and cast('''''' + convert(nvarchar,@ngayct2) + '''''' as datetime)''
else
	set @sql= N''select  NULL [Mã sản phẩm],NULL [Tên sản phẩm],NULL as [Số lượng nhập kho],NULL as [Dở dang đầu kỳ],NULL [Chi phí nguyên vật liệu],NULL [Chi phí nhân công trực tiếp],NULL [Chi phí sản xuất chung],NULL [Dở dang cuối kỳ],NULL [Giá thành]''
END
-- Hệ số chuẩn
else if @manhom = ''HSC'' 
BEGIN
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[cogiaHSC]'') AND type in (N''U''))
	set @sql= N''select  a.MaSP [Mã sản phẩm],b.tenvt [Tên sản phẩm],a.soluong as [Số lượng nhập kho],a.dddk as [Dở dang đầu kỳ],a.hsnvl [Chi phí nguyên vật liệu],a.hsluong [Chi phí nhân công trực tiếp],a.hssxc [Chi phí sản xuất chung],a.ddck [Dở dang cuối kỳ],a.Gia [Giá thành] from cogia'' + @manhom + '' a inner join dmvt b on a.masp=b.mavt where ngayct between   cast('''''' + convert(nvarchar,@ngayct1) + '''''' as datetime) and cast('''''' + convert(nvarchar,@ngayct2) + '''''' as datetime)''
else
	set @sql= N''select  NULL [Mã sản phẩm],NULL [Tên sản phẩm],NULL as [Số lượng nhập kho],NULL as [Dở dang đầu kỳ],NULL [Chi phí nguyên vật liệu],NULL [Chi phí nhân công trực tiếp],NULL [Chi phí sản xuất chung],NULL [Dở dang cuối kỳ],NULL [Giá thành]''
END
-- Định mức chuẩn
else
BEGIN
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[cogiaDMC]'') AND type in (N''U''))
	set @sql= N''select  a.MaSP [Mã sản phẩm],b.tenvt [Tên sản phẩm],a.soluong as [Số lượng nhập kho],a.dddk as [Dở dang đầu kỳ],a.dmnvl [Chi phí nguyên vật liệu],a.dmluong [Chi phí nhân công trực tiếp],a.dmsxc [Chi phí sản xuất chung],a.ddck [Dở dang cuối kỳ],a.Gia [Giá thành] from cogia'' + @manhom + '' a inner join dmvt b on a.masp=b.mavt where ngayct between   cast('''''' + convert(nvarchar,@ngayct1) + '''''' as datetime) and cast('''''' + convert(nvarchar,@ngayct2) + '''''' as datetime)''
else
	set @sql= N''select  NULL [Mã sản phẩm],NULL [Tên sản phẩm],NULL as [Số lượng nhập kho],NULL as [Dở dang đầu kỳ],NULL [Chi phí nguyên vật liệu],NULL [Chi phí nhân công trực tiếp],NULL [Chi phí sản xuất chung],NULL [Dở dang cuối kỳ],NULL [Giá thành]''
END
exec(@sql)'
where ReportName = N'Báo cáo chi tiết giá thành sản phẩm'