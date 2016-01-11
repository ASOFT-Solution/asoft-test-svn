/****** Object: StoredProcedure [dbo].[MP8005] Script Date: 08/02/2010 13:28:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang Thi Lan 
--Date 18/11/2003
--Purpose :Tính giá thành sản phẩm
--- Modify on 08/05/2014 by Bảo Anh: Bổ sung format số lẻ
/********************************************
'* Edited BY: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP8005] 
    @DivisionID NVARCHAR(50), 
    @PeriodID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @BeginningInprocessCost DECIMAL(28, 8), 
    @EndInprocessCost DECIMAL(28, 8), 
    @AriseCost DECIMAL(28, 8), 
    @ProductQuantity DECIMAL(28, 8), 
    @Cost DECIMAL(28, 8), 
    @CostUnit DECIMAL(28, 8), 
    @ProductID NVARCHAR(50), 
    @LisProduct_Cur CURSOR, 
    @CMonth NVARCHAR(20), 
    @CYear NVARCHAR(20), 
    @VoucherID NVARCHAR(50), 
    @TransactionID NVARCHAR(50), 
    @Cost621 DECIMAL(28, 8), 
    @Cost622 DECIMAL(28, 8), 
    @Cost627 DECIMAL(28, 8), 
    @BCost621 DECIMAL(28, 8), 
    @ICost621 DECIMAL(28, 8), 
    @ECost621 DECIMAL(28, 8), 
    @BCost622 DECIMAL(28, 8), 
    @ICost622 DECIMAL(28, 8), 
    @ECost622 DECIMAL(28, 8), 
    @BCost627 DECIMAL(28, 8), 
    @ICost627 DECIMAL(28, 8), 
    @ECost627 DECIMAL(28, 8),
    @QuantityDecimals TINYINT, 
    @UnitCostDecimals TINYINT, 
    @ConvertedDecimals TINYINT

SELECT	@QuantityDecimals = QuantityDecimal, 
		@UnitCostDecimals = UnitPriceDecimal, 
		@ConvertedDecimals = ConvertDecimal
FROM MT0000
WHERE DivisionID =@DivisionID

SET @QuantityDecimals = ISNULL(@QuantityDecimals, 2)
SET @UnitCostDecimals = ISNULL(@UnitCostDecimals, 2)
SET @ConvertedDecimals = ISNULL(@ConvertedDecimals, 2)

IF @TranMonth > 9
    SET @CMonth = LTRIM(RTRIM(STR(@TranMonth)))
ELSE
    SET @CMonth = '0' + LTRIM(RTRIM(STR(@TranMonth)))

SET @CYear = RIGHT(LTRIM(RTRIM(STR(@TranYear))), 2)

DELETE FROM MT1614 WHERE PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))

EXEC AP0000 @DivisionID, @VoucherID OUTPUT, 'MT1614', 'IV', @CMonth, @CYear, 16, 3, 0, '-' 

SET @LisProduct_Cur = CURSOR SCROLL KEYSET FOR 
    SELECT ProductID, SUM(ISNULL(Quantity, 0))
    FROM MT1001
    INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT1001.VoucherID = MT0810.VoucherID
    WHERE MT0810.PeriodID = @PeriodID 
    AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
    AND MT0810.ResultTypeID = 'R01' --- Thanh pham nhap kho
    GROUP BY ProductID

OPEN @LisProduct_Cur 
FETCH NEXT FROM @LisProduct_Cur INTO @ProductID, @ProductQuantity
WHILE @@Fetch_Status = 0
    BEGIN 
        --Bước 1:Lấy chi phí dở dang đầu kỳ
        SELECT 
            @BeginningInprocessCost = SUM(ConvertedAmount), 
            @BCost621 = SUM(CASE WHEN ExpenseID = 'COST001' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END), 
            @BCost622 = SUM(CASE WHEN ExpenseID = 'COST002' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END), 
            @BCost627 = SUM(CASE WHEN ExpenseID = 'COST003' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END) 
        FROM MT1613
        WHERE PeriodID = @PeriodID 
            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) 
            AND ProductID = @ProductID 
            AND Type = 'B' --- Chi phi dau ky

        --Bước 2:Lấy chi phí phát sinh trong kỳ
        SELECT 
            @AriseCost = SUM(ConvertedAmount), 
            @ICost621 = SUM(CASE WHEN ExpenseID = 'COST001' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END), 
            @ICost622 = SUM(CASE WHEN ExpenseID = 'COST002' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END), 
            @ICost627 = SUM(CASE WHEN ExpenseID = 'COST003' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END) 
        FROM MT0400
        WHERE PeriodID = @PeriodID 
            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) 
            AND ProductID = @ProductID 

        --Bước 3:Lấy chi phí dở dang cuối kỳ
        SELECT 
            @EndInprocessCost = SUM(ConvertedAmount), 
            @ECost621 = SUM(CASE WHEN ExpenseID = 'COST001' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END), 
            @ECost622 = SUM(CASE WHEN ExpenseID = 'COST002' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END), 
            @ECost627 = SUM(CASE WHEN ExpenseID = 'COST003' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END) 
        FROM MT1613
        WHERE PeriodID = @PeriodID 
            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) 
            AND ProductID = @ProductID 
            AND Type = 'E'

        --Bước 4:Lấy số lượng thành phẩm 
        --SELECT @ProductQuantity = SUM(MT1001.Quantity) 
        --FROM MT1001 INNER JOIN MT0810 ON MT1001.VoucherID = MT0810.VoucherID
        --WHERE MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) AND MT0810.PeriodID = @PeriodID AND MT1001.ProductID = @ProductID AND Resul

        --Bước 5: Tính giá thành sản phẩm 
        SET @Cost = ROUND(ISNULL(@BeginningInprocessCost, 0),@ConvertedDecimals) + ROUND(ISNULL(@AriseCost, 0),@ConvertedDecimals) - ROUND(ISNULL(@EndInprocessCost, 0),@ConvertedDecimals)
        SET @Cost621 = ROUND(ISNULL(@BCost621, 0),@ConvertedDecimals) + ROUND(ISNULL(@ICost621, 0),@ConvertedDecimals) - ROUND(ISNULL(@ECost621, 0),@ConvertedDecimals)
        SET @Cost622 = ROUND(ISNULL(@BCost622, 0),@ConvertedDecimals) + ROUND(ISNULL(@ICost622, 0),@ConvertedDecimals) - ROUND(ISNULL(@ECost622, 0),@ConvertedDecimals)
        SET @Cost627 = ROUND(ISNULL(@BCost627, 0),@ConvertedDecimals) + ROUND(ISNULL(@ICost627, 0),@ConvertedDecimals) - ROUND(ISNULL(@ECost627, 0),@ConvertedDecimals)

        --Bước 6: Tính giá thành đơn vị
        IF @ProductQuantity > 0 
            SET @CostUnit = (ROUND(ISNULL(@BeginningInprocessCost, 0),@ConvertedDecimals) + ROUND(ISNULL(@AriseCost, 0),@ConvertedDecimals) - ROUND(ISNULL(@EndInprocessCost, 0),@UnitCostDecimals)) / ROUND(@ProductQuantity,@QuantityDecimals)
        ELSE SET @Cost = 0 

        EXEC AP0000 @DivisionID, @TransactionID OUTPUT, 'MT1614', 'IT', @CMonth, @CYear, 18, 3, 0, '-'

        INSERT INTO MT1614(DivisionID, PeriodID, ProductID, Cost, CostUnit, ProductQuantity, EmployeeID, VoucherDate, VoucherID, VoucherNo, TransactionID, LastModifyDate, CreateDate, CreateUserID, LastModifyUserID, TranMonth, TranYear, VoucherTypeID, Cost621, Cost622, Cost627, BeginningInprocessCost, AriseCost, EndInprocessCost)
        VALUES (@DivisionID, @PeriodID, @ProductID, ROUND(@Cost,@ConvertedDecimals), ROUND(@CostUnit,@UnitCostDecimals), ROUND(@ProductQuantity,@QuantityDecimals), NULL, NULL, @VoucherID, NULL, @TransactionID, NULL, GETDATE(), NULL, NULL, @TranMonth, @TranYear, NULL, ROUND(@Cost621,@ConvertedDecimals), ROUND(@Cost622,@ConvertedDecimals), ROUND(@Cost627,@ConvertedDecimals), ROUND(@BeginningInprocessCost,@ConvertedDecimals), ROUND(@AriseCost,@ConvertedDecimals), ROUND(@EndInprocessCost,@ConvertedDecimals))

        FETCH NEXT FROM @LisProduct_Cur INTO @ProductID, @ProductQuantity
    END

CLOSE @LisProduct_Cur