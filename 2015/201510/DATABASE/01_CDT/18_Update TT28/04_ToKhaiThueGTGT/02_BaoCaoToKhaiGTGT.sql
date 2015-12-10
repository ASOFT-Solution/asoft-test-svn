use [CDT]
declare @mtTableID int,
		@dtTableID int,
		@sysFieldID int,
		@sysReportID int
		
select @mtTableID = sysTableID from sysTable
where TableName = 'MToKhai' and sysPackageID = 8

select @dtTableID = sysTableID from sysTable
where TableName = 'DToKhai' and sysPackageID = 8

-- Step 1: Thêm báo cáo
if not exists (select top 1 1 from sysReport where ReportName = N'Tờ khai thuế GTGT' and sysPackageID = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Tờ khai thuế GTGT', 0, @mtTableID, @dtTableID, N'select mst.KyToKhai, mst.NamToKhai, mst.InLanDau, mst.SoLanIn, dt.Stt, dt.ChiTieu, dt.CodeGT, dt.GTHHDV , dt.CodeThue, dt.ThueGTGT
from DToKhai dt inner join MToKhai mst on mst.MToKhaiID = dt.MToKhaiID
where @@ps and mst.NamToKhai = @@NAM 
Order by dt.SortOrder', N'ToKhai', N'VAT Return', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, N'mst', N'dt', NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Tờ khai thuế GTGT' and sysPackageID = 8

-- Step 2: Tham số báo cáo
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'KyToKhai'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 0, 0, 1, 1, 0, NULL)

-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Tờ khai thuế GTGT', N'ToKhai', NULL, NULL)

-- Step 4: Update menu
Update sysMenu set sysTableID = NULL, sysReportID = @sysReportID
where MenuName = N'Tờ khai thuế GTGT' and sysReportID is null