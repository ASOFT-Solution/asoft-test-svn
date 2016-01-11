-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1610]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1610](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ExpenseID] [nvarchar](50) NOT NULL,
	[MaterialTypeID] [nvarchar](50) NOT NULL,
	[PeriodID] [nvarchar](50) NOT NULL,
	[IsUse] [tinyint] NOT NULL,
 CONSTRAINT [PK_MT1610] PRIMARY KEY NONCLUSTERED 
(
	[ExpenseID] ASC,
	[MaterialTypeID] ASC,
	[PeriodID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1610_IsUse]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1610] ADD  CONSTRAINT [DF_MT1610_IsUse]  DEFAULT ((0)) FOR [IsUse]
END