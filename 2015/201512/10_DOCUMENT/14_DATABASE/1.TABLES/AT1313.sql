-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
/****** Object:  Table [dbo].[AT1313]    Script Date: 07/22/2010 15:03:17 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1313]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1313](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[NormID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[MinQuantity] [decimal](28, 8) NULL,
	[MaxQuantity] [decimal](28, 8) NULL,
	[ReOrderQuantity] [decimal](28, 8) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1313] PRIMARY KEY NONCLUSTERED 
(
	[NormID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
