
/****** Object:  StoredProcedure [dbo].[MP8102]    Script Date: 08/02/2010 13:54:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang Thi Lan
--Date 13/11/2003
--Purpose: TÝnh CP DD cuèi kú NVL TT theo ph­¬ng ph¸p §Þnh møc 

/********************************************
'* Edited BY: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP8102]  @DivisionID AS nvarchar(50), 
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
    @MaterialAmount AS DECIMAL(28, 8), --Chi phÝ NVL ®Çu kú
    @ISumConverted621 AS DECIMAL(28, 8), --Chi phÝ NVL trong kú
    @Quantity AS DECIMAL(28, 8), --Sè l­îng thµnh phÈm
    @QuantityInprocess AS DECIMAL(28, 8), --Sè l­¬ng dë dang cuèi kú
    @MaterialRate AS DECIMAL(28, 8), --TØ lÖ % NVL
    @MaterialID AS nvarchar(50), 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @MaterialInprocessCost AS DECIMAL(28, 8), 
    @ProductID AS nvarchar(50), 
    @PerfectRate AS DECIMAL(28, 8), 
    @InProcessQuantity AS DECIMAL(28, 8), 
    @HumanResourceRate AS DECIMAL(28, 8), 
    @OthersRate AS DECIMAL(28, 8), 
    @QuantityUnit AS  DECIMAL(28, 8), 
    @BMaterialQuantity AS DECIMAL(28, 8), 
    @ProductQuantityEnd AS DECIMAL(28, 8), 
    @ConvertedUnitEnd AS  DECIMAL(28, 8), 
    @ProductQuantityCoe AS DECIMAL(28, 8), --Sè l­îng NVL ®Þnh møc    
    @TransactionID AS nvarchar(50), 
    @ProductUnitID AS nvarchar(50), 
    @MaterialUnitID AS nvarchar(50), 
    @ListMaterial_cur AS CURSOR, 
    @ConvertedDecimal INT

SELECT @ConvertedDecimal = ConvertDecimal FROM MT0000
--print 'da vao1'
SET @sSQL=N'
    SELECT     MaterialID, SUM(ISNULL(MaterialQuantity, 0)) AS MaterialQuantity, 
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
        ExpenseID =''COST001'' AND
        ProductID IN (SELECT ProductID FROM  MT2222) AND        
        MaterialTypeID ='''+@MaterialTypeID+''' 
    GROUP BY MaterialID, ProductID, ProductQuantity, AT1302_P.UnitID, AT1302_M.UnitID, MT0400.DivisionID '


IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV8102' AND Xtype ='V')
    EXEC ('CREATE VIEW MV8102 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV8102 AS '+@sSQL)

SET @ListMaterial_cur  = CURSOR SCROLL KEYSET FOR 
    SELECT         MV8102.MaterialID, 
            MV8102.MaterialQuantity, ---So luong NVL phat sinh trong ky
            MV8102.ConvertedAmount, ---- Chi phi cua NVL phat sinh trong ky
            MV8102.ProductID, --- Ma san pham
            MV8102.ProductQuantity, -- So luong thanh pham hoan thanh
            ISNULL(MT2222.ProductQuantity, 0)*ISNULL(MT2222.MaterialRate, 0)/100 AS InPocessQuantity, --- So luong thanh pham do dang quy doi
            MT2222.ProductQuantity, --Sè l­îng SPDD
            MT2222.PerfectRate, MT2222.MaterialRate, MT2222.HumanResourceRate, MT2222.OthersRate, 
            MV8102.ProductUnitID, MV8102.MaterialUnitID
        FROM MV8102 LEFT JOIN MT2222 ON MV8102.DivisionID = MT2222.DivisionID AND MV8102.ProductID  = MT2222.ProductID 
        UNION
         SELECT         
            MT1613.MaterialID, 
            0 AS MaterialQuantity, 
            0 AS ConvertedAmount, 
            MT1613.ProductID, 
            ProductQuantity = ISNULL((SELECT SUM(ISNULL(Quantity, 0))     
                                FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID
                                    WHERE     MT1001.ProductID = MT1613.ProductID AND
                                        MT0810.PeriodID =@PeriodID AND
                                        MT0810.ResultTypeID = 'R01' AND --- ket qua san xuat la thanh pham
                                        MT1001.DivisionID =@DivisionID), 0), 
            MT2222.ProductQuantity*MT2222.MaterialRate/100 AS InPocessQuantity, 
            MT2222.PerfectRate, MT2222.MaterialRate, MT2222.HumanresourceRate, MT2222.OthersRate, 
            MT2222.ProductQuantity, 
            IP.UnitID AS ProductUnitID, 
            IM.UnitID AS MaterialUnitID
    FROM  MT1613     LEFT JOIN MT2222 ON MT2222.DivisionID = MT1613.DivisionID AND MT2222.ProductID = MT1613.ProductID
            LEFT JOIN AT1302 AS IM ON IM.DivisionID = MT1613.DivisionID AND IM.InventoryID = MT1613.MaterialID 
            LEFT JOIN AT1302 AS IP ON IP.DivisionID = MT1613.DivisionID AND IP.InventoryID = MT1613.ProductID 
    WHERE   MT1613.ProductID NOT IN (SELECT DISTINCT ProductID FROM MT0400 
                        WHERE DivisionID =@DivisionID AND PeriodID =@PeriodID AND 
                            MaterialTypeID = @MaterialTypeID AND ExpenseID ='COST001'  )  AND --- khong co phat sinh duoc phan bo
        MT1613.PeriodID = @PeriodID AND
        MT1613.DivisionID = @DivisionID AND
        MT1613.MaterialTypeID = @MaterialTypeID AND
        MT1613.ExpenseID = 'COST001'

        OPEN @ListMaterial_cur 
        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @InProcessQuantity, @ProductQuantityEnd, @PerfectRate, 
                    @MaterialRate, @HumanResourceRate, @OthersRate, @ProductUnitID, @MaterialUnitID
        WHILE @@Fetch_Status = 0
            BEGIN    

        
        --B­íc 1 :X¸c ®Þnh chi phÝ NVL ®Þnh møc

        SELECT     @MaterialAmount = MT1603.MaterialAmount, 
            @ProductQuantityCoe = MT1603.ProductQuantity        
                    FROM     MT1603  INNER JOIN  MT1602 ON MT1602.DivisionID=MT1603.DivisionID AND MT1602.ApportionID=MT1603.ApportionID 
                    WHERE   MT1602.Disabled = 0 AND MT1602.IsBOM=1 AND
                        MT1603.ProductID= @ProductID AND MT1603.ExpenseID='COST001'
                AND MaterialID= @MaterialID AND MT1603.DivisionID = @DivisionID

        --B­íc 2: TÝnh Chi  phÝ SPDD  theo NVL
            SET @MaterialInprocessCost = round(ISNULL(@MaterialAmount, 0)*ISNULL(@InProcessQuantity, 0), @ConvertedDecimal)
            
            IF @ProductQuantityEnd  <>0 
                BEGIN
                    SET @ConvertedUnitEnd = ISNULL(@MaterialInprocessCost, 0)/@ProductQuantityEnd
                    SET @QuantityUnit = ISNULL(@ProductQuantityCoe, 0) * ISNULL(@InProcessQuantity, 0)/@ProductQuantityEnd
                END
              ELSE 
                BEGIN
                    SET @QuantityUnit = 0
                    SET @ConvertedUnitEnd =  0    
                END
        --B­íc 3: TÝnh SL SPDD  NVL/1SP DD
                                
        
        EXEC AP0000 @DivisionID, @TransactionID  OUTPUT, 'MT1613', 'IT', @CMonth, @CYear, 18, 3, 0, '-'

    INSERT MT1613 (PeriodID, TranMonth, TranYear, DivisionID, VoucherID, TransactionID, 
            ProductID, MaterialID, ExpenseID, MaterialTypeID, ProductUnitID, MaterialUnitID, PerfectRate, --- ProductUnitID
                      MaterialQuantity, ConvertedAmount, 
              ProductQuantity, QuantityUnit, ConvertedUnit, 
             CreateDate, CreateUserID, Type, MaterialRate, HumanResourceRate, OthersRate     )

    VALUES  (@PeriodID, @TranMonth, @TranYear, @DivisionID, @VoucherID, @TransactionID, 
        @ProductID, @MaterialID, 'COST001', @MaterialTypeID, @ProductUnitID, @MaterialUnitID, @PerfectRate, 
        @MaterialQuantity, @MaterialInprocessCost, 
        @ProductQuantityEnd, @QuantityUnit, @ConvertedUnitEnd, 
        Getdate(), 'ASOFTADMIN', 'E', @MaterialRate, @HumanResourceRate, @OthersRate     )

    FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @InProcessQuantity, @ProductQuantityEnd, @PerfectRate, 
    @MaterialRate, @HumanResourceRate, @OthersRate, @ProductUnitID, @MaterialUnitID
    END
    CLOSE @ListMaterial_cur