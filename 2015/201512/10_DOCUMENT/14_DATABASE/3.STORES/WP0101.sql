IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0101]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0101]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Loc màn hình danh muc phieu chenh lech
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 05/06/2014 by Le Thi Thu Hien
---- Modified on 10/08/2015 by Hoàng Vũ : Bổ sung phần xem dữ liệu người dùng 
---- 
-- <Example>
/*
	exec WP0101 @DivisionID=N'AS',@UserID=N'NV003',@TranMonth=1,@TranYear=2014,@FromDate='2015-08-10 14:42:27.693',@ToDate='2015-08-10 14:42:27.690',@WareHouseID=N'%'
*/
---- 
CREATE PROCEDURE WP0101
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@FromDate AS DATETIME,
		@ToDate AS DATETIME,
		@WareHouseID AS NVARCHAR(50)
) 
AS 

DECLARE @sSQL AS NVARCHAR(MAX)
		----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
		DECLARE @sSQLPer AS NVARCHAR(MAX),
				@sWHEREPer AS NVARCHAR(MAX)
		SET @sSQLPer = ''
		SET @sWHEREPer = ''		

		IF EXISTS (SELECT TOP 1 1 FROM WT0000 WHERE DefDivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
			BEGIN
				SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = W.DivisionID 
													AND AT0010.AdminUserID = '''+@UserID+''' 
													AND AT0010.UserID = W.CreateUserID '
				SET @sWHEREPer = ' AND (W.CreateUserID = AT0010.UserID
										OR  W.CreateUserID = '''+@UserID+''') '		
			END

		-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		
SET @sSQL = N'
SELECT VoucherTypeID,
VoucherDate,
VoucherID,
VoucherNo,
EmployeeID,
RefNo01,
RefNo02,
WareHouseID,
CASE WHEN IsKind = 0 THEN N''Tăng'' ELSE N''Giảm'' END AS IsKind,
[Description],
TableID,
CreateDate,
CreateUserID,
LastModifyUserID,
LastModifyDate

FROM WT0101 W ' + @sSQLPer+ '
WHERE W.DivisionID = '''+@DivisionID+'''
AND W.TranMonth = ' + convert(nvarchar(2),@TranMonth) + ' AND W.TranYear = ' + convert(nvarchar(4),@TranYear)+'
AND CONVERT(VARCHAR(10),W.VoucherDate,112) BETWEEN '+CONVERT(VARCHAR(10),@FromDate,112)+' AND '+CONVERT(VARCHAR(10),@ToDate,112)+'
AND W.WareHouseID LIKE '''+@WareHouseID+''''+ @sWHEREPer+'
'

PRINT(@sSQL)
EXEC(@sSQL)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

