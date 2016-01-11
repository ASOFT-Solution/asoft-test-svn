IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP5102]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP5102]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- 	Created BY Nguyen Van Nhan AND Hoang Thi Lan; Date: 5/11/2003
---- 	Purpose: Phan bo chi phi NVL theo PP he so
----- 	Edit BY Quoc Hoai
----- 	Last updated Date 24/05/04, Van Nhan
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/
----- Modify on 02/12/2015 by Phương Thảo: Bổ sung điều kiện where theo PeriodID vì store MP5000 bảng MT2222 đã bỏ điều kiện này

CREATE Procedure [dbo].[MP5102] 	
				@DivisionID AS nvarchar(50), @PeriodID AS nvarchar(50),
				@TranMonth AS INT,@TranYear AS INT,
				@MaterialTypeID AS nvarchar(50), 
				@CoefficientID AS nvarchar(50) 
AS 
DECLARE @sSQL AS nvarchar(4000),
	@SumProductCovalues AS DECIMAL(28,8),
	@ListProduct_cur AS Cursor,
	@ProductID AS nvarchar(50),
	@ProductQuantity AS DECIMAL(28,8),
	@ProductCovalues AS DECIMAL(28,8),
	@ListMaterial_cur AS Cursor,
	@MaterialID AS nvarchar(50),
	@MaterialQuantity AS DECIMAL(28,8),
	@ConvertedAmount AS DECIMAL(28,8),
	@QuantityUnit AS DECIMAL(28,8),
	@ConvertedUnit	 AS DECIMAL(28,8),
	@UnitID AS nvarchar(50),
	@Quantity AS DECIMAL(28,8),
	@ConvertedAmount1 AS DECIMAL(28,8),
	@ConvertDecimal AS INT
	
SET @ConvertDecimal = (SELECT ConvertDecimal FROM MT0000 where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
---Print ' Van Nhan '
SET @sSQL='
Select 	MT1605.DivisionID, (Case  when MT1605.InventoryID is NULL then MT2222.ProductID ELSE MT1605.InventoryID END) AS ProductID ,
	MT2222.UnitID,		
	ISNULL(CoValue,0) AS  CoValue,
	ISNULL(ProductQuantity,0) AS ProductQuantity,
	 CoValue*ProductQuantity AS ProductCoValues 
FROM MT1605  Full JOIN MT2222 ON MT2222.DivisionID = MT1605.DivisionID AND MT2222.ProductID = MT1605.InventoryID
WHERE CoefficientID = N'''+@CoefficientID+''' and MT2222.PeriodID =  N'''+@PeriodID+'''
    AND MT1605.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(N'''+@DivisionID+'''))
'

IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV5102' AND Xtype ='V')
	EXEC ('CREATE VIEW MV5102 AS '+@sSQL)
ELSE
	EXEC ('ALTER VIEW MV5102 AS '+@sSQL)

---- tao ra VIEW So 1
SET @sSQL='
Select DivisionID, InventoryID AS MaterialID , SUM( Case D_C  when  ''D'' then ISNULL(Quantity,0) ELSE - ISNULL(Quantity,0) END) AS MaterialQuantity,
	 SUM( Case D_C  when  ''D'' then   ISNULL(ConvertedAmount,0) ELSE - ISNULL(ConvertedAmount,0) END)  AS ConvertedAmount
FROM MV9000   --- INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
WHERE PeriodID = N'''+@PeriodID+''' 
    AND ExpenseID =''COST001'' 
    AND MaterialTypeID =N'''+@MaterialTypeID+''' 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(N'''+@DivisionID+'''))
GROUP BY DivisionID,InventoryID '

IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV6102' AND Xtype ='V')
	EXEC ('CREATE VIEW MV6102 AS '+@sSQL)
ELSE
	EXEC ('ALTER VIEW MV6102 AS '+@sSQL)

------ Buoc 3  --- Xac dinh tong he so chung

SET @SumProductCovalues = (Select SUM(ISNULL(ProductCovalues,0)) FROM MV5102)

SET @ListProduct_cur = Cursor Scroll KeySet FOR 
	Select 	ProductID, ProductQuantity, ProductCoValues , UnitID
	FROM MV5102		
	 
OPEN	@ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @UnitID			
WHILE @@Fetch_Status = 0
	Begin	
		SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
		Select MaterialID , MaterialQuantity, ConvertedAmount FROM MV6102
		
		OPEN @ListMaterial_cur 
		FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount
		WHILE @@Fetch_Status = 0
			Begin	
				
				---- Phan bo so luong NVL cho mot san pham
				 IF ISNULL(@SumProductCovalues,0) <> 0 AND  ISNULL(@ProductQuantity,0)<>0		
				SET @QuantityUnit=(ISNULL(@MaterialQuantity,0)/@SumProductCovalues)*ISNULL(@ProductCoValues,0)/ @ProductQuantity 
				ELSE SET @QuantityUnit=0				
				
				---- Phan bo thanh tien chi phi mot nguyen vat lieu cho mot san pham
				IF ISNULL(@SumProductCovalues,0) <> 0 AND  ISNULL(@ProductQuantity,0)<> 0					
				   SET @ConvertedUnit = (@ConvertedAmount/@SumProductCovalues)*@ProductCoValues/@ProductQuantity					
				ELSE SET @ConvertedUnit = 0
				--INSERT vao bang MT0612
				IF ISNULL(@SumProductCovalues,0) <>0 
					Begin
						SET @Quantity =	(ISNULL(@MaterialQuantity,0)* ISNULL(@ProductCoValues,0)/@SumProductCovalues) 
						SET @ConvertedAmount1 = Round( (ISNULL(@ConvertedAmount,0)*ISNULL(@ProductCoValues,0)/@SumProductCovalues), @ConvertDecimal)
					END			
				ELSE 
					Begin
						SET @Quantity = 0
						SET @ConvertedAmount1 = 0
					END
				
				INSERT MT0621 (DivisionID, MaterialID, ProductID,  UnitID,     ExpenseID,  Quantity,  QuantityUnit,   MaterialTypeID,
					    	ConvertedAmount,  ConvertedUnit,    ProductQuantity, Rate  )
				VALUES (@DivisionID, @MaterialID, @ProductID,  @UnitID,   'COST001', @Quantity  ,  
					@QuantityUnit,   @MaterialTypeID,@ConvertedAmount1 ,  @ConvertedUnit,    @ProductQuantity, NULL)
				
				FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount
			END
		CLOSE @ListMaterial_cur
	 FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @UnitID
	END

CLOSE @ListProduct_cur

---- Xu ly lam tron
DECLARE @Detal_ConvertedAmount AS DECIMAL(28, 8),
	@Detal_MaterialQuantity  AS DECIMAL(28, 8),
	@ID AS DECIMAL(28,0)

SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
Select ISNULL(MaterialID,'')  , SUM(Quantity) AS Quantity, SUM(ConvertedAmount) AS ConvertedAmount 
FROM MT0621 WHERE MaterialTypeID =@MaterialTypeID  AND ExpenseID ='COST001'
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
GROUP BY ISNULL(MaterialID,'')

OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount
WHILE @@Fetch_Status = 0
	Begin
		Select @Detal_ConvertedAmount =0, @Detal_MaterialQuantity = 0 
		Select  @Detal_ConvertedAmount =round( ISNULL((Select  SUM( Case D_C  when  'D' then   ISNULL(ConvertedAmount,0) ELSE - ISNULL(ConvertedAmount,0) END) 
				                                       FROM MV9000 
				                                       WHERE PeriodID =@PeriodID 
				                                            AND MaterialTypeID = @MaterialTypeID 
				                                            AND ISNULL(InventoryID,'')  = @MaterialID
				                                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))),0),@ConvertDecimal) - @ConvertedAmount,
				@Detal_MaterialQuantity =  ISNULL((Select  SUM( Case D_C  when  'D' then   ISNULL(Quantity,0) ELSE - ISNULL(Quantity,0) END)  
				                                   FROM MV9000 
				                                   WHERE PeriodID =@PeriodID 
				                                        AND MaterialTypeID =@MaterialTypeID 
				                                        AND ISNULL(InventoryID,'')  = @MaterialID
				                                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))),0) - @MaterialQuantity
				                                        
		IF @Detal_ConvertedAmount <>0
			Begin
				SET @ID = NULL
				SET @ID = (Select TOP 1 ID  FROM MT0621 
				           WHERE MaterialTypeID =@MaterialTypeID AND ExpenseID = 'COST001' AND ISNULL(MaterialID,'') = @MaterialID 
				                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
				           Order BY  ConvertedAmount Desc )
				IF @ID is NOT NULL
				Update MT0621  SET ConvertedAmount = ConvertedAmount + @Detal_ConvertedAmount	 
					WHERE ID =@ID
    					AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
			END
	
		IF @Detal_MaterialQuantity <>0
			Begin
				SET @ID = NULL
				SET @ID = (Select TOP 1 ID  FROM MT0621 
				           WHERE MaterialTypeID =@MaterialTypeID AND ExpenseID = 'COST001' AND ISNULL(MaterialID,'') = @MaterialID 
				                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
				           Order BY  Quantity Desc )
				IF @ID is NOT NULL
					Update MT0621  SET Quantity = Quantity + @Detal_MaterialQuantity
					WHERE ID =@ID
    					AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
			END
		FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID , @MaterialQuantity , @ConvertedAmount
	END	


CLOSE @ListMaterial_cur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

