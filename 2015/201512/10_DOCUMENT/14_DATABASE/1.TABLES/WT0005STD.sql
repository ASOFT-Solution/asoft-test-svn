-- <Summary>
---- 
-- <History>
---- Create on 05/02/2013 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WT0005STD]') AND type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[WT0005STD](
			[TypeID] [nvarchar](50) NOT NULL,
			[SystemName] [nvarchar](250) NULL,
			[UserName] [nvarchar](250) NULL,
			[IsUsed] [tinyint] NOT NULL,
			[UserNameE] [nvarchar](250) NULL,
			[SystemNameE] [nvarchar](250) NULL
		) ON [PRIMARY]
	END

