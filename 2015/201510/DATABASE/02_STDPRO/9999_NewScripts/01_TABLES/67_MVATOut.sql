if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MVATOut'  and col.name = 'QuyBKBR')
BEGIN
	ALTER TABLE MVATOut ADD  QuyBKBR [int] NULL
	ALTER TABLE [dbo].[MVATOut] ADD  CONSTRAINT [DF_MVATOut_QuyBKBR]  DEFAULT ('0') FOR [QuyBKBR]
END