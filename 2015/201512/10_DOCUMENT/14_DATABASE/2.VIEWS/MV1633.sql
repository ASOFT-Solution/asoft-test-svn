/****** Object:  View [dbo].[MV1633]    Script Date: 12/21/2010 13:55:28 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[MV1633]'))
DROP VIEW [dbo].[MV1633]
GO

/****** Object:  View [dbo].[MV1633]    Script Date: 12/21/2010 13:55:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MV1633] as
Select 	
	DivisionID,
	null as PeriodID,
	ProductID,
	MaterialID,
	ExpenseID,
	MT1633.MaterialTypeID,
	Sum(QuantityUnit) as QuantityUnit,sum(ConvertedUnit) as ConvertedUnit
From MT1633
Group by DivisionID, ProductID,ExpenseID,MaterialTypeID,MaterialID

GO


