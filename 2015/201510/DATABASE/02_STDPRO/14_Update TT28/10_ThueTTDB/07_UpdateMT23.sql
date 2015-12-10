IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT23' AND col.name = 'ToTalTienTTDB')
BEGIN
    ALTER TABLE [dbo].[MT23] ADD [ToTalTienTTDB] [decimal](20, 6) NULL
    ALTER TABLE [dbo].[MT23] ADD  CONSTRAINT [DF_MT23_ToTalTienTTDB]  DEFAULT ('0') FOR [ToTalTienTTDB]
END

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT23' AND col.name = 'ToTalTienTTDBNT')
BEGIN
    ALTER TABLE [dbo].[MT23] ADD [ToTalTienTTDBNT] [decimal](20, 6) NULL
    ALTER TABLE [dbo].[MT23] ADD  CONSTRAINT [DF_MT23_ToTalTienTTDBNT]  DEFAULT ('0') FOR [ToTalTienTTDBNT]
END

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT23' AND col.name = 'MaNhomTTDB')
BEGIN
    ALTER TABLE [dbo].[MT23] ADD [MaNhomTTDB] [varchar](16) NULL
    
    ALTER TABLE [dbo].[MT23]  WITH CHECK ADD  CONSTRAINT [FK_MT23_DMThueTTDB15] FOREIGN KEY([MaNhomTTDB])
	REFERENCES [dbo].[DMThueTTDB] ([MaNhomTTDB])

	ALTER TABLE [dbo].[MT23] CHECK CONSTRAINT [FK_MT23_DMThueTTDB15]

END

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT23' AND col.name = 'TkTTTDB')
BEGIN
    ALTER TABLE [dbo].[MT23] ADD [TkTTTDB] [varchar](16) NULL
    
	ALTER TABLE [dbo].[MT23]  WITH NOCHECK ADD  CONSTRAINT [fk_MT23_TkTTTDB] FOREIGN KEY([TkTTTDB])
	REFERENCES [dbo].[DMTK] ([TK])

	ALTER TABLE [dbo].[MT23] CHECK CONSTRAINT [fk_MT23_TkTTTDB]
END