if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DMTSCD'  and col.name = 'DaKH')
BEGIN
	ALTER TABLE DMTSCD ADD  DaKH decimal(28,6) NOT NULL CONSTRAINT [DF_DMTSCD_DaKH] DEFAULT (0)
END
