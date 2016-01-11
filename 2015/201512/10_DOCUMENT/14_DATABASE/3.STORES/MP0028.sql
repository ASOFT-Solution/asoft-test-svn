IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0028]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0028]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load bộ định mức MF0022 - Phân quyền xem dữ liệu của người dùng khác [LAVO]
-- <History>
---- Create on 23/03/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
-- MP0028 @DivisionID = 'LV', @UserID = ''

CREATE PROCEDURE [dbo].[MP0028] 	
	@DivisionID NVARCHAR(50),
	@UserID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX)
---- Thực hiện kiểm tra phân quyền dữ liệu
DECLARE @sSQLPer NVARCHAR(1000),
		@sWHEREPer NVARCHAR(1000)
SET @sSQLPer = ''
SET @sWHEREPer = ''		
IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsPermissionView = 1 ) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = '
		LEFT JOIN AT0010 ON AT0010.DivisionID = MT62.DivisionID AND AT0010.AdminUserID = '''+@UserID+''' AND AT0010.UserID = MT62.CreateUserID '
		SET @sWHEREPer = '
		AND (MT62.CreateUserID = AT0010.UserID OR  MT62.CreateUserID = '''+@UserID+''') '		
	END

---- Load bộ định mức MT1602
SET @sSQL1 = '
SELECT MT62.*
FROM MT1602 MT62 '+@sSQLPer+'
WHERE MT62.DivisionID = '''+@DivisionID+''' '+@sWHEREPer+'
ORDER BY MT62.DivisionID, MT62.ApportionID
' 
EXEC (@sSQL1)
--PRINT @sSQL1
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON