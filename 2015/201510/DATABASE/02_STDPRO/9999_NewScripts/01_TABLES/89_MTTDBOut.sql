if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MTTDBOut'  and col.name = 'DeclareType')
BEGIN
	ALTER TABLE MTTDBOut ADD  DeclareType int NULL
END
if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MTTDBOut'  and col.name = 'Notes')
BEGIN
	ALTER TABLE MTTDBOut ADD  Notes NVARCHAR(512) NULL
END
if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MTTDBOut'  and col.name = 'InputDate')
BEGIN
	ALTER TABLE MTTDBOut ADD  InputDate SMALLDATETIME NULL
END
if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MTTDBOut'  and col.name = 'DeclareTypeName')
BEGIN
	ALTER TABLE MTTDBOut ADD  DeclareTypeName NVARCHAR(512) NULL
END