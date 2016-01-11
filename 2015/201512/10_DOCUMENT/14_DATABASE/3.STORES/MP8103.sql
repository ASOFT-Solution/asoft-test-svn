/****** Object:  StoredProcedure [dbo].[MP8103]    Script Date: 01/07/2011 10:11:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



--Created BY Hoang Thi Lan Date 12/11/2003
--Purpose :Tính chi phí dở dang cuối kỳ cho NVL TT theo PP NVL truc triep
--Tinh cho tung NVL
--Edit BY: Vo Thanh Huong, date: 01/03/2006
 
ALTER PROCEDURE  [dbo].[MP8103] @DivisionID AS NVARCHAR(50), 
                 @PeriodID AS NVARCHAR(50), 
                 @TranMonth AS INT, 
                 @TranYear AS INT, 
                 @MaterialTypeID AS NVARCHAR(50), 
                 @VoucherID AS NVARCHAR(50), 
                 @CMonth AS NVARCHAR(50), 
                 @CYear AS NVARCHAR(50)

AS 
DECLARE @sSQL AS VARCHAR(8000), 
    @BSumConverted621 AS DECIMAL(28, 8), --Chi phí NVL đầu kỳ
    @ISumConverted621 AS DECIMAL(28, 8), --Chi phí NVL trong kỳ
    @Quantity AS DECIMAL(28, 8), --Số lượng thành phẩm
    @QuantityInprocess AS DECIMAL(28, 8), --Số lương dở dang cuối kỳ
    @MaterialRate AS DECIMAL(28, 8), --Tỉ lệ % NVL
    @MaterialID AS NVARCHAR(50), 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @MaterialInprocessCost AS DECIMAL(28, 8), 
    @ProductID AS NVARCHAR(50), 
    @PerfectRate AS DECIMAL(28, 8), 
    @InProcessQuantity AS DECIMAL(28, 8), 
    @ProductQuantityEnd AS DECIMAL(28, 8), 
    @BMaterialQuantity AS DECIMAL(28, 8), --SL NVL DD đầu kỳ
    @HumanResourceRate AS DECIMAL(28, 8), 
    @ConvertedUnitEnd AS DECIMAL(28, 8), 
    @OthersRate AS DECIMAL(28, 8), 
    @QuantityUnit AS DECIMAL(28, 8), 
    @TransactionID AS NVARCHAR(50), 
    @ProductUnitID AS NVARCHAR(50), 
    @MaterialUnitID AS NVARCHAR(50), 
    @ListMaterial_cur AS CURSOR, 
    @ConvertedDecimal INT


SELECT @ConvertedDecimal = ConvertDecimal FROM MT0000
--Lay CP NVL TT phat sinh trong kỳ
--Lay SL TP 
SET @ListMaterial_cur  = CURSOR SCROLL KEYSET FOR 
SELECT    MT0400.ProductID, 
    ProductQuantity =ISNULL( (SELECT SUM(Quantity)  FROM MT1001 INNER JOIN MT0810 ON MT0810.VoucherID = MT1001.VoucherID 
                       WHERE MT1001.ProductID = MT0400.ProductID AND 
                MT0810.ResultTypeID ='R01' AND MT0810.PeriodID =  @PeriodID  AND MT0810.DivisionID=@DivisionID), 0), 
    MT0400.MaterialID, --So lượng TP được SX trong ky
     MT2222.ProductQuantity, --- So luong thanh pham do dang 
      MT2222.PerfectRate, 
    MT2222.MaterialRate, 
    MT2222.ProductQuantity, 
    AT1302_P.UnitID, 
    AT1302_M.UnitID, 
    SUM(ISNULL(MT0400.ConvertedAmount, 0)) AS ConvertedAmount, ---  Chi phi phat sinh trong kỳ
    SUM(ISNULL(MT0400.MaterialQuantity, 0)) AS MaterialQuantity, 
    BSumConverted621 = ISNULL((SELECT  SUM(ISNULL(ConvertedAmount, 0))
              FROM     MT1613
              WHERE     PeriodID =  @PeriodID  AND 
                TranMonth = @TranMonth AND TranYear = @TranYear  AND 
                ExpenseID= 'COST001' AND 
                MaterialTypeID =  @MaterialTypeID  AND
                MaterialID = MT0400.MaterialID AND
                ProductID =MT0400.ProductID  AND DivisionID = @DivisionID AND
                Type ='B'), 0), 
    
    BMaterialQuantity = ISNULL((SELECT SUM(ISNULL(MaterialQuantity, 0)) 
        FROM     MT1613
        WHERE     PeriodID = @PeriodID  AND 
                TranMonth = @TranMonth AND TranYear = @TranYear   AND 
                ExpenseID = 'COST001' AND 
                MaterialTypeID = @MaterialTypeID  AND
                MaterialID =  MT0400.MaterialID AND
                ProductID = MT0400.ProductID AND DivisionID = @DivisionID AND
                Type ='B'), 0)
FROM MT0400 LEFT JOIN MT2222 ON MT0400.DivisionID=MT2222.DivisionID AND MT0400.ProductID=MT2222.ProductID
          LEFT JOIN AT1302 AT1302_P ON MT0400.DivisionID = AT1302_P .DivisionID AND MT0400.ProductID = AT1302_P .InventoryID
          LEFT JOIN AT1302 AT1302_M ON MT0400.DivisionID = AT1302_M.DivisionID AND MT0400.MaterialID = AT1302_M.InventoryID
WHERE MT0400.DivisionID = @DivisionID  AND
        MT0400.PeriodID =  @PeriodID  AND
        MT0400.ExpenseID = 'COST001' AND
        MT0400.MaterialTypeID =  @MaterialTypeID AND
        MT0400.ProductID IN (SELECT DISTINCT ProductID FROM  MT2222  ) 
GROUP BY MT0400.ProductID, 
     MT0400.MaterialID, --So lượng TP được SX trong ky
      MT2222.ProductQuantity, --- So luong thanh pham do dang 
       MT2222.PerfectRate, 
     MT2222.MaterialRate, 
     MT2222.ProductQuantity, 
     AT1302_P.UnitID, AT1302_M.UnitID
UNION
SELECT    MT1613.ProductID, 
    ProductQuantity =ISNULL( (SELECT SUM(Quantity)  FROM MT1001 INNER JOIN MT0810 ON MT0810.VoucherID = MT1001.VoucherID 
                       WHERE MT1001.ProductID = MT1613.ProductID AND 
                MT0810.ResultTypeID ='R01' AND MT0810.PeriodID = @PeriodID  AND MT0810.DivisionID = @DivisionID), 0), 
    MT1613.MaterialID, --So lượng TP được SX trong ky
     MT2222.ProductQuantity, --- So luong thanh pham do dang 
      MT2222.PerfectRate, 
    MT2222.MaterialRate, 
    MT2222.ProductQuantity, 
    AT1302_P.UnitID, 
    AT1302_M.UnitID, 
    0 AS ConvertedAmount, ---  Chi phi phat sinh trong kỳ
    0 AS MaterialQuantity, 
    BSumConverted621 = SUM(ISNULL(ConvertedAmount, 0)), 
    BMaterialQuantity =  SUM(ISNULL(MaterialQuantity, 0)) 
FROM MT1613    LEFT JOIN MT2222 ON MT1613.DivisionID = MT2222.DivisionID AND MT1613.ProductID = MT2222.ProductID
        LEFT JOIN AT1302 AT1302_P ON MT1613.DivisionID = AT1302_P .DivisionID AND MT1613.ProductID = AT1302_P .InventoryID
        LEFT JOIN AT1302 AT1302_M ON MT1613.DivisionID = AT1302_M.DivisionID AND MT1613.MaterialID = AT1302_M.InventoryID    
WHERE MT1613.DivisionID = @DivisionID  AND
        MT1613.PeriodID = @PeriodID  AND
        MT1613.ExpenseID = 'COST001' AND
        MT1613.MaterialTypeID = @MaterialTypeID  AND
        MT1613.Type='B' AND
        MT1613.ProductID IN (SELECT DISTINCT ProductID FROM  MT2222  )  AND 
        MT1613.ProductID + MT1613.MaterialID NOT IN (SELECT DISTINCT  ProductID + MaterialID FROM MT0400
                    WHERE 
                    DivisionID = @DivisionID  AND
                    PeriodID = @PeriodID  AND
                    ExpenseID ='COST001' AND
                    MaterialTypeID = @MaterialTypeID) 
GROUP BY MT1613.ProductID, 
     MT1613.MaterialID, --So lượng TP được SX trong ky
      MT2222.ProductQuantity, --- So luong thanh pham do dang 
       MT2222.PerfectRate, 
     MT2222.MaterialRate, 
     MT2222.ProductQuantity, 
     AT1302_P.UnitID, 
    AT1302_M.UnitID


/*SELECT    MT0400.ProductID, 
    ProductQuantity = (SELECT SUM(Quantity)  FROM MT1001 INNER JOIN MT0810 ON MT0810.VoucherID = MT1001.VoucherID 
                       WHERE MT1001.ProductID = MT0400.ProductID AND 
                MT0810.ResultTypeID ='R01' AND MT0810.PeriodID =@PeriodID AND MT0810.DivisionID =@DivisionID), 
    MT0400.MaterialID, --So lượng TP được SX trong ky
     MT2222.ProductQuantity, --- So luong thanh pham do dang 
      MT2222.PerfectRate, 
    MT2222.MaterialRate, 
     MT2222.ProductQuantity, 
     AT1302_P.UnitID, 
     AT1302_M.UnitID, 
    SUM(ISNULL(MT0400.ConvertedAmount, 0)) AS ConvertedAmount, ---  Chi phi phat sinh trong kỳ
    SUM(ISNULL(MT0400.MaterialQuantity, 0)) AS MaterialQuantity
FROM MT0400 LEFT JOIN MT2222 ON MT0400.ProductID=MT2222.ProductID
          LEFT JOIN AT1302 AT1302_P ON MT0400.ProductID = AT1302_P .InventoryID
        LEFT JOIN AT1302 AT1302_M ON MT0400.MaterialID=AT1302_M.InventoryID
    
WHERE MT0400.DivisionID =@DivisionID AND
        MT0400.PeriodID = @PeriodID AND
        MT0400.ExpenseID ='COST001' AND
        MT0400.MaterialTypeID = @MaterialTypeID  AND
        MT0400.ProductID IN (SELECT ProductID FROM  MT2222  ) 
GROUP BY MT0400.ProductID, 
    
     MT0400.MaterialID, --So lượng TP được SX trong ky
      MT2222.ProductQuantity, --- So luong thanh pham do dang 
       MT2222.PerfectRate, 
     MT2222.MaterialRate, 
     MT2222.ProductQuantity, 
     AT1302_P.UnitID, AT1302_M.UnitID*/

        OPEN @ListMaterial_cur 
        FETCH NEXT FROM @ListMaterial_cur INTO  @ProductID, @ProductQuantity, @MaterialID, @InProcessQuantity, 
                                    @PerfectRate, @MaterialRate, @ProductQuantityEnd, @ProductUnitID, 
                                    @MaterialUnitID, @ConvertedAmount, @MaterialQuantity, 
                                    @BSumConverted621, @BMaterialQuantity
                                 
        WHILE @@Fetch_Status = 0
            BEGIN    

--Dua ra khoi CURSOR vi khong duoc tinh trong truong hop co NVL DDDK nhung khong phat sinh trong ky.  

        --Bước 1 :Xác định chi phí NVL DD đầu kỳ cho từng NVL
        /* SELECT     @BSumConverted621 = SUM(ISNULL(ConvertedAmount, 0)), 
                    @BMaterialQuantity = SUM(ISNULL(MaterialQuantity, 0))
                      FROM     MT1613
                      WHERE     DivisionID= @DivisionID AND  PeriodID =  @PeriodID 
                        AND TranMonth=@TranMonth AND TranYear = @TranYear 
                        AND ExpenseID='COST001' AND MaterialID = @MaterialID 
                        AND Type ='B'                
            */        
        --Bước 2:Xác định chi phí NVL phát sinh trong kỳ

        SET @ISumConverted621 = @ConvertedAmount
        
        --Bước 3:Tính chi phí DD CKỳ  NVL theo PP NVLTT
        IF (@ProductQuantity +@InProcessQuantity <> 0 )
            SET @MaterialInprocessCost = round((ISNULL(@BSumConverted621, 0) +ISNULL(@ISumConverted621, 0)) *ISNULL(@InProcessQuantity, 0)/(ISNULL(@ProductQuantity, 0) +ISNULL(@InProcessQuantity, 0)), @ConvertedDecimal)
        ELSE            
            SET @MaterialInprocessCost = 0

        --Bước 4 :Tính chi phí DD CKỳ  NVL theo PP Ước lượng tương đương/1SP
        IF (@ProductQuantityEnd <>0 )
            SET @ConvertedUnitEnd = ISNULL(@MaterialInprocessCost, 0)/@ProductQuantityEnd
        ELSE
            SET @ConvertedUnitEnd = 0
        
        

        --Bước 5 :Tính  SL NVL theo PP Ước lượng tương đương/1SP
        IF (ISNULL(@ProductQuantity, 0) +ISNULL(@InProcessQuantity, 0)) <>0 AND @ProductQuantityEnd <>0
        SET  @QuantityUnit =((ISNULL(@BMaterialQuantity, 0) + ISNULL(@MaterialQuantity, 0)) *ISNULL(@InProcessQuantity, 0)/(ISNULL(@ProductQuantity, 0) +ISNULL(@InProcessQuantity, 0)) )/@ProductQuantityEnd
        ELSE 
        SET  @QuantityUnit = 0

        EXEC AP0000 @DivisionID, @TransactionID  OUTPUT, 'MT1613', 'IT', @CMonth, @CYear, 18, 3, 0, '-'

        INSERT MT1613 (PeriodID, TranMonth, TranYear, DivisionID, VoucherID, TransactionID, 
             ProductID, MaterialID, ExpenseID, MaterialTypeID, ProductUnitID, MaterialUnitID, PerfectRate, --- ProductUnitID
                      MaterialQuantity, ConvertedAmount, 
             ProductQuantity, QuantityUnit, ConvertedUnit, 
             CreateDate, CreateUserID, Type, MaterialRate, HumanResourceRate, OthersRate     )

    VALUES  (@PeriodID, @TranMonth, @TranYear, @DivisionID, @VoucherID, @TransactionID, 
        @ProductID, @MaterialID, 'COST001', @MaterialTypeID, @ProductUnitID, @MaterialUnitID, @PerfectRate, 
        @MaterialQuantity + @BMaterialQuantity, @MaterialInProcessCost, 
        @ProductQuantityEnd, @QuantityUnit, @ConvertedUnitEnd, 
        Getdate(), Null, 'E', @MaterialRate, @HumanResourceRate, @OthersRate)
    
FETCH NEXT FROM @ListMaterial_cur INTO  @ProductID, @ProductQuantity, @MaterialID, @InProcessQuantity, 
                                    @PerfectRate, @MaterialRate, @ProductQuantityEnd, @ProductUnitID, 
                                    @MaterialUnitID, @ConvertedAmount, @MaterialQuantity, 
                                    @BSumConverted621, @BMaterialQuantity
            
END
GO


