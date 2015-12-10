-- 1) Insert DMGH default data
IF NOT EXISTS (SELECT TOP 1 1 FROM DMGH)
BEGIN
	INSERT INTO DMGH (ExtenID, ExtenName, ExtenName2, Notes, [Disabled])
	VALUES ('01', N'Doanh nghiệp có quy mô nhỏ và vừa', NULL, NULL, 0)

	INSERT INTO DMGH (ExtenID, ExtenName, ExtenName2, Notes, [Disabled])
	VALUES ('02', N'Doanh nghiệp sử dụng nhiều lao động', NULL, NULL, 0)

	INSERT INTO DMGH (ExtenID, ExtenName, ExtenName2, Notes, [Disabled])
	VALUES ('03', N'Doanh nghiệp đầu tư – kinh doanh (bán, cho thuê, cho thuê mua) nhà ở', NULL, NULL, 0)

	INSERT INTO DMGH (ExtenID, ExtenName, ExtenName2, Notes, [Disabled])
	VALUES ('99', N'Lý do khác', NULL, NULL, 0)
END