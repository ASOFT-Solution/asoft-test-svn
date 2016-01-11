-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0007]') AND type in (N'U'))
CREATE TABLE [dbo].[MT0007](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[MaterialGroupID] [nvarchar](50) NOT NULL,
	[MaterialID] [nvarchar](50) NOT NULL,
	[CoValues] [decimal](28, 8) NULL,
	[Description] [nvarchar](250) NULL,
	[Orders] [tinyint] NULL,
 CONSTRAINT [PK_MT0007] PRIMARY KEY CLUSTERED 
(
	[MaterialGroupID] ASC,
	[MaterialID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
