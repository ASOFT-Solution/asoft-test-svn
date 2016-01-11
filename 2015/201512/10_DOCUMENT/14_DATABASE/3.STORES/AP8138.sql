IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8138]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8138]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Import Excel Bảng Phân Ca
-- <History>
---- Create on 12/03/2015 by Lê Thị Hạnh 
---- Modified on ... by 
---- 
-- <Example>
/*
 AP8138 @DivisionID = 'VK', @UserID = 'ASOFTADMIN', @ImportTemplateID = '', @@XML = ''
 */
 
CREATE PROCEDURE AP8138
( 
	@DivisionID NVARCHAR(50),
	@UserID NVARCHAR(50),	
	@ImportTemplateID NVARCHAR(50),
	@XML XML 
) 
AS
DECLARE @cCURSOR CURSOR,
		@sSQL VARCHAR(1000)
		
DECLARE @ColID NVARCHAR(50), 
		@ColSQLDataType NVARCHAR(50)
		
CREATE TABLE #Data
(
	APK UNIQUEIDENTIFIER DEFAULT(NEWID()),
	Row INT,
	ImportMessage NVARCHAR(MAX) DEFAULT (''),
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
	EXEC (@sSQL)
	FETCH NEXT FROM @cCURSOR INTO @ColID, @ColSQLDataType
END 
-- Thêm dữ liệu vào bảng tạm
SELECT	X.Data.query('Row').value('.', 'INT') AS Row,
		X.Data.query('DivisionID').value('.', 'NVARCHAR(50)') AS DivisionID,
		X.Data.query('Period').value('.', 'VARCHAR(10)') AS Period,
		X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') AS EmployeeID,
		X.Data.query('FullName').value('.', 'NVARCHAR(250)') AS [FullName],
		(CASE WHEN X.Data.query('D01').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D01').value('.', 'NVARCHAR(50)') END) AS D01,
		(CASE WHEN X.Data.query('D02').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D02').value('.', 'NVARCHAR(50)') END) AS D02,
		(CASE WHEN X.Data.query('D03').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D03').value('.', 'NVARCHAR(50)') END) AS D03,
		(CASE WHEN X.Data.query('D04').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D04').value('.', 'NVARCHAR(50)') END) AS D04,
		(CASE WHEN X.Data.query('D05').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D05').value('.', 'NVARCHAR(50)') END) AS D05,
		(CASE WHEN X.Data.query('D06').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D06').value('.', 'NVARCHAR(50)') END) AS D06,
		(CASE WHEN X.Data.query('D07').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D07').value('.', 'NVARCHAR(50)') END) AS D07,
		(CASE WHEN X.Data.query('D08').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D08').value('.', 'NVARCHAR(50)') END) AS D08,
		(CASE WHEN X.Data.query('D09').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D09').value('.', 'NVARCHAR(50)') END) AS D09,
		(CASE WHEN X.Data.query('D10').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D10').value('.', 'NVARCHAR(50)') END) AS D10,
		(CASE WHEN X.Data.query('D11').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D11').value('.', 'NVARCHAR(50)') END) AS D11,
		(CASE WHEN X.Data.query('D12').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D12').value('.', 'NVARCHAR(50)') END) AS D12,
		(CASE WHEN X.Data.query('D13').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D13').value('.', 'NVARCHAR(50)') END) AS D13,
		(CASE WHEN X.Data.query('D14').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D14').value('.', 'NVARCHAR(50)') END) AS D14,
		(CASE WHEN X.Data.query('D15').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D15').value('.', 'NVARCHAR(50)') END) AS D15,
		(CASE WHEN X.Data.query('D16').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D16').value('.', 'NVARCHAR(50)') END) AS D16,
		(CASE WHEN X.Data.query('D17').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D17').value('.', 'NVARCHAR(50)') END) AS D17,
		(CASE WHEN X.Data.query('D18').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D18').value('.', 'NVARCHAR(50)') END) AS D18,
		(CASE WHEN X.Data.query('D19').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D19').value('.', 'NVARCHAR(50)') END) AS D19,
		(CASE WHEN X.Data.query('D20').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D20').value('.', 'NVARCHAR(50)') END) AS D20,
		(CASE WHEN X.Data.query('D21').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D21').value('.', 'NVARCHAR(50)') END) AS D21,
		(CASE WHEN X.Data.query('D22').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D22').value('.', 'NVARCHAR(50)') END) AS D22,
		(CASE WHEN X.Data.query('D23').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D23').value('.', 'NVARCHAR(50)') END) AS D23,
		(CASE WHEN X.Data.query('D24').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D24').value('.', 'NVARCHAR(50)') END) AS D24,
		(CASE WHEN X.Data.query('D25').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D25').value('.', 'NVARCHAR(50)') END) AS D25,
		(CASE WHEN X.Data.query('D26').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D26').value('.', 'NVARCHAR(50)') END) AS D26,
		(CASE WHEN X.Data.query('D27').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D27').value('.', 'NVARCHAR(50)') END) AS D27,
		(CASE WHEN X.Data.query('D28').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D28').value('.', 'NVARCHAR(50)') END) AS D28,
		(CASE WHEN X.Data.query('D29').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D29').value('.', 'NVARCHAR(50)') END) AS D29,
		(CASE WHEN X.Data.query('D30').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D30').value('.', 'NVARCHAR(50)') END) AS D30,
		(CASE WHEN X.Data.query('D31').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('D31').value('.', 'NVARCHAR(50)') END) AS D31,
		X.Data.query('Notes').value('.', 'NVARCHAR(250)') AS Notes
INTO	#AP8138	
FROM	@XML.nodes('//Data') AS X (Data)

INSERT INTO #Data ([Row], DivisionID, Period, EmployeeID, FullName,
			D01, D02, D03, D04, D05, D06, D07, D08, D09, D10, D11, D12, D13, D14, D15, 
			D16, D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, 
			D31, Notes)
SELECT * FROM #AP8138
ORDER BY DivisionID, Period, EmployeeID
---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID
----- Kiểm tra và lưu dữ liệu bảng phân ca
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues', @ColID = 'EmployeeID', @Param1 = 'DivisionID, Period, EmployeeID'
-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage != '')
	GOTO LB_RESULT
--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE DT
SET 
	 D01 = CASE WHEN ISNULL(D01,'') != '' THEN DT.D01 ELSE NULL END,
	 D02 = CASE WHEN ISNULL(D02,'') != '' THEN DT.D02 ELSE NULL END,
	 D03 = CASE WHEN ISNULL(D03,'') != '' THEN DT.D03 ELSE NULL END,
	 D04 = CASE WHEN ISNULL(D04,'') != '' THEN DT.D04 ELSE NULL END,
	 D05 = CASE WHEN ISNULL(D05,'') != '' THEN DT.D05 ELSE NULL END,
	 D06 = CASE WHEN ISNULL(D06,'') != '' THEN DT.D06 ELSE NULL END,
	 D07 = CASE WHEN ISNULL(D07,'') != '' THEN DT.D07 ELSE NULL END,
	 D08 = CASE WHEN ISNULL(D08,'') != '' THEN DT.D08 ELSE NULL END,
	 D09 = CASE WHEN ISNULL(D09,'') != '' THEN DT.D09 ELSE NULL END,
	 D10 = CASE WHEN ISNULL(D10,'') != '' THEN DT.D10 ELSE NULL END,
	 D11 = CASE WHEN ISNULL(D11,'') != '' THEN DT.D11 ELSE NULL END,
	 D12 = CASE WHEN ISNULL(D12,'') != '' THEN DT.D12 ELSE NULL END,
	 D13 = CASE WHEN ISNULL(D13,'') != '' THEN DT.D13 ELSE NULL END,
	 D14 = CASE WHEN ISNULL(D14,'') != '' THEN DT.D14 ELSE NULL END,
	 D15 = CASE WHEN ISNULL(D15,'') != '' THEN DT.D15 ELSE NULL END,
	 D16 = CASE WHEN ISNULL(D16,'') != '' THEN DT.D16 ELSE NULL END,
	 D17 = CASE WHEN ISNULL(D17,'') != '' THEN DT.D17 ELSE NULL END,
	 D18 = CASE WHEN ISNULL(D18,'') != '' THEN DT.D18 ELSE NULL END,
	 D19 = CASE WHEN ISNULL(D19,'') != '' THEN DT.D19 ELSE NULL END,
	 D20 = CASE WHEN ISNULL(D20,'') != '' THEN DT.D20 ELSE NULL END,
	 D21 = CASE WHEN ISNULL(D21,'') != '' THEN DT.D21 ELSE NULL END,
	 D22 = CASE WHEN ISNULL(D22,'') != '' THEN DT.D22 ELSE NULL END,
	 D23 = CASE WHEN ISNULL(D23,'') != '' THEN DT.D23 ELSE NULL END,
	 D24 = CASE WHEN ISNULL(D24,'') != '' THEN DT.D24 ELSE NULL END,
	 D25 = CASE WHEN ISNULL(D25,'') != '' THEN DT.D25 ELSE NULL END,
	 D26 = CASE WHEN ISNULL(D26,'') != '' THEN DT.D26 ELSE NULL END,
	 D27 = CASE WHEN ISNULL(D27,'') != '' THEN DT.D27 ELSE NULL END,
	 D28 = CASE WHEN ISNULL(D28,'') != '' THEN DT.D28 ELSE NULL END,
	 D29 = CASE WHEN ISNULL(D29,'') != '' THEN DT.D29 ELSE NULL END,
	 D30 = CASE WHEN ISNULL(D30,'') != '' THEN DT.D30 ELSE NULL END,
	 D31 = CASE WHEN ISNULL(D31,'') != '' THEN DT.D31 ELSE NULL END,
	 Notes = CASE WHEN ISNULL(Notes,'') != '' THEN DT.Notes ELSE NULL END
FROM #Data DT
-- Insert BẢNG PHÂN CA - HT1025
DECLARE @Cur CURSOR,
		@Row INT,
		@EmployeeID NVARCHAR(50),
		@Period NVARCHAR(10),
		@D01 NVARCHAR(50),
		@D02 NVARCHAR(50),
		@D03 NVARCHAR(50),
		@D04 NVARCHAR(50),
		@D05 NVARCHAR(50),
		@D06 NVARCHAR(50),
		@D07 NVARCHAR(50),
		@D08 NVARCHAR(50),
		@D09 NVARCHAR(50),
		@D10 NVARCHAR(50),
		@D11 NVARCHAR(50),
		@D12 NVARCHAR(50),
		@D13 NVARCHAR(50),
		@D14 NVARCHAR(50),
		@D15 NVARCHAR(50),
		@D16 NVARCHAR(50),
		@D17 NVARCHAR(50),
		@D18 NVARCHAR(50),
		@D19 NVARCHAR(50),
		@D20 NVARCHAR(50),
		@D21 NVARCHAR(50),
		@D22 NVARCHAR(50),
		@D23 NVARCHAR(50),
		@D24 NVARCHAR(50),
		@D25 NVARCHAR(50),
		@D26 NVARCHAR(50),
		@D27 NVARCHAR(50),
		@D28 NVARCHAR(50),
		@D29 NVARCHAR(50),
		@D30 NVARCHAR(50),
		@D31 NVARCHAR(50),
		@Notes NVARCHAR(50),
		@TestID NVARCHAR(50) = ''

SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT [Row], DivisionID, EmployeeID, Period, 
	   D01, D02, D03, D04, D05, D06, D07, D08, D09, D10, D11, D12, D13, D14, D15,
       D16, D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, 
       D31, Notes
FROM #Data
OPEN @Cur
FETCH NEXT FROM @Cur INTO @Row, @DivisionID, @EmployeeID, @Period, 
	   @D01, @D02, @D03, @D04, @D05, @D06, @D07, @D08, @D09, @D10, @D11, @D12, @D13, @D14, @D15,
       @D16, @D17, @D18, @D19, @D20, @D21, @D22, @D23, @D24, @D25, @D26, @D27, @D28, @D29, @D30, 
       @D31, @Notes
WHILE @@FETCH_STATUS = 0
BEGIN
---- Nếu đã có nhân viên trong kỳ thì xoá đi, insert lại, chưa có thì insert mới
	IF EXISTS(SELECT TOP 1 1
			  FROM HT1025 
			  WHERE DivisionID = @DivisionID AND TranMonth = LEFT(@Period,2) 
                    AND TranYear = RIGHT(@Period,4) AND EmployeeID = @EmployeeID)
	BEGIN
		DELETE FROM HT1025 
		WHERE DivisionID = @DivisionID AND TranMonth = LEFT(@Period,2) 
              AND TranYear = RIGHT(@Period,4) AND EmployeeID = @EmployeeID
        INSERT INTO	HT1025(DivisionID, TransactionID, EmployeeID, TranMonth, TranYear, D01,
           			D02, D03, D04, D05, D06, D07, D08, D09, D10, D11, D12, D13, D14, D15,
           			D16, D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29,
           			D30, D31, Notes, CreateUserID, CreateDate, LastModifyUserID,
           			LastModifyDate)
        VALUES(@DivisionID, NEWID(), @EmployeeID, LEFT(@Period,2), RIGHT(@Period,4),
			   @D01, @D02, @D03, @D04, @D05, @D06, @D07, @D08, @D09, @D10, @D11, @D12, @D13, @D14, @D15,
			   @D16, @D17, @D18, @D19, @D20, @D21, @D22, @D23, @D24, @D25, @D26, @D27, @D28, @D29, @D30, 
			   @D31, @Notes, @UserID, GETDATE(), @UserID, GETDATE())
	END
	ELSE 
	BEGIN
		INSERT INTO	HT1025(DivisionID, TransactionID, EmployeeID, TranMonth, TranYear, D01,
           			D02, D03, D04, D05, D06, D07, D08, D09, D10, D11, D12, D13, D14, D15,
           			D16, D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29,
           			D30, D31, Notes, CreateUserID, CreateDate, LastModifyUserID,
           			LastModifyDate)
        VALUES(@DivisionID, NEWID(), @EmployeeID, LEFT(@Period,2), RIGHT(@Period,4),
			   @D01, @D02, @D03, @D04, @D05, @D06, @D07, @D08, @D09, @D10, @D11, @D12, @D13, @D14, @D15,
			   @D16, @D17, @D18, @D19, @D20, @D21, @D22, @D23, @D24, @D25, @D26, @D27, @D28, @D29, @D30, 
			   @D31, @Notes, @UserID, GETDATE(), @UserID, GETDATE())
	END
	
FETCH NEXT FROM @Cur INTO @Row, @DivisionID, @EmployeeID, @Period, 
	   @D01, @D02, @D03, @D04, @D05, @D06, @D07, @D08, @D09, @D10, @D11, @D12, @D13, @D14, @D15,
       @D16, @D17, @D18, @D19, @D20, @D21, @D22, @D23, @D24, @D25, @D26, @D27, @D28, @D29, @D30, 
       @D31, @Notes
END
CLOSE @Cur	

-----------------------------------------------------------------------------------------
LB_RESULT:
SELECT * FROM #Data

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON