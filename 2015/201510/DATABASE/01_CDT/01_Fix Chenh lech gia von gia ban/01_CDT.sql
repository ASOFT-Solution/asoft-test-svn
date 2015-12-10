use [CDT]
declare @sysFieldID as int
declare @sysReportID as int
declare @sysMenuParent as int

-- Step 1: Thêm báo cáo
if not exists (select top 1 1 from sysReport where ReportName = N'Báo cáo chi tiết chênh lệch giá vốn và giá bán')
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) VALUES (N'Báo cáo chi tiết chênh lệch giá vốn và giá bán', 0, 2031, 2052, 
N'select x.mavt, x.tenvt, SUM(x.soluong) as [Số lượng tiêu thụ], SUM(x.tienvon) / SUM(x.soluong) as [Đơn giá (Giá vốn)], SUM(x.tienvon) as [Giá vốn], SUM(x.ps - x.ck) / SUM(x.soluong) as [Đơn giá (Giá bán)], SUM(x.ps - x.ck) as [Giá bán], SUM(x.ps - x.ck - x.tienvon) as [Chênh lệch],  x.loaiVT
from (select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, ck, giavon, tienvon, mabp, loaiVT
	from mt32, dt32, dmvt v
	where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt
	union all
	select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, -ps, 0.0, giavon, -tienvon, mabp, loaiVT
	from mt33, dt33, dmvt v
	where  mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt) x, 
	vatout vo, dmbophan b
where dt32id *= vo.mtiddt and x.mabp *= b.mabp and @@ps
Group by x.mavt, x.tenvt, x.loaiVT
order by x.mavt', N'BCCLGVGB', N'The detail report about the differences between cost and price', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, N'x', N'x', NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Báo cáo chi tiết chênh lệch giá vốn và giá bán' and sysPackageID = 8

-- Site PRO
select @sysMenuParent = sysMenuID from sysMenu 
where MenuName = N'Báo cáo' and sysMenuParent = 
							(select sysMenuID from sysMenu 
							where  MenuName = N'Bán hàng' and sysSiteID = 10)

if @sysMenuParent <> '' AND @sysMenuParent <> NULL
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo chi tiết chênh lệch giá vốn và giá bán' and sysSiteID = 10)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) VALUES (N'Báo cáo chi tiết chênh lệch giá vốn và giá bán', N'The detail report about the differences between cost and price', 10, NULL, NULL, @sysReportID, 8, NULL, @sysMenuParent, NULL, NULL, 5, NULL)
END

-- Site STD
select @sysMenuParent = sysMenuID from sysMenu 
where MenuName = N'Báo cáo' and sysMenuParent = 
							(select sysMenuID from sysMenu 
							where  MenuName = N'Bán hàng' and sysSiteID = 13)

if @sysMenuParent <> '' AND @sysMenuParent <> NULL
BEGIN					
if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo chi tiết chênh lệch giá vốn và giá bán' and sysSiteID = 13)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) VALUES (N'Báo cáo chi tiết chênh lệch giá vốn và giá bán', N'The detail report about the differences between cost and price', 13, NULL, NULL, @sysReportID, 8, NULL, 7284, NULL, NULL, 5, NULL)
END

-- Step 2: Form báo cáo
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'NgayCT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'MT32')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 1, 0, 1, 1, 0, NULL)


select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaVT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'DT32')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 1, 1, 0, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'loaiVT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'DMVT')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 2, 1, 0, 0, NULL)
				
-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Báo cáo chi tiết chênh lệch giá vốn và giá bán', N'BCCLGVGB', NULL, NULL)

-- Step 4: Update từ điển
if not exists (select top 1 1 from Dictionary where Content = N'Mặt hàng')
	insert into Dictionary(Content, Content2) Values (N'Mặt hàng',N'Goods')

if not exists (select top 1 1 from Dictionary where Content = N'Hàng Hóa')	
	insert into Dictionary(Content, Content2) Values (N'Hàng Hóa',N'Goods')

if not exists (select top 1 1 from Dictionary where Content = N'Công cụ dụng cụ')		
	insert into Dictionary(Content, Content2) Values (N'Công cụ dụng cụ',N'Tools')

if not exists (select top 1 1 from Dictionary where Content = N'Thành phẩm')		
	insert into Dictionary(Content, Content2) Values (N'Thành phẩm',N'Product')

if not exists (select top 1 1 from Dictionary where Content = N'TSCĐ')		
	insert into Dictionary(Content, Content2) Values (N'TSCĐ',N'Fixed Asset')	
	
if not exists (select top 1 1 from Dictionary where Content = N'Dịch vụ')		
	insert into Dictionary(Content, Content2) Values (N'Dịch vụ',N'Services')	

if not exists (select top 1 1 from Dictionary where Content = N'Đơn giá (Giá vốn)')		
	insert into Dictionary(Content, Content2) Values (N'Đơn giá (Giá vốn)',N'Unit price (Cost)')				

if not exists (select top 1 1 from Dictionary where Content = N'Đơn giá (Giá bán)')		
	insert into Dictionary(Content, Content2) Values (N'Đơn giá (Giá bán)',N'Unit price (Selling)')					
	
if not exists (select top 1 1 from Dictionary where Content = N'Số lượng tiêu thụ')		
	insert into Dictionary(Content, Content2) Values (N'Số lượng tiêu thụ', N'Quantity consumed')			

if not exists (select top 1 1 from Dictionary where Content = N'Chênh lệch')		
	insert into Dictionary(Content, Content2) Values (N'Chênh lệch',N'Difference')		
		