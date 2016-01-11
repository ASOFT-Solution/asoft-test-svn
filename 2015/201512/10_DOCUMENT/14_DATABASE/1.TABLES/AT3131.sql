-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on 02/12/2013 by Khánh Vân
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT3131]') AND type in (N'U'))
CREATE TABLE [dbo].[AT3131](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[ObjectID] [nvarchar](50) NULL,
	[ObjectName] [nvarchar](250) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[GiveOriginalAmount] [decimal](28, 8) NULL,
	[GiveConvertedAmount] [decimal](28, 8) NULL,
	[RemainOriginalAmount] [decimal](28, 8) NULL,
	[RemainConvertedAmount] [decimal](28, 8) NULL,
	[BonusAmount] [decimal](28, 8) NULL,
	[InterestAmount] [decimal](28, 8) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[Serial] [nvarchar](50) NULL,
	[DueDate] [datetime] NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[InterestID] [nvarchar](50) NULL,
	[VoucherID] [nvarchar](50) NULL,
	[CalMonth] [int] NULL,
	[CalYear] [int] NULL,
	[CalID] [nvarchar](50) NULL,
	CONSTRAINT [PK_AT3131] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

) ON [PRIMARY]
---- Add Columns
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'AT3131' AND xtype ='U') 
BEGIN
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT3131' AND col.name = 'AccountID')
    ALTER TABLE AT3131 ADD AccountID nvarchar(50) NULL
END 
If Exists (Select * From sysobjects Where name = 'AT3131' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT3131'  and col.name = 'Ana03ID')
Alter Table  AT3131 Add Ana03ID nvarchar(50) Null,
					 Ana04ID nvarchar(50) Null,
					 Ana05ID nvarchar(50) Null,
					 Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End