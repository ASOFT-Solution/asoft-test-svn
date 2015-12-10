If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT33'  and col.name = 'FormID')
BEGIN
	ALTER TABLE MT33 ADD  FormID [varchar](16) NULL 
	ALTER TABLE [dbo].[MT33]  WITH NOCHECK ADD CONSTRAINT [fk_MT33_DMMauSoHD] FOREIGN KEY([FormID])
	REFERENCES [dbo].[DMMauSoHD] ([FormID])
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT33'  and col.name = 'FormSymbol')
BEGIN
	ALTER TABLE MT33 ADD  FormSymbol [nvarchar](512) NULL 
END