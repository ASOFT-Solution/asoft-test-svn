IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0312]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0312]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load danh sách kết quả phân bổ chi phí mua hàng - Phân bổ chi phí mua hàng[Customize LAVO]
-- <History>
---- Create on 03/03/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
 exec AP0312 @DivisionID = 'LV', @FromMonth=01,@FromYear=2015,@ToMonth=03,@ToYear=2015, 
 @FromDate = '2015-01-01', @ToDate = '2015-03-10', @IsDate = 0, @CurrencyID = '%', @ObjectID = '%'
 */

CREATE PROCEDURE [dbo].[AP0312] 	
	@DivisionID NVARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,	
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT,
	@CurrencyID NVARCHAR(50),
	@ObjectID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX) = '',
		@sWHERE NVARCHAR(MAX) = ''

IF LTRIM((@IsDate)) = 1	SET @sWHERE = @sWHERE + '
AND CONVERT(VARCHAR(10),AT20.VoucherDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
IF LTRIM((@IsDate)) = 0	SET @sWHERE = @sWHERE + '
AND (AT20.TranYear*12 + AT20.TranMonth) BETWEEN '+LTRIM((@FromYear*12 + @FromMonth))+' AND '+LTRIM((@ToYear*12 + @ToMonth))+' '

SET @sSQL1 = '
SELECT DISTINCT AT20.DivisionID, AT20.VoucherID, AT20.TranMonth, AT20.TranYear,
       AT20.VoucherTypeID, AT20.VoucherNo, AT20.VoucherDate, AT20.EmployeeID,
       CASE WHEN ISNULL(AT20.ApportMethod,0) = 1 THEN ''Q''
			WHEN ISNULL(AT20.ApportMethod,0) = 2 THEN ''A''
			ELSE '''' END AS ApportMethod, 
       AT20.[Description] 
FROM AT0320 AT20
INNER JOIN AT0321 AT21 ON AT21.DivisionID = AT20.DivisionID AND AT21.VoucherID = AT20.VoucherID
LEFT JOIN AT9000 AT90 ON AT90.DivisionID = AT20.DivisionID AND AT90.VoucherID = AT21.POVoucherID AND AT90.TransactionID = AT21.POTransactionID
LEFT JOIN AT9000 AT09 ON AT09.DivisionID = AT20.DivisionID AND AT09.VoucherID = AT21.POCVoucherID
WHERE AT20.DivisionID = '''+@DivisionID+''' AND
	  (AT90.CurrencyID LIKE '''+@CurrencyID+''' OR AT09.CurrencyID LIKE '''+@CurrencyID+''') AND 
	  (ISNULL(AT90.ObjectID,'''') LIKE '''+@ObjectID+''' OR 
	   ISNULL((CASE WHEN AT90.TransactionTypeID = ''T99'' THEN AT90.CreditObjectID ELSE AT09.ObjectID END),'''') LIKE '''+@ObjectID+''' )
	   '+@sWHERE+'
ORDER BY AT20.DivisionID, AT20.TranYear, AT20.TranMonth, AT20.VoucherDate, AT20.VoucherNo
'

EXEC (@sSQL1)
--PRINT @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
