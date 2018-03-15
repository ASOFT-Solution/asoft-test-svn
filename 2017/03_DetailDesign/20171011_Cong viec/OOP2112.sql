IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OOP2112]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OOP2112]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- Load form OOF2110 - In Danh sách công việc
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: Phan thanh hoàng vũ on 18/10/2017
-- <Example>
/*
    EXEC OOP2112 'KY','','', '', N'', N'', N'', N'', N'', N'', N'',2, N'', N''
*/

CREATE PROCEDURE OOP2112 
( 
	@DivisionID nvarchar(250),
	@DivisionIDList NVARCHAR(MAX), 
	@FromDate Datetime,
	@ToDate Datetime,
	@WorkID nvarchar(250),
	@ProjectID nvarchar(250),
	@ProcessID nvarchar(250),
	@StepID nvarchar(250),
	@StatusID nvarchar(250),
	@ReviewerUserID nvarchar(250),
	@AssignedToUserID nvarchar(250),
	@Mode int,							--1: Kanban, 2: List, 3: Gantt, 4: Calendar
	@ConditionWorkID  NVARCHAR (MAX),
	@UserID  nvarchar(250)
   ) 
AS
BEGIN
		DECLARE @sSQL NVARCHAR (MAX),
				@sWhere NVARCHAR(MAX),
				@FromDateText NVARCHAR(20), 
				@ToDateText NVARCHAR(20)

		SET @sWhere = ''
		SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
		SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

		--Check Para DivisionIDList null then get DivisionID 
		IF Isnull(@DivisionIDList, '') != ''
			SET @sWhere = @sWhere + ' M.DivisionID IN ('''+@DivisionIDList+''') and M.DeleteFlg = 0'
		Else 
			SET @sWhere = @sWhere + ' M.DivisionID = N'''+ @DivisionID+''' and M.DeleteFlg = 0'	

		--Check Para FromDate và ToDate
		IF (isnull(@FromDate, '') = '' and isnull(@ToDate, '') != '')
		BEGIN
			SET @sWhere = @sWhere + ' and (M.PlanStartDate <= '''+ @ToDateText + ''' 
											or M.PlanEndDate <= '''+ @ToDateText + ''' 
											or M.ActualStartDate <= '''+ @ToDateText + '''
											or M.ActualEndDate <= '''+ @ToDateText + '''
											or M.CreateDate <= '''+ @ToDateText + ''')'
		END
		ELSE IF (isnull(@FromDate, '') != '' and isnull(@ToDate, '') = '')
			 BEGIN
				SET @sWhere = @sWhere + ' and (M.PlanStartDate >= '''+ @FromDateText + ''' 
											or M.PlanEndDate >= '''+ @FromDateText + ''' 
											or M.ActualStartDate >= '''+ @FromDateText + '''
											or M.ActualEndDate >= '''+ @FromDateText + '''
											or M.CreateDate >= '''+ @FromDateText + ''')'
			 END
		ELSE IF (isnull(@FromDate, '') != '' and isnull(@ToDate, '') != '')
			 BEGIN
				SET @sWhere = @sWhere + ' AND (M.PlanStartDate Between '''+ @FromDateText + ''' and '''+ @ToDateText + ''' 
											or M.PlanEndDate Between '''+ @FromDateText + ''' and '''+ @ToDateText + ''' 
											or M.ActualStartDate Between '''+ @FromDateText + ''' and '''+ @ToDateText + ''' 
											or M.ActualEndDate Between '''+ @FromDateText + ''' and '''+ @ToDateText + ''' 
											or M.CreateDate Between '''+ @FromDateText + ''' and '''+ @ToDateText + ''' )'
			 END

		IF isnull(@ProjectID, '') != ''
			SET @sWhere = @sWhere + ' AND M.ProjectID LIKE N''%'+@ProjectID+'%''  '
	
		IF isnull(@ProcessID, '') != ''
			SET @sWhere = @sWhere + ' AND M.ProcessID LIKE N''%'+@ProcessID+'%''  '
		
		IF isnull(@StepID, '') != ''
			SET @sWhere = @sWhere + ' AND M.StepID LIKE N''%'+@StepID+'%''  '

		IF isnull(@WorkID, '') != ''
			SET @sWhere = @sWhere + ' AND (M.WorkID LIKE N''%'+@WorkID+'%'' Or M.WorkName LIKE N''%'+@WorkID+'%'')'

		IF isnull(@StatusID,'')!='' 
			SET @sWhere = @sWhere + ' AND M.StatusID LIKE N''%'+@StatusID+'%''  '

		IF isnull(@ReviewerUserID,'')!='' 
			SET @sWhere = @sWhere + ' AND M.ReviewerUserID LIKE N''%'+@ReviewerUserID+'%''  '

		IF isnull(@AssignedToUserID,'')!='' 
			SET @sWhere = @sWhere + ' AND M.AssignedToUserID LIKE N''%'+@AssignedToUserID+'%''  '
		--Xem dạng List
		IF @Mode = 2
		Begin
			SET @sSQL =N' Select M.APK, M.DivisionID, M.WorkID, M.WorkName
								, M.ProjectID, TM21.ProjectName
								, M.ProcessID, TM11.ProcessName
								, M.StepID, TM12.StepName
								, M.AssignedToUserID, HT141.LastName + '' '' + HT141.MiddleName + '' '' + HT141.FirstName as AssignedToUserName
								, M.PlanStartDate, M.PlanEndDate, M.PlanTime
								, M.PriorityID, A3.Description as PriorityName
								, M.PercentProgress
								, Isnull(M.StatusID, 0) as StatusID, TM13.StatusName
								, M.PriviousWorkID
								, M.Description
								, TM13.Orders
								, M.CreateUserID, M.CreateDate, M.LastModifyUserID, M.LastModifyDate
						from OOT2110 M With (NOLOCK) Left join OOT2100 TM21 With (NOLOCK) on M.ProjectID = TM21.ProjectID
														Left join OOT1020 TM11 With (NOLOCK) on M.ProcessID = TM11.ProcessID
														Left join OOT1030 TM12 With (NOLOCK) on M.StepID = TM12.StepID
														Left join HT1400 HT141 With (NOLOCK) on M.AssignedToUserID = HT141.EmployeeID
														Left join OOT1040 TM13 With (NOLOCK) on M.StatusID = TM13.StatusID
														Left join CRMT0099 A3 With (NOLOCK) on M.PriorityID = A3.ID and A3.CodeMaster = N''CRMT00000006''
						
						Where ' + @sWhere + '
						ORDER BY M.CreateDate, M.ProjectID '
			EXEC (@sSQL)
		End
		
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
