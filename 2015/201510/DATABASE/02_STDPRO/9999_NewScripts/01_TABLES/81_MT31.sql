If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT31'  and col.name = 'FormID')
BEGIN
	ALTER TABLE MT31 ADD  FormID [varchar](16) NULL 
	ALTER TABLE [dbo].[MT31]  WITH NOCHECK ADD CONSTRAINT [fk_MT31_DMMauSoHD] FOREIGN KEY([FormID])
	REFERENCES [dbo].[DMMauSoHD] ([FormID])
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT31'  and col.name = 'FormSymbol')
BEGIN
	ALTER TABLE MT31 ADD  FormSymbol [nvarchar](512) NULL 
END