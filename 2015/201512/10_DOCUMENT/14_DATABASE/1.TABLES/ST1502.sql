-- <Summary>
---- 
-- <History>
---- Create on 09/08/2010 by Ngoc Nhut
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ST1502]') AND type in (N'U'))
CREATE TABLE [dbo].[ST1502](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[Phonenumber] [nvarchar](50) NULL,
	[MessageText] [nvarchar](100) NULL,
	[Dates] [smalldatetime] NULL,
	[Status] [tinyint] NULL,
	[InboxID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_ST1502] PRIMARY KEY CLUSTERED 
(
	[InboxID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]