if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT21'  and col.name = 'TienCKNT')
BEGIN
	Update [DT21] set [TienCKNT] = 0 where [TienCKNT] is null
	ALTER TABLE [dbo].[DT21] ALTER COLUMN [TienCKNT] [decimal](28,6) NOT NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT21'  and col.name = 'MaVT')
BEGIN
	ALTER TABLE DT21 ADD  MaVT [varchar](16) NULL 
	ALTER TABLE [dbo].[DT21]  WITH NOCHECK ADD CONSTRAINT [fk_dt21_dmvt] FOREIGN KEY([MaVT])
	REFERENCES [dbo].[DMVT] ([MaVT])
END