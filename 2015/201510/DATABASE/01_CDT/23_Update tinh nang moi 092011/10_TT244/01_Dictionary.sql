USE [CDT]

if not exists (select top 1 1 from Dictionary where Content = N'Xóa tất cả bút toán')
insert into Dictionary(Content, Content2) Values (N'Xóa tất cả bút toán',N'Delete all posted')

