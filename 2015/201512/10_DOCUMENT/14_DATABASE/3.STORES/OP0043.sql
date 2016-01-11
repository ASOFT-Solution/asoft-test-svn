IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0043]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0043]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Master cho màn hình OF0142 - Chọn đơn hàng quyết toán[Customize ABA]
-- <History>
---- Create on 22/04/2015 by Lê Thị Hạnh 
---- Modified on 18/06/2015 by Lê Thị Hạnh: Cập nhật phí phát sinh, phí rớt điểm, phí bốc xếp, khấu trừ và thành tiền
---- Modified on 10/09/2015 by Nguyen Thanh Thịnh: Update thêm Tính Phí Trả Khay và phí rớt điểm khay
---- Modified on 08/01/2016 by Kim Vu: Update thêm Tính Phí Trả Khay và phí rớt điểm khay
-- <Example>
/*
OP0043 @DivisionID = 'VG', @FromMonth = 07, @FromYear = 2014, @ToMonth = 11, @ToYear = 2015, 
       @FromDate = '2014-11-02 14:39:51.283', @ToDate = '2014-12-02 14:39:51.283', @IsDate = 0, 
       @ObjectID = '%', @SettleType = 1, @SVoucherID = ''  
 */

CREATE PROCEDURE [dbo].[OP0043] 	
	@DivisionID NVARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT, -- = 1: search theo ngày
	@ObjectID NVARCHAR(50),
	@SettleType TINYINT, --1: Đơn hàng mua, 0: đơn hàng bán
	@SVoucherID NVARCHAR(50) --Truyền vào khi Edit 
AS
DECLARE @sSQL1 NVARCHAR(MAX),
        @sWHERE NVARCHAR(MAX),
        @sSQL2 NVARCHAR(MAX),
		@sSQL3 NVARCHAR(MAX),
		@sSQL4 NVARCHAR(MAX)
		
SET @SVoucherID = ISNULL(@SVoucherID,'')
SET @SettleType = ISNULL(@SettleType,0)
SET @sWHERE = ''
IF ISNULL(@SettleType,0) = 0 
BEGIN
	IF @ObjectID IS NOT NULL OR @ObjectID != ''
	SET @sWHERE = @sWHERE + 'AND ISNULL(OT21.ObjectID,'''') LIKE '''+@ObjectID+''' '
	IF LTRIM(STR(@IsDate)) = 1	SET @sWHERE = @sWHERE + '
	  AND CONVERT(VARCHAR(10),OT21.OrderDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
	IF LTRIM(STR(@IsDate)) = 0	SET @sWHERE = @sWHERE + '
	  AND (OT21.TranYear*12 + OT21.TranMonth) BETWEEN '+LTRIM(STR(@FromYear*12 + @FromMonth))+' AND '+LTRIM(STR(@ToYear*12 + @ToMonth))+' '
SET @sSQL1 = '
SELECT CONVERT(BIT,1) AS [Choose],
	   ''OT2001'' AS OPTableID, OT21.SOrderID AS OPVoucherID,
	   OT21.VoucherNo, OT21.OrderDate,OT21.VoucherTypeID, OT21.ObjectID, AT12.ObjectName, 
	   OT21.CurrencyID, ISNULL(OT21.ExchangeRate,0) AS ExchangeRate, 
	   ISNULL(OT21.OrderStatus,0) AS OrderStatus, OT21.Notes AS [Description],
	   ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal,
	   SUM(ISNULL(OT22.OriginalAmount,0)) AS OPOriginalAmount,
	   SUM(ISNULL(OT22.ConvertedAmount,0)) AS OPConvertedAmount,
	   SUM((CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END)) AS nvarchar02,
	   SUM((CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END)) AS nvarchar03,
	   SUM((CASE WHEN ISNUMERIC(OT22.nvarchar08) = 0 OR OT22.nvarchar08 LIKE ''.'' OR OT22.nvarchar08 LIKE ''%e%'' OR OT22.nvarchar08 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar08) END)) AS nvarchar08,
	   (SUM(ISNULL(OT22.OriginalAmount,0))
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END)/ISNULL(OT21.ExchangeRate,1)) 
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END)/ISNULL(OT21.ExchangeRate,1))
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar08) = 0 OR OT22.nvarchar08 LIKE ''.'' OR OT22.nvarchar08 LIKE ''%e%'' OR OT22.nvarchar08 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar08) END)/ISNULL(OT21.ExchangeRate,1))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar03) = 0 OR OT22.varchar03 LIKE ''.'' OR OT22.varchar03 LIKE ''%e%'' OR OT22.varchar03 LIKE ''%-%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar03) END)/ISNULL(OT21.ExchangeRate,1))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar04) = 0 OR OT22.varchar04 LIKE ''.'' OR OT22.varchar04 LIKE ''%e%'' OR OT22.varchar04 LIKE ''%-%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar04) END)/ISNULL(OT21.ExchangeRate,1))	
	 - SUM((CASE WHEN ISNUMERIC(OT22.varchar05) = 0 OR OT22.varchar05 LIKE ''.'' OR OT22.varchar05 LIKE ''%e%'' OR OT22.varchar05 LIKE ''%-%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar05) END)/ISNULL(OT21.ExchangeRate,1))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar07) = 0 OR OT22.varchar07 LIKE ''.'' OR OT22.varchar07 LIKE ''%e%'' OR OT22.varchar07 LIKE ''%-%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar07) END)/ISNULL(OT21.ExchangeRate,1))	
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar09) = 0 OR OT22.varchar09 LIKE ''.'' OR OT22.varchar09 LIKE ''%e%'' OR OT22.varchar09 LIKE ''%-%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar09) END)/ISNULL(OT21.ExchangeRate,1))		 
			 ) AS OriginalAmount,
	   (SUM(ISNULL(OT22.ConvertedAmount,0))
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END)) 
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END))
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar08) = 0 OR OT22.nvarchar08 LIKE ''.'' OR OT22.nvarchar08 LIKE ''%e%'' OR OT22.nvarchar08 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar08) END))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar03) = 0 OR OT22.varchar03 LIKE ''.'' OR OT22.varchar03 LIKE ''%e%'' OR OT22.varchar03 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar03) END))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar04) = 0 OR OT22.varchar04 LIKE ''.'' OR OT22.varchar04 LIKE ''%e%'' OR OT22.varchar04 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar04) END))	
	 - SUM((CASE WHEN ISNUMERIC(OT22.varchar05) = 0 OR OT22.varchar05 LIKE ''.'' OR OT22.varchar05 LIKE ''%e%'' OR OT22.varchar05 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar05) END))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar07) = 0 OR OT22.varchar07 LIKE ''.'' OR OT22.varchar07 LIKE ''%e%'' OR OT22.varchar07 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar07) END))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar09) = 0 OR OT22.varchar09 LIKE ''.'' OR OT22.varchar09 LIKE ''%e%'' OR OT22.varchar09 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar09) END))			 
			 ) AS ConvertedAmount '
SET @sSQL3 = '
FROM OT2001 OT21
INNER JOIN OT2002 OT22 ON OT22.DivisionID = OT21.DivisionID AND OT22.SOrderID = OT21.SOrderID
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT21.DivisionID AND AT12.ObjectID = OT21.ObjectID
LEFT JOIN AT1004 AT14 ON AT14.DivisionID = OT21.DivisionID AND AT14.CurrencyID = OT21.CurrencyID
WHERE OT21.DivisionID = '''+@DivisionID+''' AND OT21.OrderType = 0
	  AND OT21.SOrderID IN (SELECT OPVoucherID 
	                        FROM OT0141 
	                        WHERE DivisionID = '''+@DivisionID+''' AND VoucherID = '''+@SVoucherID+''' AND OPTableID = ''OT2001'')
GROUP BY OT21.SOrderID, OT21.VoucherNo, OT21.OrderDate,OT21.VoucherTypeID, OT21.ObjectID, AT12.ObjectName,
		 OT21.OrderStatus, OT21.Notes, OT21.CurrencyID, OT21.ExchangeRate, AT14.ExchangeRateDecimal'
SET @sSQL2 = '
UNION 
SELECT CONVERT(BIT,0) AS [Choose],
	   ''OT2001'' AS OPTableID, OT21.SOrderID AS OPVoucherID,
	   OT21.VoucherNo, OT21.OrderDate,OT21.VoucherTypeID, OT21.ObjectID, AT12.ObjectName, 
	   OT21.CurrencyID, ISNULL(OT21.ExchangeRate,0) AS ExchangeRate, 
	   ISNULL(OT21.OrderStatus,0) AS OrderStatus, OT21.Notes AS [Description],
	   ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal,
	   SUM(ISNULL(OT22.OriginalAmount,0)) AS OPOriginalAmount,
	   SUM(ISNULL(OT22.ConvertedAmount,0)) AS OPConvertedAmount,
	   SUM((CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END)) AS nvarchar02,
	   SUM((CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END)) AS nvarchar03,
	   SUM((CASE WHEN ISNUMERIC(OT22.nvarchar08) = 0 OR OT22.nvarchar08 LIKE ''.'' OR OT22.nvarchar08 LIKE ''%e%'' OR OT22.nvarchar08 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar08) END)) AS nvarchar08,
	   (SUM(ISNULL(OT22.OriginalAmount,0))
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END)/ISNULL(OT21.ExchangeRate,1)) 
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END)/ISNULL(OT21.ExchangeRate,1))
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar08) = 0 OR OT22.nvarchar08 LIKE ''.'' OR OT22.nvarchar08 LIKE ''%e%'' OR OT22.nvarchar08 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar08) END)/ISNULL(OT21.ExchangeRate,1))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar03) = 0 OR OT22.varchar03 LIKE ''.'' OR OT22.varchar03 LIKE ''%e%'' OR OT22.varchar03 LIKE ''%-%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar03) END)/ISNULL(OT21.ExchangeRate,1))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar04) = 0 OR OT22.varchar04 LIKE ''.'' OR OT22.varchar04 LIKE ''%e%'' OR OT22.varchar04 LIKE ''%-%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar04) END)/ISNULL(OT21.ExchangeRate,1))	
	 - SUM((CASE WHEN ISNUMERIC(OT22.varchar05) = 0 OR OT22.varchar05 LIKE ''.'' OR OT22.varchar05 LIKE ''%e%'' OR OT22.varchar05 LIKE ''%-%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar05) END)/ISNULL(OT21.ExchangeRate,1))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar07) = 0 OR OT22.varchar07 LIKE ''.'' OR OT22.varchar07 LIKE ''%e%'' OR OT22.varchar07 LIKE ''%-%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar07) END)/ISNULL(OT21.ExchangeRate,1))	
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar09) = 0 OR OT22.varchar09 LIKE ''.'' OR OT22.varchar09 LIKE ''%e%'' OR OT22.varchar09 LIKE ''%-%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar09) END)/ISNULL(OT21.ExchangeRate,1))		 
			 ) AS OriginalAmount,
	   (SUM(ISNULL(OT22.ConvertedAmount,0))
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END)) 
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END))
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar08) = 0 OR OT22.nvarchar08 LIKE ''.'' OR OT22.nvarchar08 LIKE ''%e%'' OR OT22.nvarchar08 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar08) END))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar03) = 0 OR OT22.varchar03 LIKE ''.'' OR OT22.varchar03 LIKE ''%e%'' OR OT22.varchar03 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar03) END))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar04) = 0 OR OT22.varchar04 LIKE ''.'' OR OT22.varchar04 LIKE ''%e%'' OR OT22.varchar04 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar04) END))
	 - SUM((CASE WHEN ISNUMERIC(OT22.varchar05) = 0 OR OT22.varchar05 LIKE ''.'' OR OT22.varchar05 LIKE ''%e%'' OR OT22.varchar05 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar05) END))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar07) = 0 OR OT22.varchar07 LIKE ''.'' OR OT22.varchar07 LIKE ''%e%'' OR OT22.varchar07 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar07) END))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar09) = 0 OR OT22.varchar09 LIKE ''.'' OR OT22.varchar09 LIKE ''%e%'' OR OT22.varchar09 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar09) END))		 
			 ) AS ConvertedAmount'
SET @sSQL4= '
FROM OT2001 OT21
INNER JOIN OT2002 OT22 ON OT22.DivisionID = OT21.DivisionID AND OT22.SOrderID = OT21.SOrderID
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT21.DivisionID AND AT12.ObjectID = OT21.ObjectID
LEFT JOIN AT1004 AT14 ON AT14.DivisionID = OT21.DivisionID AND AT14.CurrencyID = OT21.CurrencyID
WHERE OT21.DivisionID = '''+@DivisionID+''' AND ISNULL(OT21.OrderStatus,0) IN (1,2,3,5)
	   AND OT21.OrderType = 0
	  AND OT21.SOrderID NOT IN (SELECT OPVoucherID 
	                            FROM OT0141 
	                            WHERE DivisionID = '''+@DivisionID+''' AND OPTableID = ''OT2001'')
	  '+@sWHERE+'
GROUP BY OT21.SOrderID, OT21.VoucherNo, OT21.OrderDate, OT21.VoucherTypeID, OT21.ObjectID, AT12.ObjectName,
		 OT21.OrderStatus, OT21.Notes, OT21.CurrencyID, OT21.ExchangeRate, AT14.ExchangeRateDecimal
ORDER BY [Choose], OrderDate, VoucherNo 
'
END
ELSE
BEGIN
	IF @ObjectID IS NOT NULL OR @ObjectID != ''
	SET @sWHERE = @sWHERE + 'AND ISNULL(OT31.ObjectID,'''') LIKE '''+@ObjectID+''' '
	IF LTRIM(STR(@IsDate)) = 1	SET @sWHERE = @sWHERE + '
	  AND CONVERT(VARCHAR(10),OT31.OrderDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
	IF LTRIM(STR(@IsDate)) = 0	SET @sWHERE = @sWHERE + '
	  AND (OT31.TranYear*12 + OT31.TranMonth) BETWEEN '+LTRIM(STR(@FromYear*12 + @FromMonth))+' AND '+LTRIM(STR(@ToYear*12 + @ToMonth))+' '
SET @sSQL1 = '
SELECT CONVERT(BIT,1) AS [Choose],
	   ''OT3001'' AS OPTableID, OT31.POrderID AS OPVoucherID, 
	   OT31.VoucherNo, OT31.OrderDate,OT31.VoucherTypeID, OT31.ObjectID, AT12.ObjectName, 
	   OT31.CurrencyID, ISNULL(OT31.ExchangeRate,0) AS ExchangeRate, 
	   ISNULL(OT31.OrderStatus,0) AS OrderStatus, OT31.[Description],
	   ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal,
	   SUM(ISNULL(OT32.OriginalAmount,0)) AS OPOriginalAmount,
	   SUM(ISNULL(OT32.ConvertedAmount,0)) AS OPConvertedAmount,
	   SUM((CASE WHEN ISNUMERIC(OT32.Notes) = 0 OR OT32.Notes LIKE ''.'' OR OT32.Notes LIKE ''%e%'' OR OT32.Notes LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes) END)) AS Notes,
	   SUM((CASE WHEN ISNUMERIC(OT32.Notes02) = 0 OR OT32.Notes02 LIKE ''.'' OR OT32.Notes02 LIKE ''%e%'' OR OT32.Notes02 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes02) END)) AS Notes02,
	   SUM((CASE WHEN ISNUMERIC(OT32.Notes03) = 0 OR OT32.Notes03 LIKE ''.'' OR OT32.Notes03 LIKE ''%e%'' OR OT32.Notes03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes03) END)) AS Notes03,
	  (SUM(ISNULL(OT32.OriginalAmount,0))
	 + SUM((CASE WHEN ISNUMERIC(OT32.Notes) = 0 OR OT32.Notes LIKE ''.'' OR OT32.Notes LIKE ''%e%'' OR OT32.Notes LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes) END)/ISNULL(OT31.ExchangeRate,1))
	 + SUM((CASE WHEN ISNUMERIC(OT32.Notes02) = 0 OR OT32.Notes02 LIKE ''.'' OR OT32.Notes02 LIKE ''%e%'' OR OT32.Notes02 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes02) END)/ISNULL(OT31.ExchangeRate,1))
	 - SUM((CASE WHEN ISNUMERIC(OT32.Notes03) = 0 OR OT32.Notes03 LIKE ''.'' OR OT32.Notes03 LIKE ''%e%'' OR OT32.Notes03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes03) END)/ISNULL(OT31.ExchangeRate,1))) AS OriginalAmount,
	  (SUM(ISNULL(OT32.ConvertedAmount,0))
	 + SUM((CASE WHEN ISNUMERIC(OT32.Notes) = 0 OR OT32.Notes LIKE ''.'' OR OT32.Notes LIKE ''%e%'' OR OT32.Notes LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes) END))
	 + SUM((CASE WHEN ISNUMERIC(OT32.Notes02) = 0 OR OT32.Notes02 LIKE ''.'' OR OT32.Notes02 LIKE ''%e%'' OR OT32.Notes02 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes02) END))
	 - SUM((CASE WHEN ISNUMERIC(OT32.Notes03) = 0 OR OT32.Notes03 LIKE ''.'' OR OT32.Notes03 LIKE ''%e%'' OR OT32.Notes03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes03) END))) AS ConvertedAmount '
SET @sSQL3= '
FROM OT3001 OT31
INNER JOIN OT3002 OT32 ON OT32.DivisionID = OT31.DivisionID AND OT32.POrderID = OT31.POrderID
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT31.DivisionID AND AT12.ObjectID = OT31.ObjectID
LEFT JOIN AT1004 AT14 ON AT14.DivisionID = OT31.DivisionID AND AT14.CurrencyID = OT31.CurrencyID
WHERE OT31.DivisionID = '''+@DivisionID+''' 
	  AND OT31.POrderID IN (SELECT OPVoucherID 
	                        FROM OT0141 
	                        WHERE DivisionID = '''+@DivisionID+''' AND VoucherID = '''+@SVoucherID+''' AND OPTableID = ''OT3001'') 
GROUP BY OT31.POrderID, OT31.VoucherNo, OT31.OrderDate,OT31.VoucherTypeID, OT31.ObjectID, AT12.ObjectName,
		 OT31.OrderStatus, OT31.[Description], OT31.CurrencyID, OT31.ExchangeRate, AT14.ExchangeRateDecimal'
SET @sSQL2 ='
UNION 
SELECT CONVERT(BIT,0) AS [Choose],
	   ''OT3001'' AS OPTableID, OT31.POrderID AS OPVoucherID, 
	   OT31.VoucherNo, OT31.OrderDate,OT31.VoucherTypeID, OT31.ObjectID, AT12.ObjectName, 
	   OT31.CurrencyID, ISNULL(OT31.ExchangeRate,0) AS ExchangeRate, 
	   ISNULL(OT31.OrderStatus,0) AS OrderStatus, OT31.[Description],
	   ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal,
	   SUM(ISNULL(OT32.OriginalAmount,0)) AS OPOriginalAmount,
	   SUM(ISNULL(OT32.ConvertedAmount,0)) AS OPConvertedAmount,
	   SUM((CASE WHEN ISNUMERIC(OT32.Notes) = 0 OR OT32.Notes LIKE ''.'' OR OT32.Notes LIKE ''%e%'' OR OT32.Notes LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes) END)) AS Notes,
	   SUM((CASE WHEN ISNUMERIC(OT32.Notes02) = 0 OR OT32.Notes02 LIKE ''.'' OR OT32.Notes02 LIKE ''%e%'' OR OT32.Notes02 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes02) END)) AS Notes02,
	   SUM((CASE WHEN ISNUMERIC(OT32.Notes03) = 0 OR OT32.Notes03 LIKE ''.'' OR OT32.Notes03 LIKE ''%e%'' OR OT32.Notes03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes03) END)) AS Notes03,
	  (SUM(ISNULL(OT32.OriginalAmount,0))
	 + SUM((CASE WHEN ISNUMERIC(OT32.Notes) = 0 OR OT32.Notes LIKE ''.'' OR OT32.Notes LIKE ''%e%'' OR OT32.Notes LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes) END)/ISNULL(OT31.ExchangeRate,1))
	 + SUM((CASE WHEN ISNUMERIC(OT32.Notes02) = 0 OR OT32.Notes02 LIKE ''.'' OR OT32.Notes02 LIKE ''%e%'' OR OT32.Notes02 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes02) END)/ISNULL(OT31.ExchangeRate,1))
	 - SUM((CASE WHEN ISNUMERIC(OT32.Notes03) = 0 OR OT32.Notes03 LIKE ''.'' OR OT32.Notes03 LIKE ''%e%'' OR OT32.Notes03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes03) END)/ISNULL(OT31.ExchangeRate,1))) AS OriginalAmount,
	  (SUM(ISNULL(OT32.ConvertedAmount,0))
	 + SUM((CASE WHEN ISNUMERIC(OT32.Notes) = 0 OR OT32.Notes LIKE ''.'' OR OT32.Notes LIKE ''%e%'' OR OT32.Notes LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes) END))
	 + SUM((CASE WHEN ISNUMERIC(OT32.Notes02) = 0 OR OT32.Notes02 LIKE ''.'' OR OT32.Notes02 LIKE ''%e%'' OR OT32.Notes02 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes02) END))
	 - SUM((CASE WHEN ISNUMERIC(OT32.Notes03) = 0 OR OT32.Notes03 LIKE ''.'' OR OT32.Notes03 LIKE ''%e%'' OR OT32.Notes03 LIKE ''%-%'' THEN 0
		     ELSE CONVERT(DECIMAL(28,8),OT32.Notes03) END))) AS ConvertedAmount'
SET @sSQL4= '
FROM OT3001 OT31
INNER JOIN OT3002 OT32 ON OT32.DivisionID = OT31.DivisionID AND OT32.POrderID = OT31.POrderID
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT31.DivisionID AND AT12.ObjectID = OT31.ObjectID
LEFT JOIN AT1004 AT14 ON AT14.DivisionID = OT31.DivisionID AND AT14.CurrencyID = OT31.CurrencyID
WHERE OT31.DivisionID = '''+@DivisionID+''' AND ISNULL(OT31.OrderStatus,0) IN (1,2,3,5)
	  AND OT31.POrderID NOT IN (SELECT OPVoucherID 
								FROM OT0141 
								WHERE DivisionID = '''+@DivisionID+''' AND OPTableID = ''OT3001'')
	  '+@sWHERE+'
GROUP BY OT31.POrderID, OT31.VoucherNo, OT31.OrderDate, OT31.VoucherTypeID, OT31.ObjectID, AT12.ObjectName,
		 OT31.OrderStatus, OT31.[Description], OT31.CurrencyID, OT31.ExchangeRate, AT14.ExchangeRateDecimal
ORDER BY [Choose], OrderDate, VoucherNo 
'	
END
EXEC (@sSQL1 + @sSQL3 +@sSQL2 + @sSQL4)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
