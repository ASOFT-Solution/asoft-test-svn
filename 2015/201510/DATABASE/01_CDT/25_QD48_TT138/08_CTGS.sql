use [CDT]

declare @sysReportID int,
		@sysFieldID int,
		@sysNewFieldID int

select @sysReportID = sysReportID from sysReport
where ReportName = N'Chứng từ ghi sổ'

-- Update CTGS condition
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaNT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 2, 1, 0, 0, NULL)

-- Report query
Update sysReport set Query = N'select b.mact as [Mã chứng từ], DienGiai as [Trích yếu], Tk as [Tài khoản nợ], TkDu as [Tài khoản có], MaNt as [Mã nguyên tệ], Tygia as [Tỷ giá], 
PsNo as [Số tiền], PsNoNt as [Số tiền nguyên tệ], SoCT as [Ghi chú]
from BLTK b, CTGS c
where b.MaCT = c.MaCT and psNo > 0 and @@ps
order by SoCT
'
where sysReportID = @sysReportID