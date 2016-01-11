-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1208]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1208](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[PaymentTermID] [nvarchar](50) NOT NULL,
	[PaymentTermName] [nvarchar](250) NULL,
	[IsDueDate] [tinyint] NOT NULL,
	[DueType] [nvarchar](50) NULL,
	[DueDays] [int] NULL,
	[IsDiscount] [tinyint] NOT NULL,
	[DiscountType] [nvarchar](50) NULL,
	[DiscountPercentage] [decimal](28, 8) NULL,
	[DiscountDays] [int] NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[TheDay] [tinyint] NULL,
	[TheMonth] [tinyint] NULL,
	[CloseDay] [tinyint] NULL,
 CONSTRAINT [PK_AT1208] PRIMARY KEY NONCLUSTERED 
(
	[PaymentTermID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1208_IsDueDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1208] ADD  CONSTRAINT [DF_AT1208_IsDueDate]  DEFAULT ((0)) FOR [IsDueDate]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1208_IsDiscount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1208] ADD  CONSTRAINT [DF_AT1208_IsDiscount]  DEFAULT ((0)) FOR [IsDiscount]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1208_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1208] ADD  CONSTRAINT [DF_AT1208_Disabled]  DEFAULT ((0)) FOR [Disabled]
END