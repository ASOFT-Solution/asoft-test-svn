IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2043]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP2043]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- Load các phiếu kiểm kê để lên màn hình truy vấn
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: Nguyen Quoc Huy. Date: 08/01/2007
----Modified by Thanh Sơn on 10/07/2014: Chuyển lấy dữ liệu trực tiếp từ store (không qua view) (master: AP2043, detail: AP2044)
----Modified by Hoàng vũ on 10/08/2014: Bổ sung phân quyền xem dữ liệu của người khác
-- <Example>
/*
    EXEC AP2043 'AS', 'ASOFTADMIN', 1,2014,'','','',''
*/

CREATE PROCEDURE AP2043
(
    @DivisionID NVARCHAR(50),
    @UserID VARCHAR(50),
    @TranMonth INT,
    @TranYear INT,
    @ConditionVT NVARCHAR(MAX),
	@IsUsedConditionVT NVARCHAR(20),	
	@ConditionWA NVARCHAR(MAX),
	@IsUsedConditionWA NVARCHAR(20)
)
AS
DECLARE @sSQL NVARCHAR(MAX)
	
	----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
		DECLARE @sSQLPer AS NVARCHAR(MAX),
				@sWHEREPer AS NVARCHAR(MAX)
		SET @sSQLPer = ''
		SET @sWHEREPer = ''		

		IF EXISTS (SELECT TOP 1 1 FROM WT0000 WHERE DefDivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
			BEGIN
				SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = A36.DivisionID 
													AND AT0010.AdminUserID = '''+@UserID+''' 
													AND AT0010.UserID = A36.CreateUserID '
				SET @sWHEREPer = ' AND (A36.CreateUserID = AT0010.UserID
										OR  A36.CreateUserID = '''+@UserID+''') '		
			END

		-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		

SET @sSQL = '
SELECT A36.VoucherTypeID, A36.VoucherNo, A36.VoucherDate, 
	ConvertedAmount = (SELECT SUM(ConvertedAmount) FROM AT2037 WHERE VoucherID = A36.VoucherID And DivisionID = '''+@DivisionID+'''),
	A36.EmployeeID, A03.FullName, A36.WareHouseID, A33.WareHouseName, A36.[Description], A36.VoucherID, A36.[Status],
	A36.DivisionID, A36.TranMonth, A36.TranYear, A36.CreateDate, A36.CreateUserID, A36.LastModifyDate, A36.LastModifyUserID
FROM AT2036 A36
	LEFT JOIN AT1303 A33 ON A33.DivisionID = A36.DivisionID AND A33.WareHouseID = A36.WareHouseID
	LEFT JOIN AT1103 A03 ON A03.DivisionID = A36.DivisionID AND A03.EmployeeID = A36.EmployeeID
	' + @sSQLPer+ '
WHERE A36.DivisionID = '''+@DivisionID+''''+ @sWHEREPer+'
AND A36.TranMonth = '+STR(@TranMonth)+'
AND A36.TranYear = '+STR(@TranYear)+' '

EXEC (@sSQL)
Print @sSQL

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
