-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT4724]') AND type in (N'U'))
CREATE TABLE [dbo].[AT4724](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCodeID] [nvarchar](50) NOT NULL,
	[ColumnID] [int] NOT NULL,
	[IsFromAccount] [tinyint] NOT NULL,
	[AmountType1] [nvarchar](50) NULL,
	[AmountType2] [nvarchar](50) NULL,
	[AmountType3] [nvarchar](50) NULL,
	[FromAccountID1] [nvarchar](50) NULL,
	[ToAccountID1] [nvarchar](50) NULL,
	[FromAccountID2] [nvarchar](50) NULL,
	[ToAccountID2] [nvarchar](50) NULL,
	[FromAccountID3] [nvarchar](50) NULL,
	[ToAccountID3] [nvarchar](50) NULL,
	[Colum01ID] [nvarchar](50) NULL,
	[Colum02ID] [nvarchar](50) NULL,
	[Sign1] [nvarchar](5) NULL,
	[Sign2] [nvarchar](5) NULL,
	[Sign3] [nvarchar](5) NULL,
	[Sign] [nvarchar](5) NULL,
	[IsQuantity] [tinyint] NOT NULL,
 CONSTRAINT [PK_AT4724] PRIMARY KEY NONCLUSTERED 
(
	[ReportCodeID] ASC,
	[ColumnID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT4724_IsFromAccount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT4724] ADD CONSTRAINT [DF_AT4724_IsFromAccount] DEFAULT ((1)) FOR [IsFromAccount]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT4724__IsQuanti__0544E102]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT4724] ADD CONSTRAINT [DF__AT4724__IsQuanti__0544E102] DEFAULT ((0)) FOR [IsQuantity]
END
