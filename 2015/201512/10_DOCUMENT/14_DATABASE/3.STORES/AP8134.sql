IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8134]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8134]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Xử lý Import phụ cấp theo công trình
---- Create on 14/02/2014 by Bảo Anh
---- Modify on 26/12/2014 by Bảo Anh: Nếu file import không nhập tổ nhóm thì lấy từ hồ sơ lương

CREATE PROCEDURE [DBO].[AP8134]
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
--	PRINT @sSQL
	EXEC (@sSQL)
	FETCH NEXT FROM @cCURSOR INTO @ColID, @ColSQLDataType
END

SELECT	X.Data.query('Row').value('.', 'INT') AS Row,
		X.Data.query('DivisionID').value('.', 'NVARCHAR(50)') AS DivisionID,
		X.Data.query('Period').value('.', 'VARCHAR(10)') AS Period,
		X.Data.query('ProjectID').value('.', 'NVARCHAR(50)') AS ProjectID,
		X.Data.query('DepartmentID').value('.', 'NVARCHAR(50)') AS DepartmentID,
		X.Data.query('TeamID').value('.', 'NVARCHAR(50)') AS TeamID,
		X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') AS EmployeeID,
		X.Data.query('BaseSalary').value('.', 'DECIMAL(28,8)') AS BaseSalary,
		X.Data.query('Salary01').value('.', 'DECIMAL(28,8)') AS Salary01,
		X.Data.query('Salary02').value('.', 'DECIMAL(28,8)') AS Salary02,
		X.Data.query('Salary03').value('.', 'DECIMAL(28,8)') AS Salary03,
		X.Data.query('SalaryCoefficient').value('.', 'DECIMAL(28,8)') AS SalaryCoefficient,
		X.Data.query('DutyCoefficient').value('.', 'DECIMAL(28,8)') AS DutyCoefficient,
		X.Data.query('TimeCoefficient').value('.', 'DECIMAL(28,8)') AS TimeCoefficient,
		X.Data.query('C01').value('.', 'DECIMAL(28,8)') AS C01,
		X.Data.query('C02').value('.', 'DECIMAL(28,8)') AS C02,
		X.Data.query('C03').value('.', 'DECIMAL(28,8)') AS C03,
		X.Data.query('C04').value('.', 'DECIMAL(28,8)') AS C04,
		X.Data.query('C05').value('.', 'DECIMAL(28,8)') AS C05,
		X.Data.query('C06').value('.', 'DECIMAL(28,8)') AS C06,
		X.Data.query('C07').value('.', 'DECIMAL(28,8)') AS C07,
		X.Data.query('C08').value('.', 'DECIMAL(28,8)') AS C08,
		X.Data.query('C09').value('.', 'DECIMAL(28,8)') AS C09,
		X.Data.query('C10').value('.', 'DECIMAL(28,8)') AS C10,
		X.Data.query('C11').value('.', 'DECIMAL(28,8)') AS C11,
		X.Data.query('C12').value('.', 'DECIMAL(28,8)') AS C12,
		X.Data.query('C13').value('.', 'DECIMAL(28,8)') AS C13,
		X.Data.query('C14').value('.', 'DECIMAL(28,8)') AS C14,
		X.Data.query('C15').value('.', 'DECIMAL(28,8)') AS C15,
		X.Data.query('C16').value('.', 'DECIMAL(28,8)') AS C16,
		X.Data.query('C17').value('.', 'DECIMAL(28,8)') AS C17,
		X.Data.query('C18').value('.', 'DECIMAL(28,8)') AS C18,
		X.Data.query('C19').value('.', 'DECIMAL(28,8)') AS C19,
		X.Data.query('C20').value('.', 'DECIMAL(28,8)') AS C20,
		X.Data.query('C21').value('.', 'DECIMAL(28,8)') AS C21,
		X.Data.query('C22').value('.', 'DECIMAL(28,8)') AS C22,
		X.Data.query('C23').value('.', 'DECIMAL(28,8)') AS C23,
		X.Data.query('C24').value('.', 'DECIMAL(28,8)') AS C24,
		X.Data.query('C25').value('.', 'DECIMAL(28,8)') AS C25

INTO	#AP8134		
FROM	@XML.nodes('//Data') AS X (Data)

INSERT INTO #Data (
		Row,
		DivisionID,
		Period,
		ProjectID,
		DepartmentID,
		TeamID,
		EmployeeID,
		BaseSalary,
		Salary01,
		Salary02,
		Salary03,
		SalaryCoefficient,
		DutyCoefficient,
		TimeCoefficient,
		C01,
		C02,
		C03,
		C04,
		C05,
		C06,
		C07,
		C08,
		C09,
		C10,
		C11,
		C12,
		C13,
		C14,
		C15,
		C16,
		C17,
		C18,
		C19,
		C20,
		C21,
		C22,
		C23,
		C24,
		C25)
SELECT * FROM #AP8134

---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

---- Kiểm tra dữ liệu không đồng nhất tại phần master
---EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues', @Module = 'ASOFT-WM', @ColID = 'VoucherNo', @Param1 = 'VoucherNo,VoucherDate,RefNo01,RefNo02,ObjectID,WareHouseID,InventoryTypeID,EmployeeID,Description'

--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE		DT
SET			BaseSalary = ROUND(BaseSalary, 0),
			Salary01 = ROUND(DT.Salary01, 0),
			Salary02 = ROUND(DT.Salary02, 0),
			Salary03 = ROUND(DT.Salary03, 0),
			SalaryCoefficient = ROUND(DT.SalaryCoefficient, 0),
			DutyCoefficient = ROUND(DT.DutyCoefficient, 0),
			TimeCoefficient = ROUND(DT.TimeCoefficient, 0),
			C01 = ROUND(DT.C01, 0),
			C02 = ROUND(DT.C02, 0),
			C03 = ROUND(DT.C03, 0),
			C04 = ROUND(DT.C04, 0),
			C05 = ROUND(DT.C05, 0),
			C06 = ROUND(DT.C06, 0),
			C07 = ROUND(DT.C07, 0),
			C08 = ROUND(DT.C08, 0),
			C09 = ROUND(DT.C09, 0),
			C10 = ROUND(DT.C10, 0),
			C11 = ROUND(DT.C11, 0),
			C12 = ROUND(DT.C12, 0),
			C13 = ROUND(DT.C13, 0),
			C14 = ROUND(DT.C14, 0),
			C15 = ROUND(DT.C15, 0),
			C16 = ROUND(DT.C16, 0),
			C17 = ROUND(DT.C17, 0),
			C18 = ROUND(DT.C18, 0),
			C19 = ROUND(DT.C19, 0),
			C20 = ROUND(DT.C20, 0),
			C21 = ROUND(DT.C21, 0),
			C22 = ROUND(DT.C22, 0),
			C23 = ROUND(DT.C23, 0),
			C24 = ROUND(DT.C24, 0),
			C25 = ROUND(DT.C25, 0)
FROM		#Data DT
			
-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-- Đẩy dữ liệu vào bảng HT2430
INSERT INTO HT2430
(
	DivisionID,	ProjectID, EmployeeID, DepartmentID, TranMonth, TranYear, TeamID,
	SalaryCoefficient, TimeCoefficient, DutyCoefficient, BaseSalary, [Salary01], [Salary02], [Salary03],
	[C01], [C02], [C03], [C04], [C05], [C06], [C07], [C08], [C09], [C10],
	[C11], [C12], [C13], [C14], [C15], [C16], [C17], [C18], [C19], [C20], [C21], [C22], [C23], [C24], [C25],
	CreateDate,	CreateUserID, LastModifyUserID,	LastModifyDate	
)

SELECT	DISTINCT
		DivisionID,	ProjectID, EmployeeID, DepartmentID, LEFT(Period, 2), RIGHT(Period, 4),
		
		case when Isnull(TeamID,'') = '' then (Select TeamID From HT2400 Where DivisionID = #Data.DivisionID
												And TranMonth = Cast(LEFT(Period, 2) AS int) And TranYear = CAST(RIGHT(Period, 4) AS int)
												And EmployeeID = #Data.EmployeeID)
										else TeamID end,
		
		SalaryCoefficient, TimeCoefficient, DutyCoefficient, BaseSalary, [Salary01], [Salary02], [Salary03],
		[C01], [C02], [C03], [C04], [C05], [C06], [C07], [C08], [C09], [C10],
		[C11], [C12], [C13], [C14], [C15], [C16], [C17], [C18], [C19], [C20], [C21], [C22], [C23], [C24], [C25],
		GETDATE(), @UserID,	@UserID, GETDATE()
FROM	#Data

LB_RESULT:
SELECT * FROM #Data

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

