-- 1) Insert DMThueCapCuc default data
IF NOT EXISTS (SELECT TOP 1 1 FROM DMThueCapCuc)
BEGIN
	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('101', N'Cục Thuế Thành phố Hà Nội', 'HAN')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('103', N'Cục Thuế Thành phố Hải Phòng', 'HPH')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('107', N'Cục Thuế Tỉnh Hải Dương', 'HDU')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('109', N'Cục Thuế Tỉnh Hưng Yên', 'HYE')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('111', N'Cục Thuế Tỉnh Hà Nam', 'HNA')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('113', N'Cục Thuế Tỉnh Nam Định', 'NDI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('115', N'Cục Thuế Tỉnh Thái Bình', 'TBI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('117', N'Cục Thuế Tỉnh Ninh Bình', 'NBI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('201', N'Cục Thuế Tỉnh Hà Giang', 'HGI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('203', N'Cục Thuế Tỉnh Cao Bằng', 'CBA')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('205', N'Cục Thuế Tỉnh Lào Cai', 'LCA')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('207', N'Cục Thuế Tỉnh Bắc Cạn', 'BCA')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('209', N'Cục Thuế Tỉnh Lạng Sơn', 'LSO')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('211', N'Cục Thuế Tỉnh Tuyên Quang', 'TQU')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('213', N'Cục Thuế Tỉnh Yên Bái', 'YBA')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('215', N'Cục Thuế Tỉnh Thái Nguyên', 'TNG')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('217', N'Cục Thuế Tỉnh Phú Thọ', 'PTH')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('219', N'Cục Thuế Tỉnh Vĩnh Phúc', 'VPH')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('221', N'Cục Thuế Tỉnh Bắc Giang', 'BGI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('223', N'Cục Thuế Tỉnh Bắc Ninh', 'BNI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('225', N'Cục Thuế Tỉnh Quảng Ninh', 'QNI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('301', N'Cục Thuế Tỉnh Điện Biên', 'DBI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('302', N'Cục Thuế Tỉnh Lai Châu', 'LCH')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('303', N'Cục Thuế Tỉnh Sơn La', 'SLA')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('305', N'Cục Thuế Tỉnh Hoà Bình', 'HBI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('401', N'Cục Thuế Tỉnh Thanh Hoá', 'THO')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('403', N'Cục Thuế Tỉnh Nghệ An', 'NAN')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('405', N'Cục Thuế Tỉnh Hà Tĩnh', 'HTI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('407', N'Cục Thuế Tỉnh Quảng Bình', 'QBI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('409', N'Cục Thuế Tỉnh Quảng Trị', 'QTR')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('411', N'Cục Thuế Tỉnh TT-Huế', 'TTH')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('501', N'Cục Thuế TP Đà Nẵng', 'DAN')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('503', N'Cục Thuế Tỉnh Quảng Nam', 'QNA')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('505', N'Cục Thuế Tỉnh Quảng Ngãi', 'QNG')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('507', N'Cục Thuế Tỉnh Bình Định', 'BDI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('509', N'Cục Thuế Tỉnh Phú Yên', 'PHY')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('511', N'Cục Thuế Tỉnh Khánh Hoà', 'KHH')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('601', N'Cục Thuế Tỉnh Kon Tum', 'KTU')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('603', N'Cục Thuế Tỉnh Gia Lai', 'GLA')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('605', N'Cục Thuế Tỉnh Đắk Lắk', 'DLA')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('606', N'Cục Thuế Tỉnh Đắk Nông', 'DNO')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('701', N'Cục Thuế Thành phố Hồ Chí Minh', 'HCM')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('703', N'Cục Thuế Tỉnh Lâm Đồng', 'LDO')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('705', N'Cục Thuế Tỉnh Ninh Thuận', 'NTH')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('707', N'Cục Thuế Tỉnh Bình Phước', 'BPH')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('709', N'Cục Thuế Tỉnh Tây Ninh', 'TNI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('711', N'Cục Thuế Tỉnh Bình Dương', 'BDU')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('713', N'Cục Thuế Tỉnh Đồng Nai', 'DON')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('715', N'Cục Thuế Tỉnh Bình Thuận', 'BTH')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('717', N'Cục Thuế Tỉnh Bà Rịa - Vũng Tàu', 'BRV')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('801', N'Cục Thuế Tỉnh Long An', 'LAN')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('803', N'Cục Thuế Tỉnh Đồng Tháp', 'DTH')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('805', N'Cục Thuế Tỉnh An Giang', 'AGI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('807', N'Cục Thuế Tỉnh Tiền Giang', 'TGI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('809', N'Cục Thuế Tỉnh Vĩnh Long', 'VLO')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('811', N'Cục Thuế Tỉnh Bến Tre', 'BTR')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('813', N'Cục Thuế Tỉnh Kiên Giang', 'KGI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('815', N'Cục Thuế Thành phố Cần Thơ', 'CTH')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('816', N'Cục Thuế Tỉnh Hậu Giang', 'HAG')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('817', N'Cục Thuế Tỉnh Trà Vinh', 'TVI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('819', N'Cục Thuế Tỉnh Sóc Trăng', 'STR')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('821', N'Cục Thuế Tỉnh Bạc Liêu', 'BLI')

	INSERT INTO DMThueCapCuc (TaxDepartmentID, TaxDepartmentName, ShortTaxDepartment)
	VALUES ('823', N'Cục Thuế Tỉnh Cà Mau', 'CMA')
END