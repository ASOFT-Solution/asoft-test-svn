-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1016]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1016](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[BankAccountID] [nvarchar](50) NOT NULL,
	[AccountID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[BankAccountNo] [nvarchar](50) NULL,
	[BankName] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[OpenDate] [datetime] NULL,
	[CloseDate] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[BankID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1016] PRIMARY KEY NONCLUSTERED 
(
	[BankAccountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1016_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1016] ADD  CONSTRAINT [DF_AT1016_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
