/****** Object: StoredProcedure [dbo].[AP1326] Script Date: 07/29/2010 09:45:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- CREATE by Nguyen Quoc Huy, Date 21/05/2007
---- Purpose: Chi tiet nhap xuat theo KIT .
---- Edit by: Dang Le Bao Quynh; Date: 16/01/2009
---- Purpose: Bo sung truong hop xuat hang mua tra lai

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1326] 
    @DivisionID NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @KIT NVARCHAR(50), 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @IsDate TINYINT
AS

DECLARE 
    @sSQl NVARCHAR(4000), 
    @sSQlNhap NVARCHAR(4000), 
    @sSQlXuat1 NVARCHAR(4000), 
    @sSQlXuat2 NVARCHAR(4000), 
    @WareHouseName NVARCHAR(4000), 
    @WareHouseName1 NVARCHAR(4000), 
    @WareHouseID1 NVARCHAR(4000), 
    @WareHouseID2 NVARCHAR(4000), 
    @KindVoucherListIm NVARCHAR(4000), 
    @KindVoucherListEx1 NVARCHAR(4000), 
    @KindVoucherListEx2 NVARCHAR(4000), 
    @IsInner TINYINT, 
    @IsAll TINYINT,      --- 0: Nhap, 
                            --- 1: Xuat, 
                            --- 3: Tat ca
    @FromInventoryID NVARCHAR(4000), 
    @ToInventoryID NVARCHAR(4000)
        
SET @sSQl = '' 
SET @sSQlNhap = '' 
SET @sSQlXuat1 = '' 
SET @sSQlXuat2 = '' 
SET @WareHouseName = '' 
SET @WareHouseName1 = '' 
SET @WareHouseID1 = '' 
SET @WareHouseID2 = '' 
SET @KindVoucherListIm = '' 
SET @KindVoucherListEx1 = '' 
SET @KindVoucherListEx2 = '' 
SET @FromInventoryID = '' 
SET @ToInventoryID = ''

SET @FromInventoryID = (SELECT TOP 1 ItemID FROM AT1326 WHERE DivisionID = @DivisionID ORDER BY ItemID Asc)
SET @FromInventoryID = ISNULL(@FromInventoryID, '')

SET @ToInventoryID = (SELECT TOP 1 ItemID FROM AT1326 WHERE DivisionID = @DivisionID ORDER BY ItemID DESC)
SET @ToInventoryID = ISNULL(@ToInventoryID, '')

SELECT @WareHouseName1 = WareHouseName FROM AT1303 WHERE WareHouseID = @WareHouseID AND DivisionID = @DivisionID
SET @WareHouseName1 = ISNULL(@WareHouseName1, '')

SET @IsInner = 0
SET @IsAll = 1

IF @IsInner = 0 
    BEGIN 
        SET @KindVoucherListEx1 = '(2, 4, 8, 10) '
        SET @KindVoucherListEx2 = '(2, 4, 8, 10) '
        SET @KindVoucherListIm = '(1, 5, 7, 9) '
    END
ELSE
    BEGIN
        SET @KindVoucherListEx1 = '(2, 4, 3, 8, 10) '
        SET @KindVoucherListEx2 = '(2, 4, 8, 10) '
        SET @KindVoucherListIm = '(1, 3, 5, 7, 9) '
    END

IF @WareHouseID IN ('%', '')
    BEGIN 
        SET @WareHouseID2 = '''%'''
        SET @WareHouseID1 = '''%'''
        SET @WareHouseName = 'Taát caû caùc kho'
    END
ELSE
    BEGIN
        SET @WareHouseID2 = ' AT2006.WareHouseID ' 
        SET @WareHouseID1 = ' CASE WHEN KindVoucherID = 3 THEN AT2006.WareHouseID2 ELSE AT2006.WareHouseID END '
        SET @WareHouseName = + '"' + @WareHouseName1 + '"'
    END 

IF @IsDate = 0 
    BEGIN
/* 
SET @sSQlNhap = '
--- Phan Nhap kho
SELECT ' + @WareHouseID2 + ' AS WareHouseID, 
''' + @WareHouseName + ''' AS WareHouseName, 
AT2007.VoucherID, 
AT2007.TransactionID, 
AT2007.Orders, 
VoucherDate, 
VoucherNo, 
VoucherDate AS ImVoucherDate, 
VoucherNo AS ImVoucherNo, 
SourceNo AS ImSourceNo, 
LimitDate AS ImLimitDate, 
AT2006.WareHouseID AS ImWareHouseID, 
AT2006.RefNo01 AS ImRefNo01, AT2006.RefNo02 AS ImRefNo02, 
AT2007.ActualQuantity AS ImQuantity, 
AT2007.UnitPrice AS ImUnitPrice, 
AT2007.ConvertedAmount AS ImConvertedAmount, 
AT2007.OriginalAmount AS ImOriginalAmount, 
ISNULL(AT2007.ConversionFactor, 1) * ActualQuantity AS ImConvertedQuantity, 
Null AS ExVoucherDate, 
Null AS ExVoucherNo, 
Null AS ExSourceNo, 
Null AS ExLimitDate, 
Null AS ExWareHouseID, 
Null AS ExRefNo01, Null AS ExRefNo02, 
0 AS ExQuantity, 
Null AS ExUnitPrice, 
0 AS ExConvertedAmount, 
0 AS ExOriginalAmount, 
0 AS ExConvertedQuantity, 
VoucherTypeID, 
AT2006.Description, 
AT2007.Notes, 
AT2007.InventoryID, 
AT1302.InventoryName, 
AT2007.UnitID, 
ISNULL(AT2007.ConversionFactor, 1) AS ConversionFactor, 
ISNULL(AV7015.BeginQuantity, 0) AS BeginQuantity, 
ISNULL(AV7015.BeginAmount, 0) AS BeginAmount, 
(CASE WHEN KindVoucherID = 7 THEN 3 ELSE 1 END) AS ImExOrders, 
AT2007.DebitAccountID, AT2007.CreditAccountID, 
AT2006.ObjectID, 
AT1202.ObjectName, 
AT1302.Notes01, 
AT1302.Notes02, 
AT1302.Notes03
FROM AT2007 INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID
INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID
LEFT JOIN AV7015 ON AV7015.InventoryID = AT2007.InventoryID
INNER JOIN AT1303 ON AT1303.WareHouseID = AT2006.WareHouseID 
LEFT JOIN AT1202 ON AT1202.ObjectID = AT2006.ObjectID 
WHERE AT2007.DivisionID = ''' + @DivisionID + ''' AND
(CASE WHEN ''' + @WareHouseID + ''' = ''%'' THEN AT1303.IsTemp ELSE 0 END = 0) AND
(AT2007.TranMonth + AT2007.TranYear * 100 BETWEEN (' + STR(@FromMonth) + ' + ' + STR(@FromYear) + ' * 100) AND (' + STR(@ToMonth) + ' + ' + STR(@ToYear) + ' * 100)) AND
KindVoucherID IN ' + @KindVoucherListIm + ' AND
(AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''') AND
AT2006.WareHouseID like ''' + @WareHouseID + ''''
*/

        --- Phan Xuat kho
        SET @sSQlXuat1 = '
            SELECT ' + @WareHouseID1 + ' AS WareHouseID, 
                ''' + @WareHouseName + ''' AS WareHouseName, 
                AT2007.VoucherID, 
                AT2007.TransactionID, 
                AT2007.Orders, 
                VoucherDate, 
                VoucherNo, 
                Null AS ImVoucherDate, 
                Null AS ImVoucherNo, 
                Null AS ImSourceNo, 
                Null AS ImLimitDate, 
                Null AS ImWareHouseID, 
                Null AS ImRefNo01, 
                Null AS ImRefNo02, 
                0 AS ImQuantity, 
                Null AS ImUnitPrice, 
                0 AS ImConvertedAmount, 
                0 AS ImOriginalAmount, 
                0 AS ImConvertedQuantity, 
                VoucherDate AS ExVoucherDate, 
                VoucherNo AS ExVoucherNo, 
                SourceNo AS ExSourceNo, 
                LimitDate AS ExLimitDate, 
                (CASE WHEN KindVoucherID = 3 THEN WareHouseID2 ELSE AT2006.WareHouseID END) AS ExWareHouseID, 
                AT2006.RefNo01 AS ExRefNo01, 
                AT2006.RefNo02 AS ExRefNo02, 
                AT2007.ActualQuantity AS ExQuantity, 
                AT2007.UnitPrice AS ExUnitPrice, 
                AT2007.ConvertedAmount AS ExConvertedAmount, 
                AT2007.OriginalAmount AS ExOriginalAmount, 
                ISNULL(AT2007.ConversionFactor, 1) * ActualQuantity AS ExConvertedQuantity, 
                VoucherTypeID, 
                AT2006.Description, 
                AT2007.Notes, 
                AT2007.InventoryID, 
                AT1302.InventoryName, 
                AT2007.UnitID, 
                ISNULL(AT2007.ConversionFactor, 1) AS ConversionFactor, 
                ISNULL(AV7015.BeginQuantity, 0) AS BeginQuantity, 
                ISNULL(AV7015.BeginAmount, 0) AS BeginAmount, 
                2 AS ImExOrders, 
                AT2007.DebitAccountID, AT2007.CreditAccountID, 
                AT2006.ObjectID, 
                AT1202.ObjectName, 
                AT1302.Notes01, 
                AT1302.Notes02, 
                AT1302.Notes03,
                AT2007.DivisionID
            '
        SET @sSQlXuat2 = '
            FROM AT2007 INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID 
                    AND AT1302.DivisionID = AT2007.DivisionID
                INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID 
                    AND AT2006.DivisionID = AT2007.DivisionID
                LEFT JOIN AV7015 ON AV7015.InventoryID = AT2007.InventoryID 
                    AND AV7015.DivisionID = AT2007.DivisionID
                INNER JOIN AT1303 ON AT1303.WareHouseID = (CASE WHEN KindVoucherID = 3 THEN AT2006.WareHouseID2 ELSE AT2006.WareHouseID END) 
                     AND AT1303.DivisionID = AT2007.DivisionID
                LEFT JOIN AT1202 ON AT1202.ObjectID = AT2006.ObjectID 
                     AND AT1202.DivisionID = AT2006.DivisionID
            WHERE AT2007.DivisionID = ''' + @DivisionID + ''' 
                AND (CASE WHEN ''' + @WareHouseID + ''' = ''%'' THEN AT1303.IsTemp ELSE 0 END = 0) 
                AND AT2006.KindVoucherID IN ' + @KindVoucherListEx1 + ' 
                AND (AT2007.TranMonth + AT2007.TranYear * 100 BETWEEN (' + STR(@FromMonth) + ' + ' + STR(@FromYear) + ' * 100) AND (' + STR(@ToMonth) + ' + ' + STR(@ToYear) + ' * 100)) 
                AND (AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''') 
                AND ((KindVoucherID IN ' + @KindVoucherListEx2 + ' AND AT2006.WareHouseID like''' + @WareHouseID + ''') OR (KindVoucherID = 3 AND WareHouseID2 like ''' + @WareHouseID + ''')) 
            '
    END
ELSE
    BEGIN
/* 
SET SET @sSQlNhap = '
--- Phan Nhap kho
SELECT ' + @WareHouseID2 + ' AS WareHouseID, 
''' + @WareHouseName + ''' AS WareHouseName, 
AT2007.VoucherID, 
AT2007.TransactionID, 
AT2007.Orders, 
VoucherDate, 
VoucherNo, 
VoucherDate AS ImVoucherDate, 
VoucherNo AS ImVoucherNo, 
SourceNo AS ImSourceNo, 
LimitDate AS ImLimitDate, 
AT2006.WareHouseID AS ImWareHouseID, 
AT2006.RefNo01 AS ImRefNo01, AT2006.RefNo02 AS ImRefNo02, 
AT2007.ActualQuantity AS ImQuantity, 
AT2007.UnitPrice AS ImUnitPrice, 
AT2007.ConvertedAmount AS ImConvertedAmount, 
AT2007.OriginalAmount AS ImOriginalAmount, 
ISNULL(AT2007.ConversionFactor, 1) * ActualQuantity AS ImConvertedQuantity, 
Null AS ExVoucherDate, 
Null AS ExVoucherNo, 
Null AS ExSourceNo, 
Null AS ExLimitDate, 
Null AS ExWareHouseID, 
Null AS ExRefNo01, Null AS ExRefNo02, 
0 AS ExQuantity, 
Null AS ExUnitPrice, 
0 AS ExConvertedAmount, 
0 AS ExOriginalAmount, 
0 AS ExConvertedQuantity, 
VoucherTypeID, 
AT2006.Description, 
AT2007.Notes, 
AT2007.InventoryID, 
AT1302.InventoryName, 
AT2007.UnitID, 
ISNULL(AT2007.ConversionFactor, 1) AS ConversionFactor, 
ISNULL(AV7015.BeginQuantity, 0) AS BeginQuantity, 
ISNULL(AV7015.BeginAmount, 0) AS BeginAmount, 
(CASE WHEN KindVoucherID = 7 THEN 3 ELSE 1 END) AS ImExOrders, 
AT2007.DebitAccountID, AT2007.CreditAccountID, 
AT2006.ObjectID, 
AT1202.ObjectName, 
AT1302.Notes01, 
AT1302.Notes02, 
AT1302.Notes03
FROM AT2007 INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID
INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID
LEFT JOIN AV7015 ON AV7015.InventoryID = AT2007.InventoryID
INNER JOIN AT1303 ON AT1303.WareHouseID = AT2006.WareHouseID
LEFT JOIN AT1202 ON AT1202.ObjectID = AT2006.ObjectID 
WHERE AT2007.DivisionID = ''' + @DivisionID + ''' AND
(CASE WHEN ''' + @WareHouseID + ''' = ''%'' THEN AT1303.IsTemp ELSE 0 END = 0) AND
(AT2006.VoucherDate BETWEEN ''' + Convert(NVARCHAR(50), @FromDate, 21) + ''' AND ''' + convert(NVARCHAR(50), @ToDate, 21) + ''') AND
KindVoucherID IN ' + @KindVoucherListIm + ' AND
(AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''') AND
AT2006.WareHouseID like ''' + @WareHouseID + ''''
*/

        --- Phan Xuat kho
        SET @sSQlXuat1 = '
            SELECT ' + @WareHouseID1 + ' AS WareHouseID, 
                ''' + @WareHouseName + ''' AS WareHouseName, 
                AT2007.VoucherID, 
                AT2007.TransactionID, 
                AT2007.Orders, 
                VoucherDate, 
                VoucherNo, 
                Null AS ImVoucherDate, 
                Null AS ImVoucherNo, 
                Null AS ImSourceNo, 
                Null AS ImLimitDate, 
                Null AS ImWareHouseID, 
                Null AS ImRefNo01, 
                Null AS ImRefNo02, 
                0 AS ImQuantity, 
                Null AS ImUnitPrice, 
                0 AS ImConvertedAmount, 
                0 AS ImOriginalAmount, 
                0 AS ImConvertedQuantity, 
                VoucherDate AS ExVoucherDate, 
                VoucherNo AS ExVoucherNo, 
                SourceNo AS ExSourceNo, 
                LimitDate AS ExLimitDate, 
                (CASE WHEN KindVoucherID = 3 THEN WareHouseID2 ELSE AT2006.WareHouseID END) AS ExWareHouseID, 
                AT2006.RefNo01 AS ExRefNo01, 
                AT2006.RefNo02 AS ExRefNo02, 
                AT2007.ActualQuantity AS ExQuantity, 
                AT2007.UnitPrice AS ExUnitPrice, 
                AT2007.ConvertedAmount AS ExConvertedAmount, 
                AT2007.OriginalAmount AS ExOriginalAmount, 
                ISNULL(AT2007.ConversionFactor, 1) * ActualQuantity AS ExConvertedQuantity, 
                VoucherTypeID, 
                AT2006.Description, 
                AT2007.Notes, 
                AT2007.InventoryID, 
                AT1302.InventoryName, 
                AT2007.UnitID, 
                ISNULL(AT2007.ConversionFactor, 1) AS ConversionFactor, 
                ISNULL(AV7015.BeginQuantity, 0) AS BeginQuantity, 
                ISNULL(AV7015.BeginAmount, 0) AS BeginAmount, 
                2 AS ImExOrders, 
                AT2007.DebitAccountID, 
                AT2007.CreditAccountID, 
                AT2006.ObjectID, 
                AT1202.ObjectName, 
                AT1302.Notes01, 
                AT1302.Notes02, 
                AT1302.Notes03,
                AT2007.DivisionID
            '
        SET @sSQlXuat2 = '
            FROM AT2007 INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID
                    AND AT1302.DivisionID = AT2007.DivisionID
                INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID
                    AND AT2006.DivisionID = AT2007.DivisionID
                LEFT JOIN AV7015 ON AV7015.InventoryID = AT2007.InventoryID
                    AND AV7015.DivisionID = AT2007.DivisionID
                INNER JOIN AT1303 ON AT1303.WareHouseID = (CASE WHEN KindVoucherID = 3 THEN AT2006.WareHouseID2 ELSE AT2006.WareHouseID END) 
                    AND AT1303.DivisionID = AT2007.DivisionID
                LEFT JOIN AT1202 ON AT1202.ObjectID = AT2006.ObjectID 
                    AT1202.DivisionID = AT2006.DivisionID 
            WHERE AT2007.DivisionID = ''' + @DivisionID + ''' 
                AND (CASE WHEN ''' + @WareHouseID + ''' = ''%'' THEN AT1303.IsTemp ELSE 0 END = 0) 
                AND (AT2006.VoucherDate BETWEEN ''' + Convert(NVARCHAR(50), @FromDate, 21) + ''' AND ''' + convert(NVARCHAR(50), @ToDate, 21) + ''') 
                AND (AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''') 
                AND ((KindVoucherID IN ' + @KindVoucherListEx2 + ' 
                AND AT2006.WareHouseID like''' + @WareHouseID + ''') OR (KindVoucherID = 3 AND WareHouseID2 like ''' + @WareHouseID + ''')) 
            '
    END
        
IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV1327')
    IF @IsAll = 0 -- 0: Nhap
        EXEC('CREATE VIEW AV1327 AS ' + @sSQlNhap)
    ELSE IF @IsAll = 1 --1: Xuat
        EXEC('CREATE VIEW AV1327 AS ' + @sSQlXuat1 + @sSQlXuat2)
    ELSE IF @IsAll = 2 --3: Tat ca
        EXEC('CREATE VIEW AV1327 AS ' + @sSQlNhap + ' Union ' + @sSQlXuat1 + @sSQlXuat2)
ELSE
    IF @IsAll = 0 -- 0: Nhap
        EXEC('ALTER VIEW AV1327 AS ' + @sSQlNhap)
    ELSE IF @IsAll = 1 --1: Xuat
        EXEC('ALTER VIEW AV1327 AS ' + @sSQlXuat1 + @sSQlXuat2)
    ELSE IF @IsAll = 2 --3: Tat ca
        EXEC('ALTER VIEW AV1327 AS ' + @sSQlNhap + ' Union ' + @sSQlXuat1 + @sSQlXuat2)

--- phat sinh
SET @sSQL = '
    SELECT AV1327.WareHouseID, 
        AV1327.WareHouseName, 
        AV1327.VoucherID, 
        AV1327.TransactionID, 
        AV1327.Orders, 
        AV1327.VoucherDate,         
        AV1327.VoucherNo, 
        AV1327.ImVoucherDate, 
        AV1327.ImVoucherNo, 
        AV1327.ImSourceNo, 
        AV1327.ImLimitDate, 
        AV1327.ImWareHouseID, 
        AV1327.ImRefNo01, 
        AV1327.ImRefNo02, 
        AV1327.ImQuantity, 
        AV1327.ImUnitPrice, 
        AV1327.ImConvertedAmount, 
        AV1327.ImOriginalAmount, 
        AV1327.ImConvertedQuantity, 
        AV1327.ExVoucherDate, 
        AV1327.ExVoucherNo, 
        AV1327.ExSourceNo, 
        AV1327.ExLimitDate, 
        AV1327.ExWareHouseID, 
        AV1327.ExRefNo01, 
        AV1327.ExRefNo02, 
        AV1327.ExQuantity, 
        AV1327.ExUnitPrice, 
        AV1327.ExConvertedAmount, 
        AV1327.ExOriginalAmount, 
        AV1327.ExConvertedQuantity, 
        AV1327.VoucherTypeID, 
        AV1327.Description, 
        AV1327.Notes, 
        AV1327.InventoryID, 
        AV1327.InventoryName, 
        AV1327.UnitID, 
        AV1327.ConversionFactor, 
        AV1327.BeginQuantity, 
        AV1327.BeginAmount, 
        AV1327.ImExOrders, 
        AV1327.DebitAccountID, 
        AV1327.CreditAccountID, 
        AV1327.ObjectID, 
        AV1327.ObjectName, 
        AV1327.Notes01, 
        AV1327.Notes02, 
        AV1327.Notes03,
        AV1327.DivisionID
    FROM AV1327 
    WHERE AV1327.BeginQuantity <> 0 
        OR AV1327.BeginAmount <> 0 
        OR AV1327.ImQuantity <> 0 
        OR AV1327.ImConvertedAmount <> 0 
        OR AV1327.ExQuantity <> 0 
        OR AV1327.ExConvertedAmount <> 0
'
--PRINT @sSQL

IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV1326')
    EXEC('--Created by AP1326
        CREATE VIEW AV1326 AS ' + @sSQL)
ELSE 
    EXEC('--Created by AP1326
        ALTER VIEW AV1326 AS ' + @sSQL)