-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0699STD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MT0699STD](
	[MaterialTypeID] [nvarchar](50) NOT NULL,
	[ExpenseID] [nvarchar](50) NOT NULL,
	[IsUsed] [tinyint] NOT NULL,
	[SystemName] [nvarchar](250) NULL,
	[UserName] [nvarchar](250) NULL
) ON [PRIMARY]
END
