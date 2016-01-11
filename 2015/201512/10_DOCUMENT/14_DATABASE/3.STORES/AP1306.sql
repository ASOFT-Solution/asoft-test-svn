
/****** Object: StoredProcedure [dbo].[AP1306] Script Date: 07/29/2010 09:45:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------- Created by Nguyen Van Nhan, Date 15/09/2003
------- Xu ly so le khi tinh gia binh quan.
------- Edit by: Dang Le Bao Quynh; Date 23/07/2008
------- Purpose: Loai bo phieu VCNB khi lam tron
------- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1306] 
    @TranMonth INT,
    @TranYear INT,
    @DivisionID NVARCHAR(50),
    @WareHouseID NVARCHAR(50),
    @InventoryID NVARCHAR(50), 
    @AccountID NVARCHAR(50),
    @DetalAmount DECIMAL(28,8),
    @DetalQuantity DECIMAL(28,8) 
AS

DECLARE 
    @ActEndTotal DECIMAL(28,8), 
    @TransactionID NVARCHAR(50),
    @QuantityDecimals TINYINT,
    @UnitCostDecimals TINYINT, 
    @ConvertedDecimals TINYINT

SELECT @QuantityDecimals = QuantityDecimals, 
    @UnitCostDecimals = UnitCostDecimals, 
    @ConvertedDecimals = ConvertedDecimals
FROM AT1101
WHERE DivisionID = @DivisionID

SET @QuantityDecimals =ISNULL(@QuantityDecimals, 2)
SET @UnitCostDecimals = ISNULL(@UnitCostDecimals, 2)
SET @ConvertedDecimals = ISNULL(@ConvertedDecimals, 2)

SET @TransactionID = 
(
    SELECT TOP 1 D11.TransactionID
    FROM AT2007 D11 INNER JOIN AT2006 D9 ON D9.VoucherID = D11.VoucherID AND D9.DivisionID = D11.DivisionID
    WHERE D11.InventoryID = @InventoryID 
        AND D11.TranMonth = @TranMonth
        AND D11.TranYear = @TranYear
        AND D11.DivisionID = @DivisionID 
        AND WareHouseID = @WareHouseID 
        AND KindVoucherID IN (2, 4, 6) 
        AND CreditAccountID = @AccountID 
        AND ConvertedAmount = 
        (
            SELECT MAX(AT2007.ConvertedAmount)
            FROM AT2007 INNER JOIN AT2006 ON AT2007.VoucherID = AT2006.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
            WHERE InventoryID = @InventoryID 
                AND AT2007.TranMonth = @TranMonth 
                AND AT2007.TranYear = @TranYear 
                AND AT2007.DivisionID = @DivisionID 
                AND AT2006.WareHouseID = @WareHouseID
                AND AT2006.KindVoucherID IN (2, 4, 6) 
                AND CreditAccountID = @AccountID
        )
)
 
--PRINT ' @TransactionID '+ @TransactionID
IF @TransactionID IS NOT NULL
    UPDATE AT2007 
    SET ConvertedAmount = ROUND(ISNULL(ConvertedAmount, 0) + @DetalAmount, @ConvertedDecimals),
        OriginalAmount = ROUND(ISNULL(OriginalAmount, 0) + @DetalAmount, @ConvertedDecimals),
        ActualQuantity = ROUND(ISNULL(ActualQuantity, 0) + @DetalQuantity, @QuantityDecimals)
    FROM AT2007 
    WHERE TransactionID = @TransactionID AND DivisionID = @DivisionID