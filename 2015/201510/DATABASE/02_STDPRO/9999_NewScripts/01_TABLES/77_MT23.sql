If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT23'  and col.name = 'FormID')
BEGIN
	ALTER TABLE MT23 ADD  FormID [varchar](16) NULL 
	ALTER TABLE [dbo].[MT23]  WITH NOCHECK ADD CONSTRAINT [fk_MT23_DMMauSoHD] FOREIGN KEY([FormID])
	REFERENCES [dbo].[DMMauSoHD] ([FormID])
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT23'  and col.name = 'FormSymbol')
BEGIN
	ALTER TABLE MT23 ADD  FormSymbol [nvarchar](512) NULL 
END