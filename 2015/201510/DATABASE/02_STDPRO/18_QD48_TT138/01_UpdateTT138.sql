-- QD48

---- Thêm DMTK
if not exists (select top 1 1 from DMTK where TK = '171')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK]) 
VALUES (N'171', NULL, N'Giao dịch mua bán lại trái phiếu chính phủ', N'Traded government bonds', 0, 1, 1)

if not exists (select top 1 1 from DMTK where TK = '3389')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'3389', '338', N'Bảo hiểm thất nghiệp', N'Unemployment Insurance', 0, 1, 2)

if not exists (select top 1 1 from DMTK where TK = '356')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'356', NULL, N'Quỹ phát triển khoa học và công nghệ', N'Fund for development of science and technology', 0, 1, 1)

if not exists (select top 1 1 from DMTK where TK = '3561')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'3561', '356', N'Quỹ phát triển khoa học và công nghệ', N'Fund for development of science and technology', 0, 1, 2)

if not exists (select top 1 1 from DMTK where TK = '3562')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'3562', '356', N'Quỹ PT KH và CN đã hình thành TSCD', N'Fund the development of science and technology that form the fixed assets', 0, 1, 2)

if not exists (select top 1 1 from DMTK where TK = '353')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'353', NULL, N'Quỹ khen thưởng, phúc lợi', N'The reward fund and welfare', 0, 1, 1)

if not exists (select top 1 1 from DMTK where TK = '3531')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'3531', '353', N'Quỹ khen thưởng', N'The reward fund', 0, 1, 2)

if not exists (select top 1 1 from DMTK where TK = '3532')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'3532', '353', N'Quỹ phúc lợi', N'The welfare fund', 0, 1, 2)

if not exists (select top 1 1 from DMTK where TK = '3533')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'3533', '353', N'Quỹ phúc lợi đã hình thành TSCD', N'The welfare fund has been formed of fixed assets', 0, 1, 2)

if not exists (select top 1 1 from DMTK where TK = '3534')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'3534', '353', N'Quỹ thưởng ban điều hành Cty', N'Reward Fund Executive Board Company', 0, 1, 2)

if not exists (select top 1 1 from DMTK where TK = '2213')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'2213', '221', N'Đầu tư vào công ty liên kết', N'Investments in associated companies', 0, 1, 2)

if not exists (select top 1 1 from DMTK where TK = '1541')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'1541', '154', N'Chi phí sản xuất, kinh doanh dở dang', N'Production costs, work in progress', 0, 1, 2)

if not exists (select top 1 1 from DMTK where TK = '15411')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'15411', '1541', N'Chi phí nguyên vật liệu', N'Cost of materials', 0, 1, 3)

if not exists (select top 1 1 from DMTK where TK = '15412')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'15412', '1541', N'Chi phí nhân công trực tiếp', N'Direct labor costs', 0, 1, 3)

if not exists (select top 1 1 from DMTK where TK = '15413')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'15413', '1541', N'Chi phí sử dụng máy thi công', N'The cost of using construction', 0, 1, 3)

if not exists (select top 1 1 from DMTK where TK = '15417')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'15417', '1541', N'Chi phí sản xuất chung', N'Overall production costs', 0, 1, 3)

if not exists (select top 1 1 from DMTK where TK = '15418')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'15418', '1541', N'Chi phí sản xuất, kinh doanh dở dang', N'Production costs, work in progress', 0, 1, 3)

if not exists (select top 1 1 from DMTK where TK = '1542')
INSERT [dbo].[DMTK] ([TK], [TKMe], [TenTK], [TenTK2], [TKCongNo], [TKSoCai], [GradeTK])
VALUES (N'1542', '154', N'Chi phí lắp ráp, tháo dở', N'Cost of assembly and dismantling', 0, 1, 2)

Update DMTK set TenTK = TenTK + N'(Ngưng sử dụng kể từ thông tư 138)', TenTK2 = TenTK2 +  N'(Stop using from circular 138)'
where TK = '431' and TenTK = N'Quỹ khen thưởng, phúc lợi'

Update DMTK set TenTK = TenTK + N'(Ngưng sử dụng kể từ thông tư 138)', TenTK2 = TenTK2 +  N'(Stop using from circular 138)'
where TK = '4311' and TenTK = N'Quỹ khen thưởng'

Update DMTK set TenTK = TenTK + N'(Ngưng sử dụng kể từ thông tư 138)', TenTK2 = TenTK2 +  N'(Stop using from circular 138)'
where TK = '4312' and TenTK = N'Quỹ phúc lợi'

-- Sửa đổi danh mục kết chuyển
delete from DMKetChuyen

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCCPNVL', N'15411', N'15418', 1, 0, 0, 0, N'Kết chuyển chi phí nguyên vật liệu', 1, 0, 0, N'To transfer the cost of raw materials')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCCPNCTT', N'15412', N'15418', 1, 0, 0, 0, N'Kết chuyển chi phí nhân công trực tiếp', 2, 0, 0, N'Transferred direct labor costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCCPMTC', N'15413', N'15418', 1, 0, 0, 0, N'Kết chuyển chi phí máy chờ thi công', 3, 0, 0, N'The transfer costs of construction machines')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCCPSXC', N'15417', N'15418', 1, 0, 0, 0, N'Kết chuyển chi phí sản xuất chung', 4, 0, 0, N'Forward the overall production costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCCLTGLAI', N'413', N'515', 0, 0, 0, 0, N'Kết chuyển lãi chênh lệch tỷ giá hối đoái', 10, 0, 0, N'Forward interest rate exchange differences')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCCLTGLO', N'413', N'635', 1, 0, 0, 0, N'Kết chuyển lỗ chênh lệch tỷ giá hối đoái', 15, 0, 0, N'The switching losses of exchange rate differences')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCCKTM', N'5211', N'5111', 1, 0, 0, 0, N'Kết chuyển chiết khấu thương mại', 20, 0, 0, N'Carry forward the trade discounts')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCHBTL', N'5212', N'5111', 1, 0, 0, 0, N'Kết chuyển hàng bán trả lại', 25, 0, 0, N'Transferred back to sales ')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCGGHB', N'5213', N'5111', 1, 0, 0, 0, N'Kết chuyển giảm giá hàng bán', 30, 0, 0, N'Forward reduced sales rebate')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCDTBH', N'511', N'911', 0, 0, 0, 0, N'Kết chuyển doanh thu bán hàng', 35, 0, 0, N'Carry forward sales')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCGDTBH', N'511', N'911', 1, 0, 0, 0, N'Kết chuyển giảm doanh thu bán hàng', 36, 0, 0, N'The move reduced sales')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCDTTC', N'515', N'911', 0, 0, 0, 0, N'Kết chuyển doanh thu tài chính', 40, 0, 0, N'Transferred financial revenues')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCGDTTC', N'515', N'911', 1, 0, 0, 0, N'Kết chuyển giảm doanh thu tài chính', 41, 0, 0, N'Transferred of reduced financial revenues')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCGVHB', N'632', N'911', 1, 0, 0, 0, N'Kết chuyển giá vốn', 45, 0, 0, N'Add transfer cost')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCGGVHB', N'632', N'911', 0, 0, 0, 0, N'Kết chuyển giảm giá vốn', 46, 0, 0, N'Add transfer reduced cost')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCCPTC', N'635', N'911', 1, 0, 0, 0, N'Kết chuyển chi phí tài chính', 50, 0, 0, N'Transferred financial costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCGCPTC', N'635', N'911', 0, 0, 0, 0, N'Kết chuyển giảm chi phí tài chính', 51, 0, 0, N'Transferred financial reduced costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCCPBH', N'6421', N'911', 1, 0, 0, 0, N'Kết chuyển chi phí bán hàng', 55, 0, 0, N'Transferred to cost of sales')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCGCPBH', N'6421', N'911', 0, 0, 0, 0, N'Kết chuyển giảm chi phí bán hàng', 56, 0, 0, N'Transferred to reduced cost of sales')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCCPQL', N'6422', N'911', 1, 0, 0, 0, N'Kết chuyển chi phí quản lý', 60, 0, 0, N'Transferred management costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCGCPQL', N'6422', N'911', 0, 0, 0, 0, N'Kết chuyển giảm chi phí quản lý', 61, 0, 0, N'Transferred reduced management costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCTNKHAC', N'711', N'911', 0, 0, 0, 0, N'Kết chuyển thu nhập khác', 65, 0, 0, N'Transferred income')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCGTNKHAC', N'711', N'911', 1, 0, 0, 0, N'Kết chuyển giảm thu nhập khác', 66, 0, 0, N'Transferred reduced income')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCCPKHAC', N'811', N'911', 1, 0, 0, 0, N'Kết chuyển chi phí khác', 70, 0, 0, N'Carry forward costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCGCPKHAC', N'811', N'911', 0, 0, 0, 0, N'Kết chuyển giảm chi phí khác', 71, 0, 0, N'Carry forward reduced costs')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCTTTDN', N'821', N'911', 1, 0, 0, 0, N'Kết chuyển thuế thu nhập doanh nghiệp', 75, 0, 0, N'The transfer income tax expense')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCGTTTDN', N'821', N'911', 0, 0, 0, 0, N'Kết chuyển giảm thuế thu nhập doanh nghiệp', 76, 0, 0, N'The transfer reduced income tax expense')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCLAI', N'911', N'4212', 0, 0, 0, 0, N'Kết chuyển lãi', 80, 0, 0, N'Interest transferred')

INSERT [dbo].[DMKetChuyen] ([MaCT], [TkNguon], [TkDich], [LoaiKC], [MaBP], [MaVV], [Maphi], [DienGiai], [TTKC], [MaSP], [MaCongTrinh], [DienGiai2])
VALUES (N'KCLO', N'911', N'4212', 1, 0, 0, 0, N'Kết chuyển lỗ', 85, 0, 0, N'Carry forward losses')

-- Update Chứng từ ghi sổ
delete from CTGS where SoHieu = 'KCCPBTP' and MaCT = 'KCCPBTP'
delete from CTGS where SoHieu = 'KCDTCT' and MaCT = 'KCDTCT'

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPNCTT' and [MaCT] = N'KCCPNCTT')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPNCTT', N'Kết chuyển chi phí nhân công trực tiếp', N'KCCPNCTT')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPMTC' and [MaCT] = N'KCCPMTC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPMTC', N'Kết chuyển chi phí máy chờ thi công', N'KCCPMTC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPSXC' and [MaCT] = N'KCCPSXC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPSXC', N'Kết chuyển chi phí sản xuất chung', N'KCCPSXC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCLTGLAI' and [MaCT] = N'KCCLTGLAI')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCLTGLAI', N'Kết chuyển lãi chênh lệch tỷ giá hối đoái', N'KCCLTGLAI')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCLTGLO' and [MaCT] = N'KCCLTGLO')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCLTGLO', N'Kết chuyển lỗ chênh lệch tỷ giá hối đoái', N'KCCLTGLO')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCKTM' and [MaCT] = N'KCCKTM')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCKTM', N'Kết chuyển chiết khấu thương mại', N'KCCKTM')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCHBTL' and [MaCT] = N'KCHBTL')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCHBTL', N'Kết chuyển hàng bán trả lại', N'KCHBTL')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGGHB' and [MaCT] = N'KCGGHB')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGGHB', N'Kết chuyển giảm giá hàng bán', N'KCGGHB')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCDTBH' and [MaCT] = N'KCDTBH')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCDTBH', N'Kết chuyển doanh thu bán hàng', N'KCDTBH')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCDTTC' and [MaCT] = N'KCDTTC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCDTTC', N'Kết chuyển doanh thu tài chính', N'KCDTTC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGVHB' and [MaCT] = N'KCGVHB')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGVHB', N'Kết chuyển giá vốn', N'KCGVHB')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPTC' and [MaCT] = N'KCCPTC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPTC', N'Kết chuyển chi phí tài chính', N'KCCPTC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPBH' and [MaCT] = N'KCCPBH')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPBH', N'Kết chuyển chi phí bán hàng', N'KCCPBH')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPQL' and [MaCT] = N'KCCPQL')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPQL', N'Kết chuyển chi phí quản lý', N'KCCPQL')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCTNKHAC' and [MaCT] = N'KCTNKHAC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCTNKHAC', N'Kết chuyển thu nhập khác', N'KCTNKHAC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCCPKHAC' and [MaCT] = N'KCCPKHAC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCCPKHAC', N'Kết chuyển chi phí khác', N'KCCPKHAC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCTTTDN' and [MaCT] = N'KCTTTDN')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCTTTDN', N'Kết chuyển thuế thu nhập doanh nghiệp', N'KCTTTDN')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCLAI' and [MaCT] = N'KCLAI')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCLAI', N'Kết chuyển lãi', N'KCLAI')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCLO' and [MaCT] = N'KCLO')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCLO', N'Kết chuyển lỗ', N'KCLO')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGDTBH' and [MaCT] = N'KCGDTBH')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGDTBH', N'Kết chuyển giảm doanh thu bán hàng', N'KCGDTBH')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGDTTC' and [MaCT] = N'KCGDTTC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGDTTC', N'Kết chuyển giảm doanh thu tài chính', N'KCGDTTC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGGVHB' and [MaCT] = N'KCGGVHB')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGGVHB', N'Kết chuyển giảm giá vốn', N'KCGGVHB')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGCPTC' and [MaCT] = N'KCGCPTC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGCPTC', N'kết chuyển giảm chi phí tài chính', N'KCGCPTC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGCPBH' and [MaCT] = N'KCGCPBH')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGCPBH', N'Kết chuyển giảm chi phí bán hàng', N'KCGCPBH')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGCPQL' and [MaCT] = N'KCGCPQL')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGCPQL', N'Kết chuyển giảm chi phí quản lý', N'KCGCPQL')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGTNKHAC' and [MaCT] = N'KCGTNKHAC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGTNKHAC', N'Kết chuyển giảm thu nhập khác', N'KCGTNKHAC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGCPKHAC' and [MaCT] = N'KCGCPKHAC')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGCPKHAC', N'Kết chuyển giảm chi phí khác', N'KCGCPKHAC')

if not exists (select top 1 1 from [CTGS] where [SoHieu] = N'KCGTTTDN' and [MaCT] = N'KCGTTTDN')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (N'KCGTTTDN', N'Kết chuyển giảm thuế thu nhập doanh nghiệp', N'KCGTTTDN')

-- Sửa đổi bảng cân đối kế toán
declare @sysReportID int

select @sysReportID = sysReportID from [CDT].[dbo].sysReport
where ReportName = N'Bảng cân đối kế toán'

delete from sysFormReport where sysReportID = @sysReportID

INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 1, N'A - TÀI SẢN NGẮN HẠN (100=110+120+130+140+150)', N'100', NULL, N'@110+@120+@130+@140+@150', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 2, N'I. Tiền và các khoản tương đương tiền', N'110', N'(III.01)', NULL, N'11', NULL, 5, N'I. Cash and cash equivalent', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 5, N'II. Đầu tư tài chính ngắn hạn', N'120', N'(III.05)', N'@121+@129', NULL, NULL, 0, N'II. Short-term investments', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 6, N' 1. Đầu tư tài chính ngắn hạn', N'121', NULL, N'@1211+@1212', NULL, NULL, 0, N'1. Short-term investments', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 9, N' 2. Dự phòng giảm giá đầu tư tài chính ngắn hạn(*)', N'129', NULL, NULL, N'1591', NULL, 5, N'2. Provision for impairment of short-term investments (*)(2)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 10, N'III. Các khoản phải thu ngắn hạn', N'130', NULL, N'@131+@132+@138+@139', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 11, N' 1. Phải thu của khách hàng', N'131', NULL, NULL, N'131', NULL, 5, N'1. Trade receivables', 1, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 12, N' 2. Trả trước cho người bán', N'132', NULL, NULL, N'331', NULL, 5, N'2. Advance to suppliers', 1, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 15, N' 3. Các khoản phải thu khác', N'138', NULL, N'@1351+@1352+@1353+@1354', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 20, N' 4. Dự phòng phải thu ngắn hạn khó đòi (*)', N'139', NULL, NULL, N'1592', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 21, N'IV. Hàng tồn kho', N'140', NULL, N'@141+@149', NULL, NULL, 0, N'IV. Inventories', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 22, N' 1. Hàng tồn kho', N'141', N'(III.02)', N'@1411+@1412+@1413+@1414+@1415+@1416+@1417+@1418', NULL, NULL, 0, N'1. Inventories', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 31, N' 2. Dự phòng giảm giá hàng tồn kho (*)', N'149', NULL, NULL, N'1593', NULL, 5, N'2. Provision for decline in inventory (*)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 32, N'V. Tài sản ngắn hạn khác', N'150', NULL, N'@151+@152+@157+@158', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 34, N' 1. Thuế giá trị gia tăng được khấu trừ', N'151', NULL, NULL, N'133', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 35, N' 2. Thuế và các khoản khác phải thu nhà nước', N'152', NULL, NULL, N'333', NULL, 5, NULL, 1, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 37, N' 4. Tài sản ngắn hạn khác', N'158', NULL, N'@1581+@1582+@1583+@1584', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 42, N'B - TÀI SẢN DÀI HẠN (200 = 210+220+230+240)', N'200', NULL, N'@210+@220+@230+@240', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 50, N'I. Tài sản cố định', N'210', N'(III.03.04)', N'@211+@212+@213', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 52, N' 1. Nguyên giá', N'211', NULL, NULL, N'211', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 53, N' 2. Giá trị hao mòn lũy kế (*)', N'212', NULL, N'@2121+@2122+@2123', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 60, N' 3. Chi phí xây dựng cơ bản dở dang', N'213', NULL, NULL, N'241', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 61, N'II. Bất động sản đầu tư', N'220', NULL, N'@221+@222', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 62, N' 1. Nguyên giá', N'221', NULL, NULL, N'217', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 63, N' 2. Giá trị hao mòn lũy kế (*)', N'222', NULL, NULL, N'2147', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 64, N' III. Các khoản đầu tư tài chính dài hạn', N'230', N'(III.05)', N'@231+@239', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 65, N' 1. Đầu tư tài chính dài hạn', N'231', NULL, NULL, N'221', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 70, N' 2. Dự phòng giảm giá đầu tư tài chính dài hạn (*)', N'239', NULL, NULL, N'229', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 71, N'V. Tài sản dài hạn khác', N'240', NULL, N'@241+@248-@249', NULL, NULL, 0, N'V. Other long-term assets', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 72, N' 1. Phải thu dài hạn', N'241', NULL, NULL, NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 73, N' 2. Tài sản dài hạn khác', N'248', NULL, N'@2481 + @2482', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 76, N' 3. Dự phòng phải thu dài hạn khó đòi (*)', N'249', NULL, NULL, NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 77, N'TỔNG CỘNG TÀI SẢN (250 = 100+200)', N'250', NULL, N'@100+@200', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 79, N'A- NỢ PHẢI TRẢ (300=310+330)', N'300', NULL, N'@310+@330', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 80, N'I. Nợ ngắn hạn', N'310', NULL, N'@311+@312+@313+@314+@315+@316+@318+@323+@327+@328+@329', NULL, NULL, 0, N'I. Short-term liability', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 81, N' 1. Vay ngắn hạn', N'311', NULL, N'@3111+@3112', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 78, N'                               NGUỒN VỐN', NULL, NULL, N'0', NULL, NULL, 0, N'                               CAPITAL', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 0, N'                                   TÀI SẢN', NULL, NULL, N'0', NULL, NULL, 0, N'                                   ASSETS', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 84, N' 2. Phải trả cho người bán', N'312', NULL, NULL, N'331', NULL, 6, N'2. Payable to seller', 1, 1)
--MinhLam--
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 85, N' 3. Người mua trả tiền trước', N'313', NULL, N'@3131+@3132', NULL, NULL, 0, N'3. Advances from customers', 1, 1)
--MinhLam
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 88, N' 4. Thuế và các khoản phải nộp Nhà nước', N'314', N'III.06', NULL, N'333', NULL, 6, N'4. Taxes and payable to state budget', 1, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 89, N' 5. Phải trả người lao động', N'315', NULL, NULL, N'334', NULL, 6, N'5. Payable to employees', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 90, N' 6. Chi phí phải trả', N'316', NULL, NULL, N'335', NULL, 6, N'6. Accruals', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 92, N' 7. Các khoản phải trả ngắn hạn khác', N'318', NULL, N'@3181+@3182', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 105, N' 11. Dự phòng phải trả ngắn hạn', N'329', NULL, NULL, N'352', NULL, 6, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 106, N'II. Nợ dài hạn', N'330', NULL, N'@331+@332+@334+@336+@338+@339', NULL, NULL, 0, N'II. Long-term liability', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 109, N' 1. Vay và nợ dài hạn', N'331', NULL, N'@3311+@3312+@3313', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 118, N' 5. Phải trả, phải nộp dài hạn khác', N'338', NULL, NULL, NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 116, N' 2. Dự phòng trợ cấp mất việc làm', N'332', NULL, NULL, N'351', NULL, 6, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 120, N' 6. Dự phòng phải trả dài hạn', N'339', NULL, NULL, NULL, NULL, 0, N' 6. Provisions for payables', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 121, N'B - NGUỒN VỐN CHỦ SỞ HỮU (400=411+412+413-414+415+416+417)', N'400', NULL, N'@411+@412+@413+@414+@415+@416+@417', NULL, NULL, 0, N'B. CAPITAL (400=411+412+413+414+415+416+417)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 122, N' 1. Vốn đầu tư của chủ sở hữu', N'411', NULL, NULL, N'4111', NULL, 6, N'1. Contributed legal capital', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 123, N' 2. Thăng dư vốn cổ phần', N'412', NULL, NULL, N'4112', NULL, 6, N'2. Share premium', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 124, N' 3. Vốn khác của chủ sở hữu', N'413', NULL, NULL, N'4118', NULL, 6, N'3. Other capital', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 125, N' 4. Cổ phiếu quỹ (*)', N'414', NULL, NULL, N'419', NULL, 6, N'4. Treasury stock (*)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 126, N' 5. Chênh lệch tỷ giá hối đoái', N'415', NULL, NULL, N'413', NULL, 6, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 129, N' 6. Quỹ khác thuộc vốn chủ sỡ hữu', N'416', NULL, NULL, N'418', NULL, 6, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 130, N' 7. Lợi nhuận sau thuế chưa phân phối', N'417', NULL, NULL, N'421', NULL, 6, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 138, N'TỔNG CỘNG NGUỒN VỐN (440 = 300+400)', N'440', NULL, N'@300+@400', NULL, NULL, 0, N'TOTAL LIABILITIES AND OWNERS'' EQUITY (440 = 300 + 400)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 7, N'  1.1', N'1211', NULL, NULL, N'121', NULL, 5, N'  1.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 8, N'  1.2', N'1212', NULL, NULL, N'128', NULL, 5, N'  1.2', 0, 0)
--MinhLam----
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 16, N'   3.1 Phải thu khác', N'1351', NULL, NULL, 1388, NULL, 5, N'   3.1 Other receivables', 0, 1)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 17, N'   3.2', N'1352', NULL, NULL, NULL, NULL, 0, N'   3.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 18, N'   3.3', N'1353', NULL, NULL, NULL, NULL, 0, N'   3.3', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 19, N'   3.4', N'1354', NULL, NULL, NULL, NULL, 0, N'   3.4', 0, 0)
--MinhLam
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 23, N'   1.1', N'1411', NULL, NULL, N'151', NULL, 5, N'   1.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 24, N'   1.2', N'1412', NULL, NULL, N'152', NULL, 5, N'   1.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 25, N'   1.3', N'1413', NULL, NULL, N'153', NULL, 5, N'   1.3', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 26, N'   1.4', N'1414', NULL, NULL, N'154', NULL, 5, N'   1.4', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 27, N'   1.5', N'1415', NULL, NULL, N'155', NULL, 5, N'   1.5', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 28, N'   1.6', N'1416', NULL, NULL, N'156', NULL, 5, N'   1.6', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 29, N'   1.7', N'1417', NULL, NULL, N'157', NULL, 5, N'   1.7', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 30, N'   1.8', N'1418', NULL, NULL, N'158', NULL, 5, N'   1.8', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 38, N'   4.1', N'1581', NULL, NULL, N'1381', NULL, 5, N'   4.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 39, N'   4.2', N'1582', NULL, NULL, N'141', NULL, 5, N'   4.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 41, N'   4.3', N'1583', NULL, NULL, N'144', NULL, 5, N'   4.3', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 82, N'  1.1', N'3111', NULL, NULL, N'311', NULL, 6, N'  1.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 83, N'  1.2', N'3112', NULL, NULL, N'315', NULL, 6, N'  1.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 86, N'  3.1', N'3131', NULL, NULL, N'131', NULL, 6, N'3.1', 0, 1)
--MinhLam
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 87, N'  3.2 Thu trước các khoản phải thu khác', N'3132', NULL, NULL, N'1388', NULL, 6, N'3.2 Prepaid other receivables', 0, 1)
--MinhLam
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 93, N'   7.1', N'3181', NULL, N'@31811+@31812+@31813+@31814+@31815+@31816+@31818+@31819', NULL, NULL, 0, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 110, N'   1.1', N'3311', NULL, NULL, N'341', NULL, 6, N'   1.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 111, N'   1.2', N'3312', NULL, NULL, N'342', NULL, 6, N'   1.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 112, N'   1.3', N'3313', NULL, N'@33431-@33432+@33433', NULL, NULL, 0, N'   1.3', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 113, N'     1.3.1', N'33131', NULL, NULL, N'3431', NULL, 6, N'     1.3.1', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 114, N'     1.3.2', N'33132', NULL, NULL, N'3432', NULL, 5, N'     1.3.2', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 115, N'     1.3.3', N'33133', NULL, NULL, N'3433', NULL, 6, N'     1.3.3', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 40, N'   4.4', N'1584', NULL, NULL, N'142', NULL, 5, N'   4.4', 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 74, N'  2.1', N'2481', NULL, NULL, N'242', NULL, 5, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 75, N'  2.2', N'2482', NULL, NULL, N'244', NULL, 5, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 36, N' 3. Giao dịch mua bán lại trái phiếu Chính phủ', N'157', NULL, NULL, N'171', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 102, N' 8. Quỹ khen thưởng, phúc lợi', N'323', NULL, NULL, N'353', NULL, 6, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 103, N' 9. Giao dịch mua bán lại trái phiếu của Chính phủ', N'327', NULL, NULL, NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 104, N' 10. Doanh thu chưa thực hiện ngắn hạn', N'328', NULL, NULL, N'3387', NULL, 6, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 117, N' 3. Doanh thu chưa thực hiện dài hạn', N'334', NULL, NULL, NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 118, N' 4. Quỹ phát triển khoa học và công nghệ', N'336', NULL, NULL, N'356', NULL, 6, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 139, N'CÁC CHỈ TIÊU NGOÀI BẢNG CÂN ĐỐI KẾ TOÁN', NULL, NULL, N'0', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 140, N'                                   Chỉ tiêu', NULL, NULL, N'0', NULL, NULL, 0, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 141, N' 1. Tài sản thuê ngoài', N'Tempxxx1', NULL, NULL, N'001', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 142, N' 2. Vật tư, hàng hàng hóa nhận giữ hộ, nhận gia công', N'Tempxxx2', NULL, NULL, N'002', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 143, N' 3. Hàng hóa nhận bán hộ, nhận ký gửi, ký cược', N'Tempxxx3', NULL, NULL, N'003', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 144, N' 4. Nợ khó đòi đã xử lý', N'Tempxxx4', NULL, NULL, N'004', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 145, N' 5. Ngoại tệ các loại', N'Tempxxx5', NULL, NULL, N'007', NULL, 5, NULL, 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 54, N'  2.1 Hao mòn TSCĐ hữu hình', N'2121', NULL, NULL, N'2141', NULL, 5, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 55, N'  2.2 Hao mòn TSCĐ thuê tài chính', N'2122', NULL, NULL, N'2142', NULL, 5, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 56, N'  2.3 Hao mòn TSCĐ vô hình', N'2123', NULL, NULL, N'2143', NULL, 5, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 94, N'     7.11', N'31811', NULL, NULL, N'3381', NULL, 6, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 95, N'     7.12', N'31812', NULL, NULL, N'3382', NULL, 6, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 96, N'     7.13', N'31813', NULL, NULL, N'3383', NULL, 6, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 97, N'     7.14', N'31814', NULL, NULL, N'3384', NULL, 6, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 98, N'     7.15', N'31815', NULL, NULL, N'3385', NULL, 6, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 99, N'     7.16', N'31816', NULL, NULL, N'3386', NULL, 6, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 100, N'     7.17', N'31819', NULL, NULL, N'3389', NULL, 6, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 101, N'     7.18', N'31818', NULL, NULL, N'3388', NULL, 6, NULL, 0, 0)

-- Báo cáo lưu chuyển tiền tệ
select @sysReportID = sysReportID from [CDT].[dbo].sysReport
where ReportName = N'Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp'

Update [sysFormReport] set Tk = N'511, 121, 131, 515'
where sysReportID = @sysReportID and stt = 2 and ChiTieu = N'  1. Tiền thu từ bán hàng, cung cấp dịch vụ và doanh thu khác'

Update [sysFormReport] set Tk = N'331,152,153,154,155,156,157,158,159, 611,121'
where sysReportID = @sysReportID and stt = 3 and ChiTieu = N'  2. Tiền chi trả cho người cung cấp hàng hóa và dịch vụ'

Update [sysFormReport] set Tk = N'635, 335'
where sysReportID = @sysReportID and stt = 5 and ChiTieu = N'  4. Tiền chi trả lãi vay'

Update [sysFormReport] set Tk = N'711, 133, 138, 244, 3414, 141, 338, 333, 154, 611'
where sysReportID = @sysReportID and stt = 7 and ChiTieu = N'  6. Tiền thu khác từ hoạt động kinh doanh'

Update [sysFormReport] set Tk = N'811,461,3331,141,431,3388,351 , 133, 353'
where sysReportID = @sysReportID and stt = 8 and ChiTieu = N'  7. Tiền chi khác cho hoạt động kinh doanh'

Update [sysFormReport] set Tk = N'211, 217, 241,  341, 214, 331'
where sysReportID = @sysReportID and stt = 11 and ChiTieu = N'  1. Tiền chi để mua sắm, xây dựng TSCĐ và các tài sản dài hạn khác'

Update [sysFormReport] set Tk = N'121'
where sysReportID = @sysReportID and stt = 13 and ChiTieu = N'  3. Tiền chi cho vay, mua các công cụ nợ của đơn vị khác'

Update [sysFormReport] set Tk = N'121'
where sysReportID = @sysReportID and stt = 14 and ChiTieu = N'  4. Tiền thu hồi cho vay, bán lại các công cụ nợ của đơn vị khác'
  
Update [sysFormReport] set Tk = N'221'
where sysReportID = @sysReportID and stt = 15 and ChiTieu = N'  5. Tiền chi đầu tư góp vào đơn vị khác'

Update [sysFormReport] set Tk = N'221'
where sysReportID = @sysReportID and stt = 16 and ChiTieu = N'  6. Tiền thu hồi đầu tư góp vốn vào đơn vị khác'
  
Update [sysFormReport] set Tk = N'411, 419'
where sysReportID = @sysReportID and stt = 21 and ChiTieu = N'  2. Tiền chi trả vốn góp cho các chủ sỡ hữu, mua lai CP của DN đã phát hành'

Update [sysFormReport] set Tk = N'311, 341, 221, 171'
where sysReportID = @sysReportID and stt = 22 and ChiTieu = N'  3. Tiền vay ngắn hạn, dài hạn nhận được'
  
Update [sysFormReport] set Tk = N'311, 341, 221, 315, 171'
where sysReportID = @sysReportID and stt = 23 and ChiTieu = N'  4. Tiền chi trả nợ gốc vay'

Update [sysFormReport] set Tk = N''
where sysReportID = @sysReportID and stt = 24 and ChiTieu = N'  5. Tiền chi trả nợ thuê tài chính'

Update [sysFormReport] set CachTinh = N'@01-@02-@03-@04-@05+@06-@07'
where sysReportID = @sysReportID and stt = 9 and ChiTieu = N'Lưu chuyển tiền thuần từ hoạt động kinh doanh'

Update [sysFormReport] set CachTinh = N'@22-@23+@24-@25+@26-@27-@21'
where sysReportID = @sysReportID and stt = 18 and ChiTieu = N'Lưu chuyển tiền thuần từ hoạt động đầu tư'

Update [sysFormReport] set CachTinh = N'@31-@32+@33-@34-@35-@36'
where sysReportID = @sysReportID and stt = 26 and ChiTieu = N'Lưu chuyển tiền thuần từ hoạt động tài chính'

if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and stt = 30 and ChiTieu = N'61.1 Ảnh hưởng dương (Tỷ giá hối đoái cuối kỳ > tỷ giá hối đoái trong kỳ)')
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) 
VALUES (@sysReportID, 30, N'61.1 Ảnh hưởng dương (Tỷ giá hối đoái cuối kỳ > tỷ giá hối đoái trong kỳ)', '61.1', NULL, NULL, N'413', N'11', 4, NULL, 1, 0)

if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and stt = 31 and ChiTieu = N'61.2 Ảnh hưởng âm')
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) 
VALUES (@sysReportID, 31, N'61.2 Ảnh hưởng âm', '61.2', NULL, NULL, N'413', N'11', 3, NULL, 1, 0)

Update [sysFormReport] set stt=32
where sysReportID = @sysReportID and stt = 30 and ChiTieu = N'Tiền và tương tiền cuối kỳ (70=50+60+61)'

Update [sysFormReport] set Tk = N'511,131,515'
where sysReportID = @sysReportID and stt = 2 and ChiTieu = N'  1. Tiền thu từ bán hàng, cung cấp dịch vụ và doanh thu khác'

Update [sysFormReport] set Tk = N'331,152,153,154,155,156,157,158,159,611,631,521,632'
where sysReportID = @sysReportID and stt = 3 and ChiTieu = N'  2. Tiền chi trả cho người cung cấp hàng hóa và dịch vụ'

Update [sysFormReport] set Tk = N'334,351,352', ChiTieu = N'  3. Tiền chi trả cho người lao động'
where sysReportID = @sysReportID and stt = 4 and ChiTieu = N'  3. Tiền chi trả cho ngườ lao động'

Update [sysFormReport] set Tk = N'635,335'
where sysReportID = @sysReportID and stt = 5 and ChiTieu = N'  4. Tiền chi trả lãi vay'

Update [sysFormReport] set Tk = N'3334'
where sysReportID = @sysReportID and stt = 6 and ChiTieu = N'  5. Tiền chi nộp thuế thu nhập doanh nghiệp'

Update [sysFormReport] set Tk = N'811,351,352,521,133,353,356,138,244,3414,141,142,334,338,3331,3332,3333,3335,3336,3337,3338,3339,154,611,642,331,631'
where sysReportID = @sysReportID and stt = 7 and ChiTieu = N'  6. Tiền thu khác từ hoạt động kinh doanh'

Update [sysFormReport] set Tk = N'811,821,131,3331,3332,3333,3335,3336,3337,3338,3339,244,3414,431,141,642,142,242,133,138,338,353,356'
where sysReportID = @sysReportID and stt = 8 and ChiTieu = N'  7. Tiền chi khác cho hoạt động kinh doanh'

Update [sysFormReport] set Tk = N'211,217,214,241,711'
where sysReportID = @sysReportID and stt = 11 and ChiTieu = N'  1. Tiền chi để mua sắm, xây dựng TSCĐ và các tài sản dài hạn khác'

Update [sysFormReport] set Tk = N'711,241'
where sysReportID = @sysReportID and stt = 12 and ChiTieu = N'  2. Tiền thu từ thanh lý, nhượng bán TSCĐ và các tài sản dài hạn khác'

Update [sysFormReport] set Tk = N'121'
where sysReportID = @sysReportID and stt = 13 and ChiTieu = N'  3. Tiền chi cho vay, mua các công cụ nợ của đơn vị khác'

Update [sysFormReport] set Tk = N'121,152,153,155,156,157,158,159,632'
where sysReportID = @sysReportID and stt = 14 and ChiTieu = N'  4. Tiền thu hồi cho vay, bán lại các công cụ nợ của đơn vị khác'

Update [sysFormReport] set Tk = N'221'
where sysReportID = @sysReportID and stt = 15 and ChiTieu = N'  5. Tiền chi đầu tư góp vào đơn vị khác'

Update [sysFormReport] set Tk = N'221,335,242,315'
where sysReportID = @sysReportID and stt = 16 and ChiTieu = N'  6. Tiền thu hồi đầu tư góp vốn vào đơn vị khác'

Update [sysFormReport] set CachTinh = N'@22-@23+@24-@25+@26+@27-@21'
where sysReportID = @sysReportID and stt = 18 and ChiTieu = N'Lưu chuyển tiền thuần từ hoạt động đầu tư'

Update [sysFormReport] set Tk = N'411,419,421,418'
where sysReportID = @sysReportID and stt = 20 and ChiTieu = N'  1. Tiền thu từ phát hành cổ phiếu, nhận vốn góp của chủ sỡ hữu'

Update [sysFormReport] set Tk = N'411,419,418'
where sysReportID = @sysReportID and stt = 21 and ChiTieu = N'  2. Tiền chi trả vốn góp cho các chủ sỡ hữu, mua lai CP của DN đã phát hành'

Update [sysFormReport] set Tk = N'311,3411,3412,3413,171,635,821'
where sysReportID = @sysReportID and stt = 22 and ChiTieu = N'  3. Tiền vay ngắn hạn, dài hạn nhận được'

Update [sysFormReport] set Tk = N'311,3411,3412,3413,171,315'
where sysReportID = @sysReportID and stt = 23 and ChiTieu = N'  4. Tiền chi trả nợ gốc vay'

Update [sysFormReport] set Tk = NULL, Tkdu = NULL, LoaiCT = 0
where sysReportID = @sysReportID and stt = 24 and ChiTieu = N'  5. Tiền chi trả nợ thuê tài chính'

Update [sysFormReport] set Tk = N'421'
where sysReportID = @sysReportID and stt = 25 and ChiTieu = N'  6. Cổ tức, lợi nhuận đã trả cho chủ sỡ hữu'

Update [sysFormReport] set MaSo = '60',	Tk = N'11', LoaiCT = 1
where sysReportID = @sysReportID and stt = 28 and ChiTieu = N'Tiền và tương đương tiền đầu kỳ'

Update [sysFormReport] set Tk = NULL, CachTinh = N'@61.1-@61.2'
where sysReportID = @sysReportID and stt = 29 and ChiTieu = N'Ảnh hưởng của thay đổi tỷ giá hối đoái quy đỗi ngọai tệ'

Update [sysFormReport] set Tk = N'413'
where sysReportID = @sysReportID and stt = 30 and ChiTieu = N'61.1 Ảnh hưởng dương (Tỷ giá hối đoái cuối kỳ > tỷ giá hối đoái trong kỳ)'

Update [sysFormReport] set Tk = N'413'
where sysReportID = @sysReportID and stt = 31 and ChiTieu = N'61.2 Ảnh hưởng âm'

Update [sysFormReport] set CachTinh = NULL, Tk = NULL, Tkdu = NULL, LoaiCT = 0
where sysReportID = @sysReportID and stt = 17 and ChiTieu = N'  7. Tiền thu lãi cho vay, cổ tức và lợi nhuận được chia'

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
where sysReportID = @sysReportID and stt = 18 and ChiTieu = N'Lưu chuyển tiền thuần từ hoạt động đầu tư' and MaSo = N'30' and CachTinh = N'@22-@23+@24-@25+@26+@27-@21'

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

Update [sysFormReport] set CachTinh = N'@61.1+@61.2'
where sysReportID = @sysReportID and stt = 29 and ChiTieu = N'Ảnh hưởng của thay đổi tỷ giá hối đoái quy đỗi ngọai tệ' and MaSo = N'61' and CachTinh = N'@61.1-@61.2'

Update [sysFormReport] set XuatGiaTriAm = 1
where sysReportID = @sysReportID and stt = 31 and ChiTieu = N'61.2 Ảnh hưởng âm' and MaSo = N'61.2'

-- Báo cáo kết quả kinh doanh
select @sysReportID = sysReportID from [CDT].[dbo].sysReport
where ReportName = N'Báo cáo kết quả kinh doanh'

delete from sysFormReport where sysReportID = @sysReportID

INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 1, N'1. Doanh thu bán hàng, cung cấp dịch vụ', N'01', N'IV.08', N'@01.1-@01.2-@01.3+@01.4+@02', NULL, NULL, 0, N'1. Sales', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 2, N'1.1  Tổng doanh thu (phát sinh co)', N'01.1', NULL, NULL, N'511', NULL, 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 3, N'1.2  Kết chuyển giảm doanh thu', N'01.2', NULL, NULL, N'511', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 4, N'1.3  Tổng doanh thu (Phát sinh nợ)', N'01.3', NULL, NULL, N'511', NULL, 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 5, N'1.4  Kết chuyển tăng doanh thu', N'01.4', NULL, NULL, N'511', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 6, N'2. Các khoản giảm trừ doanh thu', N'02', NULL, NULL, N'511', N'521, 3331, 3332, 3333', 3, N'2. Deductions', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 10, N'3. Doanh thu thuần về bán hàng và cung cấp dịch vụ(10=01-02)', N'10', NULL, N'@01-@02', NULL, NULL, 0, N'3. Net sales (10 = 01 - 02)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 15, N'4. Giá vốn hàng bán', N'11', NULL, N'@11.1-@11.2', NULL, NULL, 0, N'4. Cost of goods sold', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 16, N'4.1 Tăng giá vốn hàng bán', N'11.1', NULL, NULL, N'632', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 17, N'4.2 Giảm giá vốn hàng bán', N'11.2', NULL, NULL, N'632', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 20, N'5. Lợi  nhuân gộp về bán hàng và cung cấp dịch vụ (20=10-11)', N'20', NULL, N'@10-@11', NULL, NULL, 0, N'5. Gross profit/ (loss) (20 = 10 - 11)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 25, N'6. Doanh thu hoạt động tài chính', N'21', N'VI.26', N'@21.1-@21.2', NULL, NULL, 0, N'6. Financial activities income', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 26, N'6.1 Tăng doanh thu hoạt động tài chính', N'21.1', NULL, NULL, N'515', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 27, N'6.1 Giảm doanh thu hoạt động tài chính', N'21.2', NULL, NULL, N'515', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 30, N'7. Chi phí tài chính', N'22', N'VI.28', N'@22.1-@22.2', NULL, NULL, 0, N'7. Financial activities expenses', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 31, N'7.1 Tăng chi phí tài chính', N'22.1', NULL, NULL, N'635', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 32, N'7.1 Giảm chi phí tài chính', N'22.2', NULL, NULL, N'635', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 35, N'Trong đó Chi phí lãi vay', N'23', NULL, N'@23.1-@23.2', NULL, NULL, 0, N'- In which: Loan interest expenses', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 36, N'Trong đó Tăng chi phí lãi vay', N'23.1', NULL, NULL, N'635', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 37, N'Trong đó Giảm chi phí lãi vay', N'23.2', NULL, NULL, N'635', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 40, N'8. Chi phí quản lý kinh doanh', N'24', NULL, N'@24.1-@24.2', NULL, NULL, 0, N'8. General & administration expenses', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 41, N'8.1 Tăng chi phí quản lý kinh doanh', N'24.1', NULL, NULL, N'642', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 42, N'8.1 Giảm chi phí quản lý kinh doanh', N'24.2', NULL, NULL, N'642', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 45, N'9. Lợi  nhuận thuần từ hoạt động kinh doanh (30=20+21-22-24)', N'30', NULL, N'@20+@21-@22-@24', NULL, NULL, 0, N'9. Net operating profit/(loss) (30=20+21-22-24)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 50, N'10. Thu nhập khác', N'31', NULL, N'@31.1-@31.2', NULL, NULL, 0, N'10. Other income', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 51, N'10.1 Tăng thu nhập khác', N'31.1', NULL, NULL, N'711', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 52, N'10.1 Giảm thu nhập khác', N'31.2', NULL, NULL, N'711', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 55, N'11. Chi phí khác', N'32', NULL, N'@32.1-@32.2', NULL, NULL, 0, N'11. Other expenses', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 56, N'11.1 Tăng chi phí khác', N'32.1', NULL, NULL, N'811', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 57, N'11.2 Giảm chi phí khác', N'32.2', NULL, NULL, N'811', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 60, N'12. Lợi nhuận khác (40=31-32)', N'40', NULL, N'@31-@32', NULL, NULL, 0, N'12. Other profit/(loss)  (40=31-32)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 65, N'13. Tổng lợi nhuận trước thuế (50=30+40)', N'50', N'IV.09', N'@30+@40', NULL, NULL, 0, N'13. Profit/(loss) before tax (50=30+40)', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 70, N'14. Chi phí thuế thu nhập doanh nghiệp', N'51', N'VI.30', N'@51.1-@51.2', NULL, NULL, 0, N'14. Business income tax charge', 1, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 71, N'14.1 Tăng chi phí thuế thu nhập doanh nghiệp', N'51.1', NULL, NULL, N'821', N'911', 4, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 72, N'14.2 Giảm chi phí thuế thu nhập doanh nghiệp', N'51.2', NULL, NULL, N'821', N'911', 3, NULL, 0, 0)
INSERT [dbo].[sysFormReport] ([sysReportID], [Stt], [ChiTieu], [MaSo], [ThuyetMinh], [CachTinh], [Tk], [Tkdu], [LoaiCT], [ChiTieu2], [InBaoCao], [Iscn]) VALUES (@sysReportID, 75, N'15. Lợi nhuận sau thuế thu nhập doanh nghiệp (60=50-51)', N'60', NULL, N'@50-@51', NULL, NULL, 0, N'15. Profit/(loss) after tax (60=50-51)', 1, 0)