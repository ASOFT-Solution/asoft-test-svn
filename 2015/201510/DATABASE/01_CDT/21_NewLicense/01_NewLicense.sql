use [CDT]

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'sysDatabase' AND col.name = 'ExpiredDate')
    ALTER TABLE [dbo].[sysDatabase] ADD [ExpiredDate] SmallDatetime NULL 
GO

if not exists (select top 1 1 from Dictionary where Content = N'Phần mềm đã hết thời hạn sử dụng!')
insert into Dictionary(Content, Content2) Values (N'Phần mềm đã hết thời hạn sử dụng!',N'License key has been expired!')

if not exists (select top 1 1 from Dictionary where Content = N'Phần mềm đã hết thời hạn sử dụng! Bạn có muốn đăng ký license khác?')
insert into Dictionary(Content, Content2) Values (N'Phần mềm đã hết thời hạn sử dụng! Bạn có muốn đăng ký license khác?',N'License key has been expired! Please register again?')

if not exists (select top 1 1 from Dictionary where Content = N'Phần mềm đã hết thời hạn dùng thử 45 ngày! Bạn có muốn đăng ký sử dụng?')
insert into Dictionary(Content, Content2) Values (N'Phần mềm đã hết thời hạn dùng thử 45 ngày! Bạn có muốn đăng ký sử dụng?',N'License expired 45 days! Do you want to register?')
