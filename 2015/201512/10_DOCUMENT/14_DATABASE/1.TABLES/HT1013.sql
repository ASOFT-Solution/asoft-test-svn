-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>


GO

/****** Object:  Table [dbo].[HT1013]    Script Date: 07/22/2010 15:39:06 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1013]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1013](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[AbsentTypeID] [nvarchar](50) NOT NULL,
	[AbsentName] [nvarchar](250) NULL,
	[UnitID] [nvarchar](50) NULL,
	[IsMonth] [tinyint] NULL,
	[ConvertUnit] [decimal](28, 8) NULL,
	[TypeID] [nvarchar](50) NULL,
	[IsTransfer] [tinyint] NULL,
	[ParentID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[IsSystem] [tinyint] NOT NULL,
	[Disabled] [tinyint] NOT NULL,
	[MaxValue] [decimal](28, 8) NULL,
	[Orders] [tinyint] NULL,
	[Caption] [nvarchar](250) NULL,
 CONSTRAINT [PK_HT1013] PRIMARY KEY NONCLUSTERED 
(
	[AbsentTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[HT1013]    Script Date: 07/22/2010 15:39:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---- Add giá trị defauult
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1013_IsSystem]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1013] ADD  CONSTRAINT [DF_HT1013_IsSystem]  DEFAULT ((0)) FOR [IsSystem]
END
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1013_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1013] ADD  CONSTRAINT [DF_HT1013_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT1013' and xtype ='U') 
Begin      
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1013'  and col.name = 'IsCondition')
       Alter Table  HT1013 Add IsCondition tinyint Null Default(0)       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1013'  and col.name = 'ConditionCode')
       Alter Table  HT1013 Add ConditionCode nvarchar(4000) Null
End
