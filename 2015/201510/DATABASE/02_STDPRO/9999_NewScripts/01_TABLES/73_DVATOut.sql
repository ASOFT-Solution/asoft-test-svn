If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DVATOut'  and col.name = 'FormID')
BEGIN
	ALTER TABLE DVATOut ADD  FormID [varchar](16) NULL 
	ALTER TABLE [dbo].[DVATOut]  WITH NOCHECK ADD CONSTRAINT [fk_DVATOut_DMMauSoHD] FOREIGN KEY([FormID])
	REFERENCES [dbo].[DMMauSoHD] ([FormID])
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DVATOut'  and col.name = 'FormSymbol')
BEGIN
	ALTER TABLE DVATOut ADD  FormSymbol [nvarchar](512) NULL 
END