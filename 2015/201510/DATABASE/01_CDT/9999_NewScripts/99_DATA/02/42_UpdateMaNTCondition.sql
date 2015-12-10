Use CDT

-- Update filter
declare @sysReportID int,
		@sysFieldID int

-- Sổ nhật ký chung
select @sysReportID = sysReportID from sysReport
where ReportName = N'Sổ nhật ký chung'

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaNT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')
				
Update [sysReportFilter] set AllowNull = 1
where [sysFieldID] = @sysFieldID and sysReportID = @sysReportID and AllowNull = 0
