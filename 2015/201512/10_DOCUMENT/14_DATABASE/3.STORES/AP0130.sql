IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0130]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0130]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiểm tra Sửa/Xóa Danh mục Email template
---- Xóa danh mục Nhân viên
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Nguyễn Thanh Sơn, Date: 07/10/2014
-- <Example>
---- 
/*
	EXEC AP0130 @DivisionID = 'EIS', @UserID = '', @TemplateIDList = 'HK1_2014'',''HK2_2014' , @Mode = 1
	EXEC AP0130 @DivisionID = 'EIS', @UserID = '', @TemplateID = 'HK1_2014', @Mode = 0
*/

CREATE PROCEDURE AP0130
( 
  @DivisionID VARCHAR(50),
  @UserID VARCHAR(50),
  @TemplateID VARCHAR(50) = NULL,
  @TemplateIDList NVARCHAR(MAX) = NULL,
  @Mode TINYINT --0: Edit, 1: Delete
) 
AS 
DECLARE @sSQL NVARCHAR(MAX),
		@sSQL1 NVARCHAR(MAX)

IF @Mode = 1 SET @sSQL = '
DECLARE @Cur CURSOR,
		@Params1 NVARCHAR(MAX),
		@Params2 NVARCHAR(MAX),
		@DelTemplateID VARCHAR(50)
SET @Params1 = ''''
SET @Params2 = ''''
SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT TemplateID FROM AT0129 WHERE TemplateID IN ('''+@TemplateIDList+''')
OPEN @Cur
FETCH NEXT FROM @Cur INTO @DelTemplateID
WHILE @@FETCH_STATUS = 0
BEGIN
	IF ('''+@DivisionID+''' <> (SELECT DivisionID FROM AT0129 WHERE TemplateID = @DelTemplateID))   --kiểm tra khác DivisionID
		SET @Params1 = @Params1 + @DelTemplateID + '', ''
	ELSE
		BEGIN		
			--IF EXISTS (SELECT TOP 1 1 FROM MTT1040 WHERE TemplateID = @DelTemplateID)	-- kiểm tra đã được sử dụng	
			--	SET @Params2 = @Params2 + @DelTemplateID + '', ''			
			--ELSE 
				DELETE FROM AT0129 WHERE TemplateID = @DelTemplateID	
		END	
	FETCH NEXT FROM @Cur INTO @DelTemplateID
END 
IF @Params1 <> '''' SET @Params1 = LEFT(@Params1, LEN(@Params1)- 1)
IF @Params2 <> '''' SET @Params2 = LEFT(@Params2, LEN(@Params2)- 1)

SELECT * FROM
(
SELECT 2 AS Status,''00ML000050'' AS MessageID, @Params1 AS Params             
UNION ALL 
SELECT 2 AS Status,''00ML000052'' AS MessageID, @Params2 AS Params
)A WHERE A.Params <> '''' '

IF @Mode = 0 SET @sSQL = '
DECLARE @Params NVARCHAR(MAX),
		@MessageID VARCHAR(50)
SET @Params = ''''

IF ('''+@DivisionID+''' <> (SELECT TOP 1 DivisionID FROM AT0129 WHERE TemplateID = '''+@TemplateID+''')) -- kiểm tra khác Division
	BEGIN
		SET @Params = '''+@TemplateID+'''
		SET @MessageID = ''00ML000050''
	END
IF @Params <> '''' SET @Params = LEFT(@Params, LEN(@Params)- 1)
SELECT 2 AS Status, @MessageID AS MessageID, @Params AS Params
WHERE @Params <> ''''   '

EXEC (@sSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
