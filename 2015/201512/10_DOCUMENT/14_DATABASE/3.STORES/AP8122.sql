IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8122]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8122]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Xử lý Import phiếu mua hàng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 26/03/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 07/06/2013 by Lê Thị Thu Hiền : Bổ sung thêm 1 số trường
---- Mpdified on 15/04/2015 by Lê Thị Hạnh: Bổ sung convert dữ liệu import
-- <Example>
---- 
CREATE PROCEDURE [DBO].[AP8122]
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
	PRINT @sSQL
	EXEC (@sSQL)
	FETCH NEXT FROM @cCURSOR INTO @ColID, @ColSQLDataType
END

SELECT	X.Data.query('Row').value('.', 'INT') AS Row,
		X.Data.query('DivisionID').value('.', 'NVARCHAR(50)') AS DivisionID,
		X.Data.query('Period').value('.', 'VARCHAR(10)') AS Period,
		X.Data.query('VoucherTypeID').value('.', 'NVARCHAR(50)') AS VoucherTypeID,
		X.Data.query('PurchaseNo').value('.', 'NVARCHAR(50)') AS PurchaseNo,
		(CASE WHEN X.Data.query('PurchaseDate').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('PurchaseDate').value('.', 'DATETIME') END) AS PurchaseDate,
		X.Data.query('ContractNo').value('.', 'NVARCHAR(50)') AS ContractNo,
		(CASE WHEN X.Data.query('ContractDate').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('ContractDate').value('.', 'DATETIME') END) AS ContractDate,
		X.Data.query('CurrencyID').value('.', 'NVARCHAR(50)') AS CurrencyID,
		(CASE WHEN X.Data.query('ExchangeRate').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('ExchangeRate').value('.', 'DECIMAL(28,8)') END) AS ExchangeRate,
		X.Data.query('ClassifyID').value('.', 'NVARCHAR(50)') AS ClassifyID,
		(CASE WHEN X.Data.query('Status').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('Status').value('.', 'TINYINT') END) AS Status,
		(CASE WHEN X.Data.query('MasterShipDate').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('MasterShipDate').value('.', 'DATETIME') END) AS MasterShipDate,
		X.Data.query('InventoryTypeID').value('.', 'NVARCHAR(50)') AS InventoryTypeID,
		X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') AS EmployeeID,
		X.Data.query('Description').value('.', 'NVARCHAR(250)') AS Description,
		X.Data.query('ObjectID').value('.', 'NVARCHAR(50)') AS ObjectID,
		X.Data.query('TaxID').value('.', 'NVARCHAR(50)') AS TaxID,
		X.Data.query('DueDate').value('.', 'DATETIME') AS DueDate,
		X.Data.query('OrderAddress').value('.', 'NVARCHAR(250)') AS OrderAddress,
		X.Data.query('ReceivedAddress').value('.', 'NVARCHAR(250)') AS ReceivedAddress,
		X.Data.query('Transport').value('.', 'NVARCHAR(250)') AS Transport,
		X.Data.query('PaymentTermID').value('.', 'NVARCHAR(250)') AS PaymentTermID,
		X.Data.query('Varchar01').value('.', 'NVARCHAR(250)') AS Varchar01,
		X.Data.query('PaymentID').value('.', 'NVARCHAR(250)') AS PaymentID,
		X.Data.query('Varchar02').value('.', 'NVARCHAR(250)') AS Varchar02,
		X.Data.query('POAna01ID').value('.', 'NVARCHAR(250)') AS POAna01ID,
		X.Data.query('POAna02ID').value('.', 'NVARCHAR(250)') AS POAna02ID,
		X.Data.query('POAna03ID').value('.', 'NVARCHAR(250)') AS POAna03ID,
		X.Data.query('POAna04ID').value('.', 'NVARCHAR(250)') AS POAna04ID,
		X.Data.query('POAna05ID').value('.', 'NVARCHAR(250)') AS POAna05ID,
		X.Data.query('BarCode').value('.', 'NVARCHAR(250)') AS BarCode,
		X.Data.query('InventoryID').value('.', 'NVARCHAR(250)') AS InventoryID,
		X.Data.query('UnitID').value('.', 'NVARCHAR(250)') AS UnitID,
		(CASE WHEN X.Data.query('ConvertedQuantity').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('ConvertedQuantity').value('.', 'DECIMAL(28,8)') END) AS ConvertedQuantity,
		(CASE WHEN X.Data.query('ConvertedSaleprice').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('ConvertedSaleprice').value('.', 'DECIMAL(28,8)') END) AS ConvertedSaleprice,
		(CASE WHEN X.Data.query('OrderQuantity').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('OrderQuantity').value('.', 'DECIMAL(28,8)') END) AS OrderQuantity,
		(CASE WHEN X.Data.query('PurchasePrice').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('PurchasePrice').value('.', 'DECIMAL(28,8)') END) AS PurchasePrice,
		(CASE WHEN X.Data.query('OriginalAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('OriginalAmount').value('.', 'DECIMAL(28,8)') END) AS OriginalAmount,
		(CASE WHEN X.Data.query('ConvertedAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('ConvertedAmount').value('.', 'DECIMAL(28,8)') END) AS ConvertedAmount,
		(CASE WHEN X.Data.query('DiscountPercent').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('DiscountPercent').value('.', 'DECIMAL(28,8)') END) AS DiscountPercent,
		(CASE WHEN X.Data.query('DiscountOriginalAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('DiscountOriginalAmount').value('.', 'DECIMAL(28,8)') END) AS DiscountOriginalAmount,
		(CASE WHEN X.Data.query('DiscountConvertedAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('DiscountConvertedAmount').value('.', 'DECIMAL(28,8)') END) AS DiscountConvertedAmount,
		(CASE WHEN X.Data.query('VATPercent').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('VATPercent').value('.', 'DECIMAL(28,8)') END) AS VATPercent,
		(CASE WHEN X.Data.query('VATOriginalAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('VATOriginalAmount').value('.', 'DECIMAL(28,8)') END) AS VATOriginalAmount,
		(CASE WHEN X.Data.query('VATConvertedAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('VATConvertedAmount').value('.', 'DECIMAL(28,8)') END) AS VATConvertedAmount,
		(CASE WHEN X.Data.query('ImTaxPercent').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('ImTaxPercent').value('.', 'DECIMAL(28,8)') END) AS ImTaxPercent,
		(CASE WHEN X.Data.query('ImTaxOriginalAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('ImTaxOriginalAmount').value('.', 'DECIMAL(28,8)') END) AS ImTaxOriginalAmount,
		(CASE WHEN X.Data.query('ImTaxConvertedAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('ImTaxConvertedAmount').value('.', 'DECIMAL(28,8)') END) AS ImTaxConvertedAmount,
		(CASE WHEN X.Data.query('IsPicking').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('IsPicking').value('.', 'TINYINT') END) AS IsPicking,
		X.Data.query('WareHouseID').value('.', 'NVARCHAR(50)') AS WareHouseID,
		(CASE WHEN X.Data.query('Finish').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('Finish').value('.', 'TINYINT') END) AS Finish,
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
		X.Data.query('Notes02').value('.', 'NVARCHAR(250)') AS Notes02,
		X.Data.query('Notes03').value('.', 'NVARCHAR(250)') AS Notes03,
		X.Data.query('Notes04').value('.', 'NVARCHAR(250)') AS Notes04,
		X.Data.query('Notes05').value('.', 'NVARCHAR(250)') AS Notes05,
		X.Data.query('Notes06').value('.', 'NVARCHAR(250)') AS Notes06,
		X.Data.query('Notes07').value('.', 'NVARCHAR(250)') AS Notes07,
		X.Data.query('Notes08').value('.', 'NVARCHAR(250)') AS Notes08,
		X.Data.query('Notes09').value('.', 'NVARCHAR(250)') AS Notes09,		
		(CASE WHEN X.Data.query('DetailShipDate').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('DetailShipDate').value('.', 'DATETIME') END) AS DetailShipDate,
		X.Data.query('StrParameter01').value('.', 'NVARCHAR(250)') AS StrParameter01,	
		X.Data.query('StrParameter02').value('.', 'NVARCHAR(250)') AS StrParameter02,
		X.Data.query('StrParameter03').value('.', 'NVARCHAR(250)') AS StrParameter03,
		X.Data.query('StrParameter04').value('.', 'NVARCHAR(250)') AS StrParameter04,
		X.Data.query('StrParameter05').value('.', 'NVARCHAR(250)') AS StrParameter05,
		X.Data.query('StrParameter06').value('.', 'NVARCHAR(250)') AS StrParameter06,
		X.Data.query('StrParameter07').value('.', 'NVARCHAR(250)') AS StrParameter07,
		X.Data.query('StrParameter08').value('.', 'NVARCHAR(250)') AS StrParameter08,
		X.Data.query('StrParameter09').value('.', 'NVARCHAR(250)') AS StrParameter09,
		X.Data.query('StrParameter10').value('.', 'NVARCHAR(250)') AS StrParameter10,
		X.Data.query('StrParameter11').value('.', 'NVARCHAR(250)') AS StrParameter11,	
		X.Data.query('StrParameter12').value('.', 'NVARCHAR(250)') AS StrParameter12,
		X.Data.query('StrParameter13').value('.', 'NVARCHAR(250)') AS StrParameter13,
		X.Data.query('StrParameter14').value('.', 'NVARCHAR(250)') AS StrParameter14,
		X.Data.query('StrParameter15').value('.', 'NVARCHAR(250)') AS StrParameter15,
		X.Data.query('StrParameter16').value('.', 'NVARCHAR(250)') AS StrParameter16,
		X.Data.query('StrParameter17').value('.', 'NVARCHAR(250)') AS StrParameter17,
		X.Data.query('StrParameter18').value('.', 'NVARCHAR(250)') AS StrParameter18,
		X.Data.query('StrParameter19').value('.', 'NVARCHAR(250)') AS StrParameter19,
		X.Data.query('StrParameter20').value('.', 'NVARCHAR(250)') AS StrParameter20
INTO	#AP8122		
FROM	@XML.nodes('//Data') AS X (Data)


INSERT INTO #Data (
		Row,
		DivisionID,
		Period,
		VoucherTypeID,
		PurchaseNo,
		PurchaseDate,
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
		TaxID,
		DueDate,
		OrderAddress,
		ReceivedAddress,
		Transport,
		PaymentTermID,
		Varchar01,
		PaymentID,
		Varchar02,
		POAna01ID,
		POAna02ID,
		POAna03ID,
		POAna04ID,
		POAna05ID,
		BarCode,
		InventoryID,
		UnitID,
		ConvertedQuantity,
		ConvertedSaleprice,
		OrderQuantity,
		PurchasePrice,
		OriginalAmount,
		ConvertedAmount,
		DiscountPercent,
		DiscountOriginalAmount,
		DiscountConvertedAmount,
		VATPercent,
		VATOriginalAmount,
		VATConvertedAmount,
		ImTaxPercent,
		ImTaxOriginalAmount,
		ImTaxConvertedAmount,
		IsPicking,
		WareHouseID,
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
		Notes02,
		Notes03,
		Notes04,
		Notes05,
		Notes06,
		Notes07,
		Notes08,
		Notes09,
		DetailShipDate,
		StrParameter01,
		StrParameter02,
		StrParameter03,
		StrParameter04,
		StrParameter05,
		StrParameter06,
		StrParameter07,
		StrParameter08,
		StrParameter09,
		StrParameter10,
		StrParameter11,
		StrParameter12,
		StrParameter13,
		StrParameter14,
		StrParameter15,
		StrParameter16,
		StrParameter17,
		StrParameter18,
		StrParameter19,
		StrParameter20
		)
SELECT * FROM #AP8122


---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

---- Kiểm tra dữ liệu không đồng nhất tại phần master
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues', @ColID = 'PurchaseNo', @Param1 = 'PurchaseNo,PurchaseDate,ContractNo,ContractDate,CurrencyID,ExchangeRate,ClassifyID,MasterShipDate,InventoryTypeID,EmployeeID,Description,ObjectID,TaxID,DueDate,OrderAddress,ReceivedAddress,Transport,PaymentTermID,Varchar01,PaymentID,Varchar01,POAna01ID,POAna02ID,POAna03ID,POAna04ID,POAna05ID'

--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE		DT
SET			ConvertedAmount = ROUND(ConvertedAmount, CUR.ConvertedDecimals),
			OriginalAmount = ROUND(OriginalAmount, CUR.OriginalDecimal),
			DiscountConvertedAmount = ROUND(DiscountConvertedAmount, CUR.ConvertedDecimals),
			DiscountOriginalAmount = ROUND(DiscountOriginalAmount, CUR.OriginalDecimal),
			VATConvertedAmount = ROUND(VATConvertedAmount, CUR.ConvertedDecimals),
			VATOriginalAmount = ROUND(VATOriginalAmount, CUR.OriginalDecimal),
			ImTaxOriginalAmount	= ROUND(ImTaxOriginalAmount, CUR.OriginalDecimal),		
			ImTaxConvertedAmount = ROUND(ImTaxConvertedAmount, CUR.ConvertedDecimals),			
			ConvertedQuantity = ROUND(DT.ConvertedQuantity, CUR.QuantityDecimals),		
			OrderQuantity = ROUND(DT.OrderQuantity, CUR.QuantityDecimals),	
			PurchasePrice = ROUND(DT.PurchasePrice, CUR.UnitCostDecimals),	
			ConvertedSaleprice = ROUND(DT.ConvertedSaleprice, CUR.UnitCostDecimals),	
			ExchangeRate = ROUND(DT.ExchangeRate, CUR.ExchangeRateDecimal),			
			DetailShipDate = CASE WHEN DetailShipDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), DetailShipDate, 101)) END,
			MasterShipDate = CASE WHEN MasterShipDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), MasterShipDate, 101)) END,
			PurchaseDate = CASE WHEN PurchaseDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), PurchaseDate, 101)) END,
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
		@PurchaseNo AS NVARCHAR(50),
		@Period AS NVARCHAR(50),
		@PurchaseGroup AS NVARCHAR(50)

DECLARE	@TransID AS NVARCHAR(50)			

SET @cKey = CURSOR FOR
	SELECT	Row, PurchaseNo, Period
	FROM	#Data
		
OPEN @cKey
FETCH NEXT FROM @cKey INTO @Row, @PurchaseNo, @Period
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @Period = RIGHT(@Period, 4)
	IF @PurchaseGroup IS NULL OR @PurchaseGroup <> @PurchaseNo
	BEGIN
		SET @Orders = 0
		SET @PurchaseGroup = @PurchaseNo
	END
	SET @Orders = @Orders + 1
	EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @TransID OUTPUT, @TableName = 'OT3002', @StringKey1 = 'OT', @StringKey2 = @Period, @OutputLen = 16
	INSERT INTO #Keys (Row, Orders, TransactionID) VALUES (@Row, @Orders, @TransID)				
	FETCH NEXT FROM @cKey INTO @Row, @PurchaseNo, @Period
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
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckDuplicateOtherVoucherNo', @ColID = 'PurchaseNo', @Param2 = 'OT3001', @Param3 = 'VoucherNo'

-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-- Đẩy dữ liệu vào bảng master
INSERT INTO OT3001
(		DivisionID,		TranMonth,		TranYear,
		VoucherTypeID,	VoucherNo,		POrderID,		OrderDate,
		ContractNo,		ContractDate,
		ClassifyID,		OrderStatus,	ShipDate,
		CurrencyID,		ExchangeRate,
		InventoryTypeID,EmployeeID,		[Description],
		ObjectID,		VATNo,			DueDate,		[Address],		ReceivedAddress,
		Transport,		
		PaymentTermID,	Varchar01,
		PaymentID,		Varchar02,
		Ana01ID,		Ana02ID,		Ana03ID,		Ana04ID,		Ana05ID,
		CreateUserID,	Createdate,		LastModifyUserID,				LastModifyDate
)
SELECT	DISTINCT
		DivisionID,		LEFT(Period, 2),RIGHT(Period, 4),
		VoucherTypeID,	PurchaseNo,		PurchaseNo,		PurchaseDate,
		ContractNo,		ContractDate,
		ClassifyID,		[Status],		MasterShipDate,
		CurrencyID,		ExchangeRate,
		InventoryTypeID,EmployeeID,		[Description],
		ObjectID,		TaxID,			DueDate,		OrderAddress,	ReceivedAddress,
		Transport,
		PaymentTermID,	Varchar01,
		PaymentID,		Varchar02,
		POAna01ID,		POAna02ID,		POAna03ID,		POAna04ID,		POAna05ID,
		@UserID,		GETDATE(),		@UserID,		GETDATE()
FROM	#Data

INSERT INTO OT3002
(
	DivisionID,				TransactionID,				POrderID,				Orders,
	InventoryID,			UnitID,
	ConvertedQuantity,		ConvertedSaleprice,
	OrderQuantity,			PurchasePrice,
	OriginalAmount,			ConvertedAmount,
	DiscountPercent,		DiscountOriginalAmount,		DiscountConvertedAmount,
	VATPercent,				VATOriginalAmount,			VATConvertedAmount,
	ImTaxPercent,			ImTaxOriginalAmount,		ImTaxConvertedAmount,
	IsPicking,				WareHouseID,				Finish,
	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
	Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
	Notes,		Notes01,	Notes02,	Notes03,	Notes04,
	Notes05,	Notes06,	Notes07,	Notes08,Notes09,
	StrParameter01,	StrParameter02,	StrParameter03,	StrParameter04,	StrParameter05,
	StrParameter06,	StrParameter07,	StrParameter08,	StrParameter09,	StrParameter10,
	StrParameter11,	StrParameter12,	StrParameter13,	StrParameter14,	StrParameter15,
	StrParameter16,	StrParameter17,	StrParameter18,	StrParameter19,	StrParameter20,
	ShipDate

)
SELECT	
	DivisionID,				TransactionID,				PurchaseNo,				Orders,
	InventoryID,			UnitID,
	ConvertedQuantity,		ConvertedSaleprice,
	OrderQuantity,			PurchasePrice,
	OriginalAmount,			ConvertedAmount,
	DiscountPercent,		DiscountOriginalAmount,		DiscountConvertedAmount,
	VATPercent,				VATOriginalAmount,			VATConvertedAmount,
	ImTaxPercent,			ImTaxOriginalAmount,		ImTaxConvertedAmount,
	IsPicking,				WareHouseID,				Finish,		
	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
	Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
	Notes,		Notes01,	Notes02,	Notes03,	Notes04,
	Notes05,	Notes06,	Notes07,	Notes08,Notes09,
	StrParameter01,	StrParameter02,	StrParameter03,	StrParameter04,	StrParameter05,
	StrParameter06,	StrParameter07,	StrParameter08,	StrParameter09,	StrParameter10,
	StrParameter11,	StrParameter12,	StrParameter13,	StrParameter14,	StrParameter15,
	StrParameter16,	StrParameter17,	StrParameter18,	StrParameter19,	StrParameter20,
	DetailShipDate
FROM	#Data

LB_RESULT:
SELECT * FROM #Data

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

