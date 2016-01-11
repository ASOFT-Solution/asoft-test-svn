IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8137]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8137]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Import Excel Bảng giá bán [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 26/12/2014 by Lê Thị Hạnh 
---- Modified on ... by 
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh
-- <Example>
/*
 AP8137 @DivisionID = 'VG', @UserID = 'ASOFTADMIN', @ImportTemplateID = '', @@XML = ''
 */
 
CREATE PROCEDURE AP8137
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),	
	@ImportTemplateID AS NVARCHAR(50),
	@XML AS XML
) 
AS
DECLARE @cCURSOR AS CURSOR,
		@sSQL AS VARCHAR(1000)
		
DECLARE @ColID AS NVARCHAR(50), 
		@ColSQLDataType AS NVARCHAR(50)
		
CREATE TABLE #Data
(
	APK UNIQUEIDENTIFIER DEFAULT(NEWID()),
	Row INT,
	Orders INT,
	DetailID NVARCHAR(50),
	ImportMessage NVARCHAR(MAX) DEFAULT (''),
	CONSTRAINT [PK_#Data] PRIMARY KEY CLUSTERED 
	(
		Row ASC
	) ON [PRIMARY]	
)

CREATE TABLE #Keys
(
	Row INT,	
	Orders INT,
	ID NVARCHAR(50),
	DetailID NVARCHAR(50),
	InventoryID NVARCHAR(50),
	UnitID NVARCHAR(50),
	CONSTRAINT [PK_#Keys] PRIMARY KEY CLUSTERED 
	(
		Row ASC
	) ON [PRIMARY]	
)

SET @cCURSOR = CURSOR STATIC FOR
	SELECT		TLD.ColID,
				BTL.ColSQLDataType
	FROM		A01065 TL
	INNER JOIN	A01066 TLD
			ON	TL.ImportTemplateID = TLD.ImportTemplateID
	INNER JOIN	A00065 BTL
			ON	BTL.ImportTransTypeID = TL.ImportTransTypeID AND BTL.ColID = TLD.ColID
	WHERE		TL.ImportTemplateID = @ImportTemplateID
	ORDER BY	TLD.OrderNum

OPEN @cCURSOR									
-- Tạo cấu trúc bảng tạm
FETCH NEXT FROM @cCURSOR INTO @ColID, @ColSQLDataType	
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @sSQL = 'ALTER TABLE #Data ADD ' + @ColID + ' ' + @ColSQLDataType + CASE WHEN @ColSQLDataType LIKE '%char%' THEN ' COLLATE SQL_Latin1_General_CP1_CI_AS' ELSE '' END + ' NULL'
	EXEC (@sSQL)
	FETCH NEXT FROM @cCURSOR INTO @ColID, @ColSQLDataType
END
-- Thêm dữ liệu vào bảng tạm
SELECT	X.Data.query('Row').value('.', 'INT') AS Row,
		X.Data.query('DivisionID').value('.', 'NVARCHAR(50)') AS DivisionID,
		X.Data.query('ID').value('.', 'NVARCHAR(50)') AS ID,
		X.Data.query('Description').value('.', 'NVARCHAR(250)') AS [Description],
		X.Data.query('FromDate').value('.', 'DATETIME') AS FromDate,
		(CASE WHEN X.Data.query('ToDate').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('ToDate').value('.', 'DATETIME') END) AS ToDate,
		--X.Data.query('ToDate').value('.', 'DATETIME') AS ToDate, '9999-12-31 23:59:59.997'
		(CASE WHEN X.Data.query('OID').value('.', 'NVARCHAR(50)') = '' THEN '%' ELSE X.Data.query('OID').value('.', 'NVARCHAR(50)') END) AS OID,
		(CASE WHEN X.Data.query('InventoryTypeID').value('.', 'NVARCHAR(50)') = '' THEN '%' ELSE X.Data.query('InventoryTypeID').value('.', 'NVARCHAR(50)') END) AS InventoryTypeID,
		X.Data.query('CurrencyID').value('.', 'NVARCHAR(50)') AS CurrencyID,
		(CASE WHEN X.Data.query('IsConvertedPrice').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('IsConvertedPrice').value('.', 'TINYINT') END) AS IsConvertedPrice,
		X.Data.query('InheritID').value('.', 'NVARCHAR(50)') AS InheritID,
		X.Data.query('InventoryID').value('.', 'NVARCHAR(50)') AS InventoryID,		
		X.Data.query('UnitID').value('.', 'NVARCHAR(50)') AS UnitID,
		(CASE WHEN X.Data.query('UnitPrice').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('UnitPrice').value('.', 'DECIMAL(28,8)') END) AS UnitPrice,
		(CASE WHEN X.Data.query('MinPrice').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('MinPrice').value('.', 'DECIMAL(28,8)') END) AS MinPrice,
		(CASE WHEN X.Data.query('MaxPrice').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('MaxPrice').value('.', 'DECIMAL(28,8)') END) AS MaxPrice,
		(CASE WHEN X.Data.query('ConvertedUnitPrice').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('ConvertedUnitPrice').value('.', 'DECIMAL(28,8)') END) AS ConvertedUnitPrice,
		(CASE WHEN X.Data.query('ConvertedMinPrice').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('ConvertedMinPrice').value('.', 'DECIMAL(28,8)') END) AS ConvertedMinPrice,
		(CASE WHEN X.Data.query('ConvertedMaxPrice').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('ConvertedMaxPrice').value('.', 'DECIMAL(28,8)') END) AS ConvertedMaxPrice,
		(CASE WHEN X.Data.query('DiscountPercent').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('DiscountPercent').value('.', 'DECIMAL(28,8)') END) AS DiscountPercent,
		(CASE WHEN X.Data.query('DiscountAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('DiscountAmount').value('.', 'DECIMAL(28,8)') END) AS DiscountAmount,
		(CASE WHEN X.Data.query('SaleOffPercent01').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('SaleOffPercent01').value('.', 'DECIMAL(28,8)') END) AS SaleOffPercent01,
		(CASE WHEN X.Data.query('SaleOffAmount01').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('SaleOffAmount01').value('.', 'DECIMAL(28,8)') END) AS SaleOffAmount01,
		(CASE WHEN X.Data.query('SaleOffPercent02').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('SaleOffPercent02').value('.', 'DECIMAL(28,8)') END) AS SaleOffPercent02,
		(CASE WHEN X.Data.query('SaleOffAmount02').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('SaleOffAmount02').value('.', 'DECIMAL(28,8)') END) AS SaleOffAmount02,
		(CASE WHEN X.Data.query('SaleOffPercent03').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('SaleOffPercent03').value('.', 'DECIMAL(28,8)')END) AS SaleOffPercent03,
		(CASE WHEN X.Data.query('SaleOffAmount03').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('SaleOffAmount03').value('.', 'DECIMAL(28,8)') END) AS SaleOffAmount03,
		(CASE WHEN X.Data.query('SaleOffPercent04').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('SaleOffPercent04').value('.', 'DECIMAL(28,8)')END) AS SaleOffPercent04,
		(CASE WHEN X.Data.query('SaleOffAmount04').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('SaleOffAmount04').value('.', 'DECIMAL(28,8)') END) AS SaleOffAmount04,
		(CASE WHEN X.Data.query('SaleOffPercent05').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('SaleOffPercent05').value('.', 'DECIMAL(28,8)') END) AS SaleOffPercent05,
		(CASE WHEN X.Data.query('SaleOffAmount05').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('SaleOffAmount05').value('.', 'DECIMAL(28,8)') END) AS SaleOffAmount05,
		X.Data.query('Notes').value('.', 'NVARCHAR(250)') AS Notes,
		X.Data.query('Notes01').value('.', 'NVARCHAR(250)') AS Notes01, 
		X.Data.query('Notes02').value('.', 'NVARCHAR(250)') AS Notes02
INTO	#AP8137	
FROM	@XML.nodes('//Data') AS X (Data)

INSERT INTO #Data ([Row], DivisionID, ID, [Description], FromDate, ToDate, OID, InventoryTypeID, CurrencyID, IsConvertedPrice,     
InheritID, InventoryID, UnitID, UnitPrice, MinPrice, MaxPrice, ConvertedUnitPrice, ConvertedMinPrice, ConvertedMaxPrice,
DiscountPercent, DiscountAmount, SaleOffPercent01, SaleOffAmount01, SaleOffPercent02, SaleOffAmount02, SaleOffPercent03, 
SaleOffAmount03, SaleOffPercent04, SaleOffAmount04, SaleOffPercent05, SaleOffAmount05, Notes, Notes01, Notes02)
SELECT * FROM #AP8137
ORDER BY ID, InventoryID, UnitID
---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID
----- Kiểm tra và lưu dữ liệu bảng giá bán
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues', @ColID = 'ID', @Param1 = 'DivisionID, ID, [Description], FromDate, ToDate, OID, InventoryTypeID, CurrencyID, IsConvertedPrice'
--EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckValidList', @ColID = 'ID', @Param1 = 'OT1301', @Param2 = 'InventoryTypeID', @Param3 = 'FromDate', @Param4 = 'ToDate', @Param5 = 'OID'
/*
DECLARE @Cur CURSOR,
		@Row INT,
		@TransactionID UNIQUEIDENTIFIER,
		@ID NVARCHAR(50),
		@FromDate DATETIME,
		@ToDate DATETIME,
		@OID NVARCHAR(50),
		@InventoryTypeID NVARCHAR(50),
		@InventoryID NVARCHAR(50),
		@UnitID NVARCHAR(50),
		@Message NVARCHAR(MAX) = '',
		@TestID NVARCHAR(50) = ''
SET @TransactionID = NEWID()
SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT [Row], DivisionID, ID, FromDate, ToDate, OID, InventoryTypeID, InventoryID, UnitID
FROM #Data
OPEN @Cur
FETCH NEXT FROM @Cur INTO @Row, @DivisionID, @ID, @FromDate, @ToDate, @OID, @InventoryTypeID, @InventoryID, @UnitID
WHILE @@FETCH_STATUS = 0
BEGIN
---- Kiểm tra trùng dữ liệu bảng giá
	IF (SELECT COUNT(ID) FROM #Data 
	    WHERE DivisionID = @DivisionID AND ID = @ID AND InventoryID = @InventoryID AND UnitID = @UnitID) > 1
	SET @Message = @Message + CASE WHEN ISNULL(@Message,'') <> '' THEN '\n' ELSE '' END + 'ASML000088 {0}= '''+CONVERT(VARCHAR,@Row)+''''

---- Kiểm tra bảng giá đã tồn tại hay chưa
	IF EXISTS (SELECT TOP 1 1 FROM OT1301 WHERE DivisionID = @DivisionID AND ID = @ID)
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM OT1302 
			          WHERE OT1302.DivisionID = @DivisionID AND OT1302.ID = @ID AND OT1302.InventoryID = @InventoryID AND OT1302.UnitID = @UnitID)
	    SET @Message = @Message + CASE WHEN ISNULL(@Message,'') <> '' THEN '\n' ELSE '' END + 'ASML000088 {0}= '''+CONVERT(VARCHAR,@Row)+''''
    END
	ELSE -- bảng giá chưa tồn tại
	BEGIN		
		SET @TestID = (STUFF((SELECT N', ' + ID FROM OT1301
		               WHERE DivisionID = @DivisionID AND OID LIKE @OID AND InventoryTypeID LIKE @InventoryTypeID AND (
					  (CONVERT(DATETIME,@FromDate,112) BETWEEN CONVERT(DATETIME,FromDate,112) AND CONVERT(DATETIME,ISNULL(ToDate,'9999-12-31 23:59:59.997'),112))
					OR
					  (CONVERT(DATETIME,@ToDate,112) BETWEEN CONVERT(DATETIME,FromDate,112) AND CONVERT(DATETIME,ISNULL(ToDate,'9999-12-31 23:59:59.997'),112))	
		               ) FOR XML PATH('')),1,2,N''))    
		/*
		SET @TestID = (SELECT TOP 1 ID FROM OT1301
		               WHERE DivisionID = @DivisionID AND OID LIKE @OID AND InventoryTypeID LIKE @InventoryTypeID AND (
					  (CONVERT(DATETIME,@FromDate,112) BETWEEN CONVERT(DATETIME,FromDate,112) AND CONVERT(DATETIME,ISNULL(ToDate,'9999-12-31 23:59:59.997'),112))
					OR
					  (CONVERT(DATETIME,@ToDate,112) BETWEEN CONVERT(DATETIME,FromDate,112) AND CONVERT(DATETIME,ISNULL(ToDate,'9999-12-31 23:59:59.997'),112))	
					  ))                
		*/
		IF ISNULL(@TestID,'') <> ''
		SET @Message = @Message + CASE WHEN ISNULL(@Message,'') <> '' THEN '\n' ELSE '' END + 'OFML000133 {0}= '''+CONVERT(NVARCHAR,@TestID)+''''
	END 
	IF ISNULL(@Message,'') <> ''
	UPDATE DT SET 
	ImportMessage = ImportMessage + CASE WHEN ImportMessage != '' THEN '\n' ELSE '' END + ''''+CONVERT(NVARCHAR,@Message)+''''
	FROM #Data DT
	WHERE DT.Row = @Row
FETCH NEXT FROM @Cur INTO @Row, @DivisionID, @ID, @FromDate, @ToDate, @OID, @InventoryTypeID, @InventoryID, @UnitID
END
CLOSE @Cur
*/
DECLARE @Cur CURSOR,
		@Row INT,
		@ID NVARCHAR(50),
		@FromDate DATETIME,
		@ToDate DATETIME,
		@OID NVARCHAR(50),
		@InventoryTypeID NVARCHAR(50),
		@InventoryID NVARCHAR(50),
		@UnitID NVARCHAR(50),
		@TestID NVARCHAR(50) = ''

SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT [Row], DivisionID, ID, FromDate, ToDate, OID, InventoryTypeID, InventoryID, UnitID
FROM #Data
OPEN @Cur
FETCH NEXT FROM @Cur INTO @Row, @DivisionID, @ID, @FromDate, @ToDate, @OID, @InventoryTypeID, @InventoryID, @UnitID
WHILE @@FETCH_STATUS = 0
BEGIN
---- Kiểm tra trùng dữ liệu bảng giá
	IF (SELECT COUNT(ID) FROM #Data 
	    WHERE DivisionID = @DivisionID AND ID = @ID AND InventoryID = @InventoryID AND UnitID = @UnitID) > 1
	BEGIN
		UPDATE DT SET 
		ImportMessage = ImportMessage + CASE WHEN ImportMessage != '' THEN '\n' ELSE '' END + 'ASML000088 {0}='''+CONVERT(VARCHAR,@Row)+''''
		FROM #Data DT
		WHERE DT.Row = @Row
	END	
---- Kiểm tra bảng giá đã tồn tại hay chưa
	IF EXISTS (SELECT TOP 1 1 FROM OT1301 WHERE DivisionID = @DivisionID AND ID = @ID)
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM OT1301 
		           WHERE DivisionID = @DivisionID AND ID = @ID AND 
		           (OID <> @OID OR InventoryTypeID <> @InventoryTypeID OR 
		            CONVERT(DATETIME,FromDate,112) <> CONVERT(DATETIME,@FromDate,112) OR 
		             CONVERT(DATETIME,ISNULL(ToDate,'9999-12-31 23:59:59.997'),112) <> CONVERT(DATETIME,ISNULL(@ToDate,'9999-12-31 23:59:59.997'),112)))
			BEGIN
				UPDATE DT SET 
				ImportMessage = ImportMessage + CASE WHEN ImportMessage != '' THEN '\n' ELSE '' END + 'OFML000008 {0}='''+CONVERT(NVARCHAR,@ID)+''''
				FROM #Data DT
				WHERE DT.Row = @Row
			END
			ELSE
			BEGIN
				UPDATE DT SET 
				ImportMessage = ImportMessage + CASE WHEN ImportMessage != '' THEN '\n' ELSE '' END + 'ASML000088 {0}='''+CONVERT(VARCHAR,@Row)+''''
				FROM #Data DT 
				WHERE DT.Row = @Row AND 
					  EXISTS (SELECT TOP 1 1 FROM OT1302 
							  WHERE OT1302.DivisionID = @DivisionID AND OT1302.ID = @ID AND OT1302.InventoryID = @InventoryID AND OT1302.UnitID = @UnitID)
	
			END
	END
	/*ELSE -- bảng giá chưa tồn tại
	BEGIN		
		SET @TestID = (STUFF((SELECT N', ' + ID FROM OT1301
		               WHERE DivisionID = @DivisionID AND OID LIKE @OID AND InventoryTypeID LIKE @InventoryTypeID AND (
					  (CONVERT(DATETIME,@FromDate,112) BETWEEN CONVERT(DATETIME,FromDate,112) AND CONVERT(DATETIME,ISNULL(ToDate,'9999-12-31 23:59:59.997'),112))
					OR
					  (CONVERT(DATETIME,ISNULL(@ToDate,'9999-12-31 23:59:59.997'),112) BETWEEN CONVERT(DATETIME,FromDate,112) AND CONVERT(DATETIME,ISNULL(ToDate,'9999-12-31 23:59:59.997'),112))	
		               ) FOR XML PATH('')),1,2,N''))    
		/*
		SET @TestID = (SELECT TOP 1 ID FROM OT1301
		               WHERE DivisionID = @DivisionID AND OID LIKE @OID AND InventoryTypeID LIKE @InventoryTypeID AND (
					  (CONVERT(DATETIME,@FromDate,112) BETWEEN CONVERT(DATETIME,FromDate,112) AND CONVERT(DATETIME,ISNULL(ToDate,'9999-12-31 23:59:59.997'),112))
					OR
					  (CONVERT(DATETIME,@ToDate,112) BETWEEN CONVERT(DATETIME,FromDate,112) AND CONVERT(DATETIME,ISNULL(ToDate,'9999-12-31 23:59:59.997'),112))	
					  ))                
		ASML000071 {0}=''''' + @ColumnName + '''''''
		*/
		UPDATE DT SET 
		ImportMessage = ImportMessage + CASE WHEN ImportMessage != '' THEN '\n' ELSE '' END + 'OFML000133 {0}='''+CONVERT(NVARCHAR,@TestID)+''''
		FROM #Data DT
		WHERE DT.Row = @Row AND ISNULL(@TestID,'') <> ''
	END
	*/ 
FETCH NEXT FROM @Cur INTO @Row, @DivisionID, @ID, @FromDate, @ToDate, @OID, @InventoryTypeID, @InventoryID, @UnitID
END
CLOSE @Cur	
-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage != '')
	GOTO LB_RESULT
--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE DT 
SET 
	FromDate = CASE WHEN DT.FromDate IS NOT NULL OR DT.FromDate != '' THEN CONVERT(DATETIME,DT.FromDate,114) END,
	ToDate = CASE WHEN DT.ToDate IS NOT NULL OR DT.ToDate != '' THEN CONVERT(DATETIME,DT.ToDate,114) ELSE NULL END,
	UnitPrice = ROUND(DT.UnitPrice,A.UnitCostDecimals),
	MinPrice = ROUND(DT.MinPrice,A.UnitCostDecimals),
	MaxPrice = ROUND(DT.MaxPrice,A.UnitCostDecimals),
	ConvertedUnitPrice = ROUND(DT.ConvertedUnitPrice,A.ConvertedDecimals),
	ConvertedMinPrice = ROUND(DT.ConvertedMinPrice,A.ConvertedDecimals),
	ConvertedMaxPrice = ROUND(DT.ConvertedMaxPrice,A.ConvertedDecimals),
	DiscountPercent = ROUND(DT.DiscountPercent,A.PercentDecimal),
	DiscountAmount = ROUND(DT.DiscountAmount,A.ConvertedDecimals),
	SaleOffPercent01 = ROUND(DT.SaleOffPercent01,A.PercentDecimal),
	SaleOffAmount01 = ROUND(DT.SaleOffAmount01,A.ConvertedDecimals),
	SaleOffPercent02 = ROUND(DT.SaleOffPercent02,A.PercentDecimal),
	SaleOffAmount02 = ROUND(DT.SaleOffAmount02,A.ConvertedDecimals),
	SaleOffPercent03 = ROUND(DT.SaleOffPercent03,A.PercentDecimal),
	SaleOffAmount03 = ROUND(DT.SaleOffAmount03,A.ConvertedDecimals),
	SaleOffPercent04 = ROUND(DT.SaleOffPercent04,A.PercentDecimal),
	SaleOffAmount04 = ROUND(DT.SaleOffAmount04,A.ConvertedDecimals),
	SaleOffPercent05 = ROUND(DT.SaleOffPercent05,A.PercentDecimal),
	SaleOffAmount05 = ROUND(DT.SaleOffAmount05,A.ConvertedDecimals),
	InheritID = CASE WHEN ISNULL(InheritID,'') != '' THEN DT.InheritID ELSE NULL END,
	Notes = CASE WHEN ISNULL(Notes,'') != '' THEN DT.Notes ELSE NULL END,
	Notes01 = CASE WHEN ISNULL(Notes01,'') != '' THEN DT.Notes01 ELSE NULL END,
	Notes02 = CASE WHEN ISNULL(Notes02,'') != '' THEN DT.Notes02 ELSE NULL END
FROM #Data DT
LEFT JOIN	AT1101 A ON A.DivisionID = DT.DivisionID

-- Sinh khoá
DECLARE @cKey AS CURSOR
DECLARE --@Row INT,
		@Orders INT,
	    @DetailID NVARCHAR(50)--,
	    --@ID NVARCHAR(50),
		--@InventoryID NVARCHAR(50),
		--@UnitID NVARCHAR(50),
	    --@TestID NVARCHAR(50)
SET @cKey = CURSOR SCROLL KEYSET FOR
			SELECT Row, ID, InventoryID, UnitID
			FROM #Data
OPEN @cKey
FETCH NEXT FROM @cKey INTO @Row, @ID, @InventoryID, @UnitID
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @TestID IS NULL OR @TestID != @ID
	BEGIN
		SET @Orders = 1
		SET @DetailID = NEWID()
		SET @TestID = @ID
	END
	ELSE 
	BEGIN
		SET @Orders = @Orders + 1
		SET @DetailID = NEWID()
	END
	INSERT INTO #Keys (Row, Orders, ID, DetailID, InventoryID, UnitID)
	VALUES (@Row, @Orders, @ID, @DetailID, @InventoryID, @UnitID)
	FETCH NEXT FROM @cKey INTO @Row, @ID, @InventoryID, @UnitID
END
CLOSE @cKey
----- Cập nhật khoá 
UPDATE DT
SET
	DT.Orders = K.Orders,
	DT.DetailID = K.DetailID
FROM #Data DT
INNER JOIN #Keys K ON K.Row = DT.Row

UPDATE		DT
SET			Orders = K.Orders,
			DT.ID = K.ID ,
			DT.DetailID = K.DetailID			
FROM		#Data DT
INNER JOIN	#Keys K
		ON	K.Row = DT.Row
-- Insert Master
INSERT INTO	OT1301 (DivisionID, ID, [Description], FromDate, ToDate, OID,
			InventoryTypeID, [Disabled], CurrencyID, InheritID,
			IsConvertedPrice, TypeID, CreateUserID, CreateDate,
			LastModifyUserID, LastModifyDate)
SELECT DISTINCT DivisionID, ID, [Description], FromDate, ToDate, OID, InventoryTypeID, 0, 
		CurrencyID, InheritID, IsConvertedPrice, 0, @UserID, GETDATE(), @UserID, GETDATE() 
FROM #Data DT 
WHERE DT.ID NOT IN (SELECT OT31.ID FROM OT1301 OT31 WHERE OT31.DivisionID = DT.DivisionID)
-- Insert Detail
INSERT INTO OT1302(DivisionID, ID, DetailID, InventoryID, UnitID, UnitPrice, MinPrice, MaxPrice, Orders, 
			DiscountPercent, DiscountAmount, SaleOffPercent01, SaleOffAmount01, SaleOffPercent02,
			SaleOffAmount02, SaleOffPercent03, SaleOffAmount03, SaleOffPercent04, SaleOffAmount04, 
			SaleOffPercent05, SaleOffAmount05, ConvertedUnitPrice, ConvertedMinPrice, ConvertedMaxPrice, 
			Notes, Notes01, Notes02)
SELECT DivisionID, ID, DetailID, InventoryID, UnitID, UnitPrice, MinPrice, MaxPrice, Orders, 
		DiscountPercent, DiscountAmount, SaleOffPercent01, SaleOffAmount01, SaleOffPercent02,
		SaleOffAmount02, SaleOffPercent03, SaleOffAmount03, SaleOffPercent04, SaleOffAmount04, 
		SaleOffPercent05, SaleOffAmount05, ConvertedUnitPrice, ConvertedMinPrice, ConvertedMaxPrice, 
		Notes, Notes01, Notes02
FROM #Data DT

-----------------------------------------------------------------------------------------
LB_RESULT:
SELECT * FROM #Data

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON