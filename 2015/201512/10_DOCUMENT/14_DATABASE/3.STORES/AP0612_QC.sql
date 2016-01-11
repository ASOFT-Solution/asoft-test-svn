/****** Object:  StoredProcedure [dbo].[AP0612_QC]    Script Date: 04/11/2015 ******/
IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0612_QC]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0612_QC]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by Tiểu Mai on 04/11/2015
----- Purpose: Cập nhật số dư khi quản lý mặt hàng theo quy cách.

CREATE  PROCEDURE [dbo].[AP0612_QC]
	 @DivisionID nvarchar(50), 
	@WareHouseID  nvarchar(50),
	 @TranMonth  int, 
	@TranYear int, 
	@InventoryID  nvarchar(50), 
	@ConvertedAmount as Decimal(28,8), 
	@ConvertedQuantity as Decimal(28,8), 
	@DebitAccountID  nvarchar(50), 
	@CreditAccountID  nvarchar(50), 
	@Type as TINYINT, -- (1) la cap nhat tang,(0 ) la cap nhat giam
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

 AS

If @Type =1	 --- Cap nhat tang (Inserted)
	BEGIN
		If not exists (Select 1 From AT2008_QC 	Where 	InventoryID = @InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID =@DebitAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear AND 
								ISNULL(S01ID,'') = Isnull(@S01ID,'') AND 
								ISNULL(S02ID,'') = isnull(@S02ID,'') AND
								ISNULL(S03ID,'') = isnull(@S03ID,'') AND
								ISNULL(S04ID,'') = isnull(@S04ID,'') AND
								ISNULL(S05ID,'') = isnull(@S05ID,'') AND 
								ISNULL(S06ID,'') = isnull(@S06ID,'') AND
								ISNULL(S07ID,'') = isnull(@S07ID,'') AND
								ISNULL(S08ID,'') = isnull(@S08ID,'') AND
								ISNULL(S09ID,'') = isnull(@S09ID,'') AND
								ISNULL(S10ID,'') = isnull(@S10ID,'') AND
								ISNULL(S11ID,'') = isnull(@S11ID,'') AND 
								ISNULL(S12ID,'') = isnull(@S12ID,'') AND
								ISNULL(S13ID,'') = isnull(@S13ID,'') AND
								ISNULL(S14ID,'') = isnull(@S14ID,'') AND
								ISNULL(S15ID,'') = isnull(@S15ID,'') AND
								ISNULL(S16ID,'') = isnull(@S16ID,'') AND
								ISNULL(S17ID,'') = isnull(@S17ID,'') AND
								ISNULL(S18ID,'') = isnull(@S18ID,'') AND
								ISNULL(S19ID,'') = isnull(@S19ID,'') AND
								ISNULL(S20ID,'') = isnull(@S20ID,''))
			Insert AT2008_QC (InventoryID, WareHouseID,TranMonth,TranYear, DivisionID,
					  InventoryAccountID,   BeginQuantity,  BeginAmount,
					 DebitQuantity ,  DebitAmount , CreditQuantity ,
					CreditAmount,  EndQuantity ,  EndAmount, S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
		S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID)
			Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
				@DebitAccountID, @ConvertedQuantity, @ConvertedAmount , 0,0, 0,0, 
				@ConvertedQuantity, @ConvertedAmount, @S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
        @S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID)
		else
			Update AT2008_QC
				Set	BeginQuantity 	=	Isnull(BeginQuantity,0)	+ isnull(@ConvertedQuantity,0),
					BeginAmount 	=	Isnull(BeginAmount,0)	+ isnull(@ConvertedAmount,0),
					EndQuantity		=	Isnull(EndQuantity,0)		+ Isnull(@ConvertedQuantity,0),
					EndAmount		=	Isnull(EndAmount,0)		+Isnull(@ConvertedAmount,0)	
			Where 		InventoryID =@InventoryID and
					DivisionID =@DivisionID and
					WareHouseID =@WareHouseID and
					InventoryAccountID =@DebitAccountID and
					TranMonth =@TranMonth and
					TranYear =@TranYear AND 
					ISNULL(S01ID,'') = Isnull(@S01ID,'') AND 
					ISNULL(S02ID,'') = isnull(@S02ID,'') AND
					ISNULL(S03ID,'') = isnull(@S03ID,'') AND
					ISNULL(S04ID,'') = isnull(@S04ID,'') AND
					ISNULL(S05ID,'') = isnull(@S05ID,'') AND 
					ISNULL(S06ID,'') = isnull(@S06ID,'') AND
					ISNULL(S07ID,'') = isnull(@S07ID,'') AND
					ISNULL(S08ID,'') = isnull(@S08ID,'') AND
					ISNULL(S09ID,'') = isnull(@S09ID,'') AND
					ISNULL(S10ID,'') = isnull(@S10ID,'') AND
					ISNULL(S11ID,'') = isnull(@S11ID,'') AND 
					ISNULL(S12ID,'') = isnull(@S12ID,'') AND
					ISNULL(S13ID,'') = isnull(@S13ID,'') AND
					ISNULL(S14ID,'') = isnull(@S14ID,'') AND
					ISNULL(S15ID,'') = isnull(@S15ID,'') AND
					ISNULL(S16ID,'') = isnull(@S16ID,'') AND
					ISNULL(S17ID,'') = isnull(@S17ID,'') AND
					ISNULL(S18ID,'') = isnull(@S18ID,'') AND
					ISNULL(S19ID,'') = isnull(@S19ID,'') AND
					ISNULL(S20ID,'') = isnull(@S20ID,'')
	END				

Else  		--- Cap nhat giam (Deleted)
	BEGIN
		If not exists (Select 1 From AT2008_QC Where 	InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID =@DebitAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear AND 
								ISNULL(S01ID,'') = Isnull(@S01ID,'') AND 
								ISNULL(S02ID,'') = isnull(@S02ID,'') AND
								ISNULL(S03ID,'') = isnull(@S03ID,'') AND
								ISNULL(S04ID,'') = isnull(@S04ID,'') AND
								ISNULL(S05ID,'') = isnull(@S05ID,'') AND 
								ISNULL(S06ID,'') = isnull(@S06ID,'') AND
								ISNULL(S07ID,'') = isnull(@S07ID,'') AND
								ISNULL(S08ID,'') = isnull(@S08ID,'') AND
								ISNULL(S09ID,'') = isnull(@S09ID,'') AND
								ISNULL(S10ID,'') = isnull(@S10ID,'') AND
								ISNULL(S11ID,'') = isnull(@S11ID,'') AND 
								ISNULL(S12ID,'') = isnull(@S12ID,'') AND
								ISNULL(S13ID,'') = isnull(@S13ID,'') AND
								ISNULL(S14ID,'') = isnull(@S14ID,'') AND
								ISNULL(S15ID,'') = isnull(@S15ID,'') AND
								ISNULL(S16ID,'') = isnull(@S16ID,'') AND
								ISNULL(S17ID,'') = isnull(@S17ID,'') AND
								ISNULL(S18ID,'') = isnull(@S18ID,'') AND
								ISNULL(S19ID,'') = isnull(@S19ID,'') AND
								ISNULL(S20ID,'') = isnull(@S20ID,''))
			Insert AT2008_QC (InventoryID, WareHouseID,TranMonth,TranYear, DivisionID,
					  InventoryAccountID,   BeginQuantity,  BeginAmount,
					 DebitQuantity,  DebitAmount,  CreditQuantity,
					CreditAmount,   EndQuantity , EndAmount, S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
		S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID)
			Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
				@DebitAccountID, -@ConvertedQuantity, -@ConvertedAmount, 0,0, 0,0,  
				-@ConvertedQuantity, -@ConvertedAmount, @S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
        @S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID)
		else
			Update AT2008_QC
				set 	BeginQuantity	 	=	Isnull(BeginQuantity,0)		- Isnull(@ConvertedQuantity,0),
					BeginAmount 		=	Isnull(BeginAmount,0)		- Isnull(@ConvertedAmount,0),
					EndQuantity		=	Isnull(EndQuantity,0)		- Isnull(@ConvertedQuantity,0),
					EndAmount		= 	Isnull(EndAmount,0)	- 	Isnull(@ConvertedAmount,0)	
			Where 		InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID  =@DebitAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear AND 
								ISNULL(S01ID,'') = Isnull(@S01ID,'') AND 
								ISNULL(S02ID,'') = isnull(@S02ID,'') AND
								ISNULL(S03ID,'') = isnull(@S03ID,'') AND
								ISNULL(S04ID,'') = isnull(@S04ID,'') AND
								ISNULL(S05ID,'') = isnull(@S05ID,'') AND 
								ISNULL(S06ID,'') = isnull(@S06ID,'') AND
								ISNULL(S07ID,'') = isnull(@S07ID,'') AND
								ISNULL(S08ID,'') = isnull(@S08ID,'') AND
								ISNULL(S09ID,'') = isnull(@S09ID,'') AND
								ISNULL(S10ID,'') = isnull(@S10ID,'') AND
								ISNULL(S11ID,'') = isnull(@S11ID,'') AND 
								ISNULL(S12ID,'') = isnull(@S12ID,'') AND
								ISNULL(S13ID,'') = isnull(@S13ID,'') AND
								ISNULL(S14ID,'') = isnull(@S14ID,'') AND
								ISNULL(S15ID,'') = isnull(@S15ID,'') AND
								ISNULL(S16ID,'') = isnull(@S16ID,'') AND
								ISNULL(S17ID,'') = isnull(@S17ID,'') AND
								ISNULL(S18ID,'') = isnull(@S18ID,'') AND
								ISNULL(S19ID,'') = isnull(@S19ID,'') AND
								ISNULL(S20ID,'') = isnull(@S20ID,'')
	END
GO
