-- DT21
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT21' AND col.name = 'TyleCK')
    ALTER TABLE [dbo].[DT21] ADD [TyleCK] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt21_tyleck]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT21] WITH CHECK ADD CONSTRAINT [df_dt21_tyleck] DEFAULT (0) FOR [TyleCK]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT21' AND col.name = 'TienCKNT')
    ALTER TABLE [dbo].[DT21] ADD [TienCKNT] DECIMAL(20, 6) NULL
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt21_tiencknt]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT21] WITH CHECK ADD CONSTRAINT [df_dt21_tiencknt] DEFAULT (0) FOR [TienCKNT] 
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT21' AND col.name = 'TienCK')
    ALTER TABLE [dbo].[DT21] ADD [TienCK] DECIMAL(20, 6) NULL
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt21_tienck]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT21] WITH CHECK ADD CONSTRAINT [df_dt21_tienck] DEFAULT (0) FOR [TienCK]
GO

-- MT21
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT21' AND col.name = 'MaLoaiHD')
ALTER TABLE [dbo].[MT21] ADD [MaLoaiHD] VARCHAR(16) NULL    
GO

UPDATE [dbo].[MT21] SET [MaLoaiHD] = '01' WHERE [MaLoaiHD] IS NULL
ALTER TABLE [dbo].[MT21] ALTER COLUMN [MaLoaiHD] VARCHAR(16) NOT NULL

GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[FK_MT21_DMLHD]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
    ALTER TABLE [dbo].[MT21] WITH CHECK ADD CONSTRAINT [FK_MT21_DMLHD] FOREIGN KEY([MaLoaiHD]) REFERENCES [dbo].[DMLHD] ([MaLoaiHD])
    ALTER TABLE [dbo].[MT21] CHECK CONSTRAINT [FK_MT21_DMLHD]
END
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt21_maloaihd]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT21] WITH CHECK ADD CONSTRAINT [df_dt21_maloaihd] DEFAULT ('01') FOR [MaLoaiHD]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT21' AND col.name = 'TotalCKNT')
    ALTER TABLE [dbo].[MT21] ADD [TotalCKNT] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_MT21_totalcknt]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT21] WITH CHECK ADD CONSTRAINT [df_MT21_totalcknt] DEFAULT (0) FOR [TotalCKNT]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT21' AND col.name = 'TotalCK')
    ALTER TABLE [dbo].[MT21] ADD [TotalCK] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_MT21_totalck]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT21] WITH CHECK ADD CONSTRAINT [df_MT21_totalck] DEFAULT (0) FOR [TotalCK]
