IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0296]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0296]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- LOAD DANH MỤC TỜ KHAI THUẾ BẢO VỆ MÔI TRƯỜNG
-- <History>
---- Create on 03/04/2015 by Lê Thị Hạnh 
-- <Example>
/*
AP0296 @DivisionID = 'SEC', @FromMonth = 2, @FromYear = 2014, @ToMonth = 04, @ToYear = 2015, 
@FromDate = '2014-04-07 00:00:00.000', @ToDate = '2015-12-12',@IsDate = 0, @UserID = ''
*/


CREATE PROCEDURE [dbo].[AP0296] 	
	@DivisionID NVARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT,
	@UserID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWHERE NVARCHAR(MAX) = ''

IF LTRIM(STR(@IsDate)) = 1	SET @sWHERE = @sWHERE + '
	AND (CASE WHEN ISNULL(AT96.IsPeriodTax,0) = 0 THEN CONVERT(VARCHAR(10),AT96.TaxReturnDate,112) ELSE NULL END) 
	BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
IF LTRIM(STR(@IsDate)) = 0	SET @sWHERE = @sWHERE + '
	AND (CASE WHEN ISNULL(AT96.IsPeriodTax,0) = 1 THEN (AT96.TranYearTax*12 + AT96.TranMonthTax)  
			  WHEN ISNULL(AT96.IsPeriodTax,0) = 0 THEN (YEAR(AT96.TaxReturnDate)*12 + MONTH(AT96.TaxReturnDate))
			  ELSE 0 END)
		BETWEEN '+LTRIM(STR(@FromYear*12 + @FromMonth))+' AND '+LTRIM(STR(@ToYear*12 + @ToMonth))+' '
SET @sSQL1 = '
SELECT AT96.DivisionID, AT96.VoucherID, AT96.TaxReturnID, AT96.TaxReturnName, 
	   AT96.TranMonthTax, AT96.TranYearTax, ISNULL(AT96.IsPeriodTax,0) AS IsPeriodTax, 
	   CASE WHEN ISNULL(AT96.IsPeriodTax,0) = 0 THEN AT96.TaxReturnDate ELSE NULL END TaxReturnDate,
	   ISNULL(AT96.ReturnTime,0) AS ReturnTime, 
	   AT34.ReportCode, AT34.ReportName, AT96.ReportVoucherID, AT34.ReportID,
	   AT34.ReportTitle,AT96.TaxAgentPeron, AT96.TaxAgentCertificate,
	   AT96.TaxReturnPerson, AT96.TaxAssignDate
FROM AT0296 AT96
LEFT JOIN AT0304 AT34 ON AT34.DivisionID = AT96.DivisionID AND AT34.VoucherID = AT96.ReportVoucherID 
WHERE AT96.DivisionID = '''+@DivisionID+''' '+@sWHERE+'
ORDER BY AT96.IsPeriodTax DESC, AT96.TranYear, AT96.TranMonth, TaxReturnDate, AT96.ReturnTime
'
EXEC (@sSQL1)
PRINT (@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

