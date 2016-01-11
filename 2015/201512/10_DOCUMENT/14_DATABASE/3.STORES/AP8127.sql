IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8127]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8127]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Yêu cầu mua hàng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 10/06/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 02/07/2013 by Le Thi Thu Hien : Bo sung INSERT khoan muc khi khoan muc khong co , Bo kiem tra khoan muc (Khach hang DongQuang)
---- Modified on 08/07/2013 by Le Thi Thu Hien : Bo sung INSERT Disabled = 0, OrderType = 0
-- <Example>
---- 
CREATE PROCEDURE AP8127
(	@DivisionID AS NVARCHAR(50),
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
	TransactionID NVARCHAR(50),
	ImportMessage NVARCHAR(500) DEFAULT (''),
	ObjectName NVARCHAR(250),
	Address NVARCHAR(250),
	InventoryCommonName NVARCHAR(250),
	CONSTRAINT [PK_#Data] PRIMARY KEY CLUSTERED 
	(
		Row ASC
	) ON [PRIMARY]	
)

CREATE TABLE #Keys
(
	Row INT,
	Orders INT,
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
	SET @sSQL = 'ALTER TABLE #Data ADD ' + @ColID + ' ' + @ColSQLDataType + ' NULL'
	--PRINT @sSQL
	EXEC (@sSQL)
	FETCH NEXT FROM @cCURSOR INTO @ColID, @ColSQLDataType
END

SELECT	X.Data.query('Row').value('.', 'INT') AS Row,
		X.Data.query('DivisionID').value('.', 'NVARCHAR(50)') AS DivisionID,
		X.Data.query('Period').value('.', 'VARCHAR(10)') AS Period,
		X.Data.query('VoucherTypeID').value('.', 'NVARCHAR(50)') AS VoucherTypeID,
		X.Data.query('RequestNo').value('.', 'NVARCHAR(50)') AS RequestNo,
		X.Data.query('RequestDate').value('.', 'DATETIME') AS RequestDate,
		X.Data.query('ContractNo').value('.', 'NVARCHAR(50)') AS ContractNo,
		X.Data.query('ContractDate').value('.', 'DATETIME') AS ContractDate,
		X.Data.query('CurrencyID').value('.', 'NVARCHAR(50)') AS CurrencyID,
		X.Data.query('ExchangeRate').value('.', 'DECIMAL(28,8)') AS ExchangeRate,
		X.Data.query('ClassifyID').value('.', 'NVARCHAR(50)') AS ClassifyID,
		X.Data.query('Status').value('.', 'TINYINT') AS Status,
		X.Data.query('MasterShipDate').value('.', 'DATETIME') AS MasterShipDate,
		X.Data.query('InventoryTypeID').value('.', 'NVARCHAR(50)') AS InventoryTypeID,
		X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') AS EmployeeID,
		X.Data.query('Description').value('.', 'NVARCHAR(250)') AS Description,
		X.Data.query('ObjectID').value('.', 'NVARCHAR(50)') AS ObjectID,
		X.Data.query('DueDate').value('.', 'DATETIME') AS DueDate,
		X.Data.query('OrderAddress').value('.', 'NVARCHAR(250)') AS OrderAddress,
		X.Data.query('ReceivedAddress').value('.', 'NVARCHAR(250)') AS ReceivedAddress,
		X.Data.query('Transport').value('.', 'NVARCHAR(250)') AS Transport,
		X.Data.query('PaymentID').value('.', 'NVARCHAR(250)') AS PaymentTermID,
		X.Data.query('POAna01ID').value('.', 'NVARCHAR(250)') AS POAna01ID,
		X.Data.query('POAna02ID').value('.', 'NVARCHAR(250)') AS POAna02ID,
		X.Data.query('POAna03ID').value('.', 'NVARCHAR(250)') AS POAna03ID,
		X.Data.query('POAna04ID').value('.', 'NVARCHAR(250)') AS POAna04ID,
		X.Data.query('POAna05ID').value('.', 'NVARCHAR(250)') AS POAna05ID,
		X.Data.query('InventoryID').value('.', 'NVARCHAR(250)') AS InventoryID,
		X.Data.query('UnitID').value('.', 'NVARCHAR(250)') AS UnitID,
		X.Data.query('ConvertedQuantity').value('.', 'DECIMAL(28,8)') AS ConvertedQuantity,
		X.Data.query('ConvertedSaleprice').value('.', 'DECIMAL(28,8)') AS ConvertedSaleprice,
		X.Data.query('OrderQuantity').value('.', 'DECIMAL(28,8)') AS OrderQuantity,
		X.Data.query('RequestPrice').value('.', 'DECIMAL(28,8)') AS RequestPrice,
		X.Data.query('OriginalAmount').value('.', 'DECIMAL(28,8)') AS OriginalAmount,
		X.Data.query('ConvertedAmount').value('.', 'DECIMAL(28,8)') AS ConvertedAmount,
		X.Data.query('DiscountPercent').value('.', 'DECIMAL(28,8)') AS DiscountPercent,
		X.Data.query('DiscountOriginalAmount').value('.', 'DECIMAL(28,8)') AS DiscountOriginalAmount,
		X.Data.query('DiscountConvertedAmount').value('.', 'DECIMAL(28,8)') AS DiscountConvertedAmount,
		X.Data.query('VATPercent').value('.', 'DECIMAL(28,8)') AS VATPercent,
		X.Data.query('VATOriginalAmount').value('.', 'DECIMAL(28,8)') AS VATOriginalAmount,
		X.Data.query('VATConvertedAmount').value('.', 'DECIMAL(28,8)') AS VATConvertedAmount,
		X.Data.query('DetailDescription').value('.', 'NVARCHAR(250)') AS DetailDescription,
		X.Data.query('Finish').value('.', 'TINYINT') AS Finish,
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
		X.Data.query('Notes').value('.', 'NVARCHAR(50)') AS Notes,
		X.Data.query('Notes01').value('.', 'NVARCHAR(250)') AS Notes01,
		X.Data.query('Notes02').value('.', 'NVARCHAR(250)') AS Notes02


INTO	#AP8127		
FROM	@XML.nodes('//Data') AS X (Data)


INSERT INTO #Data (
		Row,
		DivisionID,
		Period,
		VoucherTypeID,
		RequestNo,
		RequestDate,
		ContractNo,
		ContractDate,
		CurrencyID,
		ExchangeRate,
		ClassifyID,
		[Status],
		MasterShipDate,
		InventoryTypeID,
		EmployeeID,
		[Description],
		ObjectID,
		DueDate,
		OrderAddress,
		ReceivedAddress,
		Transport,
		PaymentID,
		POAna01ID,
		POAna02ID,
		POAna03ID,
		POAna04ID,
		POAna05ID,
		InventoryID,
		UnitID,
		ConvertedQuantity,
		ConvertedSaleprice,
		OrderQuantity,
		RequestPrice,
		OriginalAmount,
		ConvertedAmount,
		DiscountPercent,
		DiscountOriginalAmount,
		DiscountConvertedAmount,
		VATPercent,
		VATOriginalAmount,
		VATConvertedAmount,
		DetailDescription,
		Finish,
		Ana01ID,
		Ana02ID,
		Ana03ID,
		Ana04ID,
		Ana05ID,
		Ana06ID,
		Ana07ID,
		Ana08ID,
		Ana09ID,
		Ana10ID,
		Notes,
		Notes01,
		Notes02
		)
SELECT * FROM #AP8127


---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

---- Kiểm tra dữ liệu không đồng nhất tại phần master
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues',@Module = 'ASOFT-OP', @ColID = 'RequestNo', @Param1 = 'RequestNo,RequestDate,ContractNo,ContractDate,CurrencyID,ExchangeRate,ClassifyID,MasterShipDate,InventoryTypeID,EmployeeID,Description,ObjectID,DueDate,OrderAddress,ReceivedAddress,Transport,PaymentID,POAna01ID,POAna02ID,POAna03ID,POAna04ID,POAna05ID'

---- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE		DT
SET			ConvertedAmount = ROUND(ConvertedAmount, CUR.ConvertedDecimals),
			OriginalAmount = ROUND(OriginalAmount, CUR.OriginalDecimal),
			DiscountConvertedAmount = ROUND(DiscountConvertedAmount, CUR.ConvertedDecimals),
			DiscountOriginalAmount = ROUND(DiscountOriginalAmount, CUR.OriginalDecimal),

			VATConvertedAmount = ROUND(VATConvertedAmount, CUR.ConvertedDecimals),
			VATOriginalAmount = ROUND(VATOriginalAmount, CUR.OriginalDecimal),
			
			ConvertedQuantity = ROUND(DT.ConvertedQuantity, CUR.QuantityDecimals),		
			OrderQuantity = ROUND(DT.OrderQuantity, CUR.QuantityDecimals),	
			RequestPrice = ROUND(DT.RequestPrice, CUR.UnitCostDecimals),	
			ConvertedSaleprice = ROUND(DT.ConvertedSaleprice, CUR.UnitCostDecimals),	
			ExchangeRate = ROUND(DT.ExchangeRate, CUR.ExchangeRateDecimal)
			,			
			MasterShipDate = CASE WHEN MasterShipDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), MasterShipDate, 101)) END,
			RequestDate = CASE WHEN RequestDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), RequestDate, 101)) END,
			ContractDate = CASE WHEN ContractDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), ContractDate, 101)) END
FROM		#Data DT
INNER JOIN	AV1004 CUR
		ON	CUR.CurrencyID = DT.CurrencyID AND CUR.DivisionID = DT.DivisionID

-- Cập nhật tên và địa chỉ đối tượng
UPDATE		DT
SET			ObjectName = OB.ObjectName,
			Address = OB.Address 		
FROM		#Data DT
INNER JOIN	AT1202 OB
		ON	OB.ObjectID = DT.ObjectID AND OB.DivisionID = DT.DivisionID 

-- Cập nhật tên hàng hóa
UPDATE		DT
SET			InventoryCommonName = INV.InventoryName	
FROM		#Data DT
INNER JOIN	AT1302 INV
		ON	INV.InventoryID = DT.InventoryID AND INV.DivisionID = DT.DivisionID
			
-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT


-- Sinh khóa
DECLARE @cKey AS CURSOR
DECLARE @Row AS INT,
		@Orders AS INT,
		@RequestNo AS NVARCHAR(50),
		@Period AS NVARCHAR(50),
		@RequestGroup AS NVARCHAR(50)

DECLARE	@TransID AS NVARCHAR(50)			

SET @cKey = CURSOR FOR
	SELECT	Row, RequestNo, Period
	FROM	#Data
		
OPEN @cKey
FETCH NEXT FROM @cKey INTO @Row, @RequestNo, @Period
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @Period = RIGHT(@Period, 4)
	IF @RequestGroup IS NULL OR @RequestGroup <> @RequestNo
	BEGIN
		SET @Orders = 0
		SET @RequestGroup = @RequestNo
	END
	SET @Orders = @Orders + 1
	EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @TransID OUTPUT, @TableName = 'OT3002', @StringKey1 = 'OT', @StringKey2 = @Period, @OutputLen = 16
	INSERT INTO #Keys (Row, Orders, TransactionID) VALUES (@Row, @Orders, @TransID)				
	FETCH NEXT FROM @cKey INTO @Row, @RequestNo, @Period
END	
CLOSE @cKey

-- Cập nhật khóa
UPDATE		DT
SET			Orders = K.Orders,
			DT.TransactionID = K.TransactionID			
FROM		#Data DT
INNER JOIN	#Keys K
		ON	K.Row = DT.Row
		
				
-- Kiểm tra trùng số chứng từ
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckDuplicateOtherVoucherNo', @ColID = 'RequestNo', @Param2 = 'OT3101', @Param3 = 'VoucherNo'

-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-- Đẩy dữ liệu vào bảng master
INSERT INTO OT3101
(		DivisionID,		TranMonth,		TranYear,
		VoucherTypeID,	VoucherNo,		ROrderID,		OrderDate,
		ContractNo,		ContractDate,
		ClassifyID,		OrderStatus,	ShipDate,
		CurrencyID,		ExchangeRate,
		InventoryTypeID,EmployeeID,		[Description],
		ObjectID,		DueDate,		[Address],		ReceivedAddress,
		Transport,		PaymentID,
		Ana01ID,		Ana02ID,		Ana03ID,		Ana04ID,		Ana05ID,
		CreateUserID,	Createdate,		LastModifyUserID,				LastModifyDate,
		[Disabled],		OrderType
)
SELECT	DISTINCT
		DivisionID,		LEFT(Period, 2),RIGHT(Period, 4),
		VoucherTypeID,	RequestNo,		RequestNo,		RequestDate,
		ContractNo,		ContractDate,
		ClassifyID,		[Status],		MasterShipDate,
		CurrencyID,		ExchangeRate,
		InventoryTypeID,EmployeeID,		[Description],
		ObjectID,		DueDate,		OrderAddress,	ReceivedAddress,
		Transport,		PaymentID,		
		POAna01ID,		POAna02ID,		POAna03ID,		POAna04ID,		POAna05ID,
		@UserID,		GETDATE(),		@UserID,		GETDATE(),
		0,				0
FROM	#Data

INSERT INTO OT3102
(
	DivisionID,				TransactionID,				ROrderID,				Orders,
	InventoryID,			UnitID,
	ConvertedQuantity,		ConvertedSaleprice,
	OrderQuantity,			RequestPrice,
	OriginalAmount,			ConvertedAmount,
	DiscountPercent,		DiscountOriginalAmount,		DiscountConvertedAmount,
	VATPercent,				VATOriginalAmount,			VATConvertedAmount,				
	Description,			Finish,
	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
	Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
	Notes,		Notes01,	Notes02	

)
SELECT	
	DivisionID,				TransactionID,				RequestNo,				Orders,
	InventoryID,			UnitID,
	ConvertedQuantity,		ConvertedSaleprice,
	OrderQuantity,			RequestPrice,
	OriginalAmount,			ConvertedAmount,
	DiscountPercent,		DiscountOriginalAmount,		DiscountConvertedAmount,
	VATPercent,				VATOriginalAmount,			VATConvertedAmount,
	DetailDescription,		Finish,		
	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
	Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
	Notes,		Notes01,	Notes02
FROM	#Data

----------- INSERT khoan muc

DECLARE @AnaCur AS CURSOR
DECLARE @Ana01ID NVARCHAR(50),
		@Ana02ID NVARCHAR(50),
		@Ana03ID NVARCHAR(50),
		@Ana04ID NVARCHAR(50),
		@Ana05ID NVARCHAR(50),
		@Ana06ID NVARCHAR(50),
		@Ana07ID NVARCHAR(50),
		@Ana08ID NVARCHAR(50),
		@Ana09ID NVARCHAR(50),
		@Ana10ID NVARCHAR(50)
		

SET @AnaCur = CURSOR FOR
	SELECT	Row , Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
			Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID
	FROM	#Data
		
OPEN @AnaCur
FETCH NEXT FROM @AnaCur INTO 	@Row, @Ana01ID,	@Ana02ID,	@Ana03ID,	@Ana04ID,	@Ana05ID,
							@Ana06ID,	@Ana07ID,	@Ana08ID,	@Ana09ID,	@Ana10ID
WHILE @@FETCH_STATUS = 0
BEGIN
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE AnaTypeID = 'A01' AND AnaID = @Ana01ID AND DivisionID = @DivisionID)
	INSERT INTO AT1011 (DivisionID, AnaTypeID, AnaID, AnaName,
			CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
	VALUES (@DivisionID, 'A01', @Ana01ID, @Ana01ID,
			@UserID, GETDATE(), @UserID, GETDATE())
			
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE AnaTypeID = 'A02' AND AnaID = @Ana02ID AND DivisionID = @DivisionID)
	INSERT INTO AT1011 (DivisionID, AnaTypeID, AnaID, AnaName,
			CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
	VALUES (@DivisionID, 'A02', @Ana02ID, @Ana02ID,
			@UserID, GETDATE(), @UserID, GETDATE())

	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE AnaTypeID = 'A03' AND AnaID = @Ana03ID AND DivisionID = @DivisionID)
	INSERT INTO AT1011 (DivisionID, AnaTypeID, AnaID, AnaName,
			CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
	VALUES (@DivisionID, 'A03', @Ana03ID, @Ana03ID,
			@UserID, GETDATE(), @UserID, GETDATE())
			
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE AnaTypeID = 'A04' AND AnaID = @Ana04ID AND DivisionID = @DivisionID)
	INSERT INTO AT1011 (DivisionID, AnaTypeID, AnaID, AnaName,
			CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
	VALUES (@DivisionID, 'A04', @Ana04ID, @Ana04ID,
			@UserID, GETDATE(), @UserID, GETDATE())

	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE AnaTypeID = 'A05' AND AnaID = @Ana05ID AND DivisionID = @DivisionID)
	INSERT INTO AT1011 (DivisionID, AnaTypeID, AnaID, AnaName,
			CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
	VALUES (@DivisionID, 'A05', @Ana05ID, @Ana05ID,
			@UserID, GETDATE(), @UserID, GETDATE())
			
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE AnaTypeID = 'A06' AND AnaID = @Ana06ID AND DivisionID = @DivisionID)
	INSERT INTO AT1011 (DivisionID, AnaTypeID, AnaID, AnaName,
			CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
	VALUES (@DivisionID, 'A06', @Ana06ID, @Ana06ID,
			@UserID, GETDATE(), @UserID, GETDATE())

	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE AnaTypeID = 'A07' AND AnaID = @Ana07ID AND DivisionID = @DivisionID)
	INSERT INTO AT1011 (DivisionID, AnaTypeID, AnaID, AnaName,
			CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
	VALUES (@DivisionID, 'A07', @Ana07ID, @Ana07ID,
			@UserID, GETDATE(), @UserID, GETDATE())
			
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE AnaTypeID = 'A08' AND AnaID = @Ana08ID AND DivisionID = @DivisionID)
	INSERT INTO AT1011 (DivisionID, AnaTypeID, AnaID, AnaName,
			CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
	VALUES (@DivisionID, 'A08', @Ana08ID, @Ana08ID,
			@UserID, GETDATE(), @UserID, GETDATE())
			
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE AnaTypeID = 'A09' AND AnaID = @Ana09ID AND DivisionID = @DivisionID)
	INSERT INTO AT1011 (DivisionID, AnaTypeID, AnaID, AnaName,
			CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
	VALUES (@DivisionID, 'A09', @Ana09ID, @Ana09ID,
			@UserID, GETDATE(), @UserID, GETDATE())
			
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE AnaTypeID = 'A10' AND AnaID = @Ana10ID AND DivisionID = @DivisionID)
	INSERT INTO AT1011 (DivisionID, AnaTypeID, AnaID, AnaName,
			CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
	VALUES (@DivisionID, 'A10', @Ana10ID, @Ana10ID,
			@UserID, GETDATE(), @UserID, GETDATE())

				
	FETCH NEXT FROM @AnaCur INTO @Row ,@Ana01ID,	@Ana02ID,	@Ana03ID,	@Ana04ID,	@Ana05ID,
								@Ana06ID,	@Ana07ID,	@Ana08ID,	@Ana09ID,	@Ana10ID
END	
CLOSE @AnaCur


LB_RESULT:
SELECT * FROM #Data

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

