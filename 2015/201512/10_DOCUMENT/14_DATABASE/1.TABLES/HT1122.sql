-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1122]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1122](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ProjectID] [nvarchar](50) NOT NULL,
	[DefineID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_HT1122] PRIMARY KEY CLUSTERED 
(
	[ProjectID] ASC,
	[DefineID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

