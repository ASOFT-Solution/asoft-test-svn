-- <Summary>
---- 
-- <History>
---- Create on 28/12/2010 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0008]') AND type in (N'U'))
CREATE TABLE [dbo].[AT0008](
	[APK] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TypeID] [nvarchar](20) NOT NULL,
	[SystemName] [nvarchar](100) NULL,
	[UserName] [nvarchar](100) NULL,
	[IsUsed] [tinyint] NOT NULL DEFAULT ((1)),
	[UserNameE] [nvarchar](100) NULL,
CONSTRAINT [PK_AT0008] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]