USE [CDT]

if not exists (select top 1 1 from Dictionary where Content = N'Tiền Việt Nam')
	insert into Dictionary(Content, Content2) Values (N'Tiền Việt Nam',N'VietNamese currency')
	
if not exists (select top 1 1 from Dictionary where Content = N'Tiền ngoại tệ')
	insert into Dictionary(Content, Content2) Values (N'Tiền ngoại tệ',N'Foreign currency')