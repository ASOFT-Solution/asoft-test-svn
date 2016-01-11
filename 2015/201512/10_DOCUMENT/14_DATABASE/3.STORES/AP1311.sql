IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1311]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1311]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--- Created by Hoàng Vũ	Date: 07/07/2015
---Store AP1311 thay thế View MQ2221 và phân bổ sung thêm quyền xem dữ liệu của người
--- Purpose: Load master kế thừa đơn hàng sản xuất từ phiếu giao giao việc
--- EXEC AP1311 'AS', '', '', '', 'ASOFTADMIN'

CREATE PROCEDURE [dbo].[AP1311] 
(
	@DivisionID nvarchar(50),
	@ExtraID nvarchar(250),
	@ExtraName nvarchar(250),
	@Note  nvarchar(250),
	@UserID nvarchar(250)
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

IF EXISTS (SELECT TOP 1 1 FROM OT0001 WHERE DivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = A11.DivisionID 
											AND AT0010.AdminUserID = '''+@UserID+''' 
											AND AT0010.UserID = A11.CreateUserID '
		SET @sWHEREPer = ' AND (A11.CreateUserID = AT0010.UserID
								OR  A11.CreateUserID = '''+@UserID+''') '		
	END

-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		
SET @DivisionWhere = '1 = 1'

IF @DivisionID is not null and @DivisionID != ''
	Set @DivisionWhere = @DivisionWhere + ' And A11.DivisionID = '''+Isnull(@DivisionID,'''') +''''

IF @ExtraID is not null and @ExtraID !=''
	Set @DivisionWhere = @DivisionWhere + ' And A11.ExtraID like  N''%'+isnull(@ExtraID,'''') +'%'''

IF @ExtraName is not null and @ExtraName !=''
	Set @DivisionWhere = @DivisionWhere + ' And A11.ExtraName like ''%'+isnull(@ExtraName,'''') +'%'''

IF @Note is not null and @Note !=''
	Set @DivisionWhere = @DivisionWhere + ' And A11.Note like ''%'+isnull(@Note,'''') +'%'''
			
SET @sSQL = ' Select A11.* from AT1311 A11
			' + @sSQLPer+ 
			'Where '+ @DivisionWhere + '' + @sWHEREPer+
			' Order by ExtraID'	

EXEC(@sSQL)
print @sSQL


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
