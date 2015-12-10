-- 1) Insert DMNN default data
IF NOT EXISTS (SELECT TOP 1 1 FROM DMNN)
BEGIN
	INSERT INTO DMNN (TaxType, VocationID, VocationName, VocationName2, Notes, [Disabled])
	VALUES ('GTGT', '1701', N'Ngành hàng sản xuất, kinh doanh thông thường', NULL, NULL, 0)

	INSERT INTO DMNN (TaxType, VocationID, VocationName, VocationName2, Notes, [Disabled])
	VALUES ('GTGT', '1704', N'Từ hoạt động thăm dò, phát triển mỏ và khai thác dầu, khí thiên nhiên', NULL, NULL, 0)

	INSERT INTO DMNN (TaxType, VocationID, VocationName, VocationName2, Notes, [Disabled])
	VALUES ('GTGT', '1705', N'Từ hoạt động xổ số kiến thiết của các công ty xổ số kiến thiết', NULL, NULL, 0)

	INSERT INTO DMNN (TaxType, VocationID, VocationName, VocationName2, Notes, [Disabled])
	VALUES ('TNDN', '1052', N'Ngành hàng sản xuất, kinh doanh thông thường', NULL, NULL, 0)

	INSERT INTO DMNN (TaxType, VocationID, VocationName, VocationName2, Notes, [Disabled])
	VALUES ('TNDN', '1056', N'Từ hoạt động thăm dò, phát triển mỏ và khai thác dầu, khí thiên nhiên', NULL, NULL, 0)

	INSERT INTO DMNN (TaxType, VocationID, VocationName, VocationName2, Notes, [Disabled])
	VALUES ('TNDN', '1057', N'Từ hoạt động xổ số kiến thiết của các công ty xổ số kiến thiết', NULL, NULL, 0)

	INSERT INTO DMNN (TaxType, VocationID, VocationName, VocationName2, Notes, [Disabled])
	VALUES ('TTDB', '0000', N'Ngành hàng sản xuất, kinh doanh thông thường', NULL, NULL, 0)

	INSERT INTO DMNN (TaxType, VocationID, VocationName, VocationName2, Notes, [Disabled])
	VALUES ('TTDB', '1761', N'Từ hoạt động xổ số kiến thiết của các công ty xổ số kiến thiết', NULL, NULL, 0)
END