USE [AS_CRM]
GO
/****** Object:  StoredProcedure [dbo].[CRMP20803]    Script Date: 1/26/2018 3:05:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- <Summary>
---- In Grid Form CRMF20801 Danh mục yêu cầu
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Cao Thị Phượng, Date: 27/03/2017
--- Modify by Thị Phượng, Date 08/05/2017: Bổ sung phân quyền
--- Modify by Tấn Đạt, Date 26/01/2018: Bổ sung thêm trường RequestTypeID
-- <Example>
/*
--Lưu y chưa xử lý: Phân quyền xem dữ liệu người khác, phân quyền chi tiết dữ liệu

EXEC CRMP20803 'AS' ,'','' ,'' ,'' , '', '' , 'NV01' ,N'ASOFTADMIN'', ''DANH'', ''HOANG'', ''HUYEN'', ''LIEN'', ''LUAN'', ''PHUONG'', ''QUI'', ''QUYNH'', ''VU' ,''

*/
ALTER PROCEDURE [dbo].[CRMP20803] ( 
  @DivisionID VARCHAR(50),  --Biến môi trường
  @DivisionIDList NVARCHAR(2000),      --Chọn trong DropdownChecklist DivisionID
  @RequestSubject nvarchar(50),
  @AccountID nvarchar(250),
  @AssignedToUserID nvarchar(250),
  @RequestStatus nvarchar(250),
  @PriorityID nvarchar(100),
  @UserID  VARCHAR(50),
  @ConditionRequestID NVARCHAR (MAX),
  @RequestTypeID nvarchar(250)
) 
AS 
DECLARE @sSQL NVARCHAR (MAX),
		@sWhere NVARCHAR(MAX),
		@OrderBy NVARCHAR(500)
		
	SET @sWhere = ''
	SET @OrderBy = 'M.RequestID'
	
	--Check Para DivisionIDList null then get DivisionID 
	IF Isnull(@DivisionIDList, '') != ''
		SET @sWhere = @sWhere + ' M.DivisionID IN ('''+@DivisionIDList+''') '
	Else 
		SET @sWhere = @sWhere + ' M.DivisionID = N'''+ @DivisionID+''''
		
		
	IF Isnull(@RequestSubject, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.RequestSubject, '''') LIKE N''%'+@RequestSubject+'%'' '
	IF Isnull(@AccountID, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(D.AccountID,'''') LIKE N''%'+@AccountID+'%''  '
	IF Isnull(@AssignedToUserID, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.AssignedToUserID,'''') LIKE N''%'+@AssignedToUserID+'%'' '
	IF Isnull(@RequestStatus, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.RequestStatus,'''') LIKE N''%'+@RequestStatus+'%'' '
	IF Isnull(@PriorityID, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.PriorityID,'''') LIKE N''%'+@PriorityID+'%'' '
	IF Isnull(@ConditionRequestID, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.CreateUserID,'''') In ('''+@ConditionRequestID+''') '
	IF Isnull(@RequestTypeID, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.RequestTypeID,'''') LIKE N''%'+@RequestTypeID+'%'' '
SET @sSQL = ' SELECT  M.APK, M.DivisionID, M.RequestID, M.RequestSubject, M.RelatedToTypeID
					, M.PriorityID, C02.Description as PriorityName , M.RequestStatus, C01.Description as RequestStatusName
					, M.TimeRequest, M.DeadlineRequest, M.AssignedToUserID, A.FullName as AssignedToUserName
					, M.RequestDescription, M.FeedbackDescription, B.AccountID as RelatedToID, B.AccountName as RelatedToName
					, M.CreateDate, M.CreateUserID +''_''+ A1.FullName as CreateUserName
					, M.LastModifyDate, M.LastModifyUserID +''_''+ A2.FullName as LastModifyUserName
					, M.RequestTypeID, C03.Description as RequestTypeName
					From CRMT20801 M With (Nolock)
					Left join CRMT20801_CRMT10101_REL D With (Nolock) on D.RequestID = M.RequestID
					LEft join CRMT10101 B With (Nolock) on  D.AccountID = B.AccountID
					Left join AT1103 A With (Nolock) On A.EmployeeID = M.AssignedToUserID
					Left join CRMT0099 C01 With (Nolock) On C01.ID = M.RequestStatus and C01.CodeMaster =''CRMT00000003''
					Left join CRMT0099 C02 With (Nolock) On C02.ID = M.RequestStatus and C02.CodeMaster =''CRMT00000006''
					Left join AT1103 A1 With (Nolock) On A1.EmployeeID = M.CreateUserID
					Left join AT1103 A2 With (Nolock) On A2.EmployeeID = M.LastModifyUserID								
					Left join CRMT0099 C03 With (Nolock) On C03.ID = M.RequestTypeID and C03.CodeMaster =''CRMT00000025''			 
			WHERE '+@sWhere+'
			ORDER BY '+@OrderBy+' '
EXEC (@sSQL)
--print (@sSQL)