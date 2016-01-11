IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1308_QC]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1308_QC]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--------- Created by Nguyen Van Nhan, Date 06/09/2003
--------- Purpose: Tính giá bình quân gia quyền cuối kỳ cho trường hợp xuất VCNB cho mặt hàng theo quy cách.

--- AP1308_QC 'PL',11,2013,2,2,0
CREATE PROCEDURE [dbo].[AP1308_QC] 
    @DivisionID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT, 
    @QuantityDecimals TINYINT, 
    @UnitCostDecimals TINYINT, 
    @ConvertedDecimals TINYINT
   
AS

DECLARE 
    @InventoryID NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @AccountID NVARCHAR(50), 
    @DetalAmount DECIMAL(28, 8), 
    @UnitPrice DECIMAL(28, 8), 
    @BQGQ_cur CURSOR,
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

SET @BQGQ_Cur = CURSOR SCROLL KEYSET FOR 
    SELECT WareHouseID, 
        InventoryID, 
        UnitPrice, 
        InventoryAccountID,
        S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
        S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID
    FROM AV1309_QC
    WHERE InventoryID IN 
    (
        SELECT InventoryID 
        FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
        WHERE AT2007.DivisionID = @DivisionID 
        AND AT2007.TranMonth = @TranMonth 
        AND AT2007.TranYear = @TranYear 
        AND KindVoucherID = 3
    )
    ORDER BY InventoryID, 
        ActBegTotal DESC, 
        ActBegQty DESC, 
        UnitPrice DESC, 
        ActReceivedQty DESC 
 
OPEN @BQGQ_cur
FETCH NEXT FROM @BQGQ_cur INTO @WareHouseID, @InventoryID, @UnitPrice, @AccountID, @S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
    @S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID

WHILE @@Fetch_Status = 0
    BEGIN --- Cap nhat gia xuat kho cho xuat van chuyen noi bo
        SET @UnitPrice = 
        (
            SELECT TOP 1 UnitPrice 
            FROM AV1309_QC 
            WHERE WareHouseID = @WareHouseID 
            AND InventoryID = @InventoryID 
            AND InventoryAccountID = @AccountID
            AND DivisionID = @DivisionID
            AND S01ID = @S01ID		AND S02ID = @S02ID		AND S03ID = @S03ID		AND S04ID = @S04ID		AND S05ID = @S05ID
            AND S06ID = @S06ID		AND S07ID = @S07ID		AND S08ID = @S08ID		AND S09ID = @S09ID		AND S10ID = @S10ID
            AND S11ID = @S11ID		AND S12ID = @S12ID		AND S13ID = @S13ID		AND S14ID = @S14ID		AND S15ID = @S15ID
            AND S16ID = @S16ID		AND S17ID = @S17ID		AND S18ID = @S18ID		AND S19ID = @S19ID		AND S20ID = @S20ID 
        )
        
        UPDATE AT2007
        SET UnitPrice = ROUND(@UnitPrice, @UnitCostDecimals), 
			ConvertedPrice =  ROUND(@UnitPrice, @UnitCostDecimals),
            OriginalAmount = ROUND(ROUND(@UnitPrice, @UnitCostDecimals) * ROUND(AT2007.ActualQuantity, @QuantityDecimals), @ConvertedDecimals), 
            ConvertedAmount = ROUND(ROUND(@UnitPrice, @UnitCostDecimals) * ROUND(AT2007.ActualQuantity, @QuantityDecimals), @ConvertedDecimals) 
            FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
            LEFT JOIN WT8899 ON WT8899.DivisionID = AT2007.DivisionID AND WT8899.VoucherID = AT2007.VoucherID AND WT8899.TransactionID = AT2007.TransactionID
            WHERE AT2006.KindVoucherID = 3 ---- Xac dinh la xuat van chuyen noi bo
                AND AT2007.InventoryID = @InventoryID 
                AND AT2007.TranMonth = @TranMonth 
                AND AT2007.TranYear = @TranYear 
                AND AT2007.DivisionID = @DivisionID 
                AND AT2007.CreditAccountID = @AccountID 
                AND AT2006.WareHouseID2 = @WareHouseID
                AND ISNULL(WT8899.S01ID,'') = Isnull(@S01ID,'')
				AND ISNULL(WT8899.S02ID,'') = isnull(@S02ID,'') 
				AND ISNULL(WT8899.S03ID,'') = isnull(@S03ID,'') 	
				AND ISNULL(WT8899.S04ID,'') = isnull(@S04ID,'') 
				AND ISNULL(WT8899.S05ID,'') = isnull(@S05ID,'') 
				AND ISNULL(WT8899.S06ID,'') = isnull(@S06ID,'') 
				AND ISNULL(WT8899.S07ID,'') = isnull(@S07ID,'') 
				AND ISNULL(WT8899.S08ID,'') = isnull(@S08ID,'') 
				AND ISNULL(WT8899.S09ID,'') = isnull(@S09ID,'') 
				AND ISNULL(WT8899.S10ID,'') = isnull(@S10ID,'') 
				AND ISNULL(WT8899.S11ID,'') = isnull(@S11ID,'') 
				AND ISNULL(WT8899.S12ID,'') = isnull(@S12ID,'') 
				AND ISNULL(WT8899.S13ID,'') = isnull(@S13ID,'') 
				AND ISNULL(WT8899.S14ID,'') = isnull(@S14ID,'') 
				AND ISNULL(WT8899.S15ID,'') = isnull(@S15ID,'') 
				AND ISNULL(WT8899.S16ID,'') = isnull(@S16ID,'') 
				AND ISNULL(WT8899.S17ID,'') = isnull(@S17ID,'') 
				AND ISNULL(WT8899.S18ID,'') = isnull(@S18ID,'') 
				AND ISNULL(WT8899.S19ID,'') = isnull(@S19ID,'')
				AND ISNULL(WT8899.S20ID,'') = isnull(@S20ID,'')
                
        SET @DetalAmount = 0

        FETCH NEXT FROM @BQGQ_cur INTO @WareHouseID, @InventoryID, @UnitPrice, @AccountID
    END
CLOSE @BQGQ_cur
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
