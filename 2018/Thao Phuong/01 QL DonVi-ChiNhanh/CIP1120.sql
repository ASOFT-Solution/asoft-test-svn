IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'CIP1120') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE CIP1120
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
---- Load Grid Form Danh muc don vi
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Thao Phuong, Date: 22/01/2018
-- <Example> EXEC CIP1120 'AS', '', '', '', '', '', '', '', '', '', 1, 20

CREATE PROCEDURE CIP1120( 
          @DivisionID VARCHAR(50),  
		  @DivisionIDList NVARCHAR(2000), 
		  @DivisionName nvarchar(250),
		  @Tel nvarchar(50),
		  @Email nvarchar(250),
		  @Fax nvarchar(100),
		  @Address nvarchar(250),
		  @ContactPerson nvarchar(100),
		  @Disabled nvarchar(100),
		  @UserID  VARCHAR(50),
		  @PageNumber INT,
		  @PageSize INT
) 
AS 
DECLARE @sSQL NVARCHAR (MAX),
		@sWhere NVARCHAR(MAX),
		@OrderBy NVARCHAR(500)
		
	SET @sWhere = ''
	SET @OrderBy = ' M.CreateDate DESC, M.DivisionName '

		--Check Para DivisionIDList null then get DivisionID 
	IF Isnull(@DivisionIDList, '') != ''
		SET @sWhere = @sWhere + ' (M.DivisionID IN ('''+@DivisionIDList+''')) '
	Else 
		SET @sWhere = @sWhere + ' (M.DivisionID in ('''+@DivisionID+''')) '
		
		
	IF Isnull(@DivisionName, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.DivisionName, '''') LIKE N''%'+@DivisionName+'%'' '
	IF Isnull(@Tel, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.Tel, '''') LIKE N''%'+@Tel+'%'' '
	IF Isnull(@Email, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.Email,'''') LIKE N''%'+@Email+'%''  '
	IF Isnull(@Fax, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.Fax,'''') LIKE N''%'+@Fax+'%'' '
	IF Isnull(@Address, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.Address,'''') LIKE N''%'+@Address+'%'' '
	IF Isnull(@ContactPerson, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.ContactPerson,'''') LIKE N''%'+@ContactPerson+'%'' '
	IF Isnull(@Disabled, '') != ''
		SET @sWhere = @sWhere + ' AND ISNULL(M.Disabled,'''') LIKE N''%'+@Disabled+'%'' '

SET @sSQL = ' 
			SELECT M.APK, M.DivisionID, M.DivisionName
					, M.Tel, M.Email, M.Fax, M.Address
					, M.ContactPerson, M.Disabled
					, M.CreateUserID, M.CreateDate, M.LastModifyUserID, M.LastModifyDate
					 into #TempAT1101
			FROM AT1101 M With (NOLOCK) 
			WHERE '+@sWhere+'

			DECLARE @count int
			Select @count = Count(DivisionID) From #TempAT1101 With (NOLOCK) 

			SELECT ROW_NUMBER() OVER (ORDER BY '+@OrderBy+') AS RowNum, @count AS TotalRow
					, M.APK, M.DivisionID, M.DivisionName
					, M.Tel, M.Email, M.Fax, M.Address
					, M.ContactPerson, M.Disabled
					, M.CreateUserID, M.CreateDate, M.LastModifyUserID, M.LastModifyDate
			FROM #TempAT1101 M  With (NOLOCK) 
			ORDER BY '+@OrderBy+'
			OFFSET '+STR((@PageNumber-1) * @PageSize)+' ROWS
			FETCH NEXT '+STR(@PageSize)+' ROWS ONLY '
EXEC (@sSQL)