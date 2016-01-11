/****** Object:  StoredProcedure [dbo].[WP0118]    Script Date: 08/03/2010 15:02:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

 ---- Created by Van Nhan. Date 07/07/2008.
 ---- purpose: Bao cao tuoi hang ton kho

/********************************************
'* Edited by: [GS] [Việt Khánh] [04/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[WP0118]     
    @DivisionID NVARCHAR(50), 
    @Now DATETIME, 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @FromWareHouseID NVARCHAR(50), 
    @ToWareHouseID NVARCHAR(50), 
    @GroupID NVARCHAR(50), 
    @Days INT
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @GroupField NVARCHAR(50)

SET @GroupField = 'AT1302.' + @GroupID + 'ID'

SET @sSQL = '
    SELECT 
		AT0114.DivisionID,
		' + @GroupField + ' AS GroupID, 
        AT0114.InventoryID, 
        AT1302.InventoryName, 
        AT1302.UnitID, ReVoucherDate, 
        AT1302.I01ID, 
        AT1302.I02ID, 
        AT1302.I03ID, 
        AT1302.I04ID, 
        AT1302.I05ID, 
        CASE WHEN ''' + CONVERT(NVARCHAR(10), @Now, 21) + ''' - ReVoucherDate - ' + STR(@Days) + ' <= 7 THEN SUM(EndQuantity) ELSE 0 END AS ThisWeek, 
        CASE WHEN ''' + CONVERT(NVARCHAR(10), @Now, 21) + ''' - ReVoucherDate - ' + STR(@Days) + ' >7 THEN SUM(EndQuantity) ELSE 0 END AS LastWeek
    FROM AT0114 INNER JOIN AT1302 ON AT1302.InventoryID = AT0114.InventoryID
    WHERE ReVoucherDate + - ' + STR(@Days) + ' <= ''' + CONVERT(NVARCHAR(10), @Now, 21) + ''' 
        AND ReVoucherDate + ' + STR(@Days) + ' + 14 >= ''' + CONVERT(NVARCHAR(10), @Now, 21) + ''' 
        AND EndQuantity <> 0 
        AND AT0114.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 
        AND AT0114.WareHouseID BETWEEN ''' + @FromWareHouseID + ''' AND ''' + @ToWareHouseID + ''' 
    GROUP BY AT0114.DivisionID, AT0114.InventoryID, AT1302.InventoryName, AT1302.UnitID, AT1302.I01ID, 
        AT1302.I02ID, AT1302.I03ID, AT1302.I04ID, AT1302.I05ID, ReVoucherDate
'

 --- Print @sSQL
IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'WV0117')
    EXEC('CREATE VIEW WV0117 AS ' + @sSQL)
ELSE
    EXEC('ALTER VIEW WV0117 AS ' + @sSQL)

SET @sSQL = '
    SELECT 
		DivisionID,
		GroupID, InventoryID, InventoryName, UnitID, 
        I01ID, I02ID, I03ID, I04ID, I05ID, 
        SUM(ThisWeek) AS ThisWeek, 
        SUM(LastWeek) AS LastWeek
    FROM WV0117
    GROUP BY DivisionID, GroupID, InventoryID, InventoryName, UnitID, I01ID, I02ID, I03ID, I04ID, I05ID
'

IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'WV0118')
    EXEC('CREATE VIEW WV0118 AS ' + @sSQL)
ELSE
    EXEC('ALTER VIEW WV0118 AS ' + @sSQL)
