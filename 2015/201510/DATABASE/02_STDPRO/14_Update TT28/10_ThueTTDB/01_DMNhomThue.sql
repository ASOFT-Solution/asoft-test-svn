IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMThueTTDB]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[DMThueTTDB](
	[MaNhomTTDB] [varchar](16) NOT NULL,
	[TenNhomTTDB] [nvarchar](512) NOT NULL,
	[TenNhomTTDB2] [nvarchar](512) NULL,
	[MaNhomTTDBCha] [varchar](16) NULL,
	[ThueSuatTTDB] [decimal](20, 6) NOT NULL,
	[DVT] [nvarchar](128) NULL,
	[GhiChu] [ntext] NULL,
 CONSTRAINT [PK_DMThueTTDB] PRIMARY KEY CLUSTERED 
(
	[MaNhomTTDB] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_PADDING OFF

ALTER TABLE [dbo].[DMThueTTDB] ADD  CONSTRAINT [DF_DMThueTTDB_ThueSuatTTDB]  DEFAULT ('0') FOR [ThueSuatTTDB]

INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I', N'Hàng hoá', N'', N'', CAST(0.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.1', N'Thuốc lá điếu, xì gà và các chế phẩm khác từ cây thuốc lá', N'', N'I', CAST(0.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.1.1', N'Xì gà', N'', N'I.1', CAST(65.000000 AS Decimal(20, 6)), N'', N'Bao')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.1.2', N'Thuốc lá điếu', N'', N'I.1', CAST(65.000000 AS Decimal(20, 6)), N'', N'Bao')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.1.3', N'Các chế phẩm khác từ cây thuốc lá', N'', N'I.1', CAST(65.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.10', N'Bài lá', N'', N'I.', CAST(40.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.11', N'Vàng mã, hàng mã', N'', N'I.', CAST(70.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.2', N'Rượu', N'', N'I', CAST(0.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.2.1', N'Rượu từ 20 độ trở lên', N'', N'I.2', CAST(45.000000 AS Decimal(20, 6)), N'', N'Lít')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.2.2', N'Rượu dưới 20 độ, rượu hoa quả, rượu thuốc ', N'', N'I.2', CAST(25.000000 AS Decimal(20, 6)), N'', N'Lít')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.3', N' Bia', N'', N'I', CAST(45.000000 AS Decimal(20, 6)), N'', N'Lít')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4', N'Xe ô tô dưới 24 chỗ', N'', N'I', CAST(0.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.1', N' Xe ô tô chở người từ 9 chỗ trở xuống', N'', N'I.4', CAST(0.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.1.1', N'Loại có dung tích xi lanh từ 2.000 cm3 trở xuống', N'', N'I.4.1', CAST(45.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.1.2', N'Loại có dung tích xi lanh trên 2.000 cm3 đến 3.000 cm3', N'', N'I.4.1', CAST(50.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.1.3', N'Loại có dung tích xi lanh trên 3.000 cm3      ', N'', N'I.4.1', CAST(60.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.2', N'Xe ô tô chở người từ 10 đến dưới 16 chỗ  ', N'', N'I.4', CAST(30.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.3', N' Xe ô tô chở người từ 16 đến dưới 24 chỗ', N'', N'I.4', CAST(15.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.4', N'Xe ô tô vừa chở người, vừa chở hàng', N'', N'I.4', CAST(15.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.5', N'Xe ô tô chạy bằng xăng kết hợp năng lượng điện, năng lượng sinh học, trong đó tỷ trọng xăng sử dụng không quá 70% số năng lượng sử dụng.', N'', N'I.4', CAST(0.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.5.1', N' Xe ô tô chở người từ 9 chỗ trở xuống', N'', N'I.4.5', CAST(0.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.5.1.1', N'Loại có dung tích xi lanh từ 2.000 cm3 trở xuống', N'', N'I.4.5.1', CAST(31.500000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.5.1.2', N'Loại có dung tích xi lanh trên 2.000 cm3 đến 3.000 cm3', N'', N'I.4.5.1', CAST(35.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.5.1.3', N'Loại có dung tích xi lanh trên 3.000 cm3      ', N'', N'I.4.5.1', CAST(42.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.5.2', N'Xe ô tô chở người từ 10 đến dưới 16 chỗ  ', N'', N'I.4.5', CAST(21.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.5.3', N' Xe ô tô chở người từ 16 đến dưới 24 chỗ', N'', N'I.4.5', CAST(10.500000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.5.4', N'Xe ô tô vừa chở người, vừa chở hàng', N'', N'I.4.5', CAST(10.500000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.6', N'Xe ô tô chạy bằng năng lượng sinh học', N'', N'I.4', CAST(0.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.6.1', N' Xe ô tô chở người từ 9 chỗ trở xuống', N'', N'I.4.6', CAST(0.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.6.1.1', N'Loại có dung tích xi lanh từ 2.000 cm3 trở xuống', N'', N'I.4.6.1', CAST(22.500000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.6.1.2', N'Loại có dung tích xi lanh trên 2.000 cm3 đến 3.000 cm3', N'', N'I.4.6.1', CAST(25.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.6.1.3', N'Loại có dung tích xi lanh trên 3.000 cm3      ', N'', N'I.4.6.1', CAST(30.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.6.2', N'Xe ô tô chở người từ 10 đến dưới 16 chỗ  ', N'', N'I.4.6', CAST(15.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.6.3', N' Xe ô tô chở người từ 16 đến dưới 24 chỗ', N'', N'I.4.6', CAST(7.500000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.6.4', N'Xe ô tô vừa chở người, vừa chở hàng', N'', N'I.4.6', CAST(7.500000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.7', N'Xe ô tô chạy bằng điện', N'', N'I.4', CAST(0.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.7.1', N'Loại chở người từ 9 chỗ trở xuống', N'', N'I.4.7', CAST(25.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.7.2', N'Loại chở người từ 10 đến dưới 16 chỗ  ', N'', N'I.4.7', CAST(15.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.7.3', N'Loại chở người từ 16 đến dưới 24 chỗ', N'', N'I.4.7', CAST(10.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.4.7.4', N'Loại thiết kế vừa chở người, vừa chở hàng', N'', N'I.4.7', CAST(10.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.5', N'Xe mô tô hai bánh, xe mô tô ba bánh có dung tích xi lanh trên 125cm3', N'', N'I', CAST(20.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.6', N'Tàu bay', N'', N'I', CAST(30.000000 AS Decimal(20, 6)), N'', N'Chiếc')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.7', N'Du thuyền', N'', N'I', CAST(30.000000 AS Decimal(20, 6)), N'', N'Chiếc')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.8', N'Xăng các loại, nap-ta, chế phẩm tái hợp và các chế phẩm khác để pha chế xăng', N'', N'I', CAST(10.000000 AS Decimal(20, 6)), N'', N'Lít')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'I.9', N'Điều hoà nhiệt độ công suất từ 90.000 BTU trở xuống', N'', N'I', CAST(10.000000 AS Decimal(20, 6)), N'', N'Cái')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'II', N'Dịch vụ', N'', N'', CAST(0.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'II.1', N'Kinh doanh vũ trường, Kinh doanh mát-xa, ka-ra-ô-kê', N'', N'II', CAST(0.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'II.1.1', N'Kinh doanh vũ trường', N'', N'II.1', CAST(40.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'II.1.2', N'Kinh doanh mát-xa, ka-ra-ô-kê', N'', N'II.1', CAST(30.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'II.3', N'Kinh doanh ca-si-nô, trò chơi điện tử có thưởng', N'', N'II', CAST(30.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'II.4', N'Kinh doanh đặt cược', N'', N'II', CAST(30.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'II.5', N'Kinh doanh gôn', N'', N'II', CAST(20.000000 AS Decimal(20, 6)), N'', N'')
INSERT [dbo].[DMThueTTDB] ([MaNhomTTDB], [TenNhomTTDB], [TenNhomTTDB2], [MaNhomTTDBCha], [ThueSuatTTDB], [GhiChu], [DVT]) VALUES (N'II.6', N'Kinh doanh xổ số', N'', N'II', CAST(15.000000 AS Decimal(20, 6)), N'', N'')

END

