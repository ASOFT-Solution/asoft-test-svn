IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP8000]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP8000]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
---  Load tờ khai 05-1BK-TNCN
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on 01/04/2015
---- Modified by:
-- <Example>
/*
	 HP8000 'VK', '', 2014
*/
				
 CREATE PROCEDURE HP8000
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT
)
AS

SELECT H38.EmployeeID, V40.FullName, V40.PersonalTaxID, V40.IdentifyCardNo, 0 IsDeputize, SUM(H38.TotalAmount) TotalAmount,
	NULL WorkInEconomicZones, NULL WorkWithPact, H38.TaxReducedAmount, NULL CharHumEduTotal, NULL Insuarance, NULL Retirement,
	SUM(H38.TotalAmount) TaxAmount, SUM(H38.IncomeAmount) IncomeAmount, NULL TaxExcessAmount, NULL RemainTaxAmount
FROM HT0338 H38
	INNER JOIN HV1400 V40 ON H38.DivisionID = V40.DivisionID AND H38.EmployeeID = V40.EmployeeID
WHERE H38.DivisionID = @DivisionID AND TranMonth + TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100
	AND H38.EmployeeID IN 
		(
			SELECT HT1360.EmployeeID FROM HT1360
				INNER JOIN HT1105 ON HT1360.DivisionID = HT1105.DivisionID AND HT1360.ContractTypeID = HT1105.ContractTypeID
			WHERE HT1360.DivisionID = H38.DivisionID AND (HT1105.Months >= 3 OR HT1105.Months = 0)
				AND MONTH(DATEADD(MONTH,HT1105.Months,HT1360.SignDate)) + YEAR(DATEADD(MONTH, HT1105.Months, HT1360.SignDate)) * 100 >= 1 + @FromMonth + @FromYear * 100
		) 
	AND V40.CountryID = 'VN'
GROUP BY H38.EmployeeID, V40.FullName, V40.IdentifyCardNo, H38.TaxReducedAmount, V40.PersonalTaxID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
