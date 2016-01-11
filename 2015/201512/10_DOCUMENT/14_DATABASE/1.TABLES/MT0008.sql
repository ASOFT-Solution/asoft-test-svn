-- <Summary>
---- 
-- <History>
---- Create on 04/09/2015 by Tiểu Mai
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0008]') AND type in (N'U'))
CREATE TABLE [dbo].[MT0008](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TypeID] [nvarchar](50) NOT NULL,
	[SystemName] [nvarchar](250) NULL,
	SystemNameE NVARCHAR(50) NULL,
	[UserName] [nvarchar](250) NULL,
	[IsUsed] [tinyint] NOT NULL,
	[UserNameE] [nvarchar](250) NULL,
 CONSTRAINT [PK_MT0008] PRIMARY KEY CLUSTERED 
(
	[TypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT0008_IsUsed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0008] ADD  CONSTRAINT [DF_MT0008_IsUsed]  DEFAULT ((1)) FOR [IsUsed]
END
