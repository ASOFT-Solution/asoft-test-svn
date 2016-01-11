/****** Object: StoredProcedure [dbo].[AP1314] Script Date: 07/29/2010 09:45:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------- Created by Nguyen Thi Ngoc Minh, Date 20/08/2004
------- Cap nhat danh muc dinh muc ton kho hang hoa
--- Edit by: Thien Huynh [14/11/2011]: Tang @OutputLen len 20
/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1314] 
    @DivisionID NVARCHAR(50), 
    @TranYear NVARCHAR(50), 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @NormID NVARCHAR(50), 
    @MinQuantity DECIMAL(28, 8), 
    @MaxQuantity DECIMAL(28, 8), 
    @ReOrderQuantity DECIMAL(28, 8), 
    @CreateUserID NVARCHAR(50),    
    @IsAdd TINYINT,                     --0: Them moi
                                        --1: Sua
    @Inventory NVARCHAR(50) OUTPUT, 
    @StatusExecute TINYINT OUTPUT, 
    @VietTmpWareHouse NVARCHAR(50) OUTPUT

AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @AT1302_Cursor CURSOR, 
    @InventoryID NVARCHAR(50), 
    @InventoryNormID NVARCHAR(50), 
    @Status TINYINT,                    --0: duoc them moi
                                        --1: khong duoc them moi
    @EngMess NVARCHAR(4000), 
    @VietMess NVARCHAR(4000), 
    @VietTmpWareHouseID NVARCHAR(50), 
    @EngTmpWareHouseID NVARCHAR(50)

SET @EngMess = ''
SET @VietMess = ''
SET @Status = 0

IF @WareHouseID = '%'
    BEGIN
        SET @VietTmpWareHouseID = N'tất cả các kho'
        SET @EngTmpWareHouseID = 'all warehouses'
    END
ELSE 
    BEGIN
        SET @VietTmpWareHouseID = 'kho ' + LTRIM(RTRIM(@WareHouseID))
        SET @EngTmpWareHouseID = LTRIM(RTRIM(@WareHouseID)) + ' warehouse'
        SET @VietTmpWareHouse = @WareHouseID;
    END

SET NOCOUNT ON

SET @AT1302_Cursor = CURSOR SCROLL KEYSET FOR
    SELECT InventoryID
    FROM AT1302 
    WHERE InventoryID BETWEEN @FromInventoryID AND @ToInventoryID
    and DivisionID = @DivisionID

OPEN @AT1302_Cursor
FETCH NEXT FROM @AT1302_Cursor INTO @InventoryID

WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @IsAdd = 0 --Them moi
            BEGIN
                IF NOT EXISTS(SELECT InventoryID FROM AT1314 WHERE InventoryID = @InventoryID AND DivisionID = @DivisionID AND (@WareHouseID like WareHouseID OR WareHouseID like @WareHouseID))
                    BEGIN 
                        SELECT @Status AS Status, @EngMess AS EngMess, @VietMess AS VietMess                         
                        --EXEC AP0000 @DivisionID, @InventoryNormID OUTPUT, 'AT1314', 'N', @TranYear, '', 10, 3, 0, ''                         
                        EXEC AP0000 @DivisionID, @InventoryNormID OUTPUT, 'AT1314', 'N', @TranYear, '', 20, 3, 0, ''                         
                        INSERT INTO AT1314 (DivisionID, InventoryNormID, NormID, InventoryID, WareHouseID, MinQuantity, MaxQuantity, ReOrderQuantity, CreateDate, LastModifyDate, CreateUserID, LastModifyUserID)
                            VALUES (@DivisionID, @InventoryNormID, @NormID, @InventoryID, @WareHouseID, @MinQuantity, @MaxQuantity, @ReOrderQuantity, GETDATE(), GETDATE(), @CreateUserID, @CreateUserID)
                    END
                ELSE 
                BEGIN
                    SET @Status = 1
                    SET @Inventory = @InventoryID
                    SET @VietMess = @VietMess + N'Mặt hàng ' + LTRIM(RTRIM(@InventoryID)) + ' trong ' + @VietTmpWareHouseID + N' đã có định mức.' + char(13)
                    SET @EngMess = @EngMess + LTRIM(RTRIM(@InventoryID)) + ' inventoryID IN ' + @EngTmpWareHouseID + ' already has norm.' + char(13)                    
                    SELECT @Status AS Status, @EngMess AS EngMess, @VietMess AS VietMess 
                END
            END 
        ELSE IF @IsAdd = 1 -- Sua
            UPDATE AT1314 
            SET WareHouseID = @WareHouseID, 
                NormID = @NormID, 
                MinQuantity = @MinQuantity, 
                MaxQuantity = @MaxQuantity, 
                ReOrderQuantity = @ReOrderQuantity, 
                LastModifyUserID = @CreateUserID, 
                LastModifyDate = GETDATE()
            WHERE InventoryID BETWEEN @FromInventoryID AND @ToInventoryID
				AND DivisionID = @DivisionID

        FETCH NEXT FROM @AT1302_Cursor INTO @InventoryID
    END

SET @StatusExecute = @Status

CLOSE @AT1302_Cursor
DEALLOCATE @AT1302_Cursor
--GOTO EndMess

SET NOCOUNT OFF
--EndMess:
---SELECT @Status AS Status, @EngMess AS EngMess, @VietMess AS VietMess

