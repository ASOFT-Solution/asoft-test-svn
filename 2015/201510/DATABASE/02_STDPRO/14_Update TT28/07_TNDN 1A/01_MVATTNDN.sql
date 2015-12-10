-- [MVATTNDN]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MVATTNDN]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[MVATTNDN](
	[MVATTNDNID] [uniqueidentifier] NOT NULL,
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[MauBaoCao] [nvarchar](128) NOT NULL,
	[Nam1] [int] NULL,
	[Nam2] [int] NULL,
	[ChonKy] [int] NULL,
	[TuKy] [int] NULL,
	[DenKy] [int] NULL,
	[Quy] [int] NULL,
	[Ngay] [smalldatetime] NULL,
	[InLanDau] [bit] NULL,
	[SoLanIn] [int] NULL,
	[PhuThuoc] [bit] NULL,
	[DienGiai] [nvarchar](400) NULL,
	[TaiLieu1] [nvarchar](400) NULL,
	[TaiLieu2] [nvarchar](400) NULL,
	[TaiLieu3] [nvarchar](400) NULL,
	[TaiLieu4] [nvarchar](400) NULL,
	[TaiLieu5] [nvarchar](400) NULL,
	[TaiLieu6] [nvarchar](400) NULL,
	[GiaHan] [int] NULL,
 CONSTRAINT [PK_MVATTNDN] PRIMARY KEY CLUSTERED 
(
	[MVATTNDNID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
GO

-- [DVATTNDN]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DVATTNDN]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[DVATTNDN](
	[DVATTNDNID] [uniqueidentifier] NOT NULL,
	[MVATTNDNID] [uniqueidentifier] NULL,
	[SortOrder] [int] NOT NULL,
	[Stt1] [nvarchar](128) NULL,
	[Stt2] [nvarchar](128) NULL,
	[TenChiTieu] [nvarchar](400) NULL,
	[TenChiTieu2] [nvarchar](400) NULL,
	[MaCode] [nvarchar](128) NULL,
	[TTien] [decimal](20, 6) NULL,
	[GhiChu] [nvarchar](128) NULL,
 CONSTRAINT [PK_DVATTNDN] PRIMARY KEY CLUSTERED 
(
	[DVATTNDNID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DVATTNDN]  WITH CHECK ADD  CONSTRAINT [FK_DVATTNDN_MVATTNDN2] FOREIGN KEY([MVATTNDNID])
REFERENCES [dbo].[MVATTNDN] ([MVATTNDNID])

ALTER TABLE [dbo].[DVATTNDN] CHECK CONSTRAINT [FK_DVATTNDN_MVATTNDN2]

ALTER TABLE [dbo].[DVATTNDN] ADD  CONSTRAINT [DF_DVATTNDN_TTien]  DEFAULT ('0') FOR [TTien]

END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ToKhaiTNDN]') AND type in (N'U'))
drop table [ToKhaiTNDN]

CREATE TABLE [dbo].[ToKhaiTNDN](
	[MaToKhai] [nvarchar](128) NULL,
	[SortOrder] [int] NULL,
	[Stt1] [nvarchar](128) NULL,
	[Stt2] [nvarchar](128) NULL,
	[TenChiTieu] [nvarchar](400) NULL,
	[TenChiTieu2] [nvarchar](400) NULL,
	[MaCode] [nvarchar](128) NULL,
	[TTien] [decimal](20, 6) NULL,
	[GhiChu] [nvarchar](128) NULL,
) ON [PRIMARY]
GO

INSERT [ToKhaiTNDN] ([MaToKhai], [SortOrder], [MaCode], [TTien], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [GhiChu])
-- 1A/TNDN-TT28
          SELECT N'1A/TNDN-TT28', 1, N'[21]', 0, N'1', N'', N'Doanh thu phát sinh trong kỳ', NULL, NULL
UNION ALL SELECT N'1A/TNDN-TT28', 2, N'[22]', 0, N'2', N'', N'Chi phí phát sinh trong kỳ', NULL, NULL
UNION ALL SELECT N'1A/TNDN-TT28', 3, N'[23]', 0, N'3', N'', N'Lợi nhuận phát sinh trong kỳ ([23]=[21]-[22])', NULL, NULL
UNION ALL SELECT N'1A/TNDN-TT28', 4, N'[24]', 0, N'4', N'', N'Điều chỉnh tăng lợi nhuận theo pháp luật thuế', NULL, NULL
UNION ALL SELECT N'1A/TNDN-TT28', 5, N'[25]', 0, N'5', N'', N'Điều chỉnh giảm lợi nhuận theo pháp luật thuế', NULL, NULL
UNION ALL SELECT N'1A/TNDN-TT28', 6, N'[26]', 0, N'6', N'', N'Thu nhập chịu thuế ([26]=[23]+[24]-[25])', NULL, NULL
UNION ALL SELECT N'1A/TNDN-TT28', 7, N'[27]', 0, N'7', N'', N'Thu nhập miễn thuế', NULL, NULL
UNION ALL SELECT N'1A/TNDN-TT28', 8, N'[28]', 0, N'8', N'', N'Số lỗ chuyển kỳ này', NULL, NULL
UNION ALL SELECT N'1A/TNDN-TT28', 9, N'[29]', 0, N'9', N'', N'TN tính thuế ([29]=[26]-[27]-[28])', NULL, NULL
UNION ALL SELECT N'1A/TNDN-TT28', 10, N'[30]', 5, N'10', N'', N'Thuế suất thuế TNDN (%)', NULL, NULL
UNION ALL SELECT N'1A/TNDN-TT28', 11, N'[31]', 0, N'11', N'', N'Thuế TNDN sự kiến miễn, giảm', NULL, NULL
UNION ALL SELECT N'1A/TNDN-TT28', 12, N'[32]', 0, N'12', N'', N'Thuế TNDN phải nộp trong kỳ ([32]=[29]*[30]-[31])', NULL, NULL
-- 1B/TNDN-TT28
UNION ALL SELECT N'1B/TNDN-TT28', 1, N'[21]', 0, N'1', N'', N'Doanh thu phát sinh trong kỳ', NULL, NULL
UNION ALL SELECT N'1B/TNDN-TT28', 2, N'[22]', 0, N'', N'a', N'Doanh thu theo thuế suất chung', NULL, NULL
UNION ALL SELECT N'1B/TNDN-TT28', 3, N'[23]', 0, N'', N'b', N'Doanh thu của dự án theo thuế suất ưu đãi', NULL, NULL
UNION ALL SELECT N'1B/TNDN-TT28', 4, N'[24]', 0, N'2', N'', N'Tỷ lệ thu nhập chịu thuế trên doanh thu (%)', NULL, NULL
UNION ALL SELECT N'1B/TNDN-TT28', 5, N'', 0, N'3', N'', N'Thuế suất', NULL, NULL
UNION ALL SELECT N'1B/TNDN-TT28', 6, N'[25]', 25, N'', N'a', N'Thuế suất chung (%)', NULL, NULL
UNION ALL SELECT N'1B/TNDN-TT28', 7, N'[26]', 0, N'', N'b', N'Thuế suất ưu đãi (%)', NULL, NULL
UNION ALL SELECT N'1B/TNDN-TT28', 8, N'[27]', 0, N'4', N'', N'Thuế thu nhập doanh nghiệp phát sinh trong kỳ ([27]=[28]+[29])', NULL, NULL
UNION ALL SELECT N'1B/TNDN-TT28', 9, N'[28]', 0, N'', N'a', N'Thuế thu nhập doanh nghiệp tính theo thuế suất chung ([28]=[22]*[24]*[25])', NULL, NULL
UNION ALL SELECT N'1B/TNDN-TT28', 10, N'[29]', 0, N'', N'b', N'Thuế thu nhập doanh nghiệp tính theo thuế suất ưu đãi ([29]=[23]*[24]*[26])', NULL, NULL
UNION ALL SELECT N'1B/TNDN-TT28', 11, N'[30]', 0, N'5', N'', N'Thuế thu nhập doanh nghiệp dự kiến miễn, giảm', NULL, NULL
UNION ALL SELECT N'1B/TNDN-TT28', 12, N'[31]', 0, N'6', N'', N'Thuế TNDN phải nộp trong kỳ ([31]=[27]-[30])', NULL, NULL
-- 03/TNDN-TT60
UNION ALL SELECT N'03/TNDN-TT60', 1, N'', 0, N'A', N'', N'Kết quả kinh doanh ghi nhận theo báo cáo tài chính', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 2, N'A1', 0, N'1', N'', N'Tổng lợi nhuận kế toán trước thuế thu nhập doanh nghiệp', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 3, N'', 0, N'B', N'', N'Xác định thu nhập chịu thuế theo Luật thuế thu nhập doanh nghiệp', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 4, N'B1', 0, N'1', N'', N'Điều chỉnh tăng tổng lợi nhuận trước thuế thu nhập doanh nghiệp (B1=B2+B3+...+B16)', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 5, N'B2', 0, N'1.1', N'', N'Các khoản điều chỉnh tăng doanh thu', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 6, N'B3', 0, N'1.2', N'', N'Chi phí phần doanh thu điều chỉnh giảm', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 7, N'B4', 0, N'1.3', N'', N'Thuế thu nhập đã nộp cho phần thu nhập nhận được ở nước ngoài', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 8, N'B5', 0, N'1.4', N'', N'Chi phí khấu hao TSCĐ không đúng quy định', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 9, N'B6', 0, N'1.5', N'', N'Chi phí lãi tiền vay vượt mức khống chế theo quy định', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 10, N'B7', 0, N'1.6', N'', N'Chi phí không có hóa đơn, chứng từ theo chế độ quy định', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 11, N'B8', 0, N'1.7', N'', N'Các khoản thuế bị truy thu và tiền phạt về vi phạm hành chính đã tính vào chi phí', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 12, N'B9', 0, N'1.8', N'', N'Chi phí không liên quan đến doanh thu, thu nhập chịu thuế thu nhập doanh nghiệp', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 13, N'B10', 0, N'1.9', N'', N'Chi phí tiền lương, tiền công không được tính vào chi phí hợp lý do vi phạm chế độ hợp đồng lao động, chi phí tiền lương, tiền công của chủ doanh nghiệp tư nhân, thành viên hợp danh, chủ hộ cá thể, cá nhân kinh doanh và tiền thù lao trả cho sáng lập viên, thành viên hội đồng quản trị của công ty cổ phần, công ty trách nhiệm hữu hạn không trực tiếp tham gia điều hành sản xuất kinh doanh', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 14, N'B11', 0, N'1.10', N'', N'Các khoản trích trước vào chi phí mà thực tế không chi', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 15, N'B12', 0, N'1.11', N'', N'Chi phí tiền ăn giữa các ca vượt mức quy định', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 16, N'B13', 0, N'1.12', N'', N'Chi phí quản lý kinh doanh do công ty ở nước ngoài phân bổ vượt mức quy định', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 17, N'B14', 0, N'1.13', N'', N'Lỗ chênh lệch tỷ giá hối đoái do đánh giá lại các khoản mục tiền tệ có nguồn gốc ngoại tệ tại thời điểm cuối năm tài chính', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 18, N'B15', 0, N'1.14', N'', N'Chi phí quảng cáo, tiếp thị, khuyến mại, tiếp tân, khánh tiết, chi phí giao dịch đối ngoại, chi hoa hồng môi giới, chi phí hội nghị và các chi phí khác vượt mức quy định', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 19, N'B16', 0, N'1.15', N'', N'Các khoản điều chỉnh làm tăng lợi nhuận trước thuế khác', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 20, N'B17', 0, N'2', N'', N'Điều chỉnh giảm tổng lợi nhuận trước thuế thu nhập doanh nghiệp (B17 = B18 + B19 + B20 + B21 + B22)', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 21, N'B18', 0, N'2.1', N'', N'Lợi nhuận từ hoạt động không thuộc diện chịu thuế thu nhập doanh nghiệp', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 22, N'B19', 0, N'2.2', N'', N'Giảm trừ các khoản doanh thu đã tính thuế năm trước', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 23, N'B20', 0, N'2.3', N'', N'Chi phí của phần doanh thu điều chỉnh tăng', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 24, N'B21', 0, N'2.4', N'', N'Lãi chênh lệch tỷ giá hối đoái do đánh giá lại các khoản mục tiền tệ có nguồn gốc ngoại tệ tại thời điểm cuối năm tài chính', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 25, N'B22', 0, N'2.5', N'', N'Các khoản điều chỉnh làm giảm lợi nhuận trước thuế khác', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 26, N'B23', 0, N'3', N'', N'Tổng thu nhập chịu thuế thu nhập doanh nghiệp chưa trừ chuyển lỗ (B23 = A1 + B1 - B17)', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 27, N'B24', 0, N'3.1', N'', N'Thu nhập từ hoạt động SXKD (trừ thu nhập từ chuyển quyền sử dụng đất, chuyển quyền thuê đất)', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 28, N'B25', 0, N'3.2', N'', N'Thu nhập từ chuyển quyền sử dụng đất, chuyển quyền thuê đất', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 29, N'B26', 0, N'4', N'', N'Lỗ từ các năm trước chuyển sang (B26 = B27 + B28)', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 30, N'B27', 0, N'4.1', N'', N'Lỗ từ hoạt động SXKD (trừ lỗ chuyển quyền sử dụng đất, chuyển quyền thuê đất)', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 31, N'B28', 0, N'4.2', N'', N'Lỗ từ chuyển quyền sử dụng đất, chuyển quyền thuê đất', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 32, N'B29', 0, N'5', N'', N'Tổng thu nhập chịu thuế thu nhập doanh nghiệp (đã trừ chuyển lỗ) (B29 = B30 + B31)', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 33, N'B30', 0, N'5.1', N'', N'Thu nhập từ hoạt động SXKD (trừ thu nhập từ hoạt động chuyển quyền sử dụng đất, chuyển quyền thuê đất) (B30 = B24 - B27)', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 34, N'B31', 0, N'5.2', N'', N'Thu nhập từ hoạt động chuyển quyền sử dụng đất, chuyển quyền thuê đất (B31 = B25 - B28)', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 35, N'', 0, N'C', N'', N'Xác định số thuế thu nhập doanh nghiệp phải nộp trong kỳ tính thuế', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 36, N'C1', 0, N'1', N'', N'Thuế TNDN từ hoạt động SXKD (C1 = C2 - C3 - C4 - C5)', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 37, N'C2', 0, N'1.1', N'', N'Thuế TNDN từ hoạt động SXKD tính theo thuế suất phổ thông (C2 = B30 x 25%)', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 38, N'C3', 0, N'1.2', N'', N'Thuế TNDN chênh lệch do áp dụng thuế suất khác mức thuế suất 25%', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 39, N'C4', 0, N'1.3', N'', N'Thuế thu nhập doanh nghiệp được miễn, giảm trong kỳ tính thuế', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 40, N'C5', 0, N'1.4', N'', N'Số thuế thu nhập đã nộp ở nước ngoài được trừ trong kỳ tính thuế', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 41, N'C6', 0, N'2', N'', N'Thuế TNDN từ hoạt động chuyển quyền sử dụng đất, chuyển quyền thuê đất (C6 = C7 + C8 - C9)', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 42, N'C7', 0, N'2.1', N'', N'Thuế thu nhập doanh nghiệp đối với thu nhập từ chuyển quyền sử dụng đất, chuyển quyền thuê đất (C7 = B31 x 25%)', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 43, N'C8', 0, N'2.2', N'', N'Thuế thu nhập bổ sung từ thu nhập chuyển quyền sử dụng đất, chuyển quyền thuê đất', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 44, N'C9', 0, N'2.3', N'', N'Thuế TNDN từ hoạt động chuyển quyền sử dụng đất, chuyển quyền thuê đất đã nộp ở tỉnh/thành phố ngoài nơi đóng trụ sở chính', NULL, NULL
UNION ALL SELECT N'03/TNDN-TT60', 45, N'C10', 0, N'3', N'', N'Thuế thu nhập doanh nghiệp phát sinh phải nộp trong kỳ tính thuế (C10 = C1 + C6)', NULL, NULL