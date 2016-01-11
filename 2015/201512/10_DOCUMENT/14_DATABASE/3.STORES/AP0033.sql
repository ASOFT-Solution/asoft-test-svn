IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0033]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0033]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
	 --Created by NguyenThi Ngoc Minh, Date 25/10/2004.
	 --Purpose: Loc ra cac phieu xuat theo bo de len man hinh truy van
	 --Edited by Nguyen Quoc Huy, date: 28/03/2007
	 --Edited by: [GS] [Tố Oanh] [28/07/2010]
	 --Modified by Thanh Sơn on 09/07/2014: Bổ sung định danh cho trường RevoucherID do bảng AT2006 cũng có trường này
	 --Modified by Thanh Sơn on 10/07/2014: Lấy dữ liệu trực tiếp từ store, không sinh ra view (master: AP0033, detail: AP0032)
*/
CREATE PROCEDURE AP0033
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@TranMOnth INT,
	@TranYear INT,
	@ConditionVT NVARCHAR(MAX),
	@IsUsedConditionVT NVARCHAR(20),
	@ConditionOB NVARCHAR(MAX),
	@IsUsedConditionOB NVARCHAR(20),
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
				SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = T26.DivisionID 
													AND AT0010.AdminUserID = '''+@UserID+''' 
													AND AT0010.UserID = T26.CreateUserID '
				SET @sWHEREPer = ' AND (T26.CreateUserID = AT0010.UserID
										OR  T26.CreateUserID = '''+@UserID+''') '		
			END

		-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác	


SET @sSQL = '
SELECT * FROM
(
SELECT T26.VoucherTypeID, T26.VoucherNo, T26.VoucherDate, T26.RefNo01, T26.RefNo02, T26.ObjectID + '' - '' + T22.ObjectName ObjectID,
	T26.ObjectID ObjectIDPermission, T26.EmployeeID, T13.FullName, T26.WareHouseID, T26.[Description], T26.VoucherID, T26.OrderID,		
	T26.ProjectID, T26.[Status], T26.DivisionID, T26.KindVoucherID, SUM(ISNULL(T07.ConvertedAmount,0)) ConvertedAmount,
	T26.TranMonth, T26.TranYear, T26.CreateDate, T26.CreateUserID, T26.LastModifyUserID, T26.LastModifyDate , T24.OrderNo,
	T33.WareHouseName 
FROM AT2026 T26	' + @sSQLPer+ '
	LEFT JOIN AT1202 T22 ON T22.ObjectID = T26.ObjectID AND T22.DivisionID = T26.DivisionID
	LEFT JOIN AT2004 T24 ON T24.OrderID = T26.OrderID AND T24.DivisionID = T26.DivisionID
	LEFT JOIN AT1303 T33 ON T33.WareHouseID = T26.WarehouseID AND T33.DivisionID = T26.DivisionID
	LEFT JOIN AT1103 T13 ON T13.EmployeeID = T26.EmployeeID AND T13.DivisionID = T26.DivisionID
	LEFT JOIN AT2007 T07 ON T07.VoucherID = T26.VoucherID AND T07.DivisionID = T26.DivisionID
WHERE T26.DivisionID = '''+@DivisionID+''' 
	AND T26.TranMonth = '+STR(@TranMonth)+'
	AND	T26.TranYear = '+STR(@TranYear)+' '+ @sWHEREPer+'
GROUP BY T26.VoucherTypeID, T26.VoucherNo, T26.VoucherDate, T26.RefNo01, T26.RefNo02, T26.ObjectID, T22.ObjectName, T26.EmployeeID,
	T13.FullName, T26.WareHouseID, T26.[Description], T26.VoucherID, T26.OrderID, T26.ProjectID, T26.[Status], T26.DivisionID,
	T26.TranMonth, T26.TranYear, T26.KindVoucherID, T26.CreateDate, T26.CreateUserID, T26.LastModifyUserID, T26.LastModifyDate ,
	T24.OrderNo, T33.WareHouseName 
)A
WHERE (ISNULL(VoucherTypeID, ''#'') IN ('+@ConditionVT+ ') OR '+@IsUsedConditionVT+')
AND (ISNULL(ObjectIDPermission, ''#'') IN ('+@ConditionOB+') OR '+@IsUsedConditionOB+')
AND (ISNULL(WareHouseID, ''#'') IN ('+@ConditionWA+') OR '+@IsUsedConditionWA+')'
		
EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
