Use CDT
declare @sysTableID int
select @sysTableID = sysTableID from sysTable where TableName = 'DTTDBOut'
UPDATE sysField Set LabelName = N'Ký hiệu', TabIndex = 3 where FieldName = 'SoSeries' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Số', TabIndex = 4 where FieldName = 'SoHoaDon' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Ngày, tháng, năm phát hành', TabIndex = 5 where FieldName = 'NgayHD' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Tên khách hàng', TabIndex = 6 where FieldName = 'TenKH' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Tên hàng hóa dịch vụ', TabIndex = 7 where FieldName = 'TenVT' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Số lượng', TabIndex = 8 where FieldName = 'SoLuong' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Giá NT', TabIndex = 9 where FieldName = 'GiaNT' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Giá', TabIndex = 10 where FieldName = 'Gia' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Thành tiền NT', TabIndex = 11 where FieldName = 'PsNT' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Thành tiền', TabIndex = 12 where FieldName = 'Ps' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Nhóm hàng hóa dịch vụ', TabIndex = 13 where FieldName = 'MaNhomTTDB' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Thuế suất', TabIndex = 14 where FieldName = 'ThueSuatTTDB' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Tiền thuế NT', TabIndex = 15 where FieldName = 'TienTTDBNT' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Tiền thuế', TabIndex = 16 where FieldName = 'TienTTDB' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Giá tính thuế TTDB NT', TabIndex = 17 where FieldName = 'Ps1NT' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Giá tính thuế TTDB', TabIndex = 18 where FieldName = 'Ps1' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Số thứ tự', TabIndex = 19 where FieldName = 'Stt' and sysTableID = @sysTableID
UPDATE sysField Set LabelName = N'Ngày chứng từ', TabIndex = 20 where FieldName = 'NgayCt' and sysTableID = @sysTableID
