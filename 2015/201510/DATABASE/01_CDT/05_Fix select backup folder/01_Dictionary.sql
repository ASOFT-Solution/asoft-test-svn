use [CDT]
GO

if not exists (select top 1 1 from Dictionary where Content = N'Vui lòng chọn thư mục lưu trữ!')
	insert into Dictionary(Content, Content2) Values (N'Vui lòng chọn thư mục lưu trữ!',N'Please select backup folder!')
	
if not exists (select top 1 1 from Dictionary where Content = N'Thư mục lưu trữ không tồn tại. Xin chọn lại thư mục khác!')
	insert into Dictionary(Content, Content2) Values (N'Thư mục lưu trữ không tồn tại. Xin chọn lại thư mục khác!',N'Backup folder does not exist! Please choose another folder!')
