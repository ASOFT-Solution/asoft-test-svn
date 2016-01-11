-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1018]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1018](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[InterestID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[IsReceivable] [tinyint] NOT NULL,
	[IsConstant] [tinyint] NOT NULL,
	[PercentValues] [decimal](28, 8) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[BonusPercent] [decimal](28, 8) NOT NULL,
	[LaterDays] [int] NOT NULL,
	[VoucherTypeID1] [nvarchar](50) NULL,
	[VoucherTypeID2] [nvarchar](50) NULL,
	[VoucherTypeID3] [nvarchar](50) NULL,
	[VoucherTypeID4] [nvarchar](50) NULL,
	[VoucherTypeID5] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1018] PRIMARY KEY NONCLUSTERED 
(
	[InterestID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1018_IsReceivable]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1018] ADD  CONSTRAINT [DF_AT1018_IsReceivable]  DEFAULT ((1)) FOR [IsReceivable]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1018_IsConstant]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1018] ADD  CONSTRAINT [DF_AT1018_IsConstant]  DEFAULT ((1)) FOR [IsConstant]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1018_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1018] ADD  CONSTRAINT [DF_AT1018_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1018_BonusPercent]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1018] ADD  CONSTRAINT [DF_AT1018_BonusPercent]  DEFAULT ((0)) FOR [BonusPercent]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1018_LaterDays]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1018] ADD  CONSTRAINT [DF_AT1018_LaterDays]  DEFAULT ((0)) FOR [LaterDays]
END
