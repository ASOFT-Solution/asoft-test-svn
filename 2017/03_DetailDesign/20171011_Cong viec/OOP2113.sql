IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OOP2113]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OOP2113]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- Load form OOF2113 - Load màn hình Cập nhật công việc hàng loạt
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
    EXEC OOP2113 N'KY', N'M', N'Q', N'S', N'4', N'', N''
*/

CREATE PROCEDURE OOP2113 
( 
	@DivisionID nvarchar(250),			--Biến môi trường
	@ProjectID nvarchar(250),
	@ProcessID nvarchar(250),
	@StepID nvarchar(250),
	@StatusID nvarchar(250),
	@ConditionWorkID  NVARCHAR (MAX),	--Phân quyền vai trò biến môi trường
	@UserID  nvarchar(250)				--Biến môi trường
   ) 
AS
BEGIN
		DECLARE @sSQL NVARCHAR (MAX),
				@sWhere NVARCHAR(MAX)

		SET @sWhere = ''
		
		IF isnull(@ProjectID, '') != ''
			SET @sWhere = @sWhere + ' AND M.ProjectID LIKE N''%'+@ProjectID+'%''  '
	
		IF isnull(@ProcessID, '') != ''
			SET @sWhere = @sWhere + ' AND M.ProcessID LIKE N''%'+@ProcessID+'%''  '
		
		IF isnull(@StepID, '') != ''
			SET @sWhere = @sWhere + ' AND M.StepID LIKE N''%'+@StepID+'%''  '

		IF isnull(@StatusID, '') != ''
			SET @sWhere = @sWhere + ' AND M.StatusID LIKE N''%'+@StatusID+'%''  '

		SET @sSQL =N' Select M.APK, M.DivisionID, M.WorkID, M.WorkName
						, M.ProjectID, TM21.ProjectName
						, M.ProcessID, TM11.ProcessName
						, M.StepID, TM12.StepName
						, M.AssignedToUserID, HT141.LastName + '' '' + HT141.MiddleName + '' '' + HT141.FirstName as AssignedToUserName
						, M.PlanStartDate, M.PlanEndDate, M.PlanTime
						, M.PriorityID, A3.Description as PriorityName
						, M.PercentProgress
						, Isnull(M.StatusID, 0) as StatusID, TM13.StatusName
						, M.ParentWorkID
						, M.PriviousWorkID
						, M.Description
						, M.Orders
						, M.CreateUserID, M.CreateDate, M.LastModifyUserID, M.LastModifyDate
				from OOT2110 M With (NOLOCK) Left join OOT2100 TM21 With (NOLOCK) on M.ProjectID = TM21.ProjectID
												Left join OOT1020 TM11 With (NOLOCK) on M.ProcessID = TM11.ProcessID
												Left join OOT1030 TM12 With (NOLOCK) on M.StepID = TM12.StepID
												Left join HT1400 HT141 With (NOLOCK) on M.AssignedToUserID = HT141.EmployeeID
												Left join OOT1040 TM13 With (NOLOCK) on M.StatusID = TM13.StatusID
												Left join CRMT0099 A3 With (NOLOCK) on M.PriorityID = A3.ID and A3.CodeMaster = N''CRMT00000006''
						
				Where M.DivisionID = ''' + @DivisionID + '''' + @sWhere + '
				Order by M.ProjectID, M.ProcessID, M.StepID, M.Orders, M.PlanEndDate
				'
			EXEC (@sSQL)
		
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
