USE [CDT]
declare @content nvarchar(512),
		@content2 nvarchar(512)

set @content = N'Tiêu đề của bản sao'
set @content2 = N'The title of the table so'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Đơn giá quy đổi'
set @content2 = N'Converted unit price'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
	
set @content = N'Số lượng quy đổi'
set @content2 = N'Converted quantity'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Đơn giá quy đổi nguyên tệ'
set @content2 = N'Converted original unit price'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'&2. Thông tin mặc định hóa đơn tự in'
set @content2 = N'&2. Default config for invoices'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)	

set @content = N'Thông tin mặc định hóa đơn tự in'
set @content2 = N'Default config for invoices'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)	
	
set @content = N'&3. Hóa đơn tự in'
set @content2 = N'&3. Invoices'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)	
	
set @content = N'Hóa đơn tự in'
set @content2 = N'Invoices'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)	

set @content = N'&4. Định dạng số'
set @content2 = N'&4. Number format'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)	

set @content = N'(*) Chỉ tiêu này chỉ áp dụng đối với công ty cố phẩn.'
set @content2 = N'(*) This criterion applies only to joint stock companies.'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)		

--Báo cáo Sổ nhật ký chứng từ 02---
set @content = N'Nhật ký chứng từ số 02'
set @content2 = N'Diary vouchers No. 02'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Ghi có tài khoản:'
set @content2 = N'Credited to account:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Đã ghi Sổ Cái ngày..... tháng ..... năm '
set @content2 = N'Ledger scored on ..... months ..... year '
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Tên TK'
set @content2 = N'Account Name'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Tên TK'
set @content2 = N'Account Name'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Tên máy chủ:'
set @content2 = N'Server:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Tên số liệu:'
set @content2 = N'Enterprise:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Người sử dụng:'
set @content2 = N'User:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Quyết định:'
set @content2 = N'Decision:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Phiên bản:'
set @content2 = N'Version:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Tính lại đơn giá'
set @content2 = N'Recalculate unit price'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'- Nhấn F9 để tính lại đơn giá của dòng hiện tại.\n- Nhấn Ctrl+F9 để tính lại đơn giá của tất cả các dòng.'
set @content2 = N'- Press F9 to recalculate unit price of focus row.\n- Press Ctrl+F9 to recalculate unit price of all rows.'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Mã tài sản {0} đã được sử dụng. Bạn không được phép chỉnh sửa!'
set @content2 = N'Property ID {0} has been used. You are not allowed to edit!'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Bạn phải chọn ít nhất một Vật tư!'
set @content2 = N'You must select at least one supplies!'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Lấy định mức nguyên vật liệu'
set @content2 = N'Get the raw materials'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Sản phẩm'
set @content2 = N'Product Name'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Chọn/Bỏ'
set @content2 = N'Check/Uncheck'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Tên nguyên liệu'
set @content2 = N'Material name'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Mã đơn vị tính'
set @content2 = N'Unit Code'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Số lượng'
set @content2 = N'Quantity'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Tài khoản có'
set @content2 = N'Credit Account'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Tài khoản {0} đã được sử dụng. Bạn không được phép thêm tài khoản con!'
set @content2 = N'Account {0} has been used. You are not allowed to add a child account!'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Bảng cân đối chưa cân'
set @content2 = N'Balance sheet is not balanced'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Vật tư đích danh này đã được nhập trong danh sách. Vui lòng kiểm tra lại!'
set @content2 = N'Materials by their names have been entered in the list. Please check again!'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Trùng Số hóa đơn và Ký hiệu hóa đơn'
set @content2 = N'Invoice number and Seri number existed'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Số dư tài khoản này được nhập bên số dư công trình. Bạn không được chỉnh sửa!'
set @content2 = N'The balance of this account is entered the project balance. You may not edit!'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Thông tin giá vốn'
set @content2 = N'Cost price information'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Ngày, tháng ghi sổ'
set @content2 = N'Create date'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Đã ghi sổ cái'
set @content2 = N'Recorded ledger'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Số hiệu TK đối ứng'
set @content2 = N'Account number'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)	
	
set @content = N'(Ban hành theo QĐ số 48/2006/QĐ-BTC Ngày 14/09/2006 của Bộ trưởng BTC)'
set @content2 = N'(Issued with Decission No 48/2006/QĐ-BTC dated march 14/09/2006 by Ministry of Finance)'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)	
		
set @content = N'Ban hành theo QĐ số 48/2006/QĐ-BTC ngày 14/9/2006 và Thông tư số 138/2011/TT-BTC ngày 4/10/2011 của Bộ Tài chính'
set @content2 = N'Issued with Decission No 48/2006/QĐ-BTC dated march 14/09/2006 and 138/2011/TT-BTC date  march 4/10/2011 by Ministry of Finance'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)	
	
set @content = N'Mẫu số B01-DNN'
set @content2 = N'Form no B01-DNN'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)		

set @content = N'Mẫu số B 02- DNN'
set @content2 = N'Form no B 02- DNN'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)		
	
set @content = N'Ghi chú: (*) Chỉ tiêu này chỉ áp dụng đối với công ty cố phẩn.'
set @content2 = N'Note: (*) This indicator only applies to joint stock companies.'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)			

set @content = N'Mẫu số B 03- DNN'
set @content2 = N'Form no B 03- DNN'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)		

set @content = N'Mẫu số: S07-DN'
set @content2 = N'Form no S07-DN'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)		

set @content = N'Mẫu số S06-DNN'
set @content2 = N'Form no S06-DNN'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)		

set @content = N'Mẫu số s02c1-DN'
set @content2 = N'Form no s02c1-DN'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)			

set @content = N'Mẫu số S03b-DN'
set @content2 = N'Form no S03b-DN'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)				

set @content = N'Mẫu số S03b-DNN'
set @content2 = N'Form no S03b-DNN'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)					

set @content = N'Mẫu số F01-DNN'
set @content2 = N'Form no F01-DNN'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)					
	
set @content = N'Mẫu số S04-DNN'
set @content2 = N'Form no S04-DNN'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)						

set @content = N'Chứng từ kết chuyển'
set @content2 = N'Transfer voucher'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)						

set @content = N'- Tổng số tiền ( viết bằng số )'
set @content2 = N'- Amount (in number)'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Hạn nợ\r\n(Hạn thanh toán)'
set @content2 = N'Term of debt'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Tuổi nợ\r\n(Số ngày quá hạn)'
set @content2 = N'Age of Debt'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Cộng (Theo đối tượng)'
set @content2 = N'Total (By object)'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)	

set @content = N'Ngân hàng:'
set @content2 = N'Bank Name:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)	
	
set @content = N'Chi nhánh:'
set @content2 = N'Bank Branch Name:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Giấy báo có'
set @content2 = N'Credit note receipt'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Ngày:'
set @content2 = N'Date:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Mã GDV:'
set @content2 = N'Trader code:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Mã KH:'
set @content2 = N'Customer code:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Số GD:'
set @content2 = N'Trade No.:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Kính gởi:'
set @content2 = N'Dear:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Hôm nay, chúng tôi xin thông báo đã ghi Có tài khoản của quý khách hàng với nội dung như sau:'
set @content2 = N'Today, we are pleased to announced that it has credited your account with the following contents:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Số tài khoản ghi có:'
set @content2 = N'Credit Account No.:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Số tiền bằng số:'
set @content2 = N'Amount (in number):'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Số tiền bằng chữ:'
set @content2 = N'Amount (in word)'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Nội dung:'
set @content2 = N'Description:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Giao dịch viên'
set @content2 = N'Trader'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Kiểm soát'
set @content2 = N'Controler'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Giấy báo nợ'
set @content2 = N'Debit note receipt'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Hôm nay, chúng tôi xin thông báo đã ghi Nợ tài khoản của quý khách hàng với nội dung như sau:'
set @content2 = N'Today, we are pleased to announced that it has debited your account with the following contents:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Số tài khoản ghi Nợ:'
set @content2 = N'Debit Account No.:'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Chưa chọn phiếu điều chuyển kho!'
set @content2 = N'You have not chosen any movement voucher!'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Nghiệp vụ đã xuất hóa đơn, bạn không được phép chỉnh sửa!'
set @content2 = N'This invoice has been exported. You can not change!'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Vật tư không đủ số lượng'
set @content2 = N'The materials are not enough quantity'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Vật tư không đủ số lượng hoặc không có tồn kho'
set @content2 = N'The materials are not enough quantity or do not exist in warehouse'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Không có tồn kho'
set @content2 = N'The materials do not exist in warehouse'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)
	
set @content = N'Chọn chính sách giá bán theo khách hàng'
set @content2 = N'Select the price policy according to customer'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)

set @content = N'Chưa chọn khách hàng!'
set @content2 = N'You have not chosen any customer!'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)	
	
set @content = N'Phải chọn ít nhất một vật tư!'
set @content2 = N'You must select at least one supplies!'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)	

set @content = N'Vui lòng kiểm tra lại số liệu!'
set @content2 = N'Data is invalid!'
if not exists (select top 1 1 from [Dictionary] where [Content] = @content )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (@content, @content2)		
	