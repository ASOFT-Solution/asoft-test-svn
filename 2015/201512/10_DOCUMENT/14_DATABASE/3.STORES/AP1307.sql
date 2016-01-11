IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1307]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1307]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--------- Created by Nguyen Van Nhan, Date 0909/2003
--------- Purpose: Tinh gia binh quan gia quyen cuoi ky cho truong hop xuat kho thong thuong hoac ban hang xuat kho
--------- Edit By: Dang Le Bao Quynh; Date : 18/02/2008
--------- Purpose: Bo sung them viec tinh gia cho cac phieu kiem ke (dieu chinh giam) trong truong hop ap dung PP kiem ke dinh ky - Ap dung cho Lang Tre
--------- Edit by: Dang Le Bao Quynh; Date 01/08/2008
--------- Purpose: Chuyen tat cac xu ly lam tron ra ngoai store AP1309
--------- Edit by: Dang Le Bao Quynh; Date 10/12/2009
--------- Purpose: Dong bo hoa voi AP3333
--------- Modify on 27/12/2013 by Bảo Anh: Dùng biến table @AV1309 thay AV1309 để cải thiện tốc độ
--------- Modify on 20/02/2014 by Bảo Anh: Không dùng biến table @AV1309 thay AV1309 nữa vì tính giá xuất không đúng
--------- Modify on 18/08/2015 by Tiểu Mai: Bổ sung đơn giá quy đổi = đơn giá chuẩn
/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP1307] 
    @DivisionID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT, 
    @QuantityDecimals TINYINT, 
    @UnitCostDecimals TINYINT, 
    @ConvertedDecimals TINYINT
    
AS

DECLARE 
    @AccountID NVARCHAR(50), 
    @TransactionID NVARCHAR(50), 
    @InventoryID NVARCHAR(50), 
    @InventoryID1 NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @WareHouseID1 NVARCHAR(50), 
    @DetalAmount DECIMAL(28, 8), 
    @DetalQuantity DECIMAL(28, 8), 
    @UnitPrice DECIMAL(28, 8), 
    @ActEndTotal DECIMAL(28, 8), 
    @Status INT, 
    @BQGQ_cur CURSOR

--Tao bang tam de xac dinh day co phai la phuong phap tinh cho Lang tre khong
CREATE Table #Status (Status INT, Yasaka INT)
INSERT #Status EXEC AP3333
SET @Status = (SELECT TOP 1 Status FROM #Status)

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
            AND KindVoucherID IN (2, 4, 6, 8)
 )

OPEN @BQGQ_cur
FETCH NEXT FROM @BQGQ_cur INTO @WareHouseID, @InventoryID, @UnitPrice, @AccountID

WHILE @@Fetch_Status = 0
BEGIN --- Cap nhat gia xuat kho thuong
    IF @Status = 0
        BEGIN
            UPDATE AT2007
            SET UnitPrice = ROUND(@UnitPrice, @UnitCostDecimals),
				ConvertedPrice =  ROUND(@UnitPrice, @UnitCostDecimals), 
                OriginalAmount = ROUND(ROUND(@UnitPrice, @UnitCostDecimals) * ROUND(AT2007.ActualQuantity, @QuantityDecimals), @ConvertedDecimals), 
                ConvertedAmount = ROUND(ROUND(@UnitPrice, @UnitCostDecimals) * ROUND(AT2007.ActualQuantity, @QuantityDecimals), @ConvertedDecimals) 
            FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
            WHERE AT2006.KindVoucherID IN (2, 4, 6) ---- 2: xuat kho thong thuong, 4: ban hang xuat kho
                AND AT2007.InventoryID = @InventoryID 
                AND AT2007.TranMonth = @TranMonth 
                AND AT2007.TranYear = @TranYear 
                AND AT2007.DivisionID = @DivisionID 
                AND AT2007.CreditAccountID = @AccountID 
                AND AT2006.WareHouseID = @WareHouseID
        END
/* 
UPDATE AT2007
SET
UnitPrice = ROUND(@UnitPrice, @UnitCostDecimals), 
OriginalAmount = ROUND(ROUND(@UnitPrice, @UnitCostDecimals) * ROUND(AT2007.ActualQuantity, @QuantityDecimals), @ConvertedDecimals), 
ConvertedAmount = ROUND(ROUND(@UnitPrice, @UnitCostDecimals) * ROUND(AT2007.ActualQuantity, @QuantityDecimals), @ConvertedDecimals) 
FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID
WHERE (AT2006.KindVoucherID IN (7)) AND ---- 2: nhap kho hang ban tra lai
AT2007.InventoryID = @InventoryID AND
AT2007.TranMonth = @TranMonth AND
AT2007.TranYear = @TranYear AND
AT2007.DivisionID = @DivisionID AND
AT2007.DebitAccountID = @AccountID AND
AT2006.WareHouseID = @WareHouseID
*/
    ELSE
        BEGIN
            UPDATE AT2007
            SET UnitPrice = ROUND(@UnitPrice, @UnitCostDecimals),
			ConvertedPrice =  ROUND(@UnitPrice, @UnitCostDecimals), 
                OriginalAmount = ROUND(ROUND(@UnitPrice, @UnitCostDecimals) * ROUND(AT2007.ActualQuantity, @QuantityDecimals), @ConvertedDecimals), 
                ConvertedAmount = ROUND(ROUND(@UnitPrice, @UnitCostDecimals) * ROUND(AT2007.ActualQuantity, @QuantityDecimals), @ConvertedDecimals) 
            FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
            WHERE AT2006.KindVoucherID IN (2, 4, 6, 8) ---- 2: xuat kho thong thuong, 4: ban hang xuat kho
                AND AT2007.InventoryID = @InventoryID 
                AND AT2007.TranMonth = @TranMonth 
                AND AT2007.TranYear = @TranYear 
                AND AT2007.DivisionID = @DivisionID 
                AND AT2007.CreditAccountID = @AccountID 
                AND AT2006.WareHouseID = @WareHouseID
        END
/* 
SET @DetalAmount = 0
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
