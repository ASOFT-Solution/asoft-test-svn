
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MP7721]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MP7721]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



----- Created by:  Vo Thanh Huong , date: 26/4/2006
----- purpose: Phan bo CP SXC cho TP theo PP dinh muc  & SPDD theo PP ULTD

/**********************************************
** Edited by: [GS] [Cẩm Loan] [03/08/2010]
***********************************************/

CREATE PROCEDURE  [dbo].[MP7721] 	@DivisionID as nvarchar(50), 
				 	@PeriodID  as nvarchar(50),  
					@TranMonth as int, 
					@TranYear as int, 
					@MaterialTypeID  as nvarchar(50),  
					@ApportionID  as nvarchar(50),
					@BeginMethodID int,
					@FromPeriodID nvarchar(50)	
AS
Declare @sSQL as nvarchar(4000),
		@ProductlD_cur as cursor,
		@SumConvertedAmount as Decimal(28,8),	
		@ConvertedAmount as decimal(28,8),
		@ProductConvertedAmount decimal(28,8),
		@AConvertedAmount decimal(28,8), 
		@EConvertedAmount decimal(28,8), 		
		@ProductConvertedUnit as decimal(28,8),
		@SumProductQuantity as Decimal(28,8),
		@SumProductConverted as Decimal(28,8),
	  	@ConvertedAmount1 as Decimal(28,8),
		@ListProduct_cur as cursor,
		@ProductID as nvarchar(50),
		@ProductQuantity as Decimal(28,8),
		@ProductQuantityUnit as Decimal(28,8),
		@UnitID as nvarchar(50),
		@ConvertedUnit as decimal(28,8),
		@ConvertedDecimal int,
		@ResultTypeID nvarchar(50),
		@PerfectRate decimal(28,8),
		@MaterialRate decimal(28,8),
		@HumanResourceRate decimal(28,8),
		@OthersRate decimal(28,8)

SET @ConvertedDecimal = (Select ConvertDecimal FROM MT0000 where DivisionID = @DivisionID)

---------------------------- Tong chi phi PS & DDDK  ---------------------------------
Set @ConvertedAmount = round((Select Sum(Case D_C when 'D' then Isnull(ConvertedAmount,0) else - Isnull(ConvertedAmount,0) end)  
			From MV9000 
			Where  DivisionID = @DivisionID and PeriodID = @PeriodID and
				ExpenseID ='COST003' and MaterialTypeID =@MaterialTypeID), @ConvertedDecimal)

IF @BeginMethodID = 1  --Chi phi DDDK cap nhat bang tay
	Set @ConvertedAmount = round( isnull(@ConvertedAmount, 0) + isnull((Select Sum( Isnull(ConvertedAmount,0))
			From MT1612 
			Where  DivisionID =@DivisionID and PeriodID = @PeriodID and
				ExpenseID ='COST003' and MaterialTypeID =@MaterialTypeID and Type = 'B'),0), @ConvertedDecimal)
ELSE  -- chi phi DDDK ke thua tu DDCK cua DTTHCP khac
	Set @ConvertedAmount = round( isnull(@ConvertedAmount, 0) + isnull((Select Sum( Isnull(ConvertedAmount,0))
			From MT0400
			Where  DivisionID =@DivisionID and PeriodID = @FromPeriodID and
				ExpenseID ='COST003' and MaterialTypeID =@MaterialTypeID and ResultTypeID = 'R03'),0), @ConvertedDecimal)


---------------------------------------------------------------------------------------------------
Set @AConvertedAmount = @ConvertedAmount
Set @SumProductConverted = (Select  Sum(Isnull(ConvertedUnit,0)*Isnull(MT4444.ProductQuantity,0)
					*case when MT4444.ResultTypeID = 'R01' then 1 else isnull(MT4444.HumanResourceRate,0)/100 end)
				From MT1603 inner join MT4444  on MT4444.ProductID = MT1603.ProductID 
				Where 	ApportionID = @ApportionID and 
					ExpenseID = 'COST003' and 
					MaterialTypeID = @MaterialTypeID)

Set @ProductlD_cur  = CURSOR  SCROLL  KEYSET  FOR 
		Select MT4444.ProductID ,  Isnull(ConvertedUnit,0)*Isnull(MT4444.ProductQuantity,0)
			*case when MT4444.ResultTypeID = 'R01' then 1 else isnull(MT4444.HumanResourceRate,0)/100 end,
			MT4444.ProductQuantity, AT1302.UnitID,
			MT4444.ResultTypeID, PerfectRate, MaterialRate, HumanResourceRate, OthersRate
		From MT4444 inner join MT1603 on MT4444.ProductID = MT1603.ProductID 
			inner join AT1302 on AT1302.InventoryID = MT4444.ProductID 
		Where 	ApportionID = @ApportionID and 
			ExpenseID = 'COST003' and 
			MaterialTypeID = @MaterialTypeID	
		Order by ResultTypeID desc,  MT4444.ProductID 

Open @ProductlD_cur 
FETCH NEXT FROM @ProductlD_cur INTO  @ProductID , @ProductConvertedUnit, @ProductQuantity, @UnitID,
					@ResultTypeID, @PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate	
WHILE @@Fetch_Status = 0
BEGIN
	IF @ConvertedAmount >0  and  Isnull(@SumProductConverted,0)<>0 and @ProductConvertedUnit<>0
	BEGIN			
		Set  @ProductConvertedAmount = round((Isnull(@ConvertedAmount,0)/@SumProductConverted)*Isnull(@ProductConvertedUnit,0),@ConvertedDecimal)

		If Isnull(@ProductQuantity,0)<>0 
			Set @ConvertedUnit = round(Isnull(@ProductConvertedAmount,0)/@ProductQuantity, @ConvertedDecimal)
		Else 
			Set @ConvertedUnit = 0
		IF @ResultTypeID = 'R03' 
			Insert MT0444 (ResultTypeID, ExpenseID, MaterialTypeID, ProductID,  
					ConvertedAmount,  ConvertedUnit,    
					InProcessQuantity, PerfectRate, MaterialRate, HumanResourceRate, OthersRate)
			Values (@ResultTypeID, 'COST003', @MaterialTypeID, @ProductID,  
					@ProductConvertedAmount ,  @ConvertedUnit,    					@ProductQuantity, @PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate)	
		ELSE
			Insert MT0444( ResultTypeID, ExpenseID,  MaterialTypeID, ProductID, 
				ConvertedAmount,  ConvertedUnit,    ProductQuantity)
			Values (@ResultTypeID,  'COST003',  @MaterialTypeID, @ProductID,
				 @ProductConvertedAmount ,  @ConvertedUnit,    @ProductQuantity)	
	END
FETCH NEXT FROM @ProductlD_cur INTO  @ProductID , @ProductConvertedUnit, @ProductQuantity, @UnitID,
					@ResultTypeID, @PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate	
END
Close @ProductlD_cur

-------------------------------------------- Xu ly lam tron ---------------------------------
Declare @ID as nvarchar(50),
	@Detal decimal(28,8)

Set @Detal = round(isnull(@AConvertedAmount,0), @ConvertedDecimal)  -  isnull((Select Sum(ConvertedAmount) From MT0444 
				    Where  MaterialTypeID = @MaterialtypeID ),0)
If @Detal<>0 
Begin
	------- Lam tron
	Set @ID = (Select top 1 ID
		From MT0444 Where ExpenseID ='COST003' and MaterialTypeID = @MaterialTypeID and ResultTypeID = 'R01'
		Order by ConvertedUnit Desc)
		
	IF  	@ID is  not null
		Update MT0444 Set ConvertedAmount = ConvertedAmount + @Detal,
				ConvertedUnit = round((ConvertedAmount + @Detal)/ProductQuantity, @ConvertedDecimal)   
			Where 	ID = @ID and
				MaterialTypeID = @MaterialTypeID and
				ExpenseID = 'COST003' and ResultTypeID = 'R01'
	ELSE
	BEGIN	
		Set @ID = (Select Top 1 ID From MT0444 
					Where ExpenseID ='COST003' and MaterialTypeID = @MaterialTypeID and ResultTypeID = 'R03'
					Order by ConvertedUnit Desc)
	
		IF @ID is not null
			Update MT0444 Set ConvertedAmount = ConvertedAmount + @Detal,
				ConvertedUnit = round((ConvertedAmount + @Detal)/InProcessQuantity, @ConvertedDecimal) 
			Where 	ID = @ID and
				MaterialTypeID = @MaterialTypeID and 
				ExpenseID = 'COST003' and ResultTypeID = 'R03'
	END
END
GO

