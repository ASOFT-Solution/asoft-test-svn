-- [ACC_HUNGKHOI] Sổ giá thành công trình thể hiện nhiều dòng
Use CDT

-- Update filter
declare @sysReportID int,
		@sysFieldID int

-- 1) Bảng kê chứng từ theo công trình
select @sysReportID = sysReportID from sysReport
where ReportName = N'Bảng kê chứng từ theo công trình'

-- MaCongTrinh
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaCongTrinh'
				and sysTableID = (select sysTableID from sysTable where TableName = 'DT11')

Update [sysReportFilter] set IsBetween = 1, SpecialCond = 0
where [sysFieldID] = @sysFieldID and sysReportID = @sysReportID and IsBetween = 0 and SpecialCond = 1

-- TK
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'TK'
AND sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 2, 1, 1, 1, NULL)

Update sysReport set mtAlias = 'bltk', 
Query = N'Declare @TK varchar(50),
		@con nvarchar(500),
		@sql nvarchar(1000)
set @TK = @@TK
set @con = ''''
IF isnull(@TK,'''') <> ''''
	set @con = @con + '' and (tk like N''''%'' + @TK + ''%'''' or tkdu like  N''''%'' + @TK + ''%'''')''
set @sql = ''select bltk.macongtrinh, dmcongtrinh.tencongtrinh,ngayct,soct,bltk.makh,dmkh.tenkh,diengiai,tk,tkdu,psno
			from bltk,dmkh,dmcongtrinh
			where dmkh.makh=*bltk.makh and  bltk.psno > 0 ''+ @con +'' and ''+ @@ps+ ''
			and dmcongtrinh.macongtrinh=bltk.macongtrinh order by NgayCT, SoCT, NhomDk''
exec (@sql)'
where sysReportID = @sysReportID

-- 2) Sổ giá thành công trình
Update sysReport set Query = N'DECLARE @SOQD NVARCHAR(50)
DECLARE @DBname NVARCHAR(10)

Set @SOQD = ''''
Set @DBname = @@DBName
SELECT @SOQD = _Value  FROM [CDT].[dbo].[sysConfig] WHERE _key=''SOQD'' and DBname = @DBname
IF @SOQD = N''15/2006/QĐ-BTC'' -- Nếu là quyết định 15
BEGIN
	Declare @QD15temp table 
			(
				soct nvarchar(50),
				ngayct Datetime,
				diengiai nvarchar(4000),
				TK varchar(50),
				MaCongTrinh varchar(50),		
				CPvattu Decimal(28,8),				--[Chi phí nguyên vật liệu]
				CPnhancong Decimal(28,8),			--[Chi phí nhân công trực tiếp]
				CPmaythicong Decimal(28,8),			--[Chi phí máy thi công]
				CPthuethauphu Decimal(28,8),		--[Chi phí thuê thầu phụ]
				CPsanxuatchung Decimal(28,8),		--[Chi phí sản xuất chung]
													--[Tổng chi phí trực tiếp]
				CPbanhang Decimal(28,8),			--[Chi phí bán hàng]
				CPquanlydoanhnghiep Decimal(28,8)	--[Chi phí quản lý]
													--[Tổng chi phí]
			)
	Insert into @QD15temp (soct, ngayct, diengiai, TK, MaCongTrinh, CPvattu, CPnhancong, CPmaythicong, CPthuethauphu, CPsanxuatchung
							, CPbanhang, CPquanlydoanhnghiep)
							
	select soct,ngayct,diengiai,TK,MaCongTrinh  ,psno,0,0,0,0,0,0
	from bltk where left(tk,3)=''621'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0,psno,0,0,0,0,0 
	from  bltk where left(tk,3)=''622'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0,0,psno,0,0,0,0
	from  bltk where left(tk,3)=''623'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0,0,0,psno,0,0,0 
	from  bltk where left(tk,4)=''6277'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0,0,0,0,psno,0,0
	from  bltk where left(tk,3)=''627'' and left(tk,4)<>''6277'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0,0,0,0,0,psno,0
	from  bltk where left(tk,3)=''641'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0,0,0,0,0,0,psno
	from  bltk where left(tk,3)=''642'' and psno > 0 and @@ps
	
	Select soct, ngayct, diengiai, MaCongTrinh
			, sum(CPvattu) as [Chi phí nguyên vật liệu]
			, sum(CPnhancong) as [Chi phí nhân công trực tiếp]
			, sum(CPmaythicong) as [Chi phí máy thi công]
			, sum(CPthuethauphu) as [Chi phí thuê thầu phụ]
			, sum(CPsanxuatchung) as [Chi phí sản xuất chung]
			, sum(CPvattu)+sum(CPnhancong)+sum(CPmaythicong)+sum(CPthuethauphu)+sum(CPsanxuatchung) as [Tổng chi phí trực tiếp]
			, sum(CPbanhang) as [Chi phí bán hàng]
			, sum(CPquanlydoanhnghiep) as [Chi phí quản lý]
			, sum(CPvattu)+sum(CPnhancong)+sum(CPmaythicong)+sum(CPthuethauphu)
				+sum(CPsanxuatchung)+sum(CPbanhang)+sum(CPquanlydoanhnghiep) as [Tổng chi phí]
	from @QD15temp
	Group by soct, ngayct, diengiai, MaCongTrinh
	order by ngayct, soct
	
end
Else IF @SOQD = N''48/2006/QĐ-BTC'' -- Nếu là quyết định 48
BEGIN
	Declare @QD48temp table 
			(
				soct nvarchar(50),
				ngayct Datetime,
				diengiai nvarchar(4000),
				TK varchar(50),
				MaCongTrinh varchar(50),		
				CPvattu Decimal(28,8),				--[Chi phí nguyên vật liệu]
				CPnhancong Decimal(28,8),			--[Chi phí nhân công trực tiếp]
				CPmaythicong Decimal(28,8),			--[Chi phí máy thi công]
				CPthuethauphu Decimal(28,8),		--[Chi phí thuê thầu phụ]
				CPsanxuatchung Decimal(28,8),		--[Chi phí sản xuất chung]
													--[Tổng chi phí trực tiếp]
				CPbanhang Decimal(28,8),			--[Chi phí bán hàng]
				CPquanlydoanhnghiep Decimal(28,8)	--[Chi phí quản lý]
													--[Tổng chi phí]
			)
	Insert into @QD48temp (soct, ngayct, diengiai, TK, MaCongTrinh, CPvattu, CPnhancong, CPmaythicong, CPthuethauphu, CPsanxuatchung
							, CPbanhang, CPquanlydoanhnghiep)
	select soct,ngayct,diengiai,TK,MaCongTrinh  ,psno,0,0,0,0,0,0
	from bltk where left(tk,5)=''15411'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0,psno,0,0,0,0,0 
	from  bltk where left(tk,5)=''15412'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0,0,psno,0,0,0,0
	from  bltk where left(tk,5)=''15413'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0,0,0,0,psno,0,0  
	from  bltk where left(tk,5) = ''15417'' and psno > 0 and  @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0,0,0,0,0,psno,0
	from  bltk where left(tk,4)=''6421'' and psno > 0 and @@ps
	union all
	select soct,ngayct,diengiai,TK,MaCongTrinh ,0,0,0,0,0,0,psno
	from  bltk where left(tk,4)=''6422'' and psno > 0 and @@ps
	
	
	Select soct, ngayct, diengiai, MaCongTrinh
			, sum(CPvattu) as [Chi phí nguyên vật liệu]
			, sum(CPnhancong) as [Chi phí nhân công trực tiếp]
			, sum(CPmaythicong) as [Chi phí máy thi công]
			, sum(CPthuethauphu) as [Chi phí thuê thầu phụ]
			, sum(CPsanxuatchung) as [Chi phí sản xuất chung]
			, sum(CPvattu)+sum(CPnhancong)+sum(CPmaythicong)+sum(CPthuethauphu)+sum(CPsanxuatchung) as [Tổng chi phí trực tiếp]
			, sum(CPbanhang) as [Chi phí bán hàng]
			, sum(CPquanlydoanhnghiep) as [Chi phí quản lý]
			, sum(CPvattu)+sum(CPnhancong)+sum(CPmaythicong)+sum(CPthuethauphu)
				+sum(CPsanxuatchung)+sum(CPbanhang)+sum(CPquanlydoanhnghiep) as [Tổng chi phí]
	from @QD48temp
	Group by soct, ngayct, diengiai, MaCongTrinh
	order by ngayct, soct
	
end'
where ReportName = N'Sổ giá thành công trình'