-- Add column Saleman

-- MT31
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT31'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE MT31 ADD  Saleman [varchar](16) NULL
END

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_MT31_DMKH31]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[MT31]  WITH CHECK ADD  CONSTRAINT [FK_MT31_DMKH31] FOREIGN KEY([Saleman]) REFERENCES [dbo].[DMKH] ([MaKH])

-- MT32
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT32'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE MT32 ADD  Saleman [varchar](16) NULL
END

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_MT32_DMKH31]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[MT32]  WITH CHECK ADD  CONSTRAINT [FK_MT32_DMKH31] FOREIGN KEY([Saleman]) REFERENCES [dbo].[DMKH] ([MaKH])

-- MT33
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT33'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE MT33 ADD  Saleman [varchar](16) NULL
END

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_MT33_DMKH31]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[MT33]  WITH CHECK ADD  CONSTRAINT [FK_MT33_DMKH31] FOREIGN KEY([Saleman]) REFERENCES [dbo].[DMKH] ([MaKH])
	
-- MT43
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT43'  and col.name = 'Saleman')
BEGIN
	ALTER TABLE MT43 ADD  Saleman [varchar](16) NULL
END

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_MT43_DMKH14]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
	ALTER TABLE [dbo].[MT43]  WITH CHECK ADD  CONSTRAINT [FK_MT43_DMKH14] FOREIGN KEY([Saleman]) REFERENCES [dbo].[DMKH] ([MaKH])