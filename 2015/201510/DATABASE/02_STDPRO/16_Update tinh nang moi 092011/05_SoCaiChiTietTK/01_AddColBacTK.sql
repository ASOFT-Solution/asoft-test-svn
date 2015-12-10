if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DMTK' and col.name = 'GradeTK')
BEGIN
	alter table DMTK add GradeTK int NOT NULL CONSTRAINT [DF_DMTK_GradeTK] DEFAULT (1)
END
