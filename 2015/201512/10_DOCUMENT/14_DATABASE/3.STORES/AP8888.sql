IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8888]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP8888]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
---- Add mới mẫu báo cáo chuẩn ASOFT -T,OP,HRM,FA,WM,M
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 11/06/2015 by Lê Thị Hạnh
---- Modified on ... by ...
-- <Example>
---- EXEC AP8888 
CREATE PROCEDURE AP8888
( 		
    @GroupID NVARCHAR(50), -- Nhóm của báo cáo
    @ModuleID NVARCHAR(50),
    @ReportID NVARCHAR(50),
    @ReportName NVARCHAR(250),
    @ReportNameE NVARCHAR(250),
    @ReportTitle NVARCHAR(250),
    @ReportTitleE NVARCHAR(250),
    @Description NVARCHAR(250),
    @DescriptionE NVARCHAR(250),
    @Type TINYINT, -- loại của báo cáo
    @SQLstring NVARCHAR(4000),
    @Orderby NVARCHAR(200),
    @TEST BIT, --0: trạng thái thêm mới, 1: sửa
    @TableID NVARCHAR(50) -- Bảng cập nhật DL: AT8888, HT8888, MT8888, HT8888,...
)
AS
DECLARE @TableIDSTD NVARCHAR(50), --- Tên bảng chuẩn
		@sSQL NVARCHAR(MAX) = ''
IF ISNULL(@TableID,'') <> '' 
BEGIN
	SET @TableIDSTD = @TableID + 'STD'
SET @sSQL = N'
IF('+LTRIM(ISNULL(@TEST,0))+' = 1)
BEGIN
DELETE '+@TableIDSTD+' WHERE ReportID = N'''+@ReportID+'''
DELETE '+@TableID+' WHERE ReportID = N'''+@ReportID+'''
END
-- Thêm thông tin báo cáo (STD)
IF NOT EXISTS (SELECT TOP 1 1 FROM '+@TableIDSTD+' WHERE ReportID = '''+@ReportID+''')
INSERT '+@TableIDSTD+' (ReportID, ReportName, ReportNameE, Title, TitleE, Description, DescriptionE, GroupID, Type, Disabled, SQLstring, Orderby) 
VALUES (N'''+@ReportID+''', N'''+@ReportName+''', N'''+@ReportNameE+''', N'''+@ReportTitle+''', N'''+@ReportTitleE+''', 
	    N'''+@Description+''', N'''+@DescriptionE+''', N'''+@GroupID+''', '+LTRIM(@Type)+', 0, N'''+@SQLstring+''', N'''+@Orderby+''')
-- Thêm thông tin báo cáo
INSERT INTO '+@TableID+'(APK, DivisionID, ReportID, ReportName, ReportNameE, Title, TitleE, Description, DescriptionE, GroupID, Type, Disabled, SQLstring, Orderby)
SELECT NEWID(), A00.DefDivisionID, STD.ReportID, STD.ReportName, STD.ReportNameE, STD.Title, STD.TitleE, STD.Description, STD.DescriptionE, STD.GroupID, STD.Type, STD.Disabled, STD.SQLstring, STD.Orderby
FROM '+@TableIDSTD+' STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.ReportID = N'''+@ReportID+'''
    AND NOT EXISTS(SELECT TOP 1 1 FROM '+@TableID+' WHERE DivisionID = A00.DefDivisionID AND ReportID = N'''+@ReportID+''')
IF('+LTRIM(ISNULL(@TEST,0))+' = 1)
BEGIN
SELECT * FROM '+@TableIDSTD+' WHERE ReportID = N'''+@ReportID+'''
SELECT * FROM '+@TableID+' WHERE ReportID = N'''+@ReportID+'''
END '
END
EXEC (@sSQL)
--PRINT (@sSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
