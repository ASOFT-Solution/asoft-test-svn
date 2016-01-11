IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8123]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8123]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Xử lý Import phiếu nhập kho
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 20/06/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 21/12/2011 by 
 ----Modified on 20/03/2014 by Khanh Van: Sửa phần làm tròn số lẻ (theo thiết lập đơn vị)
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ, tiền hạch toán theo thiết lập đơn vị-chi nhánh
---- Modified on 18/11/2015 by Phuong Thao: Bo sung them thong tin don hang (so PO), cac thong tin hoa don va tu dong sinh HD mua hang
-- <Example>
---- 
CREATE PROCEDURE [DBO].[AP8123]
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
	POrders INT,
	PVoucherNo NVarchar(50),
	PVoucherID NVarchar(50),
	PTransactionID NVarchar(50),
	VATTransactionID NVarchar(50)
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
		X.Data.query('RefNo01').value('.', 'NVARCHAR(50)') AS RefNo01,
		X.Data.query('RefNo02').value('.', 'NVARCHAR(50)') AS RefNo02,
		X.Data.query('ObjectID').value('.', 'NVARCHAR(50)') AS ObjectID,
		X.Data.query('WareHouseID').value('.', 'NVARCHAR(50)') AS WareHouseID,
		X.Data.query('InventoryTypeID').value('.', 'NVARCHAR(50)') AS InventoryTypeID,
		X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') AS EmployeeID,
		X.Data.query('Description').value('.', 'NVARCHAR(250)') AS Description,		
		X.Data.query('BarCode').value('.', 'NVARCHAR(50)') AS BarCode,		
		X.Data.query('InventoryID').value('.', 'NVARCHAR(50)') AS InventoryID,
		X.Data.query('UnitID').value('.', 'NVARCHAR(50)') AS UnitID,
		X.Data.query('ActualQuantity').value('.', 'DECIMAL(28,8)') AS ActualQuantity,
		X.Data.query('UnitPrice').value('.', 'DECIMAL(28,8)') AS UnitPrice,
		X.Data.query('OriginalAmount').value('.', 'DECIMAL(28,8)') AS OriginalAmount,
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
		X.Data.query('ProductID').value('.', 'NVARCHAR(50)') AS ProductID,
		X.Data.query('PONo').value('.', 'NVARCHAR(50)') AS PONo,
		X.Data.query('PEmployeeID').value('.', 'NVARCHAR(50)') AS PEmployeeID,
		X.Data.query('InvoiceNo').value('.', 'NVARCHAR(50)') AS InvoiceNo,
		X.Data.query('Serial').value('.', 'NVARCHAR(50)') AS Serial,
		X.Data.query('CurrencyID').value('.', 'NVARCHAR(50)') AS CurrencyID,
		X.Data.query('ExchangeRate').value('.', 'NVARCHAR(50)') AS ExchangeRate
INTO	#AP8123		
FROM	@XML.nodes('//Data') AS X (Data)

INSERT INTO #Data (
		Row,
		DivisionID,
		Period,
		VoucherTypeID,
		VoucherNo,
		VoucherDate,
		RefNo01,
		RefNo02,
		ObjectID,
		WareHouseID,
		InventoryTypeID,
		EmployeeID,
		Description,
		BarCode,
		InventoryID,
		UnitID,
		ActualQuantity,
		UnitPrice,
		OriginalAmount,
		SourceNo,
		LimitDate,
		DebitAccountID,
		CreditAccountID,
		Notes,
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
		PeriodID,
		ProductID,
		PONo,
		PEmployeeID,
		InvoiceNo,
		Serial, 
		CurrencyID, 
		ExchangeRate
		)
SELECT *
FROM #AP8123


---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

---- Kiểm tra dữ liệu không đồng nhất tại phần master
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues', @Module = 'ASOFT-WM', @ColID = 'VoucherNo', @Param1 = 'VoucherNo,VoucherDate,RefNo01,RefNo02,ObjectID,WareHouseID,InventoryTypeID,EmployeeID,Description'


----------- Doan xu ly kiem tra du lieu co nhap thong tin Hoa Don de sinh tu dong phieu mua hang --------------
-- Kiem tra bat buoc nhap thong tin den hoa don Mua hang neu co nhap so HĐ
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckObligatoryInput', @Module = 'ASOFT-WM', @ColID = 'PEmployeeID', @Param1 = '',@Param2 =  '',@Param3 = '',@Param4 = '', @Param5 = '', @ObligeCheck = 0, @SQLWhere = 'ISNULL(InvoiceNo,'''')<>'''''
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckObligatoryInput', @Module = 'ASOFT-WM', @ColID = 'Serial', @Param1 = '',@Param2 =  '',@Param3 = '',@Param4 = '', @Param5 = '', @ObligeCheck = 0, @SQLWhere = 'ISNULL(InvoiceNo,'''')<>'''''
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckObligatoryInput', @Module = 'ASOFT-WM', @ColID = 'CurrencyID', @Param1 = '',@Param2 =  '',@Param3 = '',@Param4 = '', @Param5 = '', @ObligeCheck = 0, @SQLWhere = 'ISNULL(InvoiceNo,'''')<>'''''


-- Kiem tra loai tien
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckValidCurrency', @Module = 'ASOFT-WM', @ColID = 'CurrencyID', @Param1 = '',@Param2 =  '',@Param3 = '',@Param4 = '', @Param5 = '', @ObligeCheck = 0, @SQLWhere = 'ISNULL(InvoiceNo,'''')<>'''''

-- Kiem tra thong tin dong nhat cho hoa don Mua hang
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues', @Module = 'ASOFT-WM',@ColID = 'InvoiceNo', @Param1 = 'ObjectID,Serial,PEmployeeID,CurrencyID,ExchangeRate',@Param2 =  '',@Param3 = '',@Param4 = '', @Param5 = '', @ObligeCheck = 0, @SQLWhere = 'ISNULL(InvoiceNo,'''')<>'''''


--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE		DT
SET			OriginalAmount = ROUND(OriginalAmount, A.ConvertedDecimals),
			ActualQuantity = ROUND(DT.ActualQuantity, A.QuantityDecimals),	
			UnitPrice = ROUND(DT.UnitPrice, A.UnitCostDecimals),	
			VoucherDate = CASE WHEN VoucherDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), VoucherDate, 101)) END,
			LimitDate = CASE WHEN LimitDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), LimitDate, 101)) END
FROM		#Data DT
LEFT JOIN	AT1101 A ON A.DivisionID = DT.DivisionID
			
-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT


-- Sinh khóa
DECLARE @cKey AS CURSOR
DECLARE @Row AS INT,
		@Orders AS INT,
		@VoucherNo AS NVARCHAR(50),
		@Period AS NVARCHAR(50),
		@VoucherGroup AS NVARCHAR(50)

DECLARE	@TransID AS NVARCHAR(50),
		@VoucherID AS NVARCHAR(50),
		@CurrencyID AS NVARCHAR(50)			

SET @cKey = CURSOR FOR
	SELECT	Row, VoucherNo, Period
	FROM	#Data
		
OPEN @cKey
FETCH NEXT FROM @cKey INTO @Row, @VoucherNo, @Period
WHILE @@FETCH_STATUS = 0
BEGIN
	--PRINT (@VoucherGroup)
	--PRINT (@VoucherNo)
	SET @Period = RIGHT(@Period, 4)
	IF @VoucherGroup IS NULL OR @VoucherGroup <> (@VoucherNo + '#' + @Period)
	BEGIN
		SET @Orders = 0
		EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @VoucherID OUTPUT, @TableName = 'AT2006', @StringKey1 = 'AD', @StringKey2 = @Period, @OutputLen = 16
		SET @VoucherGroup = (@VoucherNo + '#' + @Period)
	END
	SET @Orders = @Orders + 1
	EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @TransID OUTPUT, @TableName = 'AT2007', @StringKey1 = 'BD', @StringKey2 = @Period, @OutputLen = 16
	INSERT INTO #Keys (Row, Orders, VoucherID, TransactionID) VALUES (@Row, @Orders, @VoucherID, @TransID)				
	FETCH NEXT FROM @cKey INTO @Row, @VoucherNo, @Period
END	
CLOSE @cKey

-- Cập nhật khóa
UPDATE		DT
SET			Orders = K.Orders,
			DT.VoucherID = K.VoucherID ,
			DT.TransactionID = K.TransactionID			
FROM		#Data DT
INNER JOIN	#Keys K
		ON	K.Row = DT.Row
-- Cập nhật Loại tiền
SET @CurrencyID = (SELECT TOP 1 BaseCurrencyID FROM AT1101 WHERE DivisionID = @DivisionID)
				
-- Kiểm tra trùng số chứng từ
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckDuplicateOtherVoucherNo', @ColID = 'VoucherNo', @Param2 = 'AT2006', @Param3 = 'VoucherNo'

-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-- Đẩy dữ liệu vào bảng master
INSERT INTO AT2006
(
	DivisionID,		VoucherID,		TableID,	TranMonth,	TranYear,
	VoucherTypeID,	VoucherDate,	VoucherNo,	ObjectID,	InventoryTypeID,
	WareHouseID,	KindVoucherID,	[Status],	EmployeeID,	[Description],
	RefNo01,		RefNo02,
	CreateDate,		CreateUserID,	LastModifyUserID,	LastModifyDate
	
)

SELECT	DISTINCT
		DivisionID,		VoucherID,		'AT2006',	LEFT(Period, 2),	RIGHT(Period, 4),
		VoucherTypeID,	VoucherDate,	VoucherNo,	ObjectID,			InventoryTypeID,			
		WareHouseID,	1,				0,			EmployeeID,			[Description],
		RefNo01,		RefNo02,
		GETDATE(),		@UserID,		@UserID,	GETDATE()	
FROM	#Data


INSERT INTO AT2007
(
	DivisionID,	TransactionID,	VoucherID,	
	InventoryID,UnitID,	ActualQuantity,	UnitPrice,	OriginalAmount,	ConvertedAmount,
	Notes,	TranMonth,	TranYear,	CurrencyID,	ExchangeRate,
	SourceNo,	DebitAccountID,	CreditAccountID,
	LimitDate,	Orders,
	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
	Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
	PeriodID,	ProductID, OrderID
)
SELECT	DivisionID,	TransactionID,	VoucherID,	
		InventoryID,UnitID,	ActualQuantity,	UnitPrice,	OriginalAmount,	OriginalAmount,
		Notes,		LEFT(Period, 2),	RIGHT(Period, 4),	@CurrencyID,	1,
		SourceNo,	DebitAccountID,	CreditAccountID,
		LimitDate,	Orders,
		Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
		PeriodID,	ProductID,
		PONo
FROM	#Data

UPDATE T1
SET		T1.OTransactionID = T3.TransactionID
FROM AT2007 T1
INNER JOIN #Data T2 ON T1.DivisionID = T2.DivisionID AND T1.TransactionID = T2.TransactionID
INNER JOIN OT3002 T3 ON T2.PONo = T3.POrderID  AND T2.InventoryID = T3.InventoryID AND T2.DivisionID = T3.DivisionID


---------- Xử lý tự động sinh phiếu mua hàng ------------
IF EXISTS (SELECT TOP 1 1 FROM #Data WHERE Isnull(InvoiceNo,'') <> '')
BEGIN

CREATE TABLE #PKeys
(
	Row INT,
	Orders INT,
	VoucherNo NVARCHAR(50),
	VoucherID NVARCHAR(50),
	TransactionID NVARCHAR(50),	
	VATTransactionID NVARCHAR(50),	
	CONSTRAINT [PK_#PKeys] PRIMARY KEY CLUSTERED 
	(
		Row ASC
	) ON [PRIMARY]	
)


DECLARE @cPKey AS CURSOR
--DECLARE @Row AS INT,
--		@Orders AS INT,
--		@VoucherNo AS NVARCHAR(50),
--		@Period AS NVARCHAR(50),
--		@VoucherGroup AS NVARCHAR(50),
--		@VATGroupID AS NVARCHAR(50)
		

DECLARE	@PTransID AS NVARCHAR(50),
		@InvoiceNo AS NVARCHAR(50),
		@VATTransID AS NVARCHAR(50),		
		@PVoucherID AS NVARCHAR(50),		
		@PBatchID AS NVARCHAR(50),		
		@WOrderID AS NVARCHAR(50),
		@WTransactionID AS NVARCHAR(50),
		@VATGroupID AS NVARCHAR(50)	

declare @PVoucherNo NVarchar(50), @S1 Varchar(10),  @S2 Varchar(10),  @S3 Varchar(10), 
		@OutputLength int, @Seperator varchar(3), @Seperated int, @OutputOrder int,
		@VATTypeID NVarchar(50), @VATAccountID  NVarchar(50)

Select @S1 = S1, @S2 = S2, @S3 = S3, @OutputLength = OutputLength, @Seperator = Separator, 
@Seperated = Separated, @OutputOrder = OutputOrder, @VATTypeID = VATTypeID
from AT1007 where VoucherTypeID = 'MH'

SELECT @VATAccountID = VATInAccountID
FROM AT0000

SET @cPKey = CURSOR FOR
	SELECT	T1.Row, T1.InvoiceNo, T2.VATGroupID
	FROM	#Data T1
	INNER JOIN AT1302 T2 ON T1.InventoryID = T2.InventoryID
	WHERE	Isnull(T1.InvoiceNo,'') <> ''
		
OPEN @cPKey
FETCH NEXT FROM @cPKey INTO @Row, @InvoiceNo, @VATGroupID
WHILE @@FETCH_STATUS = 0
BEGIN
	
	IF  @VoucherGroup IS NULL OR @VoucherGroup <> @InvoiceNo
	BEGIN
		---------->> Hóa đơn mua hàng VoucherID
		SET @Orders = 0
		--- Sinh khoa VoucherID
		EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @PVoucherID OUTPUT, @TableName = 'AT9000', @StringKey1 = 'AV', @StringKey2 = @Period, @OutputLen = 16

		--- Sinh so phieu VoucherNo
		EXEC AP0000 @DivisionID = 'GS', @NewKey = @PVoucherNo OUTPUT, @TableName = 'AT9000', @StringKey1 = @S1, @StringKey2 = @S2, @StringKey3 = @S3, @OutputLen = @OutputLength,
					@OutputOrder = @OutputOrder, @Seperated = @Seperated, @Seperator = @Seperator				

		SET @VoucherGroup = @InvoiceNo
	END
	SET @Orders = @Orders + 1
	EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @PTransID OUTPUT, @TableName = 'AT9000', @StringKey1 = 'AT', @StringKey2 = @Period, @OutputLen = 16
	
	IF ISNULL(@VATGroupID,'') <> ''
	EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @VATTransID OUTPUT, @TableName = 'AT9000', @StringKey1 = 'AT', @StringKey2 = @Period, @OutputLen = 16
	
	INSERT INTO #PKeys (Row, Orders, VoucherNo, VoucherID, TransactionID, VATTransactionID) 
	VALUES (@Row, @Orders, @PVoucherNo, @PVoucherID, @PTransID, @VATTransID)				
	FETCH NEXT FROM @cPKey INTO @Row, @InvoiceNo, @VATGroupID
	
END	
CLOSE @cPKey

-- Cập nhật khóa
UPDATE		DT
SET			POrders = K.Orders,
			DT.PVoucherNo = K.VoucherNo,
			DT.PVoucherID = K.VoucherID ,			
			DT.PTransactionID = K.TransactionID,
			DT.VATTransactionID = K.VATTransactionID
FROM		#Data DT
INNER JOIN	#PKeys K
		ON	K.Row = DT.Row

-- Kiểm tra trùng số chứng từ
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckDuplicateOtherVoucherNo', @ColID = 'PVoucherNo', @Param2 = 'AT9000', @Param3 = 'VoucherNo'

-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT


-------->>> Phần Hóa đơn mua hàng đẩy vào bảng AT9000
INSERT INTO AT9000
(
	DivisionID,	VoucherID,		BatchID,		TransactionID,	TableID,
	TranMonth,	TranYear,		TransactionTypeID,
	CurrencyID,	ObjectID,		CreditObjectID,
	VATNo,		VATObjectID,	VATObjectName,	VATObjectAddress,
	DebitAccountID,		CreditAccountID,	
	ExchangeRate,		UnitPrice,
	OriginalAmount,		ConvertedAmount,	
	IsMultiTax,
	VATOriginalAmount,	VATConvertedAmount,
	IsStock,		VoucherDate,	InvoiceDate,	VoucherTypeID,	VATTypeID,	VATGroupID,
	VoucherNo,		Serial,			InvoiceNo,	
	Orders,			EmployeeID,		SenderReceiver,	SRDivisionName,	SRAddress,
	VDescription,	BDescription,	TDescription,
	Quantity,		InventoryID,	UnitID,	
	[Status],		IsAudit,		IsCost,	
	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
	CreateDate,		CreateUserID,			LastModifyDate,		LastModifyUserID,
	OriginalAmountCN,						ExchangeRateCN,		CurrencyIDCN,	
	ConvertedQuantity,		ConvertedPrice,		ConvertedUnitID, 
	InventoryName1,
	WOrderID, WTransactionID
)
SELECT	D.DivisionID,		D.PVoucherID,		D.PVoucherID,		D.PTransactionID,	'AT9000',
		LEFT(D.Period, 2),	RIGHT(D.Period, 4),	'T03',
		D.CurrencyID,		D.ObjectID,			D.ObjectID,
		A.VATNo,			D.ObjectID,		A.ObjectName,	A.[Address],
		A1302.AccountID AS DebitAccountID,	A1302.PurchaseAccountID AS CreditAccountID,	
		D.ExchangeRate,	D.UnitPrice,
		D.OriginalAmount,	
		CASE WHEN AT1004.Operator = 0 THEN D.OriginalAmount* D.ExchangeRate ELSE D.OriginalAmount/ D.ExchangeRate END AS ConvertedAmount,
		1,
		A1.VATRate/100*D.OriginalAmount,
		CASE WHEN AT1004.Operator = 0 THEN ROUND((A1.VATRate/100* (D.OriginalAmount* D.ExchangeRate)),ISNULL(A2.ConvertedDecimals,0)) ELSE ROUND((A1.VATRate/100* (D.OriginalAmount/D.ExchangeRate)),ISNULL(A2.ConvertedDecimals,0)) END, 		
		0,		D.VoucherDate,	D.VoucherDate,	'MH',	@VATTypeID,	A1302.VATGroupID,
		D.PVoucherNo,	D.Serial,		D.InvoiceNo,	
		D.POrders,		D.PEmployeeID,	A.ObjectName,	A.ObjectName,	A.Address,
		D.Description,	D.Description,	D.Description,
		D.ActualQuantity,		D.InventoryID,	D.UnitID,		
		0,		0,		0,	
		D.Ana01ID,	D.Ana02ID,	D.Ana03ID,	D.Ana04ID,	D.Ana05ID,
		GETDATE(),	@UserID,	GETDATE(),	@UserID,
		D.OriginalAmount,	D.ExchangeRate,	D.CurrencyID,
		D.ActualQuantity,		D.UnitPrice,	D.UnitID,
		InventoryName, D.VoucherID, D.TransactionID		
FROM	#Data D
LEFT JOIN AT1302 A1302 ON A1302.DivisionID = D.DivisionID AND A1302.InventoryID = D.InventoryID
LEFT JOIN AT1202 A ON A.DivisionID = D.DivisionID AND A.ObjectID = D.ObjectID
LEFT JOIN AT1010 A1 ON A1.DivisionID = A1302.DivisionID AND A1.VATGroupID = A1302.VATGroupID
LEFT JOIN AT1101 A2 ON A2.DivisionID = D.DivisionID 
LEFT JOIN AT1004 ON D.CurrencyID = AT1004.CurrencyID AND D.DivisionID = AT1004.DivisionID 


---------->>> Bút toán thuế
IF ISNULL(@VATGroupID, '') <> ''
INSERT INTO AT9000
(
	DivisionID,	VoucherID,		BatchID,		TransactionID,	TableID,
	TranMonth,	TranYear,		TransactionTypeID,
	CurrencyID,	ObjectID,		CreditObjectID,
	VATNo,		VATObjectID,	VATObjectName,	VATObjectAddress,
	DebitAccountID,		CreditAccountID,	
	ExchangeRate,		UnitPrice,
	OriginalAmount,		ConvertedAmount,	
	VATOriginalAmount,	VATConvertedAmount,
	IsStock,		VoucherDate,	InvoiceDate,	VoucherTypeID,	VATTypeID,	VATGroupID,
	VoucherNo,		Serial,			InvoiceNo,	
	Orders,			EmployeeID,		SenderReceiver,	SRDivisionName,	SRAddress,
	VDescription,	BDescription,	TDescription,
	Quantity,		InventoryID,	UnitID,	
	[Status],		IsAudit,		IsCost,	
	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
	CreateDate,		CreateUserID,			LastModifyDate,		LastModifyUserID,
	OriginalAmountCN,						ExchangeRateCN,		CurrencyIDCN,
	ConvertedQuantity,		ConvertedPrice,		ConvertedUnitID
)
SELECT	D.DivisionID,		D.PVoucherID,		D.PVoucherID,		D.VATTransactionID,	'AT9000',
		LEFT(D.Period, 2),	RIGHT(D.Period, 4),	'T13',
		D.CurrencyID,		D.ObjectID,	D.ObjectID,
		A.VATNo,			D.ObjectID,		A.ObjectName,	A.[Address],
		@VATAccountID,		A1302.PurchaseAccountID,	D.ExchangeRate,	NULL,
		A1.VATRate/100*D.OriginalAmount,
		CASE WHEN AT1004.Operator = 0 THEN ROUND((A1.VATRate/100* (D.OriginalAmount* D.ExchangeRate)),ISNULL(A2.ConvertedDecimals,0)) ELSE ROUND((A1.VATRate/100* (D.OriginalAmount/D.ExchangeRate)),ISNULL(A2.ConvertedDecimals,0)) END, 		
		NULL, NULL,
		0,		D.VoucherDate,	D.VoucherDate,	D.VoucherTypeID,	@VATTypeID,	A1302.VATGroupID,
		D.PVoucherNo,	D.Serial,		D.InvoiceNo,	
		D.POrders,		D.PEmployeeID,	A.ObjectName,	A.ObjectName,	A.Address,
		D.Description,	D.Description,	D.Description,
		NULL,			NULL,			NULL,		
		0,		0,		0,	
		D.Ana01ID,	D.Ana02ID,	D.Ana03ID,	D.Ana04ID,	D.Ana05ID,
		GETDATE(),	@UserID,	GETDATE(),	@UserID,
		A1.VATRate/100*D.OriginalAmount,	
		D.ExchangeRate,		D.CurrencyID,
		NULL,			NULL,	NULL
		
FROM	#Data D
LEFT JOIN AT1302 A1302 ON A1302.DivisionID = D.DivisionID AND A1302.InventoryID = D.InventoryID
LEFT JOIN AT1202 A ON A.DivisionID = D.DivisionID AND A.ObjectID = D.ObjectID
LEFT JOIN AT1010 A1 ON A1.DivisionID = A1302.DivisionID AND A1.VATGroupID = A1302.VATGroupID
LEFT JOIN AT1101 A2 ON A2.DivisionID = D.DivisionID AND A2.BaseCurrencyID = D.CurrencyID
LEFT JOIN AT1004 ON D.CurrencyID = AT1004.CurrencyID AND D.DivisionID = AT1004.DivisionID 


END

LB_RESULT:
SELECT * FROM #Data



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

