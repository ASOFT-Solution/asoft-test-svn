-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0699]') AND type in (N'U'))
CREATE TABLE [dbo].[MT0699](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[MaterialTypeID] [nvarchar](50) NOT NULL,
	[ExpenseID] [nvarchar](50) NOT NULL,
	[IsUsed] [tinyint] NOT NULL,
	[SystemName] [nvarchar](250) NULL,
	[UserName] [nvarchar](250) NULL,
 CONSTRAINT [PK_MT0699] PRIMARY KEY NONCLUSTERED 
(
	[MaterialTypeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT0699_IsUser]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT0699] ADD  CONSTRAINT [DF_MT0699_IsUser]  DEFAULT ((0)) FOR [IsUsed]
END
