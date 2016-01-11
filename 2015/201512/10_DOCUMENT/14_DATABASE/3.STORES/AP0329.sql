IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0329]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0329]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- LOAD DANH MỤC TỜ KHAI THUẾ Tài nguyên - AF0311-12-13
-- <History>
---- Create on 02/06/2015 by Lê Thị Hạnh 
-- <Example>
/*
AP0329 @DivisionID = 'VG', @FromYear = 2014, @ToYear = 2015, 
@FromDate = '2015-05-01 00:00:00.000', @ToDate = '2015-05-31',@IsDate = 0, @UserID = ''
*/

CREATE PROCEDURE [dbo].[AP0329] 	
	@DivisionID NVARCHAR(50),
	@FromYear INT,
	@ToYear INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT, -- 1: ngày, 0: theo năm
	@UserID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWHERE NVARCHAR(MAX) = '',
		@EndPre INT =0,
		@StartPre INT= 0

		SELECT @StartPre = @FromYear * 10 + MONTH(StartDate), @EndPre = @ToYear* 10 + MONTH(EndDate) FROM AT1101 WHERE DivisionID = @DivisionID

IF LTRIM(STR(@IsDate)) = 1	SET @sWHERE = @sWHERE + '
	AND (((CASE WHEN ISNULL(AT30.NRTTypeID,0) = 2 AND ISNULL(AT30.IsPeriodTax,0) = 1 THEN (AT30.TranYearTax*12 + AT30.TranMonthTax) ELSE 0 END) 
		 BETWEEN LTRIM(YEAR('''+CONVERT(VARCHAR(10),@FromDate,112)+'''))*12 + LTRIM(MONTH('''+CONVERT(VARCHAR(10),@FromDate,112)+''')) 
				AND LTRIM(YEAR('''+CONVERT(VARCHAR(10),@ToDate,112)+'''))*12 + LTRIM(MONTH('''+CONVERT(VARCHAR(10),@ToDate,112)+''')))
		OR((
		CASE WHEN ISNULL(AT30.NRTTypeID,0) = 2 AND ISNULL(AT30.IsPeriodTax,0) = 0 THEN CONVERT(VARCHAR(10),AT30.TaxReturnDate,112) ELSE NULL END) 
		 BETWEEN'''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+'''
		)
		OR((
		(CASE WHEN ISNULL(AT30.NRTTypeID,0) = 1 THEN (AT30.FromYearTax*12 + AT30.FromMonthTax) ELSE 0 END) 
		 BETWEEN LTRIM(YEAR('''+CONVERT(VARCHAR(10),@FromDate,112)+'''))*12 + LTRIM(MONTH('''+CONVERT(VARCHAR(10),@FromDate,112)+''')) 
				AND LTRIM(YEAR('''+CONVERT(VARCHAR(10),@ToDate,112)+'''))*12 + LTRIM(MONTH('''+CONVERT(VARCHAR(10),@ToDate,112)+''')))
		 OR (
		 (CASE WHEN ISNULL(AT30.NRTTypeID,0) = 1 THEN (AT30.ToYearTax*12 + AT30.ToMonthTax) ELSE 0 END) 
		 BETWEEN LTRIM(YEAR('''+CONVERT(VARCHAR(10),@FromDate,112)+'''))*12 + LTRIM(MONTH('''+CONVERT(VARCHAR(10),@FromDate,112)+''')) 
				AND LTRIM(YEAR('''+CONVERT(VARCHAR(10),@ToDate,112)+'''))*12 + LTRIM(MONTH('''+CONVERT(VARCHAR(10),@ToDate,112)+''')))
		))'
IF LTRIM(STR(@IsDate)) = 0	SET @sWHERE = @sWHERE + '
	AND( ((CASE WHEN ISNULL(AT30.NRTTypeID,0) = 2 AND ISNULL(AT30.IsPeriodTax,0) = 1 THEN AT30.TranYearTax * 10 + AT30.TranMonthTax
		     WHEN ISNULL(AT30.NRTTypeID,0) = 2 AND ISNULL(AT30.IsPeriodTax,0) = 0 THEN YEAR(TaxReturnDate) *10 + MONTH(TaxReturnDate)
			 WHEN ISNULL(AT30.NRTTypeID,0) = 1 THEN  AT30.FromYearTax*10 + AT30.FromMonthTax
			 ELSE 0 END)
		BETWEEN '+CAST(@StartPre AS VARCHAR)+' AND '+CAST(@EndPre AS VARCHAR)+') 
		 OR (CASE WHEN ISNULL(AT30.NRTTypeID,0) = 1 THEN (AT30.ToYearTax*10 + AT30.ToMonthTax) ELSE 0 END
				BETWEEN '+CAST(@StartPre AS VARCHAR)+' AND '+CAST(@EndPre AS VARCHAR)+') ) '
SET @sSQL1 = '
SELECT AT30.DivisionID, AT30.VoucherID, AT30.TaxReturnID, AT30.TranMonthTax, AT30.TranYearTax, 
	   ISNULL(AT30.IsPeriodTax,0) AS IsPeriodTax, 
	   CASE WHEN ISNULL(AT30.IsPeriodTax,0) = 0 THEN AT30.TaxReturnDate ELSE NULL END TaxReturnDate,
	   ISNULL(AT30.ReturnTime,0) AS ReturnTime, AT30.PrintDate, AT30.CreateDate, 
	   AT30.TaxAgentPeron, AT30.TaxAgentCertificate, AT30.TaxReturnPerson, AT30.TaxAssignDate,
	   ISNULL(AT30.NRTTypeID,0) AS NRTTypeID,
	   ISNULL(AT30.OriginalAmount,0) AS OriginalAmount,
	   ISNULL(AT30.ConvertedAmount,0) AS ConvertedAmount,
	   ISNULL(AT30.DeductNRTOriAmount,0) AS DeductNRTOriAmount,
	   ISNULL(AT30.DeductNRTConAmount,0) AS DeductibleNRT,
	   ISNULL(AT30.DeclareNRTOriAmount,0) AS DeclareNRTOriAmount,
	   ISNULL(AT30.DeclareNRTConAmount,0) AS DeclarationNRT	   
FROM AT0310 AT30
WHERE AT30.DivisionID = '''+@DivisionID+''' '+@sWHERE+'
ORDER BY ISNULL(AT30.NRTTypeID,0), AT30.IsPeriodTax DESC, AT30.TranYear, AT30.TranMonth, AT30.TaxReturnDate, AT30.ReturnTime
'
EXEC (@sSQL1)
PRINT (@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

