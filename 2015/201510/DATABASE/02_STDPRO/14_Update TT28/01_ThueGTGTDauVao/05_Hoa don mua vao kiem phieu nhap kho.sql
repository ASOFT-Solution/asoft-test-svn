-- DT22
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT22' AND col.name = 'TyleCK')
    ALTER TABLE [dbo].[DT22] ADD [TyleCK] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt22_tyleck]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT22] WITH CHECK ADD CONSTRAINT [df_dt22_tyleck] DEFAULT (0) FOR [TyleCK]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT22' AND col.name = 'TienCKNT')
    ALTER TABLE [dbo].[DT22] ADD [TienCKNT] DECIMAL(20, 6) NULL
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt22_tiencknt]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT22] WITH CHECK ADD CONSTRAINT [df_dt22_tiencknt] DEFAULT (0) FOR [TienCKNT] 
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT22' AND col.name = 'TienCK')
    ALTER TABLE [dbo].[DT22] ADD [TienCK] DECIMAL(20, 6) NULL
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt22_tienck]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT22] WITH CHECK ADD CONSTRAINT [df_dt22_tienck] DEFAULT (0) FOR [TienCK]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT22' AND col.name = 'TienNKNT')
    ALTER TABLE [dbo].[DT22] ADD [TienNKNT] DECIMAL(20, 6) NULL
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt22_tiennknt]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT22] WITH CHECK ADD CONSTRAINT [df_dt22_tiennknt] DEFAULT (0) FOR [TienNKNT]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT22' AND col.name = 'TienNK')
    ALTER TABLE [dbo].[DT22] ADD [TienNK] DECIMAL(20, 6) NULL
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt22_tiennk]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT22] WITH CHECK ADD CONSTRAINT [df_dt22_tiennk] DEFAULT (0) FOR [TienNK]
GO

-- MT22
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT22' AND col.name = 'MaLoaiHD')
ALTER TABLE [dbo].[MT22] ADD [MaLoaiHD] VARCHAR(16) NULL    
GO

UPDATE [dbo].[MT22] SET [MaLoaiHD] = '01' WHERE [MaLoaiHD] IS NULL
ALTER TABLE [dbo].[MT22] ALTER COLUMN [MaLoaiHD] VARCHAR(16) NOT NULL

GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[FK_MT22_DMLHD]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
    ALTER TABLE [dbo].[MT22] WITH CHECK ADD CONSTRAINT [FK_MT22_DMLHD] FOREIGN KEY([MaLoaiHD]) REFERENCES [dbo].[DMLHD] ([MaLoaiHD])
    ALTER TABLE [dbo].[MT22] CHECK CONSTRAINT [FK_MT22_DMLHD]
END
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt22_maloaihd]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT22] WITH CHECK ADD CONSTRAINT [df_dt22_maloaihd] DEFAULT ('01') FOR [MaLoaiHD]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT22' AND col.name = 'TotalCKNT')
    ALTER TABLE [dbo].[MT22] ADD [TotalCKNT] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_mt22_totalcknt]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT22] WITH CHECK ADD CONSTRAINT [df_mt22_totalcknt] DEFAULT (0) FOR [TotalCKNT]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT22' AND col.name = 'TotalCK')
    ALTER TABLE [dbo].[MT22] ADD [TotalCK] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_mt22_totalck]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT22] WITH CHECK ADD CONSTRAINT [df_mt22_totalck] DEFAULT (0) FOR [TotalCK]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT22' AND col.name = 'TotalGNKNT')
    ALTER TABLE [dbo].[MT22] ADD [TotalGNKNT] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_mt22_totalgnknt]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT22] WITH CHECK ADD CONSTRAINT [df_mt22_totalgnknt] DEFAULT (0) FOR [TotalGNKNT]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT22' AND col.name = 'TotalGNK')
    ALTER TABLE [dbo].[MT22] ADD [TotalGNK] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_mt22_totalgnk]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT22] WITH CHECK ADD CONSTRAINT [df_mt22_totalgnk] DEFAULT (0) FOR [TotalGNK]