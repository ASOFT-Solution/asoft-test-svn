use [CDT]

if not exists (select top 1 1 from Dictionary where Content = N'Hủy đăng ký sử dụng')
	insert into Dictionary(Content, Content2) Values (N'Hủy đăng ký sử dụng',N'Remove registration')
	
if not exists (select top 1 1 from Dictionary where Content = N'Hủy đăng ký thành công! Hệ thống sẽ tự khởi động lại để cập nhật thông tin')
	insert into Dictionary(Content, Content2) Values (N'Hủy đăng ký thành công! Hệ thống sẽ tự khởi động lại để cập nhật thông tin',N'Remove registration successfully! The program will restart to update information')

if not exists (select top 1 1 from Dictionary where Content = N'Bạn có muốn hủy đăng ký không?')
	insert into Dictionary(Content, Content2) Values (N'Bạn có muốn hủy đăng ký không?',N'Are you sure you want to remove registration')
