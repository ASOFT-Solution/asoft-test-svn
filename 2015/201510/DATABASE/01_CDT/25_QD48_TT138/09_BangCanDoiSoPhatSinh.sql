use [CDT]
declare @sysReportID int,
		@sysFieldID int,
		@FilterControlID int

select @sysReportID = sysReportID from sysReport
where ReportName = N'Bảng cân đối số phát sinh'

if not exists (select top 1 1 from sysFormReport where ReportName = N'Bảng cân đối số phát sinh (*)' and sysReportID = @sysReportID)
insert into sysFormReport (sysReportID, ReportName, ReportFile, ReportName2)
				  values (@sysReportID, N'Bảng cân đối số phát sinh (*)', N'BCDPSTK_THANG', N'Arising amounts balance sheet')

