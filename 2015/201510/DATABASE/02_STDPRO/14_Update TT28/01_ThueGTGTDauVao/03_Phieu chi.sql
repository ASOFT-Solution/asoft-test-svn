if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'VATIn' and col.name = 'MaLoaiHD')
	alter table VATIn  add [MaLoaiHD] varchar(16) NULL
	
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_VATIn_DMLThue]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN

ALTER TABLE [dbo].[VATIn]  WITH CHECK ADD  CONSTRAINT [FK_VATIn_DMLThue] FOREIGN KEY([Type])
REFERENCES [dbo].[DMLThue] ([MaLoaiThue])

ALTER TABLE [dbo].[VATIn] CHECK CONSTRAINT [FK_VATIn_DMLThue]

END

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_VATIn_DMLHD]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN

ALTER TABLE [dbo].[VATIn]  WITH CHECK ADD  CONSTRAINT [FK_VATIn_DMLHD] FOREIGN KEY([MaLoaiHD])
REFERENCES [dbo].[DMLHD] ([MaLoaiHD])

ALTER TABLE [dbo].[VATIn] CHECK CONSTRAINT [FK_VATIn_DMLHD]

END

GO

-- HD GTGT
Update VATIn set MaLoaiHD = '01'
where MaLoaiHD is null

if exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'VATIn' and col.name = 'MaLoaiHD')
alter table VATIn  ALTER COLUMN [MaLoaiHD] varchar(16) NOT NULL
	