
/****** Object:  StoredProcedure [dbo].[MP7119]    Script Date: 12/16/2010 14:16:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


----- 	Created by: Vo Thanh Huong ,date: 11/4/2006
---- 	Purpose: Phan bo chi phi NVL theo PP he so, DDCK khong phan bo 

ALTER Procedure [dbo].[MP7119]	@DivisionID as nvarchar(50), 
				@PeriodID as nvarchar(50),
				@TranMonth as int,@TranYear as int,
				@MaterialTypeID as nvarchar(50), 
				@CoefficientID as nvarchar(50) ,
				@BeginMethodID int,
				@FromPeriodID nvarchar(50)		
as 
Declare @sSQL as nvarchar(4000),
	@SumProductCovalues Decimal(28,8),
	@ListProduct_cur as Cursor,
	@ProductID as nvarchar(50),
	@ProductQuantity as Decimal(28,8),
	@ProductCovalues as Decimal(28,8),
	@ListMaterial_cur as Cursor,
	@MaterialID as nvarchar(50),
	@MaterialQuantity as Decimal(28,8),
	@ConvertedAmount as Decimal(28,8),
	@QuantityUnit as Decimal(28,8),
	@ConvertedUnit	 as Decimal(28,8),
	@MaterialUnitID as nvarchar(50),
	@Quantity as decimal(28,8),
	@ConvertedAmount1 as Decimal(28,8),
	@ConvertedDecimal as int,
	@QuantityDecimal as int,
	@SumConvertedAmount decimal(28,8),
	@EConvertedAmount decimal(28,8),
	@EMaterialQuantity decimal(28,8),	
	@ResultTypeID nvarchar(50),
	@PerfectRate decimal (28, 8), 
	@MaterialRate decimal (28, 8), 
	@HumanResourceRate decimal (28, 8), 
	@OthersRate decimal (28, 8),
	@PConvertedAmount Decimal(28,8),
	@PMaterialQuantity decimal(28,8)

Select  @ConvertedDecimal =  ConvertDecimal,  @QuantityDecimal = QuantityDecimal
	From MT0000

Set @sSQL='
Select MT1605.DivisionID,	(Case  when MT1605.InventoryID is null then MT4444.ProductID 
		Else MT1605.InventoryID End) as ProductID ,
	isnull(CoValue,0) as  CoValue,
	Isnull(ProductQuantity,0) as ProductQuantity,
	isnull(CoValue,0)*isnull(ProductQuantity,0)  as ProductCoValues,
	MT4444.ResultTypeID, MT4444.PerfectRate, MT4444.MaterialRate, MT4444.HumanResourceRate, MT4444.OthersRate
From MT1605  inner join MT4444   on MT4444.ProductID = MT1605.InventoryID 
Where  MT1605.CoefficientID =''' + @CoefficientID+ ''' and MT4444.ResultTypeID= ''R01'''

If  exists (Select top 1 1 From SysObjects Where name = 'MV7119' and Xtype ='V')
	DROP VIEW MV7119

Exec ('Create view MV7119 as '+@sSQL)

----Lay  chi phi  phat sinh va CP DDDK
Set @sSQL = '
Select DivisionID,InventoryID as  MaterialID,
	Sum(Case D_C  when  ''D'' then   Isnull(Quantity,0) else - Isnull(Quantity,0) end)  as MaterialQuantity,
	Sum(Case D_C  when  ''D'' then   Isnull(ConvertedAmount,0) else - Isnull(ConvertedAmount,0) end)  as ConvertedAmount
From MV9000 
WHere 	DivisionID = '''+ @DivisionID + ''' and
	PeriodID = ''' + @PeriodID  + ''' and
	ExpenseID = ''COST001'' and
	MaterialTypeID =  ''' + @MaterialTypeID + '''
GROUP BY DivisionID,InventoryID
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

If  exists (Select top 1 1 From SysObjects Where name = 'MV7312' and Xtype ='V')
	DROP VIEW MV7312

Exec ('Create view MV7312 as '+@sSQL)

Set @sSQL = '
Select DivisionID,MaterialID, Sum(MaterialQuantity) as MaterialQuantity,
	Sum(ConvertedAmount) as ConvertedAmount
From MV7312
GROUP BY DivisionID,MaterialID'

If  exists (Select top 1 1 From SysObjects Where name = 'MV7313' and Xtype ='V')
	DROP VIEW MV7313

Exec ('Create view MV7313  as '+@sSQL)
 
------ Buoc 3  	 Xac dinh tong he so chung
Set @SumProductCovalues = (Select Sum(isnull(ProductCovalues,0)) From MV7119 )

Set  @ListMaterial_cur  = Cursor Scroll KeySet FOR  
		Select MaterialID , MaterialQuantity, ConvertedAmount, AT1302.UnitID  
		From MV7313  MV6102 left join AT1302 on MV6102.MaterialID = AT1302.InventoryID

OPEN @ListMaterial_cur
FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount, @MaterialUnitID

WHILE @@FETCH_STATUS = 0
BEGIN  
	Set @ListProduct_cur = Cursor Scroll KeySet FOR 
		Select 	ProductID, isnull(ProductQuantity,0), isnull(ProductCoValues,0) , ResultTypeID,
			PerfectRate, MaterialRate, HumanResourceRate, OthersRate
		From MV7119  MV5102	
		Order by ResultTypeID   desc

	OPEN	@ListProduct_cur
	FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @ResultTypeID,
				@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate
	WHILE  @@FETCH_STATUS = 0
	BEGIN
		
		IF (@ConvertedAmount<>0 or @MaterialQuantity<> 0) 
			and Isnull(@SumProductCovalues,0) <> 0 and  Isnull(@ProductQuantity,0)<>0	
		BEGIN
			Select @PConvertedAmount = round(@ConvertedAmount/@SumProductCovalues*@ProductCoValues, @ConvertedDecimal),
				@PMaterialQuantity = round(@MaterialQuantity/@SumProductCovalues*@ProductCoValues, @QuantityDecimal)
			
			Select  @ConvertedUnit = round(@PConvertedAmount/ @ProductQuantity, @ConvertedDecimal),
				@QuantityUnit= round(@PMaterialQuantity/ @ProductQuantity, @QuantityDecimal)

			Insert MT0444( ResultTypeID, ExpenseID,  MaterialTypeID, MaterialID, ProductID,  MaterialUnitID,
					MaterialQuantity,  QuantityUnit,   ConvertedAmount,  ConvertedUnit,    ProductQuantity)
				Values (@ResultTypeID,  'COST001',  @MaterialTypeID, @MaterialID, @ProductID,  @MaterialUnitID,   
					@PMaterialQuantity,  @QuantityUnit,   @PConvertedAmount ,  @ConvertedUnit,    @ProductQuantity)	

		END			
	FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @ResultTypeID,
	@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate

END
	FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount, @MaterialUnitID
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
	Set  @Detal_ConvertedAmount = isnull((Select ConvertedAmount From MV7313
				Where 	MaterialID = @MaterialID),0)  - @ConvertedAmount

	Set  @Detal_MaterialQuantity = isnull((Select MaterialQuantity From MV7313
				Where   MaterialID = @MaterialID),0)   - @MaterialQuantity
				
	If @Detal_ConvertedAmount <>0
	BEGIN
		Set @ID = null
		Select  top 1 @ID = ID
			From MT0444  
			Where MaterialTypeID = @MaterialTypeID and ExpenseID = 'COST001' and
				isnull(MaterialID,'') = @MaterialID  and ResultTypeID= 'R01'						
			Order by  ConvertedUnit Desc
						
		IF @ProductID is not  null
			Update MT0444  Set ConvertedAmount = ConvertedAmount + @Detal_ConvertedAmount,
					@ConvertedUnit = round( (ConvertedAmount + @Detal_ConvertedAmount)/ProductQuantity, @ConvertedDecimal)	 
				Where ID = @ID 
	END			
						
	If @Detal_MaterialQuantity <>0
	Begin
		Set @ID = null
		Set @ID = (Select top 1  ID  From MT0444 
				Where MaterialTypeID =@MaterialTypeID and ExpenseID = 'COST001' and 
					isnull(MaterialID,'') = @MaterialID  and ResultTypeID = 'R01'
				Order by QuantityUnit Desc )

		IF @ID is not null
			Update MT0444  Set MaterialQuantity = MaterialQuantity + @Detal_MaterialQuantity,
				QuantityUnit = round(( MaterialQuantity + @Detal_MaterialQuantity)/ProductQuantity, @QuantityDecimal)
			Where  ID = @ID 
	END
	FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount
END

Close @ListMaterial_cur