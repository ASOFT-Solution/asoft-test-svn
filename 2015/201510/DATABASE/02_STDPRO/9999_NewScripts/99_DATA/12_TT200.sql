---- Cap nhat tai khoan theo thong tu 200 (Chi ap dung quyet dinh 15)
---- Lưu ý: Script này dùng cho khách hàng cũ muốn nâng cấp phần mềm lên theo thông tư 200

-- 1) Cập nhật Danh mục tài khoản theo TT200
--------------------------------Insert-------------------------------------------    
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'1218')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'1218', N'121', N'Chứng khoán và công cụ tài chính khác', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'1282')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'1282', N'128', N'Trái phiếu ', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'1283')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'1283', N'128', N'Cho vay', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'1311')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'1311', N'131', N'Phải thu khách hàng ngắn hạn', NULL, 1, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'1312')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'1312', N'131', N'Phải thu khách hàng dài hạn', NULL, 1, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'1362')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'1362', N'136', N'Phải thu nội bộ về chênh lệch tỷ giá', NULL, 1, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'1363')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'1363', N'136', N'Phải thu nội bộ về chi phí đi vay đủ điều kiện được vốn hóa', NULL, 1, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'1532')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'1532', N'153', N'Bao bì luân chuyển', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'1533')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'1533', N'153', N'Đồ dùng cho thuê', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'1534')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'1534', N'153', N'Thiết bị, phụ tùng thay thế', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'1551')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'1551', N'155', N'Thành phẩm nhập kho', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'1557')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'1557', N'155', N'Thành phẩm bất động sản', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'171')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'171', NULL, N'Giao dịch mua bán lại trái phiếu chính phủ', NULL, 1, 1, 1)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'2121')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'2121', N'212', N'TSCĐ hữu hình thuê tài chính', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'2122')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'2122', N'212', N'TSCĐ vô hình thuê tài chính', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'2291')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'2291', N'229', N'Dự phòng giảm giá chứng khoán kinh doanh', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'2292')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'2292', N'229', N'Dự phòng tổn thất đầu tư vào đơn vị khác', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'2293')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'2293', N'229', N'Dự phòng phải thu khó đòi', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'2294')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'2294', N'229', N'Dự phòng giảm giá hàng tồn kho', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'3311')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'3311', N'331', N'Phái trả cho người bán ngắn hạn', NULL, 1, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'3312')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'3312', N'331', N'Phải trả cho người bán dài hạn', NULL, 1, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'33381')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'33381', N'3338', N'Thuế bảo vệ môi trường', NULL, 0, 1, 3)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'33382')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'33382', N'3338', N'Các loại thuế khác', NULL, 0, 1, 3)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'3361')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'3361', N'336', N'Phải trả nội bộ về vốn kinh doanh', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'3362')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'3362', N'336', N'Phải trả nội bộ về chênh lệch tỷ giá', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'3363')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'3363', N'336', N'Phải trả nội bộ về chi phí đi vay đủ điều kiện được vốn hóa', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'3368')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'3368', N'336', N'Phải trả nội bộ khác', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'3412')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'3412', N'341', N'Nợ thuê tài chính', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'34311')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'34311', N'3431', N'Mệnh giá', NULL, 0, 1, 3)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'34312')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'34312', N'3431', N'Chiết khấu trái phiếu', NULL, 0, 1, 3)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'34313')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'34313', N'3431', N'Phụ trội trái phiếu', NULL, 0, 1, 3)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'3521')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'3521', N'352', N'Dự phòng bảo hành sản phẩm hàng hóa', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'3522')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'3522', N'352', N'Dự phòng bảo hành công trình xây dựng', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'3523')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'3523', N'352', N'Dự phòng tái cơ cấu doanh nghiệp', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'3524')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'3524', N'352', N'Dự phòng phải trả khác', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'357')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'357', NULL, N'Quỹ bình ổn giá', NULL, 0, 1, 1)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'41111')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'41111', N'4111', N'Cổ phiếu phổ thông có quyền biểu quyết', NULL, 0, 1, 3)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'41112')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'41112', N'4111', N'Cổ phiếu ưu đãi', NULL, 0, 1, 3)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'4113')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'4113', N'411', N'Quyền chọn chuyển đổi trái phiếu', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'5211')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'5211', N'521', N'Chiết khấu thương mại', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'5212')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'5212', N'521', N'Hàng bán bị trả lại', NULL, 0, 1, 2)
  
IF NOT EXISTS  (SELECT TOP 1 1 FROM DMTK WHERE TK = N'5213')
  INSERT INTO DMTK (TK, TKMe, TenTK, TenTK2, TKCongNo, TKSoCai, GradeTK)
  VALUES (N'5213', N'521', N'Giảm giá hàng bán', NULL, 0, 1, 2)
  
--------------------------------Update-------------------------------------------    
Update DMTK SET
 TenTK = N'Tiền Việt Nam', TenTK2 = N'Cash in bank', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'1111' AND TenTK=N'Tiền mặt VND'
Update DMTK SET
 TenTK = N'Ngoại tệ', TenTK2 = N'Cash in bank (VND)', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'1112' AND TenTK=N'Tiền mặt USD'
Update DMTK SET
 TenTK = N'Vàng tiền tệ', TenTK2 = NULL, TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'1113' AND TenTK=N'Vàng, bạc, kim khí quý, đá quý'
Update DMTK SET
 TenTK = N'Tiền gửi Ngân hàng', TenTK2 = NULL, TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'112' AND TenTK=N'Tiền gởi ngân hàng'
Update DMTK SET
 TenTK = N'Vàng tiền tệ', TenTK2 = N'Cash in transit USD', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'1123' AND TenTK=N'Vàng, bạc, kin khí quý, đá quý'
Update DMTK SET
 TenTK = N'Chứng khoán kinh doanh', TenTK2 = N'Other short - term investment', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'121' AND TenTK=N'Đầu tư chứng khoán ngắn hạn'
Update DMTK SET
 TenTK = N'Trái phiếu', TenTK2 = N'Other short - term investment', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'1212' AND TenTK=N'Trái phiếu, tín phiếu, kỳ phiếu'
Update DMTK SET
 TenTK = N'Đầu tư nắm giữ đến ngày đáo hạn', TenTK2 = N'Provision for diminution in value of short-term investments', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'128' AND TenTK=N'Đầu tư ngắn hạn khác'
Update DMTK SET
 TenTK = N'Các khoản đầu tư khác nắm giữ đến ngày đáo hạn', TenTK2 = N'VAT deducted', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'1288' AND TenTK=N'Đầu tư ngắn hạn khác'
Update DMTK SET
 TenTK = N'Phải thu của khách hàng', TenTK2 = N'VAT deduction of fixed assets', TKCongNo = 1, TKSoCai = 1, GradeTK = 1
 Where TK = N'131' AND TenTK=N'Công nợ phải thu'
Update DMTK SET
 TenTK = N'Thuế GTGT được khấu trừ', TenTK2 = N'Intercompany receivable', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'133' AND TenTK=N'Thuế GTGT đầu vào'
Update DMTK SET
 TenTK = N'Vốn kinh doanh ở các đơn vị trực thuộc', TenTK2 = N'Shortage of assets awaiting resolution', TKCongNo = 1, TKSoCai = 1, GradeTK = 2
 Where TK = N'1361' AND TenTK=N'Vốn kinh doanh của các đơn vị trực thuộc'
Update DMTK SET
 TenTK = N'Phải thu nội bộ khác', TenTK2 = N'Equitisation receivable', TKCongNo = 1, TKSoCai = 1, GradeTK = 2
 Where TK = N'1368' AND TenTK=N'Phải  thu nội bộ khác'
Update DMTK SET
 TenTK = N'Phải thu khác', TenTK2 = N'Other receivable', TKCongNo = 1, TKSoCai = 1, GradeTK = 1
 Where TK = N'138' AND TenTK=N'Phải  thu khác'
Update DMTK SET
 TenTK = N'Tài sản thiếu chờ xử lý', TenTK2 = N'Provision for bad debts', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'1381' AND TenTK=N'Tài sản thiếu chờ sử lý'
Update DMTK SET
 TenTK = N'Giá mua hàng hóa', TenTK2 = N'Goods on consignment', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'1561' AND TenTK=N'Gía mua hàng hóa'
Update DMTK SET
 TenTK = N'Dự phòng giảm giá hàng tồn kho (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'This year', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'159' AND TenTK=N'Dự phòng giảm giá hàng tồn kho'
Update DMTK SET
 TenTK = N'Tài sản cố định hữu hình', TenTK2 = N'Transportation & transmit instrument', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'211' AND TenTK=N'Tài sản cố định'
Update DMTK SET
 TenTK = N'Máy móc, thiết bị', TenTK2 = N'Long term trees, working & killed animals', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'2112' AND TenTK=N'Máy móc thiết bị'
Update DMTK SET
 TenTK = N'Phương tiện vận tải, truyền dẫn', TenTK2 = N'Other tangible fixed assets', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'2113' AND TenTK=N'Phương tiện, vận tải, truyền dẫn'
Update DMTK SET
 TenTK = N'Cây lâu năm, súc vật làm việc và cho sản phẩm', TenTK2 = N'Intangible fixed assets', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'2115' AND TenTK=N'Cây lâu năm, súc vật làm việc cho sản phẩm'
Update DMTK SET
 TenTK = N'Tài sản cố định vô hình', TenTK2 = N'Patents & creations', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'213' AND TenTK=N'Tài sản cố đinh vô hình'
Update DMTK SET
 TenTK = N'Quyền sử dụng đất', TenTK2 = N'Trademark', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'2131' AND TenTK=N'Quyến sử dụng đất'
Update DMTK SET
 TenTK = N'Nhãn hiệu, tên thương mại', TenTK2 = N'Other intangible fixed assets', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'2134' AND TenTK=N'Nhãn hiệu hàng hóa'
Update DMTK SET
 TenTK = N'Chương trình phần mềm', TenTK2 = N'Depreciation of fixed assets', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'2135' AND TenTK=N'Phần mềm máy vi tính'
Update DMTK SET
 TenTK = N'Hao mòn tài sản cố định', TenTK2 = N'Intangible fixed assets depreciation', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'214' AND TenTK=N'Hao mòn tài  sản cố định'
Update DMTK SET
 TenTK = N'Đầu tư vào công ty liên doanh, liên kết', TenTK2 = N'Stocks', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'222' AND TenTK=N'Vốn góp liên doanh'
Update DMTK SET
 TenTK = N'Đầu tư vào công ty liên kết (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Bonds', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'223' AND TenTK=N'Đầu tư vào công ty liên kết'
Update DMTK SET
 TenTK = N'Đầu tư khác', TenTK2 = N'Other long-term investment', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'228' AND TenTK=N'Đầu tư dài hạn khác'
Update DMTK SET
 TenTK = N'Đầu tư góp vốn vào đơn vị khác', TenTK2 = N'Provision for long term investment devaluation', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'2281' AND TenTK=N'Cổ phiếu'
Update DMTK SET
 TenTK = N'Trái phiếu (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Capital construction in process', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'2282' AND TenTK=N'Trái phiếu'
Update DMTK SET
 TenTK = N'Đầu tư khác', TenTK2 = N'Fixed assets purchases', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'2288' AND TenTK=N'Đầu tư dài hạn khác'
Update DMTK SET
 TenTK = N'Dự phòng tổn thất tài sản', TenTK2 = N'Capital construction', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'229' AND TenTK=N'Dự phòng giảm giá đầu tư dài hạn'
Update DMTK SET
 TenTK = N'Xây dựng cơ bản dở dang', TenTK2 = N'Major repair of fixed assets', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'241' AND TenTK=N'Xây dụng cơ bản dở dang'
Update DMTK SET
 TenTK = N'Chi phí trả trước', TenTK2 = N'Short-term loan', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'242' AND TenTK=N'Chi phí trả trước dài hạn'
Update DMTK SET
 TenTK = N'Cầm cố, thế chấp, ký quỹ, ký cược', TenTK2 = N'Payable to seller', TKCongNo = 1, TKSoCai = 1, GradeTK = 1
 Where TK = N'244' AND TenTK=N'Ký quỹ, ký cược dài hạn'
Update DMTK SET
 TenTK = N'Vay ngắn hạn (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Taxes and payable to state budget', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'311' AND TenTK=N'Vay ngắn hạn'
Update DMTK SET
 TenTK = N'Nợ dài hạn đến hạn trả (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Value Added Tax (VAT)', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'315' AND TenTK=N'Nợ dài hạn đến hạn trả'
Update DMTK SET
 TenTK = N'Thuế và các khoản phải nộp Nhà nước', TenTK2 = N'VAT for imported goods', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'333' AND TenTK=N'Thuế GTGT đầu ra'
Update DMTK SET
 TenTK = N'Thuế giá trị gia tăng phải nộp', TenTK2 = N'Special consumption tax', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'3331' AND TenTK=N'Thuế GTGT phải nộp'
Update DMTK SET
 TenTK = N'Thuế bảo vệ môi trường và các loại thuế khác', TenTK2 = N'Payable to employees', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'3338' AND TenTK=N'Các loại thuế khác'
Update DMTK SET
 TenTK = N'Phí, lệ phí và các khoản phải nộp khác', TenTK2 = N'Payable to other employees', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'3339' AND TenTK=N'Phí, lệ phí, và các khoản phải nộp khác'
Update DMTK SET
 TenTK = N'Bảo hiểm thất nghiệp', TenTK2 = N'Unemployment Insurance', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'3386' AND TenTK=N'Nhận ký quỹ, ký cược ngắn hạn '
Update DMTK SET
 TenTK = N'Phải trả, phải nộp khác', TenTK2 = N'Long-term borrowing', TKCongNo = 1, TKSoCai = 1, GradeTK = 2
 Where TK = N'3388' AND TenTK=N'Phải trả phải nộp khác'
Update DMTK SET
 TenTK = N'Bảo hiểm thất nghiệp (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Long-term liabilites', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'3389' AND TenTK=N'Bảo hiểm thất nghiệp'
Update DMTK SET
 TenTK = N'Vay và nợ thuê tài chính', TenTK2 = N'Issued bond', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'341' AND TenTK=N'Vay dài hạn'
Update DMTK SET
 TenTK = N'Các khoản đi vay', TenTK2 = N'Bond face value', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'3411' AND TenTK=N'Vay ngân hàng'
Update DMTK SET
 TenTK = N'Nợ dài hạn (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Bond discount', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'342' AND TenTK=N'Nợ dài hạn'
Update DMTK SET
 TenTK = N'Trái phiếu thường', TenTK2 = N'Long-term deposits received', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'3431' AND TenTK=N'Mệnh giá trái phiếu'
Update DMTK SET
 TenTK = N'Trái phiếu chuyển đổi', TenTK2 = N'Deferred income tax', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'3432' AND TenTK=N'Chiết khấu trái phiếu'
Update DMTK SET
 TenTK = N'Phụ trội trái phiếu (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Provisions fund for severance allowances', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'3433' AND TenTK=N'Phụ trội trái phiếu'
Update DMTK SET
 TenTK = N'Nhận ký quỹ, ký cược', TenTK2 = N'Provisions for payables', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'344' AND TenTK=N'Nhận ký quỹ, ký cược dài hạn'
Update DMTK SET
 TenTK = N'Quỹ dự phòng trợ cấp mất việc làm (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'The reward fund', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'351' AND TenTK=N'Quỹ dự phòng trợ cấp mất việc làm'
Update DMTK SET
 TenTK = N'Quỹ khen thưởng ', TenTK2 = N'Reward Fund Executive Board Company', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'3531' AND TenTK=N'Quỹ khen thưởng'
Update DMTK SET
 TenTK = N'Quỹ phúc lợi đã hình thành TSCĐ', TenTK2 = N'The development of science and technology fund', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'3533' AND TenTK=N'Quỹ phúc lợi đã hình thành TSCD'
Update DMTK SET
 TenTK = N'Quỹ thưởng ban quản lý điều hành công ty', TenTK2 = N'The development of science and technology fund that form the fixed assets', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'3534' AND TenTK=N'Quỹ thưởng ban điều hành Cty'
Update DMTK SET
 TenTK = N'Quỹ phát triển khoa học và công nghệ đã hình thành TSCĐ', TenTK2 = N'Share premium', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'3562' AND TenTK=N'Quỹ PT KH và CN đã hình thành TSCD'
Update DMTK SET
 TenTK = N'Vốn đầu tư của chủ sở hữu', TenTK2 = N'Other capital', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'411' AND TenTK=N'Nguồn vốn kinh doanh'
Update DMTK SET
 TenTK = N'Vốn góp của chủ sở hữu', TenTK2 = N'Differences upon asset revaluation', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'4111' AND TenTK=N'Vốn đầu tư của chủ sở hữu'
Update DMTK SET
 TenTK = N'Chênh lệch tỷ giá do đánh giá lại các khoản mục tiền tệ có gốc ngoại tệ', TenTK2 = N'Financial reserve funds', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'4131' AND TenTK=N'Chênh lệch tỷ giá hối đoái đánh giá lại cuối năm tài chính'
Update DMTK SET
 TenTK = N'Chênh lệch tỷ giá hối đoái trong giai đoạn trước hoạt động', TenTK2 = N'Fund to support the enterprise reorganization', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'4132' AND TenTK=N'Chênh lệch tỷ giá hối đoái trong giai đoạn đầu tư XDCB'
Update DMTK SET
 TenTK = N'Quỹ dự phòng tài chính (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Stock funds', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'415' AND TenTK=N'Quỹ dự phòng tài chính'
Update DMTK SET
 TenTK = N'Lợi nhuận sau thuế chưa phân phối', TenTK2 = N'Bonus & welfare funds', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'421' AND TenTK=N'Lợi nhuận chưa phân phối'
Update DMTK SET
 TenTK = N'Lợi nhuận sau thuế chưa phân phối năm trước', TenTK2 = N'Bonus fund', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'4211' AND TenTK=N'Lợi nhuận chưa phân phối năm trước'
Update DMTK SET
 TenTK = N'Lợi nhuận sau thuế chưa phân phối năm nay', TenTK2 = N'Welfare fund', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'4212' AND TenTK=N'Lợi nhuận chưa phân phối năm nay'
Update DMTK SET
 TenTK = N'Quỹ khen thưởng, phúc lợi (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Welfare fund used to acquire fixed assets', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'431' AND TenTK=N'Quỹ khen thưởng, phúc lợi'
Update DMTK SET
 TenTK = N'Quỹ khen thưởng (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Construction investment fund', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'4311' AND TenTK=N'Quỹ khen thưởng'
Update DMTK SET
 TenTK = N'Quỹ phúc lợi (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Budget resources', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'4312' AND TenTK=N'Quỹ phúc lợi'
Update DMTK SET
 TenTK = N'Quỹ phúc lợi đã hình thành TSCĐ (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Precious year budget resources', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'4313' AND TenTK=N'Quỹ phúc lợi đã hình thành TSCĐ'
Update DMTK SET
 TenTK = N'Nguồn kinh phí sự nghiệp năm nay', TenTK2 = N'Goods sale', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'4612' AND TenTK=N'Nguồn kinh phí sụ nghiệp năm nay'
Update DMTK SET
 TenTK = N'Doanh thu bán hàng và cung cấp dịch vụ', TenTK2 = N'Services sale', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'511' AND TenTK=N'Doanh thu'
Update DMTK SET
 TenTK = N'Doanh thu công trình xây lắp (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Internal gross sales', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'5115' AND TenTK=N'Doanh thu công trình xây lắp'
Update DMTK SET
 TenTK = N'Doanh thu kinh doanh bất động sản đầu tư', TenTK2 = N'Goods sale', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'5117' AND TenTK=N'Doanh thu kinh doanh bất động sản'
Update DMTK SET
 TenTK = N'Doanh thu bán hàng nội bộ (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Services sale', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'512' AND TenTK=N'Doanh thu bán hàng nội bộ'
Update DMTK SET
 TenTK = N'Doanh thu bán hàng hóa (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Financial activities income', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'5121' AND TenTK=N'Doanh thu bán hàng hóa'
Update DMTK SET
 TenTK = N'Doanh thu bán các thành phẩm (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Sale discount', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'5122' AND TenTK=N'Doanh thu bán các thành phẩm'
Update DMTK SET
 TenTK = N'Doanh thu cung cấp dịch vụ (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Sale returns', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'5123' AND TenTK=N'Doanh thu cung cấp dịch vụ'
Update DMTK SET
 TenTK = N'Các khoản giảm trừ doanh thu', TenTK2 = N'Purchase', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'521' AND TenTK=N'Chiết khấu thương mại'
Update DMTK SET
 TenTK = N'Hàng bán bị trả lại (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Raw material purchases', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'531' AND TenTK=N'Hàng bán bị trả lại'
Update DMTK SET
 TenTK = N'Giảm giá hàng bán (Ngưng sử dụng kể từ thông tư 200)', TenTK2 = N'Goods purchases', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'532' AND TenTK=N'Giảm giá hàng bán'
Update DMTK SET
 TenTK = N'Giá vốn hàng bán', TenTK2 = N'Employees cost', TKCongNo = 0, TKSoCai = 1, GradeTK = 1
 Where TK = N'632' AND TenTK=N'Giá vốn'
Update DMTK SET
 TenTK = N'Chi phí nhân viên', TenTK2 = N'Fixed asset depreciation', TKCongNo = 0, TKSoCai = 1, GradeTK = 2
 Where TK = N'6411' AND TenTK=N'Chi phí nhân viên bán hàng'

-- 2) Cập nhật Danh mục kết chuyển
Update DMKetChuyen set TkDich = '5111'
where MaCT = N'KCCKTM' and TkDich = '5112'