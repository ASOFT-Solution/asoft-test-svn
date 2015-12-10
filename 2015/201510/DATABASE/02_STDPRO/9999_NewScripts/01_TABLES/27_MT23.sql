if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT23'  and col.name = 'TotalCKNT')
BEGIN
	Update [MT23] set [TotalCKNT] = 0 where [TotalCKNT] is null
	ALTER TABLE [dbo].[MT23] ALTER COLUMN [TotalCKNT] [decimal](28,6) NOT NULL
END

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT23'  and col.name = 'TotalGNKNT')
BEGIN
	Update [MT23] set [TotalGNKNT] = 0 where [TotalGNKNT] is null
	ALTER TABLE [dbo].[MT23] ALTER COLUMN [TotalGNKNT] [decimal](28,6) NOT NULL
END

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT23'  and col.name = 'ToTalTienTTDBNT')
BEGIN
	Update [MT23] set [ToTalTienTTDBNT] = 0 where [ToTalTienTTDBNT] is null
	ALTER TABLE [dbo].[MT23] ALTER COLUMN [ToTalTienTTDBNT] [decimal](28,6) NOT NULL
END

-- Bỏ column MaNhomTTDB do không còn dùng nữa, nếu giữ column này sẽ bị lỗi không load được giá trị trong tab thuế TTDB

IF EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[FK_MT23_DMThueTTDB15]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE [dbo].[MT23] drop constraint FK_MT23_DMThueTTDB15
END

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT23'  and col.name = 'MaNhomTTDB')
BEGIN
	ALTER TABLE [dbo].[MT23] Drop COLUMN [MaNhomTTDB]
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT23'  and col.name = 'NgayBatDauTT')
BEGIN
	ALTER TABLE MT23 ADD  [NgayBatDauTT] smalldatetime NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT23'  and col.name = 'SoCTG')
BEGIN
	ALTER TABLE MT23 ADD  SoCTG nvarchar(512) NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT23'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE MT23 ADD  Saleman [varchar](16) NULL 
	ALTER TABLE [dbo].[MT23]  WITH NOCHECK ADD CONSTRAINT [fk_mt23_dmkh2] FOREIGN KEY([Saleman])
	REFERENCES [dbo].[DMKH] ([MaKH])
END