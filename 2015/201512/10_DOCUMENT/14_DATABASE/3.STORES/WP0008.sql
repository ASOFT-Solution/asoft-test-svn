IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0008]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP0008]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Loc ra cac phieu Nhap, xuat, VCNB de len man hinh truy van 
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: 
---- Edit By: Mai Duyen,Date 21/03/2014: Bổ sung tham so @IsServer,@StrWhere để tìm kiếm Detail( customized cho KH PrintTech ) 
---- Modified by Thanh Sơn on 08/07/2014: Bổ sung biến @Mode để load dữ liệu theo từng loại phiếu (chia tabcontrol)
---- Modified by Hoàng Vũ on 10/08/2015: Bổ sung phần quyền xem du74lieu65 của người khác
---- Modified by Thanh Thịnh on 05/10/2015: Bổ Sung thêm trường Load dữ liệu đối với nhập kho và từ sản xuất
---- Modified by Phương Thảo on 15/10/2015: Bổ sung thêm IsVAT
-- <Example>
/*
	 exec WP0008 @DivisionID=N'AS',@FromDate='2014-05-10 00:00:00',@ToDate='2016-05-31 00:00:00',@ConditionVT=N'('''')',
	@IsUsedConditionVT=N' (0=0) ',@ConditionOB=N'('''')',@IsUsedConditionOB=N' (0=0) ',
	@ConditionWA=N'('''')',@IsUsedConditionWA=N' (0=0) ',@IsServer=0,@StrWhere=N'', @Mode = 2, @UserID = 'NV005'
*/

	
CREATE PROCEDURE [dbo].[WP0008] 
(
    @DivisionID NVARCHAR(50),
	@FromDate DATETIME,
	@ToDate DATETIME,
	@ConditionVT NVARCHAR(MAX),
	@IsUsedConditionVT NVARCHAR(20),
	@ConditionOB NVARCHAR(MAX),
	@IsUsedConditionOB NVARCHAR(20),
	@ConditionWA NVARCHAR(MAX),
	@IsUsedConditionWA NVARCHAR(20),
	@IsServer INT = 0,	--0 : Tim kiem Master -- 1 : Tim kiem Detail
	@StrWhere NVARCHAR(4000) = '',  --Dieu kien tim kiem tren luoi
	@Mode TINYINT = 1,-- 1: Nhập, 2: Xuất, 3: VCNB
	@UserID nvarchar(50)
)

AS
DECLARE @sSQL AS NVARCHAR(4000),
		@CustomerName INT,
		@sWhere NVARCHAR(2000)

		----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
		DECLARE @sSQLPer AS NVARCHAR(MAX),
				@sWHEREPer AS NVARCHAR(MAX)
		SET @sSQLPer = ''
		SET @sWHEREPer = ''		

		IF EXISTS (SELECT TOP 1 1 FROM WT0000 WHERE DefDivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
			BEGIN
				SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = A06.DivisionID 
													AND AT0010.AdminUserID = '''+@UserID+''' 
													AND AT0010.UserID = A06.CreateUserID '
				SET @sWHEREPer = ' AND (A06.CreateUserID = AT0010.UserID
										OR  A06.CreateUserID = '''+@UserID+''') '		
			END

		-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		
SET @sWhere = ''
IF @Mode = 1 SET @sWhere = 'AND A06.KindVoucherID IN (1,5,7,9)'
IF @Mode = 2 SET @sWhere = 'AND A06.KindVoucherID IN (2,4,6,8,10)'
IF @Mode = 3 SET @sWhere = 'AND A06.KindVoucherID = 3'
	
--Tao bang tam de kiem tra day co phai la khach hang PrintTech khong (CustomerName = 26)
CREATE TABLE #CustomerName (CustomerName INT, ImportExcel INT)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

IF @CustomerName = 26  --- Customize PrintTech
	EXEC WP0008_PT @DivisionID, @FromDate, @ToDate, @ConditionVT, @IsUsedConditionVT, @ConditionOB, @IsUsedConditionOB, @ConditionWA, @IsUsedConditionWA,@IsServer,@StrWhere
ELSE
	BEGIN		
		SET @sSQL = '
SELECT * , CAST(0 AS BIT) AS IsVAT
INTO #WP0008
FROM 
(
	SELECT A06.VoucherTypeID, A06.VoucherNo, A06.VoucherDate, A06.RefNo01, A06.RefNo02, SUM(A07.ConvertedAmount) ConvertedAmount,
	A06.ObjectID + '' - '' +ISNULL(A06.VATObjectName, A02.ObjectName) ObjectID, ISNULL(A06.VATObjectName, A02.ObjectName) ObjectName,
	A06.ObjectID ObjectIDPermission, A06.EmployeeID, 
	(CASE WHEN A06.KindVoucherID IN (1,3,5,7,9) THEN A06.WareHouseID ELSE '''' END) ImWareHouseID,
	(CASE WHEN A06.KindVoucherID IN (2,4,6,8,10) THEN A06.WareHouseID ELSE CASE WHEN KindVoucherID = 3 THEN A06.WareHouseID2 ELSE '''' END END) ExWareHouseID,
	A06.[Description], A06.VoucherID, A06.[Status], A06.DivisionID, A06.TranMonth, A06.TranYear, A06.CreateUserID, A06.KindVoucherID,
	A06.EVoucherID, A06.ImVoucherID '+CASE WHEN @CustomerName = 49 THEN ', ISNULL((SELECT TOP 1 1 FROM MT0810 WHERE voucherid = A06.voucherid),0) [IsM]' ELSE '' END + '
	FROM AT2006 A06
	LEFT JOIN AT1202 A02 ON A02.DivisionID = A06.DivisionID AND A02.ObjectID = A06.ObjectID
	LEFT JOIN AT2007 A07 ON A07.DivisionID = A06.DivisionID AND A07.VoucherID = A06.VoucherID
	' + @sSQLPer+ '
	WHERE A06.DivisionID = '''+@DivisionID+'''
	AND (A06.VoucherDate BETWEEN ''' + CONVERT(VARCHAR, @FromDate,111) + ''' AND ''' + CONVERT(VARCHAR, @ToDate,111) + ''')
	'+@sWhere+''+ @sWHEREPer+'
	GROUP BY A06.VoucherTypeID, A06.VoucherNo, A06.VoucherDate, A06.RefNo01, A06.RefNo02, A06.ObjectID, A06.VATObjectName,
	A02.ObjectName, A06.ObjectID, A06.EmployeeID, A06.KindVoucherID, A06.WareHouseID, A06.WareHouseID2,
	A06.[Description], A06.VoucherID, A06.[Status], A06.DivisionID, A06.TranMonth, A06.TranYear, A06.CreateUserID, A06.KindVoucherID,
	A06.EVoucherID, A06.ImVoucherID
)A
WHERE (ISNULL(VoucherTypeID, ''#'') IN (' + @ConditionVT + ') OR ' + @IsUsedConditionVT + ')
AND (ISNULL(ObjectIDPermission, ''#'') IN (' + @ConditionOB + ') OR ' + @IsUsedConditionOB + ')
AND (ISNULL(ImWareHouseID, ''#'') IN (' + @ConditionWA + ') OR ' + @IsUsedConditionWA + ')
AND (ISNULL(ExWareHouseID, ''#'') IN (' + @ConditionWA + ') OR ' + @IsUsedConditionWA + ')
ORDER BY VoucherTypeID, VoucherDate, VoucherNo

UPDATE #WP0008
SET		ISVAT = 1
WHERE  EXISTS (SELECT 1 FROM AT9000 WITH (NOLOCK) WHERE DivisionID = '''+@DivisionID+'''
														AND #WP0008.VoucherID = AT9000.VoucherID
														AND TransactionTypeID = ''T14'')

SELECT * FROM #WP0008 ORDER BY VoucherTypeID, VoucherDate, VoucherNo
DROP TABLE #WP0008
'
	EXEC(@sSQL)
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
