-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0333]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0333](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[BatchID] [nvarchar](50) NOT NULL,
	[TableID] [nvarchar](50) NOT NULL,
	[ObjectID] [nvarchar](50) NOT NULL,
	[VoucherDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[OriginalAmountCN] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[RemainOriginal] [decimal](28, 8) NULL,
	[RemainConverted] [decimal](28, 8) NULL,
	[AccountID] [nvarchar](50) NULL,
	[D_C] [nvarchar](100) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	CONSTRAINT [PK_AT0333] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON
	)
) ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT0333' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT0333'  and col.name = 'Ana04ID')
Alter Table  AT0333 Add Ana04ID nvarchar(50) Null,
					 Ana05ID nvarchar(50) Null,
					 Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null;
End