IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0137_1]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0137_1]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 -- <Summary>
 --- 
 -- <Param>
 ---- Thực hiện load dữ liệu đối chiếu kho
 -- <Return>
 ----
 -- <Reference>
 ----
 -- <History>
 ---- Created by: Thanh Sơn on: 16/07/2015
 ---- Modified on 
 -- <Example>
 /*
 	 OP0137_1 'PL', '', 'ES/01/2015/0002', 'K01', '3F25AE74-E85D-41E0-B7F6-C55361CF2648', 1
 */
 
  CREATE PROCEDURE OP0137_1
 (
 	@DivisionID VARCHAR(50),
 	@UserID VARCHAR(50),
 	@EstimateID VARCHAR(50),
 	@WareHouseID VARCHAR(50), -- Kho chọn lại
 	@APK VARCHAR(50), -- APK của dòng thay đổi
 	@Mode TINYINT -- 1: Gợi ý lần đầu, 2: Người dùng chọn lại kho
 )
 AS
DECLARE @Cur CURSOR, @Cur1 CURSOR, @Cur2 CURSOR,
		@ReadyQuantity DECIMAL(28,8), @CompareQuantity DECIMAL(28,8), @WareHouseID1 VARCHAR(50),
		@MaterialID VARCHAR(50), @MaterialQuantity DECIMAL(28,8), @Level TINYINT, @ApportionID VARCHAR(50),
		@MaterialID2 VARCHAR(50), @MaterialQuantity2 DECIMAL(28,8), @ProductQuantity DECIMAL(28,8)
		
IF @Mode = 1 -- Gợi ý lần đầu
BEGIN		
	IF EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[OV2504_2]') AND TYPE IN (N'U')) DROP TABLE OV2504_2
	EXEC OP2504_1 @DivisionID, @UserID, @EstimateID

	IF EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[DOICHIEU]') AND TYPE IN (N'U')) DROP TABLE DOICHIEU		
	CREATE TABLE DOICHIEU  -- Danh sách B.T.Phẩm cần đối chiếu
		(
			APK VARCHAR(50),
			DivisionID VARCHAR(50),
			MaterialID VARCHAR(50),
			MaterialQuantity DECIMAL(28,8),
			WareHouseID VARCHAR(50),
			BookingQuantity DECIMAL(28,8),
			CompareQuantity DECIMAL(28,8),
			ProductTypeID TINYINT,
			[Level] TINYINT,
			ApportionID VARCHAR(50)
		)
	INSERT INTO DOICHIEU (APK, DivisionID, MaterialID, MaterialQuantity, ProductTypeID, [Level], ApportionID)
	SELECT NEWID(), @DivisionID, O03.MaterialID, SUM(ISNULL(O03.MaterialQuantity,0)), (SELECT TOP 1 ProductTypeID FROM AT1302 WHERE DivisionID = @DivisionID AND InventoryID = MaterialID),
		MIN(O03.[Level]) [Level], O03.ApportionID
	FROM OT2203 O03
	WHERE DivisionID = @DivisionID AND EstimateID = @EstimateID AND ExpenseID = 'COST001'
	AND ISNULL((SELECT TOP 1 ProductTypeID FROM AT1302 WHERE DivisionID = @DivisionID AND InventoryID = MaterialID),0) IN (2,3)
	GROUP BY MaterialID, O03.ApportionID
	
	IF EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[TONKHO]') AND TYPE IN (N'U')) DROP TABLE TONKHO		
	CREATE TABLE TONKHO --Danh sách mặt hàng tồn kho của phiếu yêu dự trù cần đối chiếu
		(
			InventoryID VARCHAR(50),
			ReadyQuantity DECIMAL(28,8),
			WareHouseID VARCHAR(50)
		)
	INSERT INTO TONKHO (InventoryID, ReadyQuantity, WareHouseID)
	SELECT InventoryID, ReadyQuantity, (SELECT TOP 1 WareHouseID FROM OV2504_2 WHERE InventoryID = A.InventoryID AND ReadyQuantity = A.ReadyQuantity)
	FROM (SELECT InventoryID, MAX(ReadyQuantity) ReadyQuantity FROM OV2504_2 GROUP BY InventoryID) A
END

IF @Mode = 2 -- Người dùng chọn lại kho
BEGIN
	DECLARE @InventoryID VARCHAR(50), @NewReadyQuantity DECIMAL(28,8)
	SELECT @InventoryID = MaterialID FROM DOICHIEU WHERE APK = @APK
	SELECT @NewReadyQuantity = ReadyQuantity FROM OV2504_2 WHERE WareHouseID = @WareHouseID AND InventoryID = @InventoryID
	
	UPDATE TONKHO SET WareHouseID = @WareHouseID, ReadyQuantity = @NewReadyQuantity WHERE InventoryID = @InventoryID
	UPDATE DOICHIEU SET BookingQuantity = 0, CompareQuantity = 0
END

SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT MaterialID, MaterialQuantity FROM DOICHIEU ORDER BY [Level]

OPEN @Cur
FETCH NEXT FROM @Cur INTO @MaterialID, @MaterialQuantity
WHILE @@FETCH_STATUS = 0
BEGIN
	IF EXISTS (SELECT TOP 1 1 FROM OV2504_2 WHERE InventoryID = @MaterialID AND ReadyQuantity > 0)
	BEGIN
		SET @ReadyQuantity = ISNULL((SELECT TOP 1 ReadyQuantity FROM TONKHO WHERE InventoryID = @MaterialID),0)
		SET @WareHouseID1 = (SELECT TOP 1 WareHouseID FROM TONKHO WHERE InventoryID = @MaterialID)
		IF @MaterialQuantity >= @ReadyQuantity
			UPDATE DOICHIEU SET WareHouseID = @WareHouseID1, BookingQuantity = @ReadyQuantity, CompareQuantity = @ReadyQuantity WHERE MaterialID = @MaterialID
		ELSE
			UPDATE DOICHIEU SET WareHouseID = @WareHouseID1, BookingQuantity = @MaterialQuantity, CompareQuantity = @MaterialQuantity WHERE MaterialID = @MaterialID
	END
	FETCH NEXT FROM @Cur INTO @MaterialID, @MaterialQuantity
END
CLOSE @Cur

---- Kiểm tra lượng hàng tồn dựa vào bộ định mức BOM
SET @Level = 1
ReturnCur1:

IF EXISTS (SELECT TOP 1 1 FROM DOICHIEU WHERE ISNULL(CompareQuantity,0) > 0 AND ProductTypeID = 2 AND [Level] = @Level)
BEGIN
	SET @Cur1 = CURSOR SCROLL KEYSET FOR
	SELECT MaterialID, CompareQuantity, ApportionID FROM DOICHIEU
	WHERE ISNULL(CompareQuantity,0) > 0 AND ProductTypeID = 2 AND [Level] = @Level
	ORDER BY [Level]

	OPEN @Cur1
	FETCH NEXT FROM @Cur1 INTO @MaterialID, @CompareQuantity, @ApportionID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Cur2 = CURSOR SCROLL KEYSET FOR
		SELECT MaterialID, MaterialQuantity, ProductQuantity
		FROM MT1603 WHERE DivisionID = @DivisionID AND ApportionID = @ApportionID AND ProductID = @MaterialID
		OPEN @Cur2
		FETCH NEXT FROM @Cur2 INTO @MaterialID2, @MaterialQuantity2, @ProductQuantity
		WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE DOICHIEU SET CompareQuantity = ISNULL(CompareQuantity,0) + @MaterialQuantity2 * @CompareQuantity / @ProductQuantity
			WHERE MaterialID = @MaterialID2
			FETCH NEXT FROM @Cur2 INTO @MaterialID2, @MaterialQuantity2, @ProductQuantity
		END
		CLOSE @Cur2
		FETCH NEXT FROM @Cur1 INTO @MaterialID, @CompareQuantity, @ApportionID
	END
	CLOSE @Cur1
END
SET @Level = @Level + 1
IF @Level <= (SELECT MAX([Level]) FROM DOICHIEU) GOTO ReturnCur1

SELECT DC.APK, DC.DivisionID, DC.MaterialID, DC.MaterialQuantity, DC.WareHouseID, A02.InventoryName MaterialName,
    DC.BookingQuantity, DC.CompareQuantity, DC.ProductTypeID MaterialTypeID, DC.[Level], DC.ApportionID, 
	CASE WHEN MaterialQuantity >= ISNULL(CompareQuantity, 0) THEN MaterialQuantity - ISNULL(CompareQuantity, 0) ELSE 0 END SuggestQuantity,
	AV2.ENDQuantity, AV2.SQuantity, AV2.PQuantity, AV2.ReadyQuantity, A02.UnitID, A04.UnitName
FROM DOICHIEU DC
LEFT JOIN AT1302 A02 ON A02.DivisionID = DC.DivisionID AND A02.InventoryID = DC.MaterialID
LEFT JOIN AT1304 A04 ON A04.DivisionID = A02.DivisionID AND A04.UnitID = A02.UnitID
LEFT JOIN OV2504_2 AV2 ON AV2.WareHouseID = DC.WareHouseID AND AV2.InventoryID = DC.MaterialID
ORDER BY [Level]

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
