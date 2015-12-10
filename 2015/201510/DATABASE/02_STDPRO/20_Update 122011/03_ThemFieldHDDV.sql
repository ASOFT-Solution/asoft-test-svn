-- DT31
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT31'  and col.name = 'MaDVT')
BEGIN
	ALTER TABLE DT31 ADD  MaDVT [varchar](16) NULL 
	
	ALTER TABLE [dbo].[DT31]  WITH NOCHECK ADD  CONSTRAINT [fk_dt31_dmdvt] FOREIGN KEY([MaDVT])
	REFERENCES [dbo].[DMDVT] ([MaDVT])
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT31'  and col.name = 'SoLuong')
BEGIN
	ALTER TABLE DT31 ADD  SoLuong [decimal](28,6) NULL CONSTRAINT [df_dt31_SoLuong] DEFAULT (1)
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT31'  and col.name = 'GiaNT')
BEGIN
	ALTER TABLE DT31 ADD  GiaNT [decimal](28,6) NULL CONSTRAINT [df_dt31_giant] DEFAULT (0)
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT31'  and col.name = 'Gia')
BEGIN
	ALTER TABLE DT31 ADD  Gia [decimal](28,6) NULL CONSTRAINT [df_dt31_gia] DEFAULT (0)
END