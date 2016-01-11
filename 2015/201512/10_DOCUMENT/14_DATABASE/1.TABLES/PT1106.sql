-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PT1106]') AND type in (N'U'))
CREATE TABLE [dbo].[PT1106](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[StyleGroupID] [nvarchar](50) NOT NULL,
	[StyleGroupName] [nvarchar](250) NOT NULL,
	[PaletteID] [nvarchar](50) NULL,
	[SalaryPrice] [decimal](28, 8) NULL,
	[StopTime] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_PT1106] PRIMARY KEY CLUSTERED 
(
	[StyleGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PT1106_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PT1106] ADD  CONSTRAINT [DF_PT1106_Disabled]  DEFAULT ((0)) FOR [Disabled]
END