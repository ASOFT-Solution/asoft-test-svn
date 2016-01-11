-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT1306]') AND type in (N'U'))
CREATE TABLE [dbo].[OT1306](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[SMaterial01ID] [nvarchar](50) NULL,
	[SMaterial02ID] [nvarchar](50) NULL,
	[SMaterial03ID] [nvarchar](50) NULL,
	[C01] [decimal](28, 8) NULL,
	[C02] [decimal](28, 8) NULL,
	[C03] [decimal](28, 8) NULL,
	[C04] [decimal](28, 8) NULL,
	[C05] [decimal](28, 8) NULL,
	[C06] [decimal](28, 8) NULL,
	[SMaterial04ID] [nvarchar](50) NULL,
CONSTRAINT [PK_OT1306] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

