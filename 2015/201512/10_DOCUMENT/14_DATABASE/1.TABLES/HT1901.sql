-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1901]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1901](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ProducingProcessID] [nvarchar](50) NOT NULL,
	[StepID] [nvarchar](50) NOT NULL,
	[StepName] [nvarchar](250) NOT NULL,
	[StepKey] [nvarchar](250) NOT NULL,
	[StepOrder] [int] NOT NULL,
	[StepLevel] [int] NULL,
	[ParentStepID] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT19012] PRIMARY KEY NONCLUSTERED 
(
	[ProducingProcessID] ASC,
	[StepID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT1901__StepOrde__117F0407]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1901] ADD  CONSTRAINT [DF__HT1901__StepOrde__117F0407]  DEFAULT ((0)) FOR [StepOrder]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT1901__StepLeve__12732840]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1901] ADD  CONSTRAINT [DF__HT1901__StepLeve__12732840]  DEFAULT ((0)) FOR [StepLevel]
END