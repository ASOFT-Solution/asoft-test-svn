
/****** Object:  StoredProcedure [dbo].[MP8006]    Script Date: 08/02/2010 13:35:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



---- CREATE BY Hoang Thi Lan, date 18/11/2003
---- purpose:     Tinh chi phi do dang dau ky cho PP cap nhat bang tay.
----        duoc goi tu store MP8001

/********************************************
'* Edited BY: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/


ALTER PROCEDURE  [dbo].[MP8006] 
                @DivisionID AS nvarchar(50), 
                @PeriodID  nvarchar(50), 
                @TranMonth INT, 
                @TranYear INT 
                
                

AS
DECLARE @LisProduct_Cur AS CURSOR, 
    @VoucherID AS nvarchar(50), 
    @TransactionID AS nvarchar(50), 
    @CMonth AS nvarchar(20), 
    @CYear AS nvarchar(20), 
    @ProductID AS nvarchar(50), 
    @WipQuantity AS DECIMAL(28, 8), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @MaterialID AS nvarchar(50), 
    @ExpenseID AS nvarchar(50), 
    @MaterialTypeID AS nvarchar(50), 
    @MaterialUnitID AS nvarchar(50), 
    @ProductUnitID AS nvarchar(50), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @ConvertedUnit AS DECIMAL(28, 8)

---- Lay tu bang MT1612 roi INSERT vao bang MT1613
--print 'Chp DD DKY 2'
IF @TranMonth >9
    SET @CMonth = ltrim(rtrim(str(@TranMonth)))
ELSE
    SET @CMonth = '0'+ltrim(rtrim(str(@TranMonth)))

SET @CYear =right(Ltrim(rtrim(str(@TranYear))), 2)


EXEC AP0000 @DivisionID, @VoucherID  OUTPUT, 'MT1613', 'IV', @CMonth, @CYear, 16, 3, 0, '-'    

DELETE  FROM MT1613  WHERE DivisionID= @DivisionID AND PeriodID = @PeriodID AND TranMonth = @TranMonth AND  
        TranYear =@TranYear  AND Type ='B'     
 
SET @LisProduct_Cur  = CURSOR SCROLL KEYSET FOR 
    SELECT     ProductID, 
            SUM(ISNULL(WipQuantity, 0)), --- So luong nguyen vat lieu do dang cho san pham
        SUM(ISNULL(ConvertedAmount, 0)), --- Tong chi phi do dang cho san pham
        MaterialID, 
        ExpenseID, 
        MaterialTypeID, 
        SUM(ISNULL(ProductQuantity, 0)), 
        ConvertedUnit, 
        AT1302_P.UnitID AS ProductUnitID, 
        AT1302_M.UnitID AS MaterialUnitID
FROM MT1612 LEFT JOIN  AT1302 AT1302_P ON MT1612.DivisionID = AT1302_P.DivisionID AND MT1612.ProductID = AT1302_P.InventoryID
        LEFT JOIN AT1302 AT1302_M ON MT1612.DivisionID = AT1302_M.DivisionID AND MT1612.MaterialID = AT1302_M.InventoryID
WHERE MT1612.DivisionID = @DivisionID  
    AND PeriodID =@PeriodID AND TranMonth = @TranMonth AND TranYear = @TranYear    AND Type = 'B'
GROUP BY ProductID, MaterialID, ExpenseID, MaterialTypeID, ConvertedUnit, AT1302_P.UnitID, AT1302_M.UnitID

OPEN @LisProduct_Cur 
FETCH NEXT FROM @LisProduct_Cur INTO  @ProductID, @WipQuantity, @ConvertedAmount, @MaterialID, 
    @ExpenseID, @MaterialTypeID, @ProductQuantity, @ConvertedUnit, @ProductUnitID, @MaterialUnitID
WHILE @@Fetch_Status = 0
BEGIN            
    EXEC AP0000 @DivisionID, @TransactionID  OUTPUT, 'MT1613', 'IT', @CMonth, @CYear, 18, 3, 0, '-'
    
    INSERT into MT1613 (PeriodID, TranMonth, TranYear, DivisionID, VoucherID, TransactionID, 
        ProductID, MaterialID, ExpenseID, MaterialTypeID, 
        ProductUnitID, 
        MaterialUnitID, MaterialQuantity, ConvertedAmount, ProductQuantity, 
        ConvertedUnit, 
        Type)
    VALUES ( @PeriodID, @TranMonth, @TranYear, @DivisionID, @VoucherID, @TransactionID, 
        @ProductID, @MaterialID, @ExpenseID, @MaterialTypeID, 
        @ProductUnitID, 
        @MaterialUnitID, @WipQuantity, @ConvertedAmount, @ProductQuantity, 
        @ConvertedUnit, 
        'B')
        
    FETCH NEXT FROM @LisProduct_Cur INTO  @ProductID, @WipQuantity, @ConvertedAmount, @MaterialID, 
            @ExpenseID, @MaterialTypeID, @ProductQuantity, @ConvertedUnit, @ProductUnitID, @MaterialUnitID
END