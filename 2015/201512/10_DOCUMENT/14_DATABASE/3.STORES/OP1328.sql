
/****** Object: StoredProcedure [dbo].[OP1328] Script Date: 12/16/2010 11:09:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----Create by:Thuy Tuyen, date: 14/08/2009
----Purpose: Lay mat hang khuyen mai cho man hinh lap don hang ban
---Edit: Thuy Tuyen, date 25/11/2009 . tinh luong khuyen mai dua vao pahn tram ban hang.

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [03/08/2010]
'********************************************/
---Edit: Thiên Huỳnh, date 16/11/2012: Không lấy khuyến mãi đã Disabled

ALTER PROCEDURE [dbo].[OP1328] 
@DivisionID NVARCHAR(50), 
@ObjectID NVARCHAR(50), 
@VoucherDate DATETIME, 
@InventoryID NVARCHAR(50), 
@Quantity DECIMAL(28, 8)

AS

DECLARE
@sSQL NVARCHAR(4000), 
@OTypeID NVARCHAR(50), 
@WHERE NVARCHAR(4000), 
@VoucherID NVARCHAR(50), 
@ID_Promote NVARCHAR(50)

SET @VoucherDate = CONVERT(NVARCHAR(10), @VoucherDate, 101)

IF @Quantity = NULL SET @Quantity = 0

SELECT @OTypeID = TypeID + 'ID' FROM AT0005 WHERE TypeID LIKE 'O%' AND Status = 1

IF ISNULL(@ObjectID, '') = ''
    BEGIN
        SELECT TOP 1 @VoucherID = VoucherID 
        FROM AT1328 
        WHERE @VoucherDate BETWEEN CONVERT(NVARCHAR(10), FromDate, 101) AND CONVERT(NVARCHAR(10), ISNULL(ToDate, CAST('12/31/9999' AS DATETIME)), 101)
        AND AT1328.InventoryID = @InventoryID 
        AND @Quantity BETWEEN FromQuantity AND ToQuantity 
        AND OID = '%' 
        AND Disabled = 0
    END
ELSE
    BEGIN 
        SELECT TOP 1 @VoucherID = VoucherID 
        FROM AT1328 
        WHERE @VoucherDate BETWEEN CONVERT(NVARCHAR(10), FromDate,101) AND CONVERT(NVARCHAR(10), ISNULL(ToDate, CAST('12/31/9999' AS DATETIME)),101)
        AND AT1328.InventoryID = @InventoryID 
        AND @Quantity BETWEEN FromQuantity AND ToQuantity 
        AND Disabled = 0
        AND
        (
            SELECT TOP 1 
            CASE WHEN @OTypeID = 'O01ID' THEN ISNULL(O01ID, '%') 
                WHEN @OTypeID = 'O02ID' THEN ISNULL(O02ID, '%') 
                WHEN @OTypeID = 'O03ID' THEN ISNULL(O03ID, '%') 
                WHEN @OTypeID = 'O04ID' THEN ISNULL(O04ID, '%') 
                ELSE ISNULL(O05ID, '%') END AS ObjectTypeID 
            FROM AT1202 WHERE ObjectID LIKE ISNULL(@ObjectID, '')
        ) LIKE OID
    END


SET @sSQL = '
SELECT
AT1338.DivisionID, 
AT1338.PromoteInventoryID, 
AT1302.InventoryName, 
(
CASE 
    WHEN ISNULL(AT1328.PromoteTypeID, 0) = 1 THEN PromoteQuantity 
    WHEN ISNULL(AT1328.PromoteTypeID, 0) = 2 THEN '+ STR(@Quantity) + ' * PromotePercent / 100
END
) AS PromoteQuantity, 
AT1338.Notes, AT1302.UnitID
FROM AT1338
LEFT JOIN AT1328 ON AT1328.VoucherID = AT1338.VoucherID AND AT1328.DivisionID = AT1338.DivisionID
LEFT JOIN AT1302 ON AT1302.InventoryID = AT1338.PromoteInventoryID AND AT1302.DivisionID = AT1338.DivisionID
WHERE ISNULL(AT1338.VoucherID, '''') = ''' + ISNULL(@VoucherID, '') + '''
'

IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND NAME = 'OV1328')
    EXEC ('CREATE VIEW OV1328 -- tao boi OP1328
            AS ' + @sSQL)
ELSE
    EXEC ('ALTER VIEW OV1328 -- tao boi OP1328
            AS ' + @sSQL)