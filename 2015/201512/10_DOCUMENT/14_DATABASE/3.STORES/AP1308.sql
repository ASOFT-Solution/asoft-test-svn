IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1308]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1308]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--------- Created by Nguyen Van Nhan, Date 06/09/2003
--------- Purpose: Tinh gia binh quan gia quyen cuoi ky cho truong hop xuat van chuyen noi bo
--------- Edit by: Dang Le Bao Quynh; Date 01/08/2008
--------- Purpose: Chuyen tat cac xu ly lam tron ra ngoai store AP1309
--------- Edit by: Dang Le Bao Quynh; Date 22/12/2008
--------- Purpose: Sap xep thu tu truoc khi tinh gia, uu tien gia cao tinh truoc
--------- Modify on 27/12/2013 by Bảo Anh: Dùng biến table @AV1309 thay AV1309 để cải thiện tốc độ
--------- Modify on 20/02/2014 by Bảo Anh: Không dùng biến table @AV1309 thay AV1309 nữa vì tính giá xuất không đúng
--------- Modify on 18/08/2015 by Tiểu Mai: Bổ sung đơn giá quy đổi = đơn giá chuẩn
/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/
--- AP1308 'PL',11,2013,2,2,0
CREATE PROCEDURE [dbo].[AP1308] 
    @DivisionID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT, 
    @QuantityDecimals TINYINT, 
    @UnitCostDecimals TINYINT, 
    @ConvertedDecimals TINYINT
   
AS

DECLARE 
    @InventoryID NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @AccountID NVARCHAR(50), 
    @TransactionID NVARCHAR(50), 
    @WareHouseID1 NVARCHAR(50), 
    @InventoryID1 NVARCHAR(50), 
    @DetalAmount DECIMAL(28, 8), 
    @DetalQuantity DECIMAL(28, 8), 
    @UnitPrice DECIMAL(28, 8), 
    @ActEndTotal DECIMAL(28, 8), 
    @BQGQ_cur CURSOR 

SET @BQGQ_Cur = CURSOR SCROLL KEYSET FOR 
    SELECT WareHouseID, 
        InventoryID, 
        UnitPrice, 
        InventoryAccountID 
    FROM AV1309
    WHERE InventoryID IN 
    (
        SELECT InventoryID 
        FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
        WHERE AT2007.DivisionID = @DivisionID 
        AND AT2007.TranMonth = @TranMonth 
        AND AT2007.TranYear = @TranYear 
        AND KindVoucherID = 3
    )
    ORDER BY InventoryID, 
        ActBegTotal DESC, 
        ActBegQty DESC, 
        UnitPrice DESC, 
        ActReceivedQty DESC 
 
OPEN @BQGQ_cur
FETCH NEXT FROM @BQGQ_cur INTO @WareHouseID, @InventoryID, @UnitPrice, @AccountID

WHILE @@Fetch_Status = 0
    BEGIN --- Cap nhat gia xuat kho cho xuat van chuyen noi bo
        SET @UnitPrice = 
        (
            SELECT TOP 1 UnitPrice 
            FROM AV1309 
            WHERE WareHouseID = @WareHouseID 
            AND InventoryID = @InventoryID 
            AND InventoryAccountID = @AccountID
            AND DivisionID = @DivisionID 
        )
        
        UPDATE AT2007
        SET UnitPrice = ROUND(@UnitPrice, @UnitCostDecimals), 
			ConvertedPrice =  ROUND(@UnitPrice, @UnitCostDecimals),
            OriginalAmount = ROUND(ROUND(@UnitPrice, @UnitCostDecimals) * ROUND(AT2007.ActualQuantity, @QuantityDecimals), @ConvertedDecimals), 
            ConvertedAmount = ROUND(ROUND(@UnitPrice, @UnitCostDecimals) * ROUND(AT2007.ActualQuantity, @QuantityDecimals), @ConvertedDecimals) 
            FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
            WHERE AT2006.KindVoucherID = 3 ---- Xac dinh la xuat van chuyen noi bo
                AND AT2007.InventoryID = @InventoryID 
                AND AT2007.TranMonth = @TranMonth 
                AND AT2007.TranYear = @TranYear 
                AND AT2007.DivisionID = @DivisionID 
                AND AT2007.CreditAccountID = @AccountID 
                AND AT2006.WareHouseID2 = @WareHouseID
                
        SET @DetalAmount = 0
/* 
SET @DetalAmount = ISNULL((SELECT EndAmount FROM AT2008
WHERE DivisionID = @DivisionID AND 
TranMonth = @TranMonth AND
TranYear = @TranYear AND
InventoryID = @InventoryID AND
WareHouseID = @WareHouseID AND
InventoryAccountID = @AccountID AND
ROUND(EndQuantity, 2) = 0 AND
EndAmount <>0), 0)
SET @DetalQuantity = ISNULL((SELECT EndQuantity FROM AT2008
WHERE DivisionID = @DivisionID AND 
TranMonth = @TranMonth AND
TranYear = @TranYear AND
InventoryID = @InventoryID AND
WareHouseID = @WareHouseID AND
InventoryAccountID = @AccountID AND
ROUND(EndQuantity, 2) = 0 AND
EndAmount <>0), 0)
IF @DetalAmount <> 0 ---- 
Exec AP1306 @TranMonth, @TranYear, @DivisionID, @WareHouseID, @InventoryID, 
@AccountID, @DetalAmount, @DetalQuantity --- Xu ly so le
*/ 
        FETCH NEXT FROM @BQGQ_cur INTO @WareHouseID, @InventoryID, @UnitPrice, @AccountID
    END
CLOSE @BQGQ_cur
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
