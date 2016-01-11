/****** Object:  StoredProcedure [dbo].[MP8201]    Script Date: 08/02/2010 14:02:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang Thi Lan Date 12/11/2003
--Purpose :Tính chi phí dở dang cuối kỳ cho NC TT theo PP Ước lượng tương đương
--Edit BY Nguyen Quoc Huy, Date 06/03/2004
--Edit BY: Dang Le Bao Quynh, Date 30/05/2007
--Purpose: Sua cach lay so lieu do dang dau ky tu bang MT1613 thay cho MT1612
--- Modify on 12/06/2014 by Tấn Phú: Them tong so san pham do dang trong ky @@TotalInProcessQuantity

/********************************************
'* Edited BY: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP8201] @DivisionID AS nvarchar(50), 
                 @PeriodID AS nvarchar(50), 
                 @TranMonth AS INT, 
                 @TranYear AS INT, 
                 @MaterialTypeID AS nvarchar(50), 
                 @VoucherID AS nvarchar(50), 
                 @CMonth AS nvarchar(50), 
                 @CYear AS nvarchar(50)

AS 
DECLARE @sSQL AS nvarchar(4000), 
    @BSumConverted622 AS DECIMAL(28, 8), --Chi phí NVL đầu kỳ
    @ISumConverted622 AS DECIMAL(28, 8), --Chi phí NVL trong kỳ
    @Quantity AS DECIMAL(28, 8), --Số lượng thành phẩm
    @QuantityInprocess AS DECIMAL(28, 8), --Số lương dở dang cuối kỳ
    @MaterialRate AS DECIMAL(28, 8), --Tỉ lệ % NVL
    @MaterialID AS nvarchar(50), 
    @ListMaterial_cur AS CURSOR, 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @InprocessCost AS DECIMAL(28, 8), 
    @ProductID AS nvarchar(50), 
    @PerfectRate AS DECIMAL(28, 8), 
    @InProcessQuantity AS DECIMAL(28, 8), 
    @TotalInProcessQuantity AS DECIMAL(28, 8), 
    @HumanResourceRate AS DECIMAL(28, 8), 
    @OthersRate AS DECIMAL(28, 8), 
    @ProductQuantityEnd AS DECIMAL(28, 8), 
    @QuantityUnit AS DECIMAL(28, 8), 
    @ConvertedUnitEnd AS DECIMAL(28, 8), 
    @TransactionID AS nvarchar(50), 
    @ProductUnitID AS nvarchar(50), 
    @MaterialUnitID AS nvarchar(50), 
    @ListProduct_cur AS CURSOR, 
    @ListMaterial_cur1 AS CURSOR, 
    @ConvertedDecimal INT, 
    @SumInProcessQuantity AS DECIMAL(28, 8)

SET NOCOUNT ON

SET @ConvertedDecimal = (Select ConvertDecimal FROM MT0000 where DivisionID = @DivisionID)

SET @sSQL=N'
SELECT SUM(ISNULL(MaterialQuantity, 0)) AS MaterialQuantity, 
    SUM(ISNULL(convertedAmount, 0)) AS ConvertedAmount, 
    ProductID, --- Ma thanh pham
    ---- So luong thanh pham duoc san xuat trong ky
    ProductQuantity = (SELECT SUM(Quantity) 
                        FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID 
                        WHERE MT1001.ProductID = MT0400.ProductID AND MT0810.ResultTypeID =''R01'' 
                            AND MT0810.PeriodID = '''+@PeriodID+''' AND MT1001.DivisionID ='''+@DivisionID+'''), 
    AT1302_P.UnitID AS ProductUnitID, 
    MT0400.MaterialTypeID, 
    MT0400.DivisionID
FROM MT0400 LEFT JOIN AT1302 AT1302_P ON MT0400.ProductID = AT1302_P .InventoryID AND MT0400.DivisionID = AT1302_P .DivisionID
WHERE MT0400.DivisionID =''' + @DivisionID+''' AND
    PeriodID = ''' + @PeriodID+''' AND
    ExpenseID = ''COST002'' AND
    ProductID IN (SELECT ProductID FROM  MT2222 WHERE DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID+''')))
GROUP BY  MT0400.MaterialTypeID, ProductID, ProductQuantity, AT1302_P.UnitID, MT0400.DivisionID '

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV8201' AND Xtype ='V')
    EXEC ('CREATE VIEW MV8201  -- tao boi MP8002
    AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV8201 -- tao boi MP8002
    AS '+@sSQL)

SET @ListProduct_cur  = CURSOR SCROLL KEYSET FOR 
SELECT MV8201.MaterialQuantity, ---So luong NVL phat sinh trong ky
       MV8201.ConvertedAmount, ---- Chi phi cua NVL phat sinh trong ky
       MV8201.ProductID, --- Ma san pham
       MV8201.ProductQuantity, -- So luong thanh pham hoan thanh
       ISNULL(MT2222.ProductQuantity, 0)*ISNULL(MT2222.HumanResourceRate, 0)/100 AS InPocessQuantity, --AS InPocessQuantity, --- So luong thanh pham do dang quy doi
       TotalInProcessQuantity = (select sum(ISNULL(MT22.ProductQuantity, 0)*ISNULL(MT22.HumanResourceRate, 0)/100) as InPocessQuantity from MT2222 MT22
        Where MT22.DivisionID = MT2222.DivisionID and MT22.ProductID = MT2222.ProductID group by MT22.DivisionID,MT22.ProductID),
       MT2222.PerfectRate, --% hoàn thành    
       MT2222.MaterialRate, --%NVL
       MT2222.HumanResourceRate, ---%NC TT
       MT2222.OthersRate, --%SXC
       MT2222.ProductQuantity, --Sô lượng SP DD cuối kỳ
       MV8201.ProductUnitID        
FROM MV8201 LEFT JOIN MT2222 ON MV8201.DivisionID = MT2222.DivisionID AND MV8201.ProductID = MT2222.ProductID 
WHERE MV8201.MaterialTypeID = @MaterialTypeID
UNION ALL  
SELECT 0 AS MaterialQuantity, 
    0 AS ConvertedAmount, 
    MT1613.ProductID, 
    ProductQuantity = ISNULL((SELECT SUM(ISNULL(Quantity, 0))
                                FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID
                                WHERE MT1001.ProductID = MT1613.ProductID AND MT0810.PeriodID =@PeriodID AND MT0810.ResultTypeID = 'R01' --- ket qua san xuat la thanh pham
                                    AND MT1001.DivisionID = @DivisionID), 0), 
    ISNULL(MT2222.ProductQuantity, 0)*ISNULL(MT2222.HumanResourceRate, 0)/100 AS InPocessQuantity, 
	TotalInProcessQuantity = (select sum(ISNULL(MT22.ProductQuantity, 0)*ISNULL(MT22.HumanResourceRate, 0)/100) as InPocessQuantity 
	from MT2222 MT22 Where MT22.DivisionID = MT2222.DivisionID and MT22.ProductID = MT2222.ProductID group by MT22.DivisionID, MT22.ProductID),

    MT2222.PerfectRate, MT2222.MaterialRate, MT2222.HumanresourceRate, MT2222.OthersRate, 
    MT2222.ProductQuantity, 
    IP.UnitID AS ProductUnitID
FROM MT1613 LEFT JOIN MT2222 ON MT2222.DivisionID = MT1613.DivisionID AND MT2222.ProductID = MT1613.ProductID
    LEFT JOIN AT1302 AS IP ON IP.DivisionID = MT1613.DivisionID AND IP.InventoryID = MT1613.ProductID 
WHERE MT1613.ProductID NOT IN (SELECT DISTINCT ProductID FROM MT0400 
                                WHERE PeriodID =@PeriodID AND MaterialTypeID = @MaterialTypeID AND ExpenseID ='COST002'
                                    AND DivisionID = @DivisionID)  --- khong co phat sinh duoc phan bo
    AND MT1613.PeriodID = @PeriodID 
    AND MT1613.DivisionID = @DivisionID 
    AND MT1613.MaterialTypeID = @MaterialTypeID 
    AND MT1613.ExpenseID = 'COST002'


OPEN @ListProduct_cur 
FETCH NEXT FROM @ListProduct_cur INTO
    @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @InProcessQuantity, @TotalInProcessQuantity, @PerfectRate, @MaterialRate, 
    @HumanResourceRate, @OthersRate, @ProductQuantityEnd, @ProductUnitID  


WHILE @@Fetch_Status = 0
    BEGIN    
    --Bước 1 :Xác định chi phí NC DD đầu kỳ         
    SET @BSumConverted622 = (SELECT SUM(ISNULL(ConvertedAmount, 0))
                            FROM MT1613 
                            WHERE DivisionID = @DivisionID 
                                AND PeriodID = @PeriodID AND TranMonth = @TranMonth AND TranYear = @TranYear  
                                AND ExpenseID = 'COST002' AND MaterialTypeID = @MaterialTypeID AND ProductID = @ProductID 
                                AND Type ='B')

    --Bước 2:Xác định chi phí NC phát sinh trong kỳ
    SET @ISumConverted622 = @ConvertedAmount
    /*
    print '@BSumConverted622' + str(@BSumConverted622)
    print '@@ISumConverted622' + str(@ISumConverted622)
    print '@@InProcessQuantity' + str(@InProcessQuantity)
    print '@@ProductQuantity' + str(@ProductQuantity)
    print '@@@TotalInProcessQuantity' + str(@TotalInProcessQuantity)
    */
    
    --Bước 3:Tính chi phí DD CKỳ  NVL theo PP Ước lượng tương đương
    IF ( ISNULL(@ProductQuantity, 0) +ISNULL(@InProcessQuantity, 0) <> 0)
         SET @InprocessCost = Round((ISNULL(@BSumConverted622, 0) + 
         ISNULL(@ISumConverted622, 0) ) *ISNULL(@InProcessQuantity, 0)/(ISNULL(@ProductQuantity, 0) 
         +ISNULL(@TotalInProcessQuantity, 0)), @ConvertedDecimal)
    ELSE SET @InprocessCost = 0 
 
    --Xác định Chi phí NC cho 1 san pham do dang
    IF (@ProductQuantityEnd <> 0)
         SET @ConvertedUnitEnd = ISNULL(@InprocessCost, 0)/@ProductQuantityEnd
    ELSE SET @ConvertedUnitEnd = 0

    EXEC AP0000 @DivisionID, @TransactionID  OUTPUT, 'MT1613', 'IT', @CMonth, @CYear, 18, 3, 0, '-'

    INSERT MT1613 (PeriodID, TranMonth, TranYear, DivisionID, VoucherID, TransactionID, 
            ProductID, MaterialID, ExpenseID, MaterialTypeID, ProductUnitID, MaterialUnitID, PerfectRate, 
                      MaterialQuantity, ConvertedAmount, 
              ProductQuantity, QuantityUnit, ConvertedUnit, 
             CreateDate, CreateUserID, Type, MaterialRate, HumanResourceRate, OthersRate     )

    VALUES  (@PeriodID, @TranMonth, @TranYear, @DivisionID, @VoucherID, @TransactionID, 
        @ProductID, @MaterialID, 'COST002', @MaterialTypeID, @ProductUnitID, @MaterialUnitID, @PerfectRate, 
        @MaterialQuantity, @InprocessCost, 
        @ProductQuantityEnd, @QuantityUnit, @ConvertedUnitEnd, 
        Getdate(), Null, 'E', @MaterialRate, @HumanResourceRate, @OthersRate     )
    FETCH NEXT FROM @ListProduct_cur INTO
    @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @InProcessQuantity, @TotalInProcessQuantity, @PerfectRate, @MaterialRate, 
    @HumanResourceRate, @OthersRate, @ProductQuantityEnd, @ProductUnitID  
END
CLOSE @ListProduct_cur
SET NOCOUNT OFF