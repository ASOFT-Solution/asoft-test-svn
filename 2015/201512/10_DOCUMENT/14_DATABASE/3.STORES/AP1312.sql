
/****** Object:  StoredProcedure [dbo].[AP1312]    Script Date: 10/25/2010 09:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------- Created by Nguyen Thi Ngoc Minh, Date 18/08/2004
------- Len view danh muc hang ton kho, thay '%' bang ma kho cu the de len bao cao

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
					[Hoang Phuoc] [25/10/2010] sửa kiểu @sSQL NVARCHAR(4000), thành @sSQL NVARCHAR(MAX), thêm N''
'********************************************/

ALTER PROCEDURE [dbo].[AP1312] 
    @DivisionID NVARCHAR(50), 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50)
AS

DECLARE 
    @sSQL NVARCHAR(MAX), 
    @AT1303_Cursor CURSOR, 
    @WareHouseID NVARCHAR(50)

SET @sSQL = N'
    SELECT DivisionID, 
        NormID, 
        InventoryID, 
        WareHouseID, 
        MinQuantity, 
        MaxQuantity, 
        ReOrderQuantity
    FROM AT1314 
    WHERE WareHouseID <> ''%'' 
        AND DivisionID = N''' + @DivisionID + ''' 
        AND InventoryID BETWEEN N''' + @FromInventoryID + ''' 
        AND N''' + @ToInventoryID + '''
'

SET @AT1303_Cursor = CURSOR SCROLL KEYSET FOR
    SELECT WareHouseID
    FROM AT1303
    WHERE DivisionID = @DivisionID
    
OPEN @AT1303_Cursor FETCH NEXT FROM @AT1303_Cursor INTO @WareHouseID

WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sSQL = @sSQL + N'
            UNION ALL
            SELECT DivisionID, 
                NormID, 
                InventoryID, 
                N''' + @WareHouseID + ''' AS WareHouseID, 
                MinQuantity, 
                MaxQuantity, 
                ReOrderQuantity
            FROM AT1314
            WHERE WareHouseID = ''%'' 
                AND DivisionID = N''' + @DivisionID + ''' 
                AND InventoryID BETWEEN N''' + @FromInventoryID + ''' 
                AND N''' + @ToInventoryID + '''
        '
        FETCH NEXT FROM @AT1303_Cursor INTO @WareHouseID
    END
CLOSE @AT1303_Cursor

DEALLOCATE @AT1303_Cursor

--select @sSQL
IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Name = 'AV1312')
    EXEC ('--Created by AP1312 
        CREATE VIEW AV1312 AS ' + @sSQL)
ELSE
    EXEC('--Created by AP1312
        ALTER VIEW AV1312 AS ' + @sSQL)