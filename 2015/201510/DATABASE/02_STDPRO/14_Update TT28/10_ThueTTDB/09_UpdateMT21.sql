IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT21' AND col.name = 'ToTalTienTTDB')
BEGIN
    ALTER TABLE [dbo].[MT21] ADD [ToTalTienTTDB] [decimal](20, 6) NULL
    ALTER TABLE [dbo].[MT21] ADD  CONSTRAINT [DF_MT21_ToTalTienTTDB]  DEFAULT ('0') FOR [ToTalTienTTDB]
END

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT21' AND col.name = 'ToTalTienTTDBNT')
BEGIN
    ALTER TABLE [dbo].[MT21] ADD [ToTalTienTTDBNT] [decimal](20, 6) NULL
    ALTER TABLE [dbo].[MT21] ADD  CONSTRAINT [DF_MT21_ToTalTienTTDBNT]  DEFAULT ('0') FOR [ToTalTienTTDBNT]
END

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT21' AND col.name = 'MaNhomTTDB')
BEGIN
    ALTER TABLE [dbo].[MT21] ADD [MaNhomTTDB] [varchar](16) NULL
    
    ALTER TABLE [dbo].[MT21]  WITH CHECK ADD  CONSTRAINT [FK_MT21_DMThueTTDB15] FOREIGN KEY([MaNhomTTDB])
	REFERENCES [dbo].[DMThueTTDB] ([MaNhomTTDB])

	ALTER TABLE [dbo].[MT21] CHECK CONSTRAINT [FK_MT21_DMThueTTDB15]

END

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT21' AND col.name = 'TkTTTDB')
BEGIN
    ALTER TABLE [dbo].[MT21] ADD [TkTTTDB] [varchar](16) NULL
    
	ALTER TABLE [dbo].[MT21]  WITH NOCHECK ADD  CONSTRAINT [fk_MT21_TkTTTDB] FOREIGN KEY([TkTTTDB])
	REFERENCES [dbo].[DMTK] ([TK])

	ALTER TABLE [dbo].[MT21] CHECK CONSTRAINT [fk_MT21_TkTTTDB]
END