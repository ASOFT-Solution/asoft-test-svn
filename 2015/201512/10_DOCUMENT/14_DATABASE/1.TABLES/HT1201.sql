-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1201]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1201](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[AbsentTypeDateID] [nvarchar](50) NOT NULL,
	[AbsentTypeDateName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[YNInsSocial] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[IncreaseAbsent] [tinyint] NULL,
	[Orders] [tinyint] NULL,
	[LeaveBase] [nvarchar](50) NULL,
	[IsLunch] [tinyint] NOT NULL,
	[Unit] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT1201] PRIMARY KEY NONCLUSTERED 
(
	[AbsentTypeDateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1201_IncreaseAbsent]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1201] ADD  CONSTRAINT [DF_HT1201_IncreaseAbsent]  DEFAULT ((0)) FOR [IncreaseAbsent]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1201_Orders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1201] ADD  CONSTRAINT [DF_HT1201_Orders]  DEFAULT ((0)) FOR [Orders]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1201_IsLunch]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1201] ADD  CONSTRAINT [DF_HT1201_IsLunch]  DEFAULT ((0)) FOR [IsLunch]
END
