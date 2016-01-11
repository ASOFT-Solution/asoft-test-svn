-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7301]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7301](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[AccountID] [nvarchar](50) NULL,
	[AccountName] [nvarchar](250) NULL,
	[AccountNameE] [nvarchar](250) NULL,
	[DebitClosing] [decimal](28, 8) NULL,
	[CreditClosing] [decimal](28, 8) NULL,
	[DebitOpening] [decimal](28, 8) NULL,
	[CreditOpening] [decimal](28, 8) NULL,
	[PeriodDebit] [decimal](28, 8) NULL,
	[PeriodCredit] [decimal](28, 8) NULL,
	[AccumulatedDebit] [decimal](28, 8) NULL,
	[AccumulatedCredit] [decimal](28, 8) NULL,
	[AccountGroup1ID] [nvarchar](50) NULL,
	[AccountGroupName1] [nvarchar](250) NULL,
	[AccountGroupNameE1] [nvarchar](250) NULL,
	CONSTRAINT [PK_AT7301] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
