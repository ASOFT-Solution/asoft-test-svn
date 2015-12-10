-- OBTK
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'OBTK'  and col.name = 'TrangThaiCT')
BEGIN
	ALTER TABLE OBTK ADD  TrangThaiCT bit not null CONSTRAINT [df_obtk_TrangThaiCT] DEFAULT (0)
END