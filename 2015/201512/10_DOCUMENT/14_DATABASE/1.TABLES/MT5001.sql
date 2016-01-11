-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT5001]') AND type in (N'U'))
CREATE TABLE [dbo].[MT5001](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[DeDistributionID] [nvarchar](50) NOT NULL,
	[DistributionID] [nvarchar](50) NULL,
	[ExpenseID] [nvarchar](50) NOT NULL,
	[MaterialTypeID] [nvarchar](50) NULL,
	[MethodID] [nvarchar](50) NULL,
	[CoefficientID] [nvarchar](50) NULL,
	[ApportionID] [nvarchar](50) NULL,
	[IsDistributed] [tinyint] NOT NULL,
 CONSTRAINT [PK_MT5001] PRIMARY KEY NONCLUSTERED 
(
	[DeDistributionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT5001_IsDistribute]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT5001] ADD  CONSTRAINT [DF_MT5001_IsDistribute]  DEFAULT ((1)) FOR [IsDistributed]
END