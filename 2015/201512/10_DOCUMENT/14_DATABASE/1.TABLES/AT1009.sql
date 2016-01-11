-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by ...
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1009]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT1009](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VATTypeID] [nvarchar](50) NOT NULL,
	[VATTypeName] [nvarchar](250) NULL,
	[IsVATIn] [tinyint] NOT NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1009] PRIMARY KEY NONCLUSTERED 
(
	[VATTypeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1009_IsVATIn]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1009] ADD  CONSTRAINT [DF_AT1009_IsVATIn]  DEFAULT ((0)) FOR [IsVATIn]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1009_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1009] ADD  CONSTRAINT [DF_AT1009_Disabled]  DEFAULT ((0)) FOR [Disabled]
END

