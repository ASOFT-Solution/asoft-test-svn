-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on 30/01/2011 by Việt Khánh: Thêm cột SystemNameE vào bảng AT0009
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0404]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0404](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[GiveUpID] [nvarchar](50) NOT NULL,
	[GiveUpDate] [datetime] NULL,
	[GiveUpEmployeeID] [nvarchar](50) NULL,
	[ObjectID] [nvarchar](50) NOT NULL,
	[AccountID] [nvarchar](50) NOT NULL,
	[CurrencyID] [nvarchar](50) NOT NULL,
	[DebitVoucherID] [nvarchar](50) NOT NULL,
	[DebitBatchID] [nvarchar](50) NOT NULL,
	[DebitTableID] [nvarchar](50) NOT NULL,
	[CreditVoucherID] [nvarchar](50) NOT NULL,
	[CreditBatchID] [nvarchar](50) NOT NULL,
	[CreditTableID] [nvarchar](50) NOT NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[IsExrateDiff] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[DebitVoucherDate] [datetime] NULL,
	[CreditVoucherDate] [datetime] NULL,
 CONSTRAINT [PK_AT0404] PRIMARY KEY NONCLUSTERED 
(
	[GiveUpID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add giá trị Dafefault
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0404_IsExrateDiff]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0404] ADD  CONSTRAINT [DF_AT0404_IsExrateDiff]  DEFAULT ((0)) FOR [IsExrateDiff]
END
