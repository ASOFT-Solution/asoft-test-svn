IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0599TL_QC]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0599TL_QC]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


  
  
---- Created by Tiểu Mai on 03/11/2015,   
---- Purpose: Cập nhật số dư tồn kho trường hợp xử lý khi quản lý mặt hàng theo quy cách.
  
CREATE PROCEDURE [dbo].[AP0599TL_QC]    
    @DivisionID NVARCHAR(50),     
    @TranYear INT,   
    @TranMonth INT,      
    @WareHouseID NVARCHAR(50),   
    @WareHouseID2 NVARCHAR(50),     
    @KindVoucherID INT,      
    @InventoryID NVARCHAR(50),     
    @ActualQuantity DECIMAL(28, 8),      
    @ConvertedAmount DECIMAL(28, 8),   
    @DebitAccountID NVARCHAR(50),   
    @CreditAccountID NVARCHAR(50),      
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
    @S20ID VARCHAR(50),
	@VoucherID NVARCHAR(50),
	@TransactionID NVARCHAR(50),
	@IsTemp TINYINT,
	@IsGoodsFirstVoucher AS TINYINT
AS    
  
IF @KindVoucherID = 3 --- la xuat van chuyen noi bo  
BEGIN  
    EXEC AP0512_QC @DivisionID, @WareHouseID, @TranMonth, @TranYear, @InventoryID, @ConvertedAmount, @ActualQuantity, @DebitAccountID, @CreditAccountID, 11,
				@S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
				@S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID -- (1) la cap nhat tang, (0 ) la cap nhat giam  
    EXEC AP0512_QC @DivisionID, @WareHouseID2, @TranMonth, @TranYear, @InventoryID, @ConvertedAmount, @ActualQuantity, @DebitAccountID, @CreditAccountID, 10,
				@S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
				@S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID -- (1) la cap nhat tang, (0 ) la cap nhat giam    
END  
ELSE IF @KindVoucherID IN (1, 5, 7, 9, 15, 17) --- Nhap kho, dieu chinh tang : 1: nhap kho - 5: mua hang nhap kho - 7: hang ban tra lai nhap kho - 9: dieu chinh kiem ke kho tang - 15: nhap kho mua hang - 17: nhap kho xuat kho hang ban tra lai  
    EXEC AP0512_QC @DivisionID, @WareHouseID, @TranMonth, @TranYear, @InventoryID, @ConvertedAmount, @ActualQuantity, @DebitAccountID, @CreditAccountID, 1,
				@S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
				@S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID -- (1) la cap nhat tang, (0 ) la cap nhat giam  
ELSE IF @KindVoucherID IN (2, 4, 6, 8, 10, 14, 20) --- Xuat kho, dieu chinh giam: 2: Xuat kho - 4: ban hang xuat kho - 8: dieu chinh kiem ke kho giam -10: hang mua tra lai xuat kho -14: xuat kho ban hang -20: xuat kho nhap kho mua hang tra lai  
  EXEC AP0512_QC @DivisionID, @WareHouseID, @TranMonth, @TranYear, @InventoryID, @ConvertedAmount, @ActualQuantity, @DebitAccountID, @CreditAccountID, 0,
			  @S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
			  @S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID -- (1) la cap nhat tang, (0 ) la cap nhat giam  
IF @IsTemp = 0 AND ISNULL(@IsGoodsFirstVoucher, 0) = 0 AND @KindVoucherID <> 10 AND (@KindVoucherID <> 3 OR ( @KindVoucherID = 3 AND @DebitAccountID <> @CreditAccountID) )  
BEGIN	
		INSERT INTO [dbo].[AT8899]
				   ([DivisionID]
				   ,[TableID]
				   ,[VoucherID]
				   ,[TransactionID]
				   ,[S01ID], [S02ID], [S03ID], [S04ID], [S05ID], [S06ID], [S07ID], [S08ID], [S09ID], [S10ID]
				   ,[S11ID], [S12ID], [S13ID], [S14ID], [S15ID], [S16ID], [S17ID], [S18ID], [S19ID], [S20ID])
			 VALUES
				   (@DivisionID
				   ,'AT9000'
				   ,@VoucherID
				   ,@TransactionID
				   ,@S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
					@S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID 
				   )
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
