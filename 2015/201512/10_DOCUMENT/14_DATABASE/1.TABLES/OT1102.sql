-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT1102]') AND type in (N'U'))
CREATE TABLE [dbo].[OT1102](
	[APK] [uniqueidentifier] NULL DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[Code] [tinyint] NOT NULL,
	[Description] [nvarchar](250) NOT NULL,
	[EDescription] [nvarchar](250) NOT NULL,
	[TypeID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_OT1102] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]