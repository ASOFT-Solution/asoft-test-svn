
/****** Object:  StoredProcedure [dbo].[MP7741]    Script Date: 12/16/2010 11:42:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


--Created by: Vo Thanh Huong, date: 17/4/2006
--Purpose: Phan bo chi phi SXC theo luong  & SPDD theo PP ULTD

/**********************************************
** Edited by: [GS] [Cẩm Loan] [03/08/2010]
***********************************************/

ALTER PROCEDURE [dbo].[MP7741]  @DivisionID as nvarchar(50),
				 @PeriodID as nvarchar(50),
				 @TranMonth as int,
				 @TranYear as int,
				 @MaterialTypeID as nvarchar(50),
				@BeginMethodID int,
				@FromPeriodID nvarchar(50)	

As 
Declare @sSQL as nvarchar(4000),
	@SumProductCovalues as Decimal(28,8),
	@ProductCoValues as Decimal(28,8),
	@ConvertedUnit as  Decimal(28,8),
	@ConvertedAmount as decimal(28,8),
	@MaterialQuantity as Decimal(28,8),
	@ListProduct_cur as cursor,
	@ProductID as nvarchar(50),
	@ProductQuantity as Decimal(28,8),
	@UnitID as nvarchar(50),
	@ConvertedDecimal as tinyint,  	
	@ResultTypeID nvarchar(50),
	@PerfectRate decimal(28,8),
	@MaterialRate decimal(28,8),
	@HumanResourceRate decimal(28,8),
	@OthersRate decimal(28,8),
	@AConvertedAmount decimal(28,8),
	@PConvertedAmount decimal(28,8),
	@PMaterialQuantity decimal(28,8)

Set @ConvertedDecimal = (Select ConvertDecimal From MT0000)


---- Buoc 1. Xac dinh he so phan bo dua vao luong da phan bo
Set @sSQL ='
Select  MT0444.DivisionID, MT0444.ProductID, Sum(ConvertedUnit) as ConvertedUnit,
	MT4444.ProductQuantity,
	MT4444.UnitID,
	Sum(ConvertedUnit)*MT4444.ProductQuantity
	*case when MT4444.ResultTypeID = ''R01'' then 1 else isnull(MT4444.OthersRate,0)/100 end  as ProductCoValues,
	MT4444.ResultTypeID, MT4444.PerfectRate, MT4444.MaterialRate, MT4444.HumanResourceRate, MT4444.OthersRate 	
From MT0444  inner  join MT4444 on MT0444.ProductID = MT4444.ProductID  and MT0444.ResultTypeID = ''R01''
Where ExpenseID = ''COST002''  
Group by MT0444.DivisionID, MT0444.ProductID, MT4444.UnitID, MT4444.ProductQuantity,
	MT4444.ResultTypeID, MT4444.PerfectRate, MT4444.MaterialRate, MT4444.HumanResourceRate, MT4444.OthersRate 	 '

---- Tao view  he so chung can phan bo cho san pham
If  exists (Select top 1 1 From SysObjects Where name = 'MV7741' and Xtype ='V')
	DROP VIEW MV7741
Exec ('Create view MV7741 as '+@sSQL)

----- Tong chi phi
Set @ConvertedAmount = round ((Select Sum(Case D_C when 'D' then Isnull(ConvertedAmount,0) else - Isnull(ConvertedAmount,0) end)  
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

Set @AConvertedAmount = @ConvertedAmount
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
Set @SumProductCovalues = (Select Sum(isnull(ProductCovalues,0)) From MV7741)

Set @ListProduct_cur = CURSOR KEYSET FOR 
	Select 	ProductID, ProductQuantity, ProductCoValues, ResultTypeID,
		PerfectRate, MaterialRate, HumanResourceRate, OthersRate 
	From   MV7741	
	Order by ResultTypeID, ProductID

OPEN	@ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @ResultTypeID,
					@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate 
			
WHILE @@Fetch_Status = 0
BEGIN
	IF @SumProductCovalues >0 and  @ProductCoValues >0
	BEGIN
		Set  @PConvertedAmount = round(@ConvertedAmount/@SumProductCovalues*@ProductCoValues, @ConvertedDecimal)
		Set @ConvertedUnit = 	round(@PConvertedAmount/@ProductQuantity, @ConvertedDecimal)		
	IF @ResultTypeID = 'R03' 
		Insert MT0444 (ResultTypeID, ExpenseID, MaterialTypeID, ProductID, 
		    	ConvertedAmount,  ConvertedUnit,   InProcessQuantity, 
			PerfectRate, MaterialRate, HumanResourceRate, OthersRate )
		Values (@ResultTypeID, 'COST003', @MaterialTypeID, @ProductID,  	
			@PConvertedAmount ,  @ConvertedUnit,    @ProductQuantity, 
			@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate)								
	ELSE
		Insert MT0444 (ProductID,     MaterialUnitID, ExpenseID,  MaterialTypeID,   	
			ConvertedAmount,  ConvertedUnit,   ProductQuantity, ResultTypeID)
		Values (@ProductID,  @UnitID,   'COST003',    @MaterialTypeID,	@PConvertedAmount,
		    	@ConvertedUnit,  @ProductQuantity, @ResultTypeID)

	END
	FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @ResultTypeID,
						@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate 
END
Close @ListProduct_cur

-------------------------------------------- Xu ly lam tron
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