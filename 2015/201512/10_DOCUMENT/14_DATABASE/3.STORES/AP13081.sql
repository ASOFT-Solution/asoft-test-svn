﻿IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP13081]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP13081]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--------- Created by Khanh Van, Date 23/01/2013
--------- Purpose: Ap gia nhap hang tra lai bang gia ton dau cho Binh Tay
--------- Modify on 27/12/2013 by Bảo Anh: Dùng biến table @AV1309 thay AV1309 để cải thiện tốc độ
--------- Modify on 20/02/2014 by Bảo Anh: Không dùng biến table @AV1309 thay AV1309 nữa vì tính giá xuất không đúng
--------- Modify on 18/08/2015 by Tiểu Mai: Bổ sung đơn giá quy đổi = đơn giá chuẩn

CREATE PROCEDURE [dbo].[AP13081] 
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
        InventoryID, CASE WHEN ActBegQty <> 0 
                    THEN(ISNULL(ActBegTotal/ActBegQty, 0))else 0 end as Price, 
        InventoryAccountID 
    FROM AV1309
    WHERE InventoryID IN 
    (
        SELECT InventoryID 
        FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
        WHERE AT2007.DivisionID = @DivisionID 
        AND AT2007.TranMonth = @TranMonth 
        AND AT2007.TranYear = @TranYear 
        AND KindVoucherID = 7
    )
    ORDER BY InventoryID, 
        ActBegTotal DESC, 
        ActBegQty DESC, 
        UnitPrice DESC, 
        ActReceivedQty DESC 
 
OPEN @BQGQ_cur
FETCH NEXT FROM @BQGQ_cur INTO @WareHouseID, @InventoryID, @UnitPrice, @AccountID

WHILE @@Fetch_Status = 0
    BEGIN --- Ap gia nhap hang tra lai bang gia dau ky
        SET @UnitPrice = 
        (
            SELECT CASE WHEN ActBegQty <> 0 
                    THEN(ISNULL(ActBegTotal/ActBegQty, 0))else 0 end as Price
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
            WHERE AT2006.KindVoucherID = 7
                AND AT2007.InventoryID = @InventoryID 
                AND AT2007.TranMonth = @TranMonth 
                AND AT2007.TranYear = @TranYear 
                AND AT2007.DivisionID = @DivisionID 
                AND AT2007.DebitAccountID = @AccountID 
                AND AT2006.WareHouseID = @WareHouseID
                
        SET @DetalAmount = 0
        FETCH NEXT FROM @BQGQ_cur INTO @WareHouseID, @InventoryID, @UnitPrice, @AccountID
    END
CLOSE @BQGQ_cur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
