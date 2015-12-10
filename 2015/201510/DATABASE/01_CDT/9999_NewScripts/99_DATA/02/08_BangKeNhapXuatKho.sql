USE [CDT]

-- Thêm điều kiện search công trình
declare @sysReportID int,
		@sysFieldID int

-- 1) Bảng kê phiếu xuất kho
select @sysReportID = sysReportID from sysReport where ReportName = N'Bảng kê phiếu xuất kho' and sysPackageID = 8

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaCongTrinh'
				and sysTableID = (select sysTableID from sysTable where TableName = N'DT43')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 11, 1, 0, 0, NULL)

-- 2) Bảng kê phiếu nhập kho
select @sysReportID = sysReportID from sysReport where ReportName = N'Bảng kê phiếu nhập kho' and sysPackageID = 8

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaCongTrinh'
				and sysTableID = (select sysTableID from sysTable where TableName = N'DT42')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 11, 1, 0, 0, NULL)