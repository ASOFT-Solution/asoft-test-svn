
/****** Object:  StoredProcedure [dbo].[MP7123]    Script Date: 12/16/2010 14:20:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



----- Created by: Vo Thanh Huong, date: 25/4/2006
----- Purpose:  Phan bo Chi phi NVL TP & SPDD theo  dinh muc 

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP7123] 	@DivisionID as nvarchar(50), 
				 	@PeriodID  as nvarchar(50),  
					@TranMonth as int, 
					@TranYear as int, 
					@MaterialTypeID  as nvarchar(50),  
					@ApportionID  as nvarchar(50),
					@BeginMethodID int,
					@FromPeriodID nvarchar(50)		
AS
Declare @sSQL as nvarchar(4000),
	@ListMaterial_cur as cursor,
	@MaterialID as nvarchar(50),
	@ConvertedAmount Decimal(28,8),
	@MaterialQuantity as Decimal(28,8),
	@SumMaterialQuantity as Decimal(28,8),
	@SumConvertedAmount as Decimal(28,8),
	@ProductID as nvarchar(50),
	@ProductQuantity as Decimal(28,8),
	@ProductQuantityUnit as Decimal(28,8),
	@QuantityUnit as Decimal(28,8),
	@ConvertedUnit as Decimal(28,8),
	@ConvertedDecimal int, 
	@QuantityDecimal int,
	@PerfectRate decimal (28, 8),
	@MaterialRate decimal (28, 8),
	@HumanResourceRate decimal (28, 8),
	@OthersRate decimal (28, 8),
	@ResultTypeID nvarchar(50),	
	@MaterialUnitID nvarchar(50),
	@ProductCo decimal(28,8),
	@SumProductCo decimal(28,8)


Select @ConvertedDecimal = ConvertDecimal,  @QuantityDecimal = QuantityDecimal
	From MT0000
	
---- Buoc 1:  Lay tong chi phi theo tung nguyen vat lieu & DDDK
Set @sSQL='
Select DivisionID, InventoryID as MaterialID , 
	Sum( Case D_C  when  ''D'' then isnull(Quantity,0) else - isnull(Quantity,0) end) as MaterialQuantity,
	Sum( Case D_C  when  ''D'' then   Isnull(ConvertedAmount,0) else - Isnull(ConvertedAmount,0) end) as ConvertedAmount	
From MV9000 
Where 	PeriodID = ''' + @PeriodID + ''' and
	DivisionID = ''' + @DivisionID + ''' and
	ExpenseID =''COST001'' and
	MaterialTypeID =''' + @MaterialTypeID + '''  
Group by DivisionID,InventoryID 
Union '

IF @BeginMethodID = 1   ---Chi phi do dang dau ky  cap nhat bang tay
	Set @sSQL = @sSQL + ' 
	Select DivisionID,MaterialID, sum(isnull(WipQuantity, 0)),  Sum(isnull(ConvertedAmount,0)) 
	From MT1612
	Where DivisionID = ''' + @DivisionID + ''' and
		PeriodID = ''' +  @PeriodID  + ''' and
		ExpenseID = ''COST001'' and
		MaterialTypeID = ''' +  @MaterialTypeID + ''' and 
		Type = ''B''	
	GROUP BY DivisionID,MaterialID'

ELSE  ---Chi phi do dang dau ky ke thua tu DDCK cua  doi tuong khac
	Set @sSQL = @sSQL + ' 
	Select  DivisionID,MaterialID ,
		Sum(isnull(MaterialQuantity,0)) as MaterialQuantity,
		Sum(isnull(ConvertedAmount, 0)) as ConvertedAmount	
	From MT0400
	WHere 	DivisionID ='''+@DivisionID+''' and
		PeriodID = '''+@FromPeriodID+''' and
		ExpenseID =''COST001'' and
		isnull(ProductID,'''')<>''''  and 
		MaterialTypeID  = ''' + @MaterialTypeID + '''  and 
		ResultTypeID= ''R03''
	Group by DivisionID,MaterialID'

If  exists (Select top 1 1 From SysObjects Where name = 'MV7315' and Xtype ='V')
	DROP VIEW MV7315
Exec ('Create view MV7315  as '+@sSQL)

Set @sSQL = '
Select 	DivisionID,MaterialID,  Sum(isnull(MaterialQuantity,0)) as MaterialQuantity,	
	Sum(isnull(ConvertedAmount,0)) as ConvertedAmount
	From MV7315 MV6113
	GROUP BY DivisionID,MaterialID'

If  exists (Select top 1 1 From SysObjects Where name = 'MV7316' and Xtype ='V')
	DROP VIEW MV7316
Exec ('Create view MV7316 as '+@sSQL)

----Buoc 2:   lay he so quy doi cho cac nguyen vat lieu
Set @sSQL='
Select MT4444.DivisionID,MT4444.ProductID, MT1603.MaterialID, MT1603.QuantityUnit , MT1603.ConvertedUnit, MT4444.ProductQuantity,
	MT1603.UnitID,
	round(isnull(MT1603.QuantityUnit,0)*MT4444.ProductQuantity, ' + cast(ISNULL(@QuantityDecimal, 0) as nvarchar(10)) + ')  as ProductQuantityUnit,
	round(isnull(MT1603.ConvertedUnit,0)*MT4444.ProductQuantity, ' + cast(ISNULL(@ConvertedDecimal, 0) as nvarchar(10)) + ')  as ProductConvertedUnit,
	ResultTypeID,	PerfectRate, MaterialRate, HumanResourceRate, OthersRate
From  MT4444  inner  join MT1603 on MT4444.ProductID = MT1603.ProductID  
Where  MT1603.ApportionID = ''' + @ApportionID + ''' and 
	MT1603.ExpenseID =''COST001'' and MT1603.MaterialID in (Select MaterialID     From MV7316)'	

If  exists (Select top 1 1 From SysObjects Where name = 'MV7123' and XType ='V')
	DROP VIEW MV7123
Exec ('Create view MV7123  as '+@sSQL)

Set @ListMaterial_cur = Cursor Scroll KeySet FOR 
		Select 	MV7121.ProductID, MV7121.MaterialID, MV7121.ProductQuantity,  AT1302.UnitID as MaterialUnitID,
			MV7121.ProductQuantityUnit,
			SumProductQuantity = (Select sum(isnull(ProductQuantityUnit,0)) From MV7121 M00
				Where MaterialID = MV7121.MaterialID),	
			MV7316.MaterialQuantity, MV7316.ConvertedAmount,
			ResultTypeID,	PerfectRate, MaterialRate, HumanResourceRate, OthersRate
		From MV7123 MV7121 left join AT1302 on AT1302.InventoryID = MV7121.MaterialID
			inner join MV7316 on MV7316.MaterialID = MV7121.MaterialID
		 	
OPEN	@ListMaterial_cur
FETCH NEXT FROM @ListMaterial_cur INTO  @ProductID, @MaterialID, @ProductQuantity, @MaterialUnitID, 
	@ProductCo, @SumProductCo, 	@SumMaterialQuantity, @SumConvertedAmount,
	@ResultTypeID,	 @PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate

WHILE  @@FETCH_STATUS = 0
BEGIN	   			
	Select @ConvertedAmount = 0, @MaterialQuantity = 0, @ConvertedUnit = 0, @QuantityUnit = 0
	IF (@SumConvertedAmount >0 or @SumMaterialQuantity > 0) and 	@SumProductCo <>0 and @ProductCo  <> 0
		Select @ConvertedAmount = round(@SumConvertedAmount/@SumProductCo*@ProductCo, @ConvertedDecimal),
			@MaterialQuantity = round(@SumMaterialQuantity/@SumProductCo*@ProductCo, @QuantityDecimal)

		Select   @ConvertedUnit = round(@ConvertedAmount/@ProductQuantity, @ConvertedDecimal),
			@QuantityUnit = round(@MaterialQuantity/@ProductQuantity, @QuantityDecimal)

	IF @ResultTypeID  = 'R03'
		Insert MT0444 (ResultTypeID, ExpenseID, MaterialTypeID, 
			MaterialID, MaterialUnitID, ProductID, MaterialQuantity,  QuantityUnit,   
		    	ConvertedAmount,  ConvertedUnit,   InProcessQuantity, 
			PerfectRate, MaterialRate, HumanResourceRate, OthersRate )
		Values (@ResultTypeID, 'COST001', @MaterialTypeID, 
			@MaterialID, @MaterialUnitID, @ProductID, @MaterialQuantity ,  @QuantityUnit,  
		    	@ConvertedAmount ,  @ConvertedUnit,    @ProductQuantity, 
			@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate)								
	ELSE
		Insert MT0444(ResultTypeID, ExpenseID,  MaterialTypeID, MaterialID, MaterialUnitID, ProductID,  
			MaterialQuantity,  QuantityUnit,   ConvertedAmount,  ConvertedUnit,    ProductQuantity)
		Values (@ResultTypeID,  'COST001',  @MaterialTypeID, @MaterialID,@MaterialUnitID, @ProductID,
			@MaterialQuantity,  @QuantityUnit,   @ConvertedAmount ,  @ConvertedUnit,    @ProductQuantity)	

	FETCH NEXT FROM @ListMaterial_cur INTO  @ProductID, @MaterialID, @ProductQuantity, @MaterialUnitID, 
		@ProductCo, @SumProductCo, 	@SumMaterialQuantity, @SumConvertedAmount,
		@ResultTypeID,	 @PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate

END		
Close @ListMaterial_cur

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Xu ly lam tron
Declare @Detal_ConvertedAmount as decimal(28, 8),
	@Detal_MaterialQuantity  as decimal(28, 8),
	@ID nvarchar(50)

----------------------Lay tong so da phan bo
Set @ListMaterial_cur  = Cursor Scroll KeySet FOR 
		Select MaterialID, sum(isnull(MaterialQuantity,0)),  sum(isnull(ConvertedAmount,0))
		From MT0444 Where MaterialTypeID = @MaterialTypeID 
		GROUP BY  MaterialID

		Open @ListMaterial_cur 
		FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount
		WHILE @@Fetch_Status = 0
			Begin
				Select @Detal_ConvertedAmount =0, @Detal_MaterialQuantity = 0 
				----tri gia da tap hop 						
				Set  @Detal_ConvertedAmount = isnull((Select ConvertedAmount From MV7316
							Where 	MaterialID = @MaterialID),0)  - @ConvertedAmount
				
				Set  @Detal_MaterialQuantity = isnull((Select MaterialQuantity From MV7316
						Where   MaterialID = @MaterialID),0)   - @MaterialQuantity
				
				If @Detal_ConvertedAmount <>0
					Begin
						Set @ID = null
						Select  top 1 @ID = ID
						From MT0444  
						Where MaterialTypeID = @MaterialTypeID and ExpenseID = 'COST001' and
							isnull(MaterialID,'') = @MaterialID  and ResultTypeID= 'R01'						
						Order by  ConvertedUnit Desc
						
						IF @ID is not  null
							Update MT0444  Set ConvertedAmount = ConvertedAmount + @Detal_ConvertedAmount,
									@ConvertedUnit = round( (ConvertedAmount + @Detal_ConvertedAmount)/ProductQuantity, @ConvertedDecimal)	 
							Where ID = @ID 
						ELSE
						BEGIN
							Select  top 1 @ID = ID
							From MT0444  
							Where MaterialTypeID = @MaterialTypeID and ExpenseID = 'COST001' and
								isnull(MaterialID,'') = @MaterialID  and ResultTypeID= 'R03'
							Order by  ConvertedUnit Desc
	
							IF @ID is not null
								Update MT0444  
									Set ConvertedAmount = ConvertedAmount + @Detal_ConvertedAmount,
										 @ConvertedUnit = round( (ConvertedAmount + @Detal_ConvertedAmount)/InProcessQuantity, @ConvertedDecimal)	 
									Where  ID = @ID 
						END
						
					End
			
				If @Detal_MaterialQuantity <>0
					Begin
						Set @ID = null
						Set @ID = (Select top 1  ID  From MT0444 
								Where MaterialTypeID =@MaterialTypeID and ExpenseID = 'COST001' and 
									isnull(MaterialID,'') = @MaterialID  and ResultTypeID = 'R01'
								Order by  QuantityUnit Desc )

						IF @ID is not null
							Update MT0444  Set MaterialQuantity = MaterialQuantity + @Detal_MaterialQuantity,
									QuantityUnit = round(( MaterialQuantity + @Detal_MaterialQuantity)/ProductQuantity, @QuantityDecimal)
							Where  ID = @ID 
						ELSE 
						BEGIN
							Select  top 1 @ID = ID
							From MT0444  
							Where MaterialTypeID = @MaterialTypeID and ExpenseID = 'COST001' and
								isnull(MaterialID,'') = @MaterialID  and ResultTypeID= 'R03'
							Order by  QuantityUnit Desc
							
							IF @ID is not null	
								Update MT0444  Set MaterialQuantity = MaterialQuantity + @Detal_MaterialQuantity,
									QuantityUnit = round(( MaterialQuantity + @Detal_MaterialQuantity)/InProcessQuantity, @QuantityDecimal)
								Where  ID = @ID 
						END	
					End
				FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount
			End	
Close @ListMaterial_cur