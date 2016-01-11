-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT5002]') AND type in (N'U'))
CREATE TABLE [dbo].[HT5002](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[GeneralAbsentID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[Type] [tinyint] NULL,
	[Days] [decimal](28, 8) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[IsMonth] [tinyint] NOT NULL,
	[FromDate] [int] NULL,
	[ToDate] [int] NULL,
	[IsP] [tinyint] NOT NULL,
	[PeriodID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT5002] PRIMARY KEY NONCLUSTERED 
(
	[GeneralAbsentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT5002_Disabed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5002] ADD  CONSTRAINT [DF_HT5002_Disabed]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT5002__AbsentTy__53240F16]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5002] ADD  CONSTRAINT [DF__HT5002__AbsentTy__53240F16]  DEFAULT ((1)) FOR [IsMonth]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT5002__IsP__1D386D71]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5002] ADD  CONSTRAINT [DF__HT5002__IsP__1D386D71]  DEFAULT ((0)) FOR [IsP]
END