IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1322]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1322]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--- Created by Hoàng Vũ	Date: 21/07/2015
--- Purpose: Load danh sách mã phụ (Customize index = 43  secoin)
--- EXEC AP1322 'AS','ASOFTADMIN'

CREATE PROCEDURE [dbo].[AP1322] 
(
	@DivisionID nvarchar(50),
	@UserID nvarchar(50)
)
AS

Declare @sSQL AS varchar(max),
		@DivisionWhere AS VARCHAR(MAX),
		@sWHERE AS VARCHAR(MAX)
	
----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer AS NVARCHAR(MAX),
		@sWHEREPer AS NVARCHAR(MAX)
SET @sSQLPer = ''
SET @sWHEREPer = ''		

IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = AT1311.DivisionID 
											AND AT0010.AdminUserID = '''+@UserID+''' 
											AND AT0010.UserID = AT1311.CreateUserID '
		SET @sWHEREPer = ' AND (AT1311.CreateUserID = AT0010.UserID
								OR  AT1311.CreateUserID = '''+@UserID+''') '		
	END

-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác					
			
SET @sSQL =' 
SELECT	Distinct
		AT1311.DivisionID,
		AT1311.ExtraID,
		AT1311.ExtraName,
		AT1311.Note,
		AT1311.Note01,
		AT1311.Note02,
		AT1311.Note03,
		AT1311.Note04,
		AT1311.Note05,
		AT1311.Note06,
		AT1311.Note07,
		AT1311.Note08,
		AT1311.Note09,
		AT1311.Note10,
		AT1311.Disabled,
		AT1311.CreateUserID,
		AT1311.CreateDate,
		AT1311.LastModifyUserID,
		AT1311.LastModifyDate
FROM	AT1311 
'+ @sSQLPer + 
' WHERE	AT1311.DivisionID = ''' + @DivisionID+ '''' + @sWHEREPer+ ' Order by AT1311.ExtraID'

EXEC (@sSQL)
Print (@sSQL)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
