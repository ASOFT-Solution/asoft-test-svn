-- VATOut
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'VATOut'  and col.name = 'FormID')
BEGIN
	ALTER TABLE VATOut ADD  FormID [varchar](16) NULL 
	ALTER TABLE [dbo].[VATOut]  WITH NOCHECK ADD CONSTRAINT [fk_VATOut_DMMauSoHD] FOREIGN KEY([FormID])
	REFERENCES [dbo].[DMMauSoHD] ([FormID])
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'VATOut'  and col.name = 'FormSymbol')
BEGIN
	ALTER TABLE VATOut ADD  FormSymbol [nvarchar](512) NULL 
END