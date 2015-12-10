
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'VATIn' AND col.name = 'MaLoaiHD')
ALTER TABLE [dbo].[VATIn] ADD [MaLoaiHD] VARCHAR(16) NULL    
GO

UPDATE [dbo].[VATIn] SET [MaLoaiHD] = '01' WHERE [MaLoaiHD] IS NULL
ALTER TABLE [dbo].[VATIn] ALTER COLUMN [MaLoaiHD] VARCHAR(16) NOT NULL

GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[FK_VATIn_DMLHD]') AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
    ALTER TABLE [dbo].[VATIn] WITH CHECK ADD CONSTRAINT [FK_VATIn_DMLHD] FOREIGN KEY([MaLoaiHD]) REFERENCES [dbo].[DMLHD] ([MaLoaiHD])
    ALTER TABLE [dbo].[VATIn] CHECK CONSTRAINT [FK_VATIn_DMLHD]
END
GO
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[df_vatin_maloaihd]') AND OBJECTPROPERTY(id, N'IsDefaultCnst') = 1)
    ALTER TABLE [dbo].[VATIn] WITH CHECK ADD CONSTRAINT [df_vatin_maloaihd] DEFAULT ('01') FOR [MaLoaiHD]
