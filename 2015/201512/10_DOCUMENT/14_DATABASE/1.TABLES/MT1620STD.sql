-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1620STD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MT1620STD](
	[ExpenseID] [nvarchar](50) NOT NULL,
	[ExpenseName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NULL,
	[Language] [nvarchar](50) NULL
) ON [PRIMARY]
END