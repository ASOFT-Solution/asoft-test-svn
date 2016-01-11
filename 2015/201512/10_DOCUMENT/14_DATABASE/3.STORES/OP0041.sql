IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0041]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0041]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Master cho màn hình OF0138 - kế thừa đơn hàng mua [Customize ABA]
-- <History>
---- Create on 27/04/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
OP0041 @DivisionID = 'VG', @FromMonth = 11, @FromYear = 2014, @ToMonth = 11, @ToYear = 2015, 
       @FromDate = '2014-11-02 14:39:51.283', @ToDate = '2014-12-02 14:39:51.283', @IsDate = 0, 
       @ObjectID = '%', @CurrencyID = '%', @SOVoucherID = 'TV20140000000002'  
 */
 
CREATE PROCEDURE [dbo].[OP0041] 	
	@DivisionID NVARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT, -- = 1: search theo ngày
	@ObjectID NVARCHAR(50),
	@CurrencyID NVARCHAR(50),
	@SOVoucherID NVARCHAR(50) -- VoucherID của ĐƠN HÀNG BÁN - Edit
AS
DECLARE @sSQL1 NVARCHAR(MAX),
        @sWHERE NVARCHAR(MAX)
		
SET @SOVoucherID = ISNULL(@SOVoucherID,'')
SET @sWHERE = ''
	IF @ObjectID IS NOT NULL OR @ObjectID != ''
	SET @sWHERE = @sWHERE + 'AND ISNULL(OT31.ObjectID,'''') LIKE '''+@ObjectID+''' '
	IF @CurrencyID IS NOT NULL OR @ObjectID != ''
	SET @sWHERE = @sWHERE + ' AND OT31.CurrencyID LIKE '''+@CurrencyID+''' '	
	IF LTRIM(STR(@IsDate)) = 1	SET @sWHERE = @sWHERE + '
	  AND CONVERT(VARCHAR(10),OT31.OrderDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
	IF LTRIM(STR(@IsDate)) = 0	SET @sWHERE = @sWHERE + '
	  AND (OT31.TranYear*12 + OT31.TranMonth) BETWEEN '+LTRIM(STR(@FromYear*12 + @FromMonth))+' AND '+LTRIM(STR(@ToYear*12 + @ToMonth))+' '
SET @sSQL1 = '
SELECT CONVERT(BIT,1) AS [Choose],
	   OT31.POrderID, OT31.VoucherNo, OT31.OrderDate,OT31.VoucherTypeID, OT31.ObjectID, AT12.ObjectName, 
	   OT31.CurrencyID, ISNULL(OT31.ExchangeRate,0) AS ExchangeRate, OT31.InventoryTypeID,
       ISNULL(OT31.OrderStatus,0) AS OrderStatus, OT31.ContractNo, OT31.ContractDate, OT31.[Description] 
FROM OT3001 OT31
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT31.DivisionID AND AT12.ObjectID = OT31.ObjectID
WHERE OT31.DivisionID = '''+@DivisionID+''' '+@sWHERE+' 
	  AND OT31.POrderID IN (SELECT OT22.InheritVoucherID 
	                        FROM OT2002 OT22 
	                        WHERE OT22.DivisionID = '''+@DivisionID+''' AND OT22.SOrderID = '''+@SOVoucherID+''' AND OT22.InheritTableID = ''OT3001'') 
UNION 
SELECT CONVERT(BIT,0) AS [Choose],
	   OT31.POrderID, OT31.VoucherNo, OT31.OrderDate,OT31.VoucherTypeID, OT31.ObjectID, AT12.ObjectName, 
	   OT31.CurrencyID, ISNULL(OT31.ExchangeRate,0) AS ExchangeRate, OT31.InventoryTypeID,
       ISNULL(OT31.OrderStatus,0) AS OrderStatus, OT31.ContractNo, OT31.ContractDate, OT31.[Description]
FROM OT3001 OT31
INNER JOIN OT3002 OT32 ON OT32.DivisionID = OT31.DivisionID AND OT32.POrderID = OT31.POrderID
LEFT JOIN OT2002 OT22 ON OT22.DivisionID = OT31.DivisionID AND OT22.InheritTableID = ''OT3001'' 
	 AND OT22.InheritVoucherID = OT31.POrderID AND OT22.InheritTransactionID = OT32.TransactionID
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT31.DivisionID AND AT12.ObjectID = OT31.ObjectID
WHERE OT31.DivisionID = '''+@DivisionID+''' AND ISNULL(OT31.OrderStatus,0) IN (1,2,3,5) '+@sWHERE+' 
	  AND OT31.POrderID NOT IN (SELECT OT22.InheritVoucherID 
	                            FROM OT2002 OT22 
	                            WHERE OT22.DivisionID = '''+@DivisionID+''' AND OT22.SOrderID = '''+@SOVoucherID+''' AND OT22.InheritTableID = ''OT3001'')
GROUP BY OT31.POrderID, OT31.VoucherNo, OT31.OrderDate,OT31.VoucherTypeID, OT31.ObjectID, AT12.ObjectName,
		 OT31.CurrencyID, OT31.ExchangeRate, OT31.InventoryTypeID, OT31.OrderStatus, OT31.ContractNo, 
		 OT31.ContractDate, OT31.[Description], OT32.OrderQuantity
HAVING ISNULL(OT32.OrderQuantity,0) - SUM(ISNULL(OT22.OrderQuantity,0)) > 0
ORDER BY [Choose], OT31.OrderDate, OT31.VoucherNo 
'
EXEC (@sSQL1)
--PRINT (@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
