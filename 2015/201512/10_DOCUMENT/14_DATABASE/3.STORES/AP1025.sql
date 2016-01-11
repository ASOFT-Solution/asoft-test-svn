IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1025]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1025]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load Danh mục hợp đồng màn hình CF0096
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 23/03/2015
---- Modified on 
-- <Example>
/*
	 AP1025 'LG', '', '2015-01-01 00:00:00', '2015-03-01 00:00:00', 1, 1, 1
*/

 CREATE PROCEDURE AP1025
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@FromDate DATETIME,
	@ToDate DATETIME,
	@All TINYINT,
	@ContractType TINYINT,
	@DisplayAll TINYINT
)
AS
SELECT * FROM
(
	SELECT A20.ContractID, A20.DivisionID, A20.ContractNo, A20.SignDate, A20.ContractName,
		PaymentStatus = MAX(PaymentStatus), A20.ObjectID, A02.ObjectName, A20.BeginDate,
		A20.EndDate, A20.ExchangeRate, A20.ConvertedAmount, A20.Amount, A20.CurrencyID, A04.ExchangeRateDecimal,
		A20.ConRef01, A20.ConRef02, A20.ConRef03, A20.ConRef04, A20.ConRef05,
		A20.ConRef06, A20.ConRef07, A20.ConRef08, A20.ConRef09, A20.ConRef10
	FROM AT1020 A20
	LEFT JOIN AT1004 A04 ON A04.DivisionID = A20.DivisionID AND A04.CurrencyID = A20.CurrencyID
	LEFT JOIN AT1202 A02 ON A20.ObjectID = A02.ObjectID AND A20.DivisionID = A02.DivisionID
    LEFT JOIN AT1021 ON AT1021.ContractID = A20.ContractID AND AT1021.DivisionID = A20.DivisionID
	WHERE A20.DivisionID = @DivisionID
	AND (@All = 1 OR (CONVERT(VARCHAR, A20.SignDate, 112) BETWEEN CONVERT(VARCHAR, @FromDate,112) AND CONVERT(VARCHAR, @ToDate,112)))
	AND (A20.ContractType = @ContractType OR @ContractType = 2)
    GROUP BY A20.ContractID, A20.DivisionID, A20.ContractNo, A20.SignDate, A20.ContractName, A20.ObjectID, A02.ObjectName,
    A20.BeginDate, A20.EndDate, A20.ExchangeRate, A20.ConvertedAmount, A20.Amount, A20.CurrencyID, A04.ExchangeRateDecimal,
    A20.ConRef01, A20.ConRef02, A20.ConRef03, A20.ConRef04, A20.ConRef05, A20.ConRef06, A20.ConRef07, A20.ConRef08, A20.ConRef09, A20.ConRef10
) A
WHERE (@DisplayAll = 1 OR ISNULL(PaymentStatus,0) = 0)

IF ISNULL((SELECT TOP 1 CustomerName FROM CustomerIndex),-1) = 40 ---- Customize cho LONG GIANG
BEGIN
	IF EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT1020LONGGIANG]') AND TYPE IN (N'U')) DROP TABLE AT1020LONGGIANG
	CREATE TABLE AT1020LONGGIANG (FromDate DATETIME, ToDate DATETIME, [All] TINYINT, ContractType TINYINT, DisplayAll TINYINT)
	INSERT INTO AT1020LONGGIANG (FromDate, ToDate, [All], ContractType, DisplayAll)
	VALUES (@FromDate, @ToDate, @All, @ContractType, @DisplayAll)
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
