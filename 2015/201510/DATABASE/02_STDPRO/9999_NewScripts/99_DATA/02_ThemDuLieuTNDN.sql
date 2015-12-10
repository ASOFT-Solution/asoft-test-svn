/****** Object:  Table [dbo].[ToKhaiTNDN]    Script Date: 05/22/2012 09:55:25 ******/
DECLARE @sMaToKhai varchar(150)

Set @sMaToKhai = N'03/TNDN-TT28'

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Kết quả kinh doanh ghi nhận theo báo cáo tài chính')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 1, N'A', N'', N'Kết quả kinh doanh ghi nhận theo báo cáo tài chính', N'Business results reported as the financial statements', N'', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Tổng lợi nhuận kế toán trước thuế thu nhập doanh nghiệp')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 2, N'1', N'', N'Tổng lợi nhuận kế toán trước thuế thu nhập doanh nghiệp', N'Profit before tax corporate income', N'A1', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Xác định thu nhập chịu thuế theo Luật thuế thu nhập doanh nghiệp')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 3, N'B', N'', N'Xác định thu nhập chịu thuế theo Luật thuế thu nhập doanh nghiệp', N'Determination of taxable income under the Law on Corporate Income Tax', N'', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Điều chỉnh tăng tổng lợi nhuận trước thuế thu nhập doanh nghiệp (B1=B2+B3+B4+B5+B6)')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 4, N'1', N'', N'Điều chỉnh tăng tổng lợi nhuận trước thuế thu nhập doanh nghiệp (B1 = B2 + B3 + B4 + B5 + B6)', N'Adjust to increase total profit before corporate income tax (B1 = B2 + B3 + B4 + B5 + B6)', N'B1', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Các khoản điều chỉnh tăng doanh thu')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 5, N'1.1', N'', N'Các khoản điều chỉnh tăng doanh thu', N'Other adjustments to increase revenue', N'B2', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Chi phí phần doanh thu điều chỉnh giảm')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 6, N'1.2', N'', N'Chi phí phần doanh thu điều chỉnh giảm', N'Cost of revenue to decrease', N'B3', CAST(0.000000 AS Decimal(28, 6)), NULL)


IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Các khoản chi không được trừ khi xác định thu nhập chịu thuế')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 7, N'1.3', N'', N'Các khoản chi không được trừ khi xác định thu nhập chịu thuế', N'Expenses not deductible in determining taxable income', N'B4', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thuế thu nhập đã nộp cho phần thu nhập nhận được ở nước ngoài')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 8, N'1.4', N'', N'Thuế thu nhập đã nộp cho phần thu nhập nhận được ở nước ngoài', N'Income tax paid on the income received in foreign countries', N'B5', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Các khoản điều chỉnh làm tăng lợi nhuận trước thuế khác')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 9, N'1.5', N'', N'Các khoản điều chỉnh làm tăng lợi nhuận trước thuế khác', N'Other adjustments to increase profit before tax', N'B6', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Điều chỉnh giảm tổng lợi nhuận trước thuế thu nhập doanh nghiệp (B7 = B8 + B9 + B10 + B11)')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 10, N'2', N'', N'Điều chỉnh giảm tổng lợi nhuận trước thuế thu nhập doanh nghiệp (B7 = B8 + B9 + B10 + B11)', N'To decrease the total profit before corporate income tax (B7 = B8 + B9 + B10 + B11)', N'B7', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Lợi nhuận từ hoạt động không thuộc diện chịu thuế thu nhập doanh nghiệp')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 11, N'2.1', N'', N'Lợi nhuận từ hoạt động không thuộc diện chịu thuế thu nhập doanh nghiệp', N'Profit from operations not subject to corporate income tax', N'B8', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Giảm trừ các khoản doanh thu đã tính thuế năm trước')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 12, N'2.2', N'', N'Giảm trừ các khoản doanh thu đã tính thuế năm trước', N'Reductions in revenue before taxation', N'B9', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Chi phí của phần doanh thu điều chỉnh tăng')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 13, N'2.3', N'', N'Chi phí của phần doanh thu điều chỉnh tăng', N'Cost of revenues to increase', N'B10', CAST(0.000000 AS Decimal(28, 6)), NULL)


IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Các khoản điều chỉnh làm giảm lợi nhuận trước thuế khác')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 14, N'2.4', N'', N'Các khoản điều chỉnh làm giảm lợi nhuận trước thuế khác', N'Other adjustments reduce profit before tax', N'B11', CAST(0.000000 AS Decimal(28, 6)), NULL)


IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Tổng thu nhập chịu thuế (B12 = A1 + B1 - B7)')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 15, N'3', N'', N'Tổng thu nhập chịu thuế (B12 = A1 + B1 - B7)', N'Total taxable income (B12 = A1 + B1-B7)', N'B12', CAST(0.000000 AS Decimal(28, 6)), NULL)


IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thu nhập từ hoạt động sản xuất kinh doanh (B13 = B12 - B14)')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 16, N'3.1', N'', N'Thu nhập từ hoạt động sản xuất kinh doanh (B13 = B12 - B14)', N'Income from business activities (B13 = B12 - B14)', N'B13', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thu nhập chịu thuế từ hoạt động chuyển nhượng bất động sản')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 17, N'3.2', N'', N'Thu nhập chịu thuế từ hoạt động chuyển nhượng bất động sản', N'Taxable income from the transfer of property', N'B14', CAST(0.000000 AS Decimal(28, 6)), NULL)


IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Xác định số thuế thu nhập doanh nghiệp phải nộp trong kỳ tính thuế')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 18, N'C', N'', N'Xác định số thuế thu nhập doanh nghiệp phải nộp trong kỳ tính thuế', N'Determination of the enterprise income tax payable in the tax period', N'', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thu nhập chịu thuế (C1 = B13)')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 19, N'1', N'', N'Thu nhập chịu thuế (C1 = B13)', N'Taxable income (C1 = B13)', N'C1', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thu nhập miễn thuế')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 20, N'2', N'', N'Thu nhập miễn thuế', N'Income tax exemption', N'C2', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Lỗ từ các năm trước được chuyển sang')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 21, N'3', N'', N'Lỗ từ các năm trước được chuyển sang', N'Loss from previous years are transferred to', N'C3', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thu nhập tính thuế (C4 = C1 - C2 - C3)')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 22, N'4', N'', N'Thu nhập tính thuế (C4 = C1 - C2 - C3)', N'Taxable income (C4 = C1 - C2 - C3)', N'C4', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Trích lập quỹ khoa học công nghệ (nếu có)')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 23, N'5', N'', N'Trích lập quỹ khoa học công nghệ (nếu có)', N'Appropriation of science and technology funds (if any)', N'C5', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thu nhập tính thuế sau khi đã trích lập quỹ khoa học công nghệ (C6 = C4 - C5)')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 24, N'6', N'', N'Thu nhập tính thuế sau khi đã trích lập quỹ khoa học công nghệ (C6 = C4 - C5)', N'Taxable income after deduction of science and technology funds (C6 = C4 - C5)', N'C6', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thuế TNDN từ hoạt động SXKD tính theo thuế suất phổ thông (C7 = C6 x 25%)')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 25, N'7', N'', N'Thuế TNDN từ hoạt động SXKD tính theo thuế suất phổ thông (C7 = C6 x 25%)', N'Corporate income tax from production and business activities taxed at the rate (C7 = C6 x 25%)', N'C7', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thuế TNDN chênh lệch do áp dụng thuế suất khác mức thuế suất 25%')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 26, N'8', N'', N'Thuế TNDN chênh lệch do áp dụng thuế suất khác mức thuế suất 25%', N'Income tax difference due to different tax rate tax rate of 25%', N'C8', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thuế TNDN được miễn, giảm trong kỳ')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 27, N'9', N'', N'Thuế TNDN được miễn, giảm trong kỳ', N'Corporate income tax exemption or reduction in public', N'C9', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Số thuế thu nhập đã nộp ở nước ngoài được trừ trong kỳ tính thuế')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 28, N'10', N'', N'Số thuế thu nhập đã nộp ở nước ngoài được trừ trong kỳ tính thuế', N'The income tax already paid abroad are deducted in the tax period', N'C10', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thuế thu nhập doanh nghiệp của hoạt động sản xuất kinh doanh (C11 = C7 - C8 - C9 - C10)')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 29, N'11', N'', N'Thuế thu nhập doanh nghiệp của hoạt động sản xuất kinh doanh (C11 = C7 - C8 - C9 - C10)', N'Corporate income tax of business activity (C11 = C7 - C8 - C9 - C10)', N'C11', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thuế TNDN từ hoạt động chuyển quyền sử dụng đất, chuyển quyền thuê đất đã nộp ở tỉnh/thành phố ngoài nơi đóng trụ sở chính')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 30, N'D', N'', N'Thuế TNDN từ hoạt động chuyển quyền sử dụng đất, chuyển quyền thuê đất đã nộp ở tỉnh/thành phố ngoài nơi đóng trụ sở chính', N'Corporate income tax from the transfer of land use rights, land lease was paid in provinces / cities where they are headquartered outside', N'D', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Tổng số thuế TNDN phải nộp trong kỳ')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 31, N'E', N'', N'Tổng số thuế TNDN phải nộp trong kỳ', N'Total income tax payable in the period', N'E', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thuế thu nhập doanh nghiệp của hoạt động sản xuất kinh doanh')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 32, N'1', N'', N'Thuế thu nhập doanh nghiệp của hoạt động sản xuất kinh doanh', N'Corporate income tax of business activities', N'E1', CAST(0.000000 AS Decimal(28, 6)), NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [ToKhaiTNDN] WHERE  [MaToKhai] = @sMaToKhai 
							AND [TenChiTieu] =N'Thuế TNDN từ hoạt động chuyển nhượng bất động sản')
INSERT [dbo].[ToKhaiTNDN] ([MaToKhai], [SortOrder], [Stt1], [Stt2], [TenChiTieu], [TenChiTieu2], [MaCode], [TTien], [GhiChu]) VALUES (@sMaToKhai, 33, N'2', N'', N'Thuế TNDN từ hoạt động chuyển nhượng bất động sản', N'Corporate income tax from the transfer of property', N'E2', CAST(0.000000 AS Decimal(28, 6)), NULL)