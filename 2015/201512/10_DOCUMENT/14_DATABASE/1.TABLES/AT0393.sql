-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0393]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0393](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ObjectID] [nvarchar](50) NULL,
	[GroupID] [nvarchar](50) NULL,
	[BeginDebitAmount] [decimal](28, 8) NULL,
	[BeginCreditAmount] [decimal](28, 8) NULL,
	[DebitAmount] [decimal](28, 8) NULL,
	[CreditAmount] [decimal](28, 8) NULL,
	[EndDebitAmount] [decimal](28, 8) NULL,
	[EndCreditAmount] [decimal](28, 8) NULL,
	[BeginDebitConAmount] [decimal](28, 8) NULL,
	[BeginCreditConAmount] [decimal](28, 8) NULL,
	[DebitConAmount] [decimal](28, 8) NULL,
	[CreditConAmount] [decimal](28, 8) NULL,
	[EndDebitConAmount] [decimal](28, 8) NULL,
	[EndCreditConAmount] [decimal](28, 8) NULL,
	[Col00] [decimal](28, 8) NULL,
	[Col01] [decimal](28, 8) NULL,
	[Col02] [decimal](28, 8) NULL,
	[Col03] [decimal](28, 8) NULL,
	[Col04] [decimal](28, 8) NULL,
	[Col05] [decimal](28, 8) NULL,
	[Col06] [decimal](28, 8) NULL,
	[ColCon00] [decimal](28, 8) NULL,
	[ColCon01] [decimal](28, 8) NULL,
	[ColCon02] [decimal](28, 8) NULL,
	[ColCon03] [decimal](28, 8) NULL,
	[ColCon04] [decimal](28, 8) NULL,
	[ColCon05] [decimal](28, 8) NULL,
	[ColCon06] [decimal](28, 8) NULL,
	[OldCol00] [decimal](28, 8) NULL,
	[OldCol01] [decimal](28, 8) NULL,
	[OldCol02] [decimal](28, 8) NULL,
	[OldCol03] [decimal](28, 8) NULL,
	[OldCol04] [decimal](28, 8) NULL,
	[OldCol05] [decimal](28, 8) NULL,
	[OldCol06] [decimal](28, 8) NULL,
	[OldColCon00] [decimal](28, 8) NULL,
	[OldColCon01] [decimal](28, 8) NULL,
	[OldColCon02] [decimal](28, 8) NULL,
	[OldColCon03] [decimal](28, 8) NULL,
	[OldColCon04] [decimal](28, 8) NULL,
	[OldColCon05] [decimal](28, 8) NULL,
	[OldColCon06] [decimal](28, 8) NULL,
	[days] [int] NULL,
	CONSTRAINT [PK_AT0393] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON
)
) ON [PRIMARY]
END

