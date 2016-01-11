-- <Summary>
---- 
-- <History>
---- Create on 04/09/2015 by Tiểu Mai
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0008STD]') AND type in (N'U'))
CREATE TABLE [dbo].[MT0008STD](
	[TypeID] [nvarchar](50) NOT NULL,
	[SystemName] [nvarchar](250) NULL,
	[UserName] [nvarchar](250) NULL,
	[IsUsed] [tinyint] NOT NULL,
	[UserNameE] [nvarchar](250) NULL,
	SystemNameE NVARCHAR(50) NULL
) ON [PRIMARY]
