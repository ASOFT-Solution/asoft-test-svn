IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8130]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP8130]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Xử lý Import số dư đầu kỳ hàng tồn kho
---- Create on 27/09/2013 by Khánh Vân
---- Modified by Thanh Sơn on 10/12/2014: Chuyển các trường số không nhập thành giá trị 0
---- Modified by Thanh Sơn on 18/02/2015: Chuyển phần làm tròn số lẻ theo thiết lập thông tin công ty bên CI
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ, tiền hạch toán theo thiết lập đơn vị-chi nhánh
CREATE PROCEDURE AP8130
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
	VoucherID NVARCHAR(50) NULL,
	TransactionID NVARCHAR(50),
	ImportMessage NVARCHAR(500) DEFAULT (''),
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
		X.Data.query('VoucherDate').value('.', 'DATETIME') AS PurchaseDate,
		X.Data.query('ObjectID').value('.', 'NVARCHAR(50)') AS ObjectID,
		X.Data.query('WareHouseID').value('.', 'NVARCHAR(50)') AS WareHouseID,
		X.Data.query('InventoryTypeID').value('.', 'NVARCHAR(50)') AS InventoryTypeID,
		X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') AS EmployeeID,
		X.Data.query('Description').value('.', 'NVARCHAR(250)') AS Description,		
		X.Data.query('BarCode').value('.', 'NVARCHAR(50)') AS BarCode,		
		X.Data.query('InventoryID').value('.', 'NVARCHAR(50)') AS InventoryID,
		X.Data.query('UnitID').value('.', 'NVARCHAR(50)') AS UnitID,
		(CASE WHEN X.Data.query('Parameter01').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('Parameter01').value('.', 'DECIMAL(28,8)') END) AS Parameter01,
		(CASE WHEN X.Data.query('Parameter02').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('Parameter02').value('.', 'DECIMAL(28,8)') END) AS Parameter02,
		(CASE WHEN X.Data.query('Parameter03').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('Parameter03').value('.', 'DECIMAL(28,8)') END) AS Parameter03,
		(CASE WHEN X.Data.query('Parameter04').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('Parameter04').value('.', 'DECIMAL(28,8)') END) AS Parameter04,
		(CASE WHEN X.Data.query('ActualQuantity').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('ActualQuantity').value('.', 'DECIMAL(28,8)') END) AS ActualQuantity,
		(CASE WHEN X.Data.query('ConvertedQuantity').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('ConvertedQuantity').value('.', 'DECIMAL(28,8)') END) AS ConvertedQuantity,
		(CASE WHEN X.Data.query('UnitPrice').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('UnitPrice').value('.', 'DECIMAL(28,8)') END) AS UnitPrice,
		(CASE WHEN X.Data.query('OriginalAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('OriginalAmount').value('.', 'DECIMAL(28,8)') END) AS OriginalAmount,
		(CASE WHEN X.Data.query('MarkQuantity').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('MarkQuantity').value('.', 'DECIMAL(28,8)') END) AS MarkQuantity,
		X.Data.query('SourceNo').value('.', 'NVARCHAR(50)') AS SourceNo,
		X.Data.query('LimitDate').value('.', 'DATETIME') AS LimitDate,
		X.Data.query('DebitAccountID').value('.', 'NVARCHAR(50)') AS DebitAccountID,
		X.Data.query('CreditAccountID').value('.', 'NVARCHAR(50)') AS CreditAccountID,
		X.Data.query('Notes').value('.', 'NVARCHAR(250)') AS Notes,
		X.Data.query('Ana01ID').value('.', 'NVARCHAR(50)') AS Ana01ID,
		X.Data.query('Ana02ID').value('.', 'NVARCHAR(50)') AS Ana02ID,
		X.Data.query('Ana03ID').value('.', 'NVARCHAR(50)') AS Ana03ID,
		X.Data.query('Ana04ID').value('.', 'NVARCHAR(50)') AS Ana04ID,
		X.Data.query('Ana05ID').value('.', 'NVARCHAR(50)') AS Ana05ID,
		X.Data.query('Ana06ID').value('.', 'NVARCHAR(50)') AS Ana06ID,
		X.Data.query('Ana07ID').value('.', 'NVARCHAR(50)') AS Ana07ID,
		X.Data.query('Ana08ID').value('.', 'NVARCHAR(50)') AS Ana08ID,
		X.Data.query('Ana09ID').value('.', 'NVARCHAR(50)') AS Ana09ID,
		X.Data.query('Ana10ID').value('.', 'NVARCHAR(50)') AS Ana10ID,		
		X.Data.query('PeriodID').value('.', 'NVARCHAR(50)') AS PeriodID,
		X.Data.query('ProductID').value('.', 'NVARCHAR(50)') AS ProductID
INTO	#AP8130		
FROM	@XML.nodes('//Data') AS X (Data)

INSERT INTO #Data ([Row], DivisionID, Period, VoucherTypeID, VoucherNo, VoucherDate, ObjectID, WareHouseID,
InventoryTypeID, EmployeeID, [Description], BarCode, InventoryID, UnitID, Parameter01, Parameter02, Parameter03,
Parameter04, ActualQuantity, ConvertedQuantity, UnitPrice, OriginalAmount, MarkQuantity, SourceNo, LimitDate,
DebitAccountID, CreditAccountID, Notes, Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID,
Ana09ID, Ana10ID, PeriodID, ProductID)
SELECT * FROM #AP8130

---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

---- Kiểm tra dữ liệu không đồng nhất tại phần master
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues', @Module = 'ASOFT-WM', @ColID = 'VoucherNo', @Param1 = 'VoucherNo,VoucherDate,RefNo01,RefNo02,ObjectID,WareHouseID,InventoryTypeID,EmployeeID,Description'

--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai --> Sửa lại lấy theo thiết lập số lẻ bên CI (thông tin công ty)
DECLARE @QuantityDecimals TINYINT, @ConvertedDecimals TINYINT, @UnitCostDecimals TINYINT

SELECT @QuantityDecimals = QuantityDecimals, @ConvertedDecimals = ConvertedDecimals, @UnitCostDecimals = UnitCostDecimals
FROM AT1101 WHERE DivisionID = @DivisionID

UPDATE		DT
SET			OriginalAmount = ROUND(OriginalAmount, @ConvertedDecimals),
			ActualQuantity = ROUND(DT.ActualQuantity, @QuantityDecimals),	
			ConvertedQuantity = ROUND(DT.ConvertedQuantity, @ConvertedDecimals),
			MarkQuantity = ROUND(DT.MarkQuantity, @QuantityDecimals),
			UnitPrice = ROUND(DT.UnitPrice, @UnitCostDecimals),	
			VoucherDate = CASE WHEN VoucherDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), VoucherDate, 101)) END,
			LimitDate = CASE WHEN LimitDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), LimitDate, 101)) END
FROM		#Data DT

			
-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT
	
-- Sinh khóa
DECLARE @cKey AS CURSOR
DECLARE @Row AS INT,
		@Orders AS INT,
		@VoucherNo AS NVARCHAR(50),
		@Period AS NVARCHAR(50),
		@VoucherGroup AS NVARCHAR(50),
    	@TransID AS NVARCHAR(50),
		@VoucherID AS NVARCHAR(50),
		@CurrencyID AS NVARCHAR(50)			

SET @cKey = CURSOR SCROLL KEYSET FOR
	SELECT [Row], VoucherNo, Period FROM #Data
		
OPEN @cKey
FETCH NEXT FROM @cKey INTO @Row, @VoucherNo, @Period
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT (@VoucherGroup)
	PRINT (@VoucherNo)
	SET @Period = RIGHT(@Period, 4)
	IF @VoucherGroup IS NULL OR @VoucherGroup <> (@VoucherNo + '#' + @Period)
	BEGIN
		SET @Orders = 0
		EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @VoucherID OUTPUT, @TableName = 'AT2016', @StringKey1 = 'AB', @StringKey2 = @Period, @OutputLen = 16
		SET @VoucherGroup = (@VoucherNo + '#' + @Period)
	END
	SET @Orders = @Orders + 1
	EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @TransID OUTPUT, @TableName = 'AT2017', @StringKey1 = 'BB', @StringKey2 = @Period, @OutputLen = 16
	INSERT INTO #Keys (Row, Orders, VoucherID, TransactionID) VALUES (@Row, @Orders, @VoucherID, @TransID)				
	FETCH NEXT FROM @cKey INTO @Row, @VoucherNo, @Period
END	
CLOSE @cKey

-- Cập nhật khóa
UPDATE DT SET Orders = K.Orders, DT.VoucherID = K.VoucherID , DT.TransactionID = K.TransactionID			
FROM #Data DT INNER JOIN #Keys K ON	K.Row = DT.Row
-- Cập nhật Loại tiền
SET @CurrencyID = (SELECT TOP 1 BaseCurrencyID FROM AT1101 WHERE DivisionID = @DivisionID)
				
-- Kiểm tra trùng số chứng từ
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckDuplicateOtherVoucherNo',
	@ColID = 'VoucherNo', @Param2 = 'AT2016', @Param3 = 'VoucherNo'

-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-- Đẩy dữ liệu vào bảng master
INSERT INTO AT2016 (DivisionID,	VoucherID, TranMonth, TranYear, VoucherTypeID, VoucherDate,	VoucherNo, ObjectID,	
	WareHouseID, [Status], EmployeeID, [Description], CreateDate, CreateUserID,	LastModifyUserID, LastModifyDate)
SELECT DISTINCT DivisionID, VoucherID, LEFT(Period, 2),	RIGHT(Period, 4), VoucherTypeID, VoucherDate, VoucherNo, ObjectID,						
	WareHouseID, 0, EmployeeID, [Description], GETDATE(), @UserID, @UserID,	GETDATE()	
FROM #Data

INSERT INTO AT2017 (DivisionID,	TransactionID, VoucherID, InventoryID, UnitID, ActualQuantity, UnitPrice, OriginalAmount,
	ConvertedAmount, Notes,	TranMonth, TranYear, CurrencyID, ExchangeRate, SourceNo, DebitAccountID, CreditAccountID,
	LimitDate, Orders, Ana01ID,	Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID,	Ana10ID,
	ConvertedQuantity, MarkQuantity, Parameter01, Parameter02, Parameter03, Parameter04)
SELECT	DivisionID,	TransactionID, VoucherID, InventoryID, UnitID, ActualQuantity, UnitPrice, OriginalAmount,
	OriginalAmount, Notes, LEFT(Period, 2),	RIGHT(Period, 4), @CurrencyID, 1, SourceNo,	DebitAccountID,	CreditAccountID,
	LimitDate, Orders, Ana01ID,	Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID,	Ana10ID,
	ConvertedQuantity, MarkQuantity, Parameter01, Parameter02, Parameter03, Parameter04
FROM #Data

LB_RESULT:
SELECT * FROM #Data

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
