-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on 17/04/2013 by Lê Thị Thu Hiền
---- Modified on 24/05/2013 by Bảo Quỳnh
---- <Example>
/****** Object:  Table [dbo].[AT7622]    Script Date: 07/23/2010 11:24:45 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7622]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7622](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar](3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[LineID] [nvarchar](50) NOT NULL,
	[Amount01] [decimal](28, 8) NULL,
	[Amount02] [decimal](28, 8) NULL,
	[Amount03] [decimal](28, 8) NULL,
	[Amount04] [decimal](28, 8) NULL,
	[Amount05] [decimal](28, 8) NULL,
	[Amount06] [decimal](28, 8) NULL,
	[Amount07] [decimal](28, 8) NULL,
	[Amount08] [decimal](28, 8) NULL,
	[Amount09] [decimal](28, 8) NULL,
	[Amount10] [decimal](28, 8) NULL,
	[Amount11] [decimal](28, 8) NULL,
	[Amount12] [decimal](28, 8) NULL,
	[Amount13] [decimal](28, 8) NULL,
	[Amount14] [decimal](28, 8) NULL,
	[Amount15] [decimal](28, 8) NULL,
	[Amount16] [decimal](28, 8) NULL,
	[Amount17] [decimal](28, 8) NULL,
	[Amount18] [decimal](28, 8) NULL,
	[Amount19] [decimal](28, 8) NULL,
	[Amount20] [decimal](28, 8) NULL,
CONSTRAINT [PK_AT7622] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT7622' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7622'  and col.name = 'Amount21')
           Alter Table  AT7622 Add Amount21 decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'AT7622' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7622'  and col.name = 'Amount22')
           Alter Table  AT7622 Add Amount22 decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'AT7622' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7622'  and col.name = 'Amount23')
           Alter Table  AT7622 Add Amount23 decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'AT7622' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7622'  and col.name = 'Amount24')
           Alter Table  AT7622 Add Amount24 decimal(28,8) Null
End 
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount01LastPeriod')  ALTER TABLE AT7622 ADD Amount01LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount02LastPeriod')  ALTER TABLE AT7622 ADD Amount02LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount03LastPeriod')  ALTER TABLE AT7622 ADD Amount03LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount04LastPeriod')  ALTER TABLE AT7622 ADD Amount04LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount05LastPeriod')  ALTER TABLE AT7622 ADD Amount05LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount06LastPeriod')  ALTER TABLE AT7622 ADD Amount06LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount07LastPeriod')  ALTER TABLE AT7622 ADD Amount07LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount08LastPeriod')  ALTER TABLE AT7622 ADD Amount08LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount09LastPeriod')  ALTER TABLE AT7622 ADD Amount09LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount10LastPeriod')  ALTER TABLE AT7622 ADD Amount10LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount11LastPeriod')  ALTER TABLE AT7622 ADD Amount11LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount12LastPeriod')  ALTER TABLE AT7622 ADD Amount12LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount13LastPeriod')  ALTER TABLE AT7622 ADD Amount13LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount14LastPeriod')  ALTER TABLE AT7622 ADD Amount14LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount15LastPeriod')  ALTER TABLE AT7622 ADD Amount15LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount16LastPeriod')  ALTER TABLE AT7622 ADD Amount16LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount17LastPeriod')  ALTER TABLE AT7622 ADD Amount17LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount18LastPeriod')  ALTER TABLE AT7622 ADD Amount18LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount19LastPeriod')  ALTER TABLE AT7622 ADD Amount19LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount20LastPeriod')  ALTER TABLE AT7622 ADD Amount20LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount21LastPeriod')  ALTER TABLE AT7622 ADD Amount21LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount22LastPeriod')  ALTER TABLE AT7622 ADD Amount22LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount23LastPeriod')  ALTER TABLE AT7622 ADD Amount23LastPeriod decimal(28,8)
IF NOT EXISTS(SELECT TOP 1 1 FROM syscolumns WHERE OBJECT_ID('AT7622')=ID AND name = 'Amount24LastPeriod')  ALTER TABLE AT7622 ADD Amount24LastPeriod decimal(28,8)