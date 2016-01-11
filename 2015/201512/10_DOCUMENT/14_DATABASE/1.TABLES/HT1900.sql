-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1900]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1900](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ProducingProcessID] [nvarchar](50) NOT NULL,
	[ProducingProcessName] [nvarchar](250) NOT NULL,
	[ChildLevel] [int] NULL,
	[Notes] [nvarchar](250) NULL,
	[Disabled] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT19001] PRIMARY KEY NONCLUSTERED 
(
	[ProducingProcessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT1900__ChildLev__07F599CD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1900] ADD  CONSTRAINT [DF__HT1900__ChildLev__07F599CD]  DEFAULT ((0)) FOR [ChildLevel]
END 