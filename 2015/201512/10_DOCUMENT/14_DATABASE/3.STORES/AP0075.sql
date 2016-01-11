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
---- Modified on 15/12/2015 by Hoàng Vũ, Sửa Store load lên trùng dữ liệu
-- <Example>
---- AP0075 @DivisionID='SC',@UserID='ASOFTADMIN',@ModuleID='%',@ScreenType='%',@ScreenID='',@ScreenName=NULL,@Disabled=1
CREATE PROCEDURE dbo.AP0075
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@ModuleID VARCHAR(50),
	@ScreenType VARCHAR(50),
	@ScreenID NVARCHAR(500),
	@ScreenName NVARCHAR(500),
	@Disabled TINYINT
)
AS
DECLARE @sSQL NVARCHAR(MAX),
		@sWhere NVARCHAR(MAX)='',
		@CustomerIndex INT
SET @CustomerIndex = (SELECT TOP 1 CustomerName FROM CustomerIndex )

IF @ModuleID IS NOT NULL SET @sWhere=@sWhere+'AND B.ModuleID LIKE '''+@ModuleID+''' '
IF @ScreenType IS NOT NULL AND @ScreenType<>'%' SET @sWhere=@sWhere+'AND B.ScreenType = '''+@ScreenType+''' '
IF @ScreenID IS NOT NULL SET @sWhere=@sWhere+'AND B.ScreenID LIKE N''%'+@ScreenID+'%'' '
IF @ScreenName IS NOT NULL SET @sWhere=@sWhere+'AND B.ScreenName LIKE N''%'+@ScreenName+'%'' '
IF @Disabled IS NOT NULL SET @sWhere=@sWhere+'AND B.Disabled = '+STR(@Disabled)+''

SET @sSQL=N'SELECT B.*,AT1409.Description ModuleName FROM
(SELECT A.*,ISNULL(A00001.CustomName,A00001.Name) ScreenName
FROM
(SELECT A00004.ScreenID,CommandMenu,ISNULL(AT1404.Disabled,0) Disabled,
(CASE WHEN A00004.ModuleID=''ASoftT''  THEN ''AF0000'' 
WHEN A00004.ModuleID=''ASOFTCI''THEN ''CF0000'' 
WHEN A00004.ModuleID=''ASOFTCM''THEN ''CMF0000''
WHEN A00004.ModuleID=''ASoftCS''THEN ''CSF0000''
WHEN A00004.ModuleID=''ASOFTFA''THEN ''FF0000''
WHEN A00004.ModuleID=''ASOFTHRM''THEN ''HF0000''
WHEN A00004.ModuleID=''ASOFTM''THEN ''MF0000''
WHEN A00004.ModuleID=''ASOFTOP''THEN ''OF0000''
ELSE ''WF0000'' END )+''.''+A00004.CommandMenu Screeen,(CASE AT1404.ScreenType
         WHEN 1 THEN N''Báo cáo''
         WHEN 2 THEN N''Danh mục và truy vấn''
         WHEN 3 THEN N''Nghiệp vụ''
         ELSE N''Khác'' END) ScreenTypeName,AT1404.APK,AT1404.ModuleID,AT1404.ScreenType,AT1404.DivisionID
FROM A00004
INNER JOIN AT1404 ON AT1404.ScreenID = A00004.ScreenID AND AT1404.ModuleID=A00004.ModuleID AND AT1404.DivisionID=A00004.DivisionID
WHERE ISNULL(A00004.CommandMenu,'''')<>''''
AND A00004.ModuleID <>''ASoftS'')A
LEFT JOIN A00001 ON A00001.ID=A.Screeen AND A00001.LanguageID=''vi-VN''
WHERE A00001.Name IS NOT NULL

UNION ALL

SELECT A.*, A00001.Name ScreenName
FROM
(SELECT A00004.ScreenID,CommandMenu,ISNULL(AT1404.Disabled,0) Disabled,
(CASE WHEN A00004.ModuleID=''ASoftT''  THEN ''AF0000'' 
WHEN A00004.ModuleID=''ASOFTCI''THEN ''CF0000'' 
WHEN A00004.ModuleID=''ASOFTCM''THEN ''CMF0000''
WHEN A00004.ModuleID=''ASoftCS''THEN ''CSF0000''
WHEN A00004.ModuleID=''ASOFTFA''THEN ''FF0000''
WHEN A00004.ModuleID=''ASOFTHRM''THEN ''HF0000''
WHEN A00004.ModuleID=''ASOFTM''THEN ''MF0000''
WHEN A00004.ModuleID=''ASOFTOP''THEN ''OF0000''
ELSE ''WF0000'' END )+''.''+A00004.CommandMenu Screeen,(CASE AT1404.ScreenType
         WHEN 1 THEN N''Báo cáo''
         WHEN 2 THEN N''Danh mục và truy vấn''
         WHEN 3 THEN N''Nghiệp vụ''
         ELSE N''Khác'' END) ScreenTypeName,AT1404.APK,AT1404.ModuleID,AT1404.ScreenType,AT1404.DivisionID
FROM A00004_1 A00004
INNER JOIN AT1404 ON AT1404.ScreenID = A00004.ScreenID AND AT1404.ModuleID=A00004.ModuleID AND AT1404.DivisionID='''+@DivisionID+'''
WHERE ISNULL(A00004.CommandMenu,'''')<>''''
AND A00004.ModuleID <>''ASoftS'' AND A00004.CustomerIndex='+STR(@CustomerIndex)+')A
LEFT JOIN A00001 ON A00001.ID=A.Screeen AND A00001.LanguageID=''vi-VN''
WHERE A00001.Name IS NOT NULL)B
LEFT JOIN AT1409 ON AT1409.ModuleID=B.ModuleID AND AT1409.DivisionID='''+@DivisionID+'''
WHERE B.DivisionID='''+@DivisionID+'''
'+@sWhere+' 
ORDER BY B.ModuleID,B.ScreenID'

EXEC (@sSQL)
PRINT(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
