IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8121]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8121]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Xử lý Import dữ liệu kiểm kê
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 31/10/2011 by Nguyễn Bình Minh
---- Modified on 08/10/2015 by Tieu Mai: Sửa tiền hạch toán theo thiết lập đơn vị-chi nhánh
---- Modified on 10/12/2015 by Phương Thảo : bổ sung gọi store tự động sinh phiếu điều chỉnh
-- <Example>
---- 
CREATE PROCEDURE [DBO].[AP8121]
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),	
	@ImportTemplateID AS NVARCHAR(50),
	@XML AS XML
) 
AS
DECLARE @cCURSOR AS CURSOR,
		@sSQL AS VARCHAR(1000),
		@BaseCurrencyID AS NVARCHAR(50)
		
DECLARE @ColID AS NVARCHAR(50), 
		@ColSQLDataType AS NVARCHAR(50)
		
CREATE TABLE #Data
(
	Row INT,	
	ImportMessage NVARCHAR(500) DEFAULT (''),
	Orders INT, -- Số thứ tự dòng
	VoucherID NVARCHAR(50) NULL,
	TransactionID NVARCHAR(50) NULL,
	UnitID NVARCHAR(50) NULL,
	Quantity DECIMAL(28,8) NULL,			
	UnitPrice DECIMAL(28,8) NULL,
	OriginalAmount DECIMAL(28,8) NULL,
	ConvertedAmount DECIMAL(28,8) NULL,
	CONSTRAINT [PK_#Data] PRIMARY KEY CLUSTERED 
	(
		Row ASC
	) ON [PRIMARY]	
)

CREATE TABLE #Keys
(
	Row INT,
	Orders INT,
	VoucherID NVARCHAR(50),
	TransactionID NVARCHAR(50),	
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
	PRINT @sSQL
	EXEC (@sSQL)
	FETCH NEXT FROM @cCURSOR INTO @ColID, @ColSQLDataType
END

SELECT	X.Data.query('Row').value('.', 'INT') AS Row,
		X.Data.query('DivisionID').value('.', 'NVARCHAR(50)') AS DivisionID,
		X.Data.query('Period').value('.', 'VARCHAR(10)') AS Period,
		X.Data.query('VoucherTypeID').value('.', 'NVARCHAR(50)') AS VoucherTypeID,
		X.Data.query('VoucherNo').value('.', 'NVARCHAR(50)') AS VoucherNo,
		X.Data.query('VoucherDate').value('.', 'DATETIME') AS VoucherDate,
		X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') AS EmployeeID,
		X.Data.query('WareHouseID').value('.', 'NVARCHAR(50)') AS WareHouseID,
		X.Data.query('Description').value('.', 'NVARCHAR(250)') AS Description,
		X.Data.query('InventoryID').value('.', 'NVARCHAR(50)') AS InventoryID,
		X.Data.query('SourceNo').value('.', 'NVARCHAR(50)') AS SourceNo,
		X.Data.query('DebitAccountID').value('.', 'NVARCHAR(50)') AS DebitAccountID,
		X.Data.query('AdjustQuantity').value('.', 'DECIMAL(28,8)') AS AdjustQuantity,
		X.Data.query('AdjustUnitPrice').value('.', 'DECIMAL(28,8)') AS AdjustUnitPrice,
		X.Data.query('AdjutsOriginalAmount').value('.', 'DECIMAL(28,8)') AS AdjutsOriginalAmount,
		X.Data.query('Notes').value('.', 'NVARCHAR(250)') AS Notes
INTO	#AP8121		
FROM	@XML.nodes('//Data') AS X (Data)

INSERT INTO #Data (
		Row,				DivisionID,			Period,				VoucherTypeID,			VoucherNo,		VoucherDate,
		EmployeeID,			WareHouseID,		Description,		InventoryID,			SourceNo,
		DebitAccountID,		AdjustQuantity,		AdjustUnitPrice,	AdjutsOriginalAmount,	Notes)
SELECT	AB.Row, AB.DivisionID ,AB.Period ,AB.VoucherTypeID ,AB.VoucherNo ,AB.VoucherDate ,
		AB.EmployeeID, AB.WareHouseID ,AB.Description ,CASE  WHEN DATA.DivisionID IS NULL THEN  AB.InventoryID ELSE DATA.InventoryID END [InventoryID],
		AB.SourceNo ,AB.DebitAccountID ,AB.AdjustQuantity ,AB.AdjustUnitPrice ,AB.AdjutsOriginalAmount ,AB.Notes 
	FROM #AP8121 AB
	LEFT JOIN (	SELECT CASE WHEN charindex(char(10),InventoryID,0) >0 
							THEN RTRIM(LTRIM(LEFT(InventoryID,charindex(char(10),InventoryID,0) -2)))
							ELSE RTRIM(LTRIM(InventoryID)) END InventoryID_Text, 
						InventoryID,DivisionID
				   FROM AT1302 ) DATA 
		ON AB.InventoryID = DATA.InventoryID_Text and AB.DivisionID = DATA.DivisionID
		
---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

---- Kiểm tra dữ liệu không đồng nhất tại phần phiếu
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues', @ColID = 'VoucherNo', @Param1 = 'VoucherNo,VoucherTypeID,VoucherDate,EmployeeID,WareHouseID,Description'

SELECT	@BaseCurrencyID = BaseCurrencyID 
FROM	AT1101
WHERE	DivisionID = @DivisionID

--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE		DT
SET			AdjutsOriginalAmount = ROUND(DT.AdjutsOriginalAmount, CUR.ConvertedDecimals),
			AdjustQuantity = ROUND(DT.AdjustQuantity, CUR.QuantityDecimals),
			AdjustUnitPrice = ROUND(DT.AdjustUnitPrice, CUR.UnitCostDecimals),
			VoucherDate = CONVERT(datetime, CONVERT(varchar(10), VoucherDate, 101))
FROM		#Data DT
INNER JOIN	AV1004 CUR 
		ON	CUR.CurrencyID = @BaseCurrencyID AND CUR.DivisionID = DT.DivisionID

-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-- Sinh khóa
DECLARE @cKey AS CURSOR
DECLARE @Row AS INT,
		@Orders AS INT,
		@VoucherNo AS NVARCHAR(50),
		@Period AS NVARCHAR(50),
		@OVoucherGroup AS NVARCHAR(50)

DECLARE	@VoucherID AS NVARCHAR(50),
		@TransID AS NVARCHAR(50)			

SET @cKey = CURSOR FOR
	SELECT	Row, Period, VoucherNo
	FROM	#Data
		
OPEN @cKey
FETCH NEXT FROM @cKey INTO @Row, @Period, @VoucherNo
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @Period = RIGHT(@Period, 4)
	IF @OVoucherGroup IS NULL OR @OVoucherGroup <> (@VoucherNo + '#' + @Period)
	BEGIN
		SET @Orders = 0
		EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @VoucherID OUTPUT, @TableName = 'AT2036', @StringKey1 = 'AJ', @StringKey2 = @Period, @OutputLen = 16
		SET @OVoucherGroup = (@VoucherNo + '#' + @Period)
	END
	SET @Orders = @Orders + 1
	EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @TransID OUTPUT, @TableName = 'AT2037', @StringKey1 = 'RD', @StringKey2 = @Period, @OutputLen = 16
	INSERT INTO #Keys (Row, Orders, VoucherID, TransactionID) VALUES (@Row, @Orders, @VoucherID, @TransID)				
	FETCH NEXT FROM @cKey INTO @Row, @Period, @VoucherNo
END	
CLOSE @cKey

-- Cập nhật khóa
UPDATE		DT
SET			Orders = K.Orders,
			VoucherID = K.VoucherID,
			DT.TransactionID = K.TransactionID			
FROM		#Data DT
INNER JOIN	#Keys K
		ON	K.Row = DT.Row

-- Kiểm tra trùng số chứng từ
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckDuplicateOtherVoucherNo', @ColID = 'VoucherNo', @Param1 = 'VoucherID', @Param2 = 'AT2036', @Param3 = 'VoucherNo' 

-- Nếu có lỗi thì không cập nhật giá trị thực tế kho
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

DECLARE @cWareHouse AS CURSOR
DECLARE @DivisionIDTmp AS NVARCHAR(50),
		@WareHouseID AS NVARCHAR(50),
		@FromInventoryID AS NVARCHAR(50),
		@ToInventoryID AS NVARCHAR(50),
		@Month AS TINYINT,
		@Year AS INT

SET @cWareHouse = CURSOR STATIC FOR
	SELECT		DivisionID, Period, WareHouseID, MIN(InventoryID) AS FromInventoryID, MAX(InventoryID) AS ToInventoryID
	FROM		#Data
	GROUP BY	DivisionID, WareHouseID, Period
OPEN @cWareHouse

FETCH NEXT FROM @cWareHouse INTO @DivisionIDTmp, @Period, @WareHouseID, @FromInventoryID, @ToInventoryID
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @Month = LEFT(@Period, 2), @Year = RIGHT(@Period, 4)
	EXEC AP2041 @DivisionID = @DivisionIDTmp, @WareHouseID = @WareHouseID, @FromInventoryID = @FromInventoryID, @ToInventoryID = @ToInventoryID, @Month = @Month, @Year =  @Year, @Date = NULL, @IsDate = 1
	UPDATE		DT
	SET			Quantity = ST.ActualQuantity,
				UnitID = ST.UnitID,
				UnitPrice = ST.UnitPrice,
				OriginalAmount = ST.OriginalAmount,
				ConvertedAmount = ST.ConvertedAmount,
				AdjustUnitPrice = ROUND(CASE WHEN AdjustUnitPrice = 0 THEN ST.UnitPrice ELSE AdjustUnitPrice END, CUR.UnitCostDecimals),
				AdjutsOriginalAmount =	ROUND(	CASE WHEN AdjutsOriginalAmount = 0 THEN 
													AdjustQuantity * ROUND(CASE WHEN AdjustUnitPrice = 0 THEN ST.UnitPrice ELSE AdjustUnitPrice END, CUR.UnitCostDecimals)
												ELSE AdjutsOriginalAmount END, CUR.ConvertedDecimals)
	FROM		#Data DT 
	INNER JOIN	AV2041 ST
			ON	ST.DivisionID = DT.DivisionID AND ST.InventoryID = DT.InventoryID 
				AND ISNULL(ST.SourceNo, '') = DT.SourceNo AND ST.DebitAccountID = DT.DebitAccountID
	INNER JOIN	AV1004 CUR 
			ON	CUR.CurrencyID = @BaseCurrencyID AND CUR.DivisionID = DT.DivisionID						
	FETCH NEXT FROM @cWareHouse INTO @DivisionIDTmp, @Period, @WareHouseID, @FromInventoryID, @ToInventoryID		
END		

-- Nếu không có dữ liệu cập nhật tương ứng, cập nhật lỗi
UPDATE	#Data
SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '' THEN '\n' ELSE '' END + 'ASML000095 {0}=''' + InventoryID + ''''
WHERE	UnitID IS NULL
	
-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT


-- Đẩy dữ liệu vào bảng Master
INSERT INTO AT2036
(			
	VoucherID,			
	DivisionID,			TranMonth,			TranYear,
	VoucherTypeID,		VoucherNo,			VoucherDate,
	EmployeeID,			WareHouseID,		Description,		Status,
	CreateDate,			CreateUserID,		LastModifyDate,		LastModifyUserID,
	TableID
)
SELECT	DISTINCT				
		VoucherID,
		DivisionID,			LEFT(Period, 2),	RIGHT(Period, 4),
		VoucherTypeID,		VoucherNo,			VoucherDate,		
		EmployeeID,			WareHouseID,		Description,		0,	
		GETDATE(),			@UserID,			GETDATE(),			@UserID,
		'AT2036'
FROM	#Data

-- Đẩy dữ liệu vào bảng Detail
INSERT INTO AT2037
(	
	APK,				Orders,
	VoucherID,			TransactionID,		ReTransactionID,		ReVoucherID,
	DivisionID,			TranMonth,			TranYear,
	DebitAccountID,		SourceNo,
	InventoryID,		UnitID,
	Quantity,			UnitPrice,			OriginalAmount,			ConvertedAmount,
	AdjustQuantity,		AdjustUnitPrice,	AdjutsOriginalAmount,	Notes, 
	isAdjust
)
SELECT	NEWID(),			Orders,
		VoucherID,			TransactionID,		'',					'',
		DivisionID,			LEFT(Period, 2),	RIGHT(Period, 4),
		DebitAccountID,		SourceNo,
		InventoryID,		UnitID,		
		Quantity,			UnitPrice,			OriginalAmount,			ConvertedAmount,
		AdjustQuantity,		AdjustUnitPrice,	AdjutsOriginalAmount,	Notes,
		0	
FROM	#Data


IF EXISTS (SELECT TOP 1 1 FROM WT0000 WHERE IsAutoCrAdjustVoucher = 1)
BEGIN

	DECLARE @cAdjust AS CURSOR,
			@cVoucherID NVarchar(50),
			@TranMonth Int, 
			@TranYear Int, 
			@CreateBy Datetime,
			@Result Int
			
	SET @cAdjust = CURSOR STATIC FOR
		SELECT		DISTINCT VoucherID, LEFT(Period, 2) AS TranMonth,	RIGHT(Period, 4) AS Tranyear, VoucherDate
		FROM		#Data

	OPEN @cAdjust

	FETCH NEXT FROM @cAdjust INTO @cVoucherID, @TranMonth, @TranYear, @CreateBy
	WHILE @@FETCH_STATUS = 0
	BEGIN

		EXEC [WP2018] @DivisionID, @cVoucherID, @TranMonth, @TranYear, @CreateBy, @Result, 1


	FETCH NEXT FROM @cAdjust INTO  @cVoucherID, @TranMonth, @TranYear, @CreateBy
	END
END

LB_RESULT:
SELECT * FROM #Data

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

