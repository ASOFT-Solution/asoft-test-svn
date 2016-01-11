IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0130]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0130]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- IN BÁO CÁO ĐẶC THÙ "BÁO CÁO THEO DÕI CHIẾT KHẤU" [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 01/10/2014 by Lê Thị Hạnh 
---- Modified on ... by 
---- Modified Lê Thị Hạnh on 16/10/2014 by : Cách tính chiết khấu thực tế lấy từ đơn hàng bán [Customize Index: 36 - Sài Gòn Petro]
-- <Example>
/*
 OP0130 @DivisionID = 'CTY', @FromPeriod = 201409, @ToPeriod = 201410, @FromDate = '2014-09-01',
 @ToDate = '2014-09-15', @TimeMode = 0, @OID = '%', @IID = '%'
 */

CREATE PROCEDURE [dbo].[OP0130] 	
	@DivisionID NVARCHAR(50),
	@FromPeriod INT,
	@ToPeriod INT,	
	@FromDate DATETIME,
	@ToDate DATETIME,
	@TimeMode TINYINT,
	@OID NVARCHAR(50),
	@IID NVARCHAR(50)

AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWHERE nvarchar(max),
		@OTypeID NVARCHAR(50), @OTypeID1 NVARCHAR(50) = '', @OTypeID2 NVARCHAR(50) = '', @OTypeID3 NVARCHAR(50) = '''''',
		@ITypeID NVARCHAR(50), @ITypeID1 NVARCHAR(50) = '',  @ITypeID2 NVARCHAR(50) = '', @ITypeID3 NVARCHAR(50) = ''''''

SELECT @OTypeID = OT00.OTypeID, @ITypeID = OT00.ITypeID
FROM OT0000 OT00 WHERE OT00.DivisionID = @DivisionID AND OT00.IsCommitDiscount = 1
IF @OTypeID IS NOT NULL
BEGIN
	SET @OTypeID2 = 'AT12.'+@OTypeID+'ID OID,'
	SET @OTypeID1 = 'AT12.'+@OTypeID+'ID,'
	SET @OTypeID3 = 'AT12.'+@OTypeID+'ID'
END
ELSE SET @OTypeID2 = 'NULL AS OID,'
IF @ITypeID IS NOT NULL
BEGIN
	SET @ITypeID2 = 'AT13.'+@ITypeID+'ID IID,'
	SET @ITypeID1 = 'AT13.'+@ITypeID+'ID,'
	SET @ITypeID3 = 'AT13.'+@ITypeID+'ID'
END
ELSE SET @ITypeID2 = 'NULL AS IID,' 


/*
 Cách tính chiết khấu thực tế lấy từ hoá đơn bán hàng - [Giải pháp Start SGPT - Bảo Anh]
 */
--IF LTRIM(STR(@TimeMode)) = 1	
--SET @sWHERE = 'AND CONVERT(VARCHAR(10),AT90.VoucherDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
--IF LTRIM(STR(@TimeMode)) = 0	
--SET @sWHERE = 'AND (AT90.TranYear*100 + AT90.TranMonth) BETWEEN '+LTRIM(@FromPeriod)+' AND '+LTRIM(@ToPeriod)+' '

--SET @sSQL1 = '
--SELECT AT12.'+@OTypeID+'ID AS OID, AT13.'+@ITypeID+'ID AS IID, AT90.ObjectID, AT12.ObjectName,       
--       AT15.AnaName AS OName, AT05.AnaName AS IName,
--       SUM(ISNULL(AT90.Quantity,0)) AS Quantity, 
--       SUM(ISNULL(AT90.DiscountAmount,0)) AS DiscountAmount,
--       SUM(CASE WHEN ISNUMERIC(AT90.DParameter01) = 0 THEN 0
--       	     ELSE CONVERT(DECIMAL(28,8),AT90.DParameter01) END) AS DParameter01,
--       SUM(CASE WHEN ISNUMERIC(AT90.DParameter02) = 0 THEN 0
--       	     ELSE CONVERT(DECIMAL(28,8),AT90.DParameter02) END) AS DParameter02, 
--       SUM(CASE WHEN ISNUMERIC(AT90.DParameter03) = 0 THEN 0
--       	     ELSE CONVERT(DECIMAL(28,8),AT90.DParameter03) END) AS DParameter03, 
--       ISNULL(OT33.Quantity,0) AS CmtQuantity, 
--       ISNULL(OT33.DiscountPrice,0) AS CmtDiscountPrice, 
--       ISNULL(OT33.EmpAmount,0) AS CmtEmpAmount, 
--       ISNULL(OT33.MarketAmount,0) AS CmtMarketAmount, 
--       ISNULL(OT33.OtherAmount,0) AS CmtOtherAmount                
--FROM AT9000 AT90
--LEFT JOIN AT1202 AT12 ON AT12.DivisionID = AT90.DivisionID AND AT12.ObjectID = AT90.ObjectID 
--LEFT JOIN AT1302 AT13 ON AT13.DivisionID = AT90.DivisionID AND AT13.InventoryID = AT90.InventoryID
--LEFT JOIN (
--	SELECT OT30.DivisionID, OT30.OID, OT30.FromDate, OT30.ToDate, OT31.ObjectID,
--	       OT31.IID, OT31.Quantity, OT31.DiscountPrice, OT31.EmpAmount,
--	       OT31.MarketAmount, OT31.OtherAmount 
--	FROM OT0130 OT30 
--	INNER JOIN OT0131 OT31 ON OT31.DivisionID = OT30.DivisionID AND OT31.ID = OT30.ID
--	WHERE OT30.DivisionID = '''+@DivisionID+''' 
--	      AND OT30.[Disabled] = 0 
--          ) AS OT33 ON OT33.DivisionID = AT90.DivisionID AND OT33.ObjectID = AT90.ObjectID AND OT33.IID = AT13.' + @ITypeID + 'ID
--    AND CONVERT(VARCHAR,AT90.VoucherDate,112) BETWEEN CONVERT(VARCHAR,OT33.FromDate,112) AND CONVERT(VARCHAR,ISNULL(OT33.ToDate,''9999-12-31 23:59:59.997''),112)
--LEFT JOIN AT1015 AT15 ON AT15.DivisionID = AT12.DivisionID AND AT15.AnaTypeID = '''+@OTypeID+''' AND AT15.AnaID = AT12.'+@OTypeID+'ID
--LEFT JOIN AT1015 AT05 ON AT05.DivisionID = AT13.DivisionID AND AT05.AnaTypeID = '''+@ITypeID+''' AND AT05.AnaID = AT13.'+@ITypeID+'ID
--WHERE AT90.DivisionID = '''+@DivisionID+''' AND TransactionTypeID = ''T04'' 
--      AND ISNULL(AT12.'+@OTypeID+'ID,'''') LIKE '''+@OID+''' AND ISNULL(AT13.'+@ITypeID+'ID,'''') LIKE '''+@IID+'''
--      '+@sWHERE+'
--GROUP BY AT90.ObjectID, OT33.Quantity, OT33.DiscountPrice, AT15.AnaName, AT05.AnaName,
--         OT33.EmpAmount, OT33.MarketAmount, OT33.OtherAmount, AT12.O01ID, AT12.ObjectName,
--         AT12.'+@OTypeID+'ID, AT13.'+@ITypeID+'ID
--ORDER BY AT13.'+@ITypeID+'ID, AT12.'+@OTypeID+'ID, AT90.ObjectID
--'

/*
 Cách tính chiết khấu thực tế lấy từ đơn hàng bán - [Giải pháp 16/10/2014 SGPT - Văn Toại(CON)]
 */

IF LTRIM(STR(@TimeMode)) = 1	
SET @sWHERE = 'AND CONVERT(VARCHAR(10),OT21.OrderDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '

IF LTRIM(STR(@TimeMode)) = 0	
SET @sWHERE = 'AND (OT21.TranYear*100 + OT21.TranMonth) BETWEEN '+LTRIM(@FromPeriod)+' AND '+LTRIM(@ToPeriod)+' '

SET @sSQL1 = '
SELECT '+@ITypeID2+' AT15.AnaName AS IName,
       '+@OTypeID2+' AT05.AnaName AS OName,
       OT21.ObjectID, AT12.ObjectName, 
       SUM(ISNULL(OT22.OrderQuantity,0)) AS Quantity,
       SUM(ISNULL(OT22.DiscountConvertedAmount,0)) AS DiscountAmount, 
       SUM(CASE WHEN ISNUMERIC(OT22.nvarchar01) = 0 OR OT22.nvarchar01 LIKE ''.'' OR OT22.nvarchar01 LIKE ''%e%'' OR OT22.nvarchar01 LIKE ''%-%'' THEN 0 
       	        ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar01) END) AS DParameter01, 
       SUM(CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
       	        ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END) AS DParameter02, 
       SUM(CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
       	        ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END) AS DParameter03,
       ISNULL(OT31.Quantity,0) AS CmtQuantity, ISNULL(OT31.DiscountPrice,0) AS CmtDiscountPrice, 
       ISNULL(OT31.EmpAmount,0) AS CmtEmpAmount, ISNULL(OT31.MarketAmount,0) AS CmtMarketAmount,
       ISNULL(OT31.OtherAmount,0) AS CmtOtherAmount
FROM OT2001 OT21
INNER JOIN OT2002 OT22 ON OT22.DivisionID = OT21.DivisionID AND OT22.SOrderID = OT21.SOrderID 
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT21.DivisionID AND AT12.ObjectID = OT21.ObjectID
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = OT21.DivisionID AND AT13.InventoryID = OT22.InventoryID
LEFT JOIN AT1015 AT05 ON AT05.DivisionID = OT21.DivisionID
	AND AT05.AnaTypeID = '''+ISNULL(@OTypeID,'') +''' AND AT05.AnaID = '+@OTypeID3+'
LEFT JOIN AT1015 AT15 ON AT15.DivisionID = OT21.DivisionID
	AND AT15.AnaTypeID = '''+ISNULL(@ITypeID,'')+''' AND AT15.AnaID = '+@ITypeID3+'
LEFT JOIN (
				SELECT OT30.DivisionID, OT30.ID, OT30.CurrencyID, OT30.FromDate, OT30.ToDate,
				       OT31.ObjectID, OT31.IID, OT31.Quantity, OT31.DiscountPrice,
				       OT31.EmpAmount, OT31.MarketAmount, OT31.OtherAmount 
				FROM OT0130 OT30 
				INNER JOIN OT0131 OT31 ON OT31.DivisionID = OT30.DivisionID AND OT31.ID = OT30.ID
				WHERE OT30.[Disabled] = 0
			) OT31 ON OT31.DivisionID = OT21.DivisionID AND OT31.ObjectID = OT21.ObjectID AND OT31.CurrencyID = OT21.CurrencyID
	AND OT31.IID = '+@ITypeID3+'
	AND CONVERT(VARCHAR,OT21.OrderDate,112) BETWEEN CONVERT(VARCHAR,OT31.FromDate,112) AND CONVERT(VARCHAR,ISNULL(OT31.ToDate,''9999-12-31 23:59:59.997''),112)
WHERE OT21.DivisionID = '''+@DivisionID+''' AND  OT21.OrderType = 0 AND OT21.OrderStatus = 1
      AND '+@OTypeID3+' LIKE '''+@OID+'''
      AND '+@ITypeID3+' LIKE '''+@IID+'''
      '+@sWHERE+'
GROUP BY '+@ITypeID1+' AT15.AnaName, '+@OTypeID1+' AT05.AnaName, OT21.ObjectID, AT12.ObjectName, OT31.Quantity,
      OT31.DiscountPrice, OT31.EmpAmount, OT31.MarketAmount, OT31.OtherAmount
ORDER BY '+@ITypeID1+' '+@OTypeID1+' OT21.ObjectID
'
EXEC (@sSQL1)
--PRINT @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
