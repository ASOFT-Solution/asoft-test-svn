-- DT31
if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DT31' and col.name = 'ChiuThueTTDB')
BEGIN
	
	alter table DT31  add ChiuThueTTDB bit NULL
	ALTER TABLE [dbo].[DT31] ADD  CONSTRAINT [DF_DT31_ChiuThueTTDB]  DEFAULT ('0') FOR [ChiuThueTTDB]
END

-- DT32
if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DT32' and col.name = 'ChiuThueTTDB')
BEGIN
	
	alter table DT32  add ChiuThueTTDB bit NULL
	ALTER TABLE [dbo].[DT32] ADD  CONSTRAINT [DF_DT32_ChiuThueTTDB]  DEFAULT ('0') FOR [ChiuThueTTDB]
END

-- DT33
if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DT33' and col.name = 'ChiuThueTTDB')
BEGIN
	
	alter table DT33  add ChiuThueTTDB bit NULL
	ALTER TABLE [dbo].[DT33] ADD  CONSTRAINT [DF_DT33_ChiuThueTTDB]  DEFAULT ('0') FOR [ChiuThueTTDB]
END

-- DT21
if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DT21' and col.name = 'ChiuThueTTDB')
BEGIN
	
	alter table DT21  add ChiuThueTTDB bit NULL
	ALTER TABLE [dbo].[DT21] ADD  CONSTRAINT [DF_DT21_ChiuThueTTDB]  DEFAULT ('0') FOR [ChiuThueTTDB]
END

-- DT22
if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DT22' and col.name = 'ChiuThueTTDB')
BEGIN
	
	alter table DT22  add ChiuThueTTDB bit NULL
	ALTER TABLE [dbo].[DT22] ADD  CONSTRAINT [DF_DT22_ChiuThueTTDB]  DEFAULT ('0') FOR [ChiuThueTTDB]
END

-- DT23
if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DT23' and col.name = 'ChiuThueTTDB')
BEGIN
	
	alter table DT23  add ChiuThueTTDB bit NULL
	ALTER TABLE [dbo].[DT23] ADD  CONSTRAINT [DF_DT23_ChiuThueTTDB]  DEFAULT ('0') FOR [ChiuThueTTDB]
END