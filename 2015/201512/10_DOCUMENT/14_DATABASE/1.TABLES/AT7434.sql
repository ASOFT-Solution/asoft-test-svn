-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7434]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7434](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[LineID] [nvarchar](50) NOT NULL,
	[Type] [tinyint] NOT NULL,
	[ReportCodeID] [nvarchar](50) NULL,
	[OrderNo] [nvarchar](50) NULL,
	[Orders] [int] NULL,
	[IsNotPrint] [tinyint] NOT NULL,
	[LineDescription] [nvarchar](250) NULL,
	[IsBold] [tinyint] NOT NULL,
	[IsGray] [tinyint] NOT NULL,
	[IsAmount] [tinyint] NOT NULL,
	[Method] [int] NULL,
	[AmountCode] [nvarchar](50) NULL,
	[CalculatorID] [nvarchar](50) NULL,
	[VATGroup] [nvarchar](50) NULL,
	[VATTypeID1] [nvarchar](50) NULL,
	[VATTypeID2] [nvarchar](50) NULL,
	[VATTypeID3] [nvarchar](50) NULL,
	[AccumulatorID] [nvarchar](50) NULL,
	[FromAccountID1] [nvarchar](50) NULL,
	[ToAccountID1] [nvarchar](50) NULL,
	[FromCorAccountID1] [nvarchar](50) NULL,
	[ToCorAccountID1] [nvarchar](50) NULL,
	[FromAccountID2] [nvarchar](50) NULL,
	[ToAccountID2] [nvarchar](50) NULL,
	[FromCorAccountID2] [nvarchar](50) NULL,
	[ToCorAccountID2] [nvarchar](50) NULL,
	[FromAccountID3] [nvarchar](50) NULL,
	[ToAccountID3] [nvarchar](50) NULL,
	[FromCorAccountID3] [nvarchar](50) NULL,
	[ToCorAccountID3] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[Sign] [nvarchar](5) NULL,
 CONSTRAINT [PK_AT7434] PRIMARY KEY NONCLUSTERED 
(
	[LineID] ASC,
	[Type] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7434_Type]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7434] ADD  CONSTRAINT [DF_AT7434_Type]  DEFAULT ((0)) FOR [Type]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7434_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7434] ADD  CONSTRAINT [DF_AT7434_Disabled]  DEFAULT ((0)) FOR [IsNotPrint]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7434_IsBold]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7434] ADD  CONSTRAINT [DF_AT7434_IsBold]  DEFAULT ((0)) FOR [IsBold]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7434_IsGray]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7434] ADD  CONSTRAINT [DF_AT7434_IsGray]  DEFAULT ((0)) FOR [IsGray]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7434_IsAmount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7434] ADD  CONSTRAINT [DF_AT7434_IsAmount]  DEFAULT ((0)) FOR [IsAmount]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT7434__Sign__5EDB4845]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7434] ADD  CONSTRAINT [DF__AT7434__Sign__5EDB4845]  DEFAULT ('+') FOR [Sign]
END
