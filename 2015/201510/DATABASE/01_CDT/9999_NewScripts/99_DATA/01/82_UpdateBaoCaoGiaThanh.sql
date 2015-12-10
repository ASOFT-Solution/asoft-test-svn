-- CRM: TT4061 
-- Update báo cáo kết quả kinh doanh theo CTXL: lấy lên báo cáo sai field
-- Update báo cáo Sổ giá thành công trình: loại bỏ các dòng = 0 (thêm condition psno > 0)
USE [CDT]

-- Báo cáo kết quả kinh doanh theo công trình xây lắp
Update sysReport set Query = N'declare @ngayct1  datetime
declare @ngayct2 datetime
declare @ngaydaunam datetime
set  @ngayct1=@@ngayct1
set  @ngayct2=dateadd(hh,23,@@ngayct2)
declare @gtsx decimal(28,6) 
declare @gtsx2 decimal(28,6)
declare @gtsx3 decimal(28,6)
declare @cpbanhang decimal(28,6)
declare @cpquanly decimal(28,6)
declare @cpquanly2 decimal(28,6)
declare @cpquanly3 decimal(28,6)
declare @cpbanhang2 decimal(28,6)
declare @cpbanhang3 decimal(28,6)
declare @gttoanbo1 decimal(28,6)
declare @dtthuan1 decimal(28,6)
declare @dtthuan2 decimal(28,6)
declare @dtthuan3 decimal(28,6)
declare @lailo1  decimal(28,6)
declare @gttoanbo2 decimal(28,6)
declare @gttoanbo3 decimal(28,6)
declare @lailo2 decimal(28,6)
declare @lailo3 decimal(28,6)

declare @macongtrinh  nvarchar(50)
declare @tencongtrinh  nvarchar(50)
declare  curtemp cursor for

select macongtrinh,tencongtrinh from dmcongtrinh where @@ps
create  table #tam
 (
	[macongtrinh] [nvarchar]  (50) NULL ,	
    [tencongtrinh] [nvarchar]  (50) NULL ,
	[giathanhsx]  decimal(28, 6) null,
	[cpbanhang] decimal(28, 6) null,
	[cpquanly] decimal(28, 6) NULL ,
	[giathanhtoanbo] decimal(28, 6) NULL,
	[dtthuan1] decimal(28, 6) null,
	[lailo1] decimal(28, 6) null,
	[gttbdaunam]  decimal(28, 6) null,
	[dtthuan2]  decimal(28, 6) null,
	[lailo2]  decimal(28, 6) null,
	[gtkhoicong]  decimal(28, 6) null,
	[dtthuan3]  decimal(28, 6) null,
	[lailo3]  decimal(28, 6) null
) ON [PRIMARY]


OPEN curtemp
DECLARE @SOQD NVARCHAR(50)
DECLARE @DBname NVARCHAR(10)
Set @SOQD = ''''
Set @DBname = @@DBName
SELECT @SOQD = _Value  FROM [CDT].[dbo].[sysConfig] WHERE _key=''SOQD'' and DBname = @DBname
FETCH NEXT FROM curtemp INTO @macongtrinh,@tencongtrinh
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @SOQD = N''15/2006/QĐ-BTC'' -- Nếu là quyết định 15
		BEGIN
			select @gtsx=sum(psno)from bltk where ( left(tk,3) =''621'' or left(tk,3) =''622'' or left(tk,3) =''623'' or left(tk,3) =''627'' ) and macongtrinh=@macongtrinh and ngayct between @ngayct1 and @ngayct2
			select @cpbanhang=sum(psno) from bltk where left(tk,3)=''641'' and macongtrinh=@macongtrinh  and ngayct between @ngayct1 and @ngayct2
			select @cpquanly=sum(psno) from bltk where left(tk,3)=''642'' and macongtrinh=@macongtrinh and  ngayct between @ngayct1 and @ngayct2
			select @dtthuan1=sum(psco) from bltk where left(tk,3)=''511'' and macongtrinh=@macongtrinh  and ngayct between @ngayct1 and @ngayct2 
			if @gtsx is null set @gtsx=0.0
			if @cpbanhang is null set @cpbanhang=0.0
			if @cpquanly is null set @cpquanly=0.0
			if @dtthuan1 is null set @dtthuan1=0.0

			set @gttoanbo1=@gtsx+@cpbanhang+@cpquanly
			set @lailo1=@dtthuan1-@gttoanbo1

			--luy ke tu dau nam den cuoi ky  (them dk ngayct between ngaydaunam and ngayct2)

			set @ngaydaunam= convert(datetime,''01/01''+''/''+ convert(nvarchar(4), year(@ngayct1)))
			select @gtsx2=sum(psno)from bltk where ( left(tk,3) =''621'' or left(tk,3) =''622'' or left(tk,3) =''623'' or left(tk,3) =''627'' ) and macongtrinh=@macongtrinh and ngayct between @ngaydaunam and @ngayct2
			select @cpbanhang2=sum(psno) from bltk where left(tk,3)=''641'' and macongtrinh=@macongtrinh  and ngayct between @ngaydaunam and @ngayct2
			select @cpquanly2=sum(psno) from bltk where left(tk,3)=''642'' and macongtrinh=@macongtrinh and  ngayct between @ngaydaunam and @ngayct2

			select @dtthuan2=sum(psco) from bltk where left(tk,3)=''511'' and macongtrinh=@macongtrinh and  ngayct between @ngaydaunam and @ngayct2
			if @gtsx2 is null set @gtsx2=0.0
			if @cpbanhang2 is null set @cpbanhang2=0.0
			if @cpquanly2 is null set @cpquanly2=0.0
			if @dtthuan2 is null set @dtthuan2=0.0

			set @gttoanbo2=@gtsx2+@cpbanhang2+@cpquanly2
			set @lailo2=@dtthuan2-@gttoanbo2

			---luy ke tu luc khoi cong 
			declare  @dudau15 decimal(28,6)
			declare  @sx15  decimal(28,6)
			select @dudau15=tien from cocongtrinhdd where macongtrinh=@macongtrinh

			select @sx15=sum(psno)from bltk where ( left(tk,3) =''621'' or left(tk,3) =''622'' or left(tk,3) =''623'' or left(tk,3) =''627'' ) and macongtrinh=@macongtrinh and ngayct <= @ngayct2
			select @cpbanhang3=sum(psno) from bltk where left(tk,3)=''641'' and macongtrinh=@macongtrinh  and ngayct <= @ngayct2
			select @cpquanly3=sum(psno) from bltk where left(tk,3)=''642'' and macongtrinh=@macongtrinh and  ngayct <= @ngayct2

			select @dtthuan3=sum(psco) from bltk where left(tk,3)=''511'' and macongtrinh=@macongtrinh and  ngayct<= @ngayct2

			if @cpbanhang3 is null set @cpbanhang3=0.0
			if @cpquanly3 is null set @cpquanly3=0.0
			if @dtthuan3 is null set @dtthuan3=0.0
			if @dudau15 is null set @dudau15=0
			if @sx15 is null set @sx15=0
			set @gtsx3=@sx15+@dudau15
			set @gttoanbo3=@gtsx3+@cpbanhang3+@cpquanly3
			set @lailo3=@dtthuan3-@gttoanbo3

	END 
	Else IF @SOQD = N''48/2006/QĐ-BTC'' -- Nếu là quyết định 48
		BEGIN
			select @gtsx=sum(psno)from bltk where ( left(tk,5) =''15411'' or left(tk,5) =''15412'' or left(tk,5) =''15413'' or left(tk,5) =''15417'' ) and macongtrinh=@macongtrinh and ngayct between @ngayct1 and @ngayct2
			select @cpbanhang=sum(psno) from bltk where left(tk,4)=''6421'' and macongtrinh=@macongtrinh  and ngayct between @ngayct1 and @ngayct2
			select @cpquanly=sum(psno) from bltk where left(tk,4)=''6422'' and macongtrinh=@macongtrinh and  ngayct between @ngayct1 and @ngayct2
			select @dtthuan1=sum(psco) from bltk where left(tk,3)=''511'' and macongtrinh=@macongtrinh  and ngayct between @ngayct1 and @ngayct2 
			if @gtsx is null set @gtsx=0.0
			if @cpbanhang is null set @cpbanhang=0.0
			if @cpquanly is null set @cpquanly=0.0
			if @dtthuan1 is null set @dtthuan1=0.0

			set @gttoanbo1=@gtsx+@cpbanhang+@cpquanly
			set @lailo1=@dtthuan1-@gttoanbo1

			--luy ke tu dau nam den cuoi ky  (them dk ngayct between ngaydaunam and ngayct2)

			set @ngaydaunam= convert(datetime,''01/01''+''/''+ convert(nvarchar(4), year(@ngayct1)))
			select @gtsx2=sum(psno)from bltk where ( left(tk,5) =''15411'' or left(tk,5) =''15412'' or left(tk,5) =''15413'' or left(tk,5) =''15417'' ) and macongtrinh=@macongtrinh and ngayct between @ngaydaunam and @ngayct2
			select @cpbanhang2=sum(psno) from bltk where left(tk,4)=''6421'' and macongtrinh=@macongtrinh  and ngayct between @ngaydaunam and @ngayct2
			select @cpquanly2=sum(psno) from bltk where left(tk,4)=''6422'' and macongtrinh=@macongtrinh and  ngayct between @ngaydaunam and @ngayct2

			select @dtthuan2=sum(psco) from bltk where left(tk,3)=''511'' and macongtrinh=@macongtrinh and  ngayct between @ngaydaunam and @ngayct2
			if @gtsx2 is null set @gtsx2=0.0
			if @cpbanhang2 is null set @cpbanhang2=0.0
			if @cpquanly2 is null set @cpquanly2=0.0
			if @dtthuan2 is null set @dtthuan2=0.0

			set @gttoanbo2=@gtsx2+@cpbanhang2+@cpquanly2
			set @lailo2=@dtthuan2-@gttoanbo2

			--luy ke tu luc khoi cong 
			declare  @dudau48 decimal(28,6)
			declare  @sx48  decimal(28,6)
			select @dudau48=tien from cocongtrinhdd where macongtrinh=@macongtrinh

			select @sx48=sum(psno)from bltk where ( left(tk,5) =''15411'' or left(tk,5) =''15412'' or left(tk,5) =''15413'' or left(tk,5) =''15417'' ) and macongtrinh=@macongtrinh and ngayct <= @ngayct2
			select @cpbanhang3=sum(psno) from bltk where left(tk,4)=''6421'' and macongtrinh=@macongtrinh  and ngayct <= @ngayct2
			select @cpquanly3=sum(psno) from bltk where left(tk,4)=''6422'' and macongtrinh=@macongtrinh and  ngayct <= @ngayct2

			select @dtthuan3=sum(psco) from bltk where left(tk,3)=''511'' and macongtrinh=@macongtrinh and  ngayct<= @ngayct2

			if @cpbanhang3 is null set @cpbanhang3=0.0
			if @cpquanly3 is null set @cpquanly3=0.0
			if @dtthuan3 is null set @dtthuan3=0.0
			if @dudau48 is null set @dudau48=0
			if @sx48 is null set @sx48=0
			set @gtsx3=@sx48+@dudau48
			set @gttoanbo3=@gtsx3+@cpbanhang3+@cpquanly3
			set @lailo3=@dtthuan3-@gttoanbo3

		END
insert into #tam (macongtrinh,tencongtrinh,giathanhsx,cpbanhang,cpquanly,giathanhtoanbo,dtthuan1,lailo1,gttbdaunam,dtthuan2,lailo2,gtkhoicong,dtthuan3,lailo3) values (@macongtrinh,@tencongtrinh,@gtsx,@cpbanhang,@cpquanly,@gttoanbo1,@dtthuan1,@lailo1,@gttoanbo2,@dtthuan2,@lailo2,@gttoanbo3,@dtthuan3,@lailo3)
FETCH NEXT FROM curtemp INTO @macongtrinh,@tencongtrinh
END
CLOSE curtemp
DEALLOCATE curtemp
select macongtrinh,tencongtrinh,giathanhsx [Giá thành công trình], cpbanhang [Chi phí bán hàng], cpquanly [Chi phí quản lý], dtthuan1 [Doanh thu thuần], lailo1 [Lãi lỗ], gttbdaunam [Giá thành lũy kế năm], dtthuan2 [Doanh thu lũy kế năm], lailo2 [Lãi lỗ lũy kế năm], gtkhoicong [Giá thành toàn bộ], dtthuan3 [Doanh thu toàn bộ], lailo3 [Lãi lỗ toàn bộ] from #tam
drop table #tam'
where ReportName = N'Báo cáo kết quả kinh doanh theo công trình xây lắp'

-- Sổ giá thành công trình
Update sysReport set Query = N'DECLARE @SOQD NVARCHAR(50)
DECLARE @DBname NVARCHAR(10)

Set @SOQD = ''''
Set @DBname = @@DBName
SELECT @SOQD = _Value  FROM [CDT].[dbo].[sysConfig] WHERE _key=''SOQD'' and DBname = @DBname
IF @SOQD = N''15/2006/QĐ-BTC'' -- Nếu là quyết định 15
BEGIN
	select soct,ngayct,diengiai,TK,MaCongTrinh  ,psno as [Chi phí nguyên vật liệu],0 [Chi phí nhân công trực tiếp],0 [Chi phí máy thi công],0 [Chi phí thuê thầu phụ],0 [Chi phí sản xuất chung],0 [Tổng chi phí trực tiếp],0 [Chi phí bán hàng],0 [Chi phí quản lý],0 [Tổng chi phí] from bltk where left(tk,3)=''621'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 vatlieu,psno as nhancong,0 maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,0 from  bltk where left(tk,3)=''622'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,psno as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,0 from  bltk where left(tk,3)=''623'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,psno chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,0 from  bltk where left(tk,4)=''6277'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,psno sanxuatchung,0,0 cpbanhang,0 cpquanly,0  from  bltk where left(tk,3)=''627'' and left(tk,4)<>''6277'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,psno,0 cpbanhang,0 cpquanly,0  from  bltk where left(tk,2)=''62'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,psno cpbanhang,0 cpquanly,0 from  bltk where left(tk,3)=''641'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,psno cpquanly,0 from  bltk where left(tk,3)=''642'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,psno from  bltk where (left(tk,1)=''6'' or left(tk,1)=''8'') and psno > 0 and @@ps
end
Else IF @SOQD = N''48/2006/QĐ-BTC'' -- Nếu là quyết định 48
BEGIN
	select soct,ngayct,diengiai,TK,MaCongTrinh ,psno as [Chi phí nguyên vật liệu],0 [Chi phí nhân công trực tiếp],0 [Chi phí máy thi công],0 [Chi phí thuê thầu phụ],0 [Chi phí sản xuất chung],0 [Tổng chi phí trực tiếp],0 [Chi phí bán hàng],0 [Chi phí quản lý],0 [Tổng chi phí] from bltk where left(tk,5)=''15411'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 vatlieu,psno as nhancong,0 maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,0 from  bltk where left(tk,5)=''15412'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,psno as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,0 from  bltk where left(tk,5)=''15413'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,psno sanxuatchung,0,0 cpbanhang,0 cpquanly,0  from  bltk where left(tk,5) = ''15417'' and psno > 0 and  @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,psno,0 cpbanhang,0 cpquanly,0  from  bltk where left(tk,4)=''1541'' and left(tk,5)<>''15418'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,psno cpbanhang,0 cpquanly,0 from  bltk where left(tk,4)=''6421'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,psno cpquanly,0 from  bltk where left(tk,4)=''6422'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0 as vatlieu,0 nhancong,0 as maythicong,0 chiphithuethauphu,0 sanxuatchung,0,0 cpbanhang,0 cpquanly,psno from  bltk where (left(tk,1)=''6'' or left(tk,1)=''8'' or (left(tk,4)=''1541'' and left(tk,5)<>''15418'')) and psno > 0 and @@ps
end'
where ReportName = N'Sổ giá thành công trình'