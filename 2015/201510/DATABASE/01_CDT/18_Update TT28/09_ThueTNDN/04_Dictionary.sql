declare
@content nvarchar(400),
@content2 nvarchar(400)

-- Thông  báo
set @content = N'Bạn có thật sự muốn xóa tờ khai không?' set @content2 = N'Do you want to delete declarations?' delete Dictionary where Content = @content
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Tờ khai đã xóa thành công.' set @content2 = N'Delete successful.' delete Dictionary where Content = @content
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Không thể xóa tờ khai.' set @content2 = N'Delete failed.' delete Dictionary where Content = @content
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Đã tồn tại tờ khai lập cho quý này.' set @content2 = N'Existing declarations made for this quarter.'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Đã tồn tại tờ khai lập cho năm này.' set @content2 = N'Existing declarations made for this year.'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Đã tồn tại tờ khai lập cho kỳ này.' set @content2 = N'Existing declarations made for this period.'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Vui lòng nhập từ kỳ nhỏ hơn hoặc bằng đến kỳ.' set @content2 = N'From period be equal to or less than To period.'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Vui lòng nhập ngày lập tờ khai.' set @content2 = N'Please enter the date of declaration.'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Vui lòng nhập số lần in.' set @content2 = N'Please enter the number of printing times.'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Tạo tờ khai thuế GTGT thành công.' set @content2 = N'VAT declarations is created successfully.'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Cập nhật tờ khai thuế GTGT thành công.' set @content2 = N'VAT declarations is updated successfully.'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Không được nhập số âm.' set @content2 = N'Negative value is invalid.'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Lỗ từ hoạt động SXKD [27] phải nhỏ hơn hoặc bằng thu nhập từ hoạt động SXKD [B24].' set @content2 = N'Loss from business and production [B27] must be less than or equal to income from production and business activities [B24].'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Lỗ từ chuyển quyền sử dụng đất, chuyển quyền thuê đất [28] phải nhỏ hơn hoặc bằng thu nhập từ chuyển quyền sử dụng đất, chuyển quyền thuê đất [B25].' set @content2 = N'Loss from transfer of land use, land lease [B28] must be less than or equal to income from land use, land lease [B25].'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Thuế thu nhập doanh nghiệp phát sinh phải nộp trong kỳ tính thuế phải lớn hơn hoặc bằng 0.' set @content2 = N'Corporate income tax payable arising in the tax period must be greater than or equal to 0.'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

-- Màn hình danh sách tờ khai
set @content = N'Danh sách chứng từ khai thuế TNDN' set @content2 = N'List vouchers corporate income tax'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Mẫu số báo cáo' set @content2 = N'Template'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Năm' set @content2 = N'Year' delete Dictionary where Content = @content
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Quý' set @content2 = N'Quarter'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Từ kỳ' set @content2 = N'From period'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Đến kỳ' set @content2 = N'To period'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Diễn giải' set @content2 = N'Description'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

-- Tạo tờ khai
set @content = N'Tạo tờ khai' set @content2 = N'Create tax declarations'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Mẫu báo cáo' set @content2 = N'List'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Ngày lập tờ khai' set @content2 = N'Create date' delete Dictionary where Content = @content
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Doanh nghiệp có cơ sở hạch toán phụ thuộc' set @content2 = N'Enterprise-based accounting depends'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Theo năm' set @content2 = N'By year'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Theo kỳ' set @content2 = N'By period'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Tên tài liệu 1' set @content2 = N'Attach document 1'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Tên tài liệu 2' set @content2 = N'Attach document 2'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Tên tài liệu 3' set @content2 = N'Attach document 3'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Tên tài liệu 4' set @content2 = N'Attach document 4'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Tên tài liệu 5' set @content2 = N'Attach document 5'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Tên tài liệu 6' set @content2 = N'Attach document 6'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Gia hạn nộp theo NĐ 30/NQ-CP' set @content2 = N'Extension of payment in accordance Decree 30/NQ-CP'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Gia hạn nộp theo QĐ 20/2011/QĐ-TTg' set @content2 = N'Extension of payment under Decision 20/2011/QD-TTg'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

-- Tờ khai
set @content = N'Tạo mới tờ khai thuế TNDN tạm tính mẫu 01A/TNDN' set @content2 = N'Create provisional income tax declaration form 01A/TNDN'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Tạo mới tờ khai thuế TNDN tạm tính mẫu 01B/TNDN' set @content2 = N'Create provisional income tax declaration form 01B/TNDN'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)

set @content = N'Tạo mới tờ khai quyết toán thuế TNDN mẫu 03/TNDN-TT60' set @content2 = N'Create corporate income tax finalization declaration form 03/TNDN-TT60'
if not exists (select top 1 1 from Dictionary where Content = @content) insert into Dictionary(Content, Content2) Values (@content, @content2)
