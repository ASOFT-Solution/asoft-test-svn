use [CDT]

declare @sysReportID int,
		@sysFieldID int,
		@sysNewFieldID int

select @sysReportID = sysReportID from sysReport
where ReportName = N'Sổ đăng ký Chứng từ ghi sổ'

-- Update CTGS condition
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'SoHieu'
				and sysTableID = (select sysTableID from sysTable where TableName = 'CTGS')

select @sysNewFieldID = sysFieldID from SysField
				where FieldName = 'SoHieu'
				and sysTableID = (select sysTableID from sysTable where TableName = 'wFilterControl')
				
Update [dbo].[sysReportFilter] set [sysFieldID] = @sysNewFieldID
where [sysFieldID] = @sysFieldID and [sysReportID] = @sysReportID

-- Report query
Update sysReport set Query = N'select sohieu, ngayct as [Ngày CT], ndkt, sum(psno) as [Số tiền], b.soct
from ctgs s, bltk b
where s.mact = b.mact and @@ps
group by sohieu, ngayct, ndkt, b.soct
order by sohieu, ngayct
'
where sysReportID = @sysReportID