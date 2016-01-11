-- <Summary>
---- 
-- <History>
---- Create on 29/01/2011 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7903]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7903](
	[APK] [uniqueidentifier] NULL DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[ReportID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT7903] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[ReportCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]