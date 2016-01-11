-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1020]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1020](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ShiftID] [nvarchar](50) NOT NULL,
	[ShiftName] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[RestrictID] [nvarchar](50) NULL,
	[BeginTime] [nvarchar](100) NULL,
	[EndTime] [nvarchar](100) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Orders] [tinyint] NULL,
	[WorkingTime] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT1020] PRIMARY KEY NONCLUSTERED 
(
	[ShiftID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1020_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1020] ADD  CONSTRAINT [DF_HT1020_Disabled]  DEFAULT ((0)) FOR [Disabled]
END