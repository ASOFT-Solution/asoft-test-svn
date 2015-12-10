use [CDT]

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Vật tư hàng hóa' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Vật tư hàng hóa', N'ITEMS')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Bảng thuế TTDB đầu vào' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Bảng thuế TTDB đầu vào', N'List of Special Consumtion Tax in')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'- Họ và tên người nhận hàng :' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'- Họ và tên người nhận hàng :', N'- Full name of the consignee :')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Hóa đơn bán hàng đặt in' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Hóa đơn bán hàng đặt in', N'Customize Invoice')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Hóa đơn dịch vụ đặt in' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Hóa đơn dịch vụ đặt in', N'Customize Invoice (Services)')


if not exists (select top 1 1 from [Dictionary] where [Content] = N'Phiếu xuất kho-giá bán' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Phiếu xuất kho-giá bán', N'ExWarehouse-Price')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Phiếu xuất kho-giá vốn' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Phiếu xuất kho-giá vốn', N'ExWarehouse-Cost')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Họ và tên người mua hàng :' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Họ và tên người mua hàng :', N'Full name of the buyer :')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tính thành công' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Tính thành công', N'Computer successfully')

------------Quản trị chứng từ thuế GTGT đầu vào-------------
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tổng thuế GTGT hàng hóa dịch vụ mua vào' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Tổng thuế GTGT hàng hóa dịch vụ mua vào', N'The total VAT on goods and services purchased')

------------Quản trị chứng từ thuế GTGT đầu ra-------------
if not exists (select top 1 1 from [Dictionary] where [Content] = N'1.Hàng hoá, dịch vụ dùng riêng cho SXKD chịu thuế GTGT:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'1.Hàng hoá, dịch vụ dùng riêng cho SXKD chịu thuế GTGT:', N'1. Goods and services used for taxable business tax credit eligibility:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'2.Hàng hoá, dịch vụ dùng riêng cho SXKD không chịu thuế GTGT:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'2.Hàng hoá, dịch vụ dùng riêng cho SXKD không chịu thuế GTGT:', N'2. Goods and services not eligible for deduction:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'3.Hàng hoá, dịch vụ dùng chung cho SXKD chịu thuế GTGT và không chịu thuế GTGT:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'3.Hàng hoá, dịch vụ dùng chung cho SXKD chịu thuế GTGT và không chịu thuế GTGT:', N'3. Goods and services used for business generally taxable and nontaxable deduction eligibility:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'4.Hàng hóa dịch vụ dùng cho dự án đầu tư:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'4.Hàng hóa dịch vụ dùng cho dự án đầu tư:', N'4. Goods and services used for projects eligible for tax deduction:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'5.Hàng hóa, dịch vụ không phải tổng hợp trên tờ khai 01/GTGT:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'5.Hàng hóa, dịch vụ không phải tổng hợp trên tờ khai 01/GTGT:', N'5. Goods, service not set on the declaration 01/GTGT:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'5.Hàng hóa, dịch vụ không phải tổng hợp trên tờ khai 01/GTGT:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'5.Hàng hóa, dịch vụ không phải tổng hợp trên tờ khai 01/GTGT:', N'5. Goods, service not set on the declaration 01/GTGT:')



if not exists (select top 1 1 from [Dictionary] where [Content] = N'Hàng hóa, dịch vụ không chịu thuế GTGT' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Hàng hóa, dịch vụ không chịu thuế GTGT', N'Goods, service none VAT:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Hàng hóa, dịch vụ không phải tổng hợp trên tờ khai 01/GTGT' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Hàng hóa, dịch vụ không phải tổng hợp trên tờ khai 01/GTGT', N'Goods and services used for business generally taxable and nontaxable deduction eligibility:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Hàng hóa, dịch vụ chịu thuế suất thuế GTGT' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Hàng hóa, dịch vụ chịu thuế suất thuế GTGT', N'Goods, service with VAT')
------------Bảng kế chứng từ thuế GTGT mua vào-------------
if not exists (select top 1 1 from [Dictionary] where [Content] = N'1.Hàng hóa, dịch vụ riêng cho SXKD chịu thuế GTGT đủ điều kiện khấu trừ thuế:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'1.Hàng hóa, dịch vụ riêng cho SXKD chịu thuế GTGT đủ điều kiện khấu trừ thuế:', N'1. Goods and services used for taxable business tax credit eligibility:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'2.Hàng hóa, dịch vụ không đủ điều kiện khấu trừ thuế:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'2.Hàng hóa, dịch vụ không đủ điều kiện khấu trừ thuế:', N'2. Goods and services not eligible for deduction:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'3.Hàng hóa, dịch vụ dùng chung cho SXKD chịu thuế và không chịu thuế đủ điều kiện khấu trừ:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'3.Hàng hóa, dịch vụ dùng chung cho SXKD chịu thuế và không chịu thuế đủ điều kiện khấu trừ:', N'3. Goods and services used for business generally taxable and nontaxable deduction eligibility:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'4.Hàng hóa, dịch vụ dùng cho dự án đầu tư đủ điều kiện được khấu trừ thuế:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'4.Hàng hóa, dịch vụ dùng cho dự án đầu tư đủ điều kiện được khấu trừ thuế:', N'4. Goods and services used for projects eligible for tax deduction:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'(*) Tổng doanh thu hàng hóa, dịch vụ mua vào là tổng cộng số liệu tại cột 8 của dòng tổng của các chỉ tiêu 1, 2, 3, 4.' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'(*) Tổng doanh thu hàng hóa, dịch vụ mua vào là tổng cộng số liệu tại cột 8 của dòng tổng của các chỉ tiêu 1, 2, 3, 4.', N'(*) Total sales of goods and services purchased in the total figures in column 8 of the total of the criteria 1, 2, 3, 4.')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'(**) Tổng số thuế GTGT của hàng hóa, dịch vụ mua vào là tổng cộng số liệu tại cột 10 của dòng tổng của các chỉ tiêu 1, 2, 3, 4.' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'(**) Tổng số thuế GTGT của hàng hóa, dịch vụ mua vào là tổng cộng số liệu tại cột 10 của dòng tổng của các chỉ tiêu 1, 2, 3, 4.', N'(**) Number of VAT on goods and services purchased in the total figures in column 10 of the total of the criteria 1, 2, 3, 4.')
--------------Bảng kế chứng từ thuế GTGT bán ra---------------------
if not exists (select top 1 1 from [Dictionary] where [Content] = N'1.Hàng hóa, dịch vụ không chịu thuế GTGT:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'1.Hàng hóa, dịch vụ không chịu thuế GTGT:', N'1. Goods, service none VAT:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'2.Hàng hóa, dịch vụ chịu thuế suất thuế GTGT 0%:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'2.Hàng hóa, dịch vụ chịu thuế suất thuế GTGT 0%:', N'2. Goods, service with VAT 0%:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'3.Hàng hóa, dịch vụ chịu thuế suất thuế GTGT 5%:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'3.Hàng hóa, dịch vụ chịu thuế suất thuế GTGT 5%:', N'2. Goods, service with VAT 5%:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'4.Hàng hóa, dịch vụ chịu thuế suất thuế GTGT 10%:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'4.Hàng hóa, dịch vụ chịu thuế suất thuế GTGT 10%:', N'2. Goods, service with VAT 10%:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'(**) Tổng doanh thu hàng hóa, dịch vụ bán ra chịu thuế GTGT là tổng cộng số liệu tại cột 8 của dòng tổng của các chỉ tiêu 2, 3, 4.' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'(**) Tổng doanh thu hàng hóa, dịch vụ bán ra chịu thuế GTGT là tổng cộng số liệu tại cột 8 của dòng tổng của các chỉ tiêu 2, 3, 4.', N'(**) Total sales of goods and services sold to VAT is the total figures in column 8 of the total of the criteria 2, 3, 4.')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'(***) Tổng số thuế GTGT của hàng hóa, dịch vụ bán ra là tổng cộng số liệu tại cột 9 của dòng tổng của các chỉ tiêu 2, 3, 4.' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'(***) Tổng số thuế GTGT của hàng hóa, dịch vụ bán ra là tổng cộng số liệu tại cột 9 của dòng tổng của các chỉ tiêu 2, 3, 4.', N'(***) Total VAT on goods and services sold is the total figures in column 9 of the sum of the criteria 2, 3, 4.')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Doanh số bán chưa có thuế' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Doanh số bán chưa có thuế', N'Sales tax sale')


if not exists (select top 1 1 from [Dictionary] where [Content] = N'Số lượng mua' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Số lượng mua', N'Purchased Quantity')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Loại' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Loại', N'Type')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tiền pb trong kỳ' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Tiền pb trong kỳ', N'Money allocated in the period')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Đã xóa bút toán thành công!' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Đã xóa bút toán thành công!', N'Deleted journal entry successfully!')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'(Bổ sung, điều chỉnh các thông tin đã khai tại Tờ khai thuế {0} mẫu số {1} kỳ tính thuế {2} ngày {3} tháng {4} năm {5})' )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'(Bổ sung, điều chỉnh các thông tin đã khai tại Tờ khai thuế {0} mẫu số {1} kỳ tính thuế {2} ngày {3} tháng {4} năm {5})', N'Additional adjustment information tax return filed in Form {0} - Denominator {1} - Period {2} tax period on {3}-{4}-{5})')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'[02] Mã số thuế:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'[02] Mã số thuế:', N'[02] Tax code:')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'[03] Địa chỉ:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'[03] Địa chỉ:', N'[03] Address:')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'[04] Quận/huyện:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'[04] Quận/huyện:', N'[04] District:')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'[06] Điện thoại:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'[06] Điện thoại:', N'[06] Tel')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'[05] Tỉnh/thành phố:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'[05] Tỉnh/thành phố:', N'[05] Province:')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'[09] Tên đại lý thuế (nếu có):' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'[09] Tên đại lý thuế (nếu có):', N'[09] Tax agent name (If any) :')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'[10] Mã số thuế:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'[10] Mã số thuế:', N'[10] Tax code:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'[11] Địa chỉ:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'[11] Địa chỉ:', N'[11] Address:')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'[12] Quận/huyện:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'[12] Quận/huyện:', N'[12] District:')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'[13] Tỉnh/thành phố:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'[13] Tỉnh/thành phố:', N'[13] Province:')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'[14] Điện thoại:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'[14] Điện thoại:', N'[14] Tel')	

if not exists (select top 1 1 from [Dictionary] where [Content] = N'[17] Hợp đồng đại lý thuế: Số' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'[17] Hợp đồng đại lý thuế: Số', N'[17] Tax agent contracts: No ')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'A. Nội dung bổ sung, điều chỉnh thông tin đã kê khai:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'A. Nội dung bổ sung, điều chỉnh thông tin đã kê khai:', N'A. Additional content, content control additional information, adjust the declared information')	

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Chỉ tiêu điều chỉnh' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Chỉ tiêu điều chỉnh', N'Adjustment target')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Mã số chỉ tiêu' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Mã số chỉ tiêu', N'Target Code')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Số đã kê khai' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Số đã kê khai', N'Declaration')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Số điều chỉnh' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Số điều chỉnh', N'Update Code')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Chênh lệch giữa số điều chỉnh với số đã kê khai' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Chênh lệch giữa số điều chỉnh với số đã kê khai', N'The difference between the adjustment to the previously declared')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Chỉ tiêu điều chỉnh tăng số thuế phải nộp' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Chỉ tiêu điều chỉnh tăng số thuế phải nộp', N'Target to increase the amount to be paid')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Điều chỉnh tăng thuế GTGT bán ra' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Điều chỉnh tăng thuế GTGT bán ra', N'Adjust the VAT increase sales')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Điều chỉnh giảm thuế GTGT mua vào' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Điều chỉnh giảm thuế GTGT mua vào', N'Adjust VAT reduction purchase')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Chỉ tiêu điều chỉnh giảm số thuế phải nộp' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Chỉ tiêu điều chỉnh giảm số thuế phải nộp', N'Targets to decrease the amount of tax payable')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Điều chỉnh giảm thuế GTGT bán ra' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Điều chỉnh giảm thuế GTGT bán ra', N'Adjust VAT reduction sale')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Điều chỉnh tăng thuế GTGT mua vào' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Điều chỉnh tăng thuế GTGT mua vào', N'Adjust the VAT increase buying')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tổng hợp điều chỉnh số thuế phải nộp (tăng: +; giảm: -)' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Tổng hợp điều chỉnh số thuế phải nộp (tăng: +; giảm: -)', N'Aggregate amount of tax payable adjustment (increase: +; down: -)')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'B. Tính số tiền phạt chậm nộp:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'B. Tính số tiền phạt chậm nộp:', N'B. Calculate the number of fines for late payment:')	
if not exists (select top 1 1 from [Dictionary] where [Content] = N'1. Số ngày chậm nộp:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'1. Số ngày chậm nộp:', N'1. Number of days late payment:')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'2. Số tiền phạt chậm nộp (= số thuế điều chỉnh tăng x số ngày chậm nộp x 0,05%): ' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'2. Số tiền phạt chậm nộp (= số thuế điều chỉnh tăng x số ngày chậm nộp x 0,05%): ', N'2. Fines for late payment (= tax adjusted x number of days delayed payment x 0.05%)')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'C. Nội dung giải thích và tài liệu đính kèm:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'C. Nội dung giải thích và tài liệu đính kèm:', N'C. Explain the content and attachments:')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'1. Tờ khai thuế {0} mẫu số {1} kỳ tính thuế {2} đã được bổ sung, điều chỉnh................' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'1. Tờ khai thuế {0} mẫu số {1} kỳ tính thuế {2} đã được bổ sung, điều chỉnh................', N'Tax {0} - denominator {1} - period {2} was added, adjusting ................')
if not exists (select top 1 1 from [Dictionary] where [Content] = N' - Thuế GTGT của HHDV mua vào dùng chung cho SXKD HHDV chịu thuế và không chịu thuế đủ điều kiện khấu trừ:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N' - Thuế GTGT của HHDV mua vào dùng chung cho SXKD HHDV chịu thuế và không chịu thuế đủ điều kiện khấu trừ:', N'- VAT of HHDV commonly used for production or business buying HHDV subject and not subject to tax deduction eligibility:')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'(Kèm theo Tờ khai TTĐB mẫu số 01/TTĐB ngày {0} tháng {1} năm {2})' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'(Kèm theo Tờ khai TTĐB mẫu số 01/TTĐB ngày {0} tháng {1} năm {2})', N'(Attached to the declaration form of excise 01/TTDB {0}-{1}-{2})')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'I. Bảng tính thuế TTĐB của nguyên liệu mua vào:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'I. Bảng tính thuế TTĐB của nguyên liệu mua vào:', N'I. Spreadsheet of the special consumption tax on materials purchased:')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Chứng từ hoặc biên lai nộp thuế TTĐB' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Chứng từ hoặc biên lai nộp thuế TTĐB', N'Vouchers or receipts for payment')







----------------------------
UPDATE sysTable  SET DienGiai2 = N'List of Special Consumtion Tax in'  WHERE TableName ='TTDBin' And DienGiai = N'Bảng thuế TTDB đầu vào'
UPDATE sysTable  SET DienGiai2 = N'List of Special Consumtion Tax out'  WHERE TableName ='TTDBout' And DienGiai = N'Bảng thuế TTDB đầu ra'

UPDATE sysTable  SET DienGiai2 = N'List of VAT Tax out'  WHERE TableName ='VATOUT' And DienGiai = N'Bảng thuế GTGT đầu ra'

UPDATE [sysPrintedInvoiceDt]  SET [ReportName2] = N'VAT Invoice' WHERE [sysReportID] = 'HDBHTUIN' AND [ReportName] = N'Hóa đơn thuế GTGT' 
UPDATE [sysPrintedInvoiceDt]  SET [ReportName2] = N'VAT Invoice (Services)' WHERE [sysReportID] = 'INHDDVUTUIN' AND [ReportName] = N'Hóa đơn thuế GTGT(dịch vụ)' 

--- Cập nhật (Phiếu thu công nợ theo hóa đơn) không hiện tên
UPDATE sysField
SET    LabelName2 = N'Total of money differences'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MT34')
       AND FieldName = 'TongCLTG'
       AND LabelName = N'Tổng tiền CLTG' 
--- Cập nhật bảng kê phiếu thu không hiện tên
UPDATE sysField
SET    LabelName2 = N'No.1'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DVATTNDN')
       AND FieldName = 'Stt1'
       AND LabelName = N'Số thứ tự 1'
UPDATE sysField
SET    LabelName2 = N'No.2'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DVATTNDN')
       AND FieldName = 'Stt2'
       AND LabelName = N'Số thứ tự 2'        
-- Dư tenkh1       
--UPDATE [dbo].[sysReport]
--SET    [Query] = 'select mt.*, dt.*  from MT11 mt, DT11 dt, dmkh  where mt.MT11ID = dt.MT11ID and dt.makhct  = dmkh.makh  and @@ps'
--WHERE  ReportName = N'Bảng kê phiếu thu'
  --     AND ReportFile = N'BKPTHU'
---------------------Thuế GTGT-------------------
UPDATE sysField
SET    LabelName2 = N'Deduction Period'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MT36')
       AND FieldName = 'KyKTT'
       AND LabelName = N'Kỳ khấu trừ' 
       
UPDATE sysField
SET    LabelName2 = N'Total pre-tax currency'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MT36')
       AND FieldName = 'TThueKyTruocNT'
       AND LabelName = N'Tổng tiền thuế kỳ trước nguyên tệ'        

UPDATE sysField
SET    LabelName2 = N'Total pre-tax'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MT36')
       AND FieldName = 'TThueKyTruoc'
       AND LabelName = N'Tổng tiền thuế kỳ trước' 
       
UPDATE sysField
SET    LabelName2 = N'Total sales tax on currency'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MT36')
       AND FieldName = 'TThueBKMVNT'
       AND LabelName = N'Tổng tiền thuế mua vào nguyên tệ' 

UPDATE sysField
SET    LabelName2 = N'Total sales tax'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MT36')
       AND FieldName = 'TThueBKMV'
       AND LabelName = N'Tổng tiền thuế mua vào' 

UPDATE sysField
SET    LabelName2 = N'The total of sales-tax currency'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MT36')
       AND FieldName = 'TThueBKBRNT'
       AND LabelName = N'Tổng tiền thuế bán ra nguyên tệ' 


UPDATE sysField
SET    LabelName2 = N'The total of sales-tax'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MT36')
       AND FieldName = 'TThueBKBR'
       AND LabelName = N'Tổng tiền thuế bán ra' 
----------DT36-------------       
UPDATE sysField
SET    LabelName2 = N'Contract'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DT36')
       AND FieldName = 'MaVV'
       AND LabelName = N'Mã vụ việc' 

UPDATE sysField
SET    LabelName2 = N'Cost code'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DT36')
       AND FieldName = 'MaPhi'
       AND LabelName = N'Mã phí' 

UPDATE sysField
SET    LabelName2 = N'Department code'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DT36')
       AND FieldName = 'MaBP'
       AND LabelName = N'Mã bộ phận' 

UPDATE sysField
SET    LabelName2 = N'Product code'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DT36')
       AND FieldName = 'MaSP'
       AND LabelName = N'Mã sản phẩm' 
       
UPDATE sysField
SET    LabelName2 = N'Project code'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DT36')
       AND FieldName = 'MaCongTrinh'
       AND LabelName = N'Mã công trình'               
       
----------MVATTNDN---------------

UPDATE sysField
SET    LabelName2 = N'Quarter'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MVATTNDN')
       AND FieldName = 'Quy'
       AND LabelName = N'Quý'       

UPDATE sysField
SET    LabelName2 = N'Year'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MVATTNDN')
       AND FieldName = 'Nam1'
       AND LabelName = N'Năm'       

UPDATE sysField
SET    LabelName2 = N'Year'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MVATTNDN')
       AND FieldName = 'Nam2'
       AND LabelName = N'Năm' 
 
 UPDATE sysField
SET    LabelName2 = N'First Print'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MVATTNDN')
       AND FieldName = 'InLanDau'
       AND LabelName = N'In lần đầu'              

UPDATE sysField
SET    LabelName2 = N'Count of Print'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MVATTNDN')
       AND FieldName = 'SoLanIn'
       AND LabelName = N'Số lần in'

UPDATE sysField
SET    LabelName2 = N'Enterprise basis of accounting'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MVATTNDN')
       AND FieldName = 'PhuThuoc'
       AND LabelName = N'Doanh nghiệp có cơ sở hạch toán phụ thuộc'
 
 UPDATE sysField
SET    LabelName2 = N'Note'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MVATTNDN')
       AND FieldName = 'DienGiai'
       AND LabelName = N'Diễn giải'
 
  UPDATE sysField
SET    LabelName2 = N'Document Name 1'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MVATTNDN')
       AND FieldName = 'TaiLieu1'
       AND LabelName = N'Tên tài liệu 1'

  UPDATE sysField
SET    LabelName2 = N'Document Name 2'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MVATTNDN')
       AND FieldName = 'TaiLieu2'
       AND LabelName = N'Tên tài liệu 2'

  UPDATE sysField
SET    LabelName2 = N'Document Name 3'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MVATTNDN')
       AND FieldName = 'TaiLieu3'
       AND LabelName = N'Tên tài liệu 3'                                       

  UPDATE sysField
SET    LabelName2 = N'Document Name 4'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MVATTNDN')
       AND FieldName = 'TaiLieu4'
       AND LabelName = N'Tên tài liệu 4'       

  UPDATE sysField
SET    LabelName2 = N'Document Name 5'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'MVATTNDN')
       AND FieldName = 'TaiLieu5'
       AND LabelName = N'Tên tài liệu 5'       
----------DVATTNDN -------------------
UPDATE sysField
SET    LabelName2 = N'Target name'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DVATTNDN')
       AND FieldName = 'TenChiTieu'
       AND LabelName = N'Tên chỉ tiêu'

UPDATE sysField
SET    LabelName2 = N'Target name 2'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DVATTNDN')
       AND FieldName = 'TenChiTieu2'
       AND LabelName = N'Tên chỉ tiêu 2'
 
UPDATE sysField
SET    LabelName2 = N'Code'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DVATTNDN')
       AND FieldName = 'MaCode'
       AND LabelName = N'Mã số'                   
       
UPDATE sysField
SET    LabelName2 = N'Amount'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DVATTNDN')
       AND FieldName = 'TTien'
       AND LabelName = N'Số tiền'                                                           

UPDATE sysField
SET    LabelName2 = N'Note'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DVATTNDN')
       AND FieldName = 'GhiChu'
       AND LabelName = N'Ghi chú' 

UPDATE sysField
SET    LabelName2 = N'Sort Order'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DVATTNDN')
       AND FieldName = 'SortOrder'
       AND LabelName = N'Thứ tự sắp xếp'        
-----------------DTTDBInI------------------
UPDATE sysField
SET    LabelName2 = N'The number of purchased materials'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInI')
       AND FieldName = 'ISoLuong6'
       AND LabelName = N'Số lượng đơn vị NL mua vào'  

UPDATE sysField
SET    LabelName2 = N'Excise tax paid currency'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInI')
       AND FieldName = 'Ips7NT'
       AND LabelName = N'Thuế TTĐB đã nộp NT' 

UPDATE sysField
SET    LabelName2 = N'Excise tax paid'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInI')
       AND FieldName = 'Ips7'
       AND LabelName = N'Thuế TTĐB đã nộp' 

UPDATE sysField
SET    LabelName2 = N'Excise tax on a unit of raw materials purchased in currencies'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInI')
       AND FieldName = 'IThueTTDB8NT'
       AND LabelName = N'Thuế TTĐB trên 1 đơn vị NL mua vào NT' 

UPDATE sysField
SET    LabelName2 = N'Excise tax on a unit of raw materials purchased in'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInI')
       AND FieldName = 'IThueTTDB8'
       AND LabelName = N'Thuế TTĐB trên 1 đơn vị NL mua vào' 

UPDATE sysField
SET    LabelName2 = N'Excise tax previously withheld (currency)'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInI')
       AND FieldName = 'Ips9NT'
       AND LabelName = N'Thuế TTĐB đã KT các kỳ trước NT'


UPDATE sysField
SET    LabelName2 = N'Excise tax previously withheld'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInI')
       AND FieldName = 'Ips9'
       AND LabelName = N'Thuế TTĐB đã KT các kỳ trước'

UPDATE sysField
SET    LabelName2 = N'Excise tax may be deducted currency'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInI')
       AND FieldName = 'Ips10NT'
       AND LabelName = N'Thuế TTĐB chưa được KT NT'

UPDATE sysField
SET    LabelName2 = N'Excise tax may be deducted'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInI')
       AND FieldName = 'Ips10'
       AND LabelName = N'Thuế TTĐB chưa được KT'
----------------------DTTDBInII-------------------
UPDATE sysField
SET    LabelName2 = N'The amount of material on a consumer product'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInII')
       AND FieldName = 'IISoLuong5'
       AND LabelName = N'Lượng NL trên 1 sản phẩm tiêu thụ'

UPDATE sysField
SET    LabelName2 = N'Excise tax on an input unit currency'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInII')
       AND FieldName = 'IIThueTTDB6NT'
       AND LabelName = N'Thuế TTĐB trên 1 đơn vị NL đầu vào NT'

UPDATE sysField
SET    LabelName2 = N'Excise tax on an input unit'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInII')
       AND FieldName = 'IIThueTTDB6'
       AND LabelName = N'Thuế TTĐB trên 1 đơn vị NL đầu vào'

UPDATE sysField
SET    LabelName2 = N'The total input tax deductible excise currency'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInII')
       AND FieldName = 'IIps7NT'
       AND LabelName = N'Tổng thuế TTĐB đầu vào được KT NT'

UPDATE sysField
SET    LabelName2 = N'The total input tax deductible excise'
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = 'DTTDBInII')
       AND FieldName = 'IIps7'
       AND LabelName = N'Tổng thuế TTĐB đầu vào được KT'
                                                                             
                                                                                    
--- Cập nhật Tổng hợp -> Quản trị chứng từ
UPDATE sysFormReport
   SET ReportName2 = N'Sheet of vouchers'
 WHERE ReportName =N'Bảng kê chứng từ'
 AND ReportFile ='BKCTU'
 AND sysReportID = (SELECT [sysReportID]
					FROM   [dbo].[sysReport]
					WHERE  ReportName = N'Bảng kê chứng từ')
  
  
-----------------Bảng kê phiếu mua hàng---------------
UPDATE sysFormReport
   SET ReportName2 = N'Sheet of purchasing service by items'
 WHERE ReportName =N'Bảng kê phiếu mua hàng theo mặt hàng'
 AND ReportFile ='BKPMHANG'
 AND sysReportID = (SELECT [sysReportID]
					FROM   [dbo].[sysReport]
					WHERE  ReportName = N'Bảng kê phiếu mua hàng')
-----------------Bảng kê chi tiết công nợ phải trả theo hóa đơn-------------
UPDATE sysFormReport
   SET ReportName2 = N'A detailed list of debts to pay by invoice'
 WHERE ReportName =N'Bảng kê chi tiết công nợ phải trả theo hóa đơn'
 AND ReportFile ='BKCTTTHD'
 AND sysReportID = (SELECT [sysReportID]
					FROM   [dbo].[sysReport]
					WHERE  ReportName = N'Bảng kê chi tiết công nợ phải trả theo hóa đơn')
-----------------Bảng kê hóa đơn bán hàng------------------
UPDATE sysFormReport
   SET ReportName2 = N'A list of detailed sales invoice as no cost items'
 WHERE ReportName =N'Bảng kê HĐBH chi tiết theo mặt hàng không có giá vốn'
 AND ReportFile ='BKHDBHANG'
 AND sysReportID = (SELECT [sysReportID]
					FROM   [dbo].[sysReport]
					WHERE  ReportName = N'Bảng kê hóa đơn bán hàng')
-------------Bảng kê chi tiết công nợ phải thu theo hóa đơn---------------
UPDATE sysFormReport
   SET ReportName2 = N'A detailed list of accounts receivable invoices'
 WHERE ReportName =N'Bảng kê chi tiết công nợ phải thu theo hóa đơn'
 AND ReportFile ='BKCTTTHD'
 AND sysReportID = (SELECT [sysReportID]
					FROM   [dbo].[sysReport]
					WHERE  ReportName = N'Bảng kê chi tiết công nợ phải thu theo hóa đơn')					




---------------------
--INSERT [dbo].[sysField] ([sysFieldID], [sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (34791, 2079, N'KHThang', 1, NULL, NULL, NULL, NULL, 2, N'Khấu hao tháng', N'Month Depreciation', 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
if not exists (select top 1 1 from Dictionary where Content = N'( Ban hành theo QĐ số  : 15/2006/QĐ-BTC\r\nNgày 20/03/2006 của Bộ trưởng BTC )')insert into Dictionary(Content, Content2) Values (N'( Ban hành theo QĐ số  : 15/2006/QĐ-BTC\r\nNgày 20/03/2006 của Bộ trưởng BTC )',N'(Issued with Decission No: 15/2006/QĐ-BTC\r\nDated march 20/03/2006 by Ministry of Finance)')
if not exists (select top 1 1 from Dictionary where Content = N'Tên, nhãn hiệu, quy cách,\r\nphẩm chất vật tư, dụng cụ\r\nsản phẩm, hàng hóa')insert into Dictionary(Content, Content2) Values (N'Tên, nhãn hiệu, quy cách,\r\nphẩm chất vật tư, dụng cụ\r\nsản phẩm, hàng hóa',N'The name, brand,specifications,\r\nquality of materials and tools products and goods')
if not exists (select top 1 1 from Dictionary where Content = N'Theo\r\nchứng từ')insert into Dictionary(Content, Content2) Values (N'Theo\r\nchứng từ',N'By\r\nvouchers')
if not exists (select top 1 1 from Dictionary where Content = N'Thực\r\nnhập')insert into Dictionary(Content, Content2) Values (N'Thực\r\nnhập',N'Net inward')
if not exists (select top 1 1 from Dictionary where Content = N'NGƯỜI NỘP THUẾ hoặc\r\nĐẠI DIỆN HỢP PHÁP CỦA NGƯỜI NỘP THUẾ')insert into Dictionary(Content, Content2) Values (N'NGƯỜI NỘP THUẾ hoặc\r\nĐẠI DIỆN HỢP PHÁP CỦA NGƯỜI NỘP THUẾ',N'TAXPAYER or \r\nLEGAL REPRESENTATIVE OF TAXPAYER')
if not exists (select top 1 1 from Dictionary where Content = N'Mẫu số: 01/GTGT\r\n(Ban hành kèm theo Thông tư \r\nsố 28/2011/TT-BTC ngày 28/02/2011 của Bộ Tài chính)')insert into Dictionary(Content, Content2) Values (N'Mẫu số: 01/GTGT\r\n(Ban hành kèm theo Thông tư \r\nsố 28/2011/TT-BTC ngày 28/02/2011 của Bộ Tài chính)',N'Form No.: 01/GTGT\r\n(Issued with Decission \r\nNo: 28/2011/QĐ-BTC dated march 28/02/2011 by Ministry of Finance)')
if not exists (select top 1 1 from Dictionary where Content = N'CỘNG HOÀ XÃ  HỘI CHỦ NGHĨA VIỆT NAM\r\nĐộc lập - Tự do - Hạnh phúc')insert into Dictionary(Content, Content2) Values (N'CỘNG HOÀ XÃ  HỘI CHỦ NGHĨA VIỆT NAM\r\nĐộc lập - Tự do - Hạnh phúc',N'SOCIALIST REPUBLIC OF VIETNAM\r\nIndependence - Fredom - Happiness')
if not exists (select top 1 1 from Dictionary where Content = N'Giá trị HHDV                                 \r\n(chưa có thuế GTGT)')insert into Dictionary(Content, Content2) Values (N'Giá trị HHDV                                 \r\n(chưa có thuế GTGT)',N'The value of goods and services\r\n(without VAT)')
if not exists (select top 1 1 from Dictionary where Content = N'Mẫu số: 01/KHBS\r\n(Ban hành kèm theo Thông tư \r\nsố 28/2011/TT-BTC ngày 28/02/2011 của Bộ Tài chính)')insert into Dictionary(Content, Content2) Values (N'Mẫu số: 01/KHBS\r\n(Ban hành kèm theo Thông tư \r\nsố 28/2011/TT-BTC ngày 28/02/2011 của Bộ Tài chính)',N'Form No.: 01/KHBS\r\n(Issued with Decission \r\nNo: 28/2011/QĐ-BTC dated march 28/02/2011 by Ministry of Finance)')
if not exists (select top 1 1 from Dictionary where Content = N'BẢN GIẢI TRÌNH KHAI BỔ SUNG, ĐIỀU CHỈNH')insert into Dictionary(Content, Content2) Values (N'BẢN GIẢI TRÌNH KHAI BỔ SUNG, ĐIỀU CHỈNH',N'The explanation - additional - adjustment')
if not exists (select top 1 1 from Dictionary where Content = N'BẢNG PHÂN BỔ SỐ THUẾ GIÁ TRỊ GIA TĂNG\r\nCỦA HÀNG HOÁ DỊCH VỤ MUA VÀO ĐƯỢC KHẤU TRỪ TRONG KỲ')insert into Dictionary(Content, Content2) Values (N'BẢNG PHÂN BỔ SỐ THUẾ GIÁ TRỊ GIA TĂNG\r\nCỦA HÀNG HOÁ DỊCH VỤ MUA VÀO ĐƯỢC KHẤU TRỪ TRONG KỲ',N'ALLOCATION TABLE VALUE ADDED TAX PURCHASE \r\nOF GOODS TO BE SERVICE IN ANY CREDIT')
if not exists (select top 1 1 from Dictionary where Content = N'(Ban hành kèm theo Thông tư \r\nsố 28/2011/TT-BTC ngày 28/02/2011 của Bộ Tài chính)')insert into Dictionary(Content, Content2) Values (N'(Ban hành kèm theo Thông tư \r\nsố 28/2011/TT-BTC ngày 28/02/2011 của Bộ Tài chính)',N'(Issued with Decission \r\nNo: 28/2011/QĐ-BTC dated march 28/02/ 2011 by Ministry of Finance)')
if not exists (select top 1 1 from Dictionary where Content = N'Ghi chú:\r\n    -    [28] Số lỗ chuyển kỳ này bao gồm số lỗ những năm trước chuyển sang và số lỗ của các quý trước chuyển sang.\r\n    -    [31] Số thuế TNDN dự kiến được miễn, giảm, người nộp thuế tự xác định theo các điều kiện ưu đãi được hưởng;')insert into Dictionary(Content, Content2) Values (N'Ghi chú:\r\n    -    [28] Số lỗ chuyển kỳ này bao gồm số lỗ những năm trước chuyển sang và số lỗ của các quý trước chuyển sang.\r\n    -    [31] Số thuế TNDN dự kiến được miễn, giảm, người nộp thuế tự xác định theo các điều kiện ưu đãi được hưởng;',N'Note:\r\n    -    [28] The hole transfer period includes losses the previous year and the losses of the previous quarter turn.\r\n    -    [31] The expected income tax exemption or reduction, taxpayers themselves determine the conditions be entitled to enjoy;')
if not exists (select top 1 1 from Dictionary where Content = N'Ghi chú:\r\n    -    [30] Số thuế TNDN dự kiến được miễn, giảm, người nộp thuế tự xác định theo các điều kiện ưu đãi được hưởng.')insert into Dictionary(Content, Content2) Values (N'Ghi chú:\r\n    -    [30] Số thuế TNDN dự kiến được miễn, giảm, người nộp thuế tự xác định theo các điều kiện ưu đãi được hưởng.',N'Note:\r\n    -    [30] The expected income tax exemption or reduction, taxpayers themselves determine the conditions are entitled to preferential treatment.')
if not exists (select top 1 1 from Dictionary where Content = N'BẢNG KÊ HOÁ ĐƠN HÀNG HOÁ MUA VÀO \r\nCHỊU THUẾ TIÊU THỤ ĐẶC BIỆT')insert into Dictionary(Content, Content2) Values (N'BẢNG KÊ HOÁ ĐƠN HÀNG HOÁ MUA VÀO \r\nCHỊU THUẾ TIÊU THỤ ĐẶC BIỆT',N'List of invoices BUY GOODS \r\nTO BE SPECIAL CONSUMPTION TAX')
if not exists (select top 1 1 from Dictionary where Content = N'Tên nguyên liệu đã nộp thuế TTĐB')insert into Dictionary(Content, Content2) Values (N'Tên nguyên liệu đã nộp thuế TTĐB',N'Name of the material has the special consumption tax')
if not exists (select top 1 1 from Dictionary where Content = N'Số lượng đơn vị nguyên liệu  mua vào')insert into Dictionary(Content, Content2) Values (N'Số lượng đơn vị nguyên liệu  mua vào',N'The number of units purchased materials')
if not exists (select top 1 1 from Dictionary where Content = N'Thuế TTĐB trên 1 đơn vị nguyên liệu mua vào')insert into Dictionary(Content, Content2) Values (N'Thuế TTĐB trên 1 đơn vị nguyên liệu mua vào',N'1 unit excise tax on materials purchased')
if not exists (select top 1 1 from Dictionary where Content = N'Số thuế TTĐB đã khấu trừ các kỳ trước')insert into Dictionary(Content, Content2) Values (N'Số thuế TTĐB đã khấu trừ các kỳ trước',N'Special consumption tax withheld from prior periods')
if not exists (select top 1 1 from Dictionary where Content = N'Số thuế TTĐB chưa được khấu trừ đến kỳ này')insert into Dictionary(Content, Content2) Values (N'Số thuế TTĐB chưa được khấu trừ đến kỳ này',N'Special consumption tax may be deducted up to this period')
if not exists (select top 1 1 from Dictionary where Content = N'II. Bảng tính thuế TTĐB của nguyên liệu được khấu trừ:')insert into Dictionary(Content, Content2) Values (N'II. Bảng tính thuế TTĐB của nguyên liệu được khấu trừ:',N'II. Table excise taxation of raw materials is deducted:')
if not exists (select top 1 1 from Dictionary where Content = N'Mặt hàng\r\ntiêu thụ')insert into Dictionary(Content, Content2) Values (N'Mặt hàng\r\ntiêu thụ',N'Commodity\r\nconsumption')
if not exists (select top 1 1 from Dictionary where Content = N'Tên nguyên liệu chịu thuế TTĐB đầu vào')insert into Dictionary(Content, Content2) Values (N'Tên nguyên liệu chịu thuế TTĐB đầu vào',N'Name of the material excise tax input')

if not exists (select top 1 1 from Dictionary where Content = N'Lượng nguyên liệu trên 1 đơn vị sản phẩm tiêu thụ')
insert into Dictionary(Content, Content2) Values (N'Lượng nguyên liệu trên 1 đơn vị sản phẩm tiêu thụ',N'The amount of material on a unit of consumption')

if not exists (select top 1 1 from Dictionary where Content = N'Thuế TTĐB trên 1 đơn vị nguyên liệu đầu vào')
insert into Dictionary(Content, Content2) Values (N'Thuế TTĐB trên 1 đơn vị nguyên liệu đầu vào',N'Excise tax on an input unit')

if not exists (select top 1 1 from Dictionary where Content = N'Tổng thuế TTĐB\r\nđầu vào\r\nđược\r\nkhấu trừ\r\n')
insert into Dictionary(Content, Content2) Values (N'Tổng thuế TTĐB\r\nđầu vào\r\nđược\r\nkhấu trừ\r\n',N'The total input tax deductible excise currency')

if not exists (select top 1 1 from Dictionary where Content = N'BẢNG KÊ HOÁ ĐƠN HÀNG HOÁ, DỊCH VỤ BÁN RA CHỊU THUẾ TIÊU THỤ ĐẶC BIỆT')
insert into Dictionary(Content, Content2) Values (N'BẢNG KÊ HOÁ ĐƠN HÀNG HOÁ, DỊCH VỤ BÁN RA CHỊU THUẾ TIÊU THỤ ĐẶC BIỆT',N'List of invoices GOODS AND SERVICES SOLD OUT TO BE SPECIAL CONSUMPTION TAX')

if not exists (select top 1 1 from Dictionary where Content = N'Hoá đơn bán hàng')
insert into Dictionary(Content, Content2) Values (N'Hoá đơn bán hàng',N'Sales invoices')

if not exists (select top 1 1 from Dictionary where Content = N'Tên hàng hoá, dịch vụ')
insert into Dictionary(Content, Content2) Values (N'Tên hàng hoá, dịch vụ',N'Name of goods and services')

if not exists (select top 1 1 from Dictionary where Content = N'Doanh số bán có thuế TTĐB (không có thuế GTGT)')
insert into Dictionary(Content, Content2) Values (N'Doanh số bán có thuế TTĐB (không có thuế GTGT)',N'Sales of special consumption tax (not including VAT)')

if not exists (select top 1 1 from Dictionary where Content = N'TỜ KHAI THUẾ TIÊU THỤ ĐẶC BIỆT')
insert into Dictionary(Content, Content2) Values (N'TỜ KHAI THUẾ TIÊU THỤ ĐẶC BIỆT',N'DECLARATION OF SPECIAL CONSUMPTION TAX')

if not exists (select top 1 1 from Dictionary where Content = N'Mẫu số: 01/TTĐB\r\n(Ban hành kèm theo Thông tư \r\nsố 28/2011/TT-BTC ngày 28/02/2011 của Bộ Tài chính)')
insert into Dictionary(Content, Content2) Values (N'Mẫu số: 01/TTĐB\r\n(Ban hành kèm theo Thông tư \r\nsố 28/2011/TT-BTC ngày 28/02/2011 của Bộ Tài chính)',N'Form No.: 01/TTĐB\r\n(Issued with Decission \r\nNo: 28/2011/QĐ-BTC dated march 28/02/2011 by Ministry of Finance)')

if not exists (select top 1 1 from Dictionary where Content = N'Sản lượng tiêu thụ')
insert into Dictionary(Content, Content2) Values (N'Sản lượng tiêu thụ',N'Sales volume')

if not exists (select top 1 1 from Dictionary where Content = N'Doanh số bán \r\n(chưa có thuế GTGT)')
insert into Dictionary(Content, Content2) Values (N'Doanh số bán \r\n(chưa có thuế GTGT)',N'Sales\r\n(excluding VAT)')

declare @sysReportID int

-- In phiếu mua hàng có chi phí
select @sysReportID = sysReportID from sysReport where ReportName = N'In phiếu mua hàng có chi phí'

Update sysFormReport set ReportName2 = N'Coupons including cost'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'In phiếu mua hàng có chi phí'

Update sysFormReport set ReportName2 = N'Coupons including cost (Foreign currency)'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'In phiếu mua hàng có chi phí (Ngoại tệ)'

-- In phiếu nhập khẩu có chi phí
select @sysReportID = sysReportID from sysReport where ReportName = N'In phiếu nhập khẩu có chi phí'

Update sysFormReport set ReportName2 = N'Receipt of import goods including cost'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'In phiếu nhập khẩu có chi phí'

Update sysFormReport set ReportName2 = N'Receipt of import goods including cost (Foreign currency)'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'In phiếu nhập khẩu có chi phí (Ngoại tệ)'

-- Báo cáo chi tiết phân bổ công cụ dụng cụ
select @sysReportID = sysReportID from sysReport where ReportName = N'Báo cáo chi tiết phân bổ công cụ dụng cụ'

Update sysFormReport set ReportName2 = N'Detail report allocation of tools'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Báo cáo chi tiết phân bổ công cụ dụng cụ'

-- Báo cáo tồn kho
select @sysReportID = sysReportID from sysReport where ReportName = N'Báo cáo tồn kho'

Update sysFormReport set ReportName2 = N'Inventory Report'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Báo cáo tồn kho'

-- Thẻ Kho
select @sysReportID = sysReportID from sysReport where ReportName = N'Thẻ Kho'

Update sysFormReport set ReportName2 = N'Card stock'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Thẻ Kho'

-- Sổ quỹ tiền mặt (ngoại tệ)
select @sysReportID = sysReportID from sysReport where ReportName = N'Sổ quỹ tiền mặt'

Update sysFormReport set ReportName2 = N'Cash books (Foreign currency)'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Sổ quỹ tiền mặt (ngoại tệ)'

-- Bảng kê hàng xuất kho
select @sysReportID = sysReportID from sysReport where ReportName = N'Bảng kê hàng xuất kho'

Update sysFormReport set ReportName2 = N'Sheet of delivering inventory by warehouse'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Bảng kê hàng xuất kho theo kho'

-- Bảng giá trung bình tháng
select @sysReportID = sysReportID from sysReport where ReportName = N'Bảng giá trung bình tháng'

Update sysFormReport set ReportName2 = N'Average monthly price'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Bảng giá trung bình tháng'

-- Báo cáo doanh số bán hàng
select @sysReportID = sysReportID from sysReport where ReportName = N'Báo cáo doanh số bán hàng'

Update sysFormReport set ReportName2 = N'Details of sales revenue by customers'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Chi tiết doanh số bán hàng theo khách hàng'

-- Báo cáo lãi gộp hàng hóa
select @sysReportID = sysReportID from sysReport where ReportName = N'Báo cáo lãi gộp hàng hóa'

Update sysFormReport set ReportName2 = N'Details of gross profit by goods'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Chi tiết lãi gộp hàng hóa theo mặt hàng'

-- Doanh số bán hàng
select @sysReportID = sysReportID from sysReport where ReportName = N'Doanh số bán hàng'

Update sysFormReport set ReportName2 = N'Sales revenue'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Doanh số bán hàng'

-- Doanh thu và chi phí các kỳ trong năm
select @sysReportID = sysReportID from sysReport where ReportName = N'Doanh thu và chi phí các kỳ trong năm'

Update sysFormReport set ReportName2 = N'Revenues and costs of period'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Doanh thu và chi phí các kỳ'

-- Giấy báo có
select @sysReportID = sysReportID from sysReport where ReportName = N'Giấy báo có'

Update sysFormReport set ReportName2 = N'Credit notice'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Giấy báo có'

-- Báo cáo chi tiết chênh lệch giá vốn và giá bán
select @sysReportID = sysReportID from sysReport where ReportName = N'Báo cáo chi tiết chênh lệch giá vốn và giá bán'

Update sysFormReport set ReportName2 = N'Detail report about difference in cost and price'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Báo cáo chi tiết chênh lệch giá vốn và giá bán'

-- Báo cáo doanh số bán hàng theo nhân viên
select @sysReportID = sysReportID from sysReport where ReportName = N'Báo cáo doanh số bán hàng theo nhân viên'

Update sysFormReport set ReportName2 = N'Sales by employee'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Báo cáo doanh số bán hàng theo nhân viên'

-- Tờ khai thuế GTGT
select @sysReportID = sysReportID from sysReport where ReportName = N'Tờ khai thuế GTGT'

Update sysFormReport set ReportName2 = N'VAT Return'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Tờ khai thuế GTGT'

-- Tờ khai Thuế TNDN tạm tính 1A
select @sysReportID = sysReportID from sysReport where ReportName = N'Tờ khai Thuế TNDN tạm tính 1A'

Update sysFormReport set ReportName2 = N'Provisional income tax declaration form 01A/TNDN'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Tờ khai Thuế TNDN tạm tính 1A'

-- Tờ khai Thuế TNDN tạm tính 1B
select @sysReportID = sysReportID from sysReport where ReportName = N'Tờ khai Thuế TNDN tạm tính 1B'

Update sysFormReport set ReportName2 = N'Provisional income tax declaration form 01B/TNDN'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Tờ khai Thuế TNDN tạm tính 1B'

-- Tờ khai Quyết toán thuế TNDN 03 - TT60
select @sysReportID = sysReportID from sysReport where ReportName = N'Tờ khai Quyết toán thuế TNDN 03 - TT60'

Update sysFormReport set ReportName2 = N'Corporate income tax finalization declaration form 03/TNDN-TT60'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Tờ khai Quyết toán thuế TNDN 03 - TT60'

-- Tờ khai thuế TTDB
select @sysReportID = sysReportID from sysReport where ReportName = N'Tờ khai thuế TTDB'

Update sysFormReport set ReportName2 = N'Excise tax declaration'
where ReportName2 is null and sysReportID = @sysReportID and ReportName = N'Tờ khai thuế TTDB'

declare @sysTableID int
select @sysTableID = sysTableID from sysTable where TableName = 'MT36'

Update sysField set LabelName2 = N'Type of tax'
where sysTableID = @sysTableID and FieldName = 'MaLCTThue' and LabelName2 is null

Update sysField set LabelName2 = N'Rate of exchange'
where sysTableID = @sysTableID and FieldName = 'TyGia' and LabelName2 is null

select @sysTableID = sysTableID from sysTable where TableName = 'MVATTNDN'

Update sysField set LabelName2 = N'Reporting Form'
where sysTableID = @sysTableID and FieldName = 'MauBaoCao' and LabelName2 is null

Update sysField set LabelName2 = N'Select period'
where sysTableID = @sysTableID and FieldName = 'ChonKy' and LabelName2 is null

Update sysField set LabelName2 = N'From period'
where sysTableID = @sysTableID and FieldName = 'TuKy' and LabelName2 is null

Update sysField set LabelName2 = N'To period'
where sysTableID = @sysTableID and FieldName = 'DenKy' and LabelName2 is null

Update sysField set LabelName2 = N'Created Date'
where sysTableID = @sysTableID and FieldName = 'Ngay' and LabelName2 is null

Update sysField set LabelName2 = N'Document Name 6'
where sysTableID = @sysTableID and FieldName = 'TaiLieu6' and LabelName2 is null

Update sysField set LabelName2 = N'Extension'
where sysTableID = @sysTableID and FieldName = 'GiaHan' and LabelName2 is null

select @sysTableID = sysTableID from sysTable where TableName = 'MToKhaiTTDB'

Update sysField set LabelName2 = N'First print'
where sysTableID = @sysTableID and FieldName = 'InLanDau' and LabelName2 is null

Update sysField set LabelName2 = N'Sales (exclusive of VAT)'
where sysTableID = @sysTableID and FieldName = 'Ps' and LabelName2 is null

Update sysField set LabelName2 = N'Additional'
where sysTableID = @sysTableID and FieldName = 'SoLanIn' and LabelName2 is null

Update sysField set LabelName2 = N'Price excise tax'
where sysTableID = @sysTableID and FieldName = 'Ps1' and LabelName2 is null

Update sysField set LabelName2 = N'Tax rates'
where sysTableID = @sysTableID and FieldName = 'ThueSuat' and LabelName2 is null

Update sysField set LabelName2 = N'Excise tax is deducted'
where sysTableID = @sysTableID and FieldName = 'Ps2' and LabelName2 is null

Update sysField set LabelName2 = N'Excise tax payable'
where sysTableID = @sysTableID and FieldName = 'Ps3' and LabelName2 is null

Update sysMenu set MenuName2 = N'List the number of cars, motorcycle sales'
where MenuName = N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra' and MenuName2 is null

Update sysMenu set MenuName2 = N'Corporate income tax finalization declaration form 03/TNDN-TT60'
where MenuName = N'Tờ khai Quyết toán thuế TNDN 03 - TT60' and MenuName2 = N'Provisional VAT return 1B - Income of business'