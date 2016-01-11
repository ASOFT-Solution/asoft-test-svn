IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0322]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0322]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- LOAD DANH MỤC TỜ KHAI THUẾ TIÊU THỤ ĐẶC BIỆT - AF0309
-- <History>
---- Create on 29/05/2015 by Lê Thị Hạnh 
-- <Example>
/*
AP0322 @DivisionID = 'VG', @FromMonth = 1, @FromYear = 2014, @ToMonth = 05, @ToYear = 2015, 
@FromDate = '2015-05-01 00:00:00.000', @ToDate = '2015-05-31',@IsDate = 0, @UserID = ''
*/

CREATE PROCEDURE [dbo].[AP0322] 	
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
	AND (CASE WHEN ISNULL(AT39.IsPeriodTax,0) = 0 THEN CONVERT(VARCHAR(10),AT39.TaxReturnDate,112) ELSE NULL END) 
	BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
IF LTRIM(STR(@IsDate)) = 0	SET @sWHERE = @sWHERE + '
	AND (CASE WHEN ISNULL(AT39.IsPeriodTax,0) = 1 THEN (AT39.TranYearTax*12 + AT39.TranMonthTax)  
			  WHEN ISNULL(AT39.IsPeriodTax,0) = 0 THEN (YEAR(AT39.TaxReturnDate)*12 + MONTH(AT39.TaxReturnDate))
			  ELSE 0 END)
		BETWEEN '+LTRIM(STR(@FromYear*12 + @FromMonth))+' AND '+LTRIM(STR(@ToYear*12 + @ToMonth))+' '
SET @sSQL1 = '
SELECT AT39.DivisionID, AT39.VoucherID, AT39.TaxReturnID, AT39.TranMonthTax, AT39.TranYearTax, 
	   ISNULL(AT39.IsPeriodTax,0) AS IsPeriodTax, 
	   CASE WHEN ISNULL(AT39.IsPeriodTax,0) = 0 THEN AT39.TaxReturnDate ELSE NULL END TaxReturnDate,
	   ISNULL(AT39.ReturnTime,0) AS ReturnTime, AT39.PrintDate, AT39.CreateDate, 
	   AT39.TaxAgentPeron, AT39.TaxAgentCertificate, AT39.TaxReturnPerson, AT39.TaxAssignDate,
	   ISNULL(AT39.IsSETIncur,0) AS IsSETIncur,
	   ISNULL(AT39.OriginalAmount,0) AS OriginalAmount,
	   ISNULL(AT39.ConvertedAmount,0) AS ConvertedAmount,
	   ISNULL(AT39.DeductSETOriAmount,0) AS DeductSETOriAmount,
	   ISNULL(AT39.DeductSETConAmount,0) AS DeductibleSET,
	   ISNULL(AT39.DeclareSETOriAmount,0) AS DeclareSETOriAmount,
	   ISNULL(AT39.DeclareSETConAmount,0) AS DeclarationSET	   
FROM AT0309 AT39
WHERE AT39.DivisionID = '''+@DivisionID+''' '+@sWHERE+'
ORDER BY AT39.IsPeriodTax DESC, AT39.TranYear, AT39.TranMonth, AT39.TaxReturnDate, AT39.ReturnTime
'
EXEC (@sSQL1)
PRINT (@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

