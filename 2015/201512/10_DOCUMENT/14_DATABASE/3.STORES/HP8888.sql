IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP8888]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP8888]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE PROCEDURE HP8888
(	
	@GroupID NVARCHAR(50),  
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
IF NOT EXISTS (SELECT TOP 1 1 FROM HT8888 WHERE ReportID = @ReportID)
	INSERT INTO HT8888(DivisionID, ReportID, ReportName, ReportNameE, Title, TitleE, [Description], DescriptionE,
		GroupID, [Type], [Disabled], SQLstring, Orderby)
	SELECT DivisionID, @ReportID, @ReportName, @ReportNameE, @ReportTitle, @ReportTitleE, @Description, @DescriptionE,
		@GroupID, @Type, @Disabled, @SQLstring, @Orderby
	FROM AT1101
		
ELSE UPDATE HT8888 SET ReportName = @ReportName, ReportNameE = @ReportNameE, Title = @ReportTitle, TitleE = @ReportTitleE,
[Description] = @Description, DescriptionE = @DescriptionE, GroupID = @GroupID, [Type] = @Type, [Disabled] = @Disabled,
SQLstring = @SQLstring, Orderby = @Orderby
WHERE ReportID = @ReportID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

