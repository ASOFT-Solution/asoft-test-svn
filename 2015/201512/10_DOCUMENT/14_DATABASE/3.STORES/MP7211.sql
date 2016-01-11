
/****** Object:  StoredProcedure [dbo].[MP7211]    Script Date: 12/16/2010 10:48:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


----- Created by: Vo Thanh Huong, date: 20/4/2006
---- Purpose: Phan bo chi phi Nhan cong theo PP he so & Cap nhat DDCK theo PP ULTD

/**********************************************
** Edited by: [GS] [Cẩm Loan] [03/08/2010]
***********************************************/


ALTER PROCEDURE [dbo].[MP7211]  @DivisionID as nvarchar(50), 
				@PeriodID as nvarchar(50),
				@TranMonth as int,@TranYear as int,
				@MaterialTypeID as nvarchar(50), 
				@CoefficientID as nvarchar(50) ,
				@BeginMethodID int,
				@FromPeriodID nvarchar(50)		
as 
Declare @sSQL as nvarchar(4000),
	@ListProduct_cur as Cursor,
	@ProductID as nvarchar(50),
	@ProductQuantity as Decimal(28,8),
	@ProductCo as Decimal(28,8),
	@ConvertedAmount as Decimal(28,8),
	@AConvertedAmount as Decimal(28,8),
	@SumProductCo Decimal(28,8),
	@ProductID_Old nvarchar(50),
	@ConvertedUnit	 as Decimal(28,8),
	@PConvertedAmount  as Decimal(28,8),
	@ConvertedDecimal int,  --- Bien lam tron,
	@ResultTypeID nvarchar(50),
	@PerfectRate decimal(28,8),
	@MaterialRate decimal(28,8),
	@HumanResourceRate decimal(28,8),
	@OthersRate decimal(28,8)

Select  @ConvertedDecimal  = ConvertDecimal From MT0000

-------Lay Bo HE SO
Set @sSQL='
Select MT1605.DivisionID,(Case  when MT1605.InventoryID is null then MT4444.ProductID 
	Else MT1605.InventoryID End) as ProductID ,
	isnull(CoValue,0) as  CoValue,
	Isnull(ProductQuantity,0) as ProductQuantity,
	CoValue*ProductQuantity
	*case when MT4444.ResultTypeID = ''R01'' then 1 else isnull(MT4444.HumanResourceRate/100,0) end as ProductCo,
	MT4444.ResultTypeID,
	PerfectRate, MaterialRate, HumanResourceRate, OthersRate 
From MT1605  inner  join MT4444 on MT4444.ProductID = MT1605.InventoryID
Where CoefficientID ='''+@CoefficientID + ''''

If  exists (Select top 1 1 From SysObjects Where name = 'MV7211' and Xtype ='V')
	DROP VIEW MV7211
Exec ('Create view MV7211 as '+@sSQL)

------Tong CPPS + CPDDDK
Set @ConvertedAmount =round(isnull((Select Sum(Case D_C when 'D' then Isnull(ConvertedAmount,0) else - Isnull(ConvertedAmount,0) end)  
			From MV9000
			 Where  DivisionID =@DivisionID and PeriodID = @PeriodID and
				ExpenseID ='COST002' and MaterialTypeID =@MaterialTypeID),0), @ConvertedDecimal)

--Lay DDDK
IF @BeginMethodID = 1-- Cap nhat bang tay
	Set @ConvertedAmount = round( isnull(@ConvertedAmount, 0) + isnull((Select Sum( Isnull(ConvertedAmount,0))
			From MT1612 
			Where  DivisionID =@DivisionID and PeriodID = @PeriodID and
				ExpenseID ='COST002' and MaterialTypeID =@MaterialTypeID and Type = 'B'),0), @ConvertedDecimal)
ELSE  --ke thua tu DDCK cua DTTHCP khac
	Set @ConvertedAmount = round( isnull(@ConvertedAmount, 0) + isnull((Select Sum( Isnull(ConvertedAmount,0))
			From MT0400
			Where  DivisionID =@DivisionID and PeriodID = @FromPeriodID and
				ExpenseID ='COST002' and MaterialTypeID =@MaterialTypeID and ResultTypeID = 'R03'),0), @ConvertedDecimal)

Set @AConvertedAmount = @ConvertedAmount

------TONG HE SO
Set @SumProductCo = (Select Sum(isnull(ProductCo,0)) From MV7211)

Set @ListProduct_cur = CURSOR SCROLL KEYSET FOR 
		Select 	ProductID, ProductQuantity, ProductCo,
			SumProductCo = isnull((Select sum(isnull(ProductCo,0)) From MV7211),0), 
 			ResultTypeID,	PerfectRate, MaterialRate, HumanResourceRate, OthersRate
		From MV7211
		Order by ProductID, ResultTypeID   desc

OPEN	@ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCo, @SumProductCo, @ResultTypeID, 
			@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate		
			
WHILE @@Fetch_Status = 0
	BEGIN		
	IF @ConvertedAmount >0 and isnull(@SumProductCo,0) <> 0 
	BEGIN	
		Set @PConvertedAmount = round(@ConvertedAmount/@SumProductCo*@ProductCo, @ConvertedDecimal)
		Set @ConvertedUnit = round(@PConvertedAmount/@ProductQuantity, @ConvertedDecimal)
		
		IF 	 @ResultTypeID = 'R03'
			Insert MT0444 (ResultTypeID, 	ExpenseID, 	MaterialTypeID, 		ProductID, 
					ConvertedAmount,  	ConvertedUnit,   	InProcessQuantity, 
					PerfectRate, 	MaterialRate, 	HumanResourceRate, 	OthersRate )
			Values (@ResultTypeID, 	'COST002', 	@MaterialTypeID, 	@ProductID,  	
					@PConvertedAmount , 	 @ConvertedUnit,    	@ProductQuantity, 					@PerfectRate, 		@MaterialRate, 		@HumanResourceRate, 	@OthersRate)										
		ELSE 	IF @ResultTypeID = 'R01' 
			Insert MT0444( ResultTypeID, ExpenseID,  MaterialTypeID, ProductID, 
					ConvertedAmount,  ConvertedUnit,    ProductQuantity)
				Values (@ResultTypeID,  'COST002',  @MaterialTypeID, @ProductID,
					 @PConvertedAmount ,  @ConvertedUnit,    @ProductQuantity)	
	END
	FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCo, @SumProductCo, @ResultTypeID, 
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
		From MT0444 Where ExpenseID ='COST002' and MaterialTypeID = @MaterialTypeID and ResultTypeID = 'R01'
		Order by ConvertedUnit Desc)
		
	IF  	@ID is  not null
		Update MT0444 Set ConvertedAmount = ConvertedAmount + @Detal,
				ConvertedUnit = round((ConvertedAmount + @Detal)/ProductQuantity, @ConvertedDecimal)   
			Where 	ID = @ID and
				MaterialTypeID = @MaterialTypeID and
				ExpenseID = 'COST002' and ResultTypeID = 'R01'
	ELSE
	BEGIN	
		Set @ID = (Select Top 1 ID From MT0444 
					Where ExpenseID ='COST002' and MaterialTypeID = @MaterialTypeID and ResultTypeID = 'R03'
					Order by ConvertedUnit Desc)
	
		IF @ID is not null
			Update MT0444 Set ConvertedAmount = ConvertedAmount + @Detal,
				ConvertedUnit = round((ConvertedAmount + @Detal)/InProcessQuantity, @ConvertedDecimal) 
			Where 	ID = @ID and
				MaterialTypeID = @MaterialTypeID and 
				ExpenseID = 'COST002' and ResultTypeID = 'R03'
	END
END