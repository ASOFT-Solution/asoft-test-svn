
/****** Object:  StoredProcedure [dbo].[MP7739]    Script Date: 12/16/2010 11:38:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by: Vo Thanh Huong, date: 20/4/2006
--Purpose: 	Phan bo chi phi SXC  theo NVL & SPDD khong phan bo chi phi

/**********************************************
** Edited by: [GS] [Cẩm Loan] [03/08/2010]
***********************************************/

ALTER PROCEDURE  [dbo].[MP7739] @DivisionID as nvarchar(50),
				 @PeriodID as nvarchar(50),
				 @TranMonth as int,
				 @TranYear as int, 
				 @MaterialTypeID as nvarchar(50)
AS
Declare 	@sSQL as nvarchar(4000),
		@SumProductCovalues as Decimal(28,8),
		@ProductCoValues as Decimal(28,8),
		@ConvertedUnit as Decimal(28,8),
		@ConvertedAmount as decimal(28,8),
		@AConvertedAmount decimal(28,8), 
		@ListProduct_cur as cursor,
		@ProductID as nvarchar(50),
		@ProductQuantity as Decimal(28,8),
		@UnitID as nvarchar(50),
		@ProductHumanRes as Decimal(28,8),
		@ProductHumanResUnit as Decimal(28,8),
		@ConvertedDecimal int,
		@ResultTypeID nvarchar(50),
		@PerfectRate decimal(28,8),
		@MaterialRate decimal(28,8),
		@HumanResourceRate  decimal(28,8),
		@OthersRate decimal(28,8)

Set @ConvertedDecimal = isnull((Select ConvertDecimal From MT0000),0)

---- Buoc 1. Xac dinh he so phan bo dua vao NVL da phan bo
Set @sSQL ='
Select  MT0444.DivisionID, MT0444.ProductID, Sum(ConvertedUnit) as ConvertedUnit,
	MT4444.ProductQuantity,
	MT4444.UnitID,
	Sum(ConvertedAmount) 	as ProductCoValues,	MT4444.ResultTypeID
From MT0444  inner  join MT4444 on MT0444.ProductID = MT4444.ProductID  and MT4444.ResultTypeID = MT0444.ResultTypeID
Where ExpenseID = ''COST001''   and MT0444.ResultTypeID = ''R01''
Group by MT0444.DivisionID, MT0444.ProductID, MT4444.UnitID, MT4444.ProductQuantity,	 MT4444.ResultTypeID'

---- Tao view he so chung can phan bo cho san pham
If  exists (Select top 1 1 From SysObjects Where Name = 'MV7739' and Xtype ='V')
	DROP VIEW MV7739

Exec ('Create view MV7739 as '+@sSQL)

------ Tong chi phi
Set @ConvertedAmount = round ((Select Sum(Case D_C when 'D' then Isnull(ConvertedAmount,0) else - Isnull(ConvertedAmount,0) end)  
			From MV9000 
			Where  DivisionID = @DivisionID and PeriodID = @PeriodID and
				ExpenseID ='COST003' and MaterialTypeID =@MaterialTypeID), @ConvertedDecimal)

Set @ConvertedAmount = round( isnull(@ConvertedAmount, 0) + isnull((Select Sum( Isnull(ConvertedAmount,0))
			From MT1612 
			Where  DivisionID =@DivisionID and PeriodID = @PeriodID and
				ExpenseID ='COST003' and MaterialTypeID =@MaterialTypeID and Type = 'B'),0), @ConvertedDecimal)

Set @AConvertedAmount = @ConvertedAmount
Set @SumProductCovalues = isnull((Select Sum(isnull(ProductCovalues,0)) From MV7739),0)

Set @ListProduct_cur = Cursor Scroll KeySet FOR 
	Select 	ProductID, ProductQuantity, isnull(ProductCoValues,0), ResultTypeID
	From  MV7739
	Order by  ResultTypeID desc, ProductID

OPEN	@ListProduct_cur
	FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @ResultTypeID

WHILE @@Fetch_Status = 0
BEGIN
	Select  @ProductHumanRes = 0 , @ProductHumanResUnit = 0
	IF @ConvertedAmount >0 and  Isnull(@SumProductCoValues,0) <> 0 and Isnull(@ProductCoValues,0) <> 0
	BEGIN
		Set @ProductHumanRes = Round(((Isnull(@ConvertedAmount,0)/@SumProductCovalues)*Isnull(@ProductCoValues,0)), @ConvertedDecimal)
		Set @ProductHumanResUnit = round(@ProductHumanRes/@ProductQuantity, @ConvertedDecimal)		
 
		Insert MT0444 (ResultTypeID, ProductID, ExpenseID, MaterialTypeID, ConvertedAmount, ConvertedUnit, ProductQuantity)
		Values (@ResultTypeID, @ProductID,   'COST003',  @MaterialTypeID, @ProductHumanRes,@ProductHumanResUnit, 
			@ProductQuantity)
	END		

	FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @ResultTypeID

END
Close @ListProduct_cur

-------------------------------------------- Xu ly lam tron
Declare @ID as nvarchar(50),
	@Detal decimal(28,8)

Set @Detal = round(isnull(@AConvertedAmount,0), @ConvertedDecimal)  -  isnull((Select Sum(ConvertedAmount) From MT0444 
			    Where  MaterialTypeID = @MaterialtypeID ),0)
If @Detal<>0 
Begin
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