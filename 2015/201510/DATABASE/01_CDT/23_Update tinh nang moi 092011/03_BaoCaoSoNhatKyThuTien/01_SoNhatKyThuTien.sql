use [CDT]
declare @sysFieldID as int
declare @sysReportID as int
declare @sysMenuParent as int
declare @sysSiteIDPRO as int
declare @sysSiteIDSTD as int
declare @sysMtTableID as int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = 'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = 'STD'

select @sysMtTableID = sysTableID from sysTable where tableName = 'BLTK'

-- Step 1: Thêm báo cáo
if not exists (select top 1 1 from sysReport where ReportName = N'Sổ nhật ký thu tiền')
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Sổ nhật ký thu tiền', 0, @sysMtTableID, NULL, 
N'Select * from 
(Select SoCt, NgayCt,  DienGiai, B.MaKH, KH.TenKH, TK, TKDu, PsNo, PsCo, 
B.MaPhi,P.Tenphi, B.MaVV, VV.TenVV, B.MaBP, PB.TenBP, MaNT, TyGia 
From BLTK as B left join DMPhi as P on B.MaPhi=P.MaPhi
  left join DMVuViec as VV on B.MaVV=VV.MaVV
  left join DMBoPhan as PB on B.MaBP=PB.MaBP
  left join DMKH as KH on B.MaKH=KH.MaKH
where TK like ''11%'' and psno > 0) x 
where @@ps', N'SNKTHUTIEN', N'Diary of income', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Sổ nhật ký thu tiền' and sysPackageID = 8

if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

-- Site PRO
select @sysMenuParent = sysMenuID from sysMenu 
where MenuName = N'Báo cáo' and sysMenuParent = 
							(select sysMenuID from sysMenu 
							where  MenuName = N'Quản lý tiền' and sysSiteID = @sysSiteIDPRO)

if isnull(@sysMenuParent,'') <> ''
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Sổ nhật ký thu tiền' and sysSiteID = @sysSiteIDPRO)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Sổ nhật ký thu tiền', N'Diary of income', @sysSiteIDPRO, NULL, NULL, @sysReportID, 4, NULL, @sysMenuParent, NULL, NULL, 5, NULL)
END

END

if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

-- Site STD
select @sysMenuParent = sysMenuID from sysMenu 
where MenuName = N'Báo cáo' and sysMenuParent = 
							(select sysMenuID from sysMenu 
							where  MenuName = N'Quản lý tiền' and sysSiteID = @sysSiteIDSTD)

if isnull(@sysMenuParent,'') <> ''
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Sổ nhật ký thu tiền' and sysSiteID = @sysSiteIDSTD)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Sổ nhật ký thu tiền', N'Diary of income', @sysSiteIDSTD, NULL, NULL, @sysReportID, 4, NULL, @sysMenuParent, NULL, NULL, 5, NULL)
END

END

-- Step 2: Form báo cáo
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'NgayCT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 1, 0, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'TK'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, '111', @sysReportID, 0, 1, 1, 1, 0, N'Tk like ''11%''')

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'TKDu'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 2, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaNT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 3, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaKH'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 4, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaBP'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 5, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaPhi'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 6, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaVV'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 7, 1, 1, 0, NULL)

-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Sổ nhật ký thu tiền', N'SNKTHUTIEN', N'Diary of income', NULL)

-- Step 4: Update từ điển
--if not exists (select top 1 1 from Dictionary where Content = N'Mặt hàng')
--	insert into Dictionary(Content, Content2) Values (N'Mặt hàng',N'Goods')

