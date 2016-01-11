IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8119]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8119]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Xử lý Import dữ liệu mã phân bổ 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 19/10/2011 by Nguyễn Bình Minh
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh

-- <Example>
---- 
CREATE PROCEDURE [DBO].[AP8119]
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
	TransactionID NVARCHAR(50),
	ImportMessage NVARCHAR(500) DEFAULT (''),
	VoucherID NVARCHAR(50),
	SerialNo NVARCHAR(50),
	InvoiceNo NVARCHAR(50),
	InvoiceDate DATETIME,
	CreditAccountID NVARCHAR(50),
	BeginMonth INT,
	BeginYear INT,
	APercent DECIMAL(28,8),
	ConvertedAmount DECIMAL(28,8),
	CONSTRAINT [PK_#Data] PRIMARY KEY CLUSTERED 
	(
		Row ASC
	) ON [PRIMARY]	
)

CREATE TABLE #Keys
(
	Row INT,
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
		X.Data.query('JobID').value('.', 'NVARCHAR(50)') AS JobID,
		X.Data.query('JobName').value('.', 'NVARCHAR(250)') AS JobName,
		X.Data.query('VoucherNo').value('.', 'NVARCHAR(50)') AS VoucherNo,
		X.Data.query('ObjectID').value('.', 'NVARCHAR(50)') AS ObjectID,
		X.Data.query('DebitAccountID').value('.', 'NVARCHAR(50)') AS DebitAccountID,
		X.Data.query('DepValue').value('.', 'DECIMAL(28,8)') AS DepValue,
		X.Data.query('Periods').value('.', 'INT') AS Periods,
		X.Data.query('DepMonths').value('.', 'INT') AS DepMonths,
		X.Data.query('BeginPeriod').value('.', 'VARCHAR(10)') AS BeginPeriod,
		X.Data.query('ApportionAmount').value('.', 'DECIMAL(28,8)') AS ApportionAmount,
		X.Data.query('Description').value('.', 'NVARCHAR(250)') AS Description,
		X.Data.query('Ana01ID').value('.', 'NVARCHAR(50)') AS Ana01ID,
		X.Data.query('Ana02ID').value('.', 'NVARCHAR(50)') AS Ana02ID,
		X.Data.query('Ana03ID').value('.', 'NVARCHAR(50)') AS Ana03ID,
		X.Data.query('Ana04ID').value('.', 'NVARCHAR(50)') AS Ana04ID,
		X.Data.query('Ana05ID').value('.', 'NVARCHAR(50)') AS Ana05ID
INTO	#AP8119		
FROM	@XML.nodes('//Data') AS X (Data)

INSERT INTO #Data (
		Row,			DivisionID,			Period,
		JobID,			JobName,	
		VoucherNo,		ObjectID,
		DebitAccountID,	DepValue,
		Periods,		DepMonths,
		BeginPeriod,	ApportionAmount,	Description,
		Ana01ID,		Ana02ID,			Ana03ID,		Ana04ID,		Ana05ID
)	
SELECT * FROM #AP8119

-- Cập nhật giá trị của VoucherID căn cứ vào VoucherNo để kiểm đối tượng có hợp lệ
UPDATE		DT
SET			DT.VoucherID = AV02.VoucherID
FROM		#Data DT
INNER JOIN	AV1702 AV02
		ON	AV02.VoucherNo = DT.VoucherNo AND AV02.DivisionID = DT.DivisionID
			AND AV02.D_C = 'D' AND AV02.VoucherID IN (SELECT AV01.VoucherID FROM AV1701 AV01 WHERE AV01.D_C = 'D' AND AV01.DivisionID = DT.DivisionID)
			AND AV02.TranMonth + AV02.TranYear * 100 <= (CASE WHEN ISNUMERIC(LEFT(DT.Period, 2)) = 1 AND ISNUMERIC(RIGHT(DT.Period, 4)) = 1 THEN LEFT(DT.Period, 2) + RIGHT(DT.Period, 4) * 100 ELSE 0 END)			 

---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

-- Kiểm tra trùng mã
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckDuplicateJob', @ColID = 'JobID', @Param1 = 'JobID'

-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE		DT
SET			DepValue = ROUND(DepValue, CUR.ConvertedDecimals),
			ApportionAmount = ROUND(ApportionAmount, CUR.ConvertedDecimals),
			APercent = CASE WHEN Periods - DepMonths > 0 THEN 100/(Periods - DepMonths) ELSE 0 END,
			DT.BeginMonth =  LEFT(DT.BeginPeriod, 2),
			DT.BeginYear = RIGHT(DT.BeginPeriod, 4)
FROM		#Data DT
INNER JOIN	AV1004 CUR 
		ON	CUR.CurrencyID = (SELECT TOP 1 BaseCurrencyID FROM AT1101 WHERE DivisionID = @DivisionID) AND CUR.DivisionID = DT.DivisionID

-- Cập nhật thông tin hóa đơn và tài khoản	
UPDATE		DT
SET			DT.TransactionID = AV.TransactionID,
			DT.SerialNo = AV.Serial,
			DT.InvoiceNo = AV.InvoiceNo,
			DT.InvoiceDate = AV.InvoiceDate,
			DT.CreditAccountID = AV.AccountID,
			DT.ConvertedAmount = AV.ConvertedAmount
FROM		#Data DT
INNER JOIN	AV1701 AV
		ON	AV.VoucherID = DT.VoucherID AND AV.ObjectID = DT.ObjectID AND DT.DivisionID = AV.DivisionID AND AV.D_C = 'D'

-- Đẩy dữ liệu vào bảng
INSERT INTO AT1703
(
	APK,
	TransactionID,
	DivisionID,			JobID,			JobName,
	VoucherNo,			VoucherID,	
	SerialNo,			InvoiceNo,		InvoiceDate,
	CreditAccountID,	DebitAccountID,
	Periods,			APercent,
	ConvertedAmount,
	BeginMonth,			BeginYear,
	TranMonth,			TranYear,
	Description,
	ObjectID,
	DepMonths,			ResidualMonths,	
	DepValue,			ResidualValue,
	ApportionAmount,	IsMultiAccount,
	D_C,				UseStatus,
	Ana01ID,			Ana02ID,			Ana03ID,			Ana04ID,			Ana05ID,
	CreateDate,			CreateUserID,		LastModifyDate,		LastModifyUserID
)
SELECT	APK,
		TransactionID,
		DivisionID,			JobID,				JobName,
		VoucherNo,			VoucherID,	
		SerialNo,			InvoiceNo,		InvoiceDate,
		CreditAccountID,	DebitAccountID,
		Periods,			APercent,
		ConvertedAmount,
		BeginMonth,			BeginYear,
		LEFT(Period, 2),	RIGHT(Period, 4),		
		Description,
		ObjectID,
		DepMonths,			(Periods - DepMonths),	
		DepValue,			(ConvertedAmount - DepValue),
		ApportionAmount,	0,
		'D',				0,	
		Ana01ID,			Ana02ID,			Ana03ID,			Ana04ID,	Ana05ID,
		GETDATE(),			@UserID,			GETDATE(),			@UserID		
FROM	#Data

LB_RESULT:
SELECT * FROM #Data