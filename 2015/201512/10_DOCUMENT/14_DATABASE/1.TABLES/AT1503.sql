-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on 17/01/2014 by Khánh Vân
---- Modified on 02/02/2012 by Nguyễn Bình Minh: Bo sung phan bo theo he so
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1503]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1503](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[AssetID] [nvarchar](50) NOT NULL,
	[AssetName] [nvarchar](250) NULL,
	[AssetStatus] [tinyint] NOT NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[AssetGroupID] [nvarchar](50) NULL,
	[AssetAccountID] [nvarchar](50) NULL,
	[DepAccountID] [nvarchar](50) NULL,
	[Years] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[BeginMonth] [int] NULL,
	[BeginYear] [int] NULL,
	[ResidualValue] [decimal](28, 8) NULL,
	[DepPeriods] [int] NULL,
	[MethodID] [tinyint] NOT NULL,
	[Serial] [nvarchar](50) NULL,
	[CountryID] [nvarchar](50) NULL,
	[MadeYear] [int] NULL,
	[IsTangible] [tinyint] NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[SerialNo] [nvarchar](50) NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[SourceID1] [nvarchar](50) NULL,
	[SourceAmount1] [decimal](28, 8) NULL,
	[SourcePercent1] [decimal](28, 8) NULL,
	[SourceID2] [nvarchar](50) NULL,
	[SourceAmount2] [decimal](28, 8) NULL,
	[SourcePercent2] [decimal](28, 8) NULL,
	[SourceID3] [nvarchar](50) NULL,
	[SourceAmount3] [decimal](28, 8) NULL,
	[SourcePercent3] [decimal](28, 8) NULL,
	[DebitDepAccountID1] [nvarchar](50) NULL,
	[DepPercent1] [decimal](28, 8) NULL,
	[DebitDepAccountID2] [nvarchar](50) NULL,
	[DepPercent2] [decimal](28, 8) NULL,
	[DebitDepAccountID3] [nvarchar](50) NULL,
	[DepPercent3] [decimal](28, 8) NULL,
	[DepPercent] [decimal](28, 8) NULL,
	[DepAmount] [decimal](28, 8) NULL,
	[Status] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[EstablishDate] [datetime] NULL,
	[ParentAssetID] [nvarchar](50) NULL,
	[Notes] [nvarchar](250) NULL,
	[Ana01ID1] [nvarchar](50) NULL,
	[Ana02ID1] [nvarchar](50) NULL,
	[Ana03ID1] [nvarchar](50) NULL,
	[Ana01ID2] [nvarchar](50) NULL,
	[Ana02ID2] [nvarchar](50) NULL,
	[Ana03ID2] [nvarchar](50) NULL,
	[Ana01ID3] [nvarchar](50) NULL,
	[Ana02ID3] [nvarchar](50) NULL,
	[Ana03ID3] [nvarchar](50) NULL,
	[Ana01ID4] [nvarchar](50) NULL,
	[Ana02ID4] [nvarchar](50) NULL,
	[Ana03ID4] [nvarchar](50) NULL,
	[Ana01ID5] [nvarchar](50) NULL,
	[Ana02ID5] [nvarchar](50) NULL,
	[Ana03ID5] [nvarchar](50) NULL,
	[DepPercent4] [decimal](28, 8) NULL,
	[DepPercent5] [decimal](28, 8) NULL,
	[DepPercent6] [decimal](28, 8) NULL,
	[DebitDepAccountID5] [nvarchar](50) NULL,
	[DebitDepAccountID6] [nvarchar](50) NULL,
	[DebitDepAccountID4] [nvarchar](50) NULL,
	[Ana01ID6] [nvarchar](50) NULL,
	[Ana02ID6] [nvarchar](50) NULL,
	[Ana03ID6] [nvarchar](50) NULL,
	[DepMonths] [int] NULL,
	[S1] [nvarchar](50) NULL,
	[S2] [nvarchar](50) NULL,
	[S3] [nvarchar](50) NULL,
	[Ana04ID1] [nvarchar](50) NULL,
	[Ana04ID2] [nvarchar](50) NULL,
	[Ana04ID3] [nvarchar](50) NULL,
	[Ana04ID4] [nvarchar](50) NULL,
	[Ana04ID5] [nvarchar](50) NULL,
	[Ana04ID6] [nvarchar](50) NULL,
	[Ana05ID1] [nvarchar](50) NULL,
	[Ana05ID2] [nvarchar](50) NULL,
	[Ana05ID3] [nvarchar](50) NULL,
	[Ana05ID4] [nvarchar](50) NULL,
	[Ana05ID5] [nvarchar](50) NULL,
	[Ana05ID6] [nvarchar](50) NULL,
	[CauseID] [nvarchar](50) NULL,
	[PeriodID01] [nvarchar](50) NULL,
	[PeriodID02] [nvarchar](50) NULL,
	[PeriodID03] [nvarchar](50) NULL,
	[PeriodID05] [nvarchar](50) NULL,
	[PeriodID06] [nvarchar](50) NULL,
	[PeriodID04] [nvarchar](50) NULL,
	[IsInherist] [tinyint] NOT NULL,
 CONSTRAINT [PK_AT1503] PRIMARY KEY NONCLUSTERED 
(
	[AssetID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1503_AssetStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1503] ADD  CONSTRAINT [DF_AT1503_AssetStatus]  DEFAULT ((0)) FOR [AssetStatus]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1503_Method]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1503] ADD  CONSTRAINT [DF_AT1503_Method]  DEFAULT ((0)) FOR [MethodID]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT1503__IsInheri__378417D1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1503] ADD  CONSTRAINT [DF__AT1503__IsInheri__378417D1]  DEFAULT ((0)) FOR [IsInherist]
END
---- Add Columns
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'AT1503' AND xtype ='U') 
BEGIN
		IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter01')
    ALTER TABLE AT1503 ADD Parameter01 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter02')
    ALTER TABLE AT1503 ADD Parameter02 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter03')
    ALTER TABLE AT1503 ADD Parameter03 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter04')
    ALTER TABLE AT1503 ADD Parameter04 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter05')
    ALTER TABLE AT1503 ADD Parameter05 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter06')
    ALTER TABLE AT1503 ADD Parameter06 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter07')
    ALTER TABLE AT1503 ADD Parameter07 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter08')
    ALTER TABLE AT1503 ADD Parameter08 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter09')
    ALTER TABLE AT1503 ADD Parameter09 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter10')
    ALTER TABLE AT1503 ADD Parameter10 NVARCHAR(50) NULL
   		IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter11')
    ALTER TABLE AT1503 ADD Parameter11 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter12')
    ALTER TABLE AT1503 ADD Parameter12 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter13')
    ALTER TABLE AT1503 ADD Parameter13 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter14')
    ALTER TABLE AT1503 ADD Parameter14 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter15')
    ALTER TABLE AT1503 ADD Parameter15 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter16')
    ALTER TABLE AT1503 ADD Parameter16 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter17')
    ALTER TABLE AT1503 ADD Parameter17 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter18')
    ALTER TABLE AT1503 ADD Parameter18 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter19')
    ALTER TABLE AT1503 ADD Parameter19 NVARCHAR(50) NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT1503' AND col.name = 'Parameter20')
    ALTER TABLE AT1503 ADD Parameter20 NVARCHAR(50) NULL
END 
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT1503' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT1503' AND col.name='CoefficientID')
		ALTER TABLE AT1503 ADD CoefficientID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT1503' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT1503' AND col.name='UseCofficientID')
		ALTER TABLE AT1503 ADD UseCofficientID NVARCHAR(50) NULL
	END
If Exists (Select * From sysobjects Where name = 'AT1503' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT1503'  and col.name = 'Ana06ID1')
Alter Table  AT1503 Add Ana06ID1 nvarchar(50) Null,
					 Ana06ID2 nvarchar(50) Null,
					 Ana06ID3 nvarchar(50) Null,
					 Ana06ID4 nvarchar(50) Null,
					 Ana06ID5 nvarchar(50) Null,
					 Ana06ID6 nvarchar(50) Null,
					 Ana07ID1 nvarchar(50) Null,
					 Ana07ID2 nvarchar(50) Null,
					 Ana07ID3 nvarchar(50) Null,
					 Ana07ID4 nvarchar(50) Null,
					 Ana07ID5 nvarchar(50) Null,
					 Ana07ID6 nvarchar(50) Null,
					 Ana08ID1 nvarchar(50) Null,
					 Ana08ID2 nvarchar(50) Null,
					 Ana08ID3 nvarchar(50) Null,
					 Ana08ID4 nvarchar(50) Null,
					 Ana08ID5 nvarchar(50) Null,
					 Ana08ID6 nvarchar(50) Null,
					 Ana09ID1 nvarchar(50) Null,
					 Ana09ID2 nvarchar(50) Null,
					 Ana09ID3 nvarchar(50) Null,
					 Ana09ID4 nvarchar(50) Null,
					 Ana09ID5 nvarchar(50) Null,
					 Ana09ID6 nvarchar(50) Null,
					 Ana10ID1 nvarchar(50) Null,
					 Ana10ID2 nvarchar(50) Null,
					 Ana10ID3 nvarchar(50) Null,
					 Ana10ID4 nvarchar(50) Null,
					 Ana10ID5 nvarchar(50) Null,
					 Ana10ID6 nvarchar(50) Null;
End
---- Alter Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT1503' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT1503' AND col.name='Years')
		ALTER TABLE AT1503 ALTER COLUMN Years DECIMAL(28,8) NULL 
	END