
/****** Object:  StoredProcedure [dbo].[MP7109]    Script Date: 12/16/2010 14:11:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



--- Created by: Vo Thanh Huong, date: 19/4/2006
---- Purpose: Phan bo chi phi NVL theo PP truc tiep, DDCK khong phan bo

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER Procedure [dbo].[MP7109] 	@DivisionID as nvarchar(50), 
				@PeriodID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@MaterialTypeID as nvarchar(50),
				@BeginMethodID int,
				@FromPeriodID nvarchar(50)		 				
AS
Declare @sSQL as nvarchar(4000),	
	@ProductID as nvarchar(50),
	@ProductQuantity as Decimal(28,8),
	@ProductCovalues as Decimal(28,8),
	@ListMaterial_cur as Cursor,
	@MaterialID as nvarchar(50),
	@MaterialQuantity as Decimal(28,8),
	@ConvertedAmount as Decimal(28,8),
	@QuantityUnit as Decimal(28,8),
	@ConvertedUnit	 as Decimal(28,8),
	@ProductUnitID nvarchar(50),	
	@ConvertDecimal int,
	@QuantityDecimal int,	
	@ResultTypeID nvarchar(50),
	@PerfectRate decimal (28, 8),
	@MaterialRate decimal (28, 8),
	@HumanResourceRate decimal (28, 8),
	@OthersRate decimal (28, 8),
	@MaterialUnitID nvarchar(50),
	@SumProductCo decimal(28,8),
	@ProductCo decimal(28,8),
	@ProductID_Old nvarchar(50),
	@MaterialID_Old  nvarchar(50)

Select  @ConvertDecimal =  ConvertDecimal,  @QuantityDecimal = QuantityDecimal, @ProductID_Old = '',	@MaterialID_Old    = ''
From MT0000

--- Chi phi phat sinh trong ky & Chi phi do dang dau ky
Set @sSQL='
Select   DivisionID, ProductID,  InventoryID  as MaterialID , 
	Sum( Case D_C  when ''D'' then Isnull(Quantity,0) else -Isnull(Quantity,0) end ) as MaterialQuantity,
	Sum( Case D_C  when ''D'' then   Isnull(ConvertedAmount,0) else - Isnull(ConvertedAmount,0) end) as ConvertedAmount	
From MV9000 
WHere 	DivisionID ='''+@DivisionID+''' and
	PeriodID = '''+@PeriodID+''' and
	ExpenseID =''COST001'' and
	isnull(ProductID,'''')<>''''  and 
	MaterialTypeID ='''+@MaterialTypeID+''' 
Group by DivisionID, InventoryID, ProductID  
Union  '

IF @BeginMethodID = 1   --Chi phi dau ky cap nhat bang tay
	Set @sSQL = @sSQL + ' 
		Select  DivisionID, ProductID, MaterialID ,
		Sum(isnull(WipQuantity,0)) as MaterialQuantity,
		Sum(isnull(ConvertedAmount, 0)) as ConvertedAmount	
	From MT1612
	WHere 	DivisionID ='''+@DivisionID+''' and
		PeriodID = '''+@PeriodID+''' and
		ExpenseID =''COST001'' and
		isnull(ProductID,'''')<>''''  and 
		MaterialTypeID  = ''' + @MaterialTypeID + '''  and 
		Type = ''B''
	Group by DivisionID, MaterialID, ProductID  '
ELSE ---Chi phi dau ky ke thua tu DDCK cua doi tuong khac
	Set @sSQL = @sSQL + ' 
	Select  DivisionID, ProductID, MaterialID ,
		Sum(isnull(MaterialQuantity,0)) as MaterialQuantity,
		Sum(isnull(ConvertedAmount, 0)) as ConvertedAmount	
	From MT0400
	WHere 	DivisionID ='''+@DivisionID+''' and
		PeriodID = '''+@FromPeriodID+''' and
		ExpenseID =''COST001'' and
		isnull(ProductID,'''')<>''''  and 
		MaterialTypeID  = ''' + @MaterialTypeID + '''  and 
		ResultTypeID= ''R03''
	Group by DivisionID, MaterialID, ProductID'

If  exists (Select top 1 1 From SysObjects Where name = 'MV7311' and Xtype ='V')
	DROP VIEW MV7311

Exec ('Create view MV7311   as '+@sSQL)


Set @sSQL = '
Select 	DivisionID,	ProductID, 
		MaterialID, 
		sum(isnull(MaterialQuantity, 0)) as MaterialQuantity, 
		sum(isnull(ConvertedAmount,0)) as ConvertedAmount
From MV7311
Group by DivisionID, ProductID, MaterialID '

If  exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV7109')
	DROP VIEW MV7109	
	
Exec ('Create view MV7109 as '+@sSQL)

Set @ListMaterial_cur  = Cursor Scroll KeySet FOR 
		Select MV5101.MaterialID , round(MV5101.MaterialQuantity, @QuantityDecimal), 
			round(MV5101.ConvertedAmount,@ConvertDecimal),
			MV5101.ProductID , MT4444.ProductQuantity,MT4444.UnitID, MT4444.ResultTypeID,
			MT4444.PerfectRate, MT4444.MaterialRate, MT4444.HumanResourceRate, MT4444.OthersRate, AT1302.UnitID	
		From MT4444 INNER  join MV7109 MV5101 on MV5101.ProductID  = MT4444.ProductID --AND MT4444.ResultTypeID = 'R01'
			left join AT1302 on MV5101.MaterialID = AT1302.InventoryID 
		Where   round(MV5101.MaterialQuantity, @QuantityDecimal) + round(MV5101.ConvertedAmount,@ConvertDecimal) <>0
		Order by   MV5101.ProductID, MV5101.MaterialID, ResultTypeID

Open @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount ,
		@ProductID, @ProductQuantity , @ProductUnitID, @ResultTypeID,
		@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate, @MaterialUnitID

WHILE @@Fetch_Status = 0
BEGIN	
	IF @ResultTypeID = 'R01'
	BEGIN
	IF isnull(@ProductQuantity,0) <> 0	
		Select  @ConvertedUnit =  round(@ConvertedAmount/@ProductQuantity, @ConvertDecimal),
			@QuantityUnit = round(@MaterialQuantity/@ProductQuantity, @QuantityDecimal) 
	ELSE
		Select  @ConvertedUnit = 0,	@QuantityUnit = 0

	Insert MT0444 (ResultTypeID, ExpenseID, MaterialTypeID, MaterialID, ProductID,  MaterialQuantity,  QuantityUnit,   
	    	ConvertedAmount,  ConvertedUnit,  ProductQuantity, MaterialUnitID)
	Values (@ResultTypeID, 'COST001', @MaterialTypeID, @MaterialID, @ProductID,  @MaterialQuantity ,  @QuantityUnit, 					    	
		@ConvertedAmount ,  @ConvertedUnit,    @ProductQuantity, @MaterialUnitID)
	END 
	ELSE  IF @ResultTypeID = 'R03' and ( @ProductID_Old <> @ProductID or @MaterialID_Old <> @MaterialID  )
	BEGIN
		IF isnull(@ProductQuantity,0) <> 0	
			Select  @ConvertedUnit =  round(@ConvertedAmount/@ProductQuantity, @ConvertDecimal),
			@QuantityUnit = round(@MaterialQuantity/@ProductQuantity, @QuantityDecimal) 

		Insert MT0444 (ResultTypeID, ExpenseID, MaterialTypeID, MaterialID, ProductID,  MaterialQuantity,  QuantityUnit,   
		    	ConvertedAmount,  ConvertedUnit,  InProcessQuantity, MaterialUnitID, 
			MaterialRate, PerfectRate, HumanResourceRate, OthersRate)
		Values (@ResultTypeID, 'COST001', @MaterialTypeID, @MaterialID, @ProductID,  @MaterialQuantity ,  @QuantityUnit, 					    	
			@ConvertedAmount ,  @ConvertedUnit,    @ProductQuantity, @MaterialUnitID,
			@MaterialRate, @PerfectRate, @HumanResourceRate, @OthersRate)
	END
		Select  @ProductID_Old = @ProductID,	@MaterialID_Old = @MaterialID

	FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount ,
		@ProductID, @ProductQuantity , @ProductUnitID, @ResultTypeID,
		@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate, @MaterialUnitID
END
Close @ListMaterial_cur