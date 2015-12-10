if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DMVT'  and col.name = 'GiaMua')
BEGIN
	ALTER TABLE DMVT ADD  GiaMua [decimal](28,6) NULL CONSTRAINT [DF_DMVT_GiaMua] DEFAULT (0)
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DMVT'  and col.name = 'GiaBan')
BEGIN
	ALTER TABLE DMVT ADD  GiaBan [decimal](28,6) NULL CONSTRAINT [DF_DMVT_GiaBan] DEFAULT (0)
END

if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DMVT'  and col.name = 'TKkho')
BEGIN
	ALTER TABLE [dbo].[DMVT] ALTER COLUMN [TKkho] [varchar](16) NULL
END
