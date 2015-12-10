if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MVATIn'  and col.name = 'QuyBKMV')
BEGIN
	ALTER TABLE MVATIn ADD  QuyBKMV [int] NULL
	ALTER TABLE [dbo].[MVATIn] ADD  CONSTRAINT [DF_MVATIn_QuyBKMV]  DEFAULT ('0') FOR [QuyBKMV]
END