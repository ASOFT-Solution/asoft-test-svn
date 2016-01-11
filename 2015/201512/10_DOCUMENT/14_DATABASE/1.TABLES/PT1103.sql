-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PT1103]') AND type in (N'U'))
CREATE TABLE [dbo].[PT1103](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[MacID] [nvarchar](50) NOT NULL,
	[MacName] [nvarchar](250) NOT NULL,
	[MacTypeID] [nvarchar](50) NOT NULL,
	[FactoryID] [nvarchar](50) NULL,
	[Capacity] [decimal](28, 8) NOT NULL,
	[Persons] [int] NULL,
	[Notes] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_PT1103] PRIMARY KEY CLUSTERED 
(
	[MacID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PT1103_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PT1103] ADD  CONSTRAINT [DF_PT1103_Disabled]  DEFAULT ((0)) FOR [Disabled]
END