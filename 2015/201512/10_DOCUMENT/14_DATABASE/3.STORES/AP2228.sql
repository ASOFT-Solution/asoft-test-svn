IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2228]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP2228]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----CREATE by Nguyen Quoc Huy, Date 29/05/2007
----Purpose: Chi tiet chi phí gia cong
----Edit by Bao Anh, Date 26/07/2007
----Purpose: Sua loi du lieu bi double dong
----Edited by: [GS] [Minh Lâm] [29/07/2010]
----Edited by Thanh Sơn on 17/07/2014 : lấy dữ liệu trực tiếp từ store, không sinh view

CREATE PROCEDURE AP2228
(
    @DivisionID NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @IsDate TINYINT
)
AS
DECLARE
    @sSQlSelect NVARCHAR(4000), 
    @sSQlFrom NVARCHAR(4000), 
    @sSQlWhere NVARCHAR(4000), 
    @WareHouseName NVARCHAR(250), 
    @WareHouseName1 NVARCHAR(250), 
    @WareHouseID2 NVARCHAR(50), 
    @WareHouseID1 NVARCHAR(200), 
    @KindVoucherListIm NVARCHAR(200), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

SELECT @WareHouseName1 = WareHouseName FROM AT1303 WHERE WareHouseID = @WareHouseID AND DivisionID = @DivisionID
SET @KindVoucherListIm = ' (1, 5, 7, 9, 15, 17) '

IF @WareHouseID IN ('%', '')
    BEGIN
        SET @WareHouseID2 = '''%'''
        SET @WareHouseID1 = '''%'''
        SET @WareHouseName = 'WFML000110'
    END
ELSE
    BEGIN
        SET @WareHouseID2 = ' AT2006.WareHouseID '
        SET @WareHouseID1 = ' CASE WHEN KindVoucherID = 3 THEN AT2006.WareHouseID2 ELSE AT2006.WareHouseID END '
        SET @WareHouseName = + ' ' + @WareHouseName1
    END

SET @WareHouseName = ISNULL(@WareHouseName, '')

IF @IsDate = 0
    BEGIN
        SET @sSQlSelect = '
SELECT '+@WareHouseID2+' WareHouseID, N'''+@WareHouseName+''' WareHouseName, AT2007.VoucherID, AT2007.TransactionID, 
	AT2007.Orders, AT2006.VoucherTypeID, AT2006.VoucherDate, AT2006.VoucherNo, AT2006.RefNo01, AT2006.RefNo02, 
    AT2007.InventoryID, AT1302.InventoryName, AT2007.UnitID, ISNULL(AT2007.ConversionFactor, 1) ConversionFactor, 
    AT2007.ActualQuantity, AT2007.UnitPrice, AT2007.ConvertedAmount, AT2007.OriginalAmount,
    ISNULL(AT2007.ConversionFactor, 1) * ActualQuantity ConversionActualQuantity, AT9000.ExpenseOriginalAmount, 
    AT9000.ExpenseConvertedAmount, AT2006.[Description], AT2007.Notes, AT2007.DebitAccountID, AT2007.CreditAccountID, 
    AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID'
        SET @sSQlFrom = '
FROM AT2007 	
    INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
    LEFT JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
    LEFT JOIN AT1202 ON AT1202.DivisionID = AT2007.DivisionID AND AT1202.ObjectID = AT2006.ObjectID	
    LEFT JOIN AT1303 ON AT1303.DivisionID = AT2007.DivisionID AND AT1303.WareHouseID = AT2006.WareHouseID 	
    LEFT JOIN AT9000 ON AT9000.DivisionID = AT2007.DivisionID AND AT9000.TransactionID = AT2007.TransactionID AND AT9000.TransactionTypeID = ''T03'' '
        SET @sSQlWhere = '
WHERE AT2007.DivisionID = '''+@DivisionID+''' 
	AND (CASE WHEN '''+@WareHouseID+''' = ''%'' THEN ISNULL(AT1303.IsTemp, 0) ELSE 0 END = 0) 
	AND (AT2007.TranMonth + AT2007.TranYear * 100 BETWEEN ('+@FromMonthYearText+') AND ('+@ToMonthYearText+')) 
	AND KindVoucherID IN '+@KindVoucherListIm+' 
	AND (AT2007.InventoryID BETWEEN '''+@FromInventoryID+''' AND '''+@ToInventoryID+''') 
	AND AT2006.WareHouseID LIKE '''+@WareHouseID+''' '
    END
ELSE
    BEGIN
		SET @sSQlSelect = '
        --- Phan Nhap kho
 SELECT '+@WareHouseID2+' WareHouseID, '''+@WareHouseName+''' WareHouseName, AT2007.VoucherID, AT2007.TransactionID,
	AT2007.Orders, AT2006.VoucherTypeID, AT2006.VoucherDate, AT2006.VoucherNo, AT2006.RefNo01, AT2006.RefNo02, 
    AT2007.InventoryID, AT1302.InventoryName, AT2007.UnitID, ISNULL(AT2007.ConversionFactor, 1) ConversionFactor, 
    AT2007.ActualQuantity, AT2007.UnitPrice, AT2007.ConvertedAmount, AT2007.OriginalAmount, 
    (ISNULL(AT2007.ConversionFactor, 1) * ActualQuantity) ConversionActualQuantity, 
    AT9000.ExpenseOriginalAmount, AT9000.ExpenseConvertedAmount, AT2006.[Description], 
    AT2007.Notes, AT2007.DebitAccountID, AT2007.CreditAccountID, AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID '
        SET @sSQlFrom = '
FROM AT2007 	
    INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
    LEFT JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
    LEFT JOIN AT1202 ON AT1202.DivisionID = AT2007.DivisionID AND AT1202.ObjectID = AT2006.ObjectID	
    LEFT JOIN AT1303 ON AT1303.DivisionID = AT2007.DivisionID AND AT1303.WareHouseID = AT2006.WareHouseID 	
    LEFT JOIN AT9000 ON AT9000.DivisionID = AT2007.DivisionID AND AT9000.TransactionID = AT2007.TransactionID AND AT9000.TransactionTypeID = ''T03'' '
	    SET @sSQlWhere = ' 
WHERE AT2007.DivisionID =''' + @DivisionID + ''' 
    AND (CASE WHEN ''' + @WareHouseID + ''' = ''%'' THEN ISNULL(AT1303.IsTemp, 0) ELSE 0 END = 0) 
    AND (AT2006.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''') 
    AND KindVoucherID IN ' + @KindVoucherListIm + ' 
    AND (AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''') 
    AND AT2006.WareHouseID LIKE ''' + @WareHouseID + '''
        '
    END

EXEC (@sSQlSelect + @sSQlFrom + @sSQlWhere)
PRINT (@sSQlSelect)
PRINT (@sSQlFrom)
PRINT (@sSQlWhere)

--IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV2228')
--    EXEC ('CREATE VIEW AV2228 -- Tạo bởi AP2228
--        AS ' + @sSQlSelect + @sSQlFrom + @sSQlWhere)
--ELSE
--    EXEC ('ALTER VIEW AV2228 -- Tạo bởi AP2228
--        AS ' + @sSQlSelect + @sSQlFrom + @sSQlWhere)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
