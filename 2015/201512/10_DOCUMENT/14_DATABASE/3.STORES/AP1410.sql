IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1410]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1410]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
--Update by: Mai Duyên,Date 04/06/2014. sửa lại order by theo CreateDate, bỏ TransactionID (KH KingCom)
--Update by: Mai Duyên,Date 10/06/2014. Bo sung order by theo VoucherDate (KH KingCom)
--Update by: Bảo Anh,Date 26/05/2015. Không order by theo CreateDate nếu không phải KH KingCom
--Update by Tiểu Mai, Date 18/08/2015. Bổ sung đơn giá quy đổi = đơn giá chuẩn
--Update by: Bảo Anh,Date 10/11/2015. Sửa lỗi không tồn tại bảng tạm #AT2007_Tmp
'********************************************/

CREATE PROCEDURE  [dbo].[AP1410]
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
    @CustomerName INT ,
    @cur CURSOR,
	@SQL nvarchar(max)
    
SET @SQL = ''   
    
    --Tao bang tam de kiem tra day co phai la khach hang Sieu Thanh khong (CustomerName = 16)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

IF @CustomerName = 26 --- Customize PrintTech
	Exec AP1410_PT @DivisionID, @TranMonth, @TranYear, @QuantityDecimals, @UnitCostDecimals, @ConvertedDecimals, @FromInventoryID, @ToInventoryID, @FromWareHouseID, @ToWareHouseID, @FromAccountID, @ToAccountID
ELSE
 BEGIN
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

SELECT TOP 0 * INTO #AT2007_Tmp FROM #AT2007_Tmp1
ALTER TABLE #AT2007_Tmp ADD Indexs INT NULL

	IF @CustomerName = 25 --- Customize Kingcom	
		SET @SQL = 'INSERT INTO #AT2007_Tmp (DivisionID, KindVoucherID, WareHouseID, WareHouseID2, InventoryID,
		ActualQuantity, OriginalAmount, DebitAccountID, CreditAccountID, VoucherID, VoucherDate, TransactionID, Orders, CreateDate, Indexs)
		SELECT DivisionID, KindVoucherID, WareHouseID, WareHouseID2, InventoryID,
				ActualQuantity, OriginalAmount, DebitAccountID, CreditAccountID, VoucherID, VoucherDate, TransactionID, Orders, CreateDate, 
				ROW_NUMBER() over (order by VoucherDate, CreateDate, Orders) AS Indexs
		FROM #AT2007_Tmp1
		ORDER BY VoucherDate, 
				CreateDate, 
				Orders'
	ELSE
		SET @SQL = 'INSERT INTO #AT2007_Tmp (DivisionID, KindVoucherID, WareHouseID, WareHouseID2, InventoryID,
		ActualQuantity, OriginalAmount, DebitAccountID, CreditAccountID, VoucherID, VoucherDate, TransactionID, Orders, CreateDate, Indexs)
		SELECT DivisionID, KindVoucherID, WareHouseID, WareHouseID2, InventoryID,
				ActualQuantity, OriginalAmount, DebitAccountID, CreditAccountID, VoucherID, VoucherDate, TransactionID, Orders, CreateDate, 
				ROW_NUMBER() over (order by VoucherDate,Orders) AS Indexs
		FROM #AT2007_Tmp1
		ORDER BY VoucherDate,
				Orders'
	EXEC(@SQL)

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


			IF @BeginQty + @DebitQty - @CreditQty <> 0
				BEGIN
					SET @UnitPrice = ROUND(((@BeginAmount + @DebitAmount - @CreditAmount)/(@BeginQty + @DebitQty - @CreditQty)), @UnitCostDecimals)
	                
					UPDATE AT2007
					SET UnitPrice = @UnitPrice,
						ConvertedPrice =  @UnitPrice,
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
						ConvertedPrice =  @UnitPrice, 
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
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON