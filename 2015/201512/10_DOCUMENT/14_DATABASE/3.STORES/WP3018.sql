IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP3018]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP3018]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----Create by:  Thuy Tuyen, Date 14/04/2010
----Purpose: IN the kho dvt qui doi   (tuong tu So chi tiet vat tu)
----Modify on 27/01/2013 by Bao Anh	Bo sung where DivisionID
----Edited by: [GS] [Việt Khánh] [04/08/2010]
----Edited by Thanh Sơn on 17/07/2014: Lấy dữ liệu trực tiếp từ store, không sinh view WV3018
---  WP3018 '','','','',1,1,1, 1, '2014-07-17 17:06:33.970','2014-07-17 17:06:33.970', 0

CREATE PROCEDURE [dbo].[WP3018] 
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
AS

DECLARE     
    @sSQL1 NVARCHAR(MAX), 
    @sSQL2 NVARCHAR(MAX), 
    @WareHouseName NVARCHAR(250), 
    @KindVoucherListIm NVARCHAR(200), 
    @KindVoucherListEx1 NVARCHAR(200), 
    @KindVoucherListEx2 NVARCHAR(200), 
    @ParameterName01 NVARCHAR(50), 
    @ParameterName02 NVARCHAR(50), 
    @ParameterName03 NVARCHAR(50), 
    @ParameterName04 NVARCHAR(50), 
    @ParameterName05 NVARCHAR(50), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
IF @WareHouseID IS NULL SET @WareHouseID = ''
IF @WareHouseName IS NULL SET @WareHouseName = ''
SELECT @ParameterName01 = ISNULL(UserName, SystemName) FROM AT0009 WHERE TypeID = 'T01'
SELECT @ParameterName02 = ISNULL(UserName, SystemName) FROM AT0009 WHERE TypeID = 'T02'
SELECT @ParameterName03 = ISNULL(UserName, SystemName) FROM AT0009 WHERE TypeID = 'T03'
SELECT @ParameterName04 = ISNULL(UserName, SystemName) FROM AT0009 WHERE TypeID = 'T04'
SELECT @ParameterName05 = ISNULL(UserName, SystemName) FROM AT0009 WHERE TypeID = 'T05'
        
SELECT @WareHouseName = ISNULL(WareHouseName, '') FROM AT1303 WHERE WareHouseID = @WareHouseID 
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

SET @KindVoucherListEx1 = ' (2, 4, 3, 6, 8, 10, 14, 20) '
SET @KindVoucherListEx2 = ' (2, 4, 6, 8, 10, 14, 20) '
SET @KindVoucherListIm = ' (1, 3, 5, 7, 9, 15, 17) '

 -------- Lay so du dau
IF @isDate = 0 
    SET @sSQL1 = '
SELECT 
DivisionID, InventoryID, InventoryName, 
UnitID, UnitName, 
Specification, Notes01, Notes02, Notes03, 
SUM(SignQuantity) AS BeginQuantity, 
SUM(SignAmount) AS BeginAmount, 
0 AS EndQuantity, 
0 AS EndAmount, 
Parameter01, Parameter02, Parameter03, Parameter04, Parameter05, 
ParameterID, 
ConvertedUnitID, 
ConvertedUnitName, 
SUM(ISNULL(SignConvertedQuantity, 0)) AS BeginConvertedQuantity

FROM WQ7002 AV7000

WHERE DivisionID LIKE ''' + @DivisionID + ''' 
AND ((D_C IN (''D'', ''C'') AND TranMonth + TranYear * 100 <  ' + @FromMonthYearText + ') OR D_C = ''BD'' ) 
AND WareHouseID LIKE ''' + @WareHouseID + ''' 
AND InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 

GROUP BY DivisionID, InventoryID, InventoryName, UnitID, UnitName, Specification, Notes01, Notes02, Notes03, 
Parameter01, Parameter02, Parameter03, Parameter04, Parameter05, 
ParameterID, ConvertedUnitID, ConvertedUnitName

HAVING SUM(ISNULL(SignConvertedQuantity, 0)) <> 0
'
ELSE
    SET @sSQL1 = '
SELECT DivisionID, InventoryID, InventoryName, 
UnitID, UnitName, 
Specification, Notes01, Notes02, Notes03, 
SUM(SignQuantity) AS BeginQuantity, 
SUM(SignAmount) AS BeginAmount, 
0 AS EndQuantity, 
0 AS EndAmount, 
Parameter01, Parameter02, Parameter03, Parameter04, Parameter05, 
ParameterID, 
ConvertedUnitID, 
ConvertedUnitName, 
SUM(ISNULL(SignConvertedQuantity, 0)) AS BeginConvertedQuantity

FROM WQ7002 AV7000

WHERE DivisionID LIKE ''' + @DivisionID + ''' 
AND ((D_C IN (''D'', ''C'') AND VoucherDate < ''' + @FromDateText + ''') OR D_C = ''BD'' ) 
AND WareHouseID LIKE ''' + @WareHouseID + ''' 
AND InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 

GROUP BY DivisionID, InventoryID, InventoryName, UnitID, UnitName, Specification, Notes01, Notes02, Notes03, 
Parameter01, Parameter02, Parameter03, Parameter04, Parameter05, 
ParameterID, ConvertedUnitID, ConvertedUnitName

HAVING SUM(ISNULL(SignConvertedQuantity, 0)) <> 0
'

 -- print @sSQL

IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'WV7005')
    EXEC('CREATE VIEW WV7005 -- Tạo bởi WP3018
        AS ' + @sSQL1)
ELSE
    EXEC('ALTER VIEW WV7005 -- Tạo bởi WP3018
        AS ' + @sSQL1)
 ---- Lay so phat sinh    

IF @IsDate = 0 
    BEGIN
        SET @sSQL1 = '--- Phan Nhap kho
SELECT 
AT2007.DivisionID,
AT2007.VoucherID, 
N''T05'' AS TransactionTypeID, 
AT2007.TransactionID, 
AT2007.Orders, 
VoucherDate, 
VoucherNo, 
VoucherDate AS ImVoucherDate, 
VoucherNo AS ImVoucherNo, 
SourceNo AS ImSourceNo, 
LimitDate AS ImLimitDate, 
WareHouseID AS ImWareHouseID, 
AT2007.ActualQuantity AS ImQuantity, 
AT2007.UnitPrice AS ImUnitPrice, 
AT2007.ConvertedAmount AS ImConvertedAmount, 
AT2007.OriginalAmount AS ImOriginalAmount,             
NULL AS ExVoucherDate, 
NULL AS ExVoucherNo, 
NULL AS ExSourceNo, 
NULL AS ExLimitDate, 
NULL AS ExWareHouseID, 
NULL AS ExQuantity, 
NULL AS ExUnitPrice, 
NULL AS ExConvertedAmount, 
NULL AS ExOriginalAmount, 
VoucherTypeID, 
AT2006.Description, 
AT2007.Notes, 
AT2007.InventoryID, 
AT1302.InventoryName, 
AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, 
AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, 
AT2007.UnitID, 
AT1304.UnitName,             
AT2006.ObjectID, AT1202.ObjectName, 
ConvertedUnitID, 
T04.UnitName AS ConvertedUnitName, 
Parameter01 AS Parameter01, Parameter02 AS Parameter02, Parameter03 AS Parameter03, 
Parameter04 AS Parameter04, Parameter05 AS Parameter05, 
AT2007.InventoryID + ''T01'' + CAST(ISNULL(Parameter01, 0) AS NVARCHAR) + ''T02'' + CAST(ISNULL(Parameter02, 0) AS NVARCHAR) + ''T03'' + CAST(ISNULL(Parameter03, 0) AS NVARCHAR) + ''T04'' + CAST(ISNULL(Parameter04, 0) AS NVARCHAR) + ''T05'' + CAST(ISNULL(Parameter03, 0) AS NVARCHAR) AS ParameterID, 
AT2007.ConvertedQuantity AS ImConvertedQuantity, 
NULL AS ExConvertedQuantity

FROM AT2007 INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID and AT2007.DivisionID = AT1302.DivisionID
LEFT JOIN AT1304 ON AT1304.UnitID = AT2007.UnitID and AT2007.DivisionID = AT1304.DivisionIDINNER JOIN AT2006 ON At2006.VoucherID = AT2007.VoucherID and AT2007.DivisionID = AT2006.DivisionID
LEFT JOIN AT1202 ON AT2006.ObjectID = AT1202.ObjectID and AT2006.DivisionID = AT1202.DivisionID
LEFT JOIN AT1304 T04 ON T04.UnitID = AT2007.ConvertedUnitID and T04.DivisionID = AT2007.DivisionID

WHERE AT2007.DivisionID = ''' + @DivisionID + ''' 
AND AT2007.TranMonth + AT2007.TranYear * 100 BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText + 'AND KindVoucherID IN ' + @KindVoucherListIm + ' 
AND (AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''') 
AND WareHouseID LIKE ''' + @WareHouseID + '''

UNION
        '
        SET @sSQL2 = '--- Phan Xuat kho
SELECT 
AT2007.DivisionID,
AT2007.VoucherID, 
N''T06'' AS TransactionTypeID, 
AT2007.TransactionID, 
AT2007.Orders, 
VoucherDate, 
VoucherNo, 
NULL AS ImVoucherDate, 
NULL AS ImVoucherNo, 
NULL AS ImSourceNo, 
NULL AS ImLimitDate, 
NULL AS ExWareHouseID, 
NULL AS ImQuantity, 
NULL AS ImUnitPrice, 
NULL AS ImConvertedAmount, 
NULL AS ImOriginalAmount, 
VoucherDate AS ExVoucherDate, 
VoucherNo AS ExVoucherNo, 
SourceNo AS ExSourceNo, 
LimitDate AS ExLimitDate, 
(CASE WHEN KindVoucherID = 3 THEN WareHouseID2 ELSE WareHouseID END) AS ExWareHouseID, 
AT2007.ActualQuantity AS ExQuantity, 
AT2007.UnitPrice AS ExUnitPrice, 
AT2007.ConvertedAmount AS ExConvertedAmount, 
AT2007.OriginalAmount AS ExOriginalAmount, 
VoucherTypeID, 
AT2006.Description, 
AT2007.Notes, 
AT2007.InventoryID, 
AT1302.InventoryName, 
AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, 
AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, 
AT2007.UnitID, 
AT1304.UnitName, 
AT2006.ObjectID, AT1202.ObjectName, 
ConvertedUnitID, 
T04.UnitName AS ConvertedUnitName, 
Parameter01, Parameter02, Parameter03, Parameter04, Parameter05, 
AT2007.InventoryID + ''T01'' + CAST(ISNULL(Parameter01, 0) AS NVARCHAR) + ''T02'' + CAST(ISNULL(Parameter02, 0) AS NVARCHAR) + ''T03'' + CAST(ISNULL(Parameter03, 0) AS NVARCHAR) + ''T04'' + CAST(ISNULL(Parameter04, 0) AS NVARCHAR) + ''T05'' + CAST(ISNULL(Parameter03, 0) AS NVARCHAR) AS ParameterID, 
NULL AS ImConvertedQuantity, 
ISNULL(ConvertedQuantity, 0) AS ExConvertedQuantity

FROM AT2007 INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID and AT2007.DivisionID = AT1302.DivisionID
LEFT JOIN AT1304 ON AT1304.UnitID = AT2007.UnitID and AT2007.DivisionID = AT1304.DivisionID
INNER JOIN AT2006 ON At2006.VoucherID = AT2007.VoucherID and AT2007.DivisionID = AT2006.DivisionID
LEFT JOIN AT1202 ON AT2006.ObjectID = AT1202.ObjectID and AT2006.DivisionID = AT1202.DivisionID
LEFT JOIN AT1304 T04 ON T04.UnitID = AT2007.ConvertedUnitID and T04.DivisionID = AT2007.DivisionID
WHERE AT2007.DivisionID = ''' + @DivisionID + ''' 
AND AT2007.TranMonth + AT2007.TranYear*100 BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText + '
AND AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
AND KindVoucherID IN ' + @KindVoucherListEx1 + '
AND ((KindVoucherID  IN ' + @KindVoucherListEx2 + ' AND WareHouseID LIKE''' + @WareHouseID + ''') OR (KindVoucherID = 3 AND WareHouseID2 LIKE ''' + @WareHouseID + '''))        '
    END
ELSE
    BEGIN
        SET @sSQL1 = '--- Phan Nhap kho
SELECT 
AT2007.DivisionID,
AT2007.VoucherID, 
N''T05'' AS TransactionTypeID, 
AT2007.TransactionID, 
AT2007.Orders, 
VoucherDate, 
VoucherNo, 
VoucherDate AS ImVoucherDate, 
VoucherNo AS ImVoucherNo, 
SourceNo AS ImSourceNo, 
LimitDate AS ImLimitDate, 
WareHouseID AS ImWareHouseID, 
AT2007.ActualQuantity AS ImQuantity, 
AT2007.UnitPrice AS ImUnitPrice, 
AT2007.ConvertedAmount AS ImConvertedAmount, 
AT2007.OriginalAmount AS ImOriginalAmount,             
NULL AS ExVoucherDate, 
NULL AS ExVoucherNo, 
NULL AS ExSourceNo, 
NULL AS ExLimitDate, 
NULL AS ExWareHouseID, 
NULL AS ExQuantity, 
NULL AS ExUnitPrice, 
NULL AS ExConvertedAmount, 
NULL AS ExOriginalAmount,             
VoucherTypeID, 
AT2006.Description, 
AT2007.Notes, 
AT2007.InventoryID, 
AT1302.InventoryName, 
AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, 
AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, 
AT2007.UnitID, AT1304.UnitName, 
AT2006.ObjectID, AT1202.ObjectName, 
ConvertedUnitID, 
T04.UnitName AS ConvertedUnitName, 
Parameter01 AS Parameter01, Parameter02 AS Parameter02, Parameter03 AS Parameter03, 
Parameter04 AS Parameter04, Parameter05 AS Parameter05, 
AT2007.InventoryID + ''T01'' + CAST(ISNULL(Parameter01, 0) AS NVARCHAR) + ''T02'' + CAST(ISNULL(Parameter02, 0) AS NVARCHAR) + ''T03'' + CAST(ISNULL(Parameter03, 0) AS NVARCHAR) + ''T04'' + CAST(ISNULL(Parameter04, 0) AS NVARCHAR) + ''T05'' + CAST(ISNULL(Parameter03, 0) AS NVARCHAR) AS ParameterID, 
AT2007.ConvertedQuantity AS ImConvertedQuantity, 
NULL AS ExConvertedQuantity

FROM AT2007 INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID and AT2007.DivisionID = AT1302.DivisionID
LEFT JOIN AT1304 ON AT1304.UnitID = AT2007.UnitID and AT2007.DivisionID = AT1304.DivisionID
INNER JOIN AT2006 ON At2006.VoucherID = AT2007.VoucherID and AT2006.DivisionID = AT2007.DivisionID
LEFT JOIN AT1202 ON AT2006.ObjectID = AT1202.ObjectID and AT2006.DivisionID = AT1202.DivisionID
LEFT JOIN AT1304 T04 ON T04.UnitID = AT2007.ConvertedUnitID and T04.DivisionID = AT2007.DivisionID

WHERE AT2007.DivisionID = ''' + @DivisionID + ''' 
AND AT2006.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + '''
AND KindVoucherID IN ' + @KindVoucherListIm + ' 
AND AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
AND WareHouseID LIKE ''' + @WareHouseID + '''

UNION
        '
        SET @sSQL2 = '--- Phan Xuat kho
SELECT 
AT2007.DivisionID,
AT2007.VoucherID, 
N''T06'' AS TransactionTypeID, 
AT2007.TransactionID, 
AT2007.Orders, 
VoucherDate, 
VoucherNo, 
NULL AS ImVoucherDate, 
NULL AS ImVoucherNo, 
NULL AS ImSourceNo, 
NULL AS ImLimitDate, 
NULL AS ExWareHouseID, 
NULL AS ImQuantity, 
NULL AS ImUnitPrice, 
NULL AS ImConvertedAmount, 
NULL AS ImOriginalAmount, 
VoucherDate AS ExVoucherDate, 
VoucherNo AS ExVoucherNo, 
SourceNo AS ExSourceNo, 
LimitDate AS ExLimitDate, 
(CASE WHEN KindVoucherID = 3 THEN WareHouseID2 ELSE WareHouseID END) AS ExWareHouseID, 
AT2007.ActualQuantity AS ExQuantity, 
AT2007.UnitPrice AS ExUnitPrice, 
AT2007.ConvertedAmount AS ExConvertedAmount, 
AT2007.OriginalAmount AS ExOriginalAmount, 
VoucherTypeID, 
AT2006.Description, 
AT2007.Notes, 
AT2007.InventoryID, 
AT1302.InventoryName, 
AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, 
AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, 
AT2007.UnitID, 
AT1304.UnitName, 
AT2006.ObjectID, AT1202.ObjectName, 
ConvertedUnitID, 
T04.UnitName AS ConvertedUnitName, Parameter01, Parameter02, Parameter03, Parameter04, Parameter05, 
AT2007.InventoryID + ''T01'' + CAST(ISNULL(Parameter01, 0) AS NVARCHAR) + ''T02'' + CAST(ISNULL(Parameter02, 0) AS NVARCHAR) + ''T03'' + CAST(ISNULL(Parameter03, 0) AS NVARCHAR) + ''T04'' + CAST(ISNULL(Parameter04, 0) AS NVARCHAR) + ''T05'' + CAST(ISNULL(Parameter03, 0) AS NVARCHAR) AS ParameterID, 
NULL AS ImConvertedQuantity, 
ISNULL(ConvertedQuantity, 0) AS ExConvertedQuantity

FROM AT2007 INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID and AT2007.DivisionID = AT1302.DivisionID
INNER JOIN AT2006 ON At2006.VoucherID = AT2007.VoucherID and AT2007.DivisionID = AT2006.DivisionID
LEFT JOIN AT1202 ON AT2006.ObjectID = AT1202.ObjectID and AT2006.DivisionID = AT1202.DivisionID
LEFT JOIN AT1304 ON AT1304.UnitID = AT2007.UnitID and AT2007.DivisionID = AT1304.DivisionID
LEFT JOIN AT1304 T04 ON T04.UnitID = AT2007.ConvertedUnitID and AT2007.DivisionID = T04.DivisionID

WHERE AT2007.DivisionID = ''' + @DivisionID + ''' 
AND AT2006.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + '''
AND AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
AND KindVoucherID IN ' + @KindVoucherListEx1 + '
AND ((KindVoucherID  IN ' + @KindVoucherListEx2 + ' AND WareHouseID LIKE''' + @WareHouseID + ''') OR (KindVoucherID = 3 AND WareHouseID2 LIKE ''' + @WareHouseID + '''))
'
    END

 --- Print @sSQL
IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'WV3028')
    EXEC('CREATE VIEW WV3028 -- Tạo bởi WP3018
        AS ' + @sSQL1 + @sSQL2)
ELSE
    EXEC('ALTER VIEW WV3028 -- Tạo bởi WP3018
        AS ' + @sSQL1 + @sSQL2)

 --- Lay du su va phat sinh
 -- INT @WareHouseName
SET @sSQL1 = '
SELECT 
AV3028.DivisionID,
N''' + @WareHouseID + ''' AS WareHouseID, 
N''' + @WareHouseName + ''' AS WareHouseName, 
AV3028.VoucherID, 
AV3028.TransactionTypeID, 
AV3028.TransactionID, 
AV3028.Orders, 
ISNULL(AV3028.VoucherDate, '''') AS VoucherDate, 
ISNULL(AV3028.VoucherNo, '''') AS VoucherNo, 
AV3028.ImVoucherDate, 
AV3028.ImVoucherNo, 
AV3028.ImSourceNo, 
AV3028.ImLimitDate, 
ISNULL(AV3028.ImQuantity, 0) AS ImQuantity, 
AV3028.ImUnitPrice, 
ISNULL(AV3028.ImConvertedAmount, 0) AS ImConvertedAmount, 
ISNULL(AV3028.ImOriginalAmount, 0) AS ImOriginalAmount, 
AV3028.ExVoucherDate, 
AV3028.ExVoucherNo, 
AV3028.ExSourceNo, 
AV3028.ExLimitDate, 
ISNULL(AV3028.ExQuantity, 0) AS ExQuantity, 
AV3028.ExUnitPrice, 
ISNULL(AV3028.ExConvertedAmount, 0) AS ExConvertedAmount, 
AV3028.ExOriginalAmount, 
AV3028.VoucherTypeID, 
AV3028.Description, 
AV3028.Notes, 
ISNULL(AV3028.InventoryID, AV7005.InventoryID) AS InventoryID, 
ISNULL(AV3028.InventoryName, AV7005.InventoryName) AS InventoryName, 
ISNULL(AV3028.Specification, AV7005.Specification) AS Specification, 
ISNULL(AV3028.Notes01, AV7005.Notes01) AS Notes01, 
ISNULL(AV3028.Notes02, AV7005.Notes02) AS Notes02, 
ISNULL(AV3028.Notes03, AV7005.Notes03) AS Notes03, 
AV3028.Ana01ID, AV3028.Ana02ID, AV3028.Ana03ID, AV3028.Ana04ID, AV3028.Ana05ID, 
ISNULL(AV3028.UnitID, AV7005.UnitID) AS UnitID, 
ISNULL(AV3028.UnitName, AV7005.UnitName) AS UnitName, 
ISNULL(AV7005.BeginQuantity, 0) AS BeginQuantity, 
AV3028.ObjectID, AV3028.ObjectName, 
ISNULL(AV3028.ConvertedUnitID, AV7005.ConvertedUnitID) AS ConvertedUnitID, 
ISNULL(AV3028.ConvertedUnitName, AV7005.ConvertedUnitName) AS ConvertedUnitName, 
ISNULL(AV7005.BeginConvertedQuantity, 0) AS BeginConvertedQuantity, 
N''' + @ParameterName01 + ''' AS ParameterName01, 
N''' + @ParameterName02 + ''' AS ParameterName02, 
N''' + @ParameterName03 + ''' AS ParameterName03, 
N''' + @ParameterName04 + ''' AS ParameterName04, 
N''' + @ParameterName05 + ''' AS ParameterName05, 
ISNULL(AV3028.Parameter01, AV7005.Parameter01) AS Parameter01, ISNULL(AV3028.Parameter02, AV7005.Parameter02 ) AS Parameter02, 
ISNULL(AV3028.Parameter03, AV7005.Parameter03 ) AS Parameter03, ISNULL(AV3028.Parameter04, AV7005.Parameter04 ) AS Parameter04, 
ISNULL(AV3028.Parameter05, AV7005.Parameter05 ) AS Parameter05, 
ISNULL(AV3028.ParameterID, AV7005.ParameterID) AS ParameterID, 
ISNULL(AV3028.ImConvertedQuantity, 0) AS ImConvertedQuantity, 
ISNULL(AV3028.ExConvertedQuantity, 0) AS ExConvertedQuantity

FROM WV3028 AV3028 FULL JOIN WV7005 AV7005 ON AV7005.InventoryID = AV3028.InventoryID 
AND ISNULL(AV7005.ParameterID, '''') = ISNULL(AV3028.ParameterID, '''') 
AND ISNULL(AV7005.ParameterID, AV3028.ParameterID) <> '' T010.00T020.00T030.00T040.00T050.00 ''

WHERE ISNULL(ImConvertedQuantity, 0) <> 0 
OR ISNULL(ExConvertedQuantity, 0) <> 0 
OR ISNULL(AV7005.BeginConvertedQuantity, 0) <> 0
'
EXEC (@sSQL1)
PRINT (@sSQL1)
--IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'WV3018')
--    EXEC('CREATE VIEW WV3018 -- Tạo bởi WP3018
--        AS ' + @sSQL1)
--ELSE
--    EXEC('ALTER VIEW WV3018 -- Tạo bởi WP3018
--        AS ' + @sSQL1)
    
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
    