use [CDT]

declare @sysTableID int

select @sysTableID = sysTableID from sysTable
where TableName = 'TTDBOut'

Update sysField set Formula = N'@PSNT_TTDB/(1+ (@ThueSuatTTDB/100))'
where sysTableID = @sysTableID and FieldName = 'PS1NT_TTDB' and Formula = N'@PSNT_TTDB/(1+@ThueSuatTTDB)'

Update sysField set Formula = N'@PS_TTDB/(1+ (@ThueSuatTTDB/100))'
where sysTableID = @sysTableID and FieldName = 'PS1_TTDB' and Formula = N'@PS_TTDB/(1+@ThueSuatTTDB)'