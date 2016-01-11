IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0116]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0116]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Đổ nguồn cho màn hình 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 14/05/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 08/06/2012 by Bao Anh: Bo sung nhieu DVT
-- <Example>
---- EXEC OP0116 'AS', 'ADMIN'
CREATE PROCEDURE OP0116
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50)
	
) 
AS 

CREATE TABLE #TAM
(
	DivisionID NVARCHAR(50),
	UserID NVARCHAR(50),
	InventoryID NVARCHAR(50),
	InventoryName NVARCHAR(250),
	UnitID NVARCHAR(50),
	ID1 NVARCHAR(50),
	DetailID1 NVARCHAR(50),
	ConvertedUnitPrice1 DECIMAL(28,8),
	UnitPrice1 DECIMAL(28,8),
	ID2 NVARCHAR(50),
	DetailID2 NVARCHAR(50),
	ConvertedUnitPrice2 DECIMAL(28,8),
	UnitPrice2 DECIMAL(28,8),
	ID3 NVARCHAR(50),
	DetailID3 NVARCHAR(50),
	ConvertedUnitPrice3 DECIMAL(28,8),
	UnitPrice3 DECIMAL(28,8),
	ID4 NVARCHAR(50),
	DetailID4 NVARCHAR(50),
	ConvertedUnitPrice4 DECIMAL(28,8),
	UnitPrice4 DECIMAL(28,8),
	ID5 NVARCHAR(50),
	DetailID5 NVARCHAR(50),
	ConvertedUnitPrice5 DECIMAL(28,8),
	UnitPrice5 DECIMAL(28,8),
	ID6 NVARCHAR(50),
	DetailID6 NVARCHAR(50),
	ConvertedUnitPrice6 DECIMAL(28,8),
	UnitPrice6 DECIMAL(28,8),
	ID7 NVARCHAR(50),
	DetailID7 NVARCHAR(50),
	ConvertedUnitPrice7 DECIMAL(28,8),
	UnitPrice7 DECIMAL(28,8),
	ID8 NVARCHAR(50),
	DetailID8 NVARCHAR(50),
	ConvertedUnitPrice8 DECIMAL(28,8),
	UnitPrice8 DECIMAL(28,8),
	ID9 NVARCHAR(50),
	DetailID9 NVARCHAR(50),
	ConvertedUnitPrice9 DECIMAL(28,8),
	UnitPrice9 DECIMAL(28,8),
	ID10 NVARCHAR(50),
	DetailID10 NVARCHAR(50),
	ConvertedUnitPrice10 DECIMAL(28,8),
	UnitPrice10 DECIMAL(28,8),
	ConversionFactor DECIMAL(28,8),
	Operator TINYINT,
	DataType TINYINT,
	Locked TINYINT

	
)
INSERT INTO #TAM (DivisionID, UserID, InventoryID, InventoryName, UnitID)
SELECT	DISTINCT @DivisionID , @UserID , OT1302.InventoryID, AT1302.InventoryName, OT1302.UnitID
FROM		OT1302 
LEFT JOIN	AT1302  ON AT1302.DivisionID = OT1302.DivisionID AND AT1302.InventoryID = OT1302.InventoryID

WHERE		ID IN (	SELECT	AT0999.Str02 
					FROM	AT0999 
          			WHERE	UserID = @UserID 
          				AND AT0999.TransTypeID = @DivisionID 
          				AND AT0999.KeyID = 'OF0018')
          				

DECLARE @UnitPrice AS decimal(28, 8),
		@ID AS NVARCHAR(50),
		@InventoryID AS NVARCHAR(50),
		@DetailID AS NVARCHAR(50),
		@STT AS INT,
		@Max AS INT,
		@cur AS CURSOR,
		@UnitID AS nvarchar(50),
		@ConvertedUnitPrice AS decimal(28, 8),
		@ConversionFactor AS decimal(28, 8),
		@Operator AS TINYINT,
		@DataType AS TINYINT
		
SET @STT = 1

SET @Max = 0
SET @Max = (SELECT COUNT(ID) FROM OT1301)
IF @Max > 10
	SET @Max = 10

SET @cur = CURSOR SCROLL KEYSET FOR		
SELECT	OT1301.ID 
FROM	OT1301
WHERE	OT1301.ID IN (	SELECT	AT0999.Str02 
				FROM	AT0999 
          		WHERE	UserID = @UserID 
          				AND AT0999.TransTypeID = @DivisionID 
          				AND AT0999.KeyID = 'OF0018')
ORDER BY OT1301.FromDate DESC

OPEN @cur
	FETCH NEXT FROM @cur INTO  @ID

WHILE @@Fetch_Status = 0
BEGIN
	
	IF @STT = 1
	UPDATE #TAM
	SET ID1 = @ID
	
	IF @STT = 2
	UPDATE #TAM
	SET ID2 = @ID
	
	IF @STT = 3
	UPDATE #TAM
	SET ID3 = @ID
	
	IF @STT = 4
	UPDATE #TAM
	SET ID4 = @ID
	
	IF @STT = 5
	UPDATE #TAM
	SET ID5 = @ID
	
	IF @STT = 6
	UPDATE #TAM
	SET ID6 = @ID
	
	IF @STT = 7
	UPDATE #TAM
	SET ID7 = @ID
	
	IF @STT = 8
	UPDATE #TAM
	SET ID8 = @ID
	
	IF @STT = 9
	UPDATE #TAM
	SET ID9 = @ID
	
	IF @STT = 10
	UPDATE #TAM
	SET ID10 = @ID
	
	SET @STT = @STT + 1
	

	FETCH NEXT FROM @cur INTO  @ID
END
            
SET @cur = CURSOR SCROLL KEYSET FOR		
SELECT	OT1302.UnitPrice, OT1302.ID , OT1302.InventoryID, OT1302.DetailID, OT1302.UnitID, OT1302.ConvertedUnitPrice,
ISNULL(AT1309.ConversionFactor,1), ISNULL(AT1309.Operator,0), ISNULL(AT1309.DataType,0)
FROM	OT1302 
LEFT JOIN OT1301 ON OT1301.DivisionID = OT1302.DivisionID AND OT1301.ID = OT1302.ID
LEFT JOIN AT1309 ON OT1302.UnitID = AT1309.UnitID
And OT1302.InventoryID = AT1309.InventoryID
And OT1302.DivisionID = @DivisionID
WHERE	OT1302.ID IN (	SELECT	AT0999.Str02 
				FROM	AT0999 
          		WHERE	UserID = @UserID 
          				AND AT0999.TransTypeID = @DivisionID 
          				AND AT0999.KeyID = 'OF0018')
ORDER BY OT1301.FromDate DESC
OPEN @cur
	FETCH NEXT FROM @cur INTO @UnitPrice, @ID, @InventoryID, @DetailID, @UnitID, @ConvertedUnitPrice, @ConversionFactor, @Operator, @DataType

WHILE @@Fetch_Status = 0
BEGIN
	
	UPDATE	#TAM
	SET		UnitPrice1 = @UnitPrice,
			DetailID1 = @DetailID,
			ConvertedUnitPrice1 = @ConvertedUnitPrice
	WHERE	ID1 = @ID
			AND InventoryID = @InventoryID AND UnitID = @UnitID
			
	UPDATE	#TAM
	SET		UnitPrice2 = @UnitPrice,
			DetailID2 = @DetailID,
			ConvertedUnitPrice2 = @ConvertedUnitPrice
	WHERE	ID2 = @ID
			AND InventoryID = @InventoryID AND UnitID = @UnitID
			
	UPDATE	#TAM
	SET		UnitPrice3 = @UnitPrice,
			DetailID3 = @DetailID,
			ConvertedUnitPrice3 = @ConvertedUnitPrice
	WHERE	ID3 = @ID
			AND InventoryID = @InventoryID AND UnitID = @UnitID
			
	UPDATE	#TAM
	SET		UnitPrice4 = @UnitPrice,
			DetailID4 = @DetailID,
			ConvertedUnitPrice4 = @ConvertedUnitPrice
	WHERE	ID4 = @ID
			AND InventoryID = @InventoryID AND UnitID = @UnitID
			
	UPDATE	#TAM
	SET		UnitPrice5 = @UnitPrice,
			DetailID5 = @DetailID,
			ConvertedUnitPrice5 = @ConvertedUnitPrice
	WHERE	ID5 = @ID
			AND InventoryID = @InventoryID AND UnitID = @UnitID
			
	UPDATE	#TAM
	SET		UnitPrice6 = @UnitPrice,
			DetailID6 = @DetailID,
			ConvertedUnitPrice6 = @ConvertedUnitPrice
	WHERE	ID6 = @ID
			AND InventoryID = @InventoryID AND UnitID = @UnitID
			
	UPDATE	#TAM
	SET		UnitPrice7 = @UnitPrice,
			DetailID7 = @DetailID,
			ConvertedUnitPrice7 = @ConvertedUnitPrice
	WHERE	ID7 = @ID
			AND InventoryID = @InventoryID AND UnitID = @UnitID
			
	UPDATE	#TAM
	SET		UnitPrice8 = @UnitPrice,
			DetailID8 = @DetailID,
			ConvertedUnitPrice8 = @ConvertedUnitPrice
	WHERE	ID8 = @ID
			AND InventoryID = @InventoryID AND UnitID = @UnitID
			
	UPDATE	#TAM
	SET		UnitPrice9 = @UnitPrice,
			DetailID9 = @DetailID,
			ConvertedUnitPrice9 = @ConvertedUnitPrice
	WHERE	ID9 = @ID
			AND InventoryID = @InventoryID AND UnitID = @UnitID 
			
	UPDATE	#TAM
	SET		UnitPrice10 = @UnitPrice,
			DetailID10 = @DetailID,
			ConvertedUnitPrice10 = @ConvertedUnitPrice
	WHERE	ID10 = @ID
			AND InventoryID = @InventoryID AND UnitID = @UnitID
	
	UPDATE	#TAM
	SET		ConversionFactor = @ConversionFactor,
			Operator = @Operator,
			DataType = @DataType
	WHERE	InventoryID = @InventoryID AND UnitID = @UnitID
	
	FETCH NEXT FROM @cur INTO @UnitPrice, @ID, @InventoryID, @DetailID, @UnitID, @ConvertedUnitPrice, @ConversionFactor, @Operator, @DataType
END

UPDATE #TAM
SET	Locked = 1

SELECT * FROM #TAM 

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

