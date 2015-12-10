-- VATIn
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'VATIn'  and col.name = 'FormID')
BEGIN
	ALTER TABLE VATIn ADD  FormID [varchar](16) NULL 
	ALTER TABLE [dbo].[VATIn]  WITH NOCHECK ADD CONSTRAINT [fk_VATIn_DMMauSoHD] FOREIGN KEY([FormID])
	REFERENCES [dbo].[DMMauSoHD] ([FormID])
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'VATIn'  and col.name = 'FormSymbol')
BEGIN
	ALTER TABLE VATIn ADD  FormSymbol [nvarchar](512) NULL 
END