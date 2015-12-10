-- [ACC_THỊNH PHÁT] Số chứng từ của phiếu kế toán không tăng tự động
USE [CDT]

declare @sysTableID int,
		@MaCT varchar(50),
		@EditMask varchar(50)

select @sysTableID = sysTableID from sysTable
					where TableName = 'MT51'

select @MaCT= DefaultValue from sysField where sysTableID = @sysTableID and FieldName = 'MaCT'

set @EditMask = @MaCT + 
				(select case when Month(GETDATE()) < 10 then '0' + convert(varchar(2),Month(GETDATE())) else '' + convert(varchar(2),Month(GETDATE())) end) + 
				'/001'

Update sysField set EditMask = @EditMask
where sysTableID = @sysTableID
and FieldName = 'SoCT'
and EditMask is NULL