
/****** Object:  StoredProcedure [dbo].[MP7703]    Script Date: 12/16/2010 11:23:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


----- Created by: Vo Thanh Huong, date: 25/4/2006
---- Purpose: Phan bo SXC TP & SPDD theo PP  truc tiep

/**********************************************
** Edited by: [GS] [Cẩm Loan] [03/08/2010]
***********************************************/

ALTER Procedure [dbo].[MP7703] 	@DivisionID as nvarchar(50), 
				@PeriodID as nvarchar(50),
				@TranMonth as int,@TranYear as int,
				@MaterialTypeID as nvarchar(50) ,
				@BeginMethodID int,
				@FromPeriodID nvarchar(50)	

as 
Declare @sSQL as nvarchar(4000),
		@SumProductCovalues as nvarchar(50),	
		@ProductID as nvarchar(50),
		@ProductQuantity as Decimal(28,8),
		@ListProduct_cur cursor,
		@ProductCo as Decimal(28,8),		
		@SumProductCo decimal(28,8),
		@PConvertedAmount as Decimal(28,8),
		@ConvertedAmount as Decimal(28,8),
		@ConvertedUnit	 as Decimal(28,8),
		@ConvertedDecimal int,
		@ResultTypeID nvarchar(50),
		@ProductID_Old  nvarchar(50),
		@PerfectRate nvarchar(50),
		@MaterialRate nvarchar(50),
		@HumanResourceRate nvarchar(50),
		@OthersRate nvarchar(50)


Select  @ConvertedDecimal = ConvertDecimal, @ProductID_Old =''  From MT0000

Set @sSQL='
Select	DivisionID, ProductID, Sum( Case D_C  when ''D'' then Isnull(ConvertedAmount,0) else - Isnull(ConvertedAmount,0) end) as ConvertedAmount	
From MV9000  
WHere 	DivisionID =''' + @DivisionID+''' and
	PeriodID = ''' + @PeriodID+''' and
	ExpenseID  = ''COST003'' and
	isnull(ProductID, '''') <> ''''  and 
	MaterialTypeID =''' + @MaterialTypeID + ''' 
Group by DivisionID, ProductID
Union '

IF @BeginMethodID = 1  --Do dang dau ky cap nhat bang tay
Set @sSQL = @sSQL + 
	' Select  DivisionID, ProductID, Sum(isnull(ConvertedAmount, 0)) as ConvertedAmount	
	From MT1612
	WHere 	DivisionID = '''+@DivisionID + ''' and
		PeriodID = '''+@PeriodID + ''' and
		ExpenseID = ''COST003''  and
		isnull(ProductID,'''') <> ''''  and 
		MaterialTypeID  = ''' + @MaterialTypeID + '''  and 
		Type = ''B''
	GROUP BY DivisionID, ProductID'
ELSE  --DDDK ke thua tu DDCK cua DTTHCP khac
Set @sSQL = @sSQL + '
	Select DivisionID, ProductID, sum(isnull(ConvertedAmount,0)) as ConvertedAmount
	From MT0400
	Where  DivisionID = ''' + @DivisionID + ''' and PeriodID = ''' + @FromPeriodID + ''' and
		ExpenseID =''COST003'' and MaterialTypeID = ''' + @MaterialTypeID + ''' and ResultTypeID = ''R03''
	Group by 	DivisionID, ProductID'

 

If  exists (Select top 1 1 From SysObjects Where name = 'MV7401' and Xtype ='V')
	DROP VIEW MV7401

Exec ('Create view MV7401 as '+@sSQL)

Set @sSQL = '
Select DivisionID, ProductID, sum(ConvertedAmount) as ConvertedAmount 
From MV7401 
GROUP BY DivisionID, ProductID'

If  exists (Select top 1 1 From SysObjects Where name = 'MV7703' and Xtype ='V')
	DROP VIEW MV7703

Exec ('Create view MV7703 as ' + @sSQL)

Set @ListProduct_cur  = CURSOR SCROLL KEYSET FOR 
	Select   MT4444.ProductID,  MT4444.ProductQuantity, 
		round(MV5201.ConvertedAmount, @ConvertedDecimal), 
		ProductCo = isnull(MT4444.ProductQuantity,0),
		SumProductCo =isnull((Select sum(ProductQuantity) 
			From MT4444 Where ProductID = MV5201.ProductID),0),
		MT4444.ResultTypeID,PerfectRate, MaterialRate, HumanResourceRate, OthersRate
	From MV7703 MV5201  inner join MT4444  on MV5201.ProductID  =  MT4444.ProductID 
	Order by MT4444.ProductID, MT4444.ResultTypeID desc

Open @ListProduct_cur 
FETCH NEXT FROM @ListProduct_cur INTO    @ProductID, @ProductQuantity, @ConvertedAmount, @ProductCo, @SumProductCo,
				 @ResultTypeID, @PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate
WHILE @@Fetch_Status = 0
BEGIN
	Select	@PConvertedAmount = 0, @ConvertedUnit = 0
	IF @SumProductCo<>0 and @ProductCo <> 0
		IF @ResultTypeID = 'R03'
		BEGIN
			Set @PConvertedAmount = round(@ConvertedAmount/ @SumProductCo*@ProductCo, @ConvertedDecimal)
			Set @ConvertedUnit =  round(@PConvertedAmount/ @ProductQuantity, @ConvertedDecimal)
		
			Insert MT0444 (ResultTypeID, ExpenseID, MaterialTypeID, ProductID,  ConvertedAmount,  ConvertedUnit,    
					InProcessQuantity, PerfectRate, MaterialRate, HumanResourceRate, OthersRate)
			Values (@ResultTypeID, 'COST003', @MaterialTypeID, @ProductID,  @PConvertedAmount ,  @ConvertedUnit,    					@ProductQuantity, @PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate)	
		END	
		ELSE   IF @ResultTypeID = 'R01'
		BEGIN
			IF @ProductID_Old = @ProductID 
			BEGIN
			
				Set @PConvertedAmount = @ConvertedAmount - isnull((Select sum(ConvertedAmount)
									From MT0444 
									Where MaterialTypeID = @MaterialTypeID and 
									ProductID = @ProductID and ResultTypeID = 'R03'),0)	
				SET @ConvertedUnit = round(@PConvertedAmount/@ProductQuantity, @ConvertedDecimal)
			
			END
			ELSE 
				Select @PConvertedAmount = @ConvertedAmount, 
					@ConvertedUnit = round(@PConvertedAmount/@ProductQuantity, @ConvertedDecimal)			
			Insert MT0444 (ResultTypeID, 	ExpenseID, 	MaterialTypeID, 	ProductID,  
					ConvertedAmount,	ConvertedUnit,	ProductQuantity)
			Values (@ResultTypeID, 'COST003', 	@MaterialTypeID, 	@ProductID,  
					@PConvertedAmount , 	 @ConvertedUnit,    @ProductQuantity)			
		END
	Set @ProductID_Old = @ProductID							
	FETCH NEXT FROM @ListProduct_cur INTO    @ProductID, @ProductQuantity, @ConvertedAmount, @ProductCo, @SumProductCo,
				 @ResultTypeID, @PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate
END
CLOSE  @ListProduct_cur