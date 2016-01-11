-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1015]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1015](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ProductID] [nvarchar](50) NOT NULL,
	[ProductName] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[MethodID] [tinyint] NOT NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[ProductTypeID] [nvarchar](50) NULL,
	[Orders] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	CONSTRAINT [PK_HT1015] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1015_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1015] ADD  CONSTRAINT [DF_HT1015_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1015_MethodID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1015] ADD  CONSTRAINT [DF_HT1015_MethodID]  DEFAULT ((0)) FOR [MethodID]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1015_Orders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1015] ADD  CONSTRAINT [DF_HT1015_Orders]  DEFAULT ((0)) FOR [Orders]
END

