-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
-- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1015]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1015](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[AnaID] [nvarchar](50) NOT NULL,
	[AnaTypeID] [nvarchar](50) NOT NULL,
	[AnaName] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Disabled] [tinyint] NOT NULL,
 CONSTRAINT [PK_AT1015] PRIMARY KEY NONCLUSTERED 
(
	[AnaID] ASC,
	[AnaTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1015_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1015] ADD  CONSTRAINT [DF_AT1015_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
