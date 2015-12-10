-- QĐ15

-- Thêm DMTK
if not exists (select top 1 1 from DMTK where TK = '3389')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai]) VALUES (N'3389', N'338', N'Bảo hiểm thất nghiệp', N'Unemployment Insurance', 0, 1)

if not exists (select top 1 1 from DMTK where TK = '356')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai]) VALUES (N'356', NULL, N'Quỹ phát triển khoa học và công nghệ', N'The development of science and technology fund', 0, 1)

if not exists (select top 1 1 from DMTK where TK = '3561')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai]) VALUES (N'3561', N'356', N'Quỹ phát triển khoa học và công nghệ', N'The development of science and technology fund', 0, 1)

if not exists (select top 1 1 from DMTK where TK = '3562')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai]) VALUES (N'3562', N'356', N'Quỹ PT KH và CN đã hình thành TSCD', N'The development of science and technology fund that form the fixed assets', 0, 1)

if not exists (select top 1 1 from DMTK where TK = '5118')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai]) VALUES (N'5118', N'511', N'Doanh thu khác', N'Other income', 0, 1)

if not exists (select top 1 1 from DMTK where TK = '417')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai]) VALUES (N'417', NULL, N'Quỹ hỗ trợ sắp xếp doanh nghiệp', N'Fund to support the enterprise reorganization', 0, 1)

if not exists (select top 1 1 from DMTK where TK = '129')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai]) VALUES (N'129 ', NULL, N'Dự phòng giảm giá đầu tư ngắn hạn khác', N'Provision for diminution in value of short-term investments', 0, 1)

if not exists (select top 1 1 from DMTK where TK = '353')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai]) VALUES (N'353', NULL, N'Quỹ khen thưởng, phúc lợi', N'Reward fund and welfare', 0, 1)

if not exists (select top 1 1 from DMTK where TK = '3531')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai]) VALUES (N'3531', N'353', N'Quỹ khen thưởng', N'The reward fund', 0, 1)

if not exists (select top 1 1 from DMTK where TK = '3532')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai]) VALUES (N'3532', N'353', N'Quỹ phúc lợi', N'The welfare fund', 0, 1)

if not exists (select top 1 1 from DMTK where TK = '3533')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai]) VALUES (N'3533', N'353', N'Quỹ phúc lợi đã hình thành TSCD', N'Welfare fund for fixed asset', 0, 1)

if not exists (select top 1 1 from DMTK where TK = '3534')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai]) VALUES (N'3534', N'353', N'Quỹ thưởng ban điều hành Cty', N'Reward Fund Executive Board Company', 0, 1)

-- Sửa đổi danh mục kết chuyển
delete from DMKetChuyen

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCCPNL', N'621', N'154', 1, 0, 0, 0, N'Kết chuyển chi phí nguyên vật liệu', 0, 0, 0, N'To transfer the cost of raw materials  ')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCCPNCTT', N'622', N'154', 1, 0, 0, 0, N'Kết chuyển chi phí nhân công trực tiếp', 1, 0, 0, N'Transferred direct labor costs ')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCCPMTC', N'623', N'154', 1, 0, 0, 0, N'Kết chuyển chi phí máy thi công', 2, 0, 0, N'The transfer costs of construction machines')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCCPSXC', N'627', N'154', 1, 0, 0, 0, N'Kết chuyển chi phí sản xuất chung', 3, 0, 0, N'Forward the overall production costs ')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCTGHD', N'4131', N'515', 0, 0, 0, 0, N'Kết chuyển lãi chênh lệch tỷ giá hối đoái', 4, 0, 0, N'Forward interest rate exchange differences')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCHDLO', N'4131', N'635', 1, 0, 0, 0, N'Kết chuyển lỗ chênh lệch tỷ giá hối đoái', 5, 0, 0, N'The switching losses of exchange rate differences')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCCKTM', N'521', N'5112', 1, 0, 0, 0, N'Kết chuyển chiết khấu thương mại', 6, 0, 0, N'Carry forward the trade discounts')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCGGHB', N'532', N'5111', 1, 0, 0, 0, N'Kết chuyển giảm giá hàng bán', 7, 0, 0, N'Forward reduced sales rebate')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCHBTL', N'531', N'5111', 1, 0, 0, 0, N'Kết chuyển hàng bán trả lại', 8, 0, 0, N'Transferred back to sales')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCDTBH', N'511', N'911', 0, 0, 0, 0, N'Kết chuyển doanh thu bán hàng', 20, 0, 0, N'Carry forward sales')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCGDTBH', N'511', N'911', 1, 0, 0, 0, N'Kết chuyển giảm doanh thu bán hàng', 21, 0, 0, N'The move reduced sales')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCDTNB', N'512', N'911', 0, 0, 0, 0, N'Kết chuyển doanh thu bán hàng nội bộ', 25, 0, 0, N'The transfer of internal sales')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCGDTNB', N'512', N'911', 1, 0, 0, 0, N'Kết chuyển giảm doanh thu bán hàng nội bộ', 26, 0, 0, N'The transfer of reduced internal sales')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCDTTC', N'515', N'911', 0, 0, 0, 0, N'Kết chuyển doanh thu tài chính', 30, 0, 0, N'Transferred financial revenues')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCGDTTC', N'515', N'911', 1, 0, 0, 0, N'Kết chuyển giảm doanh thu tài chính', 31, 0, 0, N'Transferred of reduced financial revenues')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCGV', N'632', N'911', 1, 0, 0, 0, N'Kết chuyển giá vốn', 35, 0, 0, N'Add transfer cost ')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCGGV', N'632', N'911', 0, 0, 0, 0, N'Kết chuyển giảm giá vốn', 36, 0, 0, N'Add transfer reduced the cost')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCCPTC', N'635', N'911', 1, 0, 0, 0, N'Kết chuyển chi phí tài chính', 40, 0, 0, N'Transferred financial costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCGCPTC', N'635', N'911', 0, 0, 0, 0, N'Kết chuyển giảm chi phí tài chính', 41, 0, 0, N'Transferred financial reduced costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCCPBH', N'641', N'911', 1, 0, 0, 0, N'Kết chuyển chi phí bán hàng', 45, 0, 0, N'Transferred to cost of sales')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCGCPBH', N'641', N'911', 0, 0, 0, 0, N'Kết chuyển giảm chi phí bán hàng', 46, 0, 0, N'Transferred to reduced cost of sales')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCCPQL', N'642', N'911', 1, 0, 0, 0, N'Kết chuyển chi phí quản lý', 50, 0, 0, N'Transferred management costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCGCPQL', N'642', N'911', 0, 0, 0, 0, N'Kết chuyển giảm chi phí quản lý', 51, 0, 0, N'Transferred management reduced costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCTNK', N'711', N'911', 0, 0, 0, 0, N'Kết chuyển thu nhập khác', 55, 0, 0, N'Transferred income')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCGTNK', N'711', N'911', 1, 0, 0, 0, N'Kết chuyển giảm thu nhập khác', 56, 0, 0, N'Transferred reduced income')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCCPK', N'811', N'911', 1, 0, 0, 0, N'Kết chuyển chi phí khác', 60, 0, 0, N'Carry forward costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCGCPK', N'811', N'911', 0, 0, 0, 0, N'Kết chuyển  giảm chi phí khác', 61, 0, 0, N'Carry forward reduced costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCCPTNDN', N'8211', N'911', 1, 0, 0, 0, N'Kết chuyển chi phí thuế TNDN', 65, 0, 0, N'The transfer income tax expense')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCGCPTNDN', N'8211', N'911', 0, 0, 0, 0, N'Kết chuyển giảm chi phí thuế TNDN', 66, 0, 0, N'The transfer reduced income tax expense')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCCPTNDNHL', N'8212', N'911', 1, 0, 0, 0, N'Kết chuyển chi phí thuế TNDN hoãn lại', 70, 0, 0, N'The transfer deferred tax expense')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCGCPTNDNHL', N'8212', N'911', 0, 0, 0, 0, N'Kết chuyển giảm chi phí thuế TNDN hoãn lại', 71, 0, 0, N'The transfer reduced deferred tax expense')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCLAI', N'911', N'4212', 0, 0, 0, 0, N'Kết chuyển lãi', 75, 0, 0, N'Interest transferred')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2]) 
VALUES (N'KCLO', N'911', N'4212', 1, 0, 0, 0, N'Kết chuyển lỗ', 76, 0, 0, N'Carry forward losses')

-- Sửa đổi bảng cân đối kế toán
declare @sysReportID int

select @sysReportID = sysReportID from [CDT].[dbo].sysReport
where ReportName = N'Bảng cân đối kế toán'

delete from sysFormReport where sysReportID = @sysReportID

INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 1, N'A - TÀI SẢN NGẮN HẠN', N'100', NULL, N'@110+@120+@130+@140+@150', NULL, NULL, 0, N'A. CURRENT ASSETS ', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 2, N'I. Tiền và các khoản tương đương tiền', N'110', NULL, N'@111+@112', NULL, NULL, 0, N'I. Cash and cash equivalent', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 3, N' 1. Tiền', N'111', N'V.01', NULL, N'11', NULL, 5, N'1. Cash', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 4, N' 2. Các khoản tương đương tiền', N'112', NULL, N'0', NULL, NULL, 0, N'2. Cash equivalent', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 5, N'II. Các khoản đầu tư tài chính ngắn hạn', N'120', N'V.02', N'@121+@129', NULL, NULL, 0, N'II. Short-term investments', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 6, N' 1. Đầu tư ngắn hạn', N'121', NULL, N'@1211+@1212', NULL, NULL, 0, N'1. Short-term investments', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 9, N' 2. Dự phòng giảm giá đầu tư ngắn hạn(*)(2)', N'129', NULL, NULL, N'129', NULL, 5, N'2. Provision for impairment of short-term investments (*)(2)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 10, N'III. Các khoản phải thu ngắn hạn', N'130', NULL, N'@131+@132+@133+@134+@135+@139', NULL, NULL, 0, N'III. Short - term receivables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 11, N' 1. Phải thu khách hàng', N'131', NULL, NULL, N'131', NULL, 5, N'1. Trade receivables', 1, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 12, N' 2. Trả trước cho người bán', N'132', NULL, NULL, N'331', NULL, 5, N'2. Advance to suppliers', 1, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 14, N' 4. Phải thu theo tiến độ kế hoạch hợp đồng xây dựng', N'134', NULL, NULL, N'337', NULL, 5, N'4. Construction contract progress receivables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 13, N' 3. Phải thu nội bộ ngắn hạn', N'133', NULL, NULL, NULL, NULL, 0, N'3. Intercompany receivables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 15, N' 5. Các khoản phải thu khác', N'135', N'V.03', N'@1351+@1352+@1353+@1354', NULL, NULL, 0, N'5. Other receivables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 20, N' 6. Dự phòng phải thu ngắn hạn khó đòi (*)', N'139', NULL, NULL, N'139', NULL, 5, N'6. Provision for doubtful debts (*)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 21, N'IV. Hàng tồn kho', N'140', NULL, N'@141+@149', NULL, NULL, 0, N'IV. Inventories', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 22, N' 1. Hàng tồn kho', N'141', N'V.04', N'@1411+@1412+@1413+@1414+@1415+@1416+@1417+@1418', NULL, NULL, 0, N'1. Inventories', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 31, N' 2. Dự phòng giảm giá hàng tồn kho (*)', N'149', NULL, NULL, N'159', NULL, 5, N'2. Provision for decline in inventory (*)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 32, N'V. Tài sản  ngắn hạn khác', N'150', NULL, N'@151+@152+@154+@158', NULL, NULL, 0, N'V. Current assets', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 33, N' 1. Chi phí trả trước ngắn hạn', N'151', NULL, NULL, N'142', NULL, 5, N'1. Short-term prepaid expenses', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 34, N' 2. Thuế GTGT được khấu trừ', N'152', NULL, NULL, N'133', NULL, 5, N'2. VAT deducted', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 35, N' 3. Thuế và các khoản phải thu nhà nước', N'154', N'V.05', NULL, N'333', NULL, 5, N'3. Taxes and payable to state budget', 1, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 36, N' 5. Tài sản ngắn hạn khác', N'158', NULL, N'@1581+@1582+@1583', NULL, NULL, 0, N'5. Current assets', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 40, N'B - TÀI SẢN DÀI HẠN (200=210+220+240+250+260)', N'200', NULL, N'@210+@220+@240+@250+@260', NULL, NULL, 0, N'B. FIXED ASSETS & LONG-TERM INVESTMENTS (200 = 210 + 220 + 240 + 250 + 260)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 41, N'I. Các khoản phải thu dài hạn', N'210', NULL, N'@211+@212+@213+@218-@219', NULL, NULL, 0, N'I. Long - term receivables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 42, N' 1. Phải thu dài hạn của khách hàng', N'211', NULL, NULL, NULL, NULL, 0, N'1. Long - term receivable - trade', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 43, N' 2. Vốn kinh doanh ở đơn vị trực thuộc', N'212', NULL, NULL, N'1361', NULL, 5, N'2. Investment in equity of subsidiaries', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 44, N' 3. Phải thu dài hạn nội bộ', N'213', N'V.06', NULL, N'1368', NULL, 5, N'3. Long-term intercompany receivables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 45, N' 4. Phải thu dài hạn khác', N'218', N'V.07', N'@2181+@2182+@2183', NULL, NULL, 0, N'4. Other long-term receivables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 49, N' 5. Dự phòng phải thu dài hạn khó đòi (*)', N'219', NULL, NULL, NULL, NULL, 0, N'5. Provision for doubtful debts (*)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 50, N'II. Tài sản cố định', N'220', NULL, N'@221+@224+@227+@230', NULL, NULL, 0, N'II. Fixed assets', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 51, N' 1. Tài sản cố định hữu hình', N'221', N'V.08', N'@222+@223', NULL, NULL, 0, N'1. Tangible fixed assets', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 52, N'   - Nguyên giá', N'222', NULL, NULL, N'211', NULL, 5, N'- Original cost', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 53, N'   - Giá trị hao mòn lũy kế (*)', N'223', NULL, NULL, N'2141', NULL, 5, N'- Accumulated depreciation (*)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 54, N' 2. Tài sản cố định thuê tài chính', N'224', N'V.09', N'@225+@226', NULL, NULL, 0, N'2. Financial leasing fixed assets', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 55, N'   - Nguyên giá', N'225', NULL, NULL, N'212', NULL, 5, N'- Original cost', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 56, N'   - Giá trị hao mòn lũy kế (*)', N'226', NULL, NULL, N'2142', NULL, 5, N'- Accumulated depreciation (*)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 57, N' 3. Tài sản cố định vô hình', N'227', N'V.10', N'@228+@229', NULL, NULL, 0, N'3. Intangible fixed assets', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 58, N'   - Nguyên  giá', N'228', NULL, NULL, N'213', NULL, 5, N'- Original cost', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 59, N'   - Giá trị hao mòn lũy kế (*)', N'229', NULL, NULL, N'2143', NULL, 5, N'- Accumulated depreciation (*)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 60, N' 4. Chi phí xây dựng cơ bản dỡ dang', N'230', N'V.11', NULL, N'241', NULL, 5, N'4. Costs of unfinished capital constructions', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 61, N'III. Bất động sản đầu tư', N'240', N'V.12', N'@241+@242', NULL, NULL, 0, N'III. Investment real estate', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 62, N'  - Nguyên giá', N'241', NULL, NULL, N'217', NULL, 5, N'- Original cost', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 63, N'  - Giá trị hao mòn lũy kế (*)', N'242', NULL, NULL, N'2147', NULL, 5, N'- Accumulated depreciation (*)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 64, N'IV. Các khoản đầu tư tài chính dài hạn', N'250', NULL, N'@251+@252+@258+@259', NULL, NULL, 0, N'IV. Long- term financial Investments', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 65, N' 1. Đầu tư vào công ty con', N'251', NULL, NULL, N'221', NULL, 5, N'1. Investment in equity of subsidiaries', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 66, N' 2. Đầu tư vào công ty liên kết, liên doanh', N'252', NULL, N'@2521+@2522', NULL, NULL, 0, N'2. Investment in joint-venture', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 69, N' 3. Đầu tư dài hạn khác', N'258', N'V.13', NULL, N'228', NULL, 5, N'3. Other long term investments', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 70, N' 4. Dự phòng giảm giá đầu tư tài chính dài hạn (*)', N'259', NULL, NULL, N'229', NULL, 5, N'4. Provision for decline in long term investments (*)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 71, N'V. Tài sản dài hạn khác', N'260', NULL, N'@261+@262+@268', NULL, NULL, 0, N'V. Other long-term assets', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 72, N' 1. Chi phí trả trước dài hạn', N'261', N'V.14', NULL, N'242', NULL, 5, N'1. Long-term Prepaid expense ', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 73, N' 2. Tài sản thuế thu nhập hoãn lại', N'262', N'V.21', NULL, N'243', NULL, 5, N'2. Deffered income tax assets', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 74, N' 3. Tài sản dài hạn khác', N'268', NULL, NULL, N'244', NULL, 5, N'3. Other long-term assets', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 75, N'TỔNG CỘNG TÀI SẢN (270 = 100+200)', N'270', NULL, N'@100+@200', NULL, NULL, 0, N'TOTAL ASSETS (250 = 100 + 200)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 77, N'A- NỢ PHẢI TRẢ (300=310+330)', N'300', NULL, N'@310+@330', NULL, NULL, 0, N'A. PAYABLE DEBTS (300= 310 + 330)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 78, N'I. Nợ ngắn hạn', N'310', NULL, N'@311+@312+@313+@314+@315+@316+@317+@318+@319+@320+@323', NULL, NULL, 0, N'I. Short-term liability', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 79, N' 1. Vay và nợ ngắn hạn', N'311', N'V.15', N'@3111+@3112', NULL, NULL, 0, N'1. Short-term debts and loans', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 76, N'                               NGUỒN VỐN', NULL, NULL, N'0', NULL, NULL, 0, N'                               CAPITAL', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 0, N'                                   TÀI SẢN', NULL, NULL, N'0', NULL, NULL, 0, N'                                   ASSETS', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 82, N' 2. Phải trả người bán', N'312', NULL, NULL, N'331', NULL, 6, N'2. Payable to seller', 1, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 83, N' 3. Người mua trả tiền trước', N'313', NULL, N'@3131+@3132', NULL, NULL, 0, N'3. Advances from customers', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 86, N' 4. Thuế và các khoản phải nộp Nhà nước', N'314', N'V.16', NULL, N'333', NULL, 6, N'4. Taxes and payable to state budget', 1, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 87, N' 5. Phải trả người lao động', N'315', NULL, NULL, N'334', NULL, 6, N'5. Payable to employees', 1, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 88, N' 6. Chi phí phải trả', N'316', N'V.17', NULL, N'335', NULL, 6, N'6. Accruals', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 89, N' 7. Phải trả nội bộ', N'317', NULL, NULL, NULL, NULL, 0, N'7. Intercompany payable', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 90, N' 8. Phải trả theo tiến độ kế hoạch hợp đồng xây dựng', N'318', NULL, NULL, N'337', NULL, 6, N'8. Construction contract progress payment due to customers', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 91, N' 9. Các khoản phải trả, phải nộp ngắn hạn khác', N'319', N'V.18', N'@3191+@3192-@3387', NULL, NULL, 0, N'9. Other short-term payable items', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 102, N' 10. Dự phòng phải trả ngắn hạn', N'320', NULL, NULL, N'352', NULL, 6, N'10. Short-term provisions for payables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 104, N'II. Nợ dài hạn', N'330', NULL, N'@331+@332+@333+@334+@335+@336+@337+@338+@339', NULL, NULL, 0, N'II. Long-term liability', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 105, N' 1. Phải trả dài hạn người bán', N'331', NULL, NULL, NULL, NULL, 0, N'1. Trade payables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 106, N' 2. Phải trả dài hạn nội bộ', N'332', N'V.19', NULL, N'336', NULL, 6, N'2. Intercompany long-term payables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 107, N' 3. Phải trả dài hạn khác', N'333', NULL, N'@3331+@3332', NULL, NULL, 0, N'3. Other long-term payables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 109, N' 4. Vay và nợ dài hạn', N'334', N'V.20', N'@3341+@3342+@3343', NULL, NULL, 0, N'4. Long-term borrowing & liabilities', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 117, N' 5. Thuế thu nhập hoãn lại phải trả', N'335', N'V.21', NULL, N'347', NULL, 6, N'5. Deferred income tax liabilitie', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 118, N' 6. Dự phòng trợ cấp mất việc làm', N'336', NULL, NULL, N'351', NULL, 6, N'6. Provisions fund for severance allowances', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 119, N' 7. Dự phòng phải trả dài hạn', N'337', NULL, '0', NULL, NULL, 0, N'7. Provisions for payables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 122, N'B - NGUỒN VỐN CHỦ SỞ HỮU (400=410+430)', N'400', NULL, N'@410+@430', NULL, NULL, 0, N'B. CAPITAL (400 = 410 + 430)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 123, N'I. Vốn chủ sở hữu', N'410', N'V.22', N'@411+@412+@413+@414+@415+@416+@417+@418+@419+@420+@421+@422', NULL, NULL, 0, N'I. Capital', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 124, N' 1. Vốn đầu tư của chủ sở hữu', N'411', NULL, NULL, N'4111', NULL, 6, N'1. Contributed legal capital', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 125, N' 2. Thăng dư vốn cổ phần', N'412', NULL, NULL, N'4112', NULL, 6, N'2. Share premium', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 128, N' 3. Vốn khác của chủ sở hữu', N'413', NULL, NULL, N'4118', NULL, 6, N'3. Other capital', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 129, N' 4. Cổ phiếu quỹ (*)', N'414', NULL, NULL, N'419', NULL, 6, N'4. Treasury stock (*)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 130, N' 5. Chênh lệch đánh giá tài sản', N'415', NULL, NULL, N'412', NULL, 6, N'5. Differences upon asset revaluation', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 133, N' 6. Chênh lệch tỷ giá hối đoái', N'416', NULL, NULL, N'413', NULL, 6, N'6. Foreign exchange differences', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 136, N' 7. Quỹ đầu tư phát triển', N'417', NULL, NULL, N'414', NULL, 6, N'7. Investment & development funds', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 137, N' 8. Quỹ dự phòng tài chính', N'418', NULL, NULL, N'415', NULL, 6, N'8. Financial reserve funds', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 138, N' 9. Quỹ khác thuộc vốn chủ sỡ hữu', N'419', NULL, NULL, N'418', NULL, 6, N'9. Other funds', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 139, N' 10. Lợi nhuận sau thuế chưa phân phối', N'420', NULL, N'@4201+@4202', NULL, NULL, 0, N'10. Undistributed earnings', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 141, N' 11. Nguồn vốn đầu tư XDCB', N'421', NULL, NULL, N'441', NULL, 6, N'11. Construction investment fund', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 144, N'II. Nguồn kinh phí và quỹ khác', N'430', NULL, N'@431+@432', NULL, NULL, 0, N'II. Other sources and funds', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 145, N' 1. Nguồn kinh phí', N'431', N'V.23', N'@4311-@4312', NULL, NULL, 0, N'1. Sources of expenditure', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 148, N' 2. Nguồn kinh phí đã hình thành TSCĐ', N'432', NULL, NULL, N'466', NULL, 6, N'2. Budget resources used to acquire fixed assets', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 149, N'TỔNG CỘNG NGUỒN VỐN (440 = 300+400)', N'440', NULL, N'@300+@400', NULL, NULL, 0, N'TOTAL LIABILITIES AND OWNERS'' EQUITY (440 = 300 + 400)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 7, N'  1.1', N'1211', NULL, NULL, N'121', NULL, 5, N'  1.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 8, N'  1.2', N'1212', NULL, NULL, N'128', NULL, 5, N'  1.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 16, N'   5.1', N'1351', NULL, NULL, N'1385', NULL, 5, N'   5.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 17, N'   5.2 Phải thu khác', N'1352', NULL, NULL, N'1388', NULL, 5, N'   5.2 Other receivables', 0, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 18, N'   5.3', N'1353', NULL, NULL, N'334', NULL, 5, N'   5.3', 0, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 23, N'   1.1', N'1411', NULL, NULL, N'151', NULL, 5, N'   1.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 24, N'   1.2', N'1412', NULL, NULL, N'152', NULL, 5, N'   1.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 25, N'   1.3', N'1413', NULL, NULL, N'153', NULL, 5, N'   1.3', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 26, N'   1.4', N'1414', NULL, NULL, N'154', NULL, 5, N'   1.4', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 27, N'   1.5', N'1415', NULL, NULL, N'155', NULL, 5, N'   1.5', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 28, N'   1.6', N'1416', NULL, NULL, N'156', NULL, 5, N'   1.6', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 29, N'   1.7', N'1417', NULL, NULL, N'157', NULL, 5, N'   1.7', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 30, N'   1.8', N'1418', NULL, NULL, N'158', NULL, 5, N'   1.8', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 37, N'   5.1', N'1581', NULL, NULL, N'1381', NULL, 5, N'   5.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 38, N'   5.2', N'1582', NULL, NULL, N'141', NULL, 5, N'   5.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 39, N'   5.3', N'1583', NULL, NULL, N'144', NULL, 5, N'    5.3', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 47, N'   4.2', N'2182', NULL, NULL, NULL, NULL, 0, N'   4.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 48, N'   4.3', N'2183', NULL, NULL, NULL, NULL, 0, N'   4.3', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 67, N'   2.1', N'2521', NULL, NULL, N'222', NULL, 5, N'   2.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 68, N'   2.2', N'2522', NULL, NULL, N'223', NULL, 5, N'   2.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 80, N'  1.1', N'3111', NULL, NULL, N'311', NULL, 6, N'  1.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 81, N'   1.2', N'3112', NULL, NULL, N'315', NULL, 6, N'   1.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 84, N'3.1', N'3131', NULL, NULL, N'131', NULL, 6, N'3.1', 0, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 85, N'3.2 Thu trước các khoản phải thu', N'3132', NULL, NULL, N'1388', NULL, 6, N'3.2 Prepaid accounts receivable', 0, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 93, N'   9.2', N'3192', NULL, N'@13541+@13542+@13543+@13544+@13545+@13546+@13549+@13548', NULL, NULL, 0, N'   9.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 108, N'   3.1', N'3331', NULL, NULL, NULL, NULL, 0, N'   3.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 109, N'   3.2', N'3332', NULL, NULL, N'344', NULL, 6, N'   3.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 111, N'   4.1', N'3341', NULL, NULL, N'341', NULL, 6, N'   4.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 112, N'   4.2', N'3342', NULL, NULL, N'342', NULL, 6, N'   4.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 113, N'   4.3', N'3343', NULL, N'@33431-@33432+@33433', NULL, NULL, 0, N'   4.3', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 114, N'     4.31', N'33431', NULL, NULL, N'3431', NULL, 6, N'     4.31', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 115, N'     4.32', N'33432', NULL, NULL, N'3432', NULL, 5, N'     4.32', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 116, N'     4.33', N'33433', NULL, NULL, N'3433', NULL, 6, N'     4.33', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 146, N'   1.1', N'4311', NULL, NULL, N'461', NULL, 6, N'   2.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 147, N'   1.2', N'4312', NULL, NULL, N'161', NULL, 5, N'   2.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 102, N' 11. Qũy khen thưởng, phúc lợi', N'323', NULL, NULL, N'353', NULL, 6, N'10. Short-term provisions for payables', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 120, N' 8. Doanh thu chưa thực hiện', N'338', NULL, NULL, N'3387', NULL, 6, N'7. Provisions for payables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 121, N' 9. Quỹ phát triển khoa học và công nghệ', N'339', NULL, NULL, N'356', NULL, 6, N'7. Provisions for payables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 140, N'  10.1', N'4201', NULL, NULL, N'4211', NULL, 6, N'10. Undistributed earnings', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 141, N'  10.2', N'4202', NULL, NULL, N'4212', NULL, 6, N'10. Undistributed earnings', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 143, N' 12. Quỹ hỗ trợ sắp xếp doanh nghiệp', N'422', NULL, NULL, N'417', NULL, 6, N'11. Construction investment fund', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 150, N'                                   Chỉ tiêu', NULL, NULL, N'0', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 151, N' 1. Tài sản thuê ngoài', N'Tempxxx1', NULL, NULL, N'001', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 152, N' 2. Vật tư, hàng hàng hóa nhận giữ hộ, nhận gia công', N'Tempxxx2', NULL, NULL, N'002', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 153, N' 3. Hàng hóa nhận bán hộ, nhận ký gửi, ký cược', N'Tempxxx3', NULL, NULL, N'003', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 154, N' 4. Nợ khó đòi đã xử lý', N'Tempxxx4', NULL, NULL, N'004', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 155, N' 5. Ngoại tệ các loại', N'Tempxxx5', NULL, NULL, N'007', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 156, N' 6. Dự toán chi sự nghiệp, dự án', N'Tempxxx6', NULL, NULL, N'008', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 94, N'     9.21', N'13541', NULL, NULL, N'3381', NULL, 6, N'   9.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 95, N'     9.22', N'13542', NULL, NULL, N'3382', NULL, 6, N'   9.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 96, N'     9.23', N'13543', NULL, NULL, N'3383', NULL, 6, N'   9.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 97, N'     9.24', N'13544', NULL, NULL, N'3384', NULL, 6, N'   9.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 98, N'     9.25', N'13545', NULL, NULL, N'3385', NULL, 6, N'   9.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 99, N'     9.26', N'13546', NULL, NULL, N'3386', NULL, 6, N'   9.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 100, N'     9.27', N'13549', NULL, NULL, N'3389', NULL, 6, N'   9.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 101, N'     9.28', N'13548', NULL, NULL, N'3388', NULL, 6, N'   9.2', 0, 0)

-- Báo cáo lưu chuyển tiền tệ
select @sysReportID = sysReportID from [CDT].[dbo].sysReport
where ReportName = N'Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp'

Update [sysFormReport] set CachTinh=N'@01-@02-@03-@04-@05+@06-@07'
where sysReportID = @sysReportID and stt = 9 and ChiTieu = N'Lưu chuyển tiền thuần từ hoạt động kinh doanh'

Update [sysFormReport] set CachTinh=N'@22-@23+@24-@25+@26-@27-@21'
where sysReportID = @sysReportID and stt = 18 and ChiTieu = N'Lưu chuyển tiền thuần từ hoạt động đầu tư'

Update [sysFormReport] set CachTinh=N'@31-@32+@33-@34-@35-@36'
where sysReportID = @sysReportID and stt = 26 and ChiTieu = N'Lưu chuyển tiền thuần từ hoạt động tài chính'

Update [sysFormReport] set Tk=N'331,152,641,642,627,153,133,155,156'
where sysReportID = @sysReportID and stt = 3 and ChiTieu = N'  2. Tiền chi trả cho người cung cấp hàng hóa và dịch vụ'
and Tk = '331,152,641,642,627,153,133'

Update [sysFormReport] set Tk=N'511,512,1211,515,131'
where sysReportID = @sysReportID and stt = 2 and ChiTieu = N'  1. Tiền thu từ bán hàng, cung cấp dịch vụ và doanh thu khác'

Update [sysFormReport] set Tk=N'331,151,152,153,154,155,156,157,158,159,611,1211'
where sysReportID = @sysReportID and stt = 3 and ChiTieu = N'  2. Tiền chi trả cho người cung cấp hàng hóa và dịch vụ'

Update [sysFormReport] set Tk=N'334,347,351,352', ChiTieu = N'  3. Tiền chi trả cho người lao động'
where sysReportID = @sysReportID and stt = 4 and ChiTieu = N'  3. Tiền chi trả cho ngườ lao động'

Update [sysFormReport] set Tk=N'635, 335'
where sysReportID = @sysReportID and stt = 5 and ChiTieu = N'  4. Tiền chi trả lãi vay'

Update [sysFormReport] set Tk=N'711,521,531,532,414,415,417,418,347,351,352,353,334,242,151,152,153,154,155,156,157,158,159,331,336,133,144,244,344,141,461,136,138,338, 3331,3332,3333,3335,3336,3337,3338,3339, 641,621,622,623,627,641,642,631,632,821'
where sysReportID = @sysReportID and stt = 7 and ChiTieu = N'  6. Tiền thu khác từ hoạt động kinh doanh'

Update [sysFormReport] set Tk=N'811,521,531,532,417,418,336,3331,3332,3333,3335,3336,3337,3338,3339,144,244,344,353,414,415,441,161,336,141,621,622,623,627,641,642,142,242,136,133,138,338,131,631,632,821'
where sysReportID = @sysReportID and stt = 8 and ChiTieu = N'  7. Tiền chi khác cho hoạt động kinh doanh'

Update [sysFormReport] set Tk=N'211,212,213,217,214,241,142,356,412,466,711'
where sysReportID = @sysReportID and stt = 11 and ChiTieu = N'  1. Tiền chi để mua sắm, xây dựng TSCĐ và các tài sản dài hạn khác'

Update [sysFormReport] set Tk=N'211,212,213,217,214,241,356,412,441,466,611,811'
where sysReportID = @sysReportID and stt = 12 and ChiTieu = N'  2. Tiền thu từ thanh lý, nhượng bán TSCĐ và các tài sản dài hạn khác'

Update [sysFormReport] set Tk=N'1212,2282,2288'
where sysReportID = @sysReportID and stt = 13 and ChiTieu = N'  3. Tiền chi cho vay, mua các công cụ nợ của đơn vị khác'

Update [sysFormReport] set Tk=N'1212,2282,2288'
where sysReportID = @sysReportID and stt = 14 and ChiTieu = N'  4. Tiền thu hồi cho vay, bán lại các công cụ nợ của đơn vị khác'

Update [sysFormReport] set Tk=N'223,221,222,223,2281,128,337,461'
where sysReportID = @sysReportID and stt = 15 and ChiTieu = N'  5. Tiền chi đầu tư góp vào đơn vị khác'

Update [sysFormReport] set Tk=N'222,221,222,223,2281,128,337'
where sysReportID = @sysReportID and stt = 16 and ChiTieu = N'  6. Tiền thu hồi đầu tư góp vốn vào đơn vị khác'

Update [sysFormReport] set Tk=N'335,635'
where sysReportID = @sysReportID and stt = 17 and ChiTieu = N'  7. Tiền thu lãi cho vay, cổ tức và lợi nhuận được chia'

Update [sysFormReport] set Tk=N'411,419'
where sysReportID = @sysReportID and stt = 20 and ChiTieu = N'  1. Tiền thu từ phát hành cổ phiếu, nhận vốn góp của chủ sỡ hữu'

Update [sysFormReport] set Tk=N'411,419'
where sysReportID = @sysReportID and stt = 21 and ChiTieu = N'  2. Tiền chi trả vốn góp cho các chủ sỡ hữu, mua lai CP của DN đã phát hành'

Update [sysFormReport] set Tk=N'311,341,342,343,315'
where sysReportID = @sysReportID and stt = 22 and ChiTieu = N'  3. Tiền vay ngắn hạn, dài hạn nhận được'

Update [sysFormReport] set Tk=N'311,315,341,342,343'
where sysReportID = @sysReportID and stt = 23 and ChiTieu = N'  4. Tiền chi trả nợ gốc vay'

Update [sysFormReport] set Tk=NULL,Tkdu = NULL, LoaiCT = 0
where sysReportID = @sysReportID and stt = 24 and ChiTieu = N'  5. Tiền chi trả nợ thuê tài chính'

Update [sysFormReport] set Tk=N'11' , MaSo = '60', LoaiCT = 1
where sysReportID = @sysReportID and stt = 28 and ChiTieu = N'Tiền và tương đương tiền đầu kỳ'

Update [sysFormReport] set CachTinh = N'@611-@612'
where sysReportID = @sysReportID and stt = 29 and ChiTieu = N'Ảnh hưởng của thay đổi tỷ giá hối đoái quy đỗi ngọai tệ'

if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and stt = 30 and ChiTieu = N'  Ảnh hưởng dương (Tỷ giá hối đoái cuối kỳ > tỷ giá hối đoái trong kỳ')
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) 
VALUES (@sysReportID, 30, N'  Ảnh hưởng dương (Tỷ giá hối đoái cuối kỳ > tỷ giá hối đoái trong kỳ', '611', NULL, NULL, N'413', N'11', 4, NULL, 1, 0)

if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and stt = 31 and ChiTieu = N'  Ảnh hưởng âm')
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) 
VALUES (@sysReportID, 31, N'  Ảnh hưởng âm', '612', NULL, NULL, N'413', N'11', 3, NULL, 1, 0)

Update [sysFormReport] set stt = 32
where sysReportID = @sysReportID and stt = 30 and ChiTieu = N'Tiền và tương tiền cuối kỳ (70=50+60+61)'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 3 and ChiTieu = N'  2. Tiền chi trả cho người cung cấp hàng hóa và dịch vụ' and MaSo = N'02'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 4 and ChiTieu = N'  3. Tiền chi trả cho người lao động' and MaSo = N'03'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 5 and ChiTieu = N'  4. Tiền chi trả lãi vay' and MaSo = N'04'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 6 and ChiTieu = N'  5. Tiền chi nộp thuế thu nhập doanh nghiệp' and MaSo = N'05'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 8 and ChiTieu = N'  7. Tiền chi khác cho hoạt động kinh doanh' and MaSo = N'07'

Update [sysFormReport] set CachTinh = N'@01+@02+@03+@04+@05+@06+@07'
where sysReportID = @sysReportID and stt = 9 and ChiTieu = N'Lưu chuyển tiền thuần từ hoạt động kinh doanh' and MaSo = N'20' and CachTinh = N'@01-@02-@03-@04-@05+@06-@07'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 11 and ChiTieu = N'  1. Tiền chi để mua sắm, xây dựng TSCĐ và các tài sản dài hạn khác' and MaSo = N'21'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 13 and ChiTieu = N'  3. Tiền chi cho vay, mua các công cụ nợ của đơn vị khác' and MaSo = N'23'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 15 and ChiTieu = N'  5. Tiền chi đầu tư góp vào đơn vị khác' and MaSo = N'25'

Update [sysFormReport] set CachTinh = N'@22+@23+@24+@25+@26+@27+@21'
where sysReportID = @sysReportID and stt = 18 and ChiTieu = N'Lưu chuyển tiền thuần từ hoạt động đầu tư' and MaSo = N'30' and CachTinh = N'@22-@23+@24-@25+@26-@27-@21'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 21 and ChiTieu = N'  2. Tiền chi trả vốn góp cho các chủ sỡ hữu, mua lai CP của DN đã phát hành' and MaSo = N'32'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 23 and ChiTieu = N'  4. Tiền chi trả nợ gốc vay' and MaSo = N'34'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 24 and ChiTieu = N'  5. Tiền chi trả nợ thuê tài chính' and MaSo = N'35'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 25 and ChiTieu = N'  6. Cổ tức, lợi nhuận đã trả cho chủ sỡ hữu' and MaSo = N'36'

Update [sysFormReport] set CachTinh = N'@31+@32+@33+@34+@35+@36'
where sysReportID = @sysReportID and stt = 26 and ChiTieu = N'Lưu chuyển tiền thuần từ hoạt động tài chính' and MaSo = N'40' and CachTinh = N'@31-@32+@33-@34-@35-@36'

Update [sysFormReport] set CachTinh = N'@611+@612'
where sysReportID = @sysReportID and stt = 29 and ChiTieu = N'Ảnh hưởng của thay đổi tỷ giá hối đoái quy đỗi ngọai tệ' and MaSo = N'61' and CachTinh = N'@611-@612'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 31 and ChiTieu = N'  Ảnh hưởng âm' and MaSo = N'612'

-- Báo cáo kết quả kinh doanh
select @sysReportID = sysReportID from [CDT].[dbo].sysReport
where ReportName = N'Báo cáo kết quả kinh doanh'

delete from sysFormReport where sysReportID = @sysReportID

INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 1, N'1. Doanh thu bán hàng, cung cấp dịch vụ', N'01', N'VI.25', N'@01.1-@01.2-@01.3+@01.4+@02', NULL, NULL, 0, N'1. Sales', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 2, N'1.1 Tổng  Doanh thu (Phát sinh có)', N'01.1', NULL, NULL, N'511,512', NULL, 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 3, N'1.2  Kết chuyển giảm  doanh thu', N'01.2', NULL, NULL, N'511,512', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 4, N'1.3 Tổng  Doanh thu (Phát sinh Nợ)', N'01.3', NULL, NULL, N'511,512', NULL, 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 5, N'1.4 Kết chuyển tăng  doanh thu', N'01.4', NULL, NULL, N'511,512', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 7, N'2. Các khoản giảm trừ doanh thu', N'02', NULL, NULL, N'511,512', N'521,531,532,3331, 3332, 3333', 3, N'2. Deductions', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 10, N'3. Doanh thu thuần về bán hàng và cung cấp dịch vụ(10=01-02)', N'10', NULL, N'@01-@02', NULL, NULL, 0, N'3. Net sales (10 = 01 - 02)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 15, N'4. Giá vốn hàng bán', N'11', N'VI.27', N'@11.1-@11.2', NULL, NULL, 0, N'4. Cost of goods sold', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 16, N'4.1 Tăng giá vốn hàng bán', N'11.1', NULL, NULL, N'632', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 17, N'4.2 Giảm giá vốn hàng bán', N'11.2', NULL, NULL, N'632', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 20, N'5. Lợi  nhuân gộp về bán hàng và cung cấp dịch vụ (20=10-11)', N'20', NULL, N'@10-@11', NULL, NULL, 0, N'5. Gross profit/ (loss) (20 = 10 - 11)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 25, N'6. Doanh thu hoạt động tài chính', N'21', N'VI.26', N'@21.1-@21.2', NULL, NULL, 0, N'6. Financial activities income', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 26, N'6.1 Tăng doanh thu hoạt động tài chính', N'21.1', NULL, NULL, N'515', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 27, N'6.1 Giảm doanh thu hoạt động tài chính', N'21.2', NULL, NULL, N'515', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 30, N'7. Chi phí tài chính', N'22', N'VI.28', N'@22.1-@22.2', NULL, NULL, 0, N'7. Financial activities expenses', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 31, N'7.1 Tăng chi phí tài chính', N'22.1', NULL, NULL, N'635', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 32, N'7.2 Giảm chi phí tài chính', N'22.2', NULL, NULL, N'635', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 35, N'Trong đó Chi phí lãi vay', N'23', NULL, N'@23.1-@23.2', NULL, NULL, 0, N'- In which: Loan interest expenses', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 36, N'- Trong đó Tăng chi phí lãi vay', N'23.1', NULL, NULL, N'635', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 37, N'- Trong đó Giảm chi phí lãi vay', N'23.2', NULL, NULL, N'635', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 40, N'8. Chi phí bán hàng', N'24', NULL, N'@24.1-@24.2', NULL, NULL, 0, N'8. Selling expenses', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 41, N'8.1 Tăng chi phí bán hàng', N'24.1', NULL, NULL, N'641', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 42, N'8.1 Giảm chi phí bán hàng', N'24.2', NULL, NULL, N'641', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 45, N'9. Chi phí quản lý doanh  nghiệp', N'25', NULL, N'@25.1-@25.2', NULL, NULL, 0, N'9. General & administration expenses', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 46, N'9.1 Tăng chi phí quản lý doanh  nghiệp', N'25.1', NULL, NULL, N'642', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 47, N'9.1 Giảm chi phí quản lý doanh  nghiệp', N'25.2', NULL, NULL, N'642', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 50, N'10. Lợi  nhuận thuần từ hoạt động kinh doanh(30=20+(21-22)-(24+25))', N'30', NULL, N'@20+@21-@22-@24-@25', NULL, NULL, 0, N'10. Net operating profit/(loss) (30 = 20 + (21 - 22) - (24 + 25))', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 55, N'11. Thu nhập khác', N'31', NULL, N'@31.1-@31.2', NULL, NULL, 0, N'11. Other income', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 56, N'11.1 Tăng thu nhập khác', N'31.1', NULL, NULL, N'711', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 57, N'11.1 Giảm thu nhập khác', N'31.2', NULL, NULL, N'711', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 60, N'12. Chi phí khác', N'32', NULL, N'@32.1-@32.2', NULL, NULL, 0, N'12. Other expenses', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 61, N'12.1  Tăng chi phí khác', N'32.1', NULL, NULL, N'811', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 62, N'12.1  Giảm chi phí khác', N'32.2', NULL, NULL, N'811', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 65, N'13. Lợi nhuận khác (40=31-32)', N'40', NULL, N'@31-@32', NULL, NULL, 0, N'13. Other profit/(loss) (40 = 31 - 32)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 70, N'14. Tổng lợi nhuận trước thuế (50=30+40)', N'50', NULL, N'@30+@40', NULL, NULL, 0, N'14. Profit/(loss) before tax (50 = 30 + 40)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 75, N'15. Chi phí thuế TNDN hiện hành', N'51', N'VI.30', N'@51.1-@51.2', NULL, NULL, 0, N'15. Current business income tax charge', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 76, N'15.1 Tăng chi phí thuế TNDN hiện hành', N'51.1', NULL, NULL, N'8211', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 77, N'15.2 Giảm chi phí thuế TNDN hiện hành', N'51.2', NULL, NULL, N'8211', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 80, N'16. Chi phí thuế TNDN hoãn lại', N'52', N'VI.30', N'@52.1-@52.2', NULL, NULL, 0, N'16. Deffered business income tax charge', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 81, N'16.1 Tăng chi phí thuế TNDN hoãn lại', N'52.1', NULL, NULL, N'8212', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 82, N'16.2 Giảm chi phí thuế TNDN hoãn lại', N'52.2', NULL, NULL, N'8212', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 85, N'17. Lợi nhuận sau thuế thu nhập doanh nghiệp (60=50-51-52)', N'60', NULL, N'@50-@51-@52', NULL, NULL, 0, N'17. Profit/(loss) after tax (60 = 50 - 51 - 52)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 90, N'18. Lãi cơ bản trên cổ phiếu (*)', N'70', NULL, N'0', NULL, NULL, 0, N'18. Earning per share (*)', 1, 0)

-- Update Chứng từ ghi sổ
Update CTGS set MACT = 'KCCPNL', NDKT = N'Kết chuyển phân bổ chi phí nguyên liệu'
where SoHieu = 'KCCPBTP' and MACT = 'KCCPBTP'

delete from CTGS where SoHieu = 'KCCPNVL' and MaCT = 'KCCPNVL'
delete from CTGS where SoHieu = 'KCDTCT' and MaCT = 'KCDTCT'

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPNCTT' and [MaCT] = N'KCCPNCTT')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPNCTT', N'Kết chuyển phân bổ chi phí nhân công', N'KCCPNCTT')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPMTC' and [MaCT] = N'KCCPMTC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPMTC', N'Kết chuyển phân bổ chi phí máy thi công', N'KCCPMTC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPSXC' and [MaCT] = N'KCCPSXC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPSXC', N'Kết chuyển phân bổ chi phí sản xuất chung', N'KCCPSXC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCTGHD' and [MaCT] = N'KCTGHD')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCTGHD', N'Kết chuyển lãi chênh lệch tỷ giá hối đoái', N'KCTGHD')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCHDLO' and [MaCT] = N'KCHDLO')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCHDLO', N'Kết chuyển lỗ chênh lệch tỷ giá hối đoái', N'KCHDLO')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCKTM' and [MaCT] = N'KCCKTM')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCKTM', N'Kết chuyển chiết khấu thương mại', N'KCCKTM')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGGHB' and [MaCT] = N'KCGGHB')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGGHB', N'Kết chuyển giảm giá hàng bán', N'KCGGHB')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCHBTL' and [MaCT] = N'KCHBTL')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCHBTL', N'Kết chuyển hàng bán trả lại', N'KCHBTL')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCDTBH' and [MaCT] = N'KCDTBH')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCDTBH', N'Kết chuyển doanh thu bán hàng', N'KCDTBH')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCDTNB' and [MaCT] = N'KCDTNB')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCDTNB', N'Kết chuyển doanh thu bán hàng nội bộ', N'KCDTNB')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCDTTC' and [MaCT] = N'KCDTTC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCDTTC', N'Kết chuyển doanh thu tài chính', N'KCDTTC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGV' and [MaCT] = N'KCGV')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGV', N'Kết chuyển giá vốn', N'KCGV')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPTC' and [MaCT] = N'KCCPTC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPTC', N'Kết chuyển chi phí tài chính', N'KCCPTC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPBH' and [MaCT] = N'KCCPBH')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPBH', N'Kết chuyển chi phí bán hàng', N'KCCPBH')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPQL' and [MaCT] = N'KCCPQL')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPQL', N'Kết chuyển chi phí quản lý', N'KCCPQL')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCTNK' and [MaCT] = N'KCTNK')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCTNK', N'Kết chuyển thu nhập khác', N'KCTNK')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPK' and [MaCT] = N'KCCPK')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPK', N'Kết chuyển chi phí khác', N'KCCPK')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPTNDN' and [MaCT] = N'KCCPTNDN')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPTNDN', N'Kết chuyển chi phí thuế TNDN', N'KCCPTNDN')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPTNDNHL' and [MaCT] = N'KCCPTNDNHL')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPTNDNHL', N'Kết chuyển chi phí thuế TNDN hoãn lại', N'KCCPTNDNHL')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCLAI' and [MaCT] = N'KCLAI')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCLAI', N'Kết chuyển lãi', N'KCLAI')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCLO' and [MaCT] = N'KCLO')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCLO', N'Kết chuyển lỗ', N'KCLO')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGDTBH' and [MaCT] = N'KCGDTBH')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGDTBH', N'Kết chuyển giảm doanh thu bán hàng', N'KCGDTBH')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGDTNB' and [MaCT] = N'KCGDTNB')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGDTNB', N'Kết chuyển giảm doanh thu bán hàng nội bộ', N'KCGDTNB')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGDTTC' and [MaCT] = N'KCGDTTC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGDTTC', N'Kết chuyển giảm doanh thu tài chính', N'KCGDTTC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGGV' and [MaCT] = N'KCGGV')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGGV', N'Kết chuyển giảm giá vốn', N'KCGGV')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGCPTC' and [MaCT] = N'KCGCPTC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGCPTC', N'Kết chuyển giảm chi phí tài chính', N'KCGCPTC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGCPBH' and [MaCT] = N'KCGCPBH')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGCPBH', N'Kết chuyển giảm chi phí bán hàng', N'KCGCPBH')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGCPQL' and [MaCT] = N'KCGCPQL')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGCPQL', N'Kết chuyển giảm chi phí quản lý', N'KCGCPQL')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGTNK' and [MaCT] = N'KCGTNK')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGTNK', N'Kết chuyển giảm thu nhập khác', N'KCGTNK')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGCPK' and [MaCT] = N'KCGCPK')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGCPK', N'Kết chuyển giảm chi phí khác', N'KCGCPK')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGCPTNDN' and [MaCT] = N'KCGCPTNDN')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGCPTNDN', N'Kết chuyển giảm chi phí thuế TNDN', N'KCGCPTNDN')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGCPTNDNHL' and [MaCT] = N'KCGCPTNDNHL')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGCPTNDNHL', N'Kết chuyển giảm chi phí thuế TNDN hoãn lại', N'KCGCPTNDNHL')