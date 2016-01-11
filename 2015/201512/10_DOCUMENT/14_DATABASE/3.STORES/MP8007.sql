/****** Object:  StoredProcedure [dbo].[MP8007]    Script Date: 08/02/2010 13:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---- CREATE BY Hoang Thi Lan, date 18/11/2003
---- purpose:     Tinh chi phi do dang dau ky theo PP lay tu doi tuong tap hop chi phi khac
----        duoc goi tu store MP8001

/********************************************
'* Edited BY: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP8007] @DivisionID AS nvarchar(50), 
                @PeriodID  nvarchar(50), 
                @TranMonth INT, 
                @TranYear INT
AS

DECLARE @FromPeriodID AS nvarchar(50), 
     @LisProduct_Cur AS CURSOR, 
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
--print 'CPDDDKY 3'
IF @TranMonth >9
    SET @CMonth = ltrim(rtrim(str(@TranMonth)))
ELSE
    SET @CMonth = '0'+ltrim(rtrim(str(@TranMonth)))

SET @CYear =right(Ltrim(rtrim(str(@TranYear))), 2)

DELETE  FROM MT1613  WHERE DivisionID= @DivisionID AND PeriodID = @PeriodID AND TranMonth = @TranMonth AND  TranYear =@TranYear  AND Type ='B'     

EXEC AP0000 @DivisionID, @VoucherID  OUTPUT, 'MT1613', 'IV', @CMonth, @CYear, 16, 3, 0, '-'    

SET @FromPeriodID = (SELECT  FromPeriodID FROM MT1601 WHERE PeriodID = @PeriodID And DivisionID = @DivisionID)
---- Lay tu bang MT1613 roi INSERT vao bang MT1613
--print '@FromPeriodID '+@FromPeriodID

SET @LisProduct_Cur  = CURSOR SCROLL KEYSET FOR 
    SELECT     ProductID, 
            SUM(MaterialQuantity), --- So luong nguyen vat lieu do dang cho san pham
        SUM(ConvertedAmount), --- Tong chi phi do dang cho san pham
        MaterialID, 
        ExpenseID, 
        MaterialTypeID, 
        SUM(ProductQuantity), 
        ConvertedUnit, ProductUnitID, MaterialUnitID 
FROM MT1613    
WHERE DivisionID = @DivisionID  AND PeriodID =@FromPeriodID AND Type ='E'     --- TranMonth = @TranMonth AND TranYear = @TranYear   
GROUP BY ProductID, MaterialID, ExpenseID, MaterialTypeID, ConvertedUnit, ProductUnitID, MaterialUnitID

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