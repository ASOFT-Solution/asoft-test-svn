Use CDT
declare @sysTableID int
select @sysTableID = sysTableID from sysTable where TableName = 'MToKhaiTTDB'
UPDATE sysField Set AllowNull = 1 where FieldName = 'KyToKhaiTTDB' and sysTableID = @sysTableID
UPDATE sysField Set MinValue = 0 where FieldName = 'SoLanIn' and sysTableID = @sysTableID