
/****** Object:  StoredProcedure [dbo].[MP8011]    Script Date: 08/02/2010 13:48:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


---- CREATE BY Nguyen Van Nhan, Date 13/08/2004
---- purpose:     Tinh chi phi do dang cuoi ky  cho PP cap nhat bang tay.
----        duoc goi tu store MP8002
---- Edit BY: Dang Le Bao Quynh; Date 28/08/2008
---- Purpose: Them dieu kien Type = 'E'

/********************************************
'* Edited BY: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP8011] 
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
    @ConvertedUnit AS DECIMAL(28, 8), 
    @QuantityUnit AS DECIMAL(28, 8)

---- Lay tu bang MT1612 roi INSERT vao bang MT1613
--print 'Chp DD DKY 2'
IF @TranMonth >9
    SET @CMonth = ltrim(rtrim(str(@TranMonth)))
ELSE
    SET @CMonth = '0'+ltrim(rtrim(str(@TranMonth)))

SET @CYear =right(Ltrim(rtrim(str(@TranYear))), 2)


EXEC AP0000  @DivisionID, @VoucherID  OUTPUT, 'MT1613', 'IV', @CMonth, @CYear, 16, 3, 0, '-'    

DELETE  FROM MT1613  WHERE DivisionID= @DivisionID AND PeriodID = @PeriodID AND TranMonth = @TranMonth AND  TranYear =@TranYear  AND Type ='E'     
 
SET @LisProduct_Cur  = CURSOR SCROLL KEYSET FOR 
SELECT MT1612.ProductID, 
    SUM(ISNULL(WipQuantity, 0)), --- So luong nguyen vat lieu do dang cho san pham
    SUM(ConvertedAmount), --- Tong chi phi do dang cho san pham
    MaterialID, 
    ExpenseID, 
    MaterialTypeID, 
    ISNULL(MT2222.ProductQuantity, 0) AS ProductQuantity, 
    AT1302_P.UnitID AS ProductUnitID, 
    AT1302_M.UnitID AS MaterialUnitID
FROM MT1612 LEFT JOIN  AT1302 AT1302_P ON MT1612.DivisionID = AT1302_P.DivisionID AND MT1612.ProductID = AT1302_P.InventoryID
    LEFT JOIN AT1302 AT1302_M ON MT1612.DivisionID = AT1302_M.DivisionID AND MT1612.MaterialID = AT1302_M.InventoryID
    LEFT JOIN MT2222 ON MT2222.DivisionID = MT1612.DivisionID AND MT2222.ProductID = MT1612.ProductID
WHERE MT1612.DivisionID = @DivisionID  AND PeriodID =@PeriodID AND TranMonth = @TranMonth AND TranYear = @TranYear   AND Type ='E'  
GROUP BY MT1612.ProductID, MaterialID, ExpenseID, MaterialTypeID, AT1302_P.UnitID, AT1302_M.UnitID, ISNULL(MT2222.ProductQuantity, 0)

OPEN @LisProduct_Cur 
FETCH NEXT FROM @LisProduct_Cur INTO  @ProductID, @WipQuantity, @ConvertedAmount, @MaterialID, 
@ExpenseID, @MaterialTypeID, @ProductQuantity, @ProductUnitID, @MaterialUnitID
WHILE @@Fetch_Status = 0
BEGIN            
    EXEC AP0000 @DivisionID, @TransactionID  OUTPUT, 'MT1613', 'IT', @CMonth, @CYear, 18, 3, 0, '-'
    SET @ConvertedUnit = 0 
    SET @QuantityUnit = 0

    IF @ProductQuantity<>0 
    BEGIN
        SET @ConvertedUnit = @ConvertedAmount/@ProductQuantity
        SET @QuantityUnit = @WipQuantity/@ProductQuantity
    END

    INSERT into MT1613 (PeriodID, TranMonth, TranYear, DivisionID, VoucherID, TransactionID, 
        ProductID, MaterialID, ExpenseID, MaterialTypeID, 
        ProductUnitID, 
        MaterialUnitID, MaterialQuantity, ConvertedAmount, ProductQuantity, ConvertedUnit, QuantityUnit, 
    Type)
    VALUES ( @PeriodID, @TranMonth, @TranYear, @DivisionID, @VoucherID, @TransactionID, 
        @ProductID, @MaterialID, @ExpenseID, @MaterialTypeID, 
        @ProductUnitID, 
        @MaterialUnitID, @WipQuantity, @ConvertedAmount, @ProductQuantity, @ConvertedUnit, @QuantityUnit, 
        'E')

    FETCH NEXT FROM @LisProduct_Cur INTO  @ProductID, @WipQuantity, @ConvertedAmount, @MaterialID, 
    @ExpenseID, @MaterialTypeID, @ProductQuantity, @ProductUnitID, @MaterialUnitID
                    
END