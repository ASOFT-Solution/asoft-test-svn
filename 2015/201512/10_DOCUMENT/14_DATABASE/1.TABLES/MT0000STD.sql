-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0000STD]') AND type in (N'U'))
CREATE TABLE [dbo].[MT0000STD](
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[PeriodID] [nvarchar](50) NULL,
	[DistributionID] [nvarchar](50) NULL,
	[InProcessID] [nvarchar](50) NULL,
	[OriginalDecimal] [tinyint] NULL,
	[ConvertDecimal] [tinyint] NULL,
	[UnitPriceDecimal] [tinyint] NULL,
	[PercentDecimal] [tinyint] NULL,
	[QuantityDecimal] [tinyint] NULL,
	[MaterialAccountID] [nvarchar](50) NULL,
	[HumanAccountID] [nvarchar](50) NULL,
	[OtherAccountID] [nvarchar](50) NULL,
	[InprocessAccountID] [nvarchar](50) NULL,
	[IsWork] [tinyint] NULL,
	[IsConvertUnit] [tinyint] NOT NULL
) ON [PRIMARY]
