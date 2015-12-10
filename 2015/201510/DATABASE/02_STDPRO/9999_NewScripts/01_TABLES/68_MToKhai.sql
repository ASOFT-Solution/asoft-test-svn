if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'QuyToKhai')
BEGIN
	ALTER TABLE MToKhai ADD  QuyToKhai [int] NULL
	ALTER TABLE [dbo].[MToKhai] ADD  CONSTRAINT [DF_MToKhai_QuyToKhai]  DEFAULT ('0') FOR [QuyToKhai]
END