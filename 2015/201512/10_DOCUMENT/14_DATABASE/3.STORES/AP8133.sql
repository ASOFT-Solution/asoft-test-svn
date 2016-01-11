IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP8133]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP8133]
GO


---- Xử lý Import phiếu thu chi
---- Create on 02/01/2014 by Khánh Vân

CREATE PROCEDURE [dbo].[AP8133]
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@TranMonth as int,	
	@TranYear as int,	
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
	SELECT		ColID, ColSQLDataType
	FROM		ATT9000 
	ORDER BY	OrderNum

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

INSERT INTO #Data (	Row,  TransactionTypeID, VoucherNo, VoucherDate,		
		SenderReceiver,	SRAddress,DebitAccountID, CreditAccountID, VDescription,
		Serial,	InvoiceNo,	InvoiceDate, OriginalAmount, ObjectID)		
SELECT	X.Data.query('Row').value('.', 'INT') AS Row,
		X.Data.query('TransactionTypeID').value('.', 'NVARCHAR(50)') AS VoucherTypeID,
		X.Data.query('VoucherNo').value('.', 'NVARCHAR(50)') AS VoucherNo,
		X.Data.query('VoucherDate').value('.', 'DATETIME') AS VoucherDate,
		X.Data.query('SenderReceiver').value('.', 'NVARCHAR(250)') AS SenderReceiver,
		X.Data.query('SRAddress').value('.', 'NVARCHAR(50)') AS SRAddress,
		X.Data.query('DebitAccountID').value('.', 'NVARCHAR(50)') AS DebitAccountID,
		X.Data.query('CreditAccountID').value('.', 'NVARCHAR(50)') AS CreditAccountID,
		X.Data.query('VDescription').value('.', 'NVARCHAR(250)') AS VDescription,
		X.Data.query('Serial').value('.', 'NVARCHAR(50)') AS Serial,
		X.Data.query('InvoiceNo').value('.', 'NVARCHAR(50)') AS InvoiceNo,
		X.Data.query('InvoiceDate').value('.', 'DATETIME') AS InvoiceDate,
		X.Data.query('OriginalAmount').value('.', 'DECIMAL(28,8)') AS OriginalAmount,
		X.Data.query('ObjectID').value('.', 'NVARCHAR(50)') AS ObjectID

FROM	@XML.nodes('//Data') AS X (Data)

-- Đẩy dữ liệu vào bảng
INSERT INTO AT9000
(
	APK,				Orders,
	VoucherID,			BatchID,			TransactionID,
	DivisionID,			TranMonth,			TranYear,
	VoucherTypeID,		VoucherNo,
	VoucherDate,		EmployeeID,
	SenderReceiver,		SRAddress,
	Serial,				InvoiceNo,			InvoiceDate,
	VDescription,		CurrencyID,
	ExchangeRate,		ExchangeRateCN,		CurrencyIDCN,
	OriginalAmount,		OriginalAmountCN,	ConvertedAmount,
	DebitAccountID,		CreditAccountID,
	ObjectID,	CreateDate,			CreateUserID,		LastModifyDate,		LastModifyUserID,
	TableID,			TransactionTypeID
)
SELECT	APK,				1,
		NEWID(),			NEWID(),			NEWID(),
		@DivisionID,		@TranMonth,	@TranYear,
		TransactionTypeID,	VoucherNo,
		VoucherDate,		@UserID,
		SenderReceiver,		SRAddress,
		Serial,				InvoiceNo,			InvoiceDate,
		VDescription,			'VND',
		1,		1,		'VND',
		OriginalAmount,		OriginalAmount,		OriginalAmount,
		DebitAccountID,		CreditAccountID,
		ObjectID,	GETDATE(),			@UserID,			GETDATE(),			@UserID,
		'AT9000',(Case when TransactionTypeID ='PT' then 'T01'else 'T02' end)		
FROM	#Data

LB_RESULT:
SELECT * FROM #Data
