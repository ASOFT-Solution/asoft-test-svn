IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0522]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP0522]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Created by Nguyen Quoc Huy
--Date: 24/11/2006
---- Modified on 17/01/2012 by Le Thi Thu Hien : WHERE them DivisionID
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[MP0522] 
			@RePlanDetailID nvarchar(50),
			@DivisionID nvarchar(50), 
			@PlanID nvarchar(50), 		@TranYear int, 
			@TranMonth int,   				
			@InventoryID nvarchar(50), 	@UnitID nvarchar(50),  
			@ApportionID nvarchar(50),
			@PlanQuantity decimal (28,8), 			
			@Notes nvarchar(250),		@LinkNo nvarchar(50),	 		
			@DepartmentID nvarchar(50),	@LevelID nvarchar(50), 
			@WorkID nvarchar(50),		@RefInfor nvarchar(250),
			@BeginDate datetime,
			@IsApportionID tinyint  --1 theo bo dinh muc Asoft-T
						--2 theo bo dinh muc Asoft-M


AS
DECLARE	@MT1603_Cur as cursor,	
		@AT1326_Cur as cursor,
		@Tmp_InventoryID as nvarchar(50),
		@Tmp_UnitID as nvarchar(50),
		@Tmp_Quantity as decimal (28,8),
		@Tmp_PlanDetailID as nvarchar(50),
		@Orders as INT
		
Set @Orders = 1
----------------------Su dung bo ben Asoft-M-------------------------
If @IsApportionID = 2
  BEGIN
	Set @MT1603_Cur = CURSOR SCROLL KEYSET FOR
		SELECT	MaterialID, MaterialUnitID, QuantityUnit
		FROM	MT1603 
		INNER JOIN AT1302 on AT1302.InventoryID = MT1603.MaterialID AND AT1302.DivisionID = MT1603.DivisionID
		WHERE	ExpenseID = 'COST001' 
				AND ApportionID = @ApportionID
				AND ProductID = @InventoryID
				AND AT1302.DivisionID = @DivisionID
	
	OPEN @MT1603_Cur
	FETCH NEXT FROM @MT1603_Cur INTO @Tmp_InventoryID, @Tmp_UnitID, @Tmp_Quantity

	WHILE @@FETCH_STATUS = 0
	  Begin
		EXEC AP0000 @Tmp_PlanDetailID OUTPUT, 'MT2016', 'MA', @TranYear, '', 16, 3, 0, ''
		INSERT INTO MT2016 	(PlanDetailID, PlanID, RePlanDetailID, DivisionID, TranMonth, TranYear, 
					InventoryID, UnitID, PlanQuantity, LinkNo, Notes, 
					RefInfor, BeginDate, DepartmentID, LevelID, WorkID, Orders )

			VALUES	 (@Tmp_PlanDetailID, @PlanID, @RePlanDetailID, @DivisionID, @TranYear, @TranMonth,   				
					@Tmp_InventoryID, @Tmp_UnitID, @Tmp_Quantity*@PlanQuantity, @LinkNo, @Notes,
					@RefInfor, @BeginDate, @DepartmentID, @LevelID, @WorkID, @Orders)
										
		Set @Orders = @Orders + 1
		FETCH NEXT FROM @MT1603_Cur INTO @Tmp_InventoryID, @Tmp_UnitID, @Tmp_Quantity
	  End
	CLOSE @MT1603_Cur
  END

Else
----------------------Su dung bo ben Asoft-T-------------------------
  BEGIN
	Set @AT1326_Cur = CURSOR SCROLL KEYSET FOR
		SELECT	ItemID, ItemUnitID, ItemQuantity/InventoryQuantity
		FROM	AT1326 
		INNER JOIN AT1302 on AT1302.InventoryID = AT1326.ItemID AND AT1302.DivisionID = AT1326.DivisionID
		Where	AT1326.KITID = @ApportionID
				AND AT1326.InventoryID = @InventoryID
				AND AT1302.DivisionID = @DivisionID
	
	OPEN @AT1326_Cur
	FETCH NEXT FROM @AT1326_Cur INTO @Tmp_InventoryID, @Tmp_UnitID, @Tmp_Quantity

	WHILE @@FETCH_STATUS = 0
	  Begin
		EXEC AP0000 @Tmp_PlanDetailID OUTPUT, 'MT2016', 'MA', @TranYear, '', 16, 3, 0, ''
		INSERT INTO MT2016 	(PlanDetailID, PlanID, RePlanDetailID, DivisionID, TranMonth, TranYear, 
					InventoryID, UnitID, PlanQuantity, LinkNo, Notes, 
					RefInfor, BeginDate, DepartmentID, LevelID, WorkID, Orders )

			VALUES	 (@Tmp_PlanDetailID, @PlanID, @RePlanDetailID, @DivisionID, @TranYear, @TranMonth,   				
					@Tmp_InventoryID, @Tmp_UnitID, @Tmp_Quantity*@PlanQuantity,@LinkNo, @Notes,
					@RefInfor, @BeginDate, @DepartmentID, @LevelID, @WorkID, @Orders)

		Set @Orders = @Orders + 1

		FETCH NEXT FROM @AT1326_Cur INTO @Tmp_InventoryID, @Tmp_UnitID, @Tmp_Quantity
	  End
	CLOSE @AT1326_Cur
  END



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

