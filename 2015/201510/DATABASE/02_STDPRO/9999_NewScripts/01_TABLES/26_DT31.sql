if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT31'  and col.name = 'GiaNT')
BEGIN
	Update [DT31] set [GiaNT] = 0 where [GiaNT] is null
	ALTER TABLE [dbo].[DT31] ALTER COLUMN [GiaNT] [decimal](28,6) NOT NULL
END

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT31'  and col.name = 'TienCKNT')
BEGIN
	Update [DT31] set [TienCKNT] = 0 where [TienCKNT] is null
	ALTER TABLE [dbo].[DT31] ALTER COLUMN [TienCKNT] [decimal](28,6) NOT NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT31'  and col.name = 'MaVT')
BEGIN
	ALTER TABLE DT31 ADD  MaVT [varchar](16) NULL 
	ALTER TABLE [dbo].[DT31]  WITH NOCHECK ADD CONSTRAINT [fk_dt31_dmvt] FOREIGN KEY([MaVT])
	REFERENCES [dbo].[DMVT] ([MaVT])
END