/****** Object:  StoredProcedure [dbo].[MP8702]    Script Date: 01/07/2011 10:09:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang Thi Lan
--Date 13/11/2003
--Purpose: Tính CP DD cuối kỳ CP SXC theo phương pháp Định mức 

ALTER PROCEDURE [dbo].[MP8702]  @DivisionID AS NVARCHAR(50), 
                 @PeriodID AS NVARCHAR(50), 
                 @TranMonth AS INT, 
                 @TranYear AS INT, 
                 @MaterialTypeID AS NVARCHAR(50), 
                 @ApportionID AS NVARCHAR(50), 
                 @VoucherID AS NVARCHAR(50), 
                 @CMonth AS NVARCHAR(50), 
                 @CYear AS NVARCHAR(50)
AS

DECLARE @sSQL AS  VARCHAR(8000), 
    @MaterialAmount AS DECIMAL(28, 8), --Chi phí NVL đầu kỳ
    @Quantity AS DECIMAL(28, 8), --Số lượng thành phẩm
    @QuantityInprocess AS DECIMAL(28, 8), --Số lương dở dang cuối kỳ
    @MaterialRate AS DECIMAL(28, 8), --Tỉ lệ % NVL
    @MaterialID AS NVARCHAR(50), 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @InprocessCost AS DECIMAL(28, 8), 
    @ProductID AS NVARCHAR(50), 
    @PerfectRate AS DECIMAL(28, 8), 
    @InProcessQuantity AS DECIMAL(28, 8), 
    @HumanResourceRate AS DECIMAL(28, 8), 
    @OthersRate AS DECIMAL(28, 8), 
    @ProductQuantityEnd AS DECIMAL(28, 8), 
    @ConvertedUnitEnd AS DECIMAL(28, 8), 
    @TransactionID AS NVARCHAR(50), 
    @ProductUnitID AS NVARCHAR(50), 
    @MaterialUnitID AS NVARCHAR(50)

SET @sSQL='
SELECT MaterialID, 
    SUM(ISNULL(MaterialQuantity, 0)) AS MaterialQuantity, 
    SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount, 
    ProductID, --- Ma thanh pham
    ProductQuantity, ---- So luong thanh pham duoc san xuat trong ky
    AT1302_P.UnitID AS ProductUnitID, 
    AT1302_M.UnitID AS MaterialUnitID, 
    MT0400.DivisionID
FROM MT0400 
    LEFT JOIN AT1302 AT1302_P ON MT0400.ProductID = AT1302_P .InventoryID AND MT0400.DivisionID = AT1302_P .DivisionID
    LEFT JOIN AT1302 AT1302_M ON MT0400.MaterialID=AT1302_M.InventoryID AND MT0400.DivisionID=AT1302_M.DivisionID
WHERE PeriodID = '''+@PeriodID+''' 
    AND ExpenseID =''COST003'' 
    AND ProductID IN (SELECT ProductID FROM MT2222) 
    AND MaterialTypeID = '''+@MaterialTypeID+''' 
    AND MT0400.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
GROUP BY MaterialID, ProductID, ProductQuantity, AT1302_P.UnitID, AT1302_M.UnitID, MT0400.DivisionID  
'

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV8702' AND Xtype ='V')
    EXEC ('CREATE VIEW MV8702 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV8702 AS '+@sSQL)

    SELECT  @MaterialID = MV8702.MaterialID, 
            @MaterialQuantity = MV8702.MaterialQuantity, ---So luong NVL phat sinh trong ky
            @ConvertedAmount = MV8702.ConvertedAmount, ---- Chi phi cua NVL phat sinh trong ky
            @ProductID = MV8702.ProductID, --- Ma san pham
            @ProductQuantity = MV8702.ProductQuantity, -- So luong thanh pham hoan thanh
            @InProcessQuantity = ISNULL(MT2222.ProductQuantity, 0)*ISNULL(MT2222.OthersRate, 0)/100, --- So luong thanh pham do dang quy doi
            @PerfectRate = MT2222.PerfectRate, --Tỉ lệ % hoàn thành
            @MaterialRate = MT2222.MaterialRate, --%NVL
            @HumanResourceRate = MT2222.HumanResourceRate, --%NC
            @OthersRate = MT2222.OthersRate, --%SXC
            @ProductQuantityEnd = MT2222.ProductQuantity, --Số lượng Thành phẩm dở dang cuôi kỳ
            @ProductUnitID = MV8702.ProductUnitID, 
            @MaterialUnitID = MV8702.MaterialUnitID
    FROM MV8702 LEFT JOIN MT2222 ON MV8702.DivisionID = MT2222.DivisionID 
    AND MV8702.ProductID  = MT2222.ProductID
        
    --Bước 1 :Xác định chi phí SXC định mức
    SET @MaterialAmount = ( SELECT MT1603.MaterialAmount
                            FROM MT1602 INNER JOIN MT1603 ON MT1602.DivisionID = MT1603.DivisionID 
                            AND MT1602.ApportionID=MT1603.ApportionID 
                            WHERE MT1602.Disabled = 0 AND MT1602.IsBOM = 1 AND MT1603.ProductID = @ProductID 
                                AND MT1603.ExpenseID = 'COST003' AND MaterialTypeID= @MaterialTypeID 
                                AND MT1602.ApportionID = @ApportionID
                                AND MT1602.DivisionID = @DivisionID)

    --Bước 2: Tính Chi  phí SPDD  SXC theo PP dinh muc
    SET @InprocessCost =ISNULL(@MaterialAmount, 0)*ISNULL(@InProcessQuantity, 0)
    
    --Bước3: Tính Chi  phí SPDD  SXC /1SP
    IF (@ProductQuantityEnd<>0)
         SET @ConvertedUnitEnd = ISNULL(@InprocessCost, 0)/@ProductQuantityEnd
    ELSE SET @ConvertedUnitEnd = 0 
            
    EXEC AP0000 @DivisionID, @TransactionID  OUTPUT, 'MT1613', 'IT', @CMonth, @CYear, 18, 3, 0, '-'

    INSERT MT1613 (PeriodID, TranMonth, TranYear, DivisionID, VoucherID, TransactionID, ProductID, MaterialID, ExpenseID, MaterialTypeID, ProductUnitID, MaterialUnitID, PerfectRate, MaterialQuantity, ConvertedAmount, ProductQuantity, QuantityUnit, ConvertedUnit, CreateDate, CreateUserID, Type, MaterialRate, HumanResourceRate, OthersRate)
    VALUES (@PeriodID, @TranMonth, @TranYear, @DivisionID, @VoucherID, @TransactionID, @ProductID, @MaterialID, 'COST003', @MaterialTypeID, @ProductUnitID, @MaterialUnitID, @PerfectRate, @MaterialQuantity, @InprocessCost, @ProductQuantityEnd, Null, @ConvertedUnitEnd, Getdate(), 'ASOFTADMIN', 'E', @MaterialRate, @HumanResourceRate, @OthersRate)
GO


