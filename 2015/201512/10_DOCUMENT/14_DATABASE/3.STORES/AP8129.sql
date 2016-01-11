IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8129]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8129]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Tạm ứng theo CMND
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 16/07/2013 by Lê Thị Thu Hiền
---- Modified on 02/07/2013 by 
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ, tiền hạch toán theo thiết lập đơn vị-chi nhánh
-- <Example>
---- 
CREATE PROCEDURE AP8129
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
		X.Data.query('CMND').value('.', 'NVARCHAR(50)') AS EmployeeID,
		X.Data.query('AdvanceDate').value('.', 'DATETIME') AS AdvanceDate,
		X.Data.query('AdvanceAmount').value('.', 'DECIMAL(28,8)') AS AdvanceAmount,
		X.Data.query('Notes').value('.', 'NVARCHAR(250)') AS Notes

INTO	#AP8129		
FROM	@XML.nodes('//Data') AS X (Data)


INSERT INTO #Data (
		Row,
		DivisionID,
		Period,
		CMND,
		AdvanceDate,
		AdvanceAmount,		
		Notes
		)
SELECT * FROM #AP8129


---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

------ Kiểm tra dữ liệu không đồng nhất tại phần master
--EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues',@Module = 'ASOFT-HRM', @ColID = 'RequestNo', @Param1 = 'RequestNo,RequestDate,ContractNo,ContractDate,CurrencyID,ExchangeRate,ClassifyID,MasterShipDate,InventoryTypeID,EmployeeID,Description,ObjectID,DueDate,OrderAddress,ReceivedAddress,Transport,PaymentID,POAna01ID,POAna02ID,POAna03ID,POAna04ID,POAna05ID'

---- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
DECLARE @BaseCurrencyID AS NVARCHAR(50)
SET @BaseCurrencyID = ''
SET @BaseCurrencyID = (SELECT TOP 1 BaseCurrencyID FROM AT1101 WHERE DivisionID = @DivisionID)

UPDATE		DT
SET			AdvanceAmount = ROUND(AdvanceAmount, CUR.ConvertedDecimals),
			AdvanceDate = CASE WHEN AdvanceDate IS NOT NULL THEN CONVERT(datetime, CONVERT(varchar(10), AdvanceDate, 101)) END
FROM		#Data DT
INNER JOIN	AV1004 CUR
		ON	CUR.CurrencyID = @BaseCurrencyID AND CUR.DivisionID = DT.DivisionID

			
-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

----------- INSERT 

DECLARE @Cur AS CURSOR
DECLARE @DepartmentID NVARCHAR(50),
		@TeamID NVARCHAR(50),
		@EmployeeID NVARCHAR(50),
		@CMND NVARCHAR(50),
		@AdvanceDate DATETIME,
		@AdvanceAmount DECIMAL(28,8),
		@Notes NVARCHAR(250),
		@TranMonth INT,
		@TranYear INT,
		@Row int
		
SET @TranMonth = (SELECT TOP 1 LEFT(Period, 2) FROM #Data)
SET @TranYear = (SELECT TOP 1 RIGHT(Period, 4) FROM #Data)

SET @Cur = CURSOR FOR
	SELECT	Row , CMND, AdvanceDate, AdvanceAmount,Notes
	FROM	#Data
		
OPEN @Cur
FETCH NEXT FROM @Cur INTO 	@Row, @CMND, @AdvanceDate, @AdvanceAmount, @Notes
WHILE @@FETCH_STATUS = 0
BEGIN
	
	SELECT	@EmployeeID = EmployeeID, @DepartmentID = DepartmentID , @TeamID = TeamID
	FROM	HT1400
	WHERE	IdentifyCardNo = @CMND
			AND DivisionID = @DivisionID
	
	
	EXEC HP2405   0, NULL, @DivisionID, '%', '%', @EmployeeID, @AdvanceDate, @TranMonth, @TranYear, @Notes, 0, @AdvanceAmount, 0, '', @UserID

	FETCH NEXT FROM @Cur INTO @Row, @CMND, @AdvanceDate, @AdvanceAmount, @Notes
END	
CLOSE @Cur



LB_RESULT:
SELECT * FROM #Data

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

