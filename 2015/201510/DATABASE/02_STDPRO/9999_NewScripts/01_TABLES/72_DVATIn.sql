If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DVATIn'  and col.name = 'FormID')
BEGIN
	ALTER TABLE DVATIn ADD  FormID [varchar](16) NULL 
	ALTER TABLE [dbo].[DVATIn]  WITH NOCHECK ADD CONSTRAINT [fk_DVATIn_DMMauSoHD] FOREIGN KEY([FormID])
	REFERENCES [dbo].[DMMauSoHD] ([FormID])
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DVATIn'  and col.name = 'FormSymbol')
BEGIN
	ALTER TABLE DVATIn ADD  FormSymbol [nvarchar](512) NULL 
END