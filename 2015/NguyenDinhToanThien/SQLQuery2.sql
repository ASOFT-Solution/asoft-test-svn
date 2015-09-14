USE [ERP90]
GO
/****** Object:  StoredProcedure [dbo].[HoiVien0002]    Script Date: 9/14/2015 4:21:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----<Summary>
----Man hinh truy van load du lieu danh muc nguoi dung -Store SP10001
----<Param>
---- 
----<Return>
---- 
----<Reference>
---- 
----<History>
----Created by: Ho hoang tu, Date: 09/10/2014
----Modify by: Phan thanh hoang vu, 16/10/2014 
----Modify by: Trần Quốc Tuấn, 11/11/2014 bổ sung thêm trường khóa  
---- 
----EXEC SP10001 'KC','KC'',''KC', '', '', '', '', '', '', '', 0, 0,'', 1, 20
----
ALTER PROCEDURE [dbo].[HoiVien0002] ( 
        @DivisionID NVARCHAR(50),      
		@MemberID NVARCHAR(50),
		@MemberName NVARCHAR(50),
		@Identify NVARCHAR(50),
		@Address NVARCHAR(50),
		@Tel NVARCHAR(50),
		@Phone NVARCHAR(50),
		@Fax NVARCHAR(50),
		@Email NVARCHAR(50),
		@Disable NVARCHAR(50),
		@PageNumber INT,
        @PageSize INT
) 
AS 
BEGIN
		DECLARE @sSQL NVARCHAR (MAX),
				@sWhere NVARCHAR(MAX),
				@OrderBy NVARCHAR(500),
				@TotalRow NVARCHAR(50)
        
			SET @sWhere = ''
			SET @TotalRow = ''

			--Sap xep du lieu tra ve
			SET @OrderBy = 'DivisionID'
	
			--Dem so dong phan trang
			IF @PageNumber = 1 SET @TotalRow = 'COUNT(*) OVER ()' ELSE SET @TotalRow = 'NULL'
	
			--Kiem tra neu DivisionIDList null không search thi lay DivisionID cua bien moi truong, 
			--Ngược lai thi lai trong dieu kien Search DivisionIDList
	
			--Kiem tra neu thoa dieu kien thi truyen dieu kien search
			IF @DivisionID IS NOT NULL 
				SET @sWhere = @sWhere +  'AND DivisionID LIKE ''%'+@DivisionID+'%'' '
			IF @MemberID IS NOT NULL 
				SET @sWhere = @sWhere +  'AND MemberID LIKE ''%'+@MemberID+'%'' '
			IF @MemberName IS NOT NULL 
				SET @sWhere = @sWhere +  'AND MemberName LIKE ''%'+@MemberName +'%'' '
			IF @Identify IS NOT NULL 
				SET @sWhere = @sWhere +  'AND Identify LIKE ''%'+@Identify +'%'' '
			IF @Address IS NOT NULL 
				SET @sWhere = @sWhere +  'AND Address LIKE ''%'+@Address +'%'' '
			IF @Tel IS NOT NULL 
				SET @sWhere = @sWhere +  'AND Tel LIKE ''%'+@Tel +'%'' '
			IF @Phone IS NOT NULL 
				SET @sWhere = @sWhere +  'AND Phone LIKE ''%'+@Phone +'%'' '
			IF @Fax IS NOT NULL 
				SET @sWhere = @sWhere +  'AND Fax LIKE ''%'+@Fax +'%'' '
			IF @Email IS NOT NULL 
				SET @sWhere = @sWhere +  'AND Email LIKE ''%'+@Email +'%'' '
			IF @Disable is not null
				SET @sWhere = @sWhere +  'AND Disable ='''+@Disable+''''
	
			--Cau SQL truy van lay du lieu	
			SET @sSQL = 'SELECT ROW_NUMBER() OVER (ORDER BY '+@OrderBy+') AS RowNum
										, '+@TotalRow+' AS TotalRow
						,APK
						,DivisionID 
						, MemberID
						,MemberName 
						, Identify
						, Address
						,Tel
						,Phone
						, Email
						,Disable
			FROM HoiVien
			WHERE 1=1 '+@sWhere+'
			ORDER BY '+@OrderBy+'
			OFFSET '+STR((@PageNumber-1))+' ROWS'
		
			EXEC (@sSQL)
			PRINT (@sSQL)
END
