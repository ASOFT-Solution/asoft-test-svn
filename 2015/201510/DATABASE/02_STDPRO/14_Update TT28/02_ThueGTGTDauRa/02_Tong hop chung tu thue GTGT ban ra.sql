
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'VATOut' AND col.name = 'MaLoaiHD')
ALTER TABLE [dbo].[VATOut] ADD [MaLoaiHD] VARCHAR(16) NULL    
GO

UPDATE [dbo].[VATOut] SET [MaLoaiHD] = '01' WHERE [MaLoaiHD] IS NULL
ALTER TABLE [dbo].[VATOut] ALTER COLUMN [MaLoaiHD] VARCHAR(16) NOT NULL

GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[FK_VATOut_DMLHD]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
    ALTER TABLE [dbo].[VATOut] WITH CHECK ADD CONSTRAINT [FK_VATOut_DMLHD] FOREIGN KEY([MaLoaiHD]) REFERENCES [dbo].[DMLHD] ([MaLoaiHD])
    ALTER TABLE [dbo].[VATOut] CHECK CONSTRAINT [FK_VATOut_DMLHD]
END
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_vatout_maloaihd]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[VATOut] WITH CHECK ADD CONSTRAINT [df_vatout_maloaihd] DEFAULT ('01') FOR [MaLoaiHD]

-- Cập nhật [MaLoaiHD]
UPDATE [VATOut] SET [MaLoaiHD] = '01' WHERE [MaLoaiHD] IS NULL

IF EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'VATOut' AND col.name = 'MaLoaiHD')
    ALTER TABLE [dbo].[VATOut] ALTER COLUMN [MaLoaiHD] VARCHAR(16) NOT NULL