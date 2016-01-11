-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT5560]') AND type in (N'U'))
CREATE TABLE [dbo].[AT5560](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[Serial] [nvarchar](50) NOT NULL,
	[InvoiceNo] [nvarchar](50) NOT NULL,
	[InvoiceDate] [datetime] NULL,
	[ObjectID] [nvarchar](50) NOT NULL,
	[TMB] [decimal](28, 8) NULL,
	[PQL] [decimal](28, 8) NULL,
	[TKO] [decimal](28, 8) NULL,
 CONSTRAINT [PK_AT5560] PRIMARY KEY CLUSTERED 
(
	[Serial] ASC,
	[InvoiceNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT5560_TMB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT5560] ADD  CONSTRAINT [DF_AT5560_TMB]  DEFAULT ((0)) FOR [TMB]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT5560_PQL]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT5560] ADD  CONSTRAINT [DF_AT5560_PQL]  DEFAULT ((0)) FOR [PQL]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT5560_TKO]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT5560] ADD  CONSTRAINT [DF_AT5560_TKO]  DEFAULT ((0)) FOR [TKO]
END