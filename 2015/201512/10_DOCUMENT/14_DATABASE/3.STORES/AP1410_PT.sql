IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1410_PT]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1410_PT]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






/********************************************
'* Edited by: [GS] [Vi?t Khánh] [29/07/2010]
--Update by: Mai Duyên,Date 04/06/2014. s?a l?i order by theo CreateDate, b? TransactionID (KH KingCom)
--Update by: Mai Duyên,Date 10/06/2014. Bo sung order by theo VoucherDate (KH KingCom)
--Update by: Mai Duyên,Date 30/07/2014.Fix loi co hang ban tra lai (KH PrintTech)
--Update by: Mai Duyên,Date 31/07/2014.Tra lai order by nhu ban dau VoucherDate,Orders,Transaction (KH PrintTech)
-- exec AP1309 @DivisionID=N'PRT',@TranMonth=4,@TranYear=2014,@FromInventoryID=N'TMIBAFWB0020',@ToInventoryID=N'TMIBAFWB0020',@FromWareHouseID=N'KHO 2',@ToWareHouseID=N'KSR',@FromAccountID=N'152',@ToAccountID=N'1561',@UserID=N'ASOFTADMIN',@GroupID=N'ADMIN'

'********************************************/

CREATE PROCEDURE [dbo].[AP1410_PT]
    @DivisionID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT, 
    @QuantityDecimals TINYINT, 
    @UnitCostDecimals TINYINT, 
    @ConvertedDecimals TINYINT, 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @FromWareHouseID NVARCHAR(50), 
    @ToWareHouseID NVARCHAR(50), 
    @FromAccountID NVARCHAR(50), 
    @ToAccountID NVARCHAR(50)
AS

DECLARE
    @WareHouseID NVARCHAR(50), 
    @InventoryID NVARCHAR(50), 
    @AccountID NVARCHAR(50), 
    @TransactionID NVARCHAR(50), 
    @Indexs INT, 
    @VoucherID NVARCHAR(50), 
    @VoucherDate DATETIME, 
    @BeginQty DECIMAL(28, 8), 
    @BeginAmount DECIMAL(28, 8), 
    @DebitQty DECIMAL(28, 8), 
    @DebitAmount DECIMAL(28, 8), 
    @CreditQty DECIMAL(28, 8), 
    @CreditAmount DECIMAL(28, 8), 
    @UnitPrice DECIMAL(28, 8), 
    @cur CURSOR,
    @TmpAmount  DECIMAL(28, 8), 
    @TmpQuantity  DECIMAL(28, 8),
    @tongA DECIMAL(28, 8),
    @tongb DECIMAL(28, 8)

SELECT T6.DivisionID, 
    T6.KindVoucherID, 
    T6.WareHouseID, 
    T6.WareHouseID2, 
    T7.InventoryID, 
    T7.ActualQuantity, 
    T7.OriginalAmount, 
    T7.DebitAccountID, 
    T7.CreditAccountID, 
    T6.VoucherID, 
    T6.VoucherDate, 
    T7.TransactionID, 
    CASE WHEN T6.KindVoucherID IN (1, 5, 7) THEN 1
        WHEN T6.KindVoucherID = 3 THEN 2
        ELSE 3
    END AS Orders ,
    T6.CreateDate
INTO #AT2007_Tmp1 
FROM AT2006 T6, 
    AT2007 T7
WHERE T6.VoucherID = T7.VoucherID
    AND T6.DivisionID = T7.DivisionID
    AND T6.DivisionID = @DivisionID
    AND T6.TranMonth = @TranMonth
    AND T6.TranYear = @TranYear
    AND T7.InventoryID IN (SELECT InventoryID FROM AT1302 WHERE MethodID = 5 AND DivisionID = @DivisionID)
SELECT * , 
IDENTITY(INT, 1, 1) AS Indexs 
INTO #AT2007_Tmp 
FROM #AT2007_Tmp1
ORDER BY VoucherDate, 
		--CreateDate, 
		--Orders
		Orders, 
		TransactionID
    

DROP TABLE #AT2007_Tmp1

SET @cur = CURSOR STATIC FOR
SELECT VoucherID, 
    VoucherDate, 
    TransactionID, 
    CASE WHEN KindVoucherID = 3 THEN WarehouseID2 
        ELSE WarehouseID 
    END AS WarehouseID, 
    InventoryID, 
    CreditAccountID, 
    Indexs
FROM #AT2007_Tmp
WHERE KindVoucherID IN (2, 3, 4, 6, 8)
    AND InventoryID BETWEEN @FromInventoryID AND @ToInventoryID
    AND (CASE WHEN KindVoucherID = 3 THEN WarehouseID2 ELSE WarehouseID END) BETWEEN @FromWareHouseID AND @ToWareHouseID
    AND CreditAccountID BETWEEN @FromAccountID AND @ToAccountID 
ORDER BY Indexs

OPEN @Cur

FETCH NEXT FROM @Cur INTO @VoucherID, @VoucherDate, @TransactionID, @WarehouseID, @InventoryID, @AccountID, @Indexs
WHILE @@Fetch_Status = 0
    BEGIN
        SELECT @BeginQty = ROUND(BeginQuantity, @QuantityDecimals), 
            @BeginAmount = ROUND(BeginAmount, @ConvertedDecimals) 
        FROM At2008
        WHERE DivisionID = @DivisionID
            AND TranMonth = @TranMonth
            AND TranYear = @TranYear
            AND WarehouseID = @WarehouseID
            AND InventoryID = @InventoryID 
            AND InventoryAccountID = @AccountID

        SELECT @DebitQty = ROUND(ISNULL(SUM(ISNULL(ActualQuantity, 0)), 0), @QuantityDecimals), 
            @DebitAmount = ROUND(ISNULL(SUM(ISNULL(OriginalAmount, 0)), 0), @ConvertedDecimals)
        FROM #AT2007_Tmp
        WHERE KindVoucherID IN (1, 3, 5, 7)
            AND WareHouseID = @WarehouseID
            AND InventoryID = @InventoryID
            AND DebitAccountID = @AccountID
            AND VoucherDate < = @VoucherDate
           AND Indexs < @Indexs

        SELECT @CreditQty = ROUND(ISNULL(SUM(ISNULL(ActualQuantity, 0)), 0), @QuantityDecimals), 
            @CreditAmount = ROUND(ISNULL(SUM(ISNULL(OriginalAmount, 0)), 0), @ConvertedDecimals)
        FROM #AT2007_Tmp
        WHERE KindVoucherID IN (2, 3, 4, 6, 8)
            AND @WarehouseID = (CASE WHEN KindVoucherID = 3 THEN WareHouseID2 ELSE WarehouseID END)
            AND InventoryID = @InventoryID
            AND CreditAccountID = @AccountID
            AND VoucherDate < = @VoucherDate
            AND Indexs < @Indexs
            
            
        --------Hang ban tra lai , date 30/07/2014     
            SELECT @TmpQuantity= ROUND(ISNULL(SUM(ISNULL(ActualQuantity, 0)), 0), @QuantityDecimals), 
            @TmpAmount = ROUND(ISNULL(SUM(ISNULL(OriginalAmount, 0)), 0), @ConvertedDecimals)
        FROM #AT2007_Tmp
        WHERE KindVoucherID = 10
            --AND WarehouseID = @WarehouseID
            AND InventoryID = @InventoryID
            AND VoucherDate < = @VoucherDate
            
            --Print '@TmpQuantity ' + str(@TmpQuantity) + '  ' +@VoucherID  + ' @Indexs ' + str(@Indexs)
            --Print '@@TmpAmount ' +str(@TmpAmount)+ '  ' +@VoucherID + ' @Indexs ' + str(@Indexs)
          ------------------------------------------------------------  
 
		-- SELECT @TmpQuantity = ROUND(ISNULL(SUM(ISNULL(AT9000.Quantity, 0)), 0), @QuantityDecimals), 
		-- @TmpAmount = ROUND(ISNULL(SUM(ISNULL(AT9000.OriginalAmount, 0)), 0), @ConvertedDecimals)
		--FROM AT2007 
		--	INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
		--	INNER JOIN AT9000 ON AT9000.DivisionID = AT2007.DivisionID AND AT9000.VoucherID = AT2007.VoucherID 
		--	AND AT9000.TransactionID = AT2007.TransactionID
		--WHERE AT2007.DivisionID =@DivisionID
		--	AND AT2006.KindVoucherID = 10 
		--	AND AT9000.TransactionTypeID = 'T25' 
		--	AND AT2007.InventoryID = @InventoryID
		--	AND AT2006.VoucherDate<=@VoucherDate
		--	AND AT9000.VoucherDate<=@VoucherDate
		--	AND AT2006.TranMonth = @TranMonth 
		--	AND AT2006.TranYear = @TranYear 
		--	AND AT9000.TranMonth = @TranMonth 
		--	AND AT9000.TranYear = @TranYear
			
  --------------------------------------------------------------------------------------------------  
		

        --IF (Isnull(@BeginQty,0) + isnull(@DebitQty,0) - isnull(@CreditQty,0)) <> 0
        IF (Isnull(@BeginQty,0) + isnull(@DebitQty,0) - isnull(@CreditQty,0)- isnull(@TmpQuantity,0)) <> 0
            BEGIN
                --SET @UnitPrice = ROUND(((@BeginAmount + @DebitAmount - @CreditAmount)/(@BeginQty + @DebitQty - @CreditQty)), @UnitCostDecimals)
                SET @UnitPrice = ROUND((( isnull(@BeginAmount,0) + isnull(@DebitAmount,0) - isnull(@CreditAmount,0)-isnull(@TmpAmount,0))/(isnull(@BeginQty,0) + isnull(@DebitQty,0) - isnull(@CreditQty,0)-isnull(@TmpQuantity,0))), @UnitCostDecimals)
                UPDATE AT2007
                SET UnitPrice = @UnitPrice, 
                    OriginalAmount = ROUND((@UnitPrice * ROUND(ActualQuantity, @QuantityDecimals)), @ConvertedDecimals), 
                    ConvertedAmount = ROUND((@UnitPrice * ROUND(ActualQuantity, @QuantityDecimals)), @ConvertedDecimals) 
                WHERE VoucherID = @VoucherID 
                    AND TransactionID = @TransactionID
                    AND DivisionID = @DivisionID

                UPDATE #AT2007_Tmp
                SET OriginalAmount = ROUND((@UnitPrice * ROUND(ActualQuantity, @QuantityDecimals)), @ConvertedDecimals)
                WHERE VoucherID = @VoucherID 
                    AND TransactionID = @TransactionID
                  
            END
        ELSE
            BEGIN
                SET @UnitPrice = 0
                UPDATE AT2007
                SET UnitPrice = @UnitPrice, 
                    OriginalAmount = 0, 
                    ConvertedAmount = 0 
                WHERE VoucherID = @VoucherID 
                    AND TransactionID = @TransactionID
                    AND DivisionID = @DivisionID
					
                UPDATE #AT2007_Tmp
                SET OriginalAmount = 0
                WHERE VoucherID = @VoucherID 
                    AND TransactionID = @TransactionID
            END
        FETCH NEXT FROM @Cur INTO @VoucherID, @VoucherDate, @TransactionID, @WarehouseID, @InventoryID, @AccountID, @Indexs
    END


DROP TABLE #AT2007_Tmp





GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

