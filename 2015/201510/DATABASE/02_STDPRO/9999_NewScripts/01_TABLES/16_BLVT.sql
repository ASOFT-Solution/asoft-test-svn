if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'BLVT'  and col.name = 'SoLuongQD')
BEGIN
	ALTER TABLE BLVT ADD  SoLuongQD [decimal](28,6) NULL CONSTRAINT [DF_BLVT_SoLuongQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'BLVT'  and col.name = 'SoLuong_xQD')
BEGIN
	ALTER TABLE BLVT ADD  SoLuong_xQD [decimal](28,6) NULL CONSTRAINT [DF_BLVT_SoLuong_xQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'BLVT'  and col.name = 'DongiaQDNT')
BEGIN
	ALTER TABLE BLVT ADD  DongiaQDNT [decimal](28,6) NULL CONSTRAINT [DF_BLVT_DongiaQDNT] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'BLVT'  and col.name = 'DongiaQD')
BEGIN
	ALTER TABLE BLVT ADD  DongiaQD [decimal](28,6) NULL CONSTRAINT [DF_BLVT_DongiaQD] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'BLVT'  and col.name = 'DVTQDID')
BEGIN
	ALTER TABLE BLVT ADD  [DVTQDID] [uniqueidentifier] NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'BLVT'  and col.name = 'MaDVT')
BEGIN
	ALTER TABLE BLVT ADD  MaDVT [varchar](16) NULL 
	ALTER TABLE [dbo].[BLVT]  WITH NOCHECK ADD CONSTRAINT [fk_blvt_dmdvt] FOREIGN KEY([MaDVT])
	REFERENCES [dbo].[DMDVT] ([MaDVT])
END