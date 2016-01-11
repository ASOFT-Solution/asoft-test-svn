ALTER TABLE MTTDBIn
ALTER COLUMN KyBKMVTTDB int NULL

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MTTDBIn'  and col.name = 'DeclareType')
BEGIN
	ALTER TABLE MTTDBIn ADD  DeclareType int NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MTTDBIn'  and col.name = 'InputDate')
BEGIN
	ALTER TABLE MTTDBIn ADD  InputDate SMALLDATETIME NULL
END

if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MTTDBIn'  and col.name = 'DeclareTypeName')
BEGIN
	ALTER TABLE MTTDBIn ADD  DeclareTypeName NVARCHAR(512) NULL
END