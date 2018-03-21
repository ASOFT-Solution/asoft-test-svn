IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OOP2115]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OOP2115]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load màn hình chọn công việc
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: Hoàng vũ
----<Example> exec OOP2115 @DivisionID=N'KY', @TxtSearch=N'',@UserID=N'', @ConditionWorkID=N'',@PageNumber=N'1',@PageSize=N'10'

 CREATE PROCEDURE OOP2115 (
     @DivisionID NVARCHAR(2000),		--Biến môi trường
	 @TxtSearch NVARCHAR(250),
	 @UserID VARCHAR(50),				--Biến môi trường
	 @ConditionWorkID  NVARCHAR (MAX),
     @PageNumber INT,
     @PageSize INT
)
AS
BEGIN
	DECLARE @sSQL NVARCHAR (MAX),
			@sWhere NVARCHAR(MAX),
			@OrderBy NVARCHAR(500)
			
	DECLARE @CustomerName INT
	IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#CustomerName')) 
	DROP TABLE #CustomerName
	CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
	INSERT #CustomerName EXEC AP4444
	SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName) 
	
	SET @sWhere = ''
	SET @OrderBy = ' M.StartDate DESC, M.PlanStartDate DESC'

	IF @TxtSearch IS NOT NULL SET @sWhere = @sWhere +'
		AND (M.ProjectID + '' '' + TM21.ProjectName LIKE N''%'+@TxtSearch+'%'' 
				OR M.ProcessID + '' '' +  TM11.ProcessName LIKE N''%'+@TxtSearch+'%'' 
				OR M.StepID + '' '' +  TM12.StepName LIKE N''%'+@TxtSearch+'%'' 
				OR M.WorkID + '' '' +  M.WorkName LIKE N''%'+@TxtSearch+'%'' 
				OR M.AssignedToUserID + '' '' + HT141.LastName + '' '' + HT141.MiddleName + '' '' + HT141.FirstName LIKE N''%'+@TxtSearch + '%'' 
				OR M.StatusID + '' '' +  TM13.StatusName LIKE N''%'+@TxtSearch+'%'' 
				)'
	
	SET @sSQL = '
	Select M.DivisionID, M.WorkID, M.WorkName
			, M.AssignedToUserID, HT141.LastName + '' '' + HT141.MiddleName + '' '' + HT141.FirstName as AssignedToUserName
			, M.ProjectID, TM21.ProjectName, TM21.StartDate
			, M.ProjectID+'' - ''+TM21.ProjectName as N''ProjectID_ProjectName''
			, M.ProcessID, TM11.ProcessName
			, M.StepID, TM12.StepName
			, M.StatusID, TM13.StatusName
			, M.PlanStartDate, M.PlanEndDate, M.PlanTime
			, M.CreateUserID, M.CreateDate, M.LastModifyUserID, M.LastModifyDate
			into #TempOOT2110
	from OOT2110 M With (NOLOCK) Left join OOT2100 TM21 With (NOLOCK) on M.ProjectID = TM21.ProjectID
									Left join OOT1020 TM11 With (NOLOCK) on M.ProcessID = TM11.ProcessID
									Left join OOT1030 TM12 With (NOLOCK) on M.StepID = TM12.StepID
									Left join HT1400 HT141 With (NOLOCK) on M.AssignedToUserID = HT141.EmployeeID
									Left join OOT1040 TM13 With (NOLOCK) on M.StatusID = TM13.StatusID
	WHERE M.DivisionID = N'''+@DivisionID+''' and M.DeleteFlg =0 ' + @sWhere +'

	DECLARE @count int
	Select @count = Count(WorkID) From #TempOOT2110

	SELECT ROW_NUMBER() OVER (ORDER BY '+@OrderBy+') AS RowNum, @count AS TotalRow
			, M.DivisionID, M.WorkID, M.WorkName
			, M.AssignedToUserName
			, M.ProjectID, M.ProjectName, M.StartDate
			, M.ProjectID_ProjectName
			, M.ProcessID, M.ProcessName
			, M.StepID, M.StepName
			, M.StatusID, M.StatusName
			, M.PlanStartDate, M.PlanEndDate, M.PlanTime
			, M.CreateUserID, M.CreateDate, M.LastModifyUserID, M.LastModifyDate
	FROM #TempOOT2110 M
	ORDER BY '+@OrderBy+'
	OFFSET '+STR((@PageNumber-1) * @PageSize)+' ROWS
	FETCH NEXT '+STR(@PageSize)+' ROWS ONLY '
	
	EXEC (@sSQL)
	
	
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
