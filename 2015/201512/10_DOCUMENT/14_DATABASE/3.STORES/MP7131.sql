
/****** Object:  StoredProcedure [dbo].[MP7131]    Script Date: 12/16/2010 14:26:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


--Created by: Vo Thanh Huong, date: 17/4/2006
--purpose: Phan bo NVL theo luong & DDCK theo PP ULTD

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP7131]	 @DivisionID as nvarchar(50),
					 @PeriodID as nvarchar(50), 
					 @TranMonth as int ,
					 @TranYear as int ,
					 @MaterialTypeID as nvarchar(50),
					@BeginMethodID int,
					@FromPeriodID nvarchar(50)		
AS
Declare @sSQL as nvarchar(4000),
	@SumProductCovalues as Decimal(28,8),
	@QuantityUnit as Decimal(28,8),
	@ProductCoValues as Decimal(28,8),
	@ConvertedUnit as Decimal(28,8),
	@ListMaterial_cur as cursor,
	@MaterialID as nvarchar(50),
	@ConvertedAmount as  Decimal(28,8),
	@MaterialQuantity as Decimal(28,8),
	@ListProduct_cur as cursor,
	@ProductID as nvarchar(50),
	@ProductQuantity as Decimal(28,8),
	@ProductQuantityUnit as Decimal(28,8),
	@ApportionID as nvarchar(50),
	@ProductUnitID nvarchar(50),
	@MaterialUnitID nvarchar(50),
	@ConvertedDecimal int,
	@QuantityDecimal int,
	@PerfectRate decimal (28, 8),
	@MaterialRate decimal (28, 8),
	@HumanResourceRate decimal (28, 8),
	@OthersRate decimal (28, 8),
	@UnitID nvarchar(50),
	@ResultTypeID nvarchar(50),
	@PMaterialQuantity decimal(28,8),
	@PConvertedAmount decimal(28,8)
	
Select @ConvertedDecimal = ConvertDecimal , @QuantityDecimal = QuantityDecimal
	From MT0000

---- Buoc 1. Xac dinh he so phan bo dua vao luong da phan bo
Set @sSQL ='
Select  MT4444.DivisionID,MT0444.ProductID, Sum(ConvertedUnit) as ConvertedUnit,
	MT4444.ProductQuantity,
	MT4444.UnitID,
	sum(Convertedunit)*MT4444.ProductQuantity*case when MT4444.ResultTypeID = ''R01'' then 1 else isnull(MT4444.MaterialRate,0)/100 end  as ProductCoValues,
	MT4444.PerfectRate, MT4444.MaterialRate, MT4444.HumanResourceRate, MT4444.OthersRate, MT4444.ResultTypeID	
From MT4444 inner  join MT0444 on MT4444.ProductID = MT0444.ProductID   and MT0444.ResultTypeID = ''R01''
Where ExpenseID = ''COST002''  
Group by MT4444.DivisionID, MT0444.ProductID, MT4444.ProductQuantity, MT4444.UnitID,
	MT4444.PerfectRate, MT4444.MaterialRate, MT4444.HumanResourceRate, MT4444.OthersRate, MT4444.ResultTypeID'

-----Tao view he so chung can phan bo cho san pham
If  exists (Select top 1 1 From SysObjects Where name = 'MV7131' and XType ='V')
	DROP VIEW MV7131

Exec ('Create view MV7131 as '+@sSQL)

---- Chi phi NVL phat sinh & DDDK
Set @sSQL='
Select  DivisionID,	InventoryID  as MaterialID, 
	Sum( Case D_C  when ''D'' then Isnull(Quantity,0) else -Isnull(Quantity,0) end ) as MaterialQuantity,
	Sum( Case D_C  when ''D'' then   Isnull(ConvertedAmount,0) else - Isnull(ConvertedAmount,0) end) as ConvertedAmount	
From MV9000 
WHere 	DivisionID ='''+@DivisionID+''' and
	PeriodID = '''+@PeriodID+''' and
	ExpenseID =''COST001'' and
	MaterialTypeID =''' + @MaterialTypeID+''' 
Group by DivisionID,InventoryID
Union      '      

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


If  exists (Select top 1 1 From SysObjects Where name = 'MV7317' and Xtype ='V')
	DROP VIEW MV7317
Exec ('Create view MV7317 as '+@sSQL)

Set @SumProductCovalues = (Select Sum(isnull(ProductCovalues,0)) From MV7131)


Set @ListMaterial_cur  = Cursor Scroll KeySet FOR 
		Select MV6105.MaterialID , MV6105.MaterialQuantity, MV6105.ConvertedAmount , AT1302.UnitID
		From MV7317 MV6105 	INNER JOIN AT1302 on AT1302.InventoryID = MV6105.MaterialID
	
Open @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount, @MaterialUnitID

WHILE @@Fetch_Status = 0
BEGIN
	Set @ListProduct_cur = Cursor Scroll KeySet FOR 
		Select 	ProductID, ProductQuantity, ProductCoValues , AT1302.UnitID,
			PerfectRate, MaterialRate, HumanResourceRate, OthersRate, ResultTypeID
		From  MV7131	inner join AT1302 on MV7131.ProductID = AT1302.InventoryID 
		Order by ResultTypeID desc, ProductID

	OPEN	@ListProduct_cur 
	FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @ProductUnitID,
				@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate, @ResultTypeID
	
	WHILE @@Fetch_Status = 0
	BEGIN
	IF @SumProductCovalues <> 0 and @ProductCoValues <> 0 	
	BEGIN
		Select @PConvertedAmount = round(@ConvertedAmount/@SumProductCovalues*@ProductCoValues, @ConvertedDecimal),
			@PMaterialQuantity = round(@MaterialQuantity/@SumProductCovalues*@ProductCoValues, @QuantityDecimal)
		IF isnull(@ProductQuantity,0) <> 0
			Select @ConvertedUnit = round(@PConvertedAmount/@ProductQuantity, @ConvertedDecimal),
				@QuantityUnit = round( @PMaterialQuantity/@ProductQuantity, @QuantityDecimal)
		ELSE Select @ConvertedUnit = 0, @QuantityUnit = 0
		
	IF @ResultTypeID = 'R03'
			Insert MT0444 (ResultTypeID, ExpenseID, MaterialTypeID, 
				MaterialID, ProductID, MaterialQuantity,  QuantityUnit,   
		    		ConvertedAmount,  ConvertedUnit,   InProcessQuantity, 
				PerfectRate, MaterialRate, HumanResourceRate, OthersRate )
			Values (@ResultTypeID, 'COST001', @MaterialTypeID, 
				@MaterialID, @ProductID, @PMaterialQuantity ,  @QuantityUnit,  
			    	@PConvertedAmount ,  @ConvertedUnit,    @ProductQuantity, 
				@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate)								
	ELSE  
		Insert MT0444 (MaterialID, ProductID,  ProductUnitID,  MaterialUnitID,   ExpenseID,    MaterialTypeID,
			ResultTypeID, ProductQuantity,  QuantityUnit, MaterialQuantity, ConvertedAmount,  ConvertedUnit)
		Values (@MaterialID, @ProductID,  @ProductUnitID,  @MaterialUnitID,   'COST001',    @MaterialTypeID,
			@ResultTypeID, @ProductQuantity,@QuantityUnit, @PMaterialQuantity,  @PConvertedAmount,  @ConvertedUnit)						
		
	END
	FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @ProductUnitID,
				@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate, @ResultTypeID
	END
	FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount, @MaterialUnitID		
END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- Xu ly lam tron
Declare @Detal_ConvertedAmount as decimal(28, 8),
	@Detal_MaterialQuantity  as decimal(28, 8),
	@ID nvarchar(50)

----------Lay tong so da phan bo
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
				Set  @Detal_ConvertedAmount = isnull((Select ConvertedAmount From MV7317
							Where 	MaterialID = @MaterialID),0)  - @ConvertedAmount
				
				Set  @Detal_MaterialQuantity = isnull((Select MaterialQuantity From MV7317
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