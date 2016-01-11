-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1634]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1634](
	[ProductID] [nvarchar](50) NULL,
	[PeriodID] [nvarchar](50) NULL,
	[FixProductID] [nvarchar](50) NULL,
	[QuantityUnit] [decimal](28, 8) NULL,
	[ConvertedUnit] [decimal](28, 8) NULL
) ON [PRIMARY]
