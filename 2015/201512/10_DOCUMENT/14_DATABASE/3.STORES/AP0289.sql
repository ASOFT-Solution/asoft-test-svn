IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0289]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0289]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- IN BÁO CÁO TỜ KHAI THUẾ BẢO VỆ MÔI TRƯỜNG
-- <History>
---- Create on 07/10/2014 by Lê Thị Hạnh 
---- Modified on 20/03/2015 by Lê Thị Hạnh: Cập nhật cách lấy dữ liệu - T94
---- Modified on 30/03/2015 by Mai Trí Thiện: Load thêm trường ETaxTotal (ETaxQuantity * ETaxAmount)
---- Modified on 03/04/2015 by Lê Thị Hạnh: Cập nhật cách lấy dữ liệu cho tờ khai - T94
-- <Example>
-- AP0289 @DivisionID = 'vg', @TranMonth = 1, @TranYear = 2015, @PrintDate = '2014-10-07', @IsPeriodTax = 1, @VoucherID = '8C16B896-E84C-47C1-8E64-1FE3A0FAF813'

CREATE PROCEDURE [dbo].[AP0289] 	
	@DivisionID NVARCHAR(50),
	@TranMonth INT,
	@TranYear INT,	
	@PrintDate DATETIME,
	@IsPeriodTax TINYINT,
	@VoucherID NVARCHAR(50) -- VoucherID của dạng báo cáo
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWHERE NVARCHAR(MAX) = ''

IF LTRIM(STR(ISNULL(@IsPeriodTax,0))) = 0	SET @sWHERE = @sWHERE + '
	AND CONVERT(VARCHAR(10),AT90.VoucherDate,112) = '''+CONVERT(VARCHAR(10),@PrintDate,112)+''' '
IF LTRIM(STR(ISNULL(@IsPeriodTax,0))) = 1	SET @sWHERE = @sWHERE + '
	AND (AT90.TranYear*12 + AT90.TranMonth) = '+LTRIM(STR(@TranYear*12 + @TranMonth))+' '
	
SET @sSQL1 = '
SELECT AT11.DivisionName, AT11.Tel, AT11.Fax, AT11.Email, AT11.[Address],
       AT11.VATNO, AT11.DivisionNameE, AT11.AddressE, AT11.City, AT11.District,
	   AT35.ETaxID, AT93.ETaxName, AT93.UnitID, ISNULL(AT95.ETaxAmount,0) AS ETaxAmount,
	   SUM(ISNULL(AT90.Quantity,0)*ISNULL(AT90.ETaxConvertedUnit,0)) AS ETaxQuantity,
	   SUM(ISNULL(AT90.ETaxConvertedAmount,0)) AS ETaxConvertedAmount,
	   SUM(ISNULL(AT90.Quantity,0)*ISNULL(AT90.ETaxConvertedUnit,0)) * ISNULL(AT95.ETaxAmount,0) ETaxTotal
FROM AT0304 AT34
INNER JOIN AT0305 AT35 ON AT35.DivisionID = AT34.DivisionID AND AT35.VoucherID = AT34.VoucherID
LEFT JOIN AT9000 AT90 ON AT90.DivisionID = AT34.DivisionID AND AT90.TransactionTypeID = ''T94''
      AND AT90.ETaxID = AT35.ETaxID AND AT90.ETaxVoucherID = AT34.ETaxVoucherID '+@sWHERE+'
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = AT90.DivisionID AND AT13.InventoryID = AT90.InventoryID
LEFT JOIN AT0295 AT95 ON AT95.VoucherID = AT34.ETaxVoucherID AND AT95.ETaxID = AT35.ETaxID
LEFT JOIN AT0293 AT93 ON AT93.ETaxID = AT35.ETaxID
LEFT JOIN AT1101 AT11 ON AT11.DivisionID = AT34.DivisionID
WHERE AT34.DivisionID = '''+@DivisionID+''' AND AT34.VoucherID = '''+@VoucherID+'''
GROUP BY AT11.DivisionName, AT11.Tel, AT11.Fax, AT11.Email, AT11.[Address],
       AT11.VATNO, AT11.DivisionNameE, AT11.AddressE, AT11.City, AT11.District,
	   AT35.ETaxID, AT93.ETaxName, AT93.UnitID, AT95.ETaxAmount
'
EXEC (@sSQL1)
--PRINT @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

