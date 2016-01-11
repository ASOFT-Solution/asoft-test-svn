IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0129]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0129]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Grid Form CF0129: Danh mục email Template
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Nguyễn Thanh Sơn, Date: 03/09/2014
-- <Example>
---- 
/*
   AP0129 'XR','',1,25,1,NULL, NULL, NULL, '%'
*/

CREATE PROCEDURE AP0129
( 
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@PageNumber INT,
	@PageSize INT,
	@IsSearch BIT,
	@TemplateID VARCHAR(50),
	@TemplateName NVARCHAR(250),
	@EmailTitle NVARCHAR(250),
	@EmailGroupID VARCHAR(50)	
)
AS 
DECLARE @sSQL NVARCHAR (MAX),
        @sWhere NVARCHAR(MAX),
        @OrderBy NVARCHAR(500),
        @TotalRow NVARCHAR(50)
                
SET @sWhere = ''
SET @TotalRow = ''
SET @OrderBy = 'A29.TemplateID ASC'
IF @PageNumber = 1 SET @TotalRow = 'COUNT(*) OVER ()' ELSE SET @TotalRow = 'NULL'
IF @IsSearch = 1
BEGIN	
	IF @TemplateID IS NOT NULL SET @sWhere = @sWhere + '	
	AND A29.TemplateID LIKE N''%'+@TemplateID+'%'' '
	IF @TemplateName IS NOT NULL SET @sWhere = @sWhere + '	
	AND A29.TemplateName LIKE N''%'+@TemplateName+'%'' '
	IF @EmailTitle IS NOT NULL SET @sWhere = @sWhere + '	
	AND A29.EmailTitle LIKE N''%'+@EmailTitle+'%'' '
	IF @EmailGroupID IS NOT NULL SET @sWhere = @sWhere + '	
	AND A29.EmailGroupID LIKE N'''+@EmailGroupID+''' '
END

SET @sSQL = '
SELECT ROW_NUMBER() OVER (ORDER BY '+@OrderBy+') AS RowNum, '+@TotalRow+' AS TotalRow,
	A29.TemplateID, A29.TemplateName, A29.EmailTitle, A29.EmailGroupID, A29.IsCommon, A29.[Disabled],
	D99.[Description] EmailGroupName
FROM AT0129 A29
LEFT JOIN DRT0099 D99 ON D99.ID = A29.EmailGroupID
WHERE (A29.DivisionID = '''+@DivisionID+''' OR IsCommon = 1) '+@sWhere+'
ORDER BY '+@OrderBy+'
OFFSET '+STR((@PageNumber-1) * @PageSize)+' ROWS
FETCH NEXT '+STR(@PageSize)+' ROWS ONLY'

EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
