IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT32' AND col.name = 'SoCTTT')
    ALTER TABLE [dbo].[MT32] ADD [SoCTTT] [nvarchar](512) NULL

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT31' AND col.name = 'SoCTTT')
    ALTER TABLE [dbo].[MT31] ADD [SoCTTT] [nvarchar](512) NULL

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT24' AND col.name = 'SoCTTT')
    ALTER TABLE [dbo].[MT24] ADD [SoCTTT] [nvarchar](512) NULL