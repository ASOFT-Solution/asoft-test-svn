-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1017]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1017](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VoucherGroupID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[IsUsed] [tinyint] NOT NULL,
 CONSTRAINT [PK_AT1017] PRIMARY KEY CLUSTERED 
(
	[VoucherGroupID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_at1017_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1017] ADD  CONSTRAINT [DF_at1017_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1017_IsUsed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1017] ADD  CONSTRAINT [DF_AT1017_IsUsed]  DEFAULT ((1)) FOR [IsUsed]
END

