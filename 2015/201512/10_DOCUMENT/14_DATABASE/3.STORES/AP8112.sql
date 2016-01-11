IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8112]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8112]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Xử lý Import dữ liệu phiếu thu qua ngân hàng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 13/10/2011 by Nguyễn Bình Minh
---- 
---- Modified on 05/10/2011 by 
-- <Example>
---- 
CREATE PROCEDURE [DBO].[AP8112]
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
	ImportMessage NVARCHAR(500) DEFAULT (''),
	Orders INT, -- Số thứ tự dòng
	VoucherID NVARCHAR(50) NULL,
	TransactionID NVARCHAR(50) NULL,
	BatchID NVARCHAR(50) NULL,
	DebitAccountID NVARCHAR(50),
	CurrencyID NVARCHAR(50),
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

INSERT INTO #Data (
		Row,				DivisionID,			Period,				VoucherTypeID,		VoucherNo,			VoucherDate,		EmployeeID,	RefNo01,		
		SenderReceiver,		SRDivisionName,		SRAddress,			Serial,				InvoiceNo,			InvoiceDate,		
		VDescription,		BDescription,		ExchangeRate, 		OriginalAmount, 	ConvertedAmount, 	
		DebitBankAccountID, CreditAccountID,	VATTypeID, 			VATGroupID, 		ObjectID,			
		TDescription,		Ana01ID, 			Ana02ID, 			Ana03ID, 			Ana04ID,			Ana05ID, Ana06ID,Ana07ID)		
SELECT	X.Data.query('Row').value('.', 'INT') AS Row,
		X.Data.query('DivisionID').value('.', 'NVARCHAR(50)') AS DivisionID,
		X.Data.query('Period').value('.', 'VARCHAR(10)') AS Period,
		X.Data.query('VoucherTypeID').value('.', 'NVARCHAR(50)') AS VoucherTypeID,
		X.Data.query('VoucherNo').value('.', 'NVARCHAR(50)') AS VoucherNo,
		X.Data.query('VoucherDate').value('.', 'DATETIME') AS VoucherDate,
		X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') AS EmployeeID,
		X.Data.query('RefNo01').value('.', 'NVARCHAR(100)') AS RefNo01,
		X.Data.query('SenderReceiver').value('.', 'NVARCHAR(250)') AS SenderReceiver,
		X.Data.query('SRDivisionName').value('.', 'NVARCHAR(250)') AS SRDivisionName,
		X.Data.query('SRAddress').value('.', 'NVARCHAR(50)') AS SRAddress,
		X.Data.query('Serial').value('.', 'NVARCHAR(50)') AS Serial,
		X.Data.query('InvoiceNo').value('.', 'NVARCHAR(50)') AS InvoiceNo,
		X.Data.query('InvoiceDate').value('.', 'DATETIME') AS InvoiceDate,
		X.Data.query('VDescription').value('.', 'NVARCHAR(250)') AS VDescription,
		X.Data.query('BDescription').value('.', 'NVARCHAR(250)') AS BDescription,
		X.Data.query('ExchangeRate').value('.', 'DECIMAL(28,8)') AS ExchangeRate,
		X.Data.query('OriginalAmount').value('.', 'DECIMAL(28,8)') AS OriginalAmount,
		X.Data.query('ConvertedAmount').value('.', 'DECIMAL(28,8)') AS ConvertedAmount,
		X.Data.query('DebitBankAccountID').value('.', 'NVARCHAR(50)') AS DebitBankAccountID,
		X.Data.query('CreditAccountID').value('.', 'NVARCHAR(50)') AS CreditAccountID,
		X.Data.query('VATTypeID').value('.', 'NVARCHAR(50)') AS VATTypeID,
		X.Data.query('VATGroupID').value('.', 'NVARCHAR(50)') AS VATGroupID,
		X.Data.query('ObjectID').value('.', 'NVARCHAR(50)') AS ObjectID,
		X.Data.query('TDescription').value('.', 'NVARCHAR(250)') AS TDescription,
		X.Data.query('Ana01ID').value('.', 'NVARCHAR(50)') AS Ana01ID,
		X.Data.query('Ana02ID').value('.', 'NVARCHAR(50)') AS Ana02ID,
		X.Data.query('Ana03ID').value('.', 'NVARCHAR(50)') AS Ana03ID,
		X.Data.query('Ana04ID').value('.', 'NVARCHAR(50)') AS Ana04ID,
		X.Data.query('Ana05ID').value('.', 'NVARCHAR(50)') AS Ana05ID,
		X.Data.query('Ana06ID').value('.', 'NVARCHAR(50)') AS Ana06ID,
		X.Data.query('Ana07ID').value('.', 'NVARCHAR(50)') AS Ana07ID
FROM	@XML.nodes('//Data') AS X (Data)

---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

---- Kiểm tra dữ liệu không đồng nhất tại phần phiếu
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues', @ColID = 'VoucherNo', @Param1 = 'VoucherNo,VoucherTypeID,VoucherDate,EmployeeID,SenderReceiver,SRDivisionName,SRAddress,DebitBankAccountID,ExchangeRate,VDescription'

--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE		DT
SET			ConvertedAmount = ROUND(ConvertedAmount, CUR.ConvertedDecimals),
			OriginalAmount = ROUND(OriginalAmount, CUR.ExchangeRateDecimal),
			ExchangeRate = ROUND(DT.ExchangeRate, CUR.ExchangeRateDecimal),
			VoucherDate = CONVERT(DATE, VoucherDate),
			InvoiceDate = CONVERT(DATE, CASE WHEN InvoiceDate = '1900-01-01' THEN NULL ELSE InvoiceDate END)
FROM		#Data DT
INNER JOIN	AV1004 CUR 
		ON	CUR.CurrencyID = DT.CurrencyID AND CUR.DivisionID = DT.DivisionID

-- Cập nhật tài khoản nợ và loại tiền theo tài khoản ngân hàng
UPDATE		DT
SET			CurrencyID = BA.CurrencyID,
			DebitAccountID = BA.AccountID  
FROM		#Data DT
INNER JOIN	AT1016 BA
		ON	BA.BankAccountID = DT.DebitBankAccountID AND BA.DivisionID = DT.DivisionID
		
-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-- Sinh khóa
DECLARE @cKey AS CURSOR
DECLARE @Row AS INT,
		@Orders AS INT,
		@VoucherNo AS NVARCHAR(50),
		@InvoiceNo AS NVARCHAR(50),
		@Serial AS NVARCHAR(50),
		@Period AS NVARCHAR(50),
		@ObjectID AS NVARCHAR(50), 
		@OVoucherGroup AS NVARCHAR(50),
		@OInvoiceGroup AS NVARCHAR(250)

DECLARE	@VoucherID AS NVARCHAR(50),
		@BatchID AS NVARCHAR(50),
		@TransID AS NVARCHAR(50)			

SET @cKey = CURSOR FOR
	SELECT	Row, VoucherNo, InvoiceNo, Serial, ObjectID, Period
	FROM	#Data
		
OPEN @cKey
FETCH NEXT FROM @cKey INTO @Row, @VoucherNo, @InvoiceNo, @Serial, @ObjectID, @Period
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @Period = RIGHT(@Period, 4)
	IF @OVoucherGroup IS NULL OR @OVoucherGroup <> (@VoucherNo + '#' + @Period) 
	BEGIN
		SET @Orders = 0
		EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @VoucherID OUTPUT, @TableName = 'AT9000', @StringKey1 = 'AV', @StringKey2 = @Period, @OutputLen = 16
		SET @OVoucherGroup = (@VoucherNo + '#' + @Period)
	END
	-- Mỗi hóa đơn sinh 1 BatchID
	IF @OInvoiceGroup IS NULL OR @OInvoiceGroup <> (@VoucherNo + '#' + @InvoiceNo + '#' + @Serial + '#' + @ObjectID + '#' + @Period)
	BEGIN
		EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @BatchID OUTPUT, @TableName = 'AT9000', @StringKey1 = 'AB', @StringKey2 = @Period, @OutputLen = 16
		SET @OInvoiceGroup = (@VoucherNo + '#' + @InvoiceNo + '#' + @Serial + '#' + @ObjectID + '#' + @Period)	
	END
	SET @Orders = @Orders + 1
	EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @TransID OUTPUT, @TableName = 'AT9000', @StringKey1 = 'AT', @StringKey2 = @Period, @OutputLen = 16
	INSERT INTO #Keys (Row, Orders, VoucherID, BatchID, TransactionID) VALUES (@Row, @Orders, @VoucherID, @BatchID, @TransID)				
	FETCH NEXT FROM @cKey INTO @Row, @VoucherNo, @InvoiceNo, @Serial, @ObjectID, @Period
END	
CLOSE @cKey

-- Cập nhật khóa
UPDATE		DT
SET			Orders = K.Orders,
			VoucherID = K.VoucherID,
			BatchID = K.BatchID,
			DT.TransactionID = K.TransactionID			
FROM		#Data DT
INNER JOIN	#Keys K
		ON	K.Row = DT.Row

-- Kiểm tra trùng số chứng từ
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckDuplicateVoucherNo', @ColID = 'VoucherNo', @Param1 = 'VoucherID'

-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-- Đẩy dữ liệu vào bảng
INSERT INTO AT9000
(
	APK,				Orders,
	VoucherID,			BatchID,			TransactionID,
	DivisionID,			TranMonth,			TranYear,
	VoucherTypeID,		VoucherNo,
	VoucherDate,		EmployeeID,
	SenderReceiver,		SRDivisionName,		SRAddress,
	Serial,				InvoiceNo,			InvoiceDate,
	VDescription,		BDescription,		CurrencyID,
	ExchangeRate,		ExchangeRateCN,		CurrencyIDCN,
	OriginalAmount,		OriginalAmountCN,	ConvertedAmount,
	DebitAccountID,		CreditAccountID,	DebitBankAccountID,
	VATTypeID,			VATGroupID,
	ObjectID,			TDescription,
	Ana01ID,			Ana02ID,			Ana03ID,			Ana04ID,			Ana05ID,Ana06ID,
	CreateDate,			CreateUserID,		LastModifyDate,		LastModifyUserID,
	TableID,			TransactionTypeID,RefNo01
)
SELECT	APK,				Orders,
		VoucherID,			BatchID,			TransactionID,
		DivisionID,			LEFT(Period, 2),	RIGHT(Period, 4),
		VoucherTypeID,		VoucherNo,
		VoucherDate,		EmployeeID,
		SenderReceiver,		SRDivisionName,		SRAddress,
		Serial,				InvoiceNo,			InvoiceDate,
		VDescription,		BDescription,		CurrencyID,
		ExchangeRate,		ExchangeRate,		CurrencyID,
		OriginalAmount,		OriginalAmount,		ConvertedAmount,
		DebitAccountID,		CreditAccountID,	DebitBankAccountID,
		VATTypeID,			VATGroupID,
		ObjectID,			TDescription,
		Ana01ID,			Ana02ID,			Ana03ID,			Ana04ID,	Ana05ID,Ana06ID,
		GETDATE(),			@UserID,			GETDATE(),			@UserID,
		'AT9000',			'T21',RefNo01
FROM	#Data

LB_RESULT:
SELECT * FROM #Data

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON