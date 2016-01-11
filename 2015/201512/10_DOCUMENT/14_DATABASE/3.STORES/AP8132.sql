IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8132]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8132]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Xử lý Import chấm công theo công trình
---- Created on 05/10/2013 by Bảo Anh

CREATE PROCEDURE [DBO].[AP8132]
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
	ImportMessage NVARCHAR(500) DEFAULT (''),
	CONSTRAINT [PK_#Data] PRIMARY KEY CLUSTERED 
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
---	PRINT @sSQL
	EXEC (@sSQL)
	FETCH NEXT FROM @cCURSOR INTO @ColID, @ColSQLDataType
END

SELECT	X.Data.query('Row').value('.', 'INT') AS Row,
		X.Data.query('DivisionID').value('.', 'NVARCHAR(50)') AS DivisionID,
		X.Data.query('Period').value('.', 'VARCHAR(10)') AS Period,
		X.Data.query('ProjectID').value('.', 'NVARCHAR(50)') AS ProjectID,
		X.Data.query('PeriodID').value('.', 'NVARCHAR(50)') AS PeriodID,
		X.Data.query('BeginDate').value('.', 'DATETIME') AS BeginDate,
		X.Data.query('EndDate').value('.', 'DATETIME') AS EndDate,
		X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') AS EmployeeID,
		X.Data.query('DepartmentID').value('.', 'NVARCHAR(50)') AS DepartmentID,
		X.Data.query('TeamID').value('.', 'NVARCHAR(50)') AS TeamID,
		X.Data.query('AbsentTypeID').value('.', 'NVARCHAR(50)') AS AbsentTypeID,
		X.Data.query('AbsentAmount').value('.', 'DECIMAL(28,8)') AS AbsentAmount
		
INTO	#AP8131		
FROM	@XML.nodes('//Data') AS X (Data)


INSERT INTO #Data (
		Row,
		DivisionID,
		Period,
		ProjectID,
		PeriodID,
		BeginDate,
		EndDate,
		EmployeeID,
		DepartmentID,
		TeamID,
		AbsentTypeID,
		AbsentAmount		
		)
SELECT * FROM #AP8131


---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

---- Kiểm tra dữ liệu không đồng nhất tại phần master
---EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues', @Module = 'ASOFT-WM', @ColID = 'VoucherNo', @Param1 = 'VoucherNo,VoucherDate,RefNo01,RefNo02,ObjectID,WareHouseID,InventoryTypeID,EmployeeID,Description'

--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE		DT
SET			AbsentAmount = ROUND(AbsentAmount, 0)
FROM		#Data DT

			
-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-- Đẩy dữ liệu vào bảng HT2432

DECLARE @Cur AS CURSOR
DECLARE 
		@ProjectID NVARCHAR(50),
		@PeriodID NVARCHAR(50),
		@DepartmentID NVARCHAR(50),
		@TeamID NVARCHAR(50),
		@EmployeeID NVARCHAR(50),
		@TranMonth INT,
		@TranYear INT,
		@AbsentTypeID NVARCHAR(50),
		@AbsentAmount DECIMAL(28,8),
		@BeginDate datetime,
		@EndDate datetime,		
		@Row int
		
SET @TranMonth = (SELECT TOP 1 LEFT(Period, 2) FROM #Data)
SET @TranYear = (SELECT TOP 1 RIGHT(Period, 4) FROM #Data)

SET @Cur = CURSOR FOR
	SELECT	Row , ProjectID, PeriodID, DepartmentID, TeamID, EmployeeID, AbsentTypeID, AbsentAmount, BeginDate, EndDate
	FROM	#Data
		
OPEN @Cur
FETCH NEXT FROM @Cur INTO @Row, @ProjectID, @PeriodID, @DepartmentID, @TeamID, @EmployeeID, @AbsentTypeID, @AbsentAmount, @BeginDate, @EndDate
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC HP2611  @DivisionID, @ProjectID, @PeriodID, @DepartmentID, @TeamID, @EmployeeID, @TranMonth, @TranYear, @AbsentTypeID, @AbsentAmount, @UserID, @BeginDate, @EndDate

	FETCH NEXT FROM @Cur INTO @Row, @ProjectID, @PeriodID, @DepartmentID, @TeamID, @EmployeeID, @AbsentTypeID, @AbsentAmount, @BeginDate, @EndDate
END	
CLOSE @Cur

LB_RESULT:
SELECT * FROM #Data


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

