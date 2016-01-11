/****** Object:  StoredProcedure [dbo].[AP7018]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
----- Created BY Vo Thanh Huong, Date 13/12/2004
---- Purpose: Tinh so du dau ky cua cac mat hang quan ly thuc te dich danh

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7018] 
    @DivisionID NVARCHAR(50), 
    @WareHouseID  NVARCHAR(50), 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @FromMonth INT, @FromYear INT, 
    @ToMonth INT, @ToYear INT, 
    @IsGroup TINYINT, 
    @GroupID NVARCHAR(50)
AS

DECLARE @sSQL AS NVARCHAR(4000)

SET  @sSQL = '
        SELECT AT0114.InventoryID, 
            ReVoucherNo, ReVoucherDate, ReTranMonth, ReTranYear, ReSourceNo, 
            AT0114.LimitDate, ReQuantity, DeQuantity, 
            EndQuantity, AT0114.UnitPrice, DeVoucherID, DeTransactionID, 
            DeVoucherNo, DeVoucherDate, AT0114.DivisionID
        FROM AT0114 INNER JOIN AT1302 ON AT1302.InventoryID = AT0114.InventoryID AND AT1302.DivisionID = AT0114.DivisionID
        WHERE (ReTranYear + 100 * ReTranMonth BETWEEN ' + CAST(@FromMonth + @FromYear * 100 AS NVARCHAR(10)) + ' 
            AND ' + CAST(@ToMonth + @ToYear * 100 AS NVARCHAR(10)) + ') 
            AND AT0114.DivisionID = ''' + @DivisionID + ''' 
            AND WareHouseID LIKE ''' + @WareHouseID + ''' 
            AND (AT0114.InventoryID BETWEEN ''' + @FromInventoryID + ''' 
            AND ''' + @ToInventoryID + ''') 
    '

IF EXISTS (SELECT Top 1 1  FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV7018') DROP VIEW AV7018
    EXEC('---tao boi AP7018
        CREATE VIEW AV7018 AS ' + @sSQL)
GO
