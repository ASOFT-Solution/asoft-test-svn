IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1410_QC]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1410_QC]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Tiểu Mai on 05/11/2015
--- Purpose: Tính giá xuất kho bình quân liên hoàn (quản lý hàng theo quy cách.)


CREATE PROCEDURE  [dbo].[AP1410_QC]
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
	@SQL nvarchar(max),
    @S01ID VARCHAR(50),
	@S02ID VARCHAR(50),
    @S03ID VARCHAR(50),
    @S04ID VARCHAR(50),
    @S05ID VARCHAR(50),
    @S06ID VARCHAR(50),
    @S07ID VARCHAR(50),
    @S08ID VARCHAR(50),
    @S09ID VARCHAR(50),
    @S10ID VARCHAR(50),
    @S11ID VARCHAR(50),
    @S12ID VARCHAR(50),
    @S13ID VARCHAR(50),
    @S14ID VARCHAR(50),
    @S15ID VARCHAR(50),
    @S16ID VARCHAR(50),
    @S17ID VARCHAR(50),
    @S18ID VARCHAR(50),
    @S19ID VARCHAR(50),
    @S20ID VARCHAR(50)
    

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
		T6.CreateDate,
		T89.S01ID, T89.S02ID, T89.S03ID, T89.S04ID, T89.S05ID, T89.S06ID, T89.S07ID, T89.S08ID, T89.S09ID, T89.S10ID,
		T89.S11ID, T89.S12ID, T89.S13ID, T89.S14ID, T89.S15ID, T89.S16ID, T89.S17ID, T89.S18ID, T89.S19ID, T89.S20ID
	INTO #AT2007_Tmp1 
	FROM AT2006 T6, 
		AT2007 T7
		LEFT JOIN WT8899 T89 ON T89.DivisionID = T7.DivisionID AND T89.VoucherID = T7.VoucherID AND T89.TransactionID = T7.TransactionID
	WHERE T6.VoucherID = T7.VoucherID
		AND T6.DivisionID = T7.DivisionID
		AND T6.DivisionID = @DivisionID
		AND T6.TranMonth = @TranMonth
		AND T6.TranYear = @TranYear
		AND T7.InventoryID IN (SELECT InventoryID FROM AT1302 WHERE MethodID = 5 AND DivisionID = @DivisionID)
	
	SET @SQL = 'SELECT * , 
		IDENTITY(INT, 1, 1) AS Indexs 
		INTO #AT2007_Tmp 
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
		Indexs,
		S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
		S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID 
	FROM #AT2007_Tmp
	WHERE KindVoucherID IN (2, 3, 4, 6, 8)
		AND InventoryID BETWEEN @FromInventoryID AND @ToInventoryID
		AND (CASE WHEN KindVoucherID = 3 THEN WarehouseID2 ELSE WarehouseID END) BETWEEN @FromWareHouseID AND @ToWareHouseID
		AND CreditAccountID BETWEEN @FromAccountID AND @ToAccountID 
	ORDER BY Indexs

	OPEN @Cur

	FETCH NEXT FROM @Cur INTO @VoucherID, @VoucherDate, @TransactionID, @WarehouseID, @InventoryID, @AccountID, @Indexs, @S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
    @S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID
	WHILE @@Fetch_Status = 0
		BEGIN
			SELECT @BeginQty = ROUND(BeginQuantity, @QuantityDecimals), 
				@BeginAmount = ROUND(BeginAmount, @ConvertedDecimals) 
			FROM AT2008_QC
			WHERE DivisionID = @DivisionID
				AND TranMonth = @TranMonth
				AND TranYear = @TranYear
				AND WarehouseID = @WarehouseID
				AND InventoryID = @InventoryID 
				AND InventoryAccountID = @AccountID
				AND ISNULL(S01ID,'') = Isnull(@S01ID,'')
				AND ISNULL(S02ID,'') = isnull(@S02ID,'') 
				AND ISNULL(S03ID,'') = isnull(@S03ID,'') 	
				AND ISNULL(S04ID,'') = isnull(@S04ID,'') 
				AND ISNULL(S05ID,'') = isnull(@S05ID,'') 
				AND ISNULL(S06ID,'') = isnull(@S06ID,'') 
				AND ISNULL(S07ID,'') = isnull(@S07ID,'') 
				AND ISNULL(S08ID,'') = isnull(@S08ID,'') 
				AND ISNULL(S09ID,'') = isnull(@S09ID,'') 
				AND ISNULL(S10ID,'') = isnull(@S10ID,'') 
				AND ISNULL(S11ID,'') = isnull(@S11ID,'') 
				AND ISNULL(S12ID,'') = isnull(@S12ID,'') 
				AND ISNULL(S13ID,'') = isnull(@S13ID,'') 
				AND ISNULL(S14ID,'') = isnull(@S14ID,'') 
				AND ISNULL(S15ID,'') = isnull(@S15ID,'') 
				AND ISNULL(S16ID,'') = isnull(@S16ID,'') 
				AND ISNULL(S17ID,'') = isnull(@S17ID,'') 
				AND ISNULL(S18ID,'') = isnull(@S18ID,'') 
				AND ISNULL(S19ID,'') = isnull(@S19ID,'')
				AND ISNULL(S20ID,'') = isnull(@S20ID,'')

			SELECT @DebitQty = ROUND(ISNULL(SUM(ISNULL(ActualQuantity, 0)), 0), @QuantityDecimals), 
				@DebitAmount = ROUND(ISNULL(SUM(ISNULL(OriginalAmount, 0)), 0), @ConvertedDecimals)
			FROM #AT2007_Tmp
			WHERE KindVoucherID IN (1, 3, 5, 7)
				AND WareHouseID = @WarehouseID
				AND InventoryID = @InventoryID
				AND DebitAccountID = @AccountID
				AND VoucherDate < = @VoucherDate
				AND Indexs < @Indexs
				AND ISNULL(S01ID,'') = Isnull(@S01ID,'')
				AND ISNULL(S02ID,'') = isnull(@S02ID,'') 
				AND ISNULL(S03ID,'') = isnull(@S03ID,'') 	
				AND ISNULL(S04ID,'') = isnull(@S04ID,'') 
				AND ISNULL(S05ID,'') = isnull(@S05ID,'') 
				AND ISNULL(S06ID,'') = isnull(@S06ID,'') 
				AND ISNULL(S07ID,'') = isnull(@S07ID,'') 
				AND ISNULL(S08ID,'') = isnull(@S08ID,'') 
				AND ISNULL(S09ID,'') = isnull(@S09ID,'') 
				AND ISNULL(S10ID,'') = isnull(@S10ID,'') 
				AND ISNULL(S11ID,'') = isnull(@S11ID,'') 
				AND ISNULL(S12ID,'') = isnull(@S12ID,'') 
				AND ISNULL(S13ID,'') = isnull(@S13ID,'') 
				AND ISNULL(S14ID,'') = isnull(@S14ID,'') 
				AND ISNULL(S15ID,'') = isnull(@S15ID,'') 
				AND ISNULL(S16ID,'') = isnull(@S16ID,'') 
				AND ISNULL(S17ID,'') = isnull(@S17ID,'') 
				AND ISNULL(S18ID,'') = isnull(@S18ID,'') 
				AND ISNULL(S19ID,'') = isnull(@S19ID,'')
				AND ISNULL(S20ID,'') = isnull(@S20ID,'')

			SELECT @CreditQty = ROUND(ISNULL(SUM(ISNULL(ActualQuantity, 0)), 0), @QuantityDecimals), 
				@CreditAmount = ROUND(ISNULL(SUM(ISNULL(OriginalAmount, 0)), 0), @ConvertedDecimals)
			FROM #AT2007_Tmp
			WHERE KindVoucherID IN (2, 3, 4, 6, 8)
				AND @WarehouseID = (CASE WHEN KindVoucherID = 3 THEN WareHouseID2 ELSE WarehouseID END)
				AND InventoryID = @InventoryID
				AND CreditAccountID = @AccountID
				AND VoucherDate < = @VoucherDate
				AND Indexs < @Indexs
				AND ISNULL(S01ID,'') = Isnull(@S01ID,'')
				AND ISNULL(S02ID,'') = isnull(@S02ID,'') 
				AND ISNULL(S03ID,'') = isnull(@S03ID,'') 	
				AND ISNULL(S04ID,'') = isnull(@S04ID,'') 
				AND ISNULL(S05ID,'') = isnull(@S05ID,'') 
				AND ISNULL(S06ID,'') = isnull(@S06ID,'') 
				AND ISNULL(S07ID,'') = isnull(@S07ID,'') 
				AND ISNULL(S08ID,'') = isnull(@S08ID,'') 
				AND ISNULL(S09ID,'') = isnull(@S09ID,'') 
				AND ISNULL(S10ID,'') = isnull(@S10ID,'') 
				AND ISNULL(S11ID,'') = isnull(@S11ID,'') 
				AND ISNULL(S12ID,'') = isnull(@S12ID,'') 
				AND ISNULL(S13ID,'') = isnull(@S13ID,'') 
				AND ISNULL(S14ID,'') = isnull(@S14ID,'') 
				AND ISNULL(S15ID,'') = isnull(@S15ID,'') 
				AND ISNULL(S16ID,'') = isnull(@S16ID,'') 
				AND ISNULL(S17ID,'') = isnull(@S17ID,'') 
				AND ISNULL(S18ID,'') = isnull(@S18ID,'') 
				AND ISNULL(S19ID,'') = isnull(@S19ID,'')
				AND ISNULL(S20ID,'') = isnull(@S20ID,'')


			IF @BeginQty + @DebitQty - @CreditQty <> 0
				BEGIN
					SET @UnitPrice = ROUND(((@BeginAmount + @DebitAmount - @CreditAmount)/(@BeginQty + @DebitQty - @CreditQty)), @UnitCostDecimals)
	                
					UPDATE AT2007
					SET UnitPrice = @UnitPrice,
						ConvertedPrice =  @UnitPrice,
						OriginalAmount = ROUND((@UnitPrice * ROUND(ActualQuantity, @QuantityDecimals)), @ConvertedDecimals), 
						ConvertedAmount = ROUND((@UnitPrice * ROUND(ActualQuantity, @QuantityDecimals)), @ConvertedDecimals)
					FROM AT2007 LEFT JOIN WT8899 ON WT8899.DivisionID = AT2007.DivisionID AND WT8899.VoucherID = AT2007.VoucherID AND WT8899.TransactionID = AT2007.TransactionID	
					WHERE AT2007.VoucherID = @VoucherID 
						AND AT2007.TransactionID = @TransactionID
						AND AT2007.DivisionID = @DivisionID
						AND ISNULL(S01ID,'') = Isnull(@S01ID,'')
						AND ISNULL(S02ID,'') = isnull(@S02ID,'') 
						AND ISNULL(S03ID,'') = isnull(@S03ID,'') 	
						AND ISNULL(S04ID,'') = isnull(@S04ID,'') 
						AND ISNULL(S05ID,'') = isnull(@S05ID,'') 
						AND ISNULL(S06ID,'') = isnull(@S06ID,'') 
						AND ISNULL(S07ID,'') = isnull(@S07ID,'') 
						AND ISNULL(S08ID,'') = isnull(@S08ID,'') 
						AND ISNULL(S09ID,'') = isnull(@S09ID,'') 
						AND ISNULL(S10ID,'') = isnull(@S10ID,'') 
						AND ISNULL(S11ID,'') = isnull(@S11ID,'') 
						AND ISNULL(S12ID,'') = isnull(@S12ID,'') 
						AND ISNULL(S13ID,'') = isnull(@S13ID,'') 
						AND ISNULL(S14ID,'') = isnull(@S14ID,'') 
						AND ISNULL(S15ID,'') = isnull(@S15ID,'') 
						AND ISNULL(S16ID,'') = isnull(@S16ID,'') 
						AND ISNULL(S17ID,'') = isnull(@S17ID,'') 
						AND ISNULL(S18ID,'') = isnull(@S18ID,'') 
						AND ISNULL(S19ID,'') = isnull(@S19ID,'')
						AND ISNULL(S20ID,'') = isnull(@S20ID,'')

					UPDATE #AT2007_Tmp
					SET OriginalAmount = ROUND((@UnitPrice * ROUND(ActualQuantity, @QuantityDecimals)), @ConvertedDecimals)
					WHERE VoucherID = @VoucherID 
						AND TransactionID = @TransactionID
						AND ISNULL(S01ID,'') = Isnull(@S01ID,'')
						AND ISNULL(S02ID,'') = isnull(@S02ID,'') 
						AND ISNULL(S03ID,'') = isnull(@S03ID,'') 	
						AND ISNULL(S04ID,'') = isnull(@S04ID,'') 
						AND ISNULL(S05ID,'') = isnull(@S05ID,'') 
						AND ISNULL(S06ID,'') = isnull(@S06ID,'') 
						AND ISNULL(S07ID,'') = isnull(@S07ID,'') 
						AND ISNULL(S08ID,'') = isnull(@S08ID,'') 
						AND ISNULL(S09ID,'') = isnull(@S09ID,'') 
						AND ISNULL(S10ID,'') = isnull(@S10ID,'') 
						AND ISNULL(S11ID,'') = isnull(@S11ID,'') 
						AND ISNULL(S12ID,'') = isnull(@S12ID,'') 
						AND ISNULL(S13ID,'') = isnull(@S13ID,'') 
						AND ISNULL(S14ID,'') = isnull(@S14ID,'') 
						AND ISNULL(S15ID,'') = isnull(@S15ID,'') 
						AND ISNULL(S16ID,'') = isnull(@S16ID,'') 
						AND ISNULL(S17ID,'') = isnull(@S17ID,'') 
						AND ISNULL(S18ID,'') = isnull(@S18ID,'') 
						AND ISNULL(S19ID,'') = isnull(@S19ID,'')
						AND ISNULL(S20ID,'') = isnull(@S20ID,'')
				END
			ELSE
				BEGIN
					SET @UnitPrice = 0
					UPDATE AT2007
					SET UnitPrice = @UnitPrice,
						ConvertedPrice =  @UnitPrice, 
						OriginalAmount = 0, 
						ConvertedAmount = 0
					FROM AT2007 LEFT JOIN WT8899 ON WT8899.DivisionID = AT2007.DivisionID AND WT8899.VoucherID = AT2007.VoucherID AND WT8899.TransactionID = AT2007.TransactionID	 
					WHERE AT2007.VoucherID = @VoucherID 
						AND AT2007.TransactionID = @TransactionID
						AND AT2007.DivisionID = @DivisionID

					UPDATE #AT2007_Tmp
					SET OriginalAmount = 0
					WHERE VoucherID = @VoucherID 
						AND TransactionID = @TransactionID
						AND ISNULL(S01ID,'') = Isnull(@S01ID,'')
						AND ISNULL(S02ID,'') = isnull(@S02ID,'') 
						AND ISNULL(S03ID,'') = isnull(@S03ID,'') 	
						AND ISNULL(S04ID,'') = isnull(@S04ID,'') 
						AND ISNULL(S05ID,'') = isnull(@S05ID,'') 
						AND ISNULL(S06ID,'') = isnull(@S06ID,'') 
						AND ISNULL(S07ID,'') = isnull(@S07ID,'') 
						AND ISNULL(S08ID,'') = isnull(@S08ID,'') 
						AND ISNULL(S09ID,'') = isnull(@S09ID,'') 
						AND ISNULL(S10ID,'') = isnull(@S10ID,'') 
						AND ISNULL(S11ID,'') = isnull(@S11ID,'') 
						AND ISNULL(S12ID,'') = isnull(@S12ID,'') 
						AND ISNULL(S13ID,'') = isnull(@S13ID,'') 
						AND ISNULL(S14ID,'') = isnull(@S14ID,'') 
						AND ISNULL(S15ID,'') = isnull(@S15ID,'') 
						AND ISNULL(S16ID,'') = isnull(@S16ID,'') 
						AND ISNULL(S17ID,'') = isnull(@S17ID,'') 
						AND ISNULL(S18ID,'') = isnull(@S18ID,'') 
						AND ISNULL(S19ID,'') = isnull(@S19ID,'')
						AND ISNULL(S20ID,'') = isnull(@S20ID,'')
				END

			FETCH NEXT FROM @Cur INTO @VoucherID, @VoucherDate, @TransactionID, @WarehouseID, @InventoryID, @AccountID, @Indexs, @S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
    @S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID
		END
		DROP TABLE #AT2007_Tmp
--END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
