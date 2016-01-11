/****** Object: StoredProcedure [dbo].[AP3116] Script Date: 07/29/2010 11:54:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created BY Nguyen Quoc Huy
---- Created date 16/12/2004
---- Purpose: thong tin ton kho cua mat hang
---- Last Edit : Thuy Tuyen 22/08/2007 -- Them IF @MethodID la 1
---- Edit BY: Dang Le Bao Quynh; Date 13/05/2008
---- Purpose: Sua lai cach tinh cot don gia
/********************************************
'* Edited BY: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3116]
    @DivisionID AS NVARCHAR(50), 
    @Month AS INT, 
    @Year AS INT, 
    @InventoryID AS NVARCHAR(50), 
    @VoucherDate AS DATETIME
AS

DECLARE
    @sSQL AS NVARCHAR(4000), 
    @MethodID AS TINYINT

SELECT @MethodID = MethodID FROM AT1302 WHERE DivisionID = @DivisionID AND InventoryID = @InventoryID

IF @MethodID IN (3) ---Bo FIFO di 1 Quoc Huy, Data 04/11/2008
    SET @sSQL = '
SELECT 
AT0114.WareHouseID, 
AT0114.EndQuantity, 
AT0114.UnitPrice, 
AT0114.DivisionID, 
AT1314.MaxQuantity, 
AT1314.MinQuantity, 
AT1314.ReOrderQuantity
FROM AT0114
LEFT JOIN AT1314 ON AT1314.InventoryID = AT0114.InventoryID
    AND AT1314.DivisionID = AT0114.DivisionID
    AND AT1314.WarehouseID LIKE (CASE WHEN ISNULL(AT1314.WarehouseID, ''%'') = ''%'' THEN ''%'' ELSE AT0114.WarehouseID END)
WHERE AT0114.DivisionID = ''' + @DivisionID + '''
    AND AT0114.InventoryID = ''' + @InventoryID + '''
    AND Status = 0
    AND IsLocked = 0
    AND ReVoucherDate <= ''' + CONVERT(NVARCHAR(10), @VoucherDate, 21) + '''
'
ELSE
    SET @sSQL = '
SELECT
AT2008.WareHouseID, 
CASE WHEN AT2008.EndQuantity <> 0 Then AT2008.EndAmount / AT2008.EndQuantity ELSE 0 END AS UnitPrice, 
AT2008.EndQuantity, 
AT2008.DivisionID, 
AT1314.MaxQuantity, 
AT1314.MinQuantity, 
AT1314.ReOrderQuantity
FROM AT2008
LEFT JOIN AT1314 ON AT1314.InventoryID = AT2008.InventoryID
    AND AT1314.DivisionID = AT2008.DivisionID
    AND AT1314.WarehouseID LIKE (CASE WHEN ISNULL(AT1314.WarehouseID, ''%'') = ''%'' THEN ''%'' ELSE AT2008.WarehouseID END)
WHERE AT2008.DivisionID = ''' + @DivisionID + '''
    AND AT2008.InventoryID LIKE ''' + @InventoryID + '''
    AND AT2008.TranMonth + 100 * AT2008.TranYear = ' + ltrim(@Month + 100 * @Year) + '
GROUP BY AT2008.WareHouseID, AT2008.EndQuantity, CASE WHEN AT2008.EndQuantity <> 0 THEN AT2008.EndAmount / AT2008.EndQuantity ELSE 0 END, AT2008.DivisionID,
    AT1314.MaxQuantity, AT1314.MinQuantity, AT1314.ReOrderQuantity
'

IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Xtype ='V' AND Name ='AV3116')
    EXEC(' CREATE VIEW AV3116 -- Tao boi AP3116
        AS ' + @sSQL)
ELSE
    EXEC(' ALTER VIEW AV3116 -- Tao boi AP3116
        AS ' + @sSQL)