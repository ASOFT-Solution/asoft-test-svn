IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0138]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0138]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




----- Created by Tiểu Mai on 03/12/2015
----- Purpose: Kế thừa bộ định mức theo quy cách



CREATE PROCEDURE [dbo].[MP0138] 	
					@DivisionID as nvarchar(50), 
					@FromApportionID nvarchar(50), 		--- Bo dinh muc duoc ke thua
					@NewApportionID  as nvarchar(50) 	--- Luu vao bo dinh muc moi

 AS
Declare @App_MT36Cur CURSOR, 
	@ProductID VARCHAR(50),
	@UnitID VARCHAR(50),
	@ProductQuantity DECIMAL(28,8),
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
	@Parameter01 NVARCHAR(250),
	@Parameter02 NVARCHAR(250),
	@Parameter03 NVARCHAR(250),
	@ReTransactionID VARCHAR(50),
	@Orders INT,
	@InheritTransactionID NVARCHAR(50),
	@App_MT37Cur CURSOR,
	@MaterialID VARCHAR(50),
	@MaterialUnitID VARCHAR(50),
	@MaterialQuantity DECIMAL(28,8),
	@DS01ID VARCHAR(50),
	@DS02ID VARCHAR(50),
	@DS03ID VARCHAR(50),
	@DS04ID VARCHAR(50),
	@DS05ID VARCHAR(50),
	@DS06ID VARCHAR(50),
	@DS07ID VARCHAR(50),
	@DS08ID VARCHAR(50),
	@DS09ID VARCHAR(50),
	@DS10ID VARCHAR(50),
	@DS11ID VARCHAR(50),
	@DS12ID VARCHAR(50),
	@DS13ID VARCHAR(50),
	@DS14ID VARCHAR(50),
	@DS15ID VARCHAR(50),
	@DS16ID VARCHAR(50),
	@DS17ID VARCHAR(50),
	@DS18ID VARCHAR(50),
	@DS19ID VARCHAR(50),
	@DS20ID VARCHAR(50),
	@DParameter01 NVARCHAR(250),
	@DParameter02 NVARCHAR(250),
	@DParameter03 NVARCHAR(250),
	@MaterialTypeID VARCHAR(50),
	@Rate DECIMAL(28,8),
	@RateDecimalApp DECIMAL(28,8),
	@ExpenseID VARCHAR(50),
	@MaterialPrice DECIMAL(28,8),
	@MaterialAmount DECIMAL(28,8),
	@QuantityUnit DECIMAL(28,8),
	@ConvertedUnit DECIMAL(28,8),
	@IsExtraMaterial TINYINT,
	@MaterialGroupID DECIMAL(28,8),
	@WasteID VARCHAR(50),
	@RateWastage DECIMAL(28,8),
	@Description NVARCHAR(250),
	@Orders01 INT
	

SET @App_MT36Cur = Cursor Scroll KeySet FOR 

Select ProductID,UnitID,ProductQuantity,S01ID,S02ID,S03ID,S04ID,S05ID,S06ID,S07ID,S08ID,S09ID,S10ID,
		S11ID,S12ID,S13ID,S14ID,S15ID,S16ID,S17ID,S18ID,S19ID,S20ID,Parameter01,Parameter02,Parameter03, Orders, TransactionID
From MT0136
Where ApportionID =   @FromApportionID
		and DivisionID = @DivisionID


			
OPEN @App_MT36Cur

FETCH NEXT FROM @App_MT36Cur INTO  @ProductID,@UnitID,@ProductQuantity,@S01ID,@S02ID,@S03ID,@S04ID,@S05ID,@S06ID,@S07ID,@S08ID,@S09ID,@S10ID,
	@S11ID,@S12ID,@S13ID,@S14ID,@S15ID,@S16ID,@S17ID,@S18ID,@S19ID,@S20ID,@Parameter01,@Parameter02,@Parameter03, @Orders, @InheritTransactionID
WHILE @@Fetch_Status = 0
	BEGIN
		SET @ReTransactionID = NEWID()
		INSERT INTO MT0136(DivisionID,TransactionID,ApportionID,ProductID,UnitID,ProductQuantity,S01ID,S02ID,S03ID,S04ID,S05ID,S06ID,
			S07ID,S08ID,S09ID,S10ID,S11ID,S12ID,S13ID,S14ID,S15ID,S16ID,S17ID,S18ID,S19ID,S20ID,Parameter01,Parameter02,Parameter03, Orders)
		VALUES(@DivisionID,@ReTransactionID,@NewApportionID,@ProductID,@UnitID,@ProductQuantity,@S01ID,@S02ID,@S03ID,@S04ID,@S05ID,@S06ID,
			@S07ID,@S08ID,@S09ID,@S10ID,@S11ID,@S12ID,@S13ID,@S14ID,@S15ID,@S16ID,@S17ID,@S18ID,@S19ID,@S20ID,@Parameter01,@Parameter02,@Parameter03, @Orders)	
		
		SET @App_MT37Cur = Cursor Scroll KeySet FOR 
		SELECT M37.MaterialID, M37.MaterialUnitID, M37.MaterialTypeID, M37.Rate, M37.ExpenseID, M37.MaterialQuantity,M37.MaterialPrice,
		M37.MaterialAmount,M37.QuantityUnit,M37.ConvertedUnit, M37.IsExtraMaterial, M37.MaterialGroupID, M37.RateWastage,M37.WasteID, 
		M37.[Description], M37.DParameter01, M37.DParameter02, M37.DParameter03, M37.DS01ID, M37.DS02ID, M37.DS03ID, M37.DS04ID,
		DS05ID, M37.DS06ID, M37.DS07ID, M37.DS08ID, M37.DS09ID, M37.DS10ID, M37.DS11ID, M37.DS12ID, M37.DS13ID, 
		M37.DS14ID, M37.DS15ID, M37.DS16ID, M37.DS17ID, M37.DS18ID, M37.DS19ID, M37.DS20ID, M37.DParameter01, M37.DParameter02, M37.DParameter03, M37.Orders, M37.RateDecimalApp
		FROM MT0137 M37
		LEFT JOIN MT0136 M36 ON M36.DivisionID = M37.DivisionID AND M36.ProductID = M37.ProductID AND M36.TransactionID = M37.ReTransactionID
		WHERE M37.DivisionID = @DivisionID  
		AND M36.ApportionID = @FromApportionID
		AND M37.ReTransactionID = @InheritTransactionID		

		OPEN @App_MT37Cur
		FETCH NEXT FROM @App_MT37Cur INTO @MaterialID, @MaterialUnitID, @MaterialTypeID, @Rate, @ExpenseID, @MaterialQuantity,@MaterialPrice,
					@MaterialAmount, @QuantityUnit, @ConvertedUnit, @IsExtraMaterial, @MaterialGroupID, @RateWastage, @WasteID,
					@Description, @DParameter01, @DParameter02, @DParameter03, @DS01ID, @DS02ID, @DS03ID, @DS04ID, 
					@DS05ID, @DS06ID, @DS07ID, @DS08ID, @DS09ID, @DS10ID, @DS11ID, @DS12ID, @DS13ID, 
					@DS14ID, @DS15ID, @DS16ID, @DS17ID, @DS18ID, @DS19ID, @DS20ID,@DParameter01, @DParameter02, @DParameter03, @Orders01, @RateDecimalApp
		WHILE @@Fetch_Status = 0
			Begin

				INSERT INTO MT0137(DivisionID,TransactionID,ProductID,ReTransactionID,MaterialID,MaterialUnitID, MaterialTypeID,
				Rate,ExpenseID, MaterialQuantity, MaterialPrice, MaterialAmount, QuantityUnit, ConvertedUnit, IsExtraMaterial,
				MaterialGroupID, WasteID, RateWastage, [Description],DS01ID ,DS02ID,DS03ID,DS04ID,DS05ID,DS06ID,
				DS07ID,DS08ID,DS09ID,DS10ID,DS11ID,DS12ID,DS13ID,DS14ID,DS15ID,DS16ID,DS17ID,DS18ID,DS19ID,DS20ID,DParameter01,DParameter02,DParameter03, Orders, RateDecimalApp)
				
				VALUES(@DivisionID,NEWID(),@ProductID,@ReTransactionID, @MaterialID,@MaterialUnitID, @MaterialTypeID,
				@Rate, @ExpenseID, @MaterialQuantity, @MaterialPrice, @MaterialAmount,@QuantityUnit, @ConvertedUnit, @IsExtraMaterial,
				@MaterialGroupID, @WasteID, @RateWastage, @Description, @DS01ID,@DS02ID,@DS03ID,@DS04ID,@DS05ID,@DS06ID,
				@DS07ID,@DS08ID,@DS09ID,@DS10ID,@DS11ID,@DS12ID,@DS13ID,@DS14ID,@DS15ID,@DS16ID,@DS17ID,@DS18ID,@DS19ID,@DS20ID,@Parameter01,@Parameter02,@Parameter03, @Orders01, @RateDecimalApp)		

				FETCH NEXT FROM @App_MT37Cur INTO @MaterialID, @MaterialUnitID, @MaterialTypeID, @Rate, @ExpenseID, @MaterialQuantity,@MaterialPrice,
				@MaterialAmount, @QuantityUnit, @ConvertedUnit, @IsExtraMaterial, @MaterialGroupID, @RateWastage, @WasteID,
				@Description, @Parameter01, @Parameter02, @Parameter03, @DS01ID, @DS02ID, @DS03ID, @DS04ID, @DS05ID, @DS06ID, @DS07ID,
				@DS08ID, @DS09ID, @DS10ID, @DS11ID, @DS12ID, @DS13ID, @DS14ID, @DS15ID, @DS16ID, @DS17ID, @DS18ID, @DS19ID, @DS20ID,@DParameter01, @DParameter02, @DParameter03, @Orders01, @RateDecimalApp
			End
		CLOSE @App_MT37Cur
		
		
		FETCH NEXT FROM @App_MT36Cur INTO  @ProductID,@UnitID,@ProductQuantity,@S01ID,@S02ID,@S03ID,@S04ID,@S05ID,@S06ID,@S07ID,@S08ID,@S09ID,@S10ID,
			@S11ID,@S12ID,@S13ID,@S14ID,@S15ID,@S16ID,@S17ID,@S18ID,@S19ID,@S20ID,@Parameter01,@Parameter02,@Parameter03, @Orders, @InheritTransactionID
	END
DEALLOCATE @App_MT37Cur	
CLOSE @App_MT36Cur
DEALLOCATE @App_MT36Cur


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
