IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT22' AND col.name = 'SoCTCT')
    ALTER TABLE [dbo].[MT22] ADD [SoCTCT] [nvarchar](512) NULL

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT23' AND col.name = 'SoCTCT')
    ALTER TABLE [dbo].[MT23] ADD [SoCTCT] [nvarchar](512) NULL
    
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT33' AND col.name = 'SoCTCT')
    ALTER TABLE [dbo].[MT33] ADD [SoCTCT] [nvarchar](512) NULL
    
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT21' AND col.name = 'SoCTCT')
    ALTER TABLE [dbo].[MT21] ADD [SoCTCT] [nvarchar](512) NULL
    
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT25' AND col.name = 'SoCTCT')
    ALTER TABLE [dbo].[MT25] ADD [SoCTCT] [nvarchar](512) NULL