IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8125]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8125]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Import Hóa đơn bán hàng có phần xuất kho tự động
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 25/06/2012 by Lê Thị Thu Hiền
---- 
---- Modified on Dang Le Bao Quynh. Purpose: xu ly lai cach sinh key, Ban hang, xuat kho, thue trung VoucherID. Ban hang, xuat kho trung TransactionID
---- Sinh TransactionID kieu UniqueIdentifier 
---- Modified on 21/11/2013 by Lê Thị Thu Hiền : Insert IsStock
---- Modified on 20/04/2015 by Lê Thị Hạnh: Bổ sung nếu IsWareHouse = 1 thì bắt buộc nhập WHDebitAccountID,WHCreditAccountID [LAVO]
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ, tiền hạch toán theo thiết lập đơn vị-chi nhánh
-- <Example>																			  
---- 
---- 

CREATE PROCEDURE AP8125
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
		@ColSQLDataType AS NVARCHAR(50),
		@IsWareHouse AS TINYINT	
		
CREATE TABLE #Data
(
	APK UNIQUEIDENTIFIER DEFAULT(NEWID()),
	Row INT,
	Orders INT,
	VoucherID NVARCHAR(50) NULL,
	BatchID NVARCHAR(50),
	TransactionID NVARCHAR(50),
	VATTransactionID NVARCHAR(50),
	WHVoucherID NVARCHAR(50),
	WHTransactionID NVARCHAR(50),
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
	BatchID NVARCHAR(50),
	TransactionID NVARCHAR(50),
	VATTransactionID NVARCHAR(50),	
	WHVoucherID NVARCHAR(50),
	WHTransactionID NVARCHAR(50),	
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
		X.Data.query('IsWareHouse').value('.', 'TINYINT') AS IsWareHouse,
		X.Data.query('WareHouseVoucherTypeID').value('.', 'NVARCHAR(50)') AS WareHouseVoucherTypeID,		
		X.Data.query('VoucherNo').value('.', 'NVARCHAR(50)') AS VoucherNo,
		X.Data.query('VoucherDate').value('.', 'DATETIME') AS VoucherDate,
		X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') AS EmployeeID,		
		X.Data.query('VDescription').value('.', 'NVARCHAR(250)') AS VDescription,	
		X.Data.query('Serial').value('.', 'NVARCHAR(50)') AS Serial,
		X.Data.query('InvoiceNo').value('.', 'NVARCHAR(50)') AS InvoiceNo,
		X.Data.query('InvoiceDate').value('.', 'DATETIME') AS InvoiceDate,
		X.Data.query('VATTypeID').value('.', 'NVARCHAR(50)') AS VATTypeID,
		X.Data.query('DueDate').value('.', 'DATETIME') AS DueDate,		
		X.Data.query('CurrencyID').value('.', 'NVARCHAR(50)') AS CurrencyID,
		X.Data.query('ExchangeRate').value('.', 'DECIMAL(28,8)') AS ExchangeRate,
		X.Data.query('ObjectID').value('.', 'NVARCHAR(50)') AS ObjectID,
		X.Data.query('VATObjectID').value('.', 'NVARCHAR(50)') AS VATObjectID,
		X.Data.query('PaymentTermID').value('.', 'NVARCHAR(50)') AS PaymentTermID,
		X.Data.query('BDescription').value('.', 'NVARCHAR(250)') AS BDescription,
		X.Data.query('GTGTObjectID').value('.', 'NVARCHAR(50)') AS GTGTObjectID,
		X.Data.query('GTGTDebitAccountID').value('.', 'NVARCHAR(50)') AS GTGTDebitAccountID,
		X.Data.query('GTGTCreditAccountID').value('.', 'NVARCHAR(50)') AS GTGTCreditAccountID,
		X.Data.query('InventoryID').value('.', 'NVARCHAR(50)') AS InventoryID,
		X.Data.query('UnitID').value('.', 'NVARCHAR(50)') AS UnitID,
		X.Data.query('Quantity').value('.', 'DECIMAL(28,8)') AS Quantity,
		X.Data.query('UnitPrice').value('.', 'DECIMAL(28,8)') AS UnitPrice,
		X.Data.query('DiscountRate').value('.', 'DECIMAL(28,8)') AS DiscountRate,
		X.Data.query('DiscountAmount').value('.', 'DECIMAL(28,8)') AS DiscountAmount,
		X.Data.query('OriginalAmount').value('.', 'DECIMAL(28,8)') AS OriginalAmount,
		X.Data.query('ConvertedAmount').value('.', 'DECIMAL(28,8)') AS ConvertedAmount,
		X.Data.query('VATGroupID').value('.', 'NVARCHAR(50)') AS VATGroupID,
		X.Data.query('DebitAccountID').value('.', 'NVARCHAR(50)') AS DebitAccountID,
		X.Data.query('CreditAccountID').value('.', 'NVARCHAR(50)') AS CreditAccountID,
		X.Data.query('TDescription').value('.', 'NVARCHAR(250)') AS TDescription,	
		X.Data.query('Ana01ID').value('.', 'NVARCHAR(50)') AS Ana01ID,
		X.Data.query('Ana02ID').value('.', 'NVARCHAR(50)') AS Ana02ID,
		X.Data.query('Ana03ID').value('.', 'NVARCHAR(50)') AS Ana03ID,
		X.Data.query('Ana04ID').value('.', 'NVARCHAR(50)') AS Ana04ID,
		X.Data.query('Ana05ID').value('.', 'NVARCHAR(50)') AS Ana05ID,			
		X.Data.query('WareHouseExVoucherNo').value('.', 'NVARCHAR(50)') AS WareHouseExVoucherNo,
		X.Data.query('WareHouseExVoucherDate').value('.', 'DATETIME') AS WareHouseExVoucherDate,	
		X.Data.query('WareHouseImVoucherNo').value('.', 'NVARCHAR(50)') AS WareHouseImVoucherNo,
		X.Data.query('WareHouseEx').value('.', 'NVARCHAR(50)') AS WareHouseEx,
		X.Data.query('SourceNo').value('.', 'NVARCHAR(50)') AS SourceNo,
		X.Data.query('WHContactPerson').value('.', 'NVARCHAR(250)') AS WHContactPerson,
		X.Data.query('WHRDAddress').value('.', 'NVARCHAR(250)') AS WHRDAddress,
		X.Data.query('WHDescription').value('.', 'NVARCHAR(250)') AS WHDescription,
		X.Data.query('WHDebitAccountID').value('.', 'NVARCHAR(50)') AS WHDebitAccountID,
		X.Data.query('WHCreditAccountID').value('.', 'NVARCHAR(50)') AS WHCreditAccountID
		
INTO	#AP8125	
FROM	@XML.nodes('//Data') AS X (Data)


INSERT INTO #Data (
		Row,
		DivisionID,
		Period,
		VoucherTypeID,
		IsWareHouse,
		WareHouseVoucherTypeID,
		VoucherNo,
		VoucherDate,
		EmployeeID,
		VDescription,
		Serial,
		InvoiceNo,
		InvoiceDate,
		VATTypeID,
		DueDate,
		CurrencyID,
		ExchangeRate,
		ObjectID,
		VATObjectID,
		PaymentTermID,
		BDescription,
		GTGTObjectID,
		GTGTDebitAccountID,
		GTGTCreditAccountID,
		InventoryID,
		UnitID,
		Quantity,
		UnitPrice,
		DiscountRate,
		DiscountAmount,
		OriginalAmount,
		ConvertedAmount,
		VATGroupID,
		DebitAccountID,
		CreditAccountID,
		TDescription,
		Ana01ID,
		Ana02ID,
		Ana03ID,
		Ana04ID,
		Ana05ID,
		WareHouseExVoucherNo,
		WareHouseExVoucherDate,
		WareHouseImVoucherNo,
		WareHouseEx,
		SourceNo,
		WHContactPerson,
		WHRDAddress,
		WHDescription,
		WHDebitAccountID,
		WHCreditAccountID
		)
SELECT * FROM #AP8125



---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

---- Kiểm tra dữ liệu không đồng nhất tại phần master
IF EXISTS (SELECT TOP 1 1 FROM #Data WHERE IsWareHouse = 1) 
BEGIN
	EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckValidAccount', @ColID = 'WHDebitAccountID', @ObligeCheck = 1, @SQLFilter = 'A.GroupID <> ''G00'''
	EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckValidAccount', @ColID = 'WHCreditAccountID', @ObligeCheck = 1, @SQLFilter = 'A.GroupID <> ''G00'''
END
ELSE 
BEGIN
	EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckValidAccount', @ColID = 'WHDebitAccountID', @ObligeCheck = 0, @SQLFilter = 'A.GroupID <> ''G00'''
	EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckValidAccount', @ColID = 'WHCreditAccountID', @ObligeCheck = 0, @SQLFilter = 'A.GroupID <> ''G00'''
END
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues', @Module = 'ASOFT-T', @ColID = 'VoucherNo', @Param1 = 'VoucherNo,VoucherDate,EmployeeID,VDescription,Serial,InvoiceNo,InvoiceDate,VATTypeID,DueDate,CurrencyID,ExchangeRate,ObjectID,VATObjectID,PaymentTermID,BDescription,GTGTObjectID,GTGTDebitAccountID,GTGTCreditAccountID,WareHouseExVoucherNo,WareHouseExVoucherDate,WareHouseEx,WHContactPerson,WHRDAddress,WHDescription'

--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE		DT
SET			Quantity = ROUND(DT.Quantity, A.QuantityDecimals),
			ExchangeRate = ROUND(DT.ExchangeRate, A1.ExchangeRateDecimal),
			OriginalAmount = ROUND(OriginalAmount, A1.ExchangeRateDecimal),
			ConvertedAmount = ROUND(ConvertedAmount, A.ConvertedDecimals),
			UnitPrice = ROUND(DT.UnitPrice, A.UnitCostDecimals),	
			DiscountRate = ROUND(DiscountRate, 2),
			DiscountAmount = ROUND(DiscountAmount, A1.ExchangeRateDecimal),
		
			VoucherDate = CASE WHEN VoucherDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), VoucherDate, 101)) END,
			InvoiceDate = CASE WHEN InvoiceDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), InvoiceDate, 101)) END,
			DueDate = CASE WHEN DueDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), DueDate, 101)) END,
			WareHouseExVoucherDate = CASE WHEN WareHouseExVoucherDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), WareHouseExVoucherDate, 101)) END
FROM		#Data DT
LEFT JOIN	AT1101 A ON A.DivisionID = DT.DivisionID
LEFT JOIN	AT1004 A1 ON A1.DivisionID = DT.DivisionID AND A1.CurrencyID = DT.CurrencyID

			
-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT
	
---------->>> Xuất kho
SET @IsWareHouse = (SELECT TOP 1 IsWareHouse FROM #Data WHERE DivisionID = @DivisionID)

-- Sinh khóa
DECLARE @cKey AS CURSOR
DECLARE @Row AS INT,
		@Orders AS INT,
		@VoucherNo AS NVARCHAR(50),
		@Period AS NVARCHAR(50),
		@VoucherGroup AS NVARCHAR(50),
		@VATGroupID AS NVARCHAR(50)

DECLARE	@TransID AS NVARCHAR(50),
		@VATTransID AS NVARCHAR(50),
		@WHTransID AS NVARCHAR(50),
		@VoucherID AS NVARCHAR(50),
		@WHVoucherID AS NVARCHAR(50),
		@BatchID AS NVARCHAR(50),
		@CurrencyID AS NVARCHAR(50),
		@ReVoucherID AS NVARCHAR(50)	

SET @cKey = CURSOR FOR
	SELECT	Row, VoucherNo, Period, VATGroupID
	FROM	#Data
		
OPEN @cKey
FETCH NEXT FROM @cKey INTO @Row, @VoucherNo, @Period, @VATGroupID
WHILE @@FETCH_STATUS = 0
BEGIN
	
	SET @Period = RIGHT(@Period, 4)
	IF @VoucherGroup IS NULL OR @VoucherGroup <> (@VoucherNo + '#' + @Period)
	BEGIN
		---------->> Hóa đơn bán hàng VoucherID
		SET @Orders = 0
		EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @VoucherID OUTPUT, @TableName = 'AT9000', @StringKey1 = 'AV', @StringKey2 = @Period, @OutputLen = 16
		
		---------->> Xuất kho VoucherID
		IF ISNULL(@IsWareHouse,0) <> 0
			--EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @WHVoucherID OUTPUT, @TableName = 'AT2006', @StringKey1 = 'AD', @StringKey2 = @Period, @OutputLen = 16
			SET @WHVoucherID = @VoucherID
		SET @VoucherGroup = (@VoucherNo + '#' + @Period)
	END
	SET @Orders = @Orders + 1
	--EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @TransID OUTPUT, @TableName = 'AT9000', @StringKey1 = 'AT', @StringKey2 = @Period, @OutputLen = 16
	SET @TransID = NEWID()
	IF ISNULL(@IsWareHouse,0) <> 0
	--EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @WHTransID OUTPUT, @TableName = 'AT2006', @StringKey1 = 'BD', @StringKey2 = @Period, @OutputLen = 16
	SET @WHTransID = @TransID
	
	IF ISNULL(@VATGroupID,'') <> ''
	--EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @VATTransID OUTPUT, @TableName = 'AT9000', @StringKey1 = 'AT', @StringKey2 = @Period, @OutputLen = 16
		SET @VATTransID = NEWID()
	ELSE
		SET @VATTransID = NULL

	INSERT INTO #Keys (Row, Orders, VoucherID, TransactionID, VATTransactionID, WHVoucherID, WHTransactionID) 
	VALUES (@Row, @Orders, @VoucherID, @TransID, @VATTransID, @WHVoucherID, @WHTransID)				
	FETCH NEXT FROM @cKey INTO @Row, @VoucherNo, @Period, @VATGroupID

END	
CLOSE @cKey

-- Cập nhật khóa
UPDATE		DT
SET			Orders = K.Orders,
			DT.VoucherID = K.VoucherID ,
			DT.BatchID = K.VoucherID ,
			DT.TransactionID = K.TransactionID,
			DT.VATTransactionID = K.VATTransactionID,
			DT.WHVoucherID =  K.WHVoucherID,
			DT.WHTransactionID =  K.WHTransactionID		
FROM		#Data DT
INNER JOIN	#Keys K
		ON	K.Row = DT.Row
				
-- Kiểm tra trùng số chứng từ
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckDuplicateOtherVoucherNo', @ColID = 'VoucherNo', @Param2 = 'AT9000', @Param3 = 'VoucherNo'

-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-------->>> Phần Hóa đơn bán hàng đẩy vào bảng AT9000
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
	DueDays,		PaymentID,				DueDate,	
	DiscountRate,	DiscountAmount,
	OrderID,		CreditBankAccountID,	DebitBankAccountID,
	PaymentTermID,	ConvertedQuantity,		ConvertedPrice,		ConvertedUnitID
)
SELECT	D.DivisionID,		D.VoucherID,		D.BatchID,		D.TransactionID,	'AT9000',
		LEFT(D.Period, 2),	RIGHT(D.Period, 4),	'T04',
		D.CurrencyID,		D.ObjectID,			D.ObjectID,
		A.VATNo,			D.VATObjectID,		A.ObjectName,	A.[Address],
		D.DebitAccountID,	D.CreditAccountID,	D.ExchangeRate,	D.UnitPrice,
		D.OriginalAmount,	D.ConvertedAmount,
		1,
		A1.VATRate/100*(D.OriginalAmount - ISNULL(D.DiscountAmount, 0)),
		ROUND((A1.VATRate/100*(D.ConvertedAmount - ISNULL(D.ConvertedAmount*D.DiscountRate/100,0))),ISNULL(A2.ConvertedDecimals,0)) ,
		@IsWareHouse ,		D.VoucherDate,	D.InvoiceDate,	D.VoucherTypeID,	D.VATTypeID,	D.VATGroupID,
		D.VoucherNo,	D.Serial,		D.InvoiceNo,	
		D.Orders,		D.EmployeeID,	A.ObjectName,	A.ObjectName,	A.Address,
		D.VDescription,	D.BDescription,	D.TDescription,
		D.Quantity,		D.InventoryID,	D.UnitID,		
		0,		0,		0,	
		D.Ana01ID,	D.Ana02ID,	D.Ana03ID,	D.Ana04ID,	D.Ana05ID,
		GETDATE(),	@UserID,	GETDATE(),	@UserID,
		D.OriginalAmount,	D.ExchangeRate,	D.CurrencyID,
		NULL,				NULL,			D.DueDate,	
		D.DiscountRate,		D.DiscountAmount,
		NULL,				NULL,			NULL,
		D.PaymentTermID,	D.Quantity,		D.UnitPrice,	D.UnitID
		
FROM	#Data D
LEFT JOIN AT1202 A ON A.DivisionID = D.DivisionID AND A.ObjectID = D.VATObjectID
LEFT JOIN AT1010 A1 ON A1.DivisionID = D.DivisionID AND A1.VATGroupID = D.VATGroupID
LEFT JOIN AT1101 A2 ON A2.DivisionID = D.DivisionID 

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
	DueDays,		PaymentID,				DueDate,	
	DiscountRate,	DiscountAmount,
	OrderID,		CreditBankAccountID,	DebitBankAccountID,
	PaymentTermID,	ConvertedQuantity,		ConvertedPrice,		ConvertedUnitID
)
SELECT	D.DivisionID,		D.VoucherID,		D.BatchID,		D.VATTransactionID,	'AT9000',
		LEFT(D.Period, 2),	RIGHT(D.Period, 4),	'T14',
		D.CurrencyID,		ISNULL(D.GTGTObjectID,D.ObjectID),	ISNULL(D.GTGTObjectID,D.ObjectID),
		A.VATNo,			D.VATObjectID,		A.ObjectName,	A.[Address],
		D.GTGTDebitAccountID,	D.GTGTCreditAccountID,	D.ExchangeRate,	NULL,
		A1.VATRate*(D.OriginalAmount - ISNULL(D.DiscountAmount, 0))/100,
		ROUND((A1.VATRate/100*(D.ConvertedAmount - ISNULL(D.ConvertedAmount*D.DiscountRate/100,0))),ISNULL(A2.ConvertedDecimals,0)) ,
		NULL, NULL,
		D.IsWareHouse,		D.VoucherDate,	D.InvoiceDate,	D.VoucherTypeID,	D.VATTypeID,	D.VATGroupID,
		D.VoucherNo,	D.Serial,		D.InvoiceNo,	
		D.Orders,		D.EmployeeID,	A.ObjectName,	A.ObjectName,	A.Address,
		D.VDescription,	D.BDescription,	D.TDescription,
		NULL,			NULL,			NULL,		
		0,		0,		0,	
		D.Ana01ID,	D.Ana02ID,	D.Ana03ID,	D.Ana04ID,	D.Ana05ID,
		GETDATE(),	@UserID,	GETDATE(),	@UserID,
		A1.VATRate*(D.OriginalAmount - ISNULL(D.DiscountAmount, 0))/100,	
		D.ExchangeRate,		D.CurrencyID,
		NULL,				NULL,			D.DueDate,	
		NULL,				NULL,
		NULL,				NULL,			NULL,
		D.PaymentTermID,	NULL,			NULL,	NULL
		
FROM	#Data D
LEFT JOIN AT1202 A ON A.DivisionID = D.DivisionID AND A.ObjectID = D.VATObjectID
LEFT JOIN AT1010 A1 ON A1.DivisionID = D.DivisionID AND A1.VATGroupID = D.VATGroupID
LEFT JOIN AT1101 A2 ON A2.DivisionID = D.DivisionID AND A2.BaseCurrencyID = D.CurrencyID
WHERE D.VATTransactionID Is Not Null
--------->>>> Xuất kho

IF ISNULL(@IsWareHouse, 0) <> 0
BEGIN
	
-- Đẩy dữ liệu vào bảng master
INSERT INTO AT2006
(
	DivisionID,		VoucherID,		TableID,	TranMonth,	TranYear,
	VoucherTypeID,	VoucherDate,	
	VoucherNo,		ObjectID,		InventoryTypeID,
	WareHouseID,	KindVoucherID,	[Status],	EmployeeID,	[Description],
	RefNo01,		RefNo02,		RDAddress,	ContactPerson,
	CreateDate,		CreateUserID,	LastModifyUserID,	LastModifyDate
	
)

SELECT	DISTINCT
		DivisionID,		WHVoucherID,		'AT2006',	LEFT(Period, 2),RIGHT(Period, 4),
		WareHouseVoucherTypeID,		WareHouseExVoucherDate,	
		WareHouseExVoucherNo,		ObjectID,			'%'	,		
		WareHouseEx,	4,			0,				EmployeeID,		WHDescription,
		VoucherNo,		InvoiceNo+'/'+Serial,		WHRDAddress,	WHContactPerson,
		GETDATE(),		@UserID,		@UserID,	GETDATE()	
FROM	#Data


INSERT INTO AT2007
(
	Orders,
	DivisionID,		TransactionID,	VoucherID,	
	TranMonth,		TranYear,		CurrencyID,		ExchangeRate,
	InventoryID,	UnitID,			SourceNo,
	ConvertedQuantity,				ConvertedPrice,
	ActualQuantity,	UnitPrice,		
	OriginalAmount,	ConvertedAmount,
	DebitAccountID,	CreditAccountID,						
	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
	ReVoucherID,	ReTransactionID,	OrderID,
	ConversionFactor

)
SELECT	D.Orders,
		D.DivisionID,		D.WHTransactionID,		D.WHVoucherID,	
		LEFT(D.Period, 2),	RIGHT(D.Period, 4),		D.CurrencyID,		D.ExchangeRate,
		D.InventoryID,		D.UnitID,				D.SourceNo,
		D.Quantity,			D.UnitPrice,
		D.Quantity,			D.UnitPrice,			
		D.OriginalAmount,	D.ConvertedAmount,
		D.WHDebitAccountID,	D.WHCreditAccountID,		
		D.Ana01ID,	D.Ana02ID,	D.Ana03ID,	D.Ana04ID,	D.Ana05ID,
		D.VoucherID,		D.TransactionID,		D.VoucherNo,
		1

FROM	#Data D



END


LB_RESULT:
SELECT * FROM #Data


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
