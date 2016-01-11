-- <Summary>
---- Insert dữ liệu ngầm vào bảng AT0099
-- <History>
---- Create on 13/02/2014 by Thanh Sơn: Khi Update không được sửa @CodeMaster và @ID
---- Modified on 2015-12-01 by Hoàng Vũ: Bổ sung thêm Các CodeMaster (AT00000001,AT00000002,AT00000003, AT00000004, AT00000005)
---- <Example>
DECLARE @CodeMaster VARCHAR(50), @OrderNo INT, @ID VARCHAR(50), @Description NVARCHAR(250), @DescriptionE NVARCHAR(250), @Disabled TINYINT

----------INVOICE
SET @CodeMaster = 'Invoice' 
SET @OrderNo = 1  
SET @ID = '01GTKT' 
SET @Description = N'Hoá đơn giá trị gia tăng' 
SET @DescriptionE = N'Hoá đơn giá trị gia tăng' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------
SET @OrderNo = 2  
SET @ID = '02GTTT' 
SET @Description = N'Hoá đơn bán hàng' 
SET @DescriptionE = N'Hoá đơn bán hàng' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
----------
SET @OrderNo = 3  
SET @ID = '06HDXK' 
SET @Description = N'Hoá đơn xuất khẩu' 
SET @DescriptionE = N'Hoá đơn xuất khẩu' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
-----------
SET @OrderNo = 4  
SET @ID = '07KPTQ' 
SET @Description = N'Hoá đơn bán hàng ( dành cho tổ chức, cá nhân trong khu phi thuế quan)' 
SET @DescriptionE = N'Hoá đơn bán hàng ( dành cho tổ chức, cá nhân trong khu phi thuế quan)' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
------------
SET @OrderNo = 5  
SET @ID = '03XKNB' 
SET @Description = N'Phiếu xuất kho kiêm vận chuyển hàng nội bộ' 
SET @DescriptionE = N'Phiếu xuất kho kiêm vận chuyển hàng nội bộ' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
-------------
SET @OrderNo = 6  
SET @ID = '04HGDL' 
SET @Description = N'Phiếu xuất kho gửi bán hàng đại lý' 
SET @DescriptionE = N'Phiếu xuất kho gửi bán hàng đại lý' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
-------------
SET @OrderNo = 7  
SET @ID = '01/'	 
SET @Description = N'Tem, vé, thẻ thuộc loại hoá đơn GTGT' 
SET @DescriptionE = N'Tem, vé, thẻ thuộc loại hoá đơn GTGT' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
-------------
SET @OrderNo = 8  
SET @ID = '02/'	 
SET @Description = N'Tem, vé, thẻ thuộc loại hoá đơn bán hàng' 
SET @DescriptionE = N'Tem, vé, thẻ thuộc loại hoá đơn bán hàng' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
-------------
SET @OrderNo = 9  
SET @ID = 'TT120'  
SET @Description = N'Hoá đơn theo TT 120/2002/TT-BTC' 
SET @DescriptionE = N'Hoá đơn theo TT 120/2002/TT-BTC' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
-------------
SET @OrderNo = 10 
SET @ID = '01TEDB' 
SET @Description = N'Tem vận tải đường bộ theo PP khấu trừ' 
SET @DescriptionE = N'Tem vận tải đường bộ theo PP khấu trừ' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
-------------
SET @OrderNo = 11 
SET @ID = '01VEDB' 
SET @Description = N'Vé vận tải đường bộ theo PP khấu trừ' 
SET @DescriptionE = N'Vé vận tải đường bộ theo PP khấu trừ' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
-------------
SET @OrderNo = 12 
SET @ID = '01THDB' 
SET @Description = N'Thẻ vận tải đường bộ theo PP khấu trừ' 
SET @DescriptionE = N'Thẻ vận tải đường bộ theo PP khấu trừ' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
--------------
SET @OrderNo = 13 
SET @ID = '02TEDB' 
SET @Description = N'Tem vận tải đường bộ theo PP trực tiếp' 
SET @DescriptionE = N'Tem vận tải đường bộ theo PP trực tiếp' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
--------------
SET @OrderNo = 14 
SET @ID = '02VWDB' 
SET @Description = N'Vé vận tải đường bộ theo PP trực tiếp' 
SET @DescriptionE = N'Vé vận tải đường bộ theo PP trực tiếp' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @OrderNo = 15 
SET @ID = '02THDB' 
SET @Description = N'Thẻ vận tải đường bộ theo PP trực tiếp' 
SET @DescriptionE = N'Thẻ vận tải đường bộ theo PP trực tiếp' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
----------INVOICE

---------------Phân trang
SET @CodeMaster = 'AT00000001'
SET @OrderNo = 1 
SET @ID = '1' 
SET @Description = N'10' 
SET @DescriptionE = N'Phân trang E' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @CodeMaster = 'AT00000001'
SET @OrderNo = 2 
SET @ID = '2' 
SET @Description = N'25' 
SET @DescriptionE = N'Phân trang E' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @CodeMaster = 'AT00000001'
SET @OrderNo = 3 
SET @ID = '3' 
SET @Description = N'50' 
SET @DescriptionE = N'Phân trang E' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @CodeMaster = 'AT00000001'
SET @OrderNo = 4 
SET @ID = '4' 
SET @Description = N'100' 
SET @DescriptionE = N'Phân trang E' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------Phân trang

---------------Xưng hô
SET @CodeMaster = 'AT00000002' 
SET @OrderNo = 1  
SET @ID = '1' 
SET @Description = N'Ông' 
SET @DescriptionE = N'Ông' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------
SET @CodeMaster = 'AT00000002' 
SET @OrderNo = 2  
SET @ID = '2' 
SET @Description = N'Bà' 
SET @DescriptionE = N'Bà' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------
SET @CodeMaster = 'AT00000002' 
SET @OrderNo = 3  
SET @ID = '3' 
SET @Description = N'Anh' 
SET @DescriptionE = N'Anh' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------
SET @CodeMaster = 'AT00000002' 
SET @OrderNo = 4  
SET @ID = '4' 
SET @Description = N'Chị' 
SET @DescriptionE = N'Chị' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------
SET @CodeMaster = 'AT00000002' 
SET @OrderNo = 5  
SET @ID = '5' 
SET @Description = N'Em' 
SET @DescriptionE = N'Em' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------Xưng hô

---------------Tình trạng đơn hàng
SET @CodeMaster = 'AT00000003' 
SET @OrderNo = 1  
SET @ID = '0' 
SET @Description = N'Chưa chấp nhận' 
SET @DescriptionE = N'Chưa chấp nhận' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @CodeMaster = 'AT00000003' 
SET @OrderNo = 2  
SET @ID = '1' 
SET @Description = N'Chấp nhận' 
SET @DescriptionE = N'Chấp nhận' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @CodeMaster = 'AT00000003' 
SET @OrderNo = 3  
SET @ID = '2' 
SET @Description = N'Đang giao hàng' 
SET @DescriptionE = N'Đang giao hàng' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @CodeMaster = 'AT00000003' 
SET @OrderNo = 4  
SET @ID = '3' 
SET @Description = N'Đã hoàn tất' 
SET @DescriptionE = N'Đã hoàn tất' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @CodeMaster = 'AT00000003' 
SET @OrderNo = 5  
SET @ID = '4' 
SET @Description = N'Tạm ngưng' 
SET @DescriptionE = N'Tạm ngưng' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @CodeMaster = 'AT00000003' 
SET @OrderNo = 6  
SET @ID = '5' 
SET @Description = N'Giữ chỗ' 
SET @DescriptionE = N'Giữ chỗ' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @CodeMaster = 'AT00000003' 
SET @OrderNo = 7  
SET @ID = '9' 
SET @Description = N'Hủy bỏ' 
SET @DescriptionE = N'Hủy bỏ' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------Tình trạng đơn hàng

---------------Dùng chung
SET @CodeMaster = 'AT00000004' 
SET @OrderNo = 0  
SET @ID = '%' 
SET @Description = N'Tất cả' 
SET @DescriptionE = N'Tất cả' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @CodeMaster = 'AT00000004' 
SET @OrderNo = 1  
SET @ID = '1' 
SET @Description = N'Có' 
SET @DescriptionE = N'Có' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @CodeMaster = 'AT00000004' 
SET @OrderNo = 2  
SET @ID = '0' 
SET @Description = N'Không' 
SET @DescriptionE = N'Không' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------Dùng chung


---------------Trạng thái
SET @CodeMaster = 'AT00000005' 
SET @OrderNo = 0  
SET @ID = '%' 
SET @Description = N'Tất cả' 
SET @DescriptionE = N'Tất cả' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @CodeMaster = 'AT00000005' 
SET @OrderNo = 1  
SET @ID = '0' 
SET @Description = N'Chưa hoàn tất' 
SET @DescriptionE = N'Chưa hoàn tất' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------
SET @CodeMaster = 'AT00000005' 
SET @OrderNo = 2  
SET @ID = '1' 
SET @Description = N'Hoàn tất' 
SET @DescriptionE = N'Hoàn tất' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO AT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE AT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------------Trạng thái