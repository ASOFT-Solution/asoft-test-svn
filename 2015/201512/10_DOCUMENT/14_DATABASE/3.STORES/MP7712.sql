
/****** Object:  StoredProcedure [dbo].[MP7712]    Script Date: 12/16/2010 11:30:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



----- 	Created by: Vo Thanh Huong ,date: 11/4/2006
---- 	Purpose: Phan bo chi phi SXC  theo PP he so, DDCK theo PP dinh muc

/**********************************************
** Edited by: [GS] [Cẩm Loan] [03/08/2010]
***********************************************/

ALTER Procedure [dbo].[MP7712]	@DivisionID as nvarchar(50), 
				@PeriodID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@MaterialTypeID as nvarchar(50), 
				@CoefficientID as nvarchar(50), 
				@EndApportionID as nvarchar(50)	,
				@BeginMethodID int,
				@FromPeriodID nvarchar(50)			 
AS 
Declare @sSQL as nvarchar(4000),
	@SumProductCovalues Decimal(28,8),
	@ListProduct_cur as Cursor,
	@ProductID as nvarchar(50),
	@ProductCovalues as Decimal(28,8),
	@ConvertedAmount as Decimal(28,8),
	@ConvertedUnit	 as Decimal(28,8),
	@ConvertedAmount1 as Decimal(28,8),
	@ConvertedDecimal as int,
	@ProductQuantity decimal(28,8),
	@ProductConvertedAmount Decimal(28,8), 
	@AConvertedAmount decimal(28,8),
	@SumConvertedAmount decimal(28,8),
	@EConvertedAmount decimal(28,8),
	@ResultTypeID nvarchar(50),
	@PerfectRate decimal(28,8), 
	@MaterialRate decimal(28,8), 
	@HumanResourceRate decimal(28,8), 
	@OthersRate decimal(28,8),
	@PConvertedAmount Decimal(28,8),
	@ProductConvertedUnit decimal(28,8)

Select  @ConvertedDecimal =  ConvertDecimal
From MT0000

/* ---- */
Set @ConvertedDecimal = isnull(@ConvertedDecimal,0)
/* ---- */

--------------------------------------Tong CPPS + CPDDDK ---------------------------
Set @ConvertedAmount =round(isnull((Select Sum(Case D_C when 'D' then Isnull(ConvertedAmount,0) else - Isnull(ConvertedAmount,0) end)  
			From MV9000
			 Where  DivisionID =@DivisionID and PeriodID = @PeriodID and
				ExpenseID ='COST003' and MaterialTypeID =@MaterialTypeID),0), @ConvertedDecimal)

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
------------------------------PHAN BO SPDD THEO DINH MUC -----------------------
----Lay bo dinh muc SPDD
Set @sSQL='
Select MT4444.DivisionID, MT4444.ProductID, MT1603.ConvertedUnit, MT4444.ProductQuantity,
	round(isnull(MT1603.ConvertedUnit,0)*MT4444.ProductQuantity, ' + cast(@ConvertedDecimal as varchar(10)) + ')  as ProductConvertedAmount,
	MT4444.ResultTypeID,	PerfectRate, MaterialRate, HumanResourceRate, OthersRate
From  MT4444  inner  join MT1603 on MT4444.ProductID = MT1603.ProductID   and MT4444.ResultTypeID = ''R03'' 
Where  MT1603.ApportionID = ''' + @EndApportionID + ''' and 
	MT1603.MaterialTypeID = ''' + @MaterialTypeID + ''''	

If  exists (Select top 1 1 From SysObjects Where name = 'MV7412' and Xtype ='V')
	DROP VIEW MV7412
Exec ('Create view MV7412  as '+@sSQL)

Set @EConvertedAmount =  (Select sum(isnull(ProductConvertedAmount,0)) From MV7412)

IF   	(@EConvertedAmount <= @ConvertedAmount)		
	Set @ListProduct_cur = CURSOR SCROLL KEYSET FOR
		Select ProductID,  ProductQuantity, ProductConvertedAmount,
			ResultTypeID,	PerfectRate, MaterialRate, HumanResourceRate, OthersRate		
		From MV7412
		Where ProductConvertedAmount <> 0
		Order by ProductID
ELSE ------Neu chi phi dinh muc lon hon so phat sinh thuc te thi lay chi phi thuc te phan bo theo dinh muc 
	Set @ListProduct_cur = CURSOR SCROLL KEYSET FOR
		Select ProductID,  ProductQuantity, 
			round(ProductConvertedAmount*@ConvertedAmount/@EConvertedAmount, @ConvertedDecimal),
			ResultTypeID,	PerfectRate, MaterialRate, HumanResourceRate, OthersRate		
		From MV7412 
		Where ProductConvertedAmount <> 0
		Order by ProductID

OPEN @ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO @ProductID,  @ProductQuantity,@ProductConvertedAmount,
		@ResultTypeID,	@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate

WHILE @@FETCH_STATUS = 0 
BEGIN				
	Select  @ConvertedUnit = round(@ProductConvertedAmount/@ProductQuantity,@ConvertedDecimal)
	Insert MT0444 (ResultTypeID, ExpenseID, MaterialTypeID, ProductID, 
	    	ConvertedAmount,  ConvertedUnit,   InProcessQuantity, 
		PerfectRate, MaterialRate, HumanResourceRate, OthersRate )
	Values (@ResultTypeID, 'COST003', @MaterialTypeID,  @ProductID, 
	    	@ProductConvertedAmount ,  @ConvertedUnit,    @ProductQuantity, 
		@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate)	

	FETCH NEXT FROM @ListProduct_cur INTO @ProductID,  @ProductQuantity,@ProductConvertedAmount,
		@ResultTypeID,	@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate
END


------------------------------------PHAN BO TP THEO HE SO -------------------------
IF @EConvertedAmount < @ConvertedAmount
BEGIN
----Lay he so TP
Set @sSQL='
Select MT1605.DivisionID, MT4444.ProductID ,
	isnull(CoValue,0) as  CoValue,
	Isnull(ProductQuantity,0) as ProductQuantity,
	isnull(CoValue,0)*isnull(ProductQuantity,0)   as ProductCoValues,
	MT4444.ResultTypeID, MT4444.PerfectRate, MT4444.MaterialRate, MT4444.HumanResourceRate, MT4444.OthersRate
From MT1605  inner join MT4444   on MT4444.ProductID = MT1605.InventoryID  and MT4444.ResultTypeID=''R01''
Where  MT1605.CoefficientID =''' + @CoefficientID+ '''' 

If  exists (Select top 1 1 From SysObjects Where name = 'MV7712' and Xtype ='V')
	DROP VIEW MV7712
Exec ('Create view MV7712 as '+@sSQL)

------   	 Xac dinh tong he so chung
Set @SumProductCovalues = (Select Sum(isnull(ProductCovalues,0)) From MV7712 )
Set @ConvertedAmount = @ConvertedAmount -  isnull((Select sum(isnull(ConvertedAmount,0)) 
					From MT0444 
					Where MaterialTypeID = @MaterialTypeID and 
						ResultTypeID = 'R03'),0)
Set @ListProduct_cur = Cursor Scroll KeySet FOR 
	Select 	ProductID, isnull(ProductQuantity,0), isnull(ProductCoValues,0) , ResultTypeID
	From MV7712 MV5102	
	
OPEN	@ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @ResultTypeID

WHILE  @@FETCH_STATUS = 0
	BEGIN
		IF 	 Isnull(@SumProductCovalues,0) <> 0 and  Isnull(@ProductQuantity,0)<>0	
		BEGIN
			Set @PConvertedAmount = round(@ConvertedAmount/@SumProductCovalues*@ProductCoValues, @ConvertedDecimal)
			Set  @ConvertedUnit = round(@PConvertedAmount/ @ProductQuantity, @ConvertedDecimal)
			Insert MT0444( ResultTypeID, ExpenseID,  MaterialTypeID,  ProductID,  
					 ConvertedAmount,  ConvertedUnit,    ProductQuantity)
				Values (@ResultTypeID,  'COST003',  @MaterialTypeID, @ProductID,  
					 @PConvertedAmount ,  @ConvertedUnit,    @ProductQuantity)	

		END			
		FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @ResultTypeID
END
END



------------------------ Xu ly lam tron --------------------
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
