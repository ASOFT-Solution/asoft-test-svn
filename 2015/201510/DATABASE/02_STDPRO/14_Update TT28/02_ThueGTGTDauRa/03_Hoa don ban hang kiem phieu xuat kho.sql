
-- MT32
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'MT32' AND col.name = 'MaLoaiHD')
ALTER TABLE [dbo].[MT32] ADD [MaLoaiHD] VARCHAR(16) NULL    
GO

UPDATE [dbo].[MT32] SET [MaLoaiHD] = '01' WHERE [MaLoaiHD] IS NULL
ALTER TABLE [dbo].[MT32] ALTER COLUMN [MaLoaiHD] VARCHAR(16) NOT NULL

GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[FK_MT32_DMLHD]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
    ALTER TABLE [dbo].[MT32] WITH CHECK ADD CONSTRAINT [FK_MT32_DMLHD] FOREIGN KEY([MaLoaiHD]) REFERENCES [dbo].[DMLHD] ([MaLoaiHD])
    ALTER TABLE [dbo].[MT32] CHECK CONSTRAINT [FK_MT32_DMLHD]
END
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_dt32_maloaihd]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[MT32] WITH CHECK ADD CONSTRAINT [df_dt32_maloaihd] DEFAULT ('01') FOR [MaLoaiHD]
