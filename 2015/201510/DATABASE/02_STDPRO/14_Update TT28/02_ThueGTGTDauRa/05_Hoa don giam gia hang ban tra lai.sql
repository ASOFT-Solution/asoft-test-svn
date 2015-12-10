-- DT33
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT33' AND col.name = 'TyleCK')
    ALTER TABLE [dbo].[DT33] ADD [TyleCK] DECIMAL(20, 6) NULL 
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt33_tyleck]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT33] WITH CHECK ADD CONSTRAINT [df_dt33_tyleck] DEFAULT (0) FOR [TyleCK]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT33' AND col.name = 'TienCKNT')
    ALTER TABLE [dbo].[DT33] ADD [TienCKNT] DECIMAL(20, 6) NULL
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt33_tiencknt]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT33] WITH CHECK ADD CONSTRAINT [df_dt33_tiencknt] DEFAULT (0) FOR [TienCKNT] 
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DT33' AND col.name = 'TienCK')
    ALTER TABLE [dbo].[DT33] ADD [TienCK] DECIMAL(20, 6) NULL
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt33_tienck]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[DT33] WITH CHECK ADD CONSTRAINT [df_dt33_tienck] DEFAULT (0) FOR [TienCK]
GO

-- MT33
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT33' AND col.name = 'MaLoaiHD')
ALTER TABLE [dbo].[MT33] ADD [MaLoaiHD] VARCHAR(16) NULL    
GO

UPDATE [dbo].[MT33] SET [MaLoaiHD] = '01' WHERE [MaLoaiHD] IS NULL
ALTER TABLE [dbo].[MT33] ALTER COLUMN [MaLoaiHD] VARCHAR(16) NOT NULL

GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[FK_MT33_DMLHD]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
    ALTER TABLE [dbo].[MT33] WITH CHECK ADD CONSTRAINT [FK_MT33_DMLHD] FOREIGN KEY([MaLoaiHD]) REFERENCES [dbo].[DMLHD] ([MaLoaiHD])
    ALTER TABLE [dbo].[MT33] CHECK CONSTRAINT [FK_MT33_DMLHD]
END
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt33_maloaihd]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT33] WITH CHECK ADD CONSTRAINT [df_dt33_maloaihd] DEFAULT ('01') FOR [MaLoaiHD]