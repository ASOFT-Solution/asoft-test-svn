IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP5103]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP5103]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created BY  Nguyen Van Nhan AND Hoang Thi Lan
----- Created Date 07/11/2003.
----- Purpose: Phan bo chi phi Nguyen vat lieu theo PP dinh muc
----- Edit BY Vo Thanh  Huong, date : 06/05/2005
----- Purpose: Phan bo chi phí theo dinh muc chi theo so luong khong theo thanh tien, lam tron 
----- Edit BY: Dang Le Bao Quynh; Date 21/08/2007
----- Purpose: Xu ly truong hop ma nguyen lieu co do dang dau ky, ton tai trong bo dinh muc nhung khong co phat sinh trong ky nay
----- Edit BY Van Nhan
---- Purpose: Xu ly truong hop co NVL thay the
----- Modify on 24/04/2014 by Bảo Anh: Sửa lỗi phân bổ NVL thay thế chưa đúng
----- Modify on 27/07/2015 by Bảo Anh: Khi phân bổ NVL thay thế phải trừ số tiền đã phân bổ sản xuất trực tiếp
----- Modify on 25/08/2015 by Bảo Anh: Phân bổ NVL thay thế cùng với NVL chính (trước đây phân bổ NVL chính xong mới đến NVL thay thế)
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

CREATE PROCEDURE  [dbo].[MP5103]     @DivisionID AS nvarchar(50), 
                     @PeriodID  AS nvarchar(50), 
                    @TranMonth AS INT, 
                    @TranYear AS INT, 
                    @MaterialTypeID  AS nvarchar(50), 
                    @ApportionID  AS nvarchar(50)

AS
DECLARE @sSQL AS nvarchar(4000), 
    @ListMaterial_cur AS cursor, 
    @MaterialID AS nvarchar(50), 
    @ConvertedAmount DECIMAL(28, 8), 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ProductConvertedUnit AS  DECIMAL(28, 8), 
    @MaterialQuantityUnit AS DECIMAL(28, 8), 
    @SumProductQuantity AS DECIMAL(28, 8), 
    @SumProductConverted AS DECIMAL(28, 8), 
    @MaterialConvertedUnit AS DECIMAL(28, 8), 
    @ListProduct_cur AS cursor, 
    @ProductID AS nvarchar(50), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @ProductQuantityUnit AS DECIMAL(28, 8), 
    @UnitID AS nvarchar(50), 
    @QuantityUnit AS DECIMAL(28, 8), 
    @ConvertedUnit AS DECIMAL(28, 8), 
    @ConvertedDecimal INT, 
    @Cur AS cursor, 
    @MaterialGroupID AS nvarchar(50),
    @ExtraMaterialID AS nvarchar(50),
    @ExtraQuantity as DECIMAL(28, 8)
    
SET @ConvertedDecimal = (SELECT ConvertDecimal FROM MT0000 where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
        
-- Print ' Phan bo NVL theo PP dinh muc'

---- Buoc 1:  lay he so quy doi cho cac nguyen vat lieu
--SET @sSQl='
--Select MT1603.DivisionID, MT1603.ProductID, MaterialID, QuantityUnit, ConvertedUnit, MT2222.ProductQuantity, 
--    MT2222.UnitID, IsExtraMaterial, MaterialGroupID, 
--    QuantityUnit*MT2222.ProductQuantity AS ProductQuantityUnit, 
--    ConvertedUnit*MT2222.ProductQuantity AS ProductConvertedUnit
--FROM MT1603 INNER JOIN MT2222 ON MT2222.DivisionID = MT1603.DivisionID AND MT2222.ProductID = MT1603.ProductID
--WHERE     ApportionID = N'''+@ApportionID+''' 
--    AND MT1603.DivisionID = N'''+@DivisionID+'''
--    AND ExpenseID =''COST001''

--UNION	--- Bổ sung NVL thay thế
--Select DivisionID, ProductID, MaterialID, QuantityUnit, ConvertedUnit, ProductQuantity, 
--    UnitID, 1 as IsExtraMaterial, MaterialGroupID, 
--    QuantityUnit*ProductQuantity AS ProductQuantityUnit, 
--    ConvertedUnit*ProductQuantity AS ProductConvertedUnit
--FROM
--(Select MT1603.DivisionID, MT1603.ProductID, MT0007.MaterialID, MT0007.CoValues as QuantityUnit,
--MT1603.ConvertedUnit as ConvertedUnit, MT2222.ProductQuantity, MT2222.UnitID, MT1603.MaterialGroupID
--FROM MT1603 INNER JOIN MT2222 ON MT2222.DivisionID = MT1603.DivisionID AND MT2222.ProductID = MT1603.ProductID
--INNER JOIN MT0007 On MT1603.DivisionID = MT0007.DivisionID AND MT1603.IsExtraMaterial = 1 And MT1603.MaterialGroupID = MT0007.MaterialGroupID
--WHERE     ApportionID = N'''+@ApportionID+''' 
--    AND MT1603.DivisionID = N'''+@DivisionID+'''
--    AND ExpenseID =''COST001''
--) MT1603
--'
--IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV5103' AND Xtype ='V')
--    EXEC ('CREATE VIEW MV5103 AS '+@sSQL)
--ELSE
--    EXEC ('ALTER VIEW MV5103 AS '+@sSQL)


------ Buoc 2:  Lay tong chi phi theo tung nguyen vat lieu
--SET @sSQL='
--SELECT DivisionID, InventoryID AS MaterialID, 
--    SUM( Case D_C  when  ''D'' then ISNULL(Quantity, 0) ELSE - ISNULL(Quantity, 0) END) AS MaterialQuantity, 
--    SUM( Case D_C  when  ''D'' then   ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount    
--FROM MV9000   --- INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
--WHERE     PeriodID = N'''+@PeriodID+''' 
--    AND ExpenseID =''COST001'' 
--    AND MaterialTypeID =N'''+@MaterialTypeID+'''  
--    AND DivisionID = '''+@DivisionID+'''
--GROUP BY DivisionID, InventoryID '

--IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV6103' AND Xtype ='V')
--    EXEC ('CREATE VIEW MV6103 AS '+@sSQL)
--ELSE
--    EXEC ('ALTER VIEW MV6103 AS '+@sSQL)


CREATE TABLE #TMP_MV5103(DivisionID NVARCHAR(50), ProductID NVARCHAR(50), MaterialID NVARCHAR(50), QuantityUnit DECIMAL(28,8),
						 ConvertedUnit DECIMAL(28,8), ProductQuantity DECIMAL(28,8), UnitID NVARCHAR(50),IsExtraMaterial INT,
						  MaterialGroupID NVARCHAR(50), ProductQuantityUnit DECIMAL(28,8), ProductConvertedUnit DECIMAL(28,8))
	INSERT INTO #TMP_MV5103
		Select MT1603.DivisionID, MT1603.ProductID, MaterialID, QuantityUnit, ConvertedUnit, MT2222.ProductQuantity, 
		MT2222.UnitID, IsExtraMaterial, MaterialGroupID, 
		QuantityUnit*MT2222.ProductQuantity AS ProductQuantityUnit, 
		ConvertedUnit*MT2222.ProductQuantity AS ProductConvertedUnit
	FROM MT1603 INNER JOIN MT2222 ON MT2222.DivisionID = MT1603.DivisionID AND MT2222.ProductID = MT1603.ProductID
	WHERE     ApportionID = @ApportionID
		AND MT1603.DivisionID = @DivisionID
		AND ExpenseID ='COST001'

	UNION	--- Bổ sung NVL thay thế
	Select DivisionID, ProductID, MaterialID, QuantityUnit, ConvertedUnit, ProductQuantity, 
		UnitID, 1 as IsExtraMaterial, MaterialGroupID, 
		QuantityUnit*ProductQuantity AS ProductQuantityUnit, 
		ConvertedUnit*ProductQuantity AS ProductConvertedUnit
	FROM
	(Select MT1603.DivisionID, MT1603.ProductID, MT0007.MaterialID, MT0007.CoValues as QuantityUnit,
	MT1603.ConvertedUnit as ConvertedUnit, MT2222.ProductQuantity, MT2222.UnitID, MT1603.MaterialGroupID
	FROM MT1603 INNER JOIN MT2222 ON MT2222.DivisionID = MT1603.DivisionID AND MT2222.ProductID = MT1603.ProductID
	INNER JOIN MT0007 On MT1603.DivisionID = MT0007.DivisionID AND MT1603.IsExtraMaterial = 1 And MT1603.MaterialGroupID = MT0007.MaterialGroupID
	WHERE     ApportionID = @ApportionID
		AND MT1603.DivisionID = @DivisionID
		AND ExpenseID ='COST001'
	) MT1603

	CREATE TABLE #TMP_MV6103(DivisionID NVARCHAR(50),MaterialID NVARCHAR(100) , MaterialQuantity DECIMAL(28,8), ConvertedAmount DECIMAL(28,8))
	INSERT INTO #TMP_MV6103
	SELECT DivisionID, InventoryID AS MaterialID, 
		SUM( Case D_C  when  'D' then ISNULL(Quantity, 0) ELSE - ISNULL(Quantity, 0) END) AS MaterialQuantity, 
		SUM( Case D_C  when  'D' then   ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount    
	FROM MV9000   --- INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
	WHERE     PeriodID = @PeriodID
		AND ExpenseID ='COST001' 
		AND MaterialTypeID =@MaterialTypeID
		AND DivisionID = @DivisionID
	GROUP BY DivisionID, InventoryID 


--- INSERT DU LIEU
	INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit,
				   MaterialTypeID, ConvertedAmount, ConvertedUnit, ProductQuantity, Rate)    
	
	SELECT	DivisionID, MaterialID, ProductID, UnitID, ExpenseID, 
			MaterialQuantityUnit AS Quantity,
			CASE WHEN ISNULL(ProductQuantity, 0) <> 0  THEN MaterialQuantityUnit/ProductQuantity ELSE 0 END [QuantityUnit],
			@MaterialTypeID,
			MaterialConvertedUnit AS ConvertedAmount,
			CASE WHEN ISNULL(ProductQuantity, 0) <> 0 THEN MaterialConvertedUnit/ProductQuantity ELSE 0 END [ConvertedUnit],  
			ProductQuantity
			, NULL
	FROM (		SELECT  MV5103.DivisionID, MV5103.MaterialID, MV5103.ProductID,MV5103.UnitID,'COST001' [ExpenseID],
						CASE WHEN ISNULL(SumProductQuantity, 0) <> 0 THEN (ISNULL(MV6103.MaterialQuantity, 0)*ISNULL(MV5103.ProductQuantityUnit, 0)/ SumProductQuantity) ELSE 0 END [MaterialQuantityUnit], 
						CASE WHEN ISNULL(SumProductQuantity, 0) <> 0 THEN round(ISNULL(MV6103.ConvertedAmount, 0)*ISNULL(MV5103.ProductQuantityUnit, 0)/ SumProductQuantity, @ConvertedDecimal) ELSE 0 END [MaterialConvertedUnit], 
			
						MV6103.ConvertedAmount, 
						MV6103.MaterialQuantity, MV5103.ProductQuantity,     
						MV5103.ProductQuantityUnit, MV5103.ProductConvertedUnit, 
						M03.SumProductQuantity ,
						M03.SumProductConverted 
				FROM #TMP_MV5103 MV5103				
				LEFT JOIN  #TMP_MV6103 MV6103
					ON MV5103.DivisionID = MV6103.DivisionID 
						AND MV5103.MaterialID = MV6103.MaterialID 
				LEFT JOIN	(	Select MaterialID,SUM (ISNULL(ProductQuantityUnit, 0)) SumProductQuantity,
									   SUM (ISNULL(ProductConvertedUnit, 0)) SumProductConverted
								FROM #TMP_MV5103 M03
								GROUP BY M03.MaterialID
							) M03 ON M03.MaterialID = MV6103.MaterialID
    ) DATA

--- Làm Tròn Dữ liệu

	UPDATE MT06
	SET MT06.ConvertedAmount = MT06.ConvertedAmount + AA.NewValue
	FROM MT0621 MT06
	INNER JOIN 
		(	SELECT MT06.ID,ROW_NUMBER() OVER( PARTITION BY MT06.MaterialID ORDER BY MT06.ConvertedAmount Desc)  [ROW]
		   ,ROUND(ISNULL(MV61.ConvertedAmount,0),@ConvertedDecimal) - MT061.ConvertedAmount [NewValue]
			FROM MT0621 MT06	
			INNER JOIN				
			( 		Select MaterialTypeID,ExpenseID,DivisionID, ISNULL(MaterialID,'')  [MaterialID],
							SUM(Quantity) AS Quantity,
							SUM(ConvertedAmount) AS ConvertedAmount 
					FROM MT0621 
					WHERE MaterialTypeID = @MaterialTypeID
						AND ExpenseID ='COST001'
						AND DivisionID =  @DivisionID
					GROUP BY MaterialTypeID,ExpenseID,DivisionID,ISNULL(MaterialID,'')			
			) MT061 
				ON MT06.MaterialTypeID = MT061.MaterialTypeID
				AND MT06.ExpenseID = MT061.ExpenseID
				AND MT06.DivisionID = MT061.DivisionID
				AND MT06.MaterialID = MT061.MaterialID
			LEFT JOIN #TMP_MV6103 MV61 
				ON ISNULL(MV61.MaterialID,0) = MT06.MaterialID			
			GROUP BY MT06.ID,MT06.MaterialID,MV61.ConvertedAmount,MT061.ConvertedAmount,MT06.ConvertedAmount
			HAVING (ROUND(ISNULL(MV61.ConvertedAmount,0),@ConvertedDecimal) - MT061.ConvertedAmount) <> 0
		) AA ON AA.ID = MT06.ID AND AA.[ROW] = 1





----- Buoc 3: Duyet tung nguyen vat lieu va phan bo chi phi cho chung
	
--    SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
--    SELECT MV5103.MaterialID, MV5103.ProductID, MV6103.ConvertedAmount, 
--        MV6103.MaterialQuantity,     
--        MV5103.ProductQuantity,     
--        MV5103.ProductQuantityUnit, MV5103.ProductConvertedUnit, 
--        SumProductQuantity = (Select SUM (ISNULL(ProductQuantityUnit, 0)) FROM MV5103 M03
--                                WHERE M03.MaterialID = MV6103.MaterialID), 
--        SumProductConverted = (select SUM (ISNULL(ProductConvertedUnit, 0)) FROM MV5103 M03
--                                WHERE M03.MaterialID = MV6103.MaterialID)
--    FROM MV5103 LEFT JOIN  MV6103 ON MV5103.DivisionID = MV6103.DivisionID AND MV5103.MaterialID = MV6103.MaterialID 
    
--OPEN @ListMaterial_cur 
--FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @ProductID, @ConvertedAmount, @MaterialQuantity, @ProductQuantity, @ProductQuantityUnit, @ProductConvertedUnit, @SumProductQuantity, @SumProductConverted    
--    WHILE @@Fetch_Status = 0
--    Begin    
--        SELECT @MaterialQuantityUnit = 0, @MaterialConvertedUnit = 0 
        
--        IF ISNULL(@SumProductQuantity, 0) <> 0    
--            Select @MaterialQuantityUnit = (ISNULL(@MaterialQuantity, 0)*ISNULL(@ProductQuantityUnit, 0)/ @SumProductQuantity), 
--                   @MaterialConvertedUnit =round(ISNULL(@ConvertedAmount, 0)*ISNULL(@ProductQuantityUnit, 0)/ @SumProductQuantity, @ConvertedDecimal)
--        ELSE  
--            Select @MaterialQuantityUnit = 0, @MaterialConvertedUnit = 0 
        --/*
        --IF  ISNULL(@SumProductConverted, 0) <> 0 
        --SET @MaterialConvertedUnit =(ISNULL(@ConvertedAmount, 0)*ISNULL(@ProductConvertedUnit, 0)/ @SumProductConverted)
        --ELSE 
        --    SET  @SumProductConverted = 0 
        --*/
--        IF @ProductQuantity <> 0
--            Select @QuantityUnit = @MaterialQuantityUnit/@ProductQuantity, 
--                   @ConvertedUnit = @MaterialConvertedUnit/@ProductQuantity
--        ELSE                 
--            Select @QuantityUnit = 0, @ConvertedUnit = 0
        
--        IF @MaterialConvertedUnit<>0 or @QuantityUnit<>0
--        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
--            VALUES (@DivisionID, @MaterialID, @ProductID, @UnitID, 'COST001', @MaterialQuantityUnit, @QuantityUnit, @MaterialTypeID, @MaterialConvertedUnit, @ConvertedUnit, @ProductQuantity, NULL)
    
--        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @ProductID, @ConvertedAmount, @MaterialQuantity, @ProductQuantity, @ProductQuantityUnit, @ProductConvertedUnit, @SumProductQuantity, @SumProductConverted
--    END            
--CLOSE @ListMaterial_cur



------ Xu ly lam tron
--DECLARE @Detal AS DECIMAL(28, 8), 
--    @ID AS DECIMAL(28, 8)

--SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
--Select ISNULL(MaterialID, ''), SUM(Quantity) AS Quantity, SUM(ConvertedAmount) AS ConvertedAmount 
--FROM MT0621 WHERE MaterialTypeID =@MaterialTypeID  AND ExpenseID ='COST001'
--    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
--GROUP BY ISNULL(MaterialID, '')
        
--OPEN @ListMaterial_cur 
--FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount
--WHILE @@Fetch_Status = 0
--    Begin
--        SELECT @Detal =0, @ID = NULL, 
--            @Detal = round(ISNULL( (Select SUM( Case D_C  when  'D' then   ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) 
--                                FROM MV9000   --- INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
--                                WHERE PeriodID =@PeriodID 
--                                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
--                                    AND MaterialTypeID = @MaterialTypeID 
--									AND ISNULL(InventoryID, '')  = @MaterialID), 0), @ConvertedDecimal) - @ConvertedAmount
--        IF @Detal<>0
--            Begin
--                SET @ID = (Select TOP 1 ID  FROM MT0621 
--                            WHERE MaterialTypeID =@MaterialTypeID AND ExpenseID = 'COST001' AND ISNULL(MaterialID, '') = @MaterialID 
--                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
--                            Order BY  ConvertedAmount Desc )
--                IF @ID is NOT NULL
--                    Update MT0621 SET ConvertedAmount = ConvertedAmount + @Detal     
--                    WHERE ID =@ID
--                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
--            END
--        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount
--    END
--CLOSE @ListMaterial_cur





--- Modify on 25/08/2015 by Bảo Anh: Rem lại phần NVL thay thế này do đã phân bổ chung với NVL chính ở phần trên
/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- adding BY Van Nhan, Phan bo them phan NVL thay the
--SELECT FROM MT1603 WHERE ApportionID='DM003' AND ExpenseID='COST001' AND IsExtraMaterial =1

SET @Cur  = Cursor Scroll KeySet FOR 
Select MaterialGroupID, MaterialID, ProductID, 
QuantityUnit, ConvertedUnit, 
ProductQuantity, ProductQuantityUnit
FROM MV5103 WHERE IsExtraMaterial =1

OPEN @Cur
FETCH NEXT FROM @Cur INTO  @MaterialGroupID, @MaterialID, @ProductID, 
@QuantityUnit, @ConvertedUnit, 
@ProductQuantity, @ProductQuantityUnit
WHILE @@Fetch_Status = 0
    Begin        
        SELECT @MaterialQuantityUnit = 0, @MaterialConvertedUnit = 0, @SumProductQuantity =0
/*
        Select @MaterialQuantity = SUM( MaterialQuantity/MT0007.CoValues), @ConvertedAmount =SUM(ConvertedAmount)
        FROM MV6103 INNER JOIN MT0007 ON MT0007.DivisionID =MV6103.DivisionID AND MT0007.MaterialID =MV6103.MaterialID AND MT0007.MaterialGroupID=MaterialGroupID
        
        IF @MaterialQuantity is NULL
            SET @MaterialQuantity=0
        IF @ConvertedAmount is NULL
            SET @ConvertedAmount =0 
        
        SET @SumProductQuantity =(Select SUM (ProductQuantityUnit) FROM MV5103 WHERE MaterialID= @MaterialID AND MaterialGroupID=@MaterialGroupID) 

        IF @ProductQuantity <> 0
                SELECT @QuantityUnit = @MaterialQuantityUnit/@ProductQuantity, 
                       @ConvertedUnit = @MaterialConvertedUnit/@ProductQuantity
            ELSE                 
                SELECT @QuantityUnit = 0, @ConvertedUnit = 0

        IF ISNULL(@SumProductQuantity, 0) <> 0    
                SELECT @MaterialQuantityUnit = (ISNULL(@MaterialQuantity, 0)*ISNULL(@ProductQuantityUnit, 0)/ @SumProductQuantity), 
                       @MaterialConvertedUnit =round(ISNULL(@ConvertedAmount, 0)*ISNULL(@ProductQuantityUnit, 0)/ @SumProductQuantity, @ConvertedDecimal)
            ELSE  
                SELECT @MaterialQuantityUnit = 0, @MaterialConvertedUnit = 0 
*/

		SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
		Select MV6103.MaterialID, Sum(MV6103.MaterialQuantity), Isnull(SUM(@ProductQuantity * MT0007.CoValues),0), Isnull(SUM(ConvertedAmount),0)
		FROM MV6103 INNER JOIN MT0007 ON MT0007.DivisionID =MV6103.DivisionID AND MT0007.MaterialID =MV6103.MaterialID AND MT0007.MaterialGroupID = @MaterialGroupID
		GROUP BY MV6103.MaterialID
		HAVING Isnull(SUM(ConvertedAmount),0) - ISNULL((Select sum(ConvertedAmount) From MT0621 Where DivisionID = @DivisionID AND ExpenseID = 'COST001' And MaterialTypeID = @MaterialTypeID And MaterialID = MV6103.MaterialID),0) > 0
		        
		OPEN @ListMaterial_cur 
		FETCH NEXT FROM @ListMaterial_cur INTO  @ExtraMaterialID, @ExtraQuantity, @MaterialQuantity, @ConvertedAmount
		WHILE @@Fetch_Status = 0
			Begin		   				
				Select @SumProductQuantity = sum(MV5103.ProductQuantity * MT0007.CoValues)
				From MV5103 INNER JOIN MT0007 ON MT0007.DivisionID = MV5103.DivisionID AND MT0007.MaterialGroupID =MV5103.MaterialGroupID
				Where MT0007.MaterialID = @ExtraMaterialID
				
				IF ISNULL(@SumProductQuantity, 0) <> 0    
					SELECT	@MaterialQuantityUnit = (ISNULL(@ExtraQuantity, 0)*ISNULL(@MaterialQuantity, 0)/ @SumProductQuantity), 
							@MaterialConvertedUnit =round(ISNULL(@ConvertedAmount, 0)*ISNULL(@MaterialQuantity, 0)/ @SumProductQuantity, @ConvertedDecimal)
				ELSE  
					SELECT @MaterialQuantityUnit = 0, @MaterialConvertedUnit = 0
                
                IF @ProductQuantity <> 0
					SELECT @QuantityUnit = @MaterialQuantityUnit/@ProductQuantity, 
						   @ConvertedUnit = @MaterialConvertedUnit/@ProductQuantity
				ELSE                 
					SELECT @QuantityUnit = 0, @ConvertedUnit = 0


				IF (@MaterialConvertedUnit<>0 or @MaterialQuantityUnit<>0)
				begin
				Insert MT0621 (DivisionID, MaterialID, ProductID,  UnitID,     ExpenseID,  Quantity,  QuantityUnit,   MaterialTypeID,
					    			ConvertedAmount ,  ConvertedUnit,ProductQuantity, Rate  )
						Values (@DivisionID, @ExtraMaterialID, @ProductID,  @UnitID,   'COST001',   @MaterialQuantityUnit ,  @QuantityUnit ,   @MaterialTypeID,
					    			@MaterialConvertedUnit ,@ConvertedUnit ,    @ProductQuantity, Null)
				
				end

				FETCH NEXT FROM @ListMaterial_cur INTO  @ExtraMaterialID, @ExtraQuantity, @MaterialQuantity, @ConvertedAmount
			End
		Close @ListMaterial_cur
		
        FETCH NEXT FROM @Cur INTO  @MaterialGroupID, @MaterialID, @ProductID, @QuantityUnit, @ConvertedUnit, @ProductQuantity, @ProductQuantityUnit
    END
CLOSE @Cur
*/

/*
---- Phan giam chi phi gia thanh

SET @sSQL='
SELECT InventoryID AS MaterialID, 
    SUM(ISNULL(ConvertedAMount, 0)) AS ConvertedAmount, 
     SUM(ISNULL(Quantity, 0)) AS MaterialQuantity
FROM MV9000 INNER JOIN MT0700 ON MV9000.CreditAccountID=MT0700.AccountID
WHERE     PeriodID = N'''+@PeriodID+''' AND
    DivisionID = N'''+@DivisionID+''' AND
    ExpenseID =''COST001'' AND
    MaterialTypeID =N'''+@MaterialTypeID+'''  
GROUP BY InventoryID '

---Print @sSQL
IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV6103' AND Xtype ='V')
    EXEC ('CREATE VIEW MV6103 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV6103 AS '+@sSQL)


----- Buoc 3: Duyet tung nguyen vat lieu va phan bo chi phi cho chung


    SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 

    SELECT MV5103.MaterialID, MV5103.ProductID, MV6103.ConvertedAmount, 
        MV6103.MaterialQuantity,     
        MV5103.ProductQuantity,     
        MV5103.ProductQuantityUnit, MV5103.ProductConvertedUnit, 
        SumProductQuantity = (select SUM (ISNULL(ProductQuantityUnit, 0)) FROM MV5103 M03
                WHERE M03.MaterialID = MV6103.MaterialID), 
        SumProductConverted = (select SUM (ISNULL(ProductConvertedUnit, 0)) FROM MV5103 M03
                WHERE M03.MaterialID = MV6103.MaterialID)
    FROM MV5103 INNER JOIN  MV6103 ON MV5103.MaterialID = MV6103.MaterialID 
    OPEN @ListMaterial_cur 
    FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @ProductID, @ConvertedAmount, 
                @MaterialQuantity, @ProductQuantity, @ProductQuantityUnit, @ProductConvertedUnit, @SumProductQuantity, @SumProductConverted
    
        WHILE @@Fetch_Status = 0
        Begin    
            IF @SumProductQuantity <> 0    
                SET     @MaterialQuantityUnit = (@MaterialQuantity*@ProductQuantityUnit/ @SumProductQuantity)
            ELSE  
                SET     @MaterialQuantityUnit = 0
            IF  @SumProductConverted <> 0 
                SET      @MaterialConvertedUnit =(@ConvertedAmount*@ProductConvertedUnit/ @SumProductConverted)
            ELSE 
                SET  @SumProductConverted = 0 

            IF @ProductQuantity <> 0
                Begin
                    SET  @QuantityUnit = @MaterialQuantityUnit/@ProductQuantity 
                    SET @ConvertedUnit = @MaterialConvertedUnit/@ProductQuantity
                END 
            ELSE 
                Begin 
                    SET  @QuantityUnit = 0 
                    SET @ConvertedUnit = 0
                END 
    
            

            Update MT0621 SET  Quantity=Quantity-@MaterialQuantityUnit, ConvertedAmount= ConvertedAmount-@ConvertedAmount, ProductQuantity=ProductQuantity-@ProductQuantity, QuantityUnit=QuantityUnit-@QuantityUnit, ConvertedUnit=ConvertedUnit-@ConvertedUnit
                WHERE MaterialID=@MaterialID AND ProductID=@ProductID AND  ExpenseID='COST001'  AND  MaterialTypeID=@MaterialTypeID 
        

            FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @ProductID, @ConvertedAmount, 
                @MaterialQuantity, @ProductQuantity, @ProductQuantityUnit, @ProductConvertedUnit, @SumProductQuantity, @SumProductConverted
    
        END            
CLOSE @ListMaterial_cur
*/

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
