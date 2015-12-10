use [CDT]

declare @sysTableID int

select @sysTableID = sysTableID from sysTable where TableName = N'DT23'

update sysField set Formula = N'(@PsNT-@TienCKNT)*@ThueSuatNk/100' where sysTableID = @sysTableID and FieldName = N'CtThueNkNT'
update sysField set Formula = N'(@Ps-@TienCK)*@ThueSuatNk/100' where sysTableID = @sysTableID and FieldName = N'CtThueNk'