Use CDT
declare @sysTableID int
select @sysTableID = sysTableID from sysTable where TableName = 'MTTDBIn'
UPDATE sysField Set LabelName = N'Ngày chứng từ', TabIndex = 2 where FieldName = 'NgayBKMVTTDB' and sysTableID = @sysTableID
UPDATE sysField Set TabIndex = 8, LabelName = N'Năm' where FieldName = 'NamBKMVTTDB' and sysTableID = @sysTableID
UPDATE sysField Set TabIndex = 3 where FieldName = 'DienGiai' and sysTableID = @sysTableID
UPDATE sysField Set TabIndex = 4 where FieldName = 'MaNT' and sysTableID = @sysTableID
UPDATE sysField Set TabIndex = 6, LabelName = N'Tháng', AllowNull = 1 where FieldName = 'KyBKMVTTDB' and sysTableID = @sysTableID
UPDATE sysField Set TabIndex = 10 where FieldName = 'ITotal7NT' and sysTableID = @sysTableID
UPDATE sysField Set TabIndex = 11 where FieldName = 'ITotal7' and sysTableID = @sysTableID
UPDATE sysField Set TabIndex = 12 where FieldName = 'ITotal9NT' and sysTableID = @sysTableID
UPDATE sysField Set TabIndex = 13 where FieldName = 'ITotal9' and sysTableID = @sysTableID
UPDATE sysField Set TabIndex = 14 where FieldName = 'ITotal10NT' and sysTableID = @sysTableID
UPDATE sysField Set TabIndex = 15 where FieldName = 'ITotal10' and sysTableID = @sysTableID
UPDATE sysField Set TabIndex = 16 where FieldName = 'IITotal7NT' and sysTableID = @sysTableID
UPDATE sysField Set TabIndex = 17 where FieldName = 'IITotal7' and sysTableID = @sysTableID







