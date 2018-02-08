IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'CRMP20801') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE CRMP20801
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
---- Load Grid Form CRMP20801 Danh mục yêu cầu
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Cao Thị Phượng, Date: 27/03/2017
--- Modify by Thị Phượng, Date 08/05/2017: Bổ sung phân quyền
--- Modify by Thị Phượng, Date 30/08/2017: Thay đổi cách sắp xếp order by theo CreateDate
--- Modify by Thị Phượng, Date 08/11/2017: Bổ sung thêm xử lý search nâng cao
--- Modify by Tấn Đạt, Date 08/02/2018: Bổ sung thêm các trường: RequestTypeID, RequestTypeName, BugTypeID, BugTypeName, DeadlineExpect, CompleteDate, DurationTime, RealTime
--- Modify by Tấn Đạt, Date 08/02/2018: Bổ sung thêm các trường: ProjectID, ProjectName
-- <Example>
/*
--Lưu y chưa xử lý: Phân quyền xem dữ liệu người khác, phân quyền chi tiết dữ liệu

EXEC CRMP20801 'AS' ,'','' ,'' ,'' , '', '' , 'NV01',N'ASOFTADMIN'', ''DANH'', ''HOANG'', ''HUYEN'', ''LIEN'', ''LUAN'', ''PHUONG'', ''QUI'', ''QUYNH'', ''VU'  ,1 ,20,''

*/
CREATE PROCEDURE CRMP20801 ( 
  @DivisionID VARCHAR(50),  --Biến môi trường
  @DivisionIDList NVARCHAR(2000),      --Chọn trong DropdownChecklist DivisionID
  @RequestSubject nvarchar(50),
  @AccountID nvarchar(250),
  @AssignedToUserID nvarchar(250),
  @RequestStatus nvarchar(250),
  @PriorityID nvarchar(100),
  @UserID  VARCHAR(50),
  @ConditionRequestID NVARCHAR (MAX),
  @PageNumber INT,
  @PageSize INT ,
  @SearchWhere NVARCHAR(Max) = null		
  --,@RequestTypeID nvarchar(250),
  --@BugTypeID VARCHAR(50),
  --@DeadlineExpect VARCHAR(50), 
  --@CompleteDate VARCHAR(50),
  --@DurationTime VARCHAR(50), 
  --@RealTime VARCHAR(50),
  --@projectID varchar(50)
) 
AS 
DECLARE @sSQL NVARCHAR (MAX),
		@sWhere NVARCHAR(MAX),
		@OrderBy NVARCHAR(500),
        @TotalRow NVARCHAR(50)
		
	SET @sWhere = '1 = 1'
	SET @TotalRow = ''
	SET @OrderBy = ' M.CreateDate DESC'


IF isnull(@SearchWhere,'') =''
Begin
	--Check Para DivisionIDList null then get DivisionID 
	IF Isnull(@DivisionIDList, '') != ''
		SET @sWhere = @sWhere + ' AND M.DivisionID IN ('''+@DivisionIDList+''') '
	Else 
		SET @sWhere = @sWhere + ' AND M.DivisionID = N'''+ @DivisionID+''''
		
		
	IF Isnull(@RequestSubject, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.RequestSubject, '''') LIKE N''%'+@RequestSubject+'%'' '
	IF Isnull(@AccountID, '') != ''
		SET @sWhere = @sWhere + ' AND (ISNULL(B.AccountID,'''') LIKE N''%'+@AccountID+'%'' or  ISNULL(B.AccountName,'''') LIKE N''%'+@AccountID+'%'')  '
	IF Isnull(@AssignedToUserID, '') != ''
		SET @sWhere = @sWhere + ' AND (ISNULL(M.AssignedToUserID,'''') LIKE N''%'+@AssignedToUserID+'%''  or isnull(A.FullName,'''') LIKE N''%'+@AssignedToUserID+'%'' )'
	IF Isnull(@RequestStatus, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.RequestStatus,'''') LIKE N''%'+@RequestStatus+'%'' '
	IF Isnull(@PriorityID, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.PriorityID,'''') LIKE N''%'+@PriorityID+'%'' '
	IF Isnull(@ConditionRequestID, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.AssignedToUserID,'''') In ('''+@ConditionRequestID+''') '

	--IF Isnull(@RequestTypeID, '') != ''
	--	SET @sWhere = @sWhere + ' AND ISNULL(M.RequestTypeID,'''') LIKE N''%'+@RequestTypeID+'%'' '
	--IF Isnull(@BugTypeID, '') != ''
	--	SET @sWhere = @sWhere + ' AND ISNULL(M.BugTypeID,'''') LIKE N''%'+@BugTypeID+'%'' '
	--IF Isnull(@DeadlineExpect, '') != ''
	--	SET @sWhere = @sWhere + ' AND ISNULL(M.DeadlineExpect,'''') LIKE N''%'+@DeadlineExpect+'%'' '
	--IF Isnull(@CompleteDate, '') != ''
	--	SET @sWhere = @sWhere + ' AND ISNULL(M.CompleteDate,'''') LIKE N''%'+@CompleteDate+'%'' '
	--IF Isnull(@DurationTime, '') != ''
	--	SET @sWhere = @sWhere + ' AND ISNULL(M.DurationTime,'''') LIKE N''%'+@DurationTime+'%'' '
	--IF Isnull(@RealTime, '') != ''
	--	SET @sWhere = @sWhere + ' AND ISNULL(M.RealTime,'''') LIKE N''%'+@RealTime+'%'' '
	--IF Isnull(@ProjectID, '') != ''
	--	SET @sWhere = @sWhere + ' AND ISNULL(M.ProjectID,'''') LIKE N''%'+@ProjectID+'%'' '
End
IF isnull(@SearchWhere,'') !=''
Begin
	SET  @sWhere='1 = 1'
End
SET @sSQL = ' SELECT  M.APK, M.DivisionID, M.RequestID, M.RequestSubject, M.RelatedToTypeID
					, M.PriorityID, C02.Description as PriorityName , M.RequestStatus, C01.Description as RequestStatusName
					, M.TimeRequest, M.DeadlineRequest, M.AssignedToUserID, A.FullName as AssignedToUserName
					, M.RequestDescription, M.FeedbackDescription
					, stuff(isnull((Select '', '' +  B.AccountID From CRMT10101 B WITH (NOLOCK) 
						Left join CRMT20801_CRMT10101_REL D WITH (NOLOCK)  ON D.AccountID = B.APK 
						where D.RequestID = M.RequestID
						Group by B.AccountID
						FOR XML PATH (''''), TYPE).value(''.'',''NVARCHAR(max)''), ''''), 1, 2, '''') as RelatedToID
					, stuff(isnull((Select '', '' + B.AccountName From CRMT10101 B WITH (NOLOCK) 
						Left join CRMT20801_CRMT10101_REL D WITH (NOLOCK)  ON D.AccountID = B.APK 
						where D.RequestID = M.RequestID
						Group by B.AccountID, B.AccountName
						FOR XML PATH (''''), TYPE).value(''.'',''NVARCHAR(max)''), ''''), 1, 2, '''') as RelatedToName
					, M.CreateDate, M.LastModifyDate
					--, M.DeadlineExpect, M.CompleteDate, M.DurationTime, M.RealTime
					--, M.RequestTypeID, C03.Description as RequestTypeName
					--, M.BugTypeID, C04.Description as BugTypeName
					--, M.ProjectID, A1.AnaName as ProjectName
					Into #CRMT20801
					From CRMT20801 M With (Nolock)
					Left join AT1103 A With (Nolock) On  A.EmployeeID = M.AssignedToUserID
					Left join CRMT0099 C01 With (Nolock) On C01.ID = M.RequestStatus and C01.CodeMaster =''CRMT00000003''
					Left join CRMT0099 C02 With (Nolock) On C02.ID = M.PriorityID and C02.CodeMaster =''CRMT00000006''		
					Left join CRMT0099 C03 With (Nolock) On C03.ID = M.RequestTypeID and C03.CodeMaster =''CRMT00000025''			  
					Left join CRMT0099 C04 With (Nolock) On C04.ID = M.BugTypeID and C04.CodeMaster =''CRMT00000026''			  	 
					Left join AT1015 A1 With (Nolock) On A1.AnaID = M.ProjectID 
			WHERE '+@sWhere+'

			DECLARE @Count int
			Select @Count = Count(RequestID) From #CRMT20801 
			'+Isnull(@SearchWhere,'')+'

			SELECT ROW_NUMBER() OVER (ORDER BY '+@OrderBy+') AS RowNum, @Count AS TotalRow, 
				 M.APK, M.DivisionID, M.RequestID, M.RequestSubject, M.RelatedToTypeID
					, M.PriorityID, M.PriorityName , M.RequestStatus, M.RequestStatusName
					, M.TimeRequest, M.DeadlineRequest, M.AssignedToUserID, M.AssignedToUserName
					, M.RequestDescription, M.FeedbackDescription
					, M.RelatedToID, M.RelatedToName
					, M.CreateDate, M.LastModifyDate
					--, M.DeadlineExpect, M.CompleteDate, M.DurationTime, M.RealTime
					--, M.RequestTypeID, M.RequestTypeName
					--, M.BugTypeID, M.BugTypeName
					--, M.ProjectID, M.ProjectName
					From #CRMT20801 M With (Nolock)	
					'+Isnull(@SearchWhere,'')+'									 
			ORDER BY '+@OrderBy+'
			OFFSET '+STR((@PageNumber-1) * @PageSize)+' ROWS
			FETCH NEXT '+STR(@PageSize)+' ROWS ONLY '
EXEC (@sSQL)
print (@sSQL)