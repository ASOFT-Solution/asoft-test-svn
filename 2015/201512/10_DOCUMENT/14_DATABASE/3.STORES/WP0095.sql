IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0095]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0095]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Loc ra cac phieu Nhap, xuat, VCNB de len man hinh truy van
---- Edit by: Hoàng vũ, on 10/08/2015--Bổ sung phân quyền xem dữ liệu của người khác
-- <Example> 
/*
	EXEC WP0095 @DivisionID=N'AS',@FromDate='2014-01-01 00:00:00',@ToDate='2016-01-31 00:00:00',
	@ConditionVT=N'('''')',@IsUsedConditionVT=N' (0=0) ',
	@ConditionOB=N'('''')',@IsUsedConditionOB=N' (0=0) ',
	@ConditionWA=N'('''')',@IsUsedConditionWA=N' (0=0) ',@IsServer= 0,@StrWhere='AT1302.InventoryName like ''%'''  ,
	@Mode = 1, @UserID = 'NV005'
*/
	
CREATE PROCEDURE [dbo].[WP0095] 
(
    @DivisionID NVARCHAR(50),
	@FromDate datetime,
	@ToDate datetime,
	@ConditionVT nvarchar(max),
	@IsUsedConditionVT nvarchar(20),
	@ConditionOB nvarchar(max),
	@IsUsedConditionOB nvarchar(20),
	@ConditionWA nvarchar(max),
	@IsUsedConditionWA nvarchar(20),
	@IsServer AS INT = 0,	--0 : Tim kiem Master
							-- 1 : Tim kiem Detail
	@StrWhere AS NVARCHAR(4000) = '',  --Dieu kien tim kiem tren luoi
	@Mode TINYINT = 1,-- 1: YC Nhập, 2: YC Xuất, 3: YC VCNB
	@UserID nvarchar(50)
)
AS
DECLARE @sSQL AS NVARCHAR(4000),
		@sWhere NVARCHAR(2000),		
		@CustomerName INT

		----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
		DECLARE @sSQLPer AS NVARCHAR(MAX),
				@sWHEREPer AS NVARCHAR(MAX)
		SET @sSQLPer = ''
		SET @sWHEREPer = ''		

		IF EXISTS (SELECT TOP 1 1 FROM WT0000 WHERE DefDivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
			BEGIN
				SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = WT0095.DivisionID 
													AND AT0010.AdminUserID = '''+@UserID+''' 
													AND AT0010.UserID = WT0095.CreateUserID '
				SET @sWHEREPer = ' AND (WT0095.CreateUserID = AT0010.UserID
										OR  WT0095.CreateUserID = '''+@UserID+''') '		
			END

		-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		

SET @sWhere = ''
IF @Mode = 1 SET @sWhere = 'AND WT0095.KindVoucherID IN (1,5,7,9)'
IF @Mode = 2 SET @sWhere = 'AND WT0095.KindVoucherID IN (2,4,6,8,10)'
IF @Mode = 3 SET @sWhere = 'AND WT0095.KindVoucherID = 3'

SET @sSQL = 'SELECT * FROM (
	Select
	WT0095.VoucherTypeID,
	VoucherNo,
	VoucherDate,
	WT0095.RefNo01,
	WT0095.RefNo02,
	ConvertedAmount = (Select Sum(WT0096.ConvertedAmount) from WT0096 Where voucherID = WT0095.VoucherID AND DivisionID = WT0095.DivisionID),
	WT0095.ObjectID+'' - '' + case when isnull(WT0095.VATObjectName,'''')='''' then ObjectName  else VATObjectName end as ObjectID,  
	case when isnull(WT0095.VATObjectName,'''')='''' then AT1202.ObjectName  else VATObjectName end As ObjectName,
	WT0095.ObjectID as ObjectIDPermission,
	WT0095.EmployeeID,
	(Case when KindVoucherID in (1,3,5,7,9) then WT0095.WareHouseID Else '''' End) as ImWareHouseID,
	(Case when KindVoucherID in (2,4,6,8,10)  then WT0095.WareHouseID Else 
		Case When KindVoucherID =3 then WT0095.WareHouseID2 else '''' End End) as ExWareHouseID,
	WT0095.Description,	WT0095.VoucherID, WT0095.Status, W01.[Description] as StatusName, W01.[DescriptionE] as StatusNameE,		
	WT0095.DivisionID,	WT0095.TranMonth,
	WT0095.TranYear, WT0095.CreateUserID, WT0095.KindVoucherID,	WT0095.EVoucherID
	From WT0095 	
	LEFT JOIN AT1202 on AT1202.DivisionID = WT0095.DivisionID AND AT1202.ObjectID = WT0095.ObjectID
	LEFT JOIN WV0001 W01 ON WT0095.[Status] = W01.[Code] and W01.[TypeID] = ''Status''
	' + @sSQLPer+ '
	Where WT0095.DivisionID = ''' + @DivisionID + '''
	'+@sWhere+''+ @sWHEREPer+'
		AND (WT0095.VoucherDate between ''' + convert(varchar(20),@FromDate,101) + ''' and ''' + convert(varchar(20),@ToDate,101) + ''')
	) A
	WHERE (ISNULL(VoucherTypeID, ''#'') IN (' + @ConditionVT + ') Or ' + @IsUsedConditionVT + ')
	AND (ISNULL(ObjectIDPermission, ''#'') IN (' + @ConditionOB + ') Or ' + @IsUsedConditionOB + ')
	AND (ISNULL(ImWareHouseID, ''#'') IN (' + @ConditionWA + ') Or ' + @IsUsedConditionWA + ')
	AND (ISNULL(ExWareHouseID, ''#'') IN (' + @ConditionWA + ') Or ' + @IsUsedConditionWA + ')
	Order by VoucherTypeID, VoucherDate, VoucherNo'

	EXEC(@sSQL)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

