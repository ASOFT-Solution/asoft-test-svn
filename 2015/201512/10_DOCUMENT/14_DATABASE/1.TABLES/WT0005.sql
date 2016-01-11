-- <Summary>
---- 
-- <History>
---- Create on 05/02/2013 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WT0005]') AND type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[WT0005](
			[APK] [uniqueidentifier] DEFAULT NEWID(),
			[DivisionID] nvarchar(3) NOT NULL,
			[TypeID] [nvarchar](50) NOT NULL,
			[SystemName] [nvarchar](250) NULL,
			[UserName] [nvarchar](250) NULL,
			[IsUsed] [tinyint] NOT NULL,
			[UserNameE] [nvarchar](250) NULL,
			[SystemNameE] [nvarchar](250) NULL,
		 CONSTRAINT [PK_WT0005] PRIMARY KEY CLUSTERED 
		(
			[APK] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]	
	END
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_WT0005_IsUsed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[WT0005] ADD  CONSTRAINT [DF_WT0005_IsUsed]  DEFAULT ((1)) FOR [IsUsed]
END
