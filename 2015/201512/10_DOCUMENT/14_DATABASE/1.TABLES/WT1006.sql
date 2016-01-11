-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WT1006]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WT1006](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](50) NOT NULL,
	[LocationCode] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Location01ID] [nvarchar](50) NULL,
	[Location02ID] [nvarchar](50) NULL,
	[Location03ID] [nvarchar](50) NULL,
	[Location04ID] [nvarchar](50) NULL,
	[Location05ID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Disabled] [tinyint] NULL,
 CONSTRAINT [PK_WT1006] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[LocationCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

