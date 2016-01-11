IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8131]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8131]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Xử lý Import hồ sơ lương
---- Create on 03/10/2013 by Bảo Anh
---- Modified on 13/03/2015 by Lê Thị Hạnh: Bổ sung convert dữ liệu, nếu hồ sơ đã có thì cập nhật[Lỗi convert varchar to numeric], Với APSG thì cập nhật hệ số và các thông tin nếu nhập vào
---- Modified on 01/11/2015 by Bảo Anh: Xử lý cập nhật UPDATE hồ sơ lương cho Tiên Tiến như APSG
---- Modified on 18/11/2015 by Bảo Anh: Sửa lỗi import sai các hệ số lương

CREATE PROCEDURE [DBO].[AP8131]
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
	EmpFileID NVARCHAR(50) NULL,
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
	EmpFileID NVARCHAR(50),
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
---	PRINT @sSQL
	EXEC (@sSQL)
	FETCH NEXT FROM @cCURSOR INTO @ColID, @ColSQLDataType
END

SELECT	X.Data.query('Row').value('.', 'INT') AS Row,
		X.Data.query('DivisionID').value('.', 'NVARCHAR(50)') AS DivisionID,
		X.Data.query('Period').value('.', 'VARCHAR(10)') AS Period,
		X.Data.query('DepartmentID').value('.', 'NVARCHAR(50)') AS DepartmentID,
		(CASE WHEN X.Data.query('TeamID').value('.', 'NVARCHAR(50)') = '' THEN NULL ELSE X.Data.query('TeamID').value('.', 'NVARCHAR(50)') END) AS TeamID,
		X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') AS EmployeeID,
		(CASE WHEN X.Data.query('TaxObjectID').value('.', 'NVARCHAR(50)') = '' THEN NULL ELSE X.Data.query('TaxObjectID').value('.', 'NVARCHAR(50)') END) AS TaxObjectID,
		(CASE WHEN X.Data.query('BaseSalary').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('BaseSalary').value('.', 'DECIMAL(28,8)') END) AS BaseSalary,
		(CASE WHEN X.Data.query('InsuranceSalary').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('InsuranceSalary').value('.', 'DECIMAL(28,8)') END) AS InsuranceSalary,
		(CASE WHEN X.Data.query('Salary01').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Salary01').value('.', 'DECIMAL(28,8)') END) AS Salary01,
		(CASE WHEN X.Data.query('Salary02').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Salary02').value('.', 'DECIMAL(28,8)') END) AS Salary02,
		(CASE WHEN X.Data.query('Salary03').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Salary03').value('.', 'DECIMAL(28,8)') END) AS Salary03,
		(CASE WHEN X.Data.query('SalaryCoefficient').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('SalaryCoefficient').value('.', 'DECIMAL(28,8)') END) AS SalaryCoefficient,
		(CASE WHEN X.Data.query('DutyCoefficient').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('DutyCoefficient').value('.', 'DECIMAL(28,8)') END) AS DutyCoefficient,
		(CASE WHEN X.Data.query('TimeCoefficient').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('TimeCoefficient').value('.', 'DECIMAL(28,8)') END) AS TimeCoefficient,
		(CASE WHEN X.Data.query('C01').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C01').value('.', 'DECIMAL(28,8)') END) AS C01,
		(CASE WHEN X.Data.query('C02').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C02').value('.', 'DECIMAL(28,8)') END) AS C02,
		(CASE WHEN X.Data.query('C03').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C03').value('.', 'DECIMAL(28,8)') END) AS C03,
		(CASE WHEN X.Data.query('C04').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C04').value('.', 'DECIMAL(28,8)') END) AS C04,
		(CASE WHEN X.Data.query('C05').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C05').value('.', 'DECIMAL(28,8)') END) AS C05,
		(CASE WHEN X.Data.query('C06').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C06').value('.', 'DECIMAL(28,8)') END) AS C06,
		(CASE WHEN X.Data.query('C07').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C07').value('.', 'DECIMAL(28,8)') END) AS C07,
		(CASE WHEN X.Data.query('C08').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C08').value('.', 'DECIMAL(28,8)') END) AS C08,
		(CASE WHEN X.Data.query('C09').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C09').value('.', 'DECIMAL(28,8)') END) AS C09,
		(CASE WHEN X.Data.query('C10').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C10').value('.', 'DECIMAL(28,8)') END) AS C10,
		(CASE WHEN X.Data.query('C11').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C11').value('.', 'DECIMAL(28,8)') END) AS C11,
		(CASE WHEN X.Data.query('C12').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C12').value('.', 'DECIMAL(28,8)') END) AS C12,
		(CASE WHEN X.Data.query('C13').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C13').value('.', 'DECIMAL(28,8)') END) AS C13,
		(CASE WHEN X.Data.query('C14').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C14').value('.', 'DECIMAL(28,8)') END) AS C14,
		(CASE WHEN X.Data.query('C15').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C15').value('.', 'DECIMAL(28,8)') END) AS C15,
		(CASE WHEN X.Data.query('C16').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C16').value('.', 'DECIMAL(28,8)') END) AS C16,
		(CASE WHEN X.Data.query('C17').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C17').value('.', 'DECIMAL(28,8)') END) AS C17,
		(CASE WHEN X.Data.query('C18').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C18').value('.', 'DECIMAL(28,8)') END) AS C18,
		(CASE WHEN X.Data.query('C19').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C19').value('.', 'DECIMAL(28,8)') END) AS C19,
		(CASE WHEN X.Data.query('C20').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C20').value('.', 'DECIMAL(28,8)') END) AS C20,
		(CASE WHEN X.Data.query('C21').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C21').value('.', 'DECIMAL(28,8)') END) AS C21,
		(CASE WHEN X.Data.query('C22').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C22').value('.', 'DECIMAL(28,8)') END) AS C22,
		(CASE WHEN X.Data.query('C23').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C23').value('.', 'DECIMAL(28,8)') END) AS C23,
		(CASE WHEN X.Data.query('C24').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C24').value('.', 'DECIMAL(28,8)') END) AS C24,
		(CASE WHEN X.Data.query('C25').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('C25').value('.', 'DECIMAL(28,8)') END) AS C25,
		(CASE WHEN X.Data.query('IsJobWage').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('IsJobWage').value('.', 'DECIMAL(28,8)') END) AS IsJobWage,
		(CASE WHEN X.Data.query('IsPiecework').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('IsPiecework').value('.', 'DECIMAL(28,8)') END) AS IsPiecework
INTO	#AP8131		
FROM	@XML.nodes('//Data') AS X (Data)


INSERT INTO #Data (
		Row,
		DivisionID,
		Period,
		DepartmentID,
		TeamID,
		EmployeeID,
		TaxObjectID,
		BaseSalary,
		InsuranceSalary,
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
		C25,
		IsJobWage,
		IsPiecework
		)
SELECT * FROM #AP8131


---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID

---- Kiểm tra dữ liệu không đồng nhất tại phần master
---EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues', @Module = 'ASOFT-WM', @ColID = 'VoucherNo', @Param1 = 'VoucherNo,VoucherDate,RefNo01,RefNo02,ObjectID,WareHouseID,InventoryTypeID,EmployeeID,Description'

--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE		DT
SET			BaseSalary = ROUND(DT.BaseSalary,A.OriginalDecimals ),
			InsuranceSalary = ROUND(DT.InsuranceSalary,A.OriginalDecimals),	
			Salary01 = ROUND(DT.Salary01,A.CoefficientDecimals),
			Salary02 = ROUND(DT.Salary02,A.CoefficientDecimals),
			Salary03 = ROUND(DT.Salary03,A.CoefficientDecimals),
			SalaryCoefficient = ROUND(DT.SalaryCoefficient,A.CoefficientDecimals),
			DutyCoefficient = ROUND(DT.DutyCoefficient,A.CoefficientDecimals),
			TimeCoefficient = ROUND(DT.TimeCoefficient,A.CoefficientDecimals),
			C01 = ROUND(DT.C01,A.CoefficientDecimals),
			C02 = ROUND(DT.C02,A.CoefficientDecimals),
			C03 = ROUND(DT.C03,A.CoefficientDecimals),
			C04 = ROUND(DT.C04,A.CoefficientDecimals),
			C05 = ROUND(DT.C05,A.CoefficientDecimals),
			C06 = ROUND(DT.C06,A.CoefficientDecimals),
			C07 = ROUND(DT.C07,A.CoefficientDecimals),
			C08 = ROUND(DT.C08,A.CoefficientDecimals),
			C09 = ROUND(DT.C09,A.CoefficientDecimals),
			C10 = ROUND(DT.C10,A.CoefficientDecimals),
			C11 = ROUND(DT.C11,A.CoefficientDecimals),
			C12 = ROUND(DT.C12,A.CoefficientDecimals),
			C13 = ROUND(DT.C13,A.CoefficientDecimals),
			C14 = ROUND(DT.C14,A.CoefficientDecimals),
			C15 = ROUND(DT.C15,A.CoefficientDecimals),
			C16 = ROUND(DT.C16,A.CoefficientDecimals),
			C17 = ROUND(DT.C17,A.CoefficientDecimals),
			C18 = ROUND(DT.C18,A.CoefficientDecimals),
			C19 = ROUND(DT.C19,A.CoefficientDecimals),
			C20 = ROUND(DT.C20,A.CoefficientDecimals),
			C21 = ROUND(DT.C21,A.CoefficientDecimals),
			C22 = ROUND(DT.C22,A.CoefficientDecimals),
			C23 = ROUND(DT.C23,A.CoefficientDecimals),
			C24 = ROUND(DT.C24,A.CoefficientDecimals),
			C25 = ROUND(DT.C25,A.CoefficientDecimals)
FROM		#Data DT
LEFT JOIN	HT0000 A ON A.DivisionID = DT.DivisionID			
-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT


-- Sinh khóa
DECLARE @cKey AS CURSOR
DECLARE @Row AS INT,
		@Orders AS INT,
		@Period AS NVARCHAR(50),
		@EmpFileID AS NVARCHAR(50),
		@TranMonth nvarchar(2),
		@TranYear nvarchar(2),
		@EmployeeID NVARCHAR(50)

SET @Orders = 0
SET @cKey = CURSOR FOR
	SELECT	Row, Period, EmployeeID
	FROM	#Data
		
OPEN @cKey
FETCH NEXT FROM @cKey INTO @Row, @Period, @EmployeeID
WHILE @@FETCH_STATUS = 0
BEGIN
	-- Bổ sung điều kiện, nếu hồ sơ nhân viên đã có trong kỳ thì lấy HT2400.EmpFileID
	IF EXISTS (SELECT TOP 1 1
			   FROM HT2400
			   WHERE DivisionID = @DivisionID AND TranMonth = LEFT(@Period,2) 
                     AND TranYear = RIGHT(@Period,4) AND EmployeeID = @EmployeeID)
	BEGIN
		SET @EmpFileID = (SELECT TOP 1 EmpFileID  
						  FROM HT2400
			              WHERE DivisionID = @DivisionID AND TranMonth = LEFT(@Period,2) 
                                AND TranYear = RIGHT(@Period,4) AND EmployeeID = @EmployeeID)
		SET @Orders = @Orders + 1
	END
	ELSE
	BEGIN
		SET @TranMonth = LEFT(@Period, 2)
		SET @TranYear = RIGHT(@Period, 4)
		EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @EmpFileID OUTPUT, @TableName = 'HT2400', @StringKey1 = 'HS', @StringKey2 = @TranMonth, @StringKey3 = @TranYear, @OutputLen = 15
		SET @Orders = @Orders + 1
	END
	INSERT INTO #Keys (Row, Orders, EmpFileID) VALUES (@Row, @Orders, @EmpFileID)				
	
	FETCH NEXT FROM @cKey INTO @Row, @Period, @EmployeeID
END	
CLOSE @cKey

-- Cập nhật khóa
UPDATE		DT
SET			Orders = K.Orders,
			DT.EmpFileID = K.EmpFileID			
FROM		#Data DT
INNER JOIN	#Keys K
		ON	K.Row = DT.Row

-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

-- Đẩy dữ liệu vào bảng HT2400
DECLARE @Cur CURSOR,
		@DepartmentID NVARCHAR(50),
		@TeamID NVARCHAR(50),
		@TaxObjectID NVARCHAR(50),
		@SalaryCoefficient DECIMAL(28,8),
		@TimeCoefficient DECIMAL(28,8),
		@DutyCoefficient DECIMAL(28,8),
		@BaseSalary DECIMAL(28,8),
		@InsuranceSalary DECIMAL(28,8),
		@Salary01 DECIMAL(28,8),
		@Salary02 DECIMAL(28,8),
		@Salary03 DECIMAL(28,8),
		@C01 DECIMAL(28,8),
		@C02 DECIMAL(28,8),
		@C03 DECIMAL(28,8),
		@C04 DECIMAL(28,8),
		@C05 DECIMAL(28,8),
		@C06 DECIMAL(28,8),
		@C07 DECIMAL(28,8),
		@C08 DECIMAL(28,8),
		@C09 DECIMAL(28,8),
		@C10 DECIMAL(28,8),
		@C11 DECIMAL(28,8),
		@C12 DECIMAL(28,8),
		@C13 DECIMAL(28,8),
		@C14 DECIMAL(28,8),
		@C15 DECIMAL(28,8),
		@C16 DECIMAL(28,8),
		@C17 DECIMAL(28,8),
		@C18 DECIMAL(28,8),
		@C19 DECIMAL(28,8),
		@C20 DECIMAL(28,8),
		@C21 DECIMAL(28,8),
		@C22 DECIMAL(28,8),
		@C23 DECIMAL(28,8),
		@C24 DECIMAL(28,8),
		@C25 DECIMAL(28,8),
		@IsJobWage TINYINT,
		@IsPiecework TINYINT,
		@CustomerName INT 
SET @CustomerName = (SELECT TOP 1 CustomerName FROM CustomerIndex)
SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT [Row], DivisionID, EmpFileID, Period, EmployeeID, DepartmentID, TeamID, TaxObjectID,
       Orders, SalaryCoefficient, TimeCoefficient, DutyCoefficient, Salary01, Salary02, Salary03, 
       BaseSalary, InsuranceSalary, C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11, C12, 
       C13, C14, C15, C16, C17, C18, C19, C20, C21, C22, C23, C24, C25, IsJobWage, IsPiecework 
FROM  #Data
OPEN @Cur
FETCH NEXT FROM @Cur INTO @Row, @DivisionID, @EmpFileID, @Period, @EmployeeID, @DepartmentID, @TeamID, @TaxObjectID,
       @Orders, @SalaryCoefficient, @TimeCoefficient, @DutyCoefficient, @Salary01, @Salary02, @Salary03, 
       @BaseSalary, @InsuranceSalary, @C01, @C02, @C03, @C04, @C05, @C06, @C07, @C08, @C09, @C10, @C11, @C12, @C13, 
       @C14, @C15, @C16, @C17, @C18, @C19, @C20, @C21, @C22, @C23, @C24, @C25, @IsJobWage, @IsPiecework 
WHILE @@FETCH_STATUS = 0
BEGIN
---- Nếu đã có nhân viên trong kỳ thì UPDATE, chưa có thì INSERT 
	IF EXISTS(SELECT TOP 1 1
			  FROM HT2400
			  WHERE DivisionID = @DivisionID AND EmpFileID = @EmpFileID)
	BEGIN
		IF @CustomerName = 36 or @CustomerName = 13 -- Update hệ số cho APSG PETRO hoặc Tiên Tiến
		BEGIN
			UPDATE HT24 SET 
			EmployeeID = @EmployeeID,
			DepartmentID = @DepartmentID,
			TeamID = @TeamID,
			TaxObjectID = @TaxObjectID,
			Orders = @Orders,
			SalaryCoefficient = CASE WHEN ISNULL(@SalaryCoefficient,0) = 0 THEN HT24.SalaryCoefficient ELSE @SalaryCoefficient END,
			TimeCoefficient = CASE WHEN ISNULL(@TimeCoefficient,0) = 0 THEN HT24.TimeCoefficient ELSE @TimeCoefficient END,
			DutyCoefficient = CASE WHEN ISNULL(@DutyCoefficient,0) = 0 THEN HT24.DutyCoefficient ELSE @DutyCoefficient END,
			Salary01 = CASE WHEN ISNULL(@Salary01,0) = 0 THEN HT24.Salary01 ELSE @Salary01 END,
			Salary02 = CASE WHEN ISNULL(@Salary02,0) = 0 THEN HT24.Salary02 ELSE @Salary02 END,
			Salary03 = CASE WHEN ISNULL(@Salary03,0) = 0 THEN HT24.Salary03 ELSE @Salary03 END,
			BaseSalary = CASE WHEN ISNULL(@BaseSalary,0) = 0 THEN HT24.BaseSalary ELSE @BaseSalary END,
			InsuranceSalary = CASE WHEN ISNULL(@InsuranceSalary,0) = 0 THEN HT24.InsuranceSalary ELSE @InsuranceSalary END,
			C01 = CASE WHEN ISNULL(@C01,0) = 0 THEN HT24.C01 ELSE @C01 END,
			C02 = CASE WHEN ISNULL(@C02,0) = 0 THEN HT24.C02 ELSE @C02 END,
			C03 = CASE WHEN ISNULL(@C03,0) = 0 THEN HT24.C03 ELSE @C03 END,
			C04 = CASE WHEN ISNULL(@C04,0) = 0 THEN HT24.C04 ELSE @C04 END,
			C05 = CASE WHEN ISNULL(@C05,0) = 0 THEN HT24.C05 ELSE @C05 END,
			C06 = CASE WHEN ISNULL(@C06,0) = 0 THEN HT24.C06 ELSE @C06 END,
			C07 = CASE WHEN ISNULL(@C07,0) = 0 THEN HT24.C07 ELSE @C07 END,
			C08 = CASE WHEN ISNULL(@C08,0) = 0 THEN HT24.C08 ELSE @C08 END,
			C09 = CASE WHEN ISNULL(@C09,0) = 0 THEN HT24.C09 ELSE @C09 END,
			C10 = CASE WHEN ISNULL(@C10,0) = 0 THEN HT24.C10 ELSE @C10 END,
			C11 = CASE WHEN ISNULL(@C11,0) = 0 THEN HT24.C11 ELSE @C11 END,
			C12 = CASE WHEN ISNULL(@C12,0) = 0 THEN HT24.C12 ELSE @C12 END,
			C13 = CASE WHEN ISNULL(@C13,0) = 0 THEN HT24.C13 ELSE @C13 END,
			C14 = CASE WHEN ISNULL(@C14,0) = 0 THEN HT24.C14 ELSE @C14 END,
			C15 = CASE WHEN ISNULL(@C15,0) = 0 THEN HT24.C15 ELSE @C15 END,
			C16 = CASE WHEN ISNULL(@C16,0) = 0 THEN HT24.C16 ELSE @C16 END,
			C17 = CASE WHEN ISNULL(@C17,0) = 0 THEN HT24.C17 ELSE @C17 END,
			C18 = CASE WHEN ISNULL(@C18,0) = 0 THEN HT24.C18 ELSE @C18 END,
			C19 = CASE WHEN ISNULL(@C19,0) = 0 THEN HT24.C19 ELSE @C19 END,
			C20 = CASE WHEN ISNULL(@C20,0) = 0 THEN HT24.C20 ELSE @C20 END,
			C21 = CASE WHEN ISNULL(@C21,0) = 0 THEN HT24.C21 ELSE @C21 END,
			C22 = CASE WHEN ISNULL(@C22,0) = 0 THEN HT24.C22 ELSE @C22 END,
			C23 = CASE WHEN ISNULL(@C23,0) = 0 THEN HT24.C23 ELSE @C23 END,
			C24 = CASE WHEN ISNULL(@C24,0) = 0 THEN HT24.C24 ELSE @C24 END,
			C25 = CASE WHEN ISNULL(@C25,0) = 0 THEN HT24.C25 ELSE @C25 END,
			IsJobWage = CASE WHEN ISNULL(@IsJobWage,0) = 0 THEN HT24.IsJobWage ELSE @IsJobWage END,
			IsPiecework = CASE WHEN ISNULL(@IsPiecework,0) = 0 THEN HT24.IsPiecework ELSE @IsPiecework END,
			LastmodifyUserID = @UserID,
			LastModifyDate = GETDATE()
			FROM HT2400 HT24
			WHERE HT24.DivisionID = @DivisionID AND HT24.EmpFileID = @EmpFileID
		END
		ELSE
		BEGIN		
			UPDATE HT2400 SET 
			EmployeeID = @EmployeeID,
			DepartmentID = @DepartmentID,
			TeamID = @TeamID,
			TaxObjectID = @TaxObjectID,
			Orders = @Orders,
			SalaryCoefficient = @SalaryCoefficient,
			TimeCoefficient = @TimeCoefficient,
			DutyCoefficient = @DutyCoefficient,
			Salary01 = @Salary01,
			Salary02 = @Salary02,
			Salary03 = @Salary03,
			BaseSalary = @BaseSalary,
			InsuranceSalary = @InsuranceSalary,
			C01 = @C01,
			C02 = @C02,
			C03 = @C03,
			C04 = @C04,
			C05 = @C05,
			C06 = @C06,
			C07 = @C07,
			C08 = @C08,
			C09 = @C09,
			C10 = @C10,
			C11 = @C11,
			C12 = @C12,
			C13 = @C13,
			C14 = @C14,
			C15 = @C15,
			C16 = @C16,
			C17 = @C17,
			C18 = @C18,
			C19 = @C19,
			C20 = @C20,
			C21 = @C21,
			C22 = @C22,
			C23 = @C23,
			C24 = @C24,
			C25 = @C25,
			IsJobWage = @IsJobWage,
			IsPiecework = @IsPiecework,
			LastmodifyUserID = @UserID,
			LastModifyDate = GETDATE()
			WHERE DivisionID = @DivisionID AND EmpFileID = @EmpFileID
		END
	END
	ELSE 
	BEGIN
		INSERT INTO HT2400(DivisionID, EmpFileID, EmployeeID, DepartmentID, TranMonth, TranYear, TeamID, TaxObjectID,
					Orders, SalaryCoefficient, TimeCoefficient, DutyCoefficient, Salary01, Salary02, Salary03, 
					BaseSalary, InsuranceSalary, C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11, C12, 
					C13, C14, C15, C16, C17, C18, C19, C20, C21, C22, C23, C24, C25, IsJobWage, IsPiecework, 
					EmployeeStatus,	CreateUserID, CreateDate, LastModifyUserID,	LastModifyDate)
        VALUES(@DivisionID, @EmpFileID, @EmployeeID, @DepartmentID, LEFT(@Period,2), RIGHT(@Period,4), @TeamID, @TaxObjectID,
			   @Orders, @SalaryCoefficient, @TimeCoefficient, @DutyCoefficient, @Salary01, @Salary02, @Salary03, 
			   @BaseSalary, @InsuranceSalary, @C01, @C02, @C03, @C04, @C05, @C06, @C07, @C08, @C09, @C10, @C11, @C12, 
			   @C13, @C14, @C15, @C16, @C17, @C18, @C19, @C20, @C21, @C22, @C23, @C24, @C25, @IsJobWage, @IsPiecework,
			   1, @UserID, GETDATE(), @UserID, GETDATE())
	END	
FETCH NEXT FROM @Cur INTO @Row, @DivisionID, @EmpFileID, @Period, @EmployeeID, @DepartmentID, @TeamID, @TaxObjectID,
       @Orders, @SalaryCoefficient, @TimeCoefficient, @DutyCoefficient, @Salary01, @Salary02, @Salary03, 
       @BaseSalary, @InsuranceSalary, @C01, @C02, @C03, @C04, @C05, @C06, @C07, @C08, @C09, @C10, @C11, @C12, @C13, 
       @C14, @C15, @C16, @C17, @C18, @C19, @C20, @C21, @C22, @C23, @C24, @C25, @IsJobWage, @IsPiecework 
END
CLOSE @Cur	

LB_RESULT:
SELECT * FROM #Data


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

