IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0307]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0307]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load dữ liệu cho màn hình AF0306 - Kế thừa quyết toán đơn hàng[Customize ABA]
-- <History>
---- Create on 04/05/2015 by Lê Thị Hạnh 
---- Modified on 18/06/2015 by Lê Thị Hạnh: Cập nhật phí phát sinh, phí rớt điểm, phí bốc xếp, khấu trừ và thành tiền
---- Modified on 10/09/2015 by Nguyen Thanh Thịnh: Update thêm Tính Phí Trả Khay và phí rớt điểm khay
-- <Example>
/*
AP0307 @DivisionID = 'VG', @FromMonth = 11, @FromYear = 2014, @ToMonth = 11, @ToYear = 2015, 
       @FromDate = '2014-11-02 14:39:51.283', @ToDate = '2014-12-02 14:39:51.283', @IsDate = 0, 
       @ObjectID = '%', @IsOPSettle = 1, @SVoucherID = ''  
 */

CREATE PROCEDURE [dbo].[AP0307] 	
	@DivisionID NVARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT, -- = 1: search theo ngày
	@ObjectID NVARCHAR(50),
	@IsOPSettle TINYINT, --1: QTĐHM, 0: QTĐHB
	@SVoucherID NVARCHAR(50) --Truyền vào khi Edit 
AS
DECLARE @sSQL1 NVARCHAR(MAX),
        @sWHERE NVARCHAR(MAX),
        @sSQL2 NVARCHAR(MAX),
        @sSQL3 NVARCHAR(MAX)
		
SET @SVoucherID = ISNULL(@SVoucherID,'')
SET @IsOPSettle = ISNULL(@IsOPSettle,0)
SET @sWHERE = ''
IF @ObjectID IS NOT NULL OR @ObjectID != ''
	SET @sWHERE = @sWHERE + 'AND ISNULL(OT40.ObjectID,'''') LIKE '''+@ObjectID+''' '
	IF LTRIM(STR(@IsDate)) = 1	SET @sWHERE = @sWHERE + '
	  AND CONVERT(VARCHAR(10),OT40.VoucherDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
	IF LTRIM(STR(@IsDate)) = 0	SET @sWHERE = @sWHERE + '
	  AND (OT40.TranYear*12 + OT40.TranMonth) BETWEEN '+LTRIM(STR(@FromYear*12 + @FromMonth))+' AND '+LTRIM(STR(@ToYear*12 + @ToMonth))+' '
	


IF ISNULL(@IsOPSettle,0) = 0 
BEGIN 
	SET @sSQL1 = '
SELECT CONVERT(BIT,1) AS [Choose],
	   OT40.VoucherID AS InheritVoucherID, ''OT0140'' AS InheritTableID,
	   OT40.VoucherNo, OT40.VoucherDate, OT40.VoucherTypeID, OT40.ObjectID, AT12.ObjectName, 
	   OT40.[Description], OT40.EmployeeID,
	   0 AS OPOriginalAmount, 0 AS OPConvertedAmount, 0 AS nvarchar02, 0 AS nvarchar03, 0 AS nvarchar08,
	   0 AS varchar03, 0 AS varchar04,
	   SUM(ISNULL(AT90.OriginalAmount,0)) AS OriginalAmount,
	   SUM(ISNULL(AT90.ConvertedAmount,0)) AS ConvertedAmount	   
FROM OT0140 OT40
INNER JOIN AT9000 AT90 ON AT90.DivisionID = OT40.DivisionID AND AT90.InheritVoucherID = OT40.VoucherID 
	 AND AT90.InheritTableID = ''OT0140'' AND AT90.TransactionTypeID IN (''T04'')
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT40.DivisionID AND AT12.ObjectID = OT40.ObjectID
WHERE OT40.DivisionID = '''+@DivisionID+'''
	  AND OT40.VoucherID IN (SELECT InheritVoucherID 
	                         FROM AT9000 
	                         WHERE DivisionID = '''+@DivisionID+''' AND VoucherID = '''+@SVoucherID+''' AND InheritTableID = ''OT0140'')
	  '+@sWHERE+'
GROUP BY OT40.VoucherID, OT40.VoucherNo, OT40.VoucherDate, OT40.VoucherTypeID, OT40.ObjectID, AT12.ObjectName,
		 OT40.[Description], OT40.EmployeeID ' 
SET @sSQL2 = '
UNION
SELECT CONVERT(BIT,0) AS [Choose],
	   OT40.VoucherID AS InheritVoucherID, ''OT0140'' AS InheritTableID, 
	   OT40.VoucherNo, OT40.VoucherDate, OT40.VoucherTypeID, OT40.ObjectID, AT12.ObjectName,
	   OT40.[Description], OT40.EmployeeID,
	   SUM(ISNULL(OT22.OriginalAmount,0)) AS OPOriginalAmount,
	   SUM(ISNULL(OT22.ConvertedAmount,0)) AS OPConvertedAmount,
	   SUM((CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END)) AS nvarchar02,
	   SUM((CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END)) AS nvarchar03,
	   SUM((CASE WHEN ISNUMERIC(OT22.nvarchar08) = 0 OR OT22.nvarchar08 LIKE ''.'' OR OT22.nvarchar08 LIKE ''%e%'' OR OT22.nvarchar08 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar08) END)) AS nvarchar08,
	  SUM((CASE WHEN ISNUMERIC(OT22.varchar03) = 0 OR OT22.varchar03 LIKE ''.'' OR OT22.varchar03 LIKE ''%e%'' OR OT22.varchar03 LIKE ''%-%'' THEN 0
		ELSE CONVERT(DECIMAL(28,8),OT22.varchar03) END)) AS varchar03,
	  SUM((CASE WHEN ISNUMERIC(OT22.varchar04) = 0 OR OT22.varchar04 LIKE ''.'' OR OT22.varchar04 LIKE ''%e%'' OR OT22.varchar04 LIKE ''%-%'' THEN 0
		ELSE CONVERT(DECIMAL(28,8),OT22.varchar04) END)) as varchar04,
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
	 ) AS OriginalAmount,
	   (SUM(ISNULL(OT22.ConvertedAmount,0))
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar02) = 0 OR OT22.nvarchar02 LIKE ''.'' OR OT22.nvarchar02 LIKE ''%e%'' OR OT22.nvarchar02 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar02) END)) 
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar03) = 0 OR OT22.nvarchar03 LIKE ''.'' OR OT22.nvarchar03 LIKE ''%e%'' OR OT22.nvarchar03 LIKE ''%-%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar03) END))
	 + SUM((CASE WHEN ISNUMERIC(OT22.nvarchar08) = 0 OR OT22.nvarchar08 LIKE ''.'' OR OT22.nvarchar08 LIKE ''%e%'' OR OT22.nvarchar08 LIKE ''%e%'' THEN 0
	         ELSE CONVERT(DECIMAL(28,8),OT22.nvarchar08) END))
	 +  SUM((CASE WHEN ISNUMERIC(OT22.varchar03) = 0 OR OT22.varchar03 LIKE ''.'' OR OT22.varchar03 LIKE ''%e%'' OR OT22.varchar03 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar03) END))
	 + SUM((CASE WHEN ISNUMERIC(OT22.varchar04) = 0 OR OT22.varchar04 LIKE ''.'' OR OT22.varchar04 LIKE ''%e%'' OR OT22.varchar04 LIKE ''%e%'' THEN 0
			 ELSE CONVERT(DECIMAL(28,8),OT22.varchar04) END))
	 ) AS ConvertedAmount '
SET @sSQL3 = '	         
FROM OT0140 OT40
INNER JOIN OT0141 OT41 ON OT41.DivisionID = OT40.DivisionID AND OT41.VoucherID = OT40.VoucherID
LEFT JOIN OT2002 OT22 ON OT22.DivisionID = OT41.DivisionID AND OT22.SOrderID = OT41.OPVoucherID AND OT41.OPTableID = ''OT2001''
LEFT JOIN OT2001 OT21 ON OT21.DivisionID = OT41.DivisionID AND OT21.SOrderID = OT41.OPVoucherID AND OT41.OPTableID = ''OT2001''
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT40.DivisionID AND AT12.ObjectID = OT40.ObjectID
WHERE OT40.DivisionID = '''+@DivisionID+''' AND ISNULL(OT40.SettleType,0) = 0
	  AND OT40.VoucherID NOT IN (SELECT InheritVoucherID 
	                             FROM AT9000 
	                             WHERE DivisionID = '''+@DivisionID+''' AND InheritTableID = ''OT0140'')
	  '+@sWHERE+'
GROUP BY OT40.VoucherID, OT40.VoucherNo, OT40.VoucherDate, OT40.VoucherTypeID, OT40.ObjectID, AT12.ObjectName,
		 OT40.[Description], OT40.EmployeeID
ORDER BY [Choose], VoucherDate, VoucherNo 
'
END
ELSE 
BEGIN
	SET @sSQL1 = '
SELECT CONVERT(BIT,1) AS [Choose],
	   OT40.VoucherID AS InheritVoucherID, ''OT0140'' AS InheritTableID,
	   OT40.VoucherNo, OT40.VoucherDate, OT40.VoucherTypeID, OT40.ObjectID, AT12.ObjectName, 
	   OT40.[Description], OT40.EmployeeID,
	   0 AS OPOriginalAmount, 0 AS OPConvertedAmount, 0 AS Notes, 0 AS Notes02, 0 AS Notes03,
	   SUM(ISNULL(AT90.OriginalAmount,0)) AS OriginalAmount,
	   SUM(ISNULL(AT90.ConvertedAmount,0)) AS ConvertedAmount
FROM OT0140 OT40
INNER JOIN AT9000 AT90 ON AT90.DivisionID = OT40.DivisionID AND AT90.InheritVoucherID = OT40.VoucherID 
	 AND AT90.InheritTableID = ''OT0140'' AND AT90.TransactionTypeID IN (''T03'')
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT40.DivisionID AND AT12.ObjectID = OT40.ObjectID
WHERE OT40.DivisionID = '''+@DivisionID+'''
	  AND OT40.VoucherID IN (SELECT InheritVoucherID 
	                         FROM AT9000 
	                         WHERE DivisionID = '''+@DivisionID+''' AND VoucherID = '''+@SVoucherID+''' AND InheritTableID = ''OT0140'')
	  '+@sWHERE+'
GROUP BY OT40.VoucherID, OT40.VoucherNo, OT40.VoucherDate, OT40.VoucherTypeID, OT40.ObjectID, AT12.ObjectName,
		 OT40.[Description], OT40.EmployeeID '
SET @sSQL2 = '
UNION 
SELECT CONVERT(BIT,0) AS [Choose],
	   OT40.VoucherID AS InheritVoucherID, ''OT0140'' AS InheritTableID,
	   OT40.VoucherNo, OT40.VoucherDate, OT40.VoucherTypeID, OT40.ObjectID, AT12.ObjectName,
	   OT40.[Description], OT40.EmployeeID,
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
SET @sSQL3 = '	   		     
FROM OT0140 OT40
INNER JOIN OT0141 OT41 ON OT41.DivisionID = OT40.DivisionID AND OT41.VoucherID = OT40.VoucherID
LEFT JOIN OT3002 OT32 ON OT32.DivisionID = OT41.DivisionID AND OT32.POrderID = OT41.OPVoucherID AND OT41.OPTableID = ''OT3001''
LEFT JOIN OT3001 OT31 ON OT31.DivisionID = OT41.DivisionID AND OT31.POrderID = OT41.OPVoucherID AND OT41.OPTableID = ''OT3001''
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT40.DivisionID AND AT12.ObjectID = OT40.ObjectID
WHERE OT40.DivisionID = '''+@DivisionID+''' AND ISNULL(OT40.SettleType,0) = 1
	  AND OT40.VoucherID NOT IN (SELECT InheritVoucherID 
	                             FROM AT9000 
	                             WHERE DivisionID = '''+@DivisionID+''' AND InheritTableID = ''OT0140'')
	  '+@sWHERE+'
GROUP BY OT40.VoucherID, OT40.VoucherNo, OT40.VoucherDate, OT40.VoucherTypeID, OT40.ObjectID, AT12.ObjectName,
		 OT40.[Description], OT40.EmployeeID
ORDER BY [Choose], VoucherDate, VoucherNo 
'
END
EXEC (@sSQL1 + @sSQL2 + @sSQL3)
--PRINT (@sSQL1)
--PRINT (@sSQL2)
--PRINT (@sSQL3)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
