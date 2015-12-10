-- DT23
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT23' AND col.name = 'TyleCK')
    ALTER TABLE [dbo].[DT23] ADD [TyleCK] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt23_tyleck]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT23] WITH CHECK ADD CONSTRAINT [df_dt23_tyleck] DEFAULT (0) FOR [TyleCK]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT23' AND col.name = 'TienCKNT')
    ALTER TABLE [dbo].[DT23] ADD [TienCKNT] DECIMAL(20, 6) NULL
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt23_tiencknt]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT23] WITH CHECK ADD CONSTRAINT [df_dt23_tiencknt] DEFAULT (0) FOR [TienCKNT] 
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT23' AND col.name = 'TienCK')
    ALTER TABLE [dbo].[DT23] ADD [TienCK] DECIMAL(20, 6) NULL
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt23_tienck]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT23] WITH CHECK ADD CONSTRAINT [df_dt23_tienck] DEFAULT (0) FOR [TienCK]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT23' AND col.name = 'TienNKNT')
    ALTER TABLE [dbo].[DT23] ADD [TienNKNT] DECIMAL(20, 6) NULL
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt23_tiennknt]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT23] WITH CHECK ADD CONSTRAINT [df_dt23_tiennknt] DEFAULT (0) FOR [TienNKNT]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT23' AND col.name = 'TienNK')
    ALTER TABLE [dbo].[DT23] ADD [TienNK] DECIMAL(20, 6) NULL
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt23_tiennk]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT23] WITH CHECK ADD CONSTRAINT [df_dt23_tiennk] DEFAULT (0) FOR [TienNK]
GO

-- MT23
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT23' AND col.name = 'MaLoaiHD')
ALTER TABLE [dbo].[MT23] ADD [MaLoaiHD] VARCHAR(16) NULL    
GO

UPDATE [dbo].[MT23] SET [MaLoaiHD] = '01' WHERE [MaLoaiHD] IS NULL
ALTER TABLE [dbo].[MT23] ALTER COLUMN [MaLoaiHD] VARCHAR(16) NOT NULL

GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[FK_MT23_DMLHD]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
    ALTER TABLE [dbo].[MT23] WITH CHECK ADD CONSTRAINT [FK_MT23_DMLHD] FOREIGN KEY([MaLoaiHD]) REFERENCES [dbo].[DMLHD] ([MaLoaiHD])
    ALTER TABLE [dbo].[MT23] CHECK CONSTRAINT [FK_MT23_DMLHD]
END
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_mt23_maloaihd]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT23] WITH CHECK ADD CONSTRAINT [df_mt23_maloaihd] DEFAULT ('01') FOR [MaLoaiHD]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT23' AND col.name = 'TotalCKNT')
    ALTER TABLE [dbo].[MT23] ADD [TotalCKNT] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_mt23_totalcknt]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT23] WITH CHECK ADD CONSTRAINT [df_mt23_totalcknt] DEFAULT (0) FOR [TotalCKNT]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT23' AND col.name = 'TotalCK')
    ALTER TABLE [dbo].[MT23] ADD [TotalCK] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_mt23_totalck]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT23] WITH CHECK ADD CONSTRAINT [df_mt23_totalck] DEFAULT (0) FOR [TotalCK]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT23' AND col.name = 'TotalGNKNT')
    ALTER TABLE [dbo].[MT23] ADD [TotalGNKNT] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_mt23_totalgnknt]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT23] WITH CHECK ADD CONSTRAINT [df_mt23_totalgnknt] DEFAULT (0) FOR [TotalGNKNT]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT23' AND col.name = 'TotalGNK')
    ALTER TABLE [dbo].[MT23] ADD [TotalGNK] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_mt23_totalgnk]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT23] WITH CHECK ADD CONSTRAINT [df_mt23_totalgnk] DEFAULT (0) FOR [TotalGNK]