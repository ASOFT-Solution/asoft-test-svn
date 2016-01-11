-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1618]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1618](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[InProcessDetailID] [nvarchar](50) NOT NULL,
	[InProcessID] [nvarchar](50) NULL,
	[ExpenseID] [nvarchar](50) NULL,
	[MaterialTypeID] [nvarchar](50) NULL,
	[EndMethodID] [nvarchar](50) NULL,
	[IsUsed] [tinyint] NULL,
	[ApportionID] [nvarchar](50) NULL,
 CONSTRAINT [PK_MT1618] PRIMARY KEY NONCLUSTERED 
(
	[InProcessDetailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
