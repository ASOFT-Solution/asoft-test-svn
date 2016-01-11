IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8100]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8100]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Xử lý kiểm tra dữ liệu Import có hợp lệ
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 05/10/2011 by Nguyễn Bình Minh
---- Modified on 19/09/2013 by Bảo Anh: Bổ sung kiểm tra đơn vị và kỳ kế toán cho ASOFT-HRM
---- Modified on 24/11/2015 by Phương Thảo: Sửa lỗi kiểm tra bắt buộc nhập
-- <Example>
---- 
CREATE PROCEDURE [DBO].[AP8100]
(	
	@UserID AS NVARCHAR(50),
	@ImportTemplateID AS NVARCHAR(50),
	@CheckCode AS NVARCHAR(200),
	@Module AS NVARCHAR(200) = 'ASOFT-T',
	@ColID AS NVARCHAR(50),	 		
	@Param1 AS NVARCHAR(1000) = '',
	@Param2 AS NVARCHAR(1000) = '', 
	@Param3 AS NVARCHAR(1000) = '', 
	@Param4 AS NVARCHAR(1000) = '', 
	@Param5 AS NVARCHAR(1000) = '',
	@ObligeCheck AS TINYINT = 0, -- Nếu = 0, thì nếu cột đó = Null hoặc rỗng sẽ không kiểm tra
	@SQLWhere AS NVARCHAR(4000) = '', -- Điều kiện lọc trên #DATA
	@SQLFilter AS NVARCHAR(4000) = '' -- Điều kiện lọc trên dữ liệu chi tiết
) 
AS
SET NOCOUNT ON
DECLARE @ColumnName AS NVARCHAR(50)
DECLARE @sSQL AS NVARCHAR(MAX)
DECLARE @ParamList VARCHAR(8000),
		@SetParamList VARCHAR(8000),
		@ParamCondit VARCHAR(8000),
		@sSQLTemp VARCHAR(8000)

SELECT		TLD.ColID, TLD.DataCol, BTL.ColSQLDataType 
INTO		#Columns
FROM		A01066 TLD
INNER JOIN	A01065 TL
		ON	TL.ImportTemplateID = TLD.ImportTemplateID
INNER JOIN	A00065 BTL
		ON	BTL.ImportTransTypeID = TL.ImportTransTypeID AND BTL.ColID = TLD.ColID
WHERE		TL.ImportTemplateID = @ImportTemplateID
		
SELECT	TOP 1 @ColumnName = DataCol
FROM	A01066
WHERE	ImportTemplateID = @ImportTemplateID AND ColID = @ColID

--IF @CheckCode NOT IN ('')
--	RETURN
	
-------- Kiểm tra đơn vị
IF @CheckCode = 'CheckValidDivision'
BEGIN
	SET @sSQL = 
	'	UPDATE	#DATA 
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000071 {0}=''''' + @ColumnName + '''''''
		WHERE	' + @ColID + ' NOT IN (SELECT DivisionID FROM ' + CASE	WHEN @Module  = 'ASOFT-T' THEN 'AT9999' 
																			WHEN @Module  = 'ASOFT-FA' THEN 'FT9999'
																			WHEN @Module  = 'ASOFT-M' THEN 'MT9999'
																			WHEN @Module  = 'ASOFT-OP' THEN 'OT9999'
																			WHEN @Module  = 'ASOFT-WM' THEN 'WT9999'
																			WHEN @Module  = 'ASOFT-HRM' THEN 'HT9999'
																		ELSE 'AT9999' END + '
		     	                           WHERE Closing = 0 ' + CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END

-------- Kiểm tra kỳ kế toán
IF @CheckCode = 'CheckValidPeriod'
BEGIN
	SET @sSQL = 
	'	UPDATE	#DATA
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000072 {0}=''''' + @ColumnName + '''''''
		WHERE	' + @ColID + ' NOT IN (SELECT REPLACE(STR(TranMonth, 2), '' '', ''0'') + ''/'' + STR(TranYear, 4)
		     	                           FROM ' + CASE	WHEN @Module  = 'ASOFT-T' THEN 'AT9999' 
															WHEN @Module  = 'ASOFT-FA' THEN 'FT9999'
															WHEN @Module  = 'ASOFT-M' THEN 'MT9999'
															WHEN @Module  = 'ASOFT-OP' THEN 'OT9999'
															WHEN @Module  = 'ASOFT-WM' THEN 'WT9999'
															WHEN @Module  = 'ASOFT-HRM' THEN 'HT9999'
													ELSE 'AT9999' END + '
											WHERE Closing = 0 ' + CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END

-------- Kiểm tra loại phiếu
IF @CheckCode = 'CheckValidVoucherType'
BEGIN
	SET @sSQL = 
	'	UPDATE	DT
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000073 {0}=''''' + @ColumnName + '''''''
	 	FROM	#DATA DT		
	 	WHERE	NOT EXISTS (SELECT	TOP 1 1  
		     	            FROM	AT1007 V  
		     	            WHERE	V.Disabled = 0 AND V.DivisionID = DT.DivisionID AND V.VoucherTypeID = DT.' + @ColID 
		     									+ CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END

-------- Kiểm tra ngày phiếu
IF @CheckCode = 'CheckValidVoucherDate'
BEGIN
	SET @sSQL = 
	'	UPDATE	#DATA
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000074 {0}=''''' + @ColumnName + '''''''
		WHERE	RIGHT(CONVERT(VARCHAR(10),' + @ColID + ', 103), 7) <> Period
				' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END

-------- Kiểm tra nhân viên
IF @CheckCode = 'CheckValidEmployee'
BEGIN
	SET @sSQL = 
	'	UPDATE	DT
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000075 {0}=''''' + @ColumnName + '''''''
	 	FROM	#DATA DT		
		WHERE	' + CASE WHEN @ObligeCheck = 0 THEN 'ISNULL(' + @ColID + ', '''') <> '''' AND ' ELSE '' END +
				' NOT EXISTS (SELECT	TOP 1 1
				              FROM		AT1103 E 
				              WHERE		E.Disabled = 0 AND E.DivisionID = DT.DivisionID AND E.EmployeeID = DT.' + @ColID
				                   + CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END

-------- Kiểm tra đối tượng
IF @CheckCode = 'CheckValidObject'
BEGIN
	SET @sSQL = 
	'	UPDATE	DT
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000076 {0}=''''' + @ColumnName + '''''''
	 	FROM	#DATA DT 		
		WHERE	' + CASE WHEN @ObligeCheck = 0 THEN 'ISNULL(' + @ColID + ', '''') <> '''' AND ' ELSE '' END +
				'NOT EXISTS (SELECT TOP 1 1
				             FROM	AT1202 O 
				             WHERE	O.Disabled = 0 AND O.DivisionID = DT.DivisionID AND O.ObjectID = DT.' + @ColID
									+ CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END

-------- Kiểm tra loại tiền
IF @CheckCode = 'CheckValidCurrency'
BEGIN
	SET @sSQL = 
	'	UPDATE	DT
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000077 {0}=''''' + @ColumnName + '''''''
	 	FROM	#DATA DT		
		WHERE	' + CASE WHEN @ObligeCheck = 0 THEN 'ISNULL(' + @ColID + ', '''') <> '''' AND ' ELSE '' END +
				' NOT EXISTS(SELECT TOP 1 1
				             FROM	AT1004 C 
				             WHERE	C.Disabled = 0 AND C.DivisionID = DT.DivisionID AND C.CurrencyID = DT.' + @ColID
									+ CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END

-------- Kiểm tra tài khoản
IF @CheckCode = 'CheckValidAccount'
BEGIN
	SET @sSQL = 
	'	UPDATE	DT
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000078 {0}=''''' + @ColumnName + '''''''
	 	FROM	#DATA DT 		
		WHERE	' + CASE WHEN @ObligeCheck = 0 THEN 'ISNULL(' + @ColID + ', '''') <> '''' AND ' ELSE '' END +
				' NOT EXISTS (SELECT TOP 1 1 
				              FROM AT1005 A
				              WHERE A.Disabled = 0 AND A.DivisionID = DT.DivisionID AND A.AccountID = DT.' + @ColID
									+ CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END

-------- Kiểm tra loại hóa đơn
IF @CheckCode = 'CheckValidVATType'
BEGIN
	SET @sSQL = 
	'	UPDATE	DT
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000079 {0}=''''' + @ColumnName + '''''''
	 	FROM	#DATA DT		
		WHERE	' + CASE WHEN @ObligeCheck = 0 THEN 'ISNULL(' + @ColID + ', '''') <> '''' AND ' ELSE '' END +
				' NOT EXISTS (SELECT TOP 1 1
				              FROM	AT1009 V 
				              WHERE V.Disabled = 0 AND V.DivisionID = DT.DivisionID AND V.VATTypeID = DT.' + @ColID
									+ CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END

-------- Kiểm tra nhóm thuế
IF @CheckCode = 'CheckValidVATGroup'
BEGIN
	SET @sSQL = 
	'	UPDATE	DT
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000080 {0}=''''' + @ColumnName + '''''''
	 	FROM	#DATA DT		
		WHERE	' + CASE WHEN @ObligeCheck = 0 THEN 'ISNULL(' + @ColID + ', '''') <> '''' AND ' ELSE '' END +
				' NOT EXISTS(SELECT TOP 1 1
				             FROM AT1010 V 
				             WHERE V.Disabled = 0 AND V.DivisionID = DT.DivisionID AND V.VatGroupID = DT.' + @ColID
									+ CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END				                   
END

-------- Kiểm tra khoản mục
IF @CheckCode LIKE 'CheckValidAna0[1-9]'
BEGIN
	SET @sSQL = 
	'	UPDATE	DT
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000081 {0}=''''' + @ColumnName + '''''''
	 	FROM	#DATA DT	
		WHERE	' + CASE WHEN @ObligeCheck = 0 THEN 'ISNULL(' + @ColID + ', '''') <> '''' AND ' ELSE '' END +
				'NOT EXISTS (SELECT	TOP 1 1 
				         FROM	AT1011 A
				         WHERE	A.Disabled = 0 AND A.DivisionID = DT.DivisionID AND A.AnaTypeID = ''A' + RIGHT(@CheckCode, 2) + ''' AND A.AnaID = DT.' + @ColID
									+ CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END				                   
END

-------- Kiểm tra dữ liệu này bắt buộc nhập
IF @CheckCode LIKE 'CheckObligatoryInput'
BEGIN
	SET @sSQL = 
	'	UPDATE	#DATA
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000082 {0}=''''' + @ColumnName + '''''''
		WHERE	(' + @ColID + ' IS NULL OR ' + @ColID +' = '''')
				' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
print @sSQL
END

-------- Kiểm tra dữ liệu không đồng nhất 
---- VD: Cần kiểm tra phần import master, các phần này phân biệt qua cột VoucherNo, nếu VoucherNo giống nhau thì tất cả các phần VoucherNo, VoucherTypeID, VoucherDate, VDescription cần phải giống nhau
--- EXEC AP8100 @UserID = 'ASOFTADMIN', @ImportTemplateID = '?', @CheckCode = 'CheckIdenticalValues', @ColID = 'VoucherNo', @Param1 = 'VoucherNo, VoucherTypeID, VoucherDate, VDescription', @Param5 = 'ASML000083'
IF @CheckCode = 'CheckIdenticalValues'
BEGIN		
	SET @sSQL = 
	'	
	SET ANSI_NULLS OFF
	DECLARE @cList CURSOR
	DECLARE @Row INT
	DECLARE @bIsFirst TINYINT
	DECLARE @ColumnName VARCHAR(8000)
	'
	SELECT @ParamList = '', @SetParamList = '', @ParamCondit = ''
	SELECT	@ParamCondit = @ParamCondit + CASE WHEN @ParamCondit = '' THEN '' ELSE ' AND ' END + '@' + ColID + ' = @OLD__' + ColID
	FROM	#Columns
	WHERE	CHARINDEX(',' + ColID + ',', REPLACE(',' + @ColID + ',', ' ', '')) > 0
	SET @ParamCondit = 'IF (' + @ParamCondit + ') AND @bIsFirst = 0
			BEGIN
		'
	SELECT	@sSQL = @sSQL + '
	DECLARE @' + ColID + ' ' + ColSQLDataType + '
	DECLARE @OLD__' + ColID + ' ' + ColSQLDataType,
			@ParamList = @ParamList + CASE WHEN @ParamList = '' THEN '' ELSE ',' END + '@' + ColID,
			@SetParamList = @SetParamList + CASE WHEN @SetParamList = '' THEN '' ELSE ',' END + '@OLD__' + ColID + ' = @' + ColID,
			@ParamCondit = @ParamCondit + 
				CASE WHEN CHARINDEX(',' + ColID + ',', REPLACE(',' + @ColID + ',', ' ', '')) > 0 THEN '' ELSE '
				IF @OLD__' + ColID + ' <> @' + ColID + '
					SET @ColumnName = @ColumnName + CASE WHEN @ColumnName = '''' THEN '''' ELSE '', '' END + ''' + DataCol + ''''
				END					
	FROM	#Columns
	WHERE	CHARINDEX(',' + ColID + ',', REPLACE(',' + @ColID + ',', ' ', '') + REPLACE(',' + @Param1 + ',', ' ', '')) > 0
	
	SET @ParamCondit = @ParamCondit + '
				IF @ColumnName <> ''''
					UPDATE	#DATA 
					SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000083 {0}='''''' + @ColumnName + ''''''''
					WHERE	(Row = @Row)' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END + '
			END'
	
	SET @sSQL = @sSQL + '
	SET @bIsFirst = 1
	SET @cList = CURSOR FAST_FORWARD READ_ONLY FOR
		SELECT		Row, ' + REPLACE(@ParamList, '@', '') + '
		FROM		#DATA
		' + CASE WHEN @SQLWhere <> '' THEN ' WHERE ' + @SQLWhere ELSE '' END + '
		ORDER BY	Row
	OPEN @cList
	FETCH NEXT FROM @cList INTO @Row, ' + @ParamList + '
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @ColumnName = ''''
		' + @ParamCondit + '
		ELSE
			SELECT ' + @SetParamList + '
		SET @bIsFirst = 0
			
		FETCH NEXT FROM @cList INTO @Row, ' + @ParamList + '
	END
	'
print @sSQL
END

-- Kiểm tra trùng phiếu
---- VD: Cần kiểm tra phần VoucherNo, khóa liên quan đến VoucherNo là VoucherID
--- EXEC AP8100 @UserID = 'ASOFTADMIN', @ImportTemplateID = '?', @CheckCode = 'CheckDuplicateVoucherNo', @ColID = 'VoucherNo', @Param1 = 'VoucherID'
IF @CheckCode = 'CheckDuplicateVoucherNo'
BEGIN
	SET @sSQL = '
	SELECT		MIN(Row) AS Row, ' + @ColID + CASE WHEN @Param1 <> '' THEN ',' + @Param1 ELSE '' END + '
	INTO		#AP8100
	FROM		#DATA
	GROUP BY	' + @ColID + CASE WHEN @Param1 <> '' THEN ',' + @Param1 ELSE '' END 
	
	IF @Param1 <> ''
		SET @sSQL = @sSQL + '
	UPDATE		DT 
	SET			ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000084 {0}=''''' + @ColumnName + '''''''
	FROM		#DATA DT
	INNER JOIN	#AP8100 VN
			ON	VN.' + @ColID + ' = DT.' + @ColID + ' AND VN.' + @Param1 + ' <> DT.' + @Param1 + ' AND VN.Row > DT.Row'
	+ CASE WHEN @SQLWhere <> '' THEN ' WHERE ' + @SQLWhere ELSE '' END
	
	SET @sSQL = @sSQL + '
	UPDATE		DT  
	SET			ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000085 {0}=''''' + @ColumnName + '''''''
	FROM		#DATA DT
	WHERE		EXISTS(SELECT TOP 1 1 FROM AT9000 AT WHERE AT.DivisionID = DT.DivisionID AND AT.VoucherNo = DT.' + @ColID + CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')' 
	+ CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
		
END

-------- Kiểm tra tài khoản ngân hàng
IF @CheckCode = 'CheckValidBankAccount'
BEGIN
	SET @sSQL = 
	'	UPDATE	DT
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000086 {0}=''''' + @ColumnName + '''''''
	 	FROM	#DATA DT		
	 	WHERE	' + CASE WHEN @ObligeCheck = 0 THEN 'ISNULL(' + @ColID + ', '''') <> '''' AND ' ELSE '' END +
	 			'NOT EXISTS (SELECT	TOP 1 1  
		     	            FROM	AT1016 B 
		     	            WHERE	B.Disabled = 0 AND B.DivisionID = DT.DivisionID AND B.BankAccountID = DT.' + @ColID 
		     									+ CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END

-- Kiểm tra trùng mã tài sản
---- VD: Cần kiểm tra phần AssetID
--- EXEC AP8100 @UserID = 'ASOFTADMIN', @ImportTemplateID = '?', @CheckCode = 'CheckDuplicateAsset', @ColID = 'AssetID', @Param1 = 'AssetID'
IF @CheckCode = 'CheckDuplicateAsset'
BEGIN
	SET @sSQL = '
	SELECT		MIN(Row) AS Row, ' + @ColID + '
	INTO		#AP8100
	FROM		#DATA
	GROUP BY	' + @ColID + '

	UPDATE		DT 
	SET			ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000087 {0}=''''' + @ColumnName + '''''''
	FROM		#DATA DT
	INNER JOIN	#AP8100 VN
			ON	VN.' + @ColID + ' = DT.' + @ColID + ' AND VN.Row > DT.Row'
	+ CASE WHEN @SQLWhere <> '' THEN ' WHERE ' + @SQLWhere ELSE '' END
	
	SET @sSQL = @sSQL + '
	UPDATE		DT  
	SET			ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000088 {0}=''''' + @ColumnName + '''''''
	FROM		#DATA DT
	WHERE		EXISTS(SELECT TOP 1 1 FROM AT1503 F WHERE F.DivisionID = DT.DivisionID AND F.AssetID = DT.' + @ColID + CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')' 
	+ CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END		
END

-- Kiểm tra dữ liệu có trong danh sách
---- VD: Cần kiểm tra trạng thái và giá trị trong 0, 1, 2, 3
--- EXEC AP8100 @UserID = 'ASOFTADMIN', @ImportTemplateID = '?', @CheckCode = 'CheckValueInList', @ColID = 'Status', @Param1 = '0, 1, 2, 3'
IF @CheckCode = 'CheckValueInList'
BEGIN
	SET @sSQL = '
	UPDATE		DT  
	SET			ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000089 {0}=''''' + @ColumnName + '''''''
	FROM		#DATA DT
	WHERE		' + CASE WHEN @ObligeCheck = 0 THEN 'ISNULL(' + @ColID + ', '''') <> '''' AND ' ELSE '' END +
	 			'NOT DT.' + @ColID + ' IN (' + @Param1 + ')'
	+ CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END 

-- Kiểm tra dữ liệu có trong bảng danh mục, danh sách này lấy dữ liệu từ 1 bảng
---- VD: Cần kiểm tra dữ liệu trong danh sách lý do hình thành tài sản
--- EXEC AP8100 @UserID = 'ASOFTADMIN', @ImportTemplateID = '?', @CheckCode = 'CheckValueInTableList', @ColID = 'CauseID', @Param1 = 'AT6000', @Param2 = 'Code'
IF @CheckCode = 'CheckValueInTableList'
BEGIN		
	SET @sSQL = '
	UPDATE		DT 
	SET			ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000090 {0}=''''' + @ColumnName + '''''''
	FROM		#DATA DT
	WHERE		' + CASE WHEN @ObligeCheck = 0 THEN 'ISNULL(' + @ColID + ', '''') <> '''' AND ' ELSE '' END +
				'NOT EXISTS(SELECT TOP 1 1 FROM ' + @Param1 + ' TL WHERE ' + CASE WHEN ISNULL(COL_LENGTH(@Param1, 'DivisionID'), 0) > 0 THEN ' TL.DivisionID = DT.DivisionID AND ' ELSE '' END + 'TL.' + @Param2 + ' = DT.' + @ColID + CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')' 
	+ CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END 

-------- Kiểm tra đối tượng
IF @CheckCode = 'CheckValidDepartment'
BEGIN
	SET @sSQL = 
	'	UPDATE	DT
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000091 {0}=''''' + @ColumnName + '''''''
	 	FROM	#DATA DT 		
		WHERE	' + CASE WHEN @ObligeCheck = 0 THEN 'ISNULL(' + @ColID + ', '''') <> '''' AND ' ELSE '' END +
				'NOT EXISTS (SELECT TOP 1 1
				             FROM	AT1102 D 
				             WHERE	D.Disabled = 0 AND D.DivisionID = DT.DivisionID AND D.DepartmentID = DT.' + @ColID
									+ CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END

-------- Kiểm tra tháng năm hợp lệ
IF @CheckCode = 'CheckValidMonthYear'
BEGIN
	SET @sSQL = 
	'	UPDATE	#DATA
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000092 {0}=''''' + @ColumnName + '''''''
		WHERE	' + CASE WHEN @ObligeCheck = 0 THEN 'ISNULL(' + @ColID + ', '''') <> '''' AND ' ELSE '' END +
	 			'(' + @ColID + ' NOT LIKE ''[0-1][0-9]/[2-9][0-9][0-9][0-9]'' OR ' + @ColID + ' LIKE ''00%'')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END

-- Kiểm tra trùng mã phân bổ
---- VD: Cần kiểm tra phần JobID
--- EXEC AP8100 @UserID = 'ASOFTADMIN', @ImportTemplateID = '?', @CheckCode = 'CheckDuplicateJob', @ColID = 'JobID', @Param1 = 'JobID'
IF @CheckCode = 'CheckDuplicateJob'
BEGIN
	SET @sSQL = '
	SELECT		MIN(Row) AS Row, ' + @ColID + '
	INTO		#AP8100
	FROM		#DATA
	GROUP BY	' + @ColID + '

	UPDATE		DT 
	SET			ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000087 {0}=''''' + @ColumnName + '''''''
	FROM		#DATA DT
	INNER JOIN	#AP8100 VN
			ON	VN.' + @ColID + ' = DT.' + @ColID + ' AND VN.Row > DT.Row'
	+ CASE WHEN @SQLWhere <> '' THEN ' WHERE ' + @SQLWhere ELSE '' END
	
	SET @sSQL = @sSQL + '
	UPDATE		DT  
	SET			ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000088 {0}=''''' + @ColumnName + '''''''
	FROM		#DATA DT
	WHERE		EXISTS(SELECT TOP 1 1 FROM AT1703 J WHERE J.DivisionID = DT.DivisionID AND J.JobID = DT.' + @ColID + CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')' 
	+ CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
		
END

-------- Kiểm tra kho
IF @CheckCode = 'CheckValidWareHouse'
BEGIN
	SET @sSQL = 
	'	UPDATE	DT
		SET		ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000094 {0}=''''' + @ColumnName + '''''''
	 	FROM	#DATA DT		
	 	WHERE	' + CASE WHEN @ObligeCheck = 0 THEN 'ISNULL(' + @ColID + ', '''') <> '''' AND ' ELSE '' END +
	 			'NOT EXISTS (SELECT	TOP 1 1
		     				FROM	AT1303 W 
		     	            WHERE	W.Disabled = 0 AND W.DivisionID = DT.DivisionID AND W.WareHouseID = DT.' + @ColID 
		     									+ CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')
		     	' + CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END
END


-- Kiểm tra trùng phiếu khác với bảng AT9000
---- VD: Cần kiểm tra phần VoucherNo của phiếu kiểm kê, khóa liên quan đến VoucherNo là VoucherID, bảng là AT2036 khóa bảng là VoucherNo
--- EXEC AP8100 @UserID = 'ASOFTADMIN', @ImportTemplateID = '?', @CheckCode = 'CheckDuplicateVoucherNo', @ColID = 'VoucherNo', @Param1 = 'VoucherID', @Param2 = 'AT2036', @Param3 = 'VoucherNo'
IF @CheckCode = 'CheckDuplicateOtherVoucherNo'
BEGIN
	SET @sSQL = '
	SELECT		MIN(Row) AS Row, ' + @ColID + CASE WHEN @Param1 <> '' THEN ',' + @Param1 ELSE '' END + '
	INTO		#AP8100
	FROM		#DATA
	GROUP BY	' + @ColID + CASE WHEN @Param1 <> '' THEN ',' + @Param1 ELSE '' END 
	
	IF @Param1 <> ''
		SET @sSQL = @sSQL + '
	UPDATE		DT 
	SET			ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000084 {0}=''''' + @ColumnName + '''''''
	FROM		#DATA DT
	INNER JOIN	#AP8100 VN
			ON	VN.' + @ColID + ' = DT.' + @ColID + ' AND VN.' + @Param1 + ' <> DT.' + @Param1 + ' AND VN.Row > DT.Row'
	+ CASE WHEN @SQLWhere <> '' THEN ' WHERE ' + @SQLWhere ELSE '' END
	
	SET @sSQL = @sSQL + '
	UPDATE		DT  
	SET			ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '''' THEN ''\n'' ELSE '''' END + ''ASML000085 {0}=''''' + @ColumnName + '''''''
	FROM		#DATA DT
	WHERE		EXISTS(SELECT TOP 1 1 FROM ' + @Param2 + ' AT WHERE AT.DivisionID = DT.DivisionID AND AT.' + @Param3 + ' = DT.' + @ColID + CASE WHEN @SQLFilter <> '' THEN ' AND ' + @SQLFilter ELSE '' END + ')' 
	+ CASE WHEN @SQLWhere <> '' THEN ' AND (' + @SQLWhere + ')' ELSE '' END		
END

-- Kiểm tra trùng giá trị trong dữ liệu
-- Nếu không có khóa để phân biệt thì khóa sẽ là ColID
---- VD: Cần kiểm tra phần InventoryID của phiếu kiểm kê, khóa để kiểm tra trùng là VoucherNo
--- EXEC AP8100 @UserID = 'ASOFTADMIN', @ImportTemplateID = '?', @CheckCode = 'CheckDuplicateVoucherNo', @ColID = 'InventoryID', @Param1 = 'VoucherNo'
IF @CheckCode = 'CheckDuplicateValue'
BEGIN
	SET @sSQL = '
	SELECT		MIN(Row) AS Row, ' + @ColID + CASE WHEN @Param1 <> '' THEN ',' + @Param1 ELSE '' END + '
	INTO		#AP8100
	FROM		#DATA
	GROUP BY	' + @ColID + CASE WHEN @Param1 <> '' THEN ',' + @Param1 ELSE '' END 
	+ CASE WHEN @SQLWhere <> '' THEN ' WHERE ' + @SQLWhere ELSE '' END
END
PRINT @sSQL
EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

