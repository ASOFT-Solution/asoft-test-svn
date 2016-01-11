IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0135]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0135]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load bộ định mức theo quy cách - MF0135
-- <History>
---- Created by Tiểu Mai on 02/12/2015
---- Modified on ... by 
-- <Example>


CREATE PROCEDURE [dbo].[MP0135] 	
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
		LEFT JOIN AT0010 ON AT0010.DivisionID = MT35.DivisionID AND AT0010.AdminUserID = '''+@UserID+''' AND AT0010.UserID = MT35.CreateUserID '
		SET @sWHEREPer = '
		AND (MT35.CreateUserID = AT0010.UserID OR  MT35.CreateUserID = '''+@UserID+''') '		
	END


---- Load bộ định mức theo quy cách MT0135
SET @sSQL1 = N'
SELECT MT35.*, AT1202.ObjectName, (case when MT35.IsBOM = 1 then N''Định mức nguyên vật liệu'' ELSE N''Định mức hàng xuất kho'' end) as Type
FROM MT0135 MT35
left join AT1202 on AT1202.DivisionID = MT35.DivisionID and AT1202.ObjectID = MT35.ObjectID '+@sSQLPer+'
WHERE MT35.DivisionID = '''+@DivisionID+'''
	  AND MT35.Disabled = 0 '+@sWHEREPer+'
ORDER BY MT35.DivisionID, MT35.ApportionID
' 
EXEC (@sSQL1)
--PRINT @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

