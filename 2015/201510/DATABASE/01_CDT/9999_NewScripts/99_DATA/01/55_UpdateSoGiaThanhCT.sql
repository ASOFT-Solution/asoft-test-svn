Use CDT

Update sysReport set Query = N'DECLARE @SOQD NVARCHAR(50)
DECLARE @DBname NVARCHAR(10)

Set @SOQD = ''''
Set @DBname = @@DBName
SELECT @SOQD = _Value  FROM [CDT].[dbo].[sysConfig] WHERE _key=''SOQD'' and DBname = @DBname
IF @SOQD = N''15/2006/QĐ-BTC'' -- Nếu là quyết định 15
BEGIN
	select soct,ngayct,diengiai,TK,MaCongTrinh  ,psno as [Chi phí nguyên vật liệu],0 [Chi phí nhân công trực tiếp],0 [Chi phí máy thi công],0 [Chi phí thuê thầu phụ],0 [Chi phí sản xuất chung],0 [Tổng chi phí trực tiếp],0 [Chi phí bán hàng],0 [Chi phí quản lý],0 [Tổng chi phí] from bltk where left(tk,3)=''621'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 vatlieu,psno as nhancong,0 maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,0 from  bltk where left(tk,3)=''622'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,psno as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,0 from  bltk where left(tk,3)=''623'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,psno chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,0 from  bltk where left(tk,4)=''6277'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,psno sanxuatchung,0,0 cpbanhang,0 cpquanly,0  from  bltk where left(tk,3)=''627'' and left(tk,4)<>''6277'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,psno,0 cpbanhang,0 cpquanly,0  from  bltk where left(tk,2)=''62'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,psno cpbanhang,0 cpquanly,0 from  bltk where left(tk,3)=''641'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,psno cpquanly,0 from  bltk where left(tk,3)=''642'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,psno from  bltk where (left(tk,1)=''6'' or left(tk,1)=''8'') and @@ps
end
Else IF @SOQD = N''48/2006/QĐ-BTC'' -- Nếu là quyết định 48
BEGIN
	select soct,ngayct,diengiai,TK,MaCongTrinh ,psno as [Chi phí nguyên vật liệu],0 [Chi phí nhân công trực tiếp],0 [Chi phí máy thi công],0 [Chi phí thuê thầu phụ],0 [Chi phí sản xuất chung],0 [Tổng chi phí trực tiếp],0 [Chi phí bán hàng],0 [Chi phí quản lý],0 [Tổng chi phí] from bltk where left(tk,5)=''15411'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 vatlieu,psno as nhancong,0 maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,0 from  bltk where left(tk,5)=''15412'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,psno as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,0 from  bltk where left(tk,5)=''15413'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,psno sanxuatchung,0,0 cpbanhang,0 cpquanly,0  from  bltk where left(tk,5) = ''15417'' and  @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,psno,0 cpbanhang,0 cpquanly,0  from  bltk where left(tk,4)=''1541'' and left(tk,5)<>''15418'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,psno cpbanhang,0 cpquanly,0 from  bltk where left(tk,4)=''6421'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,psno cpquanly,0 from  bltk where left(tk,4)=''6422'' and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,psno from  bltk where (left(tk,1)=''6'' or left(tk,1)=''8'' or (left(tk,4)=''1541'' and left(tk,5)<>''15418'')) and @@ps
end'
where ReportName = N'Sổ giá thành công trình'
