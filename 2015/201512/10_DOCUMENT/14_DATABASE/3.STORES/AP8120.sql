IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8120]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8120]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Xử lý Import dữ liệu tài sản cố định
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 20/10/2011 by Nguyễn Bình Minh
---- Modified on 08/10/2015 by Tieu Mai: Sửa tiền hạch toán theo thiết lập đơn vị-chi nhánh

-- <Example>
---- 
CREATE PROCEDURE [DBO].[AP8120]
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
	BeginMonth INT,
	BeginYear INT,
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
		X.Data.query('AssetID').value('.', 'NVARCHAR(50)') AS AssetID,
		X.Data.query('AssetName').value('.', 'NVARCHAR(250)') AS AssetName,
		X.Data.query('AssetStatus').value('.', 'TINYINT') AS AssetStatus,
		X.Data.query('MethodID').value('.', 'TINYINT') AS MethodID,
		X.Data.query('IsTangible').value('.', 'TINYINT') AS IsTangible,
		X.Data.query('ConvertedAmount').value('.', 'DECIMAL(28,8)') AS ConvertedAmount,
		X.Data.query('Years').value('.', 'INT') AS Years,
		X.Data.query('DepPeriods').value('.', 'INT') AS DepPeriods,
		X.Data.query('DepMonths').value('.', 'INT') AS DepMonths,
		X.Data.query('StartDate').value('.', 'DATETIME') AS StartDate,
		X.Data.query('EndDate').value('.', 'DATETIME') AS EndDate,
		X.Data.query('ResidualValue').value('.', 'DECIMAL(28,8)') AS ResidualValue,
		X.Data.query('BeginPeriod').value('.', 'VARCHAR(10)') AS BeginPeriod,
		X.Data.query('DepPercent').value('.', 'DECIMAL(28,8)') AS DepPercent,
		X.Data.query('DepAmount').value('.', 'DECIMAL(28,8)') AS DepAmount,
		X.Data.query('EstablishDate').value('.', 'DATETIME') AS EstablishDate,
		X.Data.query('CauseID').value('.', 'NVARCHAR(50)') AS CauseID,
		X.Data.query('MadeYear').value('.', 'INT') AS MadeYear,
		X.Data.query('CountryID').value('.', 'NVARCHAR(50)') AS CountryID,
		X.Data.query('Serial').value('.', 'NVARCHAR(50)') AS Serial,
		X.Data.query('AssetGroupID').value('.', 'NVARCHAR(50)') AS AssetGroupID,
		X.Data.query('DepartmentID').value('.', 'NVARCHAR(50)') AS DepartmentID,
		X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') AS EmployeeID,
		X.Data.query('Notes').value('.', 'NVARCHAR(250)') AS Notes,
		X.Data.query('AssetAccountID').value('.', 'NVARCHAR(50)') AS AssetAccountID,
		X.Data.query('DepAccountID').value('.', 'NVARCHAR(50)') AS DepAccountID,
		X.Data.query('SourceID1').value('.', 'NVARCHAR(50)') AS SourceID1,
		X.Data.query('DebitDepAccountID1').value('.', 'NVARCHAR(50)') AS DebitDepAccountID1,
		X.Data.query('Ana01ID').value('.', 'NVARCHAR(50)') AS Ana01ID,
		X.Data.query('Ana02ID').value('.', 'NVARCHAR(50)') AS Ana02ID,
		X.Data.query('Ana03ID').value('.', 'NVARCHAR(50)') AS Ana03ID,
		X.Data.query('Ana04ID').value('.', 'NVARCHAR(50)') AS Ana04ID,
		X.Data.query('Ana05ID').value('.', 'NVARCHAR(50)') AS Ana05ID
INTO	#AP8120		
FROM	@XML.nodes('//Data') AS X (Data)

INSERT INTO #Data (
		Row,				DivisionID,			Period,
		AssetID,			AssetName,		
		AssetStatus,		MethodID,		IsTangible,
		ConvertedAmount,	Years,			DepPeriods,		DepMonths,
		StartDate,			EndDate,		ResidualValue,	BeginPeriod,
		DepPercent,			DepAmount,		EstablishDate,	CauseID,
		MadeYear,			CountryID,		Serial,			AssetGroupID,
		DepartmentID,		EmployeeID,		Notes,
		AssetAccountID,		DepAccountID,	SourceID1,		DebitDepAccountID1,
		Ana01ID,			Ana02ID,		Ana03ID,		Ana04ID,				Ana05ID
)
SELECT * FROM #AP8120

---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

-- Kiểm tra trùng mã
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckDuplicateAsset', @ColID = 'AssetID', @Param1 = 'AssetID'

-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE		DT
SET			ConvertedAmount = ROUND(ConvertedAmount, CUR.ConvertedDecimals),
			ResidualValue = ROUND(ResidualValue, CUR.ConvertedDecimals),
			DepAmount = ROUND(DepAmount, CUR.ConvertedDecimals),
			BeginMonth = LEFT(DT.BeginPeriod, 2),
			BeginYear = RIGHT(DT.BeginPeriod, 4)
FROM		#Data DT
INNER JOIN	AV1004 CUR 
		ON	CUR.CurrencyID = (SELECT TOP 1 BaseCurrencyID FROM AT1101 WHERE DivisionID = @DivisionID) AND CUR.DivisionID = DT.DivisionID

-- Đẩy dữ liệu vào bảng
INSERT INTO AT1503
(
	APK,
	DivisionID,			AssetID,			AssetName,
	AssetStatus,		ConvertedAmount,	AssetGroupID,
	AssetAccountID,		DepAccountID,		Years,
	StartDate,			EndDate,
	BeginMonth,			BeginYear,
	ResidualValue,		DepPeriods,
	MethodID,			Serial,
	CountryID,			MadeYear,		    IsTangible,
	DepartmentID,		EmployeeID,
	SourceID1,			SourceAmount1,		SourcePercent1,
	DebitDepAccountID1,	DepPercent1,
	DepPercent,			DepAmount,
	EstablishDate,		Notes,
	CauseID,			DepMonths,
	Ana01ID1,			Ana02ID1,			Ana03ID1,			Ana04ID1,			Ana05ID1,      
	CreateDate,			CreateUserID,		LastModifyDate,		LastModifyUserID
)
SELECT	APK,
		DivisionID,			AssetID,			AssetName,
		AssetStatus,		ConvertedAmount,	AssetGroupID,
		AssetAccountID,		DepAccountID,		Years,
		StartDate,			EndDate,
		BeginMonth,			BeginYear,
		ResidualValue,		DepPeriods,
		MethodID,			Serial,
		CountryID,			MadeYear,		    IsTangible,
		DepartmentID,		EmployeeID,
		SourceID1,			ConvertedAmount,	100,
		DebitDepAccountID1,	100,
		DepPercent,			DepAmount,
		EstablishDate,		Notes,
		CauseID,			DepMonths,
		Ana01ID,			Ana02ID,			Ana03ID,			Ana04ID,	Ana05ID,
		GETDATE(),			@UserID,			GETDATE(),			@UserID		
FROM	#Data

LB_RESULT:
SELECT * FROM #Data

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

