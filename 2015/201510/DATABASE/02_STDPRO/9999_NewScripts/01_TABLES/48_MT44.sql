if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT44'  and col.name = 'InHD')
BEGIN
	ALTER TABLE MT44 ADD  InHD [bit] NULL  CONSTRAINT [DF_MT44_INHD] DEFAULT ('0')
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT44'  and col.name = 'MaLoaiHD')
BEGIN
	ALTER TABLE MT44 ADD  MaLoaiHD [varchar](16) NULL
	ALTER TABLE [dbo].[MT44]  WITH NOCHECK ADD CONSTRAINT [FK_MT44_DMLHD] FOREIGN KEY([MaLoaiHD])
	REFERENCES [dbo].[DMLHD] ([MaLoaiHD])
END

IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_MT44_maloaihd]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
BEGIN
    ALTER TABLE [dbo].[MT44] WITH CHECK ADD CONSTRAINT [df_MT44_maloaihd] DEFAULT ('01') FOR [MaLoaiHD]
END
    
if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT44'  and col.name = 'NgayHD')
BEGIN
	ALTER TABLE MT44 ADD  NgayHD [smalldatetime] NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT44'  and col.name = 'SoHoaDon')
BEGIN
	ALTER TABLE MT44 ADD  SoHoaDon [nvarchar](512) NULL CONSTRAINT [df_MT44_SoHoaDon] DEFAULT ('')
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT44'  and col.name = 'Soseri')
BEGIN
	ALTER TABLE MT44 ADD  Soseri [nvarchar](512) NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT44'  and col.name = 'ThukhoN')
BEGIN
	ALTER TABLE MT44 ADD  ThukhoN [varchar](16) NULL
	ALTER TABLE [dbo].[MT44]  WITH NOCHECK ADD CONSTRAINT [FK_MT44_THUKHON] FOREIGN KEY([ThukhoN])
	REFERENCES [dbo].[DMKH] ([MaKH])
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT44'  and col.name = 'ThukhoX')
BEGIN
	ALTER TABLE MT44 ADD  ThukhoX [varchar](16) NULL
	ALTER TABLE [dbo].[MT44]  WITH NOCHECK ADD CONSTRAINT [FK_MT44_THUKHOX] FOREIGN KEY([ThukhoX])
	REFERENCES [dbo].[DMKH] ([MaKH])
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT44'  and col.name = 'SoDD')
BEGIN
	ALTER TABLE MT44 ADD  SoDD [nvarchar](512) NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT44'  and col.name = 'NgayDD')
BEGIN
	ALTER TABLE MT44 ADD  NgayDD [smalldatetime] NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT44'  and col.name = 'DoituongDD')
BEGIN
	ALTER TABLE MT44 ADD  DoituongDD [nvarchar](512) NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT44'  and col.name = 'DienGiaiDD')
BEGIN
	ALTER TABLE MT44 ADD  DienGiaiDD [nvarchar](512) NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT44'  and col.name = 'PTVanchuyen')
BEGIN
	ALTER TABLE MT44 ADD  PTVanchuyen [nvarchar](512) NULL
END