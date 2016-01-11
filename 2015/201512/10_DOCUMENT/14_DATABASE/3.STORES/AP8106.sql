IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8106]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8106]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Xử lý các check code mặc định trong định nghĩa nhập dữ liệu từ Excel: trường hợp nhiều SType
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 16/07/2015 by Lê Thị Hạnh
-- <Example>
---- 
CREATE PROCEDURE [DBO].[AP8106]
( 
	@ImportTemplateID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@SType INT
) 
AS 

DECLARE @CheckValue AS NVARCHAR(4000)
DECLARE @CheckCode  AS VARCHAR(50),
		@ParamList AS VARCHAR(250),
		@ColID AS VARCHAR(50)		

DECLARE @sSQL AS NVARCHAR(4000)
DECLARE @BeginParamPos AS INT
DECLARE @EndParamPos AS INT
DECLARE @BeginCheckCodePos AS INT
DECLARE @EndCheckCodePos AS INT

DECLARE @cCheckCode AS CURSOR

SET @cCheckCode = CURSOR STATIC FOR
	SELECT		LTRIM(RTRIM(BTL.CheckExpression)) + ';', TLD.ColID 
	FROM		A01066 TLD
	INNER JOIN	A01065 TL
			ON	TL.ImportTemplateID = TLD.ImportTemplateID
	INNER JOIN	A00065 BTL
			ON	BTL.ImportTransTypeID = TL.ImportTransTypeID AND BTL.ColID = TLD.ColID AND BTL.OrderNum = TLD.OrderNum
	WHERE		TL.ImportTemplateID = @ImportTemplateID
	AND ISNULL(BTL.SType,0) IN (0, ISNULL(@SType,0)) -- Add SType Condition
	ORDER BY	TLD.OrderNum
	
OPEN @cCheckCode
FETCH NEXT FROM @cCheckCode	INTO @CheckValue, @ColID
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @BeginCheckCodePos = 1
	WHILE @BeginCheckCodePos > 0 AND LEN(@CheckValue) > 10
	BEGIN
		SET @BeginCheckCodePos = PATINDEX('{Check%}%', @CheckValue)	
		SET @EndCheckCodePos = CHARINDEX(';', @CheckValue)
		SET @BeginParamPos = CHARINDEX('}', @CheckValue, @BeginCheckCodePos)
		SET @CheckCode = SUBSTRING(@CheckValue, @BeginCheckCodePos + 1, @BeginParamPos - @BeginCheckCodePos - 1)
		SET @ParamList = RTRIM(LTRIM(SUBSTRING(@CheckValue, @BeginParamPos + 1, @EndCheckCodePos - @BeginParamPos - 1)))
		SET @sSQL = 'EXEC AP8101 @UserID = ''' + @UserID + ''', @ImportTemplateID = ''' + @ImportTemplateID + ''', @CheckCode = ''' +  @CheckCode + ''', @ColID = ''' + @ColID + '''' + CASE WHEN @ParamList <> '' THEN ', ' + @ParamList ELSE '' END + ', @SType = '+LTRIM(@SType)+' '
		PRINT @sSQL
		EXEC (@sSQL)
		SET @CheckValue = RIGHT(@CheckValue, LEN(@CheckValue) - @EndCheckCodePos)
	END
	FETCH NEXT FROM @cCheckCode	INTO @CheckValue, @ColID
END	
CLOSE @cCheckCode


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

