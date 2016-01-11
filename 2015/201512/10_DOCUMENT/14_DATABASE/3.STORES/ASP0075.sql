IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0075]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0075]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load dữ liệu màn hình AS0075
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 08/10/2015 by Trần Quốc Tuấn
---- Modified on 
-- <Example>
---- AP0075 @DivisonID='SC',@UserID='ASOFTADMIN',@ModuleID='ASOFTCI',@ScreenType='4',@ScreenID='CF0001',@ScreenName=NULL
CREATE PROCEDURE dbo.AP0075
(
	@DivisonID VARCHAR(50),
	@UserID VARCHAR(50),
	@ModuleID VARCHAR(50),
	@ScreenType VARCHAR(50),
	@ScreenID NVARCHAR(500),
	@ScreenName NVARCHAR(500)
)
AS
DECLARE @sSQL NVARCHAR(MAX),
		@sWhere NVARCHAR(MAX)=''

IF @ModuleID IS NOT NULL SET @sWhere=@sWhere+'AND AT1404.ModuleID = '''+@ModuleID+''' '
IF @ScreenType IS NOT NULL AND @ScreenType<>'%' SET @sWhere=@sWhere+'AND AT1404.ScreenType = '''+@ScreenType+''' '
IF @ScreenID IS NOT NULL SET @sWhere=@sWhere+'AND AT1404.ScreenID LIKE ''%'+@ScreenID+'%'' '
IF @ScreenName IS NOT NULL SET @sWhere=@sWhere+'AND AT1404.ScreenName LIKE ''%'+@ScreenName+'%'' '

SET @sSQL=N'
SELECT AT1404.APK,AT1404.ModuleID,ScreenID,ScreenName, ScreenType, [Disabled] IsUsed,AT1409.Description ModuleName,
	   (CASE ScreenType
         WHEN 1 THEN N''Báo cáo''
         WHEN 2 THEN N''Danh mục''
         WHEN 3 THEN N''Nghiệp vụ''
         ELSE N''Khác'' END) ScreenTypeName
FROM AT1404
INNER JOIN AT1409 ON AT1409.DivisionID = AT1404.DivisionID AND AT1409.ModuleID = AT1404.ModuleID
WHERE AT1404.DivisionID = '''+@DivisonID+''' '+@sWhere+' '

EXEC (@sSQL)
PRINT(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
