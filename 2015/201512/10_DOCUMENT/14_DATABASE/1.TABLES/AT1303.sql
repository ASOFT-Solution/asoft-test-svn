-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1303]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1303](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[WareHouseID] [nvarchar](50) NOT NULL,
	[WareHouseName] [nvarchar](250) NULL,	
	[Address] [nvarchar](250) NULL,
	[FullName] [nvarchar](250) NULL,
	[IsTemp] [tinyint] NOT NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1303] PRIMARY KEY NONCLUSTERED 
(
	[WareHouseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1303_IsTemp]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1303] ADD CONSTRAINT [DF_AT1303_IsTemp] DEFAULT ((0)) FOR [IsTemp]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1303_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1303] ADD CONSTRAINT [DF_AT1303_Disabled] DEFAULT ((0)) FOR [Disabled]
END