Use CDT
declare @sysTableID int
select @sysTableID = sysTableID from sysTable where TableName = 'MTTDBOut'
UPDATE sysField Set LabelName = N'Ngày chứng từ', TabIndex = 1 where FieldName = 'NgayBKBRTTDB' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Năm', TabIndex = 7 where FieldName = 'NamBKBRTTDB' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Tháng', TabIndex = 4,  MinValue = 0 where FieldName = 'KyBKBRTTDB' and sysTableID = @sysTableID
UPDATE sysField Set  TabIndex = 0 where FieldName = 'MTTDBOutID' and sysTableID = @sysTableID


