
/****** Object:  StoredProcedure [dbo].[MP8202]    Script Date: 08/02/2010 14:03:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang Thi Lan
--Date 13/11/2003
--Purpose: Tíng CP DD cuối kỳ NC TT theo phương pháp Định mức 

/********************************************
'* Edited BY: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP8202]  @DivisionID AS nvarchar(50), 
                 @PeriodID AS nvarchar(50), 
                 @TranMonth AS INT, 
                 @TranYear AS INT, 
                 @MaterialTypeID AS nvarchar(50), 
                 @ApportionID AS nvarchar(50), 
                 @VoucherID AS nvarchar(50), 
                 @CMonth AS nvarchar(50), 
                 @CYear AS nvarchar(50)
AS
DECLARE @sSQL AS  nvarchar(4000), 
    @MaterialAmount AS DECIMAL(28, 8), --Chi phí NVL đầu kỳ
    @ISumConverted621 AS DECIMAL(28, 8), --Chi phí NVL trong kỳ
    @Quantity AS DECIMAL(28, 8), --Số lượng thành phẩm
    @QuantityInprocess AS DECIMAL(28, 8), --Số lương dở dang cuối kỳ
    @MaterialRate AS DECIMAL(28, 8), --Tỉ lệ % NVL
    @MaterialID AS nvarchar(50), 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @InprocessCost AS DECIMAL(28, 8), 
    @ProductID AS nvarchar(50), 
    @PerfectRate AS DECIMAL(28, 8), 
    @InProcessQuantity AS DECIMAL(28, 8), 
    @HumanResourceRate AS DECIMAL(28, 8), 
    @OthersRate AS DECIMAL(28, 8), 
    @ProductQuantityEnd AS DECIMAL(28, 8), 
    @ConvertedUnitEnd AS DECIMAL(28, 8), 
    @TransactionID AS nvarchar(50), 
    @ProductUnitID AS nvarchar(50), 
    @MaterialUnitID AS nvarchar(50), 
@ListMaterial_cur AS CURSOR
--print 'da vao1'
SET NOCOUNT ON
SET @sSQL=N'
SELECT MaterialID, SUM(ISNULL(MaterialQuantity, 0)) AS MaterialQuantity, 
    SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount, 
    ProductID, --- Ma thanh pham
    ProductQuantity, ---- So luong thanh pham duoc san xuat trong ky
    AT1302_P.UnitID AS ProductUnitID, 
    AT1302_M.UnitID AS MaterialUnitID, 
    MT0400.DivisionID
 FROM MT0400  LEFT JOIN AT1302 AT1302_P ON MT0400.ProductID = AT1302_P .InventoryID AND MT0400.DivisionID = AT1302_P .DivisionID
        LEFT JOIN AT1302 AT1302_M ON MT0400.MaterialID=AT1302_M.InventoryID AND MT0400.DivisionID=AT1302_M.DivisionID

WHERE MT0400.DivisionID ='''+@DivisionID+''' AND
    PeriodID = '''+@PeriodID+''' AND
    ExpenseID =''COST002'' AND
    ProductID IN (SELECT ProductID FROM  MT2222)  AND        
    MaterialTypeID ='''+@MaterialTypeID+''' 
GROUP BY MaterialID, ProductID, ProductQuantity, AT1302_P.UnitID, AT1302_M.UnitID, MT0400.DivisionID'

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV8202' AND Xtype ='V')
    EXEC ('CREATE VIEW MV8202 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV8202 AS '+@sSQL)


    SELECT         @MaterialID = MV8202.MaterialID, 
            @MaterialQuantity  = MV8202.MaterialQuantity, ---So luong NVL phat sinh trong ky
            @ConvertedAmount = MV8202.ConvertedAmount, ---- Chi phi cua NVL phat sinh trong ky
            @ProductID = MV8202.ProductID, --- Ma san pham
            @ProductQuantity = MV8202.ProductQuantity, -- So luong thanh pham hoan thanh
            @InProcessQuantity = ISNULL(MT2222.ProductQuantity, 0)*ISNULL(MT2222.HumanResourceRate, 0)/100, --- So luong thanh pham do dang quy doi
            @PerfectRate = MT2222.PerfectRate, 
            @MaterialRate = MT2222.MaterialRate, 
            @HumanResourceRate = MT2222.HumanResourceRate, 
            @OthersRate = MT2222.OthersRate, 
            @ProductQuantityEnd = MT2222.ProductQuantity, 
            @ProductUnitID =MV8202.ProductUnitID, 
            @MaterialUnitID = MV8202.MaterialUnitID
        FROM MV8202 LEFT JOIN MT2222 ON MV8202.DivisionID  = MT2222.DivisionID AND MV8202.ProductID  = MT2222.ProductID 
        
        --Bước 1 :Xác định chi phí NVL định mức
        SELECT @MaterialAmount = MT1603.MaterialAmount
        FROM MT1602 INNER JOIN  MT1603 ON MT1602.DivisionID=MT1603.DivisionID AND MT1602.ApportionID=MT1603.ApportionID 
        WHERE MT1602.Disabled = 0 AND MT1602.IsBOM=1 AND MT1603.ProductID= @ProductID AND MT1603.ExpenseID = 'COST002'
            AND MT1602.DivisionID = @DivisionID

        --Bước 2: Tính Chi  phí SPDD  theo NC bằng PP Định mức
        SET @InprocessCost =ISNULL(@MaterialAmount, 0) *ISNULL(@InProcessQuantity, 0)
        
        --Xác định Chi phí NC cho 1 sản phẩm dở dang
        IF (@ProductQuantityEnd <> 0)
             SET @ConvertedUnitEnd =ISNULL(@InprocessCost, 0)/@ProductQuantityEnd
        ELSE SET @ConvertedUnitEnd = 0
        
        EXEC AP0000 @DivisionID, @TransactionID  OUTPUT, 'MT1613', 'IT', @CMonth, @CYear, 18, 3, 0, '-'

        INSERT MT1613 (PeriodID, TranMonth, TranYear, DivisionID, VoucherID, TransactionID, 
                ProductID, MaterialID, ExpenseID, MaterialTypeID, ProductUnitID, MaterialUnitID, PerfectRate, --- ProductUnitID
                          MaterialQuantity, ConvertedAmount, 
                  ProductQuantity, QuantityUnit, ConvertedUnit, 
                 CreateDate, CreateUserID, Type, MaterialRate, HumanResourceRate, OthersRate     )

        VALUES  (@PeriodID, @TranMonth, @TranYear, @DivisionID, @VoucherID, @TransactionID, 
            @ProductID, @MaterialID, 'COST002', @MaterialTypeID, @ProductUnitID, @MaterialUnitID, @PerfectRate, 
            @MaterialQuantity, ISNULL(@InprocessCost, 0), 
            @ProductQuantityEnd, Null, @ConvertedUnitEnd, 
            Getdate(), Null, 'E', @MaterialRate, @HumanResourceRate, @OthersRate     )

SET NOCOUNT OFF