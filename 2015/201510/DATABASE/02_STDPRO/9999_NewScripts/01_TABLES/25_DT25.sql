if exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'DT25'  and col.name = 'TienCKNT')
BEGIN
	Update [DT25] set [TienCKNT] = 0 where [TienCKNT] is null
	ALTER TABLE [dbo].[DT25] ALTER COLUMN [TienCKNT] [decimal](28,6) NOT NULL
END
