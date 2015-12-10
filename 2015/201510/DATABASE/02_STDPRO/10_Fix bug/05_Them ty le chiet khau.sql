If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT32'  and col.name = 'PCK')
BEGIN
	ALTER TABLE DT32 ADD  PCK [decimal](20, 6) NULL
	ALTER TABLE [dbo].[DT32] ADD  CONSTRAINT [DF_DT32_PSCK]  DEFAULT ('0') FOR [PCK]
END