IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0067]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0067]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load dữ liệu màn hình nhập dữ liệu từ Excel AS0067
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 28/09/2011 by 
---- Modified on 15/07/2015 by Lê Thị Hạnh: Bổ sung biến SType cho Import hồ sơ nhân viên
-- <Example>
---- 
CREATE PROCEDURE [DBO].[AP0067]
(
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@TranMonth AS TINYINT,
	@TranYear AS INT,
	@ImportTemplateID AS NVARCHAR(50),
	@ActionMode AS TINYINT, -- 0: Load cấu trúc dữ liệu lên lưới, 1: Load tên bảng và tên cột, 2: Thực hiện lưu dữ liệu từ XML
	@XML AS XML,
	@SType INT--SType tuỳ thuộc vào dữ liệu Master
) 
AS 
SET NOCOUNT ON
DECLARE @sSQL AS NVARCHAR(4000)
DECLARE @cCURSOR AS CURSOR
DECLARE @ColID AS NVARCHAR(50), 
		@ColSQLDataType AS NVARCHAR(50)

IF @ActionMode = 0
BEGIN	
	CREATE TABLE #Data
	(
		Row INT
	)
	SET @cCURSOR = CURSOR STATIC FOR
		SELECT		TLD.ColID,
					BTL.ColSQLDataType
		FROM		A01065 TL
		INNER JOIN	A01066 TLD
				ON	TL.ImportTemplateID = TLD.ImportTemplateID
		INNER JOIN	A00065 BTL
				ON	BTL.ImportTransTypeID = TL.ImportTransTypeID AND BTL.ColID = TLD.ColID AND BTL.OrderNum = TLD.OrderNum
				AND ISNULL(BTL.SType,0) IN (0, ISNULL(@SType,0)) -- Add SType Condition
		WHERE		TL.ImportTemplateID = @ImportTemplateID
		ORDER BY TLD.OrderNum		
		
	OPEN @cCURSOR
	FETCH NEXT FROM @cCURSOR INTO @ColID, @ColSQLDataType	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @sSQL
		SET @sSQL = 'ALTER TABLE #Data ADD ' + @ColID + ' ' + @ColSQLDataType + ' NULL'
		EXEC (@sSQL)
		FETCH NEXT FROM @cCURSOR INTO @ColID, @ColSQLDataType
	END
	
	ALTER TABLE #Data ADD ImportMessage NVARCHAR(500) NULL
	
	SELECT * FROM #Data
	CLOSE @cCURSOR
END

IF @ActionMode = 1
BEGIN
	SELECT		TLD.ColID,		TLD.ColName, 
				TLD.ColWidth,	TLD.Editable,	
				BTL.InputMask,	BTL.ColLength,
				TLD.DataCol,
				TLD.IsObligated,
				TLD.[Disabled]
	FROM		A01065 TL
	INNER JOIN	A01066 TLD
			ON	TL.ImportTemplateID = TLD.ImportTemplateID
	INNER JOIN	A00065 BTL
			ON	BTL.ImportTransTypeID = TL.ImportTransTypeID AND BTL.ColID = TLD.ColID AND BTL.OrderNum = TLD.OrderNum
	WHERE		TL.ImportTemplateID = @ImportTemplateID
				AND ISNULL(BTL.SType,0) IN (0, ISNULL(@SType,0)) -- Add SType Condition
	ORDER BY	TLD.OrderNum
END

IF @ActionMode = 2
BEGIN
	DECLARE @sParamDef NVARCHAR(MAX)
	DECLARE @ImportTransTypeID NVARCHAR(50)
	SELECT		TOP 1
				@sSQL = BTL.ExecSQL
	FROM		A00065 BTL
	INNER JOIN	A01065 TL
			ON	TL.ImportTransTypeID = BTL.ImportTransTypeID	
	WHERE	ImportTemplateID = @ImportTemplateID
	
	SET @sParamDef = N'@DivisionID NVARCHAR(50), @UserID NVARCHAR(50), @TranMonth TINYINT, @TranYear INT, @ImportTransTypeID NVARCHAR(50), @ImportTemplateID NVARCHAR(50), @XML XML'
	PRINT @sParamDef 
	PRINT @sSQL
	IF @ImportTemplateID = 'EmployeeFileID'
	BEGIN
		SET @sParamDef = @sParamDef + ', @SType TINYINT'
		EXECUTE sp_executesql	@sSQL, 
							@sParamDef, 
							@DivisionID = @DivisionID, 
							@UserID = @UserID,
							@TranMonth = @TranMonth, 
							@TranYear = @TranYear,
							@ImportTemplateID = @ImportTemplateID,
							@ImportTransTypeID = @ImportTransTypeID,
							@XML = @XML,
							@SType = @SType
	END
	ELSE 
	BEGIN
	EXECUTE sp_executesql	@sSQL, 
							@sParamDef, 
							@DivisionID = @DivisionID, 
							@UserID = @UserID,
							@TranMonth = @TranMonth, 
							@TranYear = @TranYear,
							@ImportTemplateID = @ImportTemplateID,
							@ImportTransTypeID = @ImportTransTypeID,
							@XML = @XML
			
	END
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

