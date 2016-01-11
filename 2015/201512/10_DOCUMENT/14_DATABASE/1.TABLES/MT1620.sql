-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1620]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1620](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ExpenseID] [nvarchar](50) NOT NULL,
	[ExpenseName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NULL,
	[Language] [nvarchar](50) NULL,
 CONSTRAINT [PK_MT1620] PRIMARY KEY NONCLUSTERED 
(
	[ExpenseID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
