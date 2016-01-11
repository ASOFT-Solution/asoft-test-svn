-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0002STD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0002STD](
	[TableID] [nvarchar](50) NOT NULL,
	[IsAutomatic] [tinyint] NOT NULL,
	[IsS1] [tinyint] NOT NULL,
	[IsS2] [tinyint] NOT NULL,
	[IsS3] [tinyint] NOT NULL,
	[S1] [nvarchar](50) NULL,
	[S2] [nvarchar](50) NULL,
	[S3] [nvarchar](50) NULL,
	[Length] [tinyint] NULL,
	[OutputOrder] [tinyint] NULL,
	[IsSeparator] [tinyint] NULL,
	[Separator] [nvarchar](5) NULL
) ON [PRIMARY]
END