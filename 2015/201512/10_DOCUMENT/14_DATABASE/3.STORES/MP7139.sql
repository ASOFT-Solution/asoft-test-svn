
/****** Object:  StoredProcedure [dbo].[MP7139]    Script Date: 12/16/2010 10:17:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


--Created by: Vo Thanh Huong, date: 17/4/2006
--purpose: Phan bo NVL theo luong & DDCK khong phan bo chi phi

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP7139]	 
					@DivisionID AS NVARCHAR(50),
					@PeriodID AS NVARCHAR(50), 
					@TranMonth AS INT,
					@TranYear AS INT,
					@MaterialTypeID AS NVARCHAR(50),
					@BEGINMethodID INT,
					@FromPeriodID NVARCHAR(50)		
AS
DECLARE @sSQL AS NVARCHAR(4000),
	@SumProductCovalues AS DECIMAL(28,8),
	@QuantityUnit AS DECIMAL(28,8),
	@ProductCoValues AS DECIMAL(28,8),
	@ConvertedUnit AS DECIMAL(28,8),
	@ListMaterial_cur AS CURSOR,
	@MaterialID AS NVARCHAR(50),
	@ConvertedAmount AS DECIMAL(28,8),
	@MaterialQuantity AS DECIMAL(28,8),
	@ListProduct_cur AS CURSOR,
	@ProductID AS NVARCHAR(50),
	@ProductQuantity AS DECIMAL(28,8),
	@ProductQuantityUnit AS DECIMAL(28,8),
	@ApportionID AS NVARCHAR(50),
	@ProductUnitID NVARCHAR(50),
	@MaterialUnitID NVARCHAR(50),
	@ConvertedDECIMAL INT,
	@QuantityDECIMAL INT,
	@PerfectRate DECIMAL (28, 8),
	@MaterialRate DECIMAL (28, 8),
	@HumanResourceRate DECIMAL (28, 8),
	@OthersRate DECIMAL (28, 8),
	@UnitID NVARCHAR(50),
	@ResultTypeID NVARCHAR(50),
	@PMaterialQuantity DECIMAL(28,8),
	@PConvertedAmount DECIMAL(28,8)
	
SELECT @ConvertedDECIMAL = ConvertDECIMAL, 
	@QuantityDECIMAL = QuantityDECIMAL
FROM MT0000

---- Buoc 1. Xac dinh he so phan bo dua vao luong da phan bo
SET @sSQL ='
SELECT MT4444.DivisionID, 
	MT0444.ProductID, 
	SUM(ConvertedUnit) AS ConvertedUnit,
	MT4444.ProductQuantity,
	MT4444.UnitID,
	SUM(ConvertedAmount) * CASE WHEN MT4444.ResultTypeID = ''R01'' THEN 1 ELSE ISNULL(MT4444.MaterialRate, 0) / 100 END  AS ProductCoValues,
	MT4444.PerfectRate, 
	MT4444.MaterialRate, 
	MT4444.HumanResourceRate, 
	MT4444.OthersRate, 
	MT4444.ResultTypeID	
FROM MT4444 INNER JOIN MT0444 ON MT4444.ProductID = MT0444.ProductID AND MT4444.ResultTypeID = MT0444.ResultTypeID
WHERE ExpenseID = ''COST002''  
	AND MT4444.ResultTypeID = ''R01''
GROUP BY MT0444.ProductID, MT4444.ProductQuantity, MT4444.UnitID,
	MT4444.PerfectRate, MT4444.MaterialRate, MT4444.HumanResourceRate, MT4444.OthersRate, MT4444.ResultTypeID, MT4444.DivisionID'

-----Tao view he so chung can phan bo cho san pham
IF  EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV7139' AND XType ='V')
	DROP VIEW MV7139

EXEC ('Create view MV7139 AS ' + @sSQL)

---- Chi phi NVL phat sinh & DDDK
SET @sSQL = '
SELECT DivisionID,
	InventoryID AS MaterialID, 
	SUM(Case D_C WHEN ''D'' THEN ISNULL(Quantity,0) ELSE - ISNULL(Quantity, 0) END) AS MaterialQuantity,
	SUM(Case D_C WHEN ''D'' THEN ISNULL(ConvertedAmount,0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount	
FROM MV9000 
WHERE DivisionID =''' + @DivisionID + '''
	AND	PeriodID = ''' + @PeriodID + '''
	AND	ExpenseID =''COST001''
	AND	MaterialTypeID =''' + @MaterialTypeID + ''' 
GROUP BY InventoryID, DivisionID
UNION          ' 

IF @BEGINMethodID = 1   ---Chi phi do dang dau ky  cap nhat bang tay
	SET @sSQL = @sSQL + ' 
	SELECT DivisionID, 
		MaterialID, 
		SUM(ISNULL(WipQuantity, 0)),  
		SUM(ISNULL(ConvertedAmount,0)) 
	FROM MT1612
	WHERE DivisionID = ''' + @DivisionID + ''' 
		AND	PeriodID = ''' +  @PeriodID  + ''' 
		AND	ExpenseID = ''COST001'' 
		AND	MaterialTypeID = ''' +  @MaterialTypeID + ''' 
		AND Type = ''B''	
	GROUP BY MaterialID, DivisionID'

ELSE  ---Chi phi do dang dau ky ke thua tu DDCK cua  doi tuong khac
	SET @sSQL = @sSQL + ' 
	SELECT  DivisionID,
		MaterialID ,
		SUM(ISNULL(MaterialQuantity,0)) AS MaterialQuantity,
		SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount	
	FROM MT0400
	WHERE DivisionID =''' + @DivisionID + ''' 
		AND	PeriodID = '''+@FromPeriodID+''' 
		AND	ExpenseID =''COST001'' 
		AND	ISNULL(ProductID,'''')<>''''  
		AND MaterialTypeID  = ''' + @MaterialTypeID + '''  
		AND ResultTypeID= ''R03''
	GROUP BY MaterialID,DivisionID'

IF  exists (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV7317' AND Xtype ='V')
	DROP VIEW MV7317
EXEC ('Create view MV7317 AS '+@sSQL)

SET @SumProductCovalues = (SELECT SUM(ISNULL(ProductCovalues,0)) FROM MV7139)

SET @ListMaterial_cur  = Cursor Scroll KeySET FOR 
		SELECT MV6105.MaterialID , MV6105.MaterialQuantity, MV6105.ConvertedAmount, AT1302.UnitID
		FROM MV7317 MV6105 INNER JOIN AT1302 ON AT1302.InventoryID = MV6105.MaterialID
	
OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount, @MaterialUnitID

WHILE @@Fetch_Status = 0
BEGIN
	SET @ListProduct_cur = Cursor Scroll KeySET FOR 
		SELECT 	ProductID, ProductQuantity, ProductCoValues , AT1302.UnitID,
			PerfectRate, MaterialRate, HumanResourceRate, OthersRate, ResultTypeID
		FROM MV7139  MV7131	inner JOIN AT1302 ON MV7131.ProductID = AT1302.InventoryID 
		ORDER BY ResultTypeID DESC, ProductID

	OPEN @ListProduct_cur 
	FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @ProductUnitID,
				@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate, @ResultTypeID
	
	WHILE @@Fetch_Status = 0
	BEGIN
	IF @SumProductCovalues <> 0 AND @ProductCoValues <> 0 	
	BEGIN
		SELECT @PConvertedAmount = ROUND(@ConvertedAmount / @SumProductCovalues * @ProductCoValues, @ConvertedDECIMAL),
			@PMaterialQuantity = ROUND(@MaterialQuantity / @SumProductCovalues * @ProductCoValues, @QuantityDECIMAL)
		IF ISNULL(@ProductQuantity, 0) <> 0
			SELECT @ConvertedUnit = ROUND(@PConvertedAmount / @ProductQuantity, @ConvertedDECIMAL),
				@QuantityUnit = ROUND(@PMaterialQuantity / @ProductQuantity, @QuantityDECIMAL)
		ELSE SELECT @ConvertedUnit = 0, @QuantityUnit = 0
		
	IF @ResultTypeID = 'R03'
			INSERT MT0444 (ResultTypeID, ExpenseID, MaterialTypeID, 
				MaterialID, ProductID, MaterialQuantity,  QuantityUnit,   
		    		ConvertedAmount,  ConvertedUnit,   InProcessQuantity, 
				PerfectRate, MaterialRate, HumanResourceRate, OthersRate)
			VALUES (@ResultTypeID, 'COST001', @MaterialTypeID, 
				@MaterialID, @ProductID, @PMaterialQuantity ,  @QuantityUnit,  
			    	@PConvertedAmount ,  @ConvertedUnit,    @ProductQuantity, 
				@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate)								
	ELSE  
		INSERT MT0444 (MaterialID, ProductID,  ProductUnitID,  MaterialUnitID,   ExpenseID,    MaterialTypeID,
			ResultTypeID, ProductQuantity,  QuantityUnit, MaterialQuantity, ConvertedAmount,  ConvertedUnit)
		VALUES (@MaterialID, @ProductID,  @ProductUnitID,  @MaterialUnitID,   'COST001',    @MaterialTypeID,
			@ResultTypeID, @ProductQuantity,@QuantityUnit, @PMaterialQuantity,  @PConvertedAmount,  @ConvertedUnit)						
		
	END
	FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @ProductUnitID,
				@PerfectRate, @MaterialRate, @HumanResourceRate, @OthersRate, @ResultTypeID
	END
	FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount, @MaterialUnitID		
END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- Xu ly lam tron
Declare @Detal_ConvertedAmount AS DECIMAL(28, 8),
	@Detal_MaterialQuantity  AS DECIMAL(28, 8),
	@ID NVARCHAR(50)

----------Lay tong so da phan bo
SET @ListMaterial_cur  = Cursor Scroll KeySET FOR 
		SELECT MaterialID, SUM(ISNULL(MaterialQuantity,0)),  SUM(ISNULL(ConvertedAmount,0))
		FROM MT0444 WHERE MaterialTypeID = @MaterialTypeID 
		GROUP BY  MaterialID

		OPEN @ListMaterial_cur 
		FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount
		WHILE @@Fetch_Status = 0
			BEGIN
				SELECT @Detal_ConvertedAmount =0, @Detal_MaterialQuantity = 0 
				----tri gia da tap hop 						
				SET  @Detal_ConvertedAmount = ISNULL((SELECT ConvertedAmount FROM MV7317
							WHERE 	MaterialID = @MaterialID),0)  - @ConvertedAmount
				
				SET  @Detal_MaterialQuantity = ISNULL((SELECT MaterialQuantity FROM MV7317
						WHERE   MaterialID = @MaterialID),0)   - @MaterialQuantity
				
				IF @Detal_ConvertedAmount <>0
					BEGIN
						SET @ID = null
						SELECT  top 1 @ID = ID
						FROM MT0444  
						WHERE MaterialTypeID = @MaterialTypeID AND ExpenseID = 'COST001' AND
							ISNULL(MaterialID,'') = @MaterialID  AND ResultTypeID= 'R01'						
						ORDER BY  ConvertedUnit Desc
						
						IF @ID is not  null
							Update MT0444  SET ConvertedAmount = ConvertedAmount + @Detal_ConvertedAmount,
									@ConvertedUnit = round( (ConvertedAmount + @Detal_ConvertedAmount)/ProductQuantity, @ConvertedDECIMAL)	 
							WHERE ID = @ID 
						ELSE
						BEGIN
							SELECT  top 1 @ID = ID
							FROM MT0444  
							WHERE MaterialTypeID = @MaterialTypeID AND ExpenseID = 'COST001' AND
								ISNULL(MaterialID,'') = @MaterialID  AND ResultTypeID= 'R03'
							ORDER BY  ConvertedUnit Desc
	
							IF @ID is not null
								UPDATE MT0444  
									SET ConvertedAmount = ConvertedAmount + @Detal_ConvertedAmount,
										 @ConvertedUnit = round( (ConvertedAmount + @Detal_ConvertedAmount)/InProcessQuantity, @ConvertedDECIMAL)	 
									WHERE  ID = @ID 
						END
						
					END
			
				IF @Detal_MaterialQuantity <>0
					BEGIN
						SET @ID = null
						SET @ID = (SELECT top 1  ID  FROM MT0444 
								WHERE MaterialTypeID =@MaterialTypeID AND ExpenseID = 'COST001' AND 
									ISNULL(MaterialID,'') = @MaterialID  AND ResultTypeID = 'R01'
								Order by  QuantityUnit Desc )

						IF @ID is not null
							Update MT0444  SET MaterialQuantity = MaterialQuantity + @Detal_MaterialQuantity,
									QuantityUnit = round(( MaterialQuantity + @Detal_MaterialQuantity)/ProductQuantity, @QuantityDECIMAL)
							WHERE  ID = @ID 
						ELSE 
						BEGIN
							SELECT  top 1 @ID = ID
							FROM MT0444  
							WHERE MaterialTypeID = @MaterialTypeID AND ExpenseID = 'COST001' AND
								ISNULL(MaterialID,'') = @MaterialID  AND ResultTypeID= 'R03'
							Order by  QuantityUnit Desc
							
							IF @ID is not null	
								Update MT0444  SET MaterialQuantity = MaterialQuantity + @Detal_MaterialQuantity,
									QuantityUnit = round(( MaterialQuantity + @Detal_MaterialQuantity)/InProcessQuantity, @QuantityDECIMAL)
								WHERE  ID = @ID 
						END	
					END
				FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount
			END	
CLOSE @ListMaterial_cur