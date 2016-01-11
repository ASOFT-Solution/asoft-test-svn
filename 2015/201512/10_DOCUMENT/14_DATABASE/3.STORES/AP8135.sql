IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8135]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP8135]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Xử lý Import Quét dữ liệu chấm công
---- Created on 10/06/2014 by Thanh Sơn

CREATE PROCEDURE [DBO].[AP8135]
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
		X.Data.query('AbsentCardNo').value('.', 'NVARCHAR(50)') AS AbsentCardNo,
		X.Data.query('AbsentDate').value('.', 'DATETIME') AS AbsentDate,
		X.Data.query('InAbsentTime').value('.', 'DATETIME') AS InAbsentTime,
		X.Data.query('OutAbsentTime').value('.', 'DATETIME') AS OutAbsentTime,		
		X.Data.query('MachineCode').value('.', 'NVARCHAR(50)') AS MachineCode,
		X.Data.query('ShiftCode').value('.', 'NVARCHAR(50)') AS ShiftCode,
		X.Data.query('InputMethod').value('.', 'NVARCHAR(50)') AS InputMethod,
		X.Data.query('Notes').value('.', 'NVARCHAR(250)') AS Notes		
		
INTO	#AP8135	
FROM	@XML.nodes('//Data') AS X (Data)

INSERT INTO #Data (Row, DivisionID, Period, AbsentCardNo, AbsentDate, InAbsentTime, OutAbsentTime, MachineCode, ShiftCode, InputMethod, Notes)
SELECT Row, DivisionID, Period, AbsentCardNo, AbsentDate, CONVERT(VARCHAR(20),InAbsentTime,108), CONVERT(VARCHAR(20), OutAbsentTime,108), MachineCode, ShiftCode, 
CASE WHEN InputMethod = '' THEN CONVERT(TINYINT,0) ELSE CONVERT(TINYINT,InputMethod) END, Notes 
FROM #AP8135
---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

---- Kiểm tra dữ liệu không đồng nhất tại phần master
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'ScanTimeRecordData', @Module = 'ASOFT-HRM', @ColID = 'AbsentCardNo', @Param1 = 'DivisionID,AbsentDate,AbsentTime'

-- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
--UPDATE		DT
--SET			AbsentAmount = ROUND(AbsentAmount, 0)
--FROM		#Data DT

			
 -- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-- Đẩy dữ liệu vào bảng HT2406

DECLARE @Cur AS CURSOR,
		@TranMonth INT,
		@TranYear INT,
		@AbsentCardNo NVARCHAR(50),
		@AbsentDate DATETIME,
		@InAbsentTime DATETIME,
		@OutAbsentTime DATETIME,
		@EmployeeID NVARCHAR(50),
		@MachineCode NVARCHAR(50),
		@ShiftCode NVARCHAR(50),
		@InputMethod DECIMAL(3),
		@Notes NVARCHAR(250),
		@Row INT
		
SET @TranMonth = (SELECT TOP 1 LEFT(Period, 2) FROM #Data)
SET @TranYear = (SELECT TOP 1 RIGHT(Period, 4) FROM #Data)

SET @Cur = CURSOR FOR
	SELECT	[Row], AbsentCardNo, AbsentDate, InAbsentTime, OutAbsentTime,  MachineCode, ShiftCode, InputMethod, Notes	
	FROM	#Data
OPEN @Cur
FETCH NEXT FROM @Cur INTO @Row, @AbsentCardNo, @AbsentDate,  @InAbsentTime, @OutAbsentTime, @MachineCode, @ShiftCode, @InputMethod, @Notes
WHILE @@FETCH_STATUS = 0
BEGIN
	--SELECT @Row [Row], @AbsentDate DA, CASE WHEN CONVERT(VARCHAR(8), @OutAbsentTime,108) < CONVERT(VARCHAR(8),@InAbsentTime,108) THEN DATEADD(DAY, 1, @AbsentDate) ELSE @AbsentDate END AA
	---------------------------------------------------------Lưu giờ vào----------------------------------------------------------------------------------------
	INSERT INTO HT2406 (DivisionID, TranMonth, Tranyear, AbsentCardNo, AbsentDate, AbsentTime, MachineCode, ShiftCode, IOCode, InputMethod, Notes )
	VALUES (@DivisionID, @TranMonth, @Tranyear, @AbsentCardNo, @AbsentDate, CONVERT(VARCHAR(8),@InAbsentTime,108), @MachineCode, @ShiftCode, 0, @InputMethod, @Notes )
	
	---------------------------------------------------------Lưu giờ ra----------------------------------------------------------------------------------------
	INSERT INTO HT2406 (DivisionID, TranMonth, Tranyear, AbsentCardNo, AbsentDate, AbsentTime, MachineCode, ShiftCode, IOCode, InputMethod, Notes )
	VALUES (@DivisionID, @TranMonth, @Tranyear, @AbsentCardNo,
		CASE WHEN CONVERT(VARCHAR(8), @OutAbsentTime,108) < CONVERT(VARCHAR(8),@InAbsentTime,108) THEN DATEADD(DAY, 1, @AbsentDate) ELSE @AbsentDate END,
		CONVERT(VARCHAR(8), @OutAbsentTime,108), @MachineCode, @ShiftCode, 1, @InputMethod, @Notes )
		
	FETCH NEXT FROM @Cur INTO @Row, @AbsentCardNo, @AbsentDate, @InAbsentTime, @OutAbsentTime, @MachineCode, @ShiftCode, @InputMethod, @Notes
	
END	
CLOSE @Cur

LB_RESULT:
SELECT * FROM #Data

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
