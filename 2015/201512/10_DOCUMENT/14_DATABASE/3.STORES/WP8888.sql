IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP8888]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP8888]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Lưu báo cáo vào bảng STD và bảng WT8888
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by:
-- <Example>
/*
    EXEC WP8888
*/

 CREATE PROCEDURE WP8888
(
    @GroupID NVARCHAR(50),
	@ModuleID NVARCHAR(50),
	@ReportID NVARCHAR(50),
	@ReportName NVARCHAR(250),
	@ReportNameE NVARCHAR(250),
	@ReportTitle NVARCHAR(250),
	@ReportTitleE NVARCHAR(250),
	@Description NVARCHAR(250),
	@DescriptionE NVARCHAR(250),
	@Type TINYINT,
	@Disabled TINYINT,
	@SQLstring NVARCHAR(4000),
	@Orderby NVARCHAR(200)
)
AS

IF EXISTS (SELECT TOP 1 1 FROM WT8888STD WHERE ReportID = @ReportID) DELETE WT8888STD WHERE ReportID = @ReportID
INSERT WT8888STD(ReportID, ReportName, ReportNameE, Title, TitleE, [Description], DescriptionE, GroupID, [Type], [Disabled], SQLstring, Orderby) 
VALUES (@ReportID, @ReportName, @ReportNameE, @ReportTitle, @ReportTitleE, @Description, @DescriptionE, @GroupID, @Type, @Disabled, @SQLstring, @Orderby)

INSERT INTO WT8888(APK, DivisionID, ReportID, ReportName, ReportNameE, Title, TitleE, Description, DescriptionE, GroupID, Type, Disabled, SQLstring, Orderby)
SELECT NEWID(), A00.DefDivisionID, STD.ReportID, STD.ReportName, STD.ReportNameE, STD.Title, STD.TitleE, STD.Description, STD.DescriptionE, STD.GroupID, STD.Type, STD.Disabled, STD.SQLstring, STD.Orderby
FROM WT8888STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.ReportID = @ReportID
    AND NOT EXISTS(SELECT TOP 1 1 FROM WT8888 WHERE DivisionID = A00.DefDivisionID AND ReportID = @ReportID)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
