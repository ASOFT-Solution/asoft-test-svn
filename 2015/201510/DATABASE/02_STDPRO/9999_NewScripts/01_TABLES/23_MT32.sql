if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MT32'  and col.name = 'TCKNT')
BEGIN
	Update [MT32] set [TCKNT] = 0 where [TCKNT] is null
	ALTER TABLE [dbo].[MT32] ALTER COLUMN [TCKNT] [decimal](28,6) NOT NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT32'  and col.name = 'NgayBatDauTT')
BEGIN
	ALTER TABLE MT32 ADD  [NgayBatDauTT] smalldatetime NULL
END