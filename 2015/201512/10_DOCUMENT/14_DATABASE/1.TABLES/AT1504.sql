-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on 02/02/2012 by Nguyen Binh Minh: Bo sung phan bo theo he so
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1504]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1504](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DepreciationID] [nvarchar](50) NOT NULL,
	[AssetID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[SourceID] [nvarchar](50) NULL,
	[BDescription] [nvarchar](250) NULL,
	[CreditAccountID] [nvarchar](50) NULL,
	[DebitAccountID] [nvarchar](50) NULL,
	[DepAmount] [decimal](28, 8) NULL,
	[DepPercent] [decimal](28, 8) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[DepType] [tinyint] NOT NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Status] [tinyint] NOT NULL,
	[ObjectID] [nvarchar](50) NULL,
	[PeriodID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1504] PRIMARY KEY NONCLUSTERED 
(
	[DepreciationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá tị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1504_DepType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1504] ADD CONSTRAINT [DF_AT1504_DepType] DEFAULT ((0)) FOR [DepType]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1504_Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1504] ADD CONSTRAINT [DF_AT1504_Status] DEFAULT ((0)) FOR [Status]
END
---- Add Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT1504' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT1504' AND col.name='CoefficientID')
		ALTER TABLE AT1504 ADD CoefficientID NVARCHAR(50) NULL
	END
If Exists (Select * From sysobjects Where name = 'AT1504' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT1504'  and col.name = 'Ana06ID')
Alter Table  AT1504 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End