-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7611]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7611](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCode] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[BookNo] [nvarchar](50) NOT NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[Description] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[BookDate] [datetime] NULL,
	[ByAccountID] [tinyint] NOT NULL,
	[Debit] [tinyint] NOT NULL,
	[IsPrint] [int] NULL,
	CONSTRAINT [PK_AT7611] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7611_ByAccountID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7611] ADD  CONSTRAINT [DF_AT7611_ByAccountID]  DEFAULT ((0)) FOR [ByAccountID]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7611_Debit]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7611] ADD  CONSTRAINT [DF_AT7611_Debit]  DEFAULT ((0)) FOR [Debit]
END
