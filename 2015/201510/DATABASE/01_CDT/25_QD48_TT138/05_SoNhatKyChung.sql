use [CDT]
declare @sysReportID int,
		@sysFieldID int

select @sysReportID = sysReportID from sysReport
where ReportName = N'Sổ nhật ký chung'

-- Add GradeTK condition
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaNT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')
				
if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, N'VND', @sysReportID, 0, 1, 1, 1, 0, NULL)


-- Report query
Update sysReport set Query = N'declare @tungay datetime
declare @denngay datetime 

set @tungay = @@Ngayct1
set @denngay = DATEADD(hh,23,@@Ngayct2)

Select mact, dbo.LayNgayGhiSo(NgayCT) as [Ngày ghi sổ], 
SoCt, NgayCT, DienGiai, 
Tk, Tkdu, MaNt,tygia, PsNoNt, PsCoNt,PsNo, Psco, '''' as [Ghi chú]
from bltk
where @@ps and NgayCt between @tungay and @denngay 
order by NgayCT, MTID, MTIDDT, NhomDK
'
where sysReportID = @sysReportID