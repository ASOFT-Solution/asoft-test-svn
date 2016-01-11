
/****** Object:  StoredProcedure [dbo].[MP7209]    Script Date: 12/16/2010 10:44:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


----- Created by: Vo Thanh Huong, date: 13/4/2006
---- Purpose: Phan bo nhan cong theo PP  truc tiep & DDCK khong phan  bo chi phi

/**********************************************
** Edited by: [GS] [Cẩm Loan] [03/08/2010]
***********************************************/


ALTER Procedure [dbo].[MP7209] 	@DivisionID as nvarchar(50), 
				@PeriodID as nvarchar(50),
				@TranMonth as int,@TranYear as int,
				@MaterialTypeID as nvarchar(50),
				@BeginMethodID int,
				@FromPeriodID nvarchar(50)		 
as 
Declare @sSQL as nvarchar(4000),
		@SumProductCovalues as nvarchar(50),	
		@ProductID as nvarchar(50),
		@ProductQuantity as Decimal(28,8),
		@ListProduct_cur cursor,
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
	ExpenseID  = ''COST002'' and
	isnull(ProductID, '''') <> ''''  and 
	MaterialTypeID =''' + @MaterialTypeID + ''' 
Group by DivisionID,ProductID
Union '

IF @BeginMethodID = 1  --Do dang dau ky cap nhat bang tay
Set @sSQL = @sSQL + 
	' Select  DivisionID,ProductID, Sum(isnull(ConvertedAmount, 0)) as ConvertedAmount	
	From MT1612
	WHere 	DivisionID = '''+@DivisionID + ''' and
		PeriodID = '''+@PeriodID + ''' and
		ExpenseID = ''COST002''  and
		isnull(ProductID,'''') <> ''''  and 
		MaterialTypeID  = ''' + @MaterialTypeID + '''  and 
		Type = ''B''
	GROUP BY DivisionID,ProductID'
ELSE  --DDDK ke thua tu DDCK cua DTTHCP khac
Set @sSQL = @sSQL + '
	Select DivisionID,ProductID, sum(isnull(ConvertedAmount,0)) as ConvertedAmount
	From MT0400
	Where  DivisionID = ''' + @DivisionID + ''' and PeriodID = ''' + @FromPeriodID + ''' and
		ExpenseID =''COST002'' and MaterialTypeID = ''' + @MaterialTypeID + ''' and ResultTypeID = ''R03''
	Group by 	DivisionID,ProductID'

If  exists (Select top 1 1 From SysObjects Where name = 'MV7401' and Xtype ='V')
	DROP VIEW MV7401

Exec ('Create view MV7401 as '+@sSQL)

Set @sSQL = '
Select DivisionID,ProductID, sum(ConvertedAmount) as ConvertedAmount 
	From MV7401 
	GROUP BY DivisionID,ProductID'

If  exists (Select top 1 1 From SysObjects Where name = 'MV7209' and Xtype ='V')
	DROP VIEW MV7209

Exec ('Create view MV7209 as ' + @sSQL)

Set @ListProduct_cur  = CURSOR SCROLL KEYSET FOR 
	Select   MT4444.ProductID,  MT4444.ProductQuantity, 
		round(MV5201.ConvertedAmount, @ConvertedDecimal), 		
		MT4444.ResultTypeID,PerfectRate, MaterialRate, HumanResourceRate, OthersRate
	From MV7209  MV5201  inner join MT4444  on MV5201.ProductID  =  MT4444.ProductID 
	Order by MT4444.ProductID, MT4444.ResultTypeID

Open @ListProduct_cur 
FETCH NEXT FROM @ListProduct_cur INTO    @ProductID, @ProductQuantity, @ConvertedAmount, 
				 @ResultTypeID, @PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate
WHILE @@Fetch_Status = 0
BEGIN
	IF @ResultTypeID = 'R01'
	BEGIN
		Set @ConvertedUnit =  round(@ConvertedAmount/ @ProductQuantity, @ConvertedDecimal)

		Insert MT0444 (ResultTypeID, 	ExpenseID, 	MaterialTypeID, 	ProductID,  
			ConvertedAmount,	ConvertedUnit,	ProductQuantity)
		Values (@ResultTypeID, 'COST002', 	@MaterialTypeID, 	@ProductID,  
			@ConvertedAmount , 	 @ConvertedUnit,    @ProductQuantity)
	END	
	ELSE   IF @ResultTypeID = 'R03'
	BEGIN
		IF @ProductID_Old <> @ProductID 
		BEGIN			
			Set @ConvertedUnit =  round(@ConvertedAmount/ @ProductQuantity, @ConvertedDecimal)
			
			Insert MT0444 (ResultTypeID, ExpenseID, MaterialTypeID, ProductID,  ConvertedAmount,  ConvertedUnit,    
				InProcessQuantity, PerfectRate, MaterialRate, HumanResourceRate, OthersRate)
			Values (@ResultTypeID, 'COST002', @MaterialTypeID, @ProductID,  @ConvertedAmount ,  @ConvertedUnit,    				@ProductQuantity, @PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate)	
		END						
	END

	Set @ProductID_Old = @ProductID								
	FETCH NEXT FROM @ListProduct_cur INTO    @ProductID, @ProductQuantity, @ConvertedAmount, 
				 @ResultTypeID, @PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate
END
CLOSE  @ListProduct_cur