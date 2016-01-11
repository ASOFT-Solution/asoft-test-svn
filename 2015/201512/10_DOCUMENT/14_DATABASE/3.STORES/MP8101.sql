/****** Object:  StoredProcedure [dbo].[MP8101]    Script Date: 08/02/2010 13:50:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang Thi Lan Date 12/11/2003
--Purpose :TÝnh chi phÝ dë dang cuèi kú cho NVL TT theo PP ¦íc l­îng t­¬ng ®­¬ng
--Tinh cho tung NVL
--Edit BY : Nguyen Quoc Huy
--Edit BY: Dang Le Bao Quynh; Date 16/03/2007
--Purpose: Sua loi tinh do dang cuoi ky khi ket qua san xuat khong co thanh pham ma chi co do dang.
--Edit BY: Dang Le Bao Quynh; Date 29/06/2007
--Purpose: Bo rem dong 141 (--AND MaterialID = @MaterialID)
--Edit BY: Dang Le Bao Quynh; Date: 13/09/2007
--Purpose: Bo sung them nhom NVL phat sinh trong ky truoc nhung khong phat sinh trong ky nay
--Edit BY: Dang Le Bao Quynh; Date: 16/05/2008
--Purpose: Sua lai cach lay cac san pham do dang dau ky
--Edit BY: Dang Le Bao Quynh; Date: 29/07/2008
--Purpose: Sua lai cach tinh cac san pham do dang dau ky
--- Modify on 11/06/2014 by Bảo Anh: Sửa cách tính @MaterialInprocessCost
--- Modify on 12/06/2014 by Tấn Phú: Them tong so san pham do dang trong ky @@TotalInProcessQuantity
/********************************************
'* Edited BY: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP8101] @DivisionID AS nvarchar(50), 
                 @PeriodID AS nvarchar(50), 
                 @TranMonth AS INT, 
                 @TranYear AS INT, 
                 @MaterialTypeID AS nvarchar(50), 
                 @VoucherID AS nvarchar(50), 
                 @CMonth AS nvarchar(50), 
                 @CYear AS nvarchar(50)
AS 
SET NOCOUNT ON
DECLARE @sSQL1 AS nvarchar(4000), 
    @sSQL2 AS nvarchar(4000), 
    @BSumConverted621 AS DECIMAL(28, 8), --Chi phÝ NVL ®Çu kú
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
    @ProductQuantityEnd AS DECIMAL(28, 8), ---Sè l­îng DD cuèi kú
    @HumanResourceRate AS DECIMAL(28, 8), 
    @OthersRate AS DECIMAL(28, 8), 
    @ConvertedUnitEnd AS DECIMAL(28, 8), 
    @QuantityUnit AS  DECIMAL(28, 8), 
    @BMaterialQuantity AS DECIMAL(28, 8), 
    @TransactionID AS nvarchar(50), 
    @ProductUnitID AS nvarchar(50), 
    @MaterialUnitID AS nvarchar(50), 
    @ListMaterial_cur1 AS CURSOR, 
    @ListMaterial_cur AS CURSOR, 
    @ConvertedDecimal INT, 
    @TotalInProcessQuantity AS DECIMAL(28, 8)


SELECT @ConvertedDecimal= ConvertDecimal FROM MT0000 Where DivisionID = @DivisionID
--print ' ---- Chi phi phat sinh trong ky da duoc phan bo '
SET @sSQL1=N'
SELECT MaterialID, SUM(MaterialQuantity) AS MaterialQuantity, 
    SUM(convertedAmount) AS ConvertedAmount, 
    ProductID, --- Ma thanh pham
    --- So luong thanh pham duoc san xuat trong ky
    ProductQuantity = (SELECT SUM(Quantity) 
                        FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID 
                        WHERE MT1001.ProductID = MT0400.ProductID AND MT0810.ResultTypeID =''R01'' AND MT0810.PeriodID = '''+@PeriodID+'''  
                            AND MT1001.DivisionID ='''+@DivisionID+'''), 
    AT1302_P.UnitID AS ProductUnitID, 
    AT1302_M.UnitID AS MaterialUnitID, 
    MT0400.DivisionID
FROM MT0400 LEFT JOIN AT1302 AT1302_P ON MT0400.DivisionID = AT1302_P .DivisionID AND MT0400.ProductID = AT1302_P .InventoryID
        LEFT JOIN AT1302 AT1302_M ON MT0400.DivisionID = AT1302_M.DivisionID AND MT0400.MaterialID=AT1302_M.InventoryID
WHERE MT0400.DivisionID ='''+@DivisionID+''' AND
    PeriodID = '''+@PeriodID+''' AND
    ExpenseID =''COST001'' AND
    ProductID IN (SELECT ProductID FROM  MT2222) AND        
    MaterialTypeID ='''+@MaterialTypeID+''' 
GROUP BY MaterialID, ProductID, ProductQuantity, AT1302_P.UnitID, AT1302_M.UnitID, MT0400.DivisionID
UNION ALL'

SET @sSQL2=N'
SELECT DISTINCT MaterialID,  sum(MaterialQuantity), 0 AS ConvertedAmount, ProductID, 
    ProductQuantity = (SELECT SUM(Quantity)  
                        FROM MT1001 INNER JOIN MT0810 ON MT0810.VoucherID = MT1001.VoucherID 
                        WHERE MT1001.ProductID = MT1613.ProductID AND MT0810.ResultTypeID =''R01'' 
                            AND MT0810.PeriodID = '''+@PeriodID+'''  
                            AND MT0810.DivisionID ='''+@DivisionID+'''), 
    ProductUnitID, MaterialUnitID, DivisionID 
FROM MT1613 
WHERE Type = ''B'' AND ExpenseID =''COST001'' AND DivisionID = ''' + @DivisionID + '''  
    AND ProductID IN (SELECT ProductID FROM  MT2222) 
    AND PeriodID = ''' + @PeriodID + ''' AND MaterialTypeID = ''' + @MaterialTypeID + ''' 
    AND ProductID + ''_'' + MaterialID NOT IN 
    (SELECT ProductID + ''_'' + MaterialID FROM MT0400 
    WHERE     DivisionID =''' + @DivisionID + ''' AND 
        PeriodID = ''' + @PeriodID + ''' AND 
        ExpenseID = ''COST001'' AND
        MaterialTypeID =''' + @MaterialTypeID + ''' ) GROUP BY MaterialID,ProductID,ProductUnitID,MaterialUnitID, DivisionID  '

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV8101' AND Xtype ='V')
    EXEC ('CREATE VIEW MV8101 AS '+@sSQL1+@sSQL2)
ELSE
    EXEC ('ALTER VIEW MV8101 AS '+@sSQL1+@sSQL2)

--print @sSQL

SET @ListMaterial_cur  = CURSOR SCROLL KEYSET FOR 
 
    SELECT         MV8101.MaterialID, 
            MV8101.MaterialQuantity, --    So luong NVL phat sinh trong ky
            MV8101.ConvertedAmount, --     Chi phi cua NVL phat sinh trong ky
            MV8101.ProductID, ---     Ma san pham
            MV8101.ProductQuantity, --     So luong thanh pham hoan thanh
            MT2222.ProductQuantity*MT2222.MaterialRate/100 AS InPocessQuantity, --- So luong thanh pham do dang quy doi
            MT2222.PerfectRate, MT2222.MaterialRate, MT2222.HumanresourceRate, MT2222.OthersRate, 
            MT2222.ProductQuantity, MV8101.ProductUnitID, MV8101.MaterialUnitID,
            (Select sum(MT22.ProductQuantity*MT22.MaterialRate/100)
            From MT2222 MT22 Where MT22.DivisionID = MT2222.DivisionID And MT22.ProductID = MT2222.ProductID)
        FROM MV8101 LEFT JOIN MT2222 ON MV8101.DivisionID  = MT2222.DivisionID AND MV8101.ProductID  = MT2222.ProductID 

        OPEN @ListMaterial_cur 
        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductID, 
                                    @ProductQuantity, @InProcessQuantity, @PerfectRate, @MaterialRate, 
                                     @HumanresourceRate, @OthersRate, @ProductQuantityEnd, @ProductUnitID, @MaterialUnitID, @TotalInProcessQuantity


        WHILE @@Fetch_Status = 0
            BEGIN    

            
        --B­íc 1 :X¸c ®Þnh chi phÝ NVL DD ®Çu kú cho tõng NVL
                    
                  SELECT     @BSumConverted621 = SUM(ConvertedAmount), 
                    @BMaterialQuantity = SUM(MaterialQuantity)
                  FROM     MT1613
                  WHERE     DivisionID= @DivisionID AND  PeriodID =  @PeriodID 
                        AND TranMonth=@TranMonth AND TranYear = @TranYear 
                        AND MaterialTypeID = @MaterialTypeID             
                        AND ProductID =@ProductID 
                        AND MaterialID = @MaterialID 
                        AND Type ='B'
            
                
                --PRINT     '@MaterialTypeID' + @MaterialTypeID            
                --PRINT     '@ProductID' + @ProductID
                --PRINT     '@MaterialID' + @MaterialID

        --B­íc 2:X¸c ®Þnh chi phÝ NVL ph¸t sinh trong kú

        SET @ISumConverted621 = @ConvertedAmount
        /*
        IF EXISTS (SELECT TOP 1 1 FROM MT0400 
                WHERE     DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) AND 
                PeriodID = @PeriodID AND 
                ExpenseID = 'COST001' AND
                MaterialTypeID = @MaterialTypeID AND
                ProductID = @ProductID AND
                MaterialID = @MaterialID)
            BEGIN        
            */
                --B­íc 3:TÝnh chi phÝ DD CKú  NVL theo PP ¦íc l­îng t­¬ng ®­¬ng
                IF (ISNULL(@ProductQuantity, 0) +ISNULL(@InProcessQuantity, 0)) <>0
                BEGIN
                    SET @MaterialInprocessCost =round((ISNULL(@BSumConverted621, 0) 
                    +ISNULL(@ISumConverted621, 0)) *ISNULL(@InProcessQuantity, 0)/(ISNULL(@ProductQuantity, 0)
                    +ISNULL(@TotalInProcessQuantity, 0)), @ConvertedDecimal)
                END    
                ELSE
                    SET @MaterialInprocessCost = 0
        
                ---Chi phi NVL/1SPDD
                IF (ISNULL(@ProductQuantityEnd, 0) <>0)
                SET @ConvertedUnitEnd = ( ISNULL(@MaterialInprocessCost, 0)/@ProductQuantityEnd)
                ELSE 
                SET @ConvertedUnitEnd = 0
                --So luong NVL/1SPDD
                IF( (ISNULL(@ProductQuantity, 0) +ISNULL(@InProcessQuantity, 0)) <> 0  AND  ISNULL(@ProductQuantityEnd, 0) <>0)
        
                    SET @QuantityUnit  =((ISNULL(@BMaterialQuantity, 0)  + ISNULL(@MaterialQuantity, 0))*ISNULL(@InProcessQuantity, 0)/(ISNULL(@ProductQuantity, 0) +ISNULL(@InProcessQuantity, 0)))/ @ProductQuantityEnd
                ELSE 
                    SET @QuantityUnit  = 0
                
                EXEC AP0000 @DivisionID, @TransactionID  OUTPUT, 'MT1613', 'IT', @CMonth, @CYear, 18, 3, 0, '-'
    
                --PRINT '@TransactionID' + @TransactionID
            
                INSERT MT1613 (PeriodID, TranMonth, TranYear, DivisionID, VoucherID, TransactionID, 
                        ProductID, MaterialID, ExpenseID, MaterialTypeID, ProductUnitID, MaterialUnitID, PerfectRate, --- ProductUnitID
                                  MaterialQuantity, ConvertedAmount, 
                         ProductQuantity, QuantityUnit, ConvertedUnit, 
                         CreateDate, CreateUserID, Type, MaterialRate, HumanResourceRate, OthersRate     )
            
                VALUES  (@PeriodID, @TranMonth, @TranYear, @DivisionID, @VoucherID, @TransactionID, 
                    @ProductID, @MaterialID, 'COST001', @MaterialTypeID, @ProductUnitID, @MaterialUnitID, @PerfectRate, 
                    ((ISNULL(@BMaterialQuantity, 0)  + ISNULL(@MaterialQuantity, 0)) * ISNULL(@InProcessQuantity, 0)/(ISNULL(@ProductQuantity, 0) +ISNULL(@InProcessQuantity, 0))), 
                    @MaterialInprocessCost, 
                    @ProductQuantityEnd, @QuantityUnit, @ConvertedUnitEnd, 
                    Getdate(), 'ASOFTADMIN', 'E', @MaterialRate, @HumanResourceRate, @OthersRate)
/*
            END
        ELSE
            BEGIN
                EXEC AP0000 @DivisionID, @TransactionID  OUTPUT, 'MT1613', 'IT', @CMonth, @CYear, 18, 3, 0, '-'
                INSERT MT1613 (PeriodID, TranMonth, TranYear, DivisionID, VoucherID, TransactionID, 
                        ProductID, MaterialID, ExpenseID, MaterialTypeID, ProductUnitID, MaterialUnitID, PerfectRate, 
                                  MaterialQuantity, ConvertedAmount, 
                         ProductQuantity, QuantityUnit, ConvertedUnit, 
                         CreateDate, CreateUserID, Type, MaterialRate, HumanResourceRate, OthersRate     )
                SELECT     @PeriodID, @TranMonth, @TranYear, @DivisionID, @VoucherID, @TransactionID, 
                    @ProductID, @MaterialID, 'COST001', @MaterialTypeID, @ProductUnitID, @MaterialUnitID, @PerfectRate, 
                    MaterialQuantity, ConvertedAmount, 
                    ProductQuantity, QuantityUnit, ConvertedUnit, 
                    Getdate(), 'ASOFTADMIN', 'E', @MaterialRate, @HumanResourceRate, @OthersRate
                FROM MT1613 
                WHERE     DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) AND 
                    PeriodID = @PeriodID AND 
                    ExpenseID = 'COST001' AND
                    MaterialTypeID = @MaterialTypeID AND
                    ProductID = @ProductID AND
                    MaterialID = @MaterialID
            END    
  */  


    FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @InProcessQuantity, @PerfectRate, @MaterialRate, @HumanresourceRate, @OthersRate, @ProductQuantityEnd, @ProductUnitID, @MaterialUnitID, @TotalInProcessQuantity
    END
    CLOSE @ListMaterial_cur

SET NOCOUNT OFF