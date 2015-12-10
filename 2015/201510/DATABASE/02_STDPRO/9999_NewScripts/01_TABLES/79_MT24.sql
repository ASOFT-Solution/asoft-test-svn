If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT24'  and col.name = 'FormID')
BEGIN
	ALTER TABLE MT24 ADD  FormID [varchar](16) NULL 
	ALTER TABLE [dbo].[MT24]  WITH NOCHECK ADD CONSTRAINT [fk_MT24_DMMauSoHD] FOREIGN KEY([FormID])
	REFERENCES [dbo].[DMMauSoHD] ([FormID])
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT24'  and col.name = 'FormSymbol')
BEGIN
	ALTER TABLE MT24 ADD  FormSymbol [nvarchar](512) NULL 
END