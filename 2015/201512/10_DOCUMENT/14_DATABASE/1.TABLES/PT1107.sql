-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PT1107]') AND type in (N'U'))
CREATE TABLE [dbo].[PT1107](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[StyleID] [nvarchar](50) NOT NULL,
	[StyleName] [nvarchar](250) NOT NULL,
	[StyleGroupID] [nvarchar](50) NOT NULL,
	[StopTime] [decimal](28, 8) NULL,
	[Width] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_PT1107] PRIMARY KEY CLUSTERED 
(
	[StyleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PT1107_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PT1107] ADD  CONSTRAINT [DF_PT1107_Disabled]  DEFAULT ((0)) FOR [Disabled]
END