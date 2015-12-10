-- 1) Insert DMThueCapQL default data
IF NOT EXISTS (SELECT TOP 1 1 FROM DMThueCapQL)
BEGIN
	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10100', N'Cục Thuế Thành phố Hà Nội')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10101', N'Chi cục Thuế Quận Ba Đình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10103', N'Chi cục Thuế Quận Tây Hồ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10105', N'Chi cục Thuế Quận Hoàn Kiếm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10106', N'Chi cục thuế Quận Long Biên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10107', N'Chi cục Thuế Quận Hai Bà Trưng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10108', N'Chi cục thuế Quận Hoàng Mai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10109', N'Chi cục Thuế Quận Đống đa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10111', N'Chi cục Thuế Quận Thanh Xuân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10113', N'Chi cục Thuế Quận Cầu Giấy')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10115', N'Chi cục Thuế Huyện Sóc sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10117', N'Chi cục Thuế Huyện Đông Anh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10119', N'Chi cục Thuế Huyện Gia Lâm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10121', N'Chi cục Thuế Huyện Từ Liêm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10123', N'Chi cục Thuế Huyện Thanh Trì')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10125', N'Chi cục Thuế Huyện Mê Linh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10127', N'Chi cục Thuế Quận Hà Đông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10129', N'Chi cục Thuế Thị xã Sơn Tây')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10131', N'Chi cục Thuế Huyện Phúc Thọ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10133', N'Chi cục Thuế Huyện Đan Phượng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10135', N'Chi cục Thuế Huyện Thạch Thất')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10137', N'Chi cục Thuế Huyện Hoài Đức')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10139', N'Chi cục Thuế Huyện Quốc Oai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10141', N'Chi cục Thuế Huyện Thanh Oai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10143', N'Chi cục Thuế Huyện Thường Tín')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10145', N'Chi cục Thuế Huyện Mỹ Đức')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10147', N'Chi cục Thuế Huyện ứng Hoà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10149', N'Chi cục Thuế Huyện Phú Xuyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10151', N'Chi cục Thuế Huyện Ba Vì')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10153', N'Chi cục Thuế Huyện Chương Mỹ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10155', N'Chi cục Thuế Quận Nam Từ Liêm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('101', '10157', N'Chi cục Thuế Quận Bắc Từ Liêm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10300', N'Cục Thuế TP Hải Phòng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10301', N'Chi cục Thuế Quận Hồng Bàng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10303', N'Chi cục Thuế Quận Ngô Quyền')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10304', N'Chi cục Thuế Quận Hải An')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10305', N'Chi cục Thuế Quận Lê Chân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10307', N'Chi cục Thuế Quận Kiến An')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10309', N'Chi cục Thuế Quận Đồ Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10311', N'Chi cục Thuế Huyện Thuỷ Nguyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10313', N'Chi cục Thuế Huyện An Dương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10315', N'Chi cục Thuế Huyện An Lão')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10317', N'Chi cục Thuế Huyện Kiến Thuỵ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10319', N'Chi cục Thuế Huyện Tiên Lãng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10321', N'Chi cục Thuế Huyện Vĩnh Bảo')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10323', N'Chi cục Thuế Huyện Cát Hải')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10325', N'Chi cục Thuế Huyện Bạch Long Vĩ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('103', '10327', N'Chi cục Thuế Quận Dương Kinh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('107', '10700', N'Cục Thuế Tỉnh Hải Dương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('107', '10701', N'Chi cục Thuế Thành phố Hải Dương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('107', '10703', N'Chi cục Thuế Thị xã Chí Linh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('107', '10705', N'Chi cục Thuế Huyện Nam Sách')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('107', '10707', N'Chi cục Thuế Huyện Thanh Hà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('107', '10709', N'Chi cục Thuế Huyện Kinh Môn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('107', '10711', N'Chi cục Thuế Huyện Kim Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('107', '10713', N'Chi cục Thuế Huyện Gia Lộc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('107', '10715', N'Chi cục Thuế Huyện Tứ Kỳ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('107', '10717', N'Chi cục Thuế Huyện Cẩm Giàng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('107', '10719', N'Chi cục Thuế Huyện Bình Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('107', '10721', N'Chi cục Thuế Huyện Thanh Miện')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('107', '10723', N'Chi cục Thuế Huyện Ninh Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('109', '10900', N'Cục Thuế Tỉnh Hưng Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('109', '10901', N'Chi cục Thuế Thành phố Hưng yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('109', '10903', N'Chi cục Thuế Huyện Mỹ Hào')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('109', '10905', N'Chi cục Thuế Huyện Khoái Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('109', '10907', N'Chi cục Thuế Huyện Ân Thi')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('109', '10909', N'Chi cục Thuế Huyện Kim Động')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('109', '10911', N'Chi cục Thuế Huyện Phù Cừ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('109', '10913', N'Chi cục Thuế Huyện Tiên Lữ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('109', '10915', N'Chi cục Thuế Huyện Văn Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('109', '10917', N'Chi cục Thuế Huyện Văn Lâm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('109', '10919', N'Chi cục Thuế Huyện Yên Mỹ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('111', '11100', N'Cục Thuế Tỉnh Hà Nam')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('111', '11101', N'Chi cục Thuế Thành phố Phủ Lý')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('111', '11103', N'Chi cục Thuế Huyện Duy Tiên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('111', '11105', N'Chi cục Thuế Huyện Kim Bảng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('111', '11107', N'Chi cục Thuế Huyện Lý Nhân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('111', '11109', N'Chi cục Thuế Huyện Thanh Liêm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('111', '11111', N'Chi cục Thuế Huyện Bình Lục')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('113', '11300', N'Cục Thuế Tỉnh Nam Định')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('113', '11301', N'Chi cục Thuế Thành phố Nam Đinh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('113', '11303', N'Chi cục Thuế Huyện Vụ Bản')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('113', '11305', N'Chi cục Thuế Huyện Mỹ Lộc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('113', '11307', N'Chi cục Thuế Huyện ý Yên                          ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('113', '11309', N'Chi cục Thuế Huyện Nam Trực')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('113', '11311', N'Chi cục Thuế Huyện Trực Ninh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('113', '11313', N'Chi cục Thuế Huyện Xuân Trường')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('113', '11315', N'Chi cục Thuế Huyện Giao Thuỷ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('113', '11317', N'Chi cục Thuế Huyện Nghĩa Hưng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('113', '11319', N'Chi cục Thuế Huyện Hải Hậu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('115', '11500', N'Cục Thuế Tỉnh Thái Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('115', '11501', N'Chi cục Thuế Thành phố Thái Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('115', '11503', N'Chi cục Thuế Huyện Quỳnh Phụ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('115', '11505', N'Chi cục Thuế Huyện Hưng Hà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('115', '11507', N'Chi cục Thuế Huyện Thái Thuỵ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('115', '11509', N'Chi cục Thuế Huyện Đông Hưng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('115', '11511', N'Chi cục Thuế Huyện Vũ Thư')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('115', '11513', N'Chi cục Thuế Huyện Kiến Xương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('115', '11515', N'Chi cục Thuế Huyện Tiền hải')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('117', '11700', N'Cục Thuế Tỉnh Ninh Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('117', '11701', N'Chi cục Thuế Thành phố Ninh Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('117', '11703', N'Chi cục Thuế Thị xã Tam Điệp')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('117', '11705', N'Chi cục Thuế Huyện Nho quan')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('117', '11707', N'Chi cục Thuế Huyện Gia Viễn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('117', '11709', N'Chi cục Thuế Huyện Hoa Lư')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('117', '11711', N'Chi cục Thuế Huyện Yên Mô')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('117', '11713', N'Chi cục Thuế Huyện Yên Khánh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('117', '11715', N'Chi cục Thuế Huyện Kim Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('201', '20100', N'Cục Thuế Tỉnh Hà Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('201', '20101', N'Chi cục Thuế Thị xã Hà Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('201', '20103', N'Chi cục Thuế Huyện Đồng Văn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('201', '20105', N'Chi cục Thuế Huyện Mèo Vạc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('201', '20107', N'Chi cục Thuế Huyện Yên Minh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('201', '20109', N'Chi cục Thuế Huyện Quản Bạ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('201', '20111', N'Chi cục Thuế Huyện Bắc Mê')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('201', '20113', N'Chi cục Thuế Huyện Hoàng Su Phì')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('201', '20115', N'Chi cục Thuế Huyện Vị Xuyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('201', '20117', N'Chi cục Thuế Huyện Xín Mần')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('201', '20118', N'Chi cục thuế Huyện Quang Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('201', '20119', N'Chi cục Thuế Huyện Bắc Quang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20300', N'Cục Thuế Tỉnh Cao Bằng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20301', N'Chi cục Thuế Thị xã Cao Bằng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20303', N'Chi cục Thuế Huyện Bảo Lạc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20305', N'Chi cục Thuế Huyện Hà Quảng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20307', N'Chi cục Thuế Huyện Thông Nông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20309', N'Chi cục Thuế Huyện Trà Lĩnh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20311', N'Chi cục Thuế Huyện Trùng Khánh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20313', N'Chi cục Thuế Huyện Nguyên Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20315', N'Chi cục Thuế Huyện Hoà An')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20317', N'Chi cục Thuế Huyện Quảng Uyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20318', N'Chi cục thuế Huyện Phục Hoà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20319', N'Chi cục Thuế Huyện Hạ Lang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20321', N'Chi cục Thuế Huyện Thạch An')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('203', '20323', N'Chi cục Thuế  Huyện Bảo Lâm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('205', '20500', N'Cục Thuế Tỉnh Lào Cai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('205', '20501', N'Chi cục Thuế Thành phố Lào Cai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('205', '20505', N'Chi cục Thuế Huyện Mường Khương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('205', '20507', N'Chi cục Thuế Huyện Bát Xát')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('205', '20509', N'Chi cục Thuế Huyện Bắc Hà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('205', '20511', N'Chi cục Thuế Huyện Bảo Thắng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('205', '20513', N'Chi cục Thuế Huyện Sa Pa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('205', '20515', N'Chi cục Thuế Huyện Bảo Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('205', '20519', N'Chi cục Thuế Huyện Văn Bàn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('205', '20521', N'Chi cục Thuế Huyện Si Ma Cai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('207', '20700', N'Cục Thuế Tỉnh Bắc Cạn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('207', '20701', N'Chi cục Thuế Thị xã Bắc Cạn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('207', '20703', N'Chi cục Thuế Huyện Ba Bể')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('207', '20704', N'Chi cục Thuế Huyện Pác Nặm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('207', '20705', N'Chi cục Thuế Huyện Ngân Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('207', '20707', N'Chi cục Thuế Huyện Chợ Đồn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('207', '20709', N'Chi cục Thuế Huyện Na Rì')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('207', '20711', N'Chi cục Thuế Huyện Bạch Thông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('207', '20713', N'Chi cục Thuế Huyện Chợ mới')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('209', '20900', N'Cục Thuế Tỉnh Lạng Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('209', '20901', N'Chi cục Thuế Thành phố Lạng Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('209', '20903', N'Chi cục Thuế Huyện Tràng Định')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('209', '20905', N'Chi cục Thuế Huyện Văn Lãng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('209', '20907', N'Chi cục Thuế Huyện Bình Gia')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('209', '20909', N'Chi cục Thuế Huyện Bắc Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('209', '20911', N'Chi cục Thuế Huyện Văn Quan')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('209', '20913', N'Chi cục Thuế Huyện Cao Lộc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('209', '20915', N'Chi cục Thuế Huyện Lộc Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('209', '20917', N'Chi cục Thuế Huyện Chi Lăng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('209', '20919', N'Chi cục Thuế Huyện Đình Lập')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('209', '20921', N'Chi cục Thuế Huyện Hữu Lũng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('211', '21100', N'Cục Thuế Tỉnh Tuyên Quang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('211', '21101', N'Chi cục Thuế Thành phố Tuyên Quang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('211', '21103', N'Chi cục Thuế Huyện Nà Hang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('211', '21105', N'Chi cục Thuế Huyện Chiêm Hoá')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('211', '21107', N'Chi cục Thuế Huyện Hàm Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('211', '21109', N'Chi cục Thuế Huyện Yên Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('211', '21111', N'Chi cục Thuế Huyện Sơn Dương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('211', '21113', N'Chi Cục Thuế huyện Lâm Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('213', '21300', N'Cục Thuế Tỉnh Yên Bái')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('213', '21301', N'Chi cục Thuế TP Yên Bái')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('213', '21303', N'Chi cục Thuế Thị xã Nghĩa Lộ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('213', '21305', N'Chi cục Thuế Huyện Lục Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('213', '21307', N'Chi cục Thuế Huyện Văn Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('213', '21309', N'Chi cục Thuế Huyện Mù Cang Chải')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('213', '21311', N'Chi cục Thuế Huyện Trấn Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('213', '21313', N'Chi cục Thuế Huyện Yên Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('213', '21315', N'Chi cục Thuế Huyện Văn Chấn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('213', '21317', N'Chi cục Thuế Huyện Trạm Tấu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('215', '21500', N'Cục Thuế Tỉnh Thái Nguyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('215', '21501', N'Chi cục Thuế Thành phố Thái Nguyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('215', '21503', N'Chi cục Thuế Thị xã Sông Công')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('215', '21505', N'Chi cục Thuế Huyện Định Hoá')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('215', '21507', N'Chi cục Thuế Huyện Võ Nhai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('215', '21509', N'Chi cục Thuế Huyện Phú Lương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('215', '21511', N'Chi cục Thuế Huyện Đồng Hỷ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('215', '21513', N'Chi cục Thuế Huyện Đại Từ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('215', '21515', N'Chi cục Thuế Huyện Phú Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('215', '21517', N'Chi cục Thuế Huyện Phổ Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21700', N'Cục Thuế Tỉnh Phú Thọ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21701', N'Chi cục Thuế Thành phố Việt Trì')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21703', N'Chi cục Thuế Thị xã Phú Thọ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21705', N'Chi cục Thuế Huyện Đoan Hùng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21707', N'Chi cục Thuế Huyện Hạ Hoà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21709', N'Chi cục Thuế Huyện Thanh Ba')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21711', N'Chi cục Thuế Huyện Phù Ninh                       ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21713', N'Chi cục Thuế Huyện Cẩm Khê')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21715', N'Chi cục Thuế Huyện Yên Lập')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21717', N'Chi cục Thuế Huyện Tam Nông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21719', N'Chi cục Thuế Huyện Thanh Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21720', N'Chi cục Thuế Huyện Tân Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21721', N'Chi cục Thuế Huyện Lâm Thao')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('217', '21723', N'Chi cục Thuế Huyện Thanh Thuỷ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('219', '21900', N'Cục Thuế Tỉnh Vĩnh Phúc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('219', '21901', N'Chi cục Thuế Thành phố Vĩnh Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('219', '21902', N'Chi cục Thuế Thị xã Phúc Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('219', '21903', N'Chi cục Thuế Huyện Lập Thạch')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('219', '21904', N'Chi cục Thuế Huyện Tam đảo')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('219', '21905', N'Chi cục Thuế Huyện Tam Dương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('219', '21907', N'Chi cục Thuế Huyện Vĩnh Tường')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('219', '21909', N'Chi cục Thuế Huyện Yên Lạc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('219', '21913', N'Chi cục Thuế Huyện Bình Xuyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('219', '21915', N'Chi cục thuế Huyện Sông Lô')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('221', '22100', N'Cục Thuế Tỉnh Bắc Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('221', '22101', N'Chi cục Thuế Thành phố Bắc Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('221', '22103', N'Chi cục Thuế Huyện Yên Thế')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('221', '22105', N'Chi cục Thuế Huyện Tân Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('221', '22107', N'Chi cục Thuế Huyện Lục Ngạn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('221', '22109', N'Chi cục Thuế Huyện Hiệp Hoà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('221', '22111', N'Chi cục Thuế Huyện Lạng Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('221', '22113', N'Chi cục Thuế Huyện Sơn Động')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('221', '22115', N'Chi cục Thuế Huyện Lục Nam')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('221', '22117', N'Chi cục Thuế Huyện Việt Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('221', '22119', N'Chi cục Thuế Huyện Yên Dũng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('223', '22300', N'Cục Thuế Tỉnh Bắc Ninh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('223', '22301', N'Chi cục Thuế Thành phố Bắc Ninh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('223', '22303', N'Chi cục Thuế Huyện Yên Phong')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('223', '22305', N'Chi cục Thuế Huyện Quế Võ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('223', '22307', N'Chi cục Thuế Huyện Tiên Du')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('223', '22309', N'Chi cục Thuế Huyện Thuận Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('223', '22311', N'Chi cục Thuế Huyện Lương Tài')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('223', '22313', N' Chi cục Thuế Thị xã Từ Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('223', '22315', N'Chi cục Thuế Huyện Gia Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22500', N'Cục Thuế Tỉnh Quảng Ninh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22501', N'Chi cục Thuế TP Hạ Long')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22503', N'Chi cục Thuế Thị xã Cẩm Phả')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22505', N'Chi cục Thuế Thị xã Uông Bí')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22507', N'Chi cục Thuế Huyện Bình Liêu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22509', N'Chi cục thuế Thành phố Móng cái')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22511', N'Chi cục Thuế Huyện Hải Hà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22513', N'Chi cục Thuế Huyện Tiên Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22515', N'Chi cục Thuế Huyện Ba Chẽ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22517', N'Chi cục Thuế Huyện Vân Đồn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22519', N'Chi cục Thuế Huyện Hoành Bồ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22521', N'Chi cục Thuế Huyện Đông Triều')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22523', N'Chi cục Thuế Huyện Cô Tô')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22525', N'Chi cục Thuế Huyện Yên Hưng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('225', '22527', N'Chi cục thuế Huyện Đầm Hà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('301', '30100', N'Cục Thuế Tỉnh Điện Biên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('301', '30101', N'Chi cục TP Điện Biên Phủ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('301', '30103', N'Chi cục Thuế Thị xã Mường Lay')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('301', '30104', N'Chi cục thuế Huyện Mường Nhé')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('301', '30111', N'Chi cục Thuế Huyện Mường Chà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('301', '30113', N'Chi cục Thuế Huyện Tủa Chùa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('301', '30115', N'Chi cục Thuế Huyện Tuần Giáo')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('301', '30117', N'Chi cục Thuế Huyện Điện Biên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('301', '30119', N'Chi cục Thuế Huyện Điện Biên Đông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('301', '30121', N'Chi cục Thuế Huyện Mường ảng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('301', '30123', N'Chi cục Thuế Huyện Nậm Pồ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('302', '30200', N'Cục Thuế Tỉnh Lai Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('302', '30201', N'Chi cục Thuế Huyện Mường Tè')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('302', '30202', N'Chi cục Thuế Thành phố Lai Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('302', '30203', N'Chi cục Thuế Huyện Phong Thổ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('302', '30205', N'Chi cục Thuế Huyện Tam Đường')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('302', '30207', N'Chi cục Thuế Huyện Sìn Hồ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('302', '30209', N'Chi cục Thuế Huyện Than Uyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('302', '30211', N'Chi cục Thuế Huyện Tân Uyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('302', '30213', N'Chi cục Thuế Huyện Nậm Nhùn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('303', '30300', N'Cục Thuế Tỉnh Sơn La')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('303', '30301', N'Chi cục Thuế Thành phố Sơn La')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('303', '30303', N'Chi cục Thuế Huyện Quỳnh Nhai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('303', '30305', N'Chi cục Thuế Huyện Mường La')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('303', '30307', N'Chi cục Thuế Huyện Thuận Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('303', '30309', N'Chi cục Thuế Huyện Bắc Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('303', '30311', N'Chi cục Thuế Huyện Phù Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('303', '30313', N'Chi cục Thuế Huyện Mai Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('303', '30315', N'Chi cục Thuế Huyện Sông Mã')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('303', '30317', N'Chi cục Thuế Huyện Yên Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('303', '30319', N'Chi cục Thuế Huyện Mộc Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('303', '30321', N'Chi cục Thuế Huyện Sốp Cộp')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('303', '30323', N'Chi cục Thuế Huyện Vân Hồ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('305', '30500', N'Cục Thuế Tỉnh Hoà Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('305', '30501', N'Chi cục Thuế Thành phố Hoà Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('305', '30503', N'Chi cục Thuế Huyện Đà Bắc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('305', '30505', N'Chi cục Thuế Huyện Mai Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('305', '30507', N'Chi cục Thuế Huyện Kỳ Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('305', '30509', N'Chi cục Thuế Huyện Lương Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('305', '30510', N'Chi cục Thuế Huyện Cao Phong')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('305', '30511', N'Chi cục Thuế Huyện Kim Bôi')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('305', '30513', N'Chi cục Thuế Huyện Tân Lạc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('305', '30515', N'Chi cục Thuế Huyện Lạc Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('305', '30517', N'Chi cục Thuế Huyện Lạc Thuỷ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('305', '30519', N'Chi cục Thuế Huyện Yên Thuỷ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40100', N'Cục Thuế Tỉnh Thanh Hoá')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40101', N'Chi cục Thuế Thành phố Thanh Hoá')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40103', N'Chi cục Thuế Thị xã Bỉm Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40105', N'Chi cục Thuế Thị xã Sầm Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40107', N'Chi cục Thuế Huyện Mường Lát')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40109', N'Chi cục Thuế Huyện Quan Hoá')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40111', N'Chi cục Thuế Huyện Quan Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40113', N'Chi cục Thuế Huyện Bá Thước')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40115', N'Chi cục Thuế Huyện Cẩm Thuỷ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40117', N'Chi cục Thuế Huyện Lang Chánh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40119', N'Chi cục Thuế Huyện Thạch Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40121', N'Chi cục Thuế Huyện Ngọc Lặc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40123', N'Chi cục Thuế Huyện Thường Xuân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40125', N'Chi cục Thuế Huyện Như Xuân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40127', N'Chi cục Thuế Huyện Như Thanh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40129', N'Chi cục Thuế Huyện Vĩnh Lộc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40131', N'Chi cục Thuế Huyện Hà Trung')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40133', N'Chi cục Thuế Huyện Nga Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40135', N'Chi cục Thuế Huyện Yên Định')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40137', N'Chi cục Thuế Huyện Thọ Xuân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40139', N'Chi cục Thuế Huyện Hậu Lộc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40141', N'Chi cục Thuế Huyện Thiệu Hoá')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40143', N'Chi cục Thuế Huyện Hoằng Hoá')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40145', N'Chi cục Thuế Huyện Đông Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40147', N'Chi cục Thuế Huyện Triệu Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40149', N'Chi cục Thuế Huyện Quảng Xương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40151', N'Chi cục Thuế Huyện Nông Cống')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('401', '40153', N'Chi cục Thuế Huyện Tĩnh Gia')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40300', N'Cục Thuế Tỉnh Nghệ An')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40301', N'Chi cục Thuế Thành phố Vinh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40303', N'Chi cục Thuế Thị xã Cửa Lò')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40305', N'Chi cục Thuế Huyện Quế Phong')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40307', N'Chi cục Thuế Huyện Quỳ Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40309', N'Chi cục Thuế Huyện Kỳ Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40311', N'Chi cục Thuế Huyện Quỳ Hợp')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40313', N'Chị Cục thuế Huyện Nghĩa Đàn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40314', N'Chi cục Thuế Thị xã Thái Hoà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40315', N'Chi cục Thuế Huyện Tương Dương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40317', N'Chi cục Thuế Huyện Quỳnh Lưu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40319', N'Chi cục Thuế Huyện Tân Kỳ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40321', N'Chi cục Thuế Huyện Con Cuông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40323', N'Chi cục Thuế Huyện Yên Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40325', N'Chi cục Thuế Huyện Diễn Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40327', N'Chi cục Thuế Huyện Anh Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40329', N'Chi cục Thuế Huyện Đô Lương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40331', N'Chi cục Thuế Huyện Thanh Chương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40333', N'Chi cục Thuế Huyện Nghi Lộc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40335', N'Chi cục Thuế Huyện Nam Đàn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40337', N'Chi cục Thuế Huyện Hưng Nguyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('403', '40339', N'Chi cục Thuế Thị xã Hoàng Mai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('405', '40500', N'Cục Thuế Tỉnh Hà Tĩnh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('405', '40501', N'Chi cục Thuế Thành phố Hà Tĩnh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('405', '40503', N'Chi cục Thuế Thị xã Hồng Lĩnh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('405', '40505', N'Chi cục Thuế Huyện Nghi Xuân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('405', '40507', N'Chi cục Thuế Huyện Đức Thọ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('405', '40509', N'Chi cục Thuế Huyện Hương Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('405', '40511', N'Chi cục Thuế Huyện Can Lộc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('405', '40513', N'Chi cục Thuế Huyện Thạch Hà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('405', '40515', N'Chi cục Thuế Huyện Cẩm Xuyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('405', '40517', N'Chi cục Thuế Huyện Hương Khê')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('405', '40519', N'Chi cục Thuế Huyện Kỳ Anh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('405', '40521', N'Chi cục thuế Huyện Vũ Quang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('405', '40523', N'Chi cục Thuế Huyện Lộc Hà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('407', '40700', N'Cục Thuế Tỉnh Quảng Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('407', '40701', N'Chi cục Thuế Thành phố Đồng Hới')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('407', '40703', N'Chi cục Thuế Huyện Tuyên Hoá')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('407', '40705', N'Chi cục Thuế Huyện Minh Hoá')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('407', '40707', N'Chi cục Thuế H.Quảng Trạch')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('407', '40709', N'Chi cục Thuế Huyện Bố Trạch')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('407', '40711', N'Chi cục Thuế Huyện Quảng Ninh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('407', '40713', N'Chi cục Thuế Huyện Lệ Thuỷ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('407', '40715', N'Chi cục Thuế Thị xã Ba Đồn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('409', '40900', N'Cục Thuế Tỉnh Quảng Trị')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('409', '40901', N'Chi cục Thuế Thành phố Đông Hà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('409', '40903', N'Chi cục Thuế Thị xã Quảng Trị')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('409', '40905', N'Chi cục Thuế Huyện Vĩnh Linh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('409', '40907', N'Chi cục Thuế Huyện Gio Linh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('409', '40909', N'Chi cục Thuế Huyện Cam Lộ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('409', '40911', N'Chi cục Thuế Huyện Triệu Phong')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('409', '40913', N'Chi cục Thuế Huyện Hải Lăng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('409', '40915', N'Chi cục Thuế Huyện Hướng Hoá')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('409', '40917', N'Chi cục Thuế Huyện Đa Krông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('409', '40919', N'Chi cục Thuế Huyện  Đảo Cồn Cỏ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('411', '41100', N'Cục Thuế Tỉnh TT-Huế')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('411', '41101', N'CCT  Thành phố Huế')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('411', '41103', N'CCT Huyện Phong Điền')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('411', '41105', N'CCT Huyện Quảng Điền')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('411', '41107', N'CCT Huyện Hương Trà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('411', '41109', N'CCT Huyện Phú Vang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('411', '41111', N'CCT Thị xã Hương Thuỷ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('411', '41113', N'CCT Huyện Phú Lộc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('411', '41115', N'CCT Huyện A Lưới')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('411', '41117', N'CCT Huyện Nam Đông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('501', '50100', N'Cục Thuế TP Đà Nẵng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('501', '50101', N'Chi cục Thuế Quận Hải Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('501', '50103', N'Chi cục Thuế Quận Thanh Khê')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('501', '50105', N'Chi cục Thuế Quận Sơn Trà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('501', '50107', N'CCT Quận Ngũ Hành Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('501', '50109', N'Chi cục Thuế Quận Liên Chiểu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('501', '50111', N'Chi cục Thuế Huyện Hoà Vang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('501', '50113', N'Chi cục Thuế Huyện Đảo Hoàng Sa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('501', '50115', N'Chi cục thuế Quận Cẩm Lệ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50300', N'Cục Thuế Tỉnh Quảng Nam')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50301', N'Chi cục Thuế Thành phố Tam Kỳ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50302', N'Chi cục Thuế Huyện Phú Ninh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50303', N'Chi cục Thuế Thành phố Hội An')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50304', N'Chi cục thuế Huyện Tây Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50305', N'Chi cục thuế Huyện Đông Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50307', N'Chi cục Thuế Huyện Đại Lộc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50309', N'Chi cục Thuế Huyện Điện Bàn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50311', N'Chi cục Thuế Huyện Duy Xuyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50313', N'Chi cục Thuế Huyện Nam Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50315', N'Chi cục Thuế Huyện Thăng Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50317', N'Chi cục Thuế Huyện Quế Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50318', N'Chi cục thuế Huyện Nông Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50319', N'Chi cục Thuế Huyện Hiệp Đức')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50321', N'Chi cục Thuế Huyện Tiên Phước')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50323', N'Chi cục Thuế Huyện Phước Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50325', N'Chi cục Thuế Huyện Núi Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50327', N'Chi cục thuế Huyện Bắc Trà My')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('503', '50329', N'Chi cục thuế Huyện Nam Trà My')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50500', N'Cục Thuế Tỉnh Quảng Ngãi')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50501', N'Chi cục Thuế Thành phố Quảng Ngãi')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50503', N'Chi cục Thuế Huyện Lý Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50505', N'Chi cục Thuế Huyện Bình Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50507', N'Chi cục Thuế Huyện Trà Bồng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50508', N'Chi cục Thuế Huyện Tây Trà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50509', N'Chi cục Thuế Huyện Sơn Tịnh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50511', N'Chi cục Thuế Huyện Sơn Tây')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50513', N'Chi cục Thuế Huyện Sơn Hà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50515', N'Chi cục Thuế Huyện Tư Nghĩa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50517', N'Chi cục Thuế Huyện Nghĩa Hành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50519', N'Chi cục Thuế Huyện Minh Long')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50521', N'Chi cục Thuế Huyện Mộ Đức')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50523', N'Chi cục Thuế Huyện Đức Phổ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('505', '50525', N'Chi cục Thuế Huyện Ba Tơ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('507', '50700', N'Cục Thuế Tỉnh Bình Định')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('507', '50701', N'Chi cục Thuế Thành phố Quy Nhơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('507', '50703', N'Chi cục Thuế Huyện An Lão')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('507', '50705', N'Chi cục Thuế Huyện Hoài Nhơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('507', '50707', N'Chi cục Thuế Huyện Hoài ân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('507', '50709', N'Chi cục Thuế Huyện Phù Mỹ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('507', '50711', N'Chi cục Thuế Huyện Vĩnh Thạnh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('507', '50713', N'Chi cục Thuế Huyện Phù Cát')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('507', '50715', N'Chi cục Thuế Huyện Tây Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('507', '50717', N'Chi cục Thuế Huyện An Nhơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('507', '50719', N'Chi cục Thuế Huyện Tuy Phước')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('507', '50721', N'Chi cục Thuế Huyện Vân Canh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('509', '50900', N'Cục Thuế Tỉnh Phú Yên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('509', '50901', N'Chi cục Thuế TP  Tuy Hoà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('509', '50903', N'Chi cục Thuế Huyện Đồng Xuân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('509', '50905', N'Chi cục Thuế Thị xã Sông Cầu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('509', '50907', N'Chi cục Thuế Huyện Tuy An')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('509', '50909', N'Chi cục Thuế Huyện Sơn Hoà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('509', '50911', N'Chi cục Thuế Huyện Đông Hoà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('509', '50912', N'Chi cục Thuế Huyện Tây Hoà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('509', '50913', N'Chi cục Thuế Huyện Sông Hinh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('509', '50915', N'Chi cục Thuế Huyện Phú Hoà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('511', '51100', N'Cục Thuế Tỉnh Khánh Hoà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('511', '51101', N'Chi cục Thuế Thành phố Nha Trang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('511', '51103', N'Chi cục Thuế Huyện Vạn Ninh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('511', '51105', N'Chi cục Thuế Thị Xã Ninh Hoà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('511', '51107', N'Chi cục Thuế Huyện Diên Khánh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('511', '51109', N'Chi cục Thuế Thành Phố Cam Ranh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('511', '51111', N'Chi cục Thuế Huyện Khánh Vĩnh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('511', '51113', N'Chi cục Thuế Huyện Khánh Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('511', '51115', N'Chi cục Thuế Huyện Trường Sa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('511', '51117', N'Chi cục Thuế Huyện Cam Lâm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('601', '60100', N'Cục Thuế Tỉnh Kon Tum')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('601', '60101', N'Chi cục Thuế Thành phố Kon Tum')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('601', '60103', N'Chi cục Thuế Huyện Đắk Glei')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('601', '60105', N'Chi cục Thuế Huyện Ngọc Hồi')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('601', '60107', N'Chi cục Thuế Huyện Đắk Tô')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('601', '60108', N'Chi cục thuế Huyện Kon Rẫy')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('601', '60109', N'Chi cục Thuế Huyện Kon Plông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('601', '60111', N'Chi cục Thuế Huyện Đák Hà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('601', '60113', N'Chi cục Thuế Huyện Sa Thầy')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('601', '60115', N'Chi cục Thuế Huyện Tu Mơ Rông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60300', N'Cục Thuế Tỉnh Gia Lai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60301', N'Chi cục Thuế Thành phố Pleiku')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60303', N'Chi cục Thuế Huyện Kbang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60305', N'Chi cục Thuế Huyện Mang Yang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60307', N'Chi cục Thuế Huyện Chư Păh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60309', N'Chi cục Thuế Huyện Ia Grai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60311', N'Chi cục Thuế Thị xã An Khê')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60313', N'Chi cục Thuế Huyện Kông Chro')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60315', N'Chi cục Thuế Huyện Đức Cơ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60317', N'Chi cục Thuế Huyện Chư Prông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60319', N'Chi cục Thuế Huyện Chư Sê')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60320', N'Chi cục Thuế Huyện IaPa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60321', N'Chi cục Thuế Thị xã Ayun Pa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60323', N'Chi cục Thuế Huyện Krông Pa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60325', N'Chi cục Thuế Huyện Đắk Đoa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60327', N'Chi cục Thuế Huyện ĐakPơ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60329', N'Chi cục Thuế Huyện Phú Thiện')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('603', '60331', N'Chi cục Thuế Huyện Chư Pưh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60500', N'Cục Thuế Tỉnh Đắk Lắk')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60501', N'Chi cục Thuế Thành phố Buôn Ma Thuột')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60503', N'Chi cục Thuế Huyện Ea H''leo')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60505', N'Chi cục Thuế Huyện Ea Súp')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60507', N'Chi cục Thuế Huyện Krông Năng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60509', N'Chi cục Thuế Thị xã Buôn Hồ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60511', N'Chi cục Thuế Huyện Buôn Đôn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60513', N'Chi cục Thuế Huyện Cư M''gar')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60515', N'Chi cục Thuế Huyện Ea Kar')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60517', N'Chi cục Thuế Huyện M''ĐrắK')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60519', N'Chi cục Thuế Huyện Krông Pắk')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60523', N'Chi cục Thuế Huyện Krông A Na')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60525', N'Chi cục Thuế Huyện Krông Bông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60531', N'Chi cục Thuế Huyện Lắk')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60537', N'Chi cục Thuế Huyện Cư Kuin')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('605', '60539', N'Chi cục Thuế Huyện Krông Buk')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('606', '60600', N'Cục Thuế Tỉnh Đắk Nông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('606', '60603', N'Chi cục Thuế Huyện Cư Jút')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('606', '60605', N'Chi cục Thuế Huyện Krông Nô')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('606', '60607', N'Chi cục Thuế Huyện Đắk Mil')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('606', '60609', N'Chi cục Thuế Huyện Đắk Song')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('606', '60611', N'Chi cục Thuế Huyện Đắk R''Lấp')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('606', '60613', N'Chi cục Thuế Thị xã Gia Nghĩa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('606', '60615', N'Chi cục thuế Huyện Đắk Glong')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('606', '60617', N'Chi cục Thuế Huyện Tuy Đức')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70100', N'Cục Thuế Thành phố Hồ Chí Minh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70101', N'Chi cục Thuế Quận 1')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70103', N'Chi cục Thuế Quận 2')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70105', N'Chi cục Thuế Quận 3')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70107', N'Chi cục Thuế Quận 4')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70109', N'Chi cục Thuế Quận 5')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70111', N'Chi cục Thuế Quận 6')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70113', N'Chi cục Thuế Quận 7')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70115', N'Chi cục Thuế Quận 8')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70117', N'Chi cục Thuế Quận 9')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70119', N'Chi cục Thuế Quận 10')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70121', N'Chi cục Thuế Quận 11')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70123', N'Chi cục Thuế Quận 12')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70125', N'Chi cục Thuế Quận Gò Vấp')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70127', N'Chi cục Thuế Quận Tân Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70128', N'Chi cục thuế Quận Tân phú')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70129', N'Chi cục Thuế Quận Bình Thạnh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70131', N'Chi cục Thuế Quận Phú Nhuận')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70133', N'Chi cục Thuế Quận Thủ Đức')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70134', N'Chi cục thuế Quận Bình Tân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70135', N'Chi cục Thuế Huyện Củ Chi')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70137', N'Chi cục Thuế Huyện Hóc Môn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70139', N'Chi cục Thuế Huyện Bình Chánh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70141', N'Chi cục Thuế Huyện Nhà Bè')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('701', '70143', N'Chi cục Thuế Huyện Cần Giờ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('703', '70300', N'Cục Thuế Tỉnh Lâm Đồng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('703', '70301', N'Chi cục Thuế Thành phố Đà Lạt')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('703', '70303', N'Chi cục Thuế Thành phố Bảo Lộc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('703', '70305', N'Chi cục Thuế Huyện Lạc Dương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('703', '70307', N'Chi cục Thuế Huyện Đơn Dương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('703', '70309', N'Chi cục Thuế Huyện Đức Trọng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('703', '70311', N'Chi cục Thuế Huyện Lâm Hà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('703', '70313', N'Chi cục Thuế Huyện Bảo Lâm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('703', '70315', N'Chi cục Thuế Huyện Di Linh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('703', '70317', N'Chi cục Thuế Huyện Đạ Huoai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('703', '70319', N'Chi cục Thuế Huyện Đạ Tẻh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('703', '70321', N'Chi cục Thuế Huyện Cát Tiên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('703', '70323', N'Chi cục Thuế huyện Đam Rông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('705', '70500', N'Cục Thuế Tỉnh Ninh Thuận')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('705', '70501', N'Chi cục Thuế TP. Phan Rang - Tháp Chàm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('705', '70503', N'Chi cục Thuế Huyện Ninh Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('705', '70505', N'Chi cục Thuế Huyện Ninh Hải')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('705', '70507', N'Chi cục Thuế Huyện Ninh Phước')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('705', '70509', N'Chi cục Thuế Huyện Bác ái')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('705', '70511', N'Chi cục thuế Huyện Thuận Bắc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('705', '70513', N'Chi cục thuế Huyện Thuận Nam')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('707', '70700', N'Cục Thuế Tỉnh Bình Phước')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('707', '70701', N'Chi cục Thuế Huyện Đồng Phú')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('707', '70703', N'Chi cục Thuế Thị xã Phước Long')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('707', '70705', N'Chi cục Thuế Huyện Lộc Ninh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('707', '70706', N'Chi cục Thuế Huyện Bù Đốp')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('707', '70707', N'Chi cục Thuế Huyện Bù Đăng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('707', '70709', N'Chi cục Thuế Thị xã Bình Long')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('707', '70710', N'Chi cục Thuế Huyện Chơn Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('707', '70711', N'Chi cục thuế Thị xã Đồng Xoài')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('707', '70713', N'Chi cục thuế Huyện Hớn Quản')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('707', '70715', N'Chi cục thuế Huyện Bù Gia Mập')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('709', '70900', N'Cục Thuế Tỉnh Tây Ninh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('709', '70901', N'Chi cục Thuế Thành phố Tây Ninh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('709', '70903', N'Chi cục Thuế Huyện Tân Biên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('709', '70905', N'Chi cục Thuế Huyện Tân Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('709', '70907', N'Chi cục Thuế Huyện Dương Minh Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('709', '70909', N'Chi cục Thuế Huyện Châu Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('709', '70911', N'Chi cục Thuế Huyện Hoà Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('709', '70913', N'Chi cục Thuế Huyện Bến Cầu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('709', '70915', N'Chi cục thuế huyện Gò Dầu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('709', '70917', N'Chi cục Thuế Huyện Trảng Bàng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('711', '71100', N'Cục Thuế Tỉnh Bình Dương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('711', '71101', N'Chi cục Thuế Thị Xã Thủ Dầu Một')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('711', '71103', N'Chi cục Thuế Thị Xã Bến Cát')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('711', '71105', N'Chi cục Thuế Thị Xã Tân Uyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('711', '71107', N'Chi cục Thuế Thị Xã Thuận An')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('711', '71109', N'Chi cục Thuế Thị Xã Dĩ An')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('711', '71111', N'Chi cục Thuế Huyện Phú Giáo')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('711', '71113', N'Chi cục Thuế Huyện Dầu Tiếng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('711', '71115', N'Chi cục Thuế Huyện Bàu Bàng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('711', '71117', N'Chi cục Thuế Huyện Bắc Tân Uyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('713', '71300', N'Cục Thuế Tỉnh Đồng Nai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('713', '71301', N'Chi cục Thuế TP Biên Hòa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('713', '71302', N'Chi cục thuế TX Long khánh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('713', '71303', N'Chi cục Thuế Huyện Tân Phú')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('713', '71305', N'Chi cục Thuế Huyện Định Quán')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('713', '71307', N'Chi cục Thuế Huyện Vĩnh Cửu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('713', '71308', N'Chi cục thuế Huyện Trảng Bom')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('713', '71309', N'Chi cục Thuế Huyện Thống Nhất')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('713', '71311', N'Chi cục Thuế huyện Cẩm Mỹ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('713', '71313', N'Chi cục Thuế Huyện Xuân Lộc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('713', '71315', N'Chi cục Thuế Huyện Long Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('713', '71317', N'Chi cục Thuế Huyện Nhơn Trạch')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('715', '71500', N'Cục Thuế Tỉnh Bình Thuận')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('715', '71501', N'Chi cục Thuế Thành phố Phan Thiết')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('715', '71503', N'Chi cục Thuế Huyện Tuy Phong')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('715', '71505', N'Chi cục Thuế Huyện Bắc Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('715', '71507', N'Chi cục Thuế Huyện Hàm Thuận Bắc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('715', '71509', N'Chi cục Thuế Huyện Hàm Thuận Nam')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('715', '71511', N'Chi cục Thuế Huyện Tánh Linh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('715', '71513', N'Chi cục Thuế Thị xã La Gi')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('715', '71514', N'Chi cục Thuế Huyện Hàm Tân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('715', '71515', N'Chi cục Thuế Huyện Đức Linh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('715', '71517', N'Chi cục Thuế Huyện Phú Quý')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('717', '71700', N'Cục Thuế Tỉnh Bà Rịa - Vũng Tàu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('717', '71701', N'Chi cục Thuế Thành phố Vũng Tàu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('717', '71703', N'Chi cục Thuế Thị xã Bà Rịa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('717', '71705', N'Chi cục Thuế Huyện Châu Đức')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('717', '71707', N'Chi cục Thuế Huyện Xuyên Mộc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('717', '71709', N'Chi cục Thuế Huyện Tân Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('717', '71711', N'Chi cục thuế Huyện Long Điền')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('717', '71712', N'Chi cục Thuế Huyện Đất đỏ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('717', '71713', N'Chi cục Thuế Huyện Côn Đảo')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80100', N'Cục Thuế Tỉnh Long An')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80101', N'Chi cục Thuế Thành phố Tân An')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80103', N'Chi cục Thuế Huyện Tân Hưng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80105', N'Chi cục Thuế Huyện Vĩnh Hưng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80107', N'Chi cục Thuế Huyện Mộc Hoá')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80109', N'Chi cục Thuế Huyện Tân Thạnh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80111', N'Chi cục Thuế Huyện Thạnh Hoá')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80113', N'Chi cục Thuế Huyện Đức Huệ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80115', N'Chi cục Thuế Huyện Đức Hoà')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80117', N'Chi cục Thuế Huyện Bến Lức')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80119', N'Chi cục Thuế Huyện Thủ Thừa')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80121', N'Chi cục Thuế Huyện Châu Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80123', N'Chi cục Thuế Huyện Tân Trụ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80125', N'Chi cục Thuế Huyện Cần Đước')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80127', N'Chi cục Thuế Huyện Cần Giuộc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('801', '80129', N'Chi cục Thuế Thị Xã Kiến Tường')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('803', '80300', N'Cục Thuế Tỉnh Đồng Tháp')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('803', '80301', N'Chi cục Thuế Thành phố Cao Lãnh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('803', '80303', N'Chi cục Thuế Thị xã Sa Đéc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('803', '80305', N'Chi cục Thuế Huyện Tân Hồng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('803', '80307', N'Chi cục Thuế Huyện Hồng Ngự')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('803', '80309', N'Chi cục Thuế Huyện Tam Nông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('803', '80311', N'Chi cục Thuế Huyện Thanh Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('803', '80313', N'Chi cục Thuế Huyện Tháp Mười')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('803', '80315', N'Chi cục Thuế Huyện Cao Lãnh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('803', '80317', N'Chi cục Thuế Huyện Lấp Vò')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('803', '80319', N'Chi cục Thuế Huyện Lai Vung')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('803', '80321', N'Chi cục Thuế Huyện Châu Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('803', '80323', N'Chi cục Thuế Thị xã Hồng Ngự')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('805', '80500', N'Cục Thuế Tỉnh An Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('805', '80501', N'Chi cục thuế Tp. Long Xuyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('805', '80503', N'Chi cục Thuế Thị xã Châu Đốc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('805', '80505', N'Chi cục Thuế Huyện An Phú')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('805', '80507', N'Chi cục Thuế Thị xã Tân Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('805', '80509', N'Chi cục Thuế Huyện Phú Tân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('805', '80511', N'Chi cục Thuế Huyện Châu Phú')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('805', '80513', N'Chi cục Thuế Huyện Tịnh Biên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('805', '80515', N'Chi cục Thuế Huyện Tri Tôn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('805', '80517', N'Chi cục Thuế Huyện Chợ Mới')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('805', '80519', N'Chi cục Thuế Huyện Châu Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('805', '80521', N'Chi cục Thuế Huyện Thoại Sơn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('807', '80700', N'Cục Thuế Tỉnh Tiền Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('807', '80701', N'Chi cục Thuế Thành phố Mỹ Tho')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('807', '80703', N'Chi cục Thuế Thị xã Gò Công')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('807', '80705', N'Chi cục Thuế Huyện Tân Phước')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('807', '80707', N'Chi cục Thuế Huyện Châu Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('807', '80709', N'Chi cục Thuế Huyện Cai Lậy')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('807', '80711', N'Chi cục Thuế Huyện Chợ Gạo')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('807', '80713', N'Chi cục Thuế Huyện Cái Bè')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('807', '80715', N'Chi cục Thuế Huyện Gò Công Tây')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('807', '80717', N'Chi cục Thuế Huyện Gò Công Đông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('807', '80719', N'Chi cục Thuế Huyện Tân Phú Đông')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('807', '80721', N'Chi cục Thuế Thị xã Cai Lậy')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('809', '80900', N'Cục Thuế Tỉnh Vĩnh Long')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('809', '80901', N'Chi cục Thuế Thành phố  Vĩnh Long')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('809', '80903', N'Chi cục Thuế Huyện Long Hồ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('809', '80905', N'Chi cục Thuế Huyện Mang Thít')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('809', '80907', N'Chi cục thuế thị xã Bình Minh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('809', '80908', N'Chi cục Thuế huyện Bình Tân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('809', '80909', N'Chi cục Thuế Huyện Tam Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('809', '80911', N'Chi cục Thuế Huyện Trà Ôn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('809', '80913', N'Chi cục Thuế Huyện Vũng Liêm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('811', '81100', N'Cục Thuế Tỉnh Bến Tre')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('811', '81101', N'Chi cục Thuế Thành phố  Bến Tre')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('811', '81103', N'Chi cục Thuế Huyện Châu Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('811', '81105', N'Chi cục Thuế Huyện Chợ Lách')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('811', '81107', N'Chi cục Thuế Huyện Mỏ Cày Nam')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('811', '81108', N'Chi cục thuế Huyện Mỏ Cày Bắc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('811', '81109', N'Chi cục Thuế Huyện Giồng Trôm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('811', '81111', N'Chi cục Thuế Huyện Bình Đại')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('811', '81113', N'Chi cục Thuế Huyện Ba Tri')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('811', '81115', N'Chi cục Thuế Huyện Thạnh Phú')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81300', N'Cục Thuế Tỉnh Kiên Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81301', N'Chi cục Thuế Thành phố Rạch Giá')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81303', N'Chi cục Thuế Huyện Kiên Lương')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81304', N'Chi cục Thuế Huyện Giang Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81305', N'Chi cục Thuế Huyện Hòn Đất')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81307', N'Chi cục Thuế Huyện Tân Hiệp')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81309', N'Chi cục Thuế Huyện Châu Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81311', N'Chi cục Thuế Huyện Giồng Riềng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81313', N'Chi cục Thuế Huyện Gò Quao')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81315', N'Chi cục Thuế Huyện An Biên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81317', N'Chi cục Thuế Huyện An Minh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81319', N'Chi cục Thuế Huyện Vĩnh Thuận')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81321', N'Chi cục Thuế Huyện Phú Quốc')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81323', N'Chi cục Thuế Huyện Kiên HảI                       ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81325', N'Chi cục thuế Thị xã Hà Tiên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('813', '81327', N'Chi cục Thuế Huyện U Minh Thượng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('815', '81500', N'Cục Thuế Thành phố Cần Thơ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('815', '81503', N'Chi cục Thuế  Quận Thốt Nốt')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('815', '81505', N'Chi cục Thuế Quận Ô Môn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('815', '81519', N'Chi cục Thuế Quận Ninh Kiều')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('815', '81521', N'Chi cục Thuế Quận Bình Thuỷ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('815', '81523', N'Chi cục Thuế Quận Cái Răng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('815', '81525', N'Chi cục Thuế Huyện Vĩnh Thạnh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('815', '81527', N'Chi cục Thuế Huyện Cờ Đỏ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('815', '81529', N'Chi cục Thuế Huyện Phong Điền')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('815', '81531', N'Chi Cục Thuế Huyện Thới Lai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('816', '81600', N'Cục Thuế Tỉnh Hậu Giang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('816', '81601', N'Chi cục Thuế Thị xã Vị Thanh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('816', '81603', N'CCThuế Huyện Châu Thành A')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('816', '81605', N'Chi cục Thuế Huyện Châu Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('816', '81607', N'Chi cục Thuế Thị  Xã Ngã Bảy')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('816', '81608', N'Chi cục thuế huyện Phụng Hiệp')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('816', '81609', N'Chi cục Thuế Huyện Vị Thủy')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('816', '81611', N'Chi cục Thuế Huyện Long Mỹ')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('817', '81700', N'Cục Thuế Tỉnh Trà Vinh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('817', '81701', N'Chi cục Thuế Thành phố Trà Vinh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('817', '81703', N'Chi cục Thuế Huyện Càng Long')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('817', '81705', N'Chi cục Thuế Huyện Châu Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('817', '81707', N'Chi cục Thuế Huyện Cầu Kè')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('817', '81709', N'Chi cục Thuế Huyện Tiểu Cần')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('817', '81711', N'Chi cục Thuế Huyện Cầu Ngang')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('817', '81713', N'Chi cục Thuế Huyện Trà Cú')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('817', '81715', N'Chi cục Thuế Huyện Duyên Hải')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('819', '81900', N'Cục Thuế Tỉnh Sóc Trăng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('819', '81901', N'Chi cục Thuế Thành phố Sóc Trăng')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('819', '81903', N'Chi cục Thuế Huyện Kế Sách')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('819', '81905', N'Chi cục Thuế Huyện Long Phú')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('819', '81906', N'Chi cục thuế Huyện Cù Lao Dung')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('819', '81907', N'Chi cục Thuế Huyện Mỹ Tú')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('819', '81909', N'Chi cục Thuế Huyện Mỹ Xuyên')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('819', '81911', N'Chi cục Thuế Huyện Thạnh Trị')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('819', '81912', N'Chi cục thuế Thị xã Ngã Năm')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('819', '81913', N'Chi cục Thuế Huyện Vĩnh Châu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('819', '81915', N'Chi cục Thuế Huyện Châu Thành')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('819', '81917', N'Chi cục Thuế Huyện Trần Đề')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('821', '82100', N'Cục Thuế Tỉnh Bạc Liêu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('821', '82101', N'Chi cục Thuế Thành phố Bạc Liêu')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('821', '82103', N'Chi cục Thuế Huyện Hồng Dân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('821', '82105', N'Chi cục Thuế Huyện Vĩnh Lợi')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('821', '82106', N'Chi cục thuế Huyện Hoà Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('821', '82107', N'Chi cục Thuế Huyện Giá Rai')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('821', '82109', N'Chi cục Thuế Huyện Phước Long')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('821', '82111', N'Chi cục thuế Huyện Đông Hải')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('823', '82300', N'Cục Thuế Tỉnh Cà Mau')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('823', '82301', N'Chi cục Thuế TP Cà Mau')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('823', '82303', N'Chi cục Thuế Huyện Thới Bình')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('823', '82305', N'Chi cục Thuế Huyện U Minh')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('823', '82307', N'Chi cục Thuế Huyện Trần Văn Thời')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('823', '82308', N'Chi cục Thuế Huyện Phú Tân')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('823', '82309', N'Chi cục Thuế Huyện Cái Nước')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('823', '82311', N'Chi cục Thuế Huyện Đầm Dơi')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('823', '82312', N'Chi cục Thuế Huyện Năm Căn')

	INSERT INTO DMThueCapQL (TaxDepartmentID, TaxDepartID, TaxDepartName)
	VALUES ('823', '82313', N'Chi cục Thuế Huyện Ngọc Hiển')
END