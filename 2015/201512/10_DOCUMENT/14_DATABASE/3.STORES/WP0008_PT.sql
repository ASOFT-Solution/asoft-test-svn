IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0008_PT]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0008_PT]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Loc ra cac phieu Nhap, xuat, VCNB de len man hinh truy van
-----Edit by: Mai Duyen, date 21/03/2014: Bo sung them 2 field InventoryID, InventoryName để tìm kiếm (Customized cho KH PrintTech)
-- <Example> exec WP0008_PT @DivisionID=N'HN',@FromDate='2014-01-01 00:00:00',@ToDate='2014-01-31 00:00:00',@ConditionVT=N'('''')',@IsUsedConditionVT=N' (0=0) ',@ConditionOB=N'('''')',@IsUsedConditionOB=N' (0=0) ',@ConditionWA=N'('''')',@IsUsedConditionWA=N' (0=0) ', 1,'AT2007.InventoryID like ''HHLY034%'''
--exec WP0008_PT @DivisionID=N'HN',@FromDate='2014-01-01 00:00:00',@ToDate='2014-01-31 00:00:00',@ConditionVT=N'('''')',@IsUsedConditionVT=N' (0=0) ',@ConditionOB=N'('''')',@IsUsedConditionOB=N' (0=0) ',@ConditionWA=N'('''')',@IsUsedConditionWA=N' (0=0) ',@IsServer= 1,@StrWhere='AT1302.InventoryName like ''HHLY034%'''

 
CREATE PROCEDURE [dbo].[WP0008_PT] 
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
	@StrWhere AS NVARCHAR(4000) = '' --Dieu kien tim kiem tren luoi :AT2007.InventoryID,AT1302.InventoryName
)
AS
	DECLARE @sSQL AS NVARCHAR(4000),
	 @sSQL1 AS NVARCHAR(4000)

SET @sSQL1 = 'SELECT * FROM (
			Select
			AT2006.VoucherTypeID,
			VoucherNo,
			VoucherDate,
			AT2006.RefNo01,
			AT2006.RefNo02,
			ConvertedAmount = (Select Sum(AT2007.ConvertedAmount) from At2007 Where voucherID = AT2006.VoucherID AND DivisionID = AT2006.DivisionID),
			AT2006.ObjectID+'' - '' + case when isnull(AT2006.VATObjectName,'''')='''' then ObjectName  else VATObjectName end as ObjectID,  
			case when isnull(AT2006.VATObjectName,'''')='''' then AT1202.ObjectName  else VATObjectName end As ObjectName,
			AT2006.ObjectID as ObjectIDPermission,
			AT2006.EmployeeID,
			(Case when KindVoucherID in (1,3,5,7,9) then AT2006.WareHouseID Else '''' End) as ImWareHouseID,
			(Case when KindVoucherID in (2,4,6,8,10)  then AT2006.WareHouseID Else 
				Case When KindVoucherID =3 then AT2006.WareHouseID2 else '''' End End) as ExWareHouseID,
			AT2006.Description,	AT2006.VoucherID, AT2006.Status,		AT2006.DivisionID,	AT2006.TranMonth,
			AT2006.TranYear, AT2006.CreateUserID, AT2006.KindVoucherID,	AT2006.EVoucherID
		From AT2006 	
			LEFT JOIN AT1202 on AT1202.DivisionID = AT2006.DivisionID AND AT1202.ObjectID = AT2006.ObjectID
		Where AT2006.DivisionID = ''' + @DivisionID + '''
			AND (AT2006.VoucherDate between ''' + convert(varchar(20),@FromDate,101) + ''' and ''' + convert(varchar(20),@ToDate,101) + ''')
		) A
		WHERE (ISNULL(VoucherTypeID, ''#'') IN (' + @ConditionVT + ') Or ' + @IsUsedConditionVT + ')
		AND (ISNULL(ObjectIDPermission, ''#'') IN (' + @ConditionOB + ') Or ' + @IsUsedConditionOB + ')
		AND (ISNULL(ImWareHouseID, ''#'') IN (' + @ConditionWA + ') Or ' + @IsUsedConditionWA + ')
		AND (ISNULL(ExWareHouseID, ''#'') IN (' + @ConditionWA + ') Or ' + @IsUsedConditionWA + ')'


	IF @IsServer = 1
		SET @sSQL = 'SELECT DISTINCT B.*
					FROM (' + @sSQL1 + ') B 
					Left join AT2007  on AT2007.DivisionID = B.DivisionID AND AT2007.VoucherID = B.VoucherID
					Left JOIN AT1302	on AT1302.DivisionID    = AT2007.DivisionID AND AT1302.InventoryID =AT2007.InventoryID
					WHERE ' + @StrWhere + ' 
					Order by VoucherTypeID, VoucherDate, VoucherNo'
	ELSE
		SET @sSQL = 'SELECT * FROM (' + @sSQL1 + ') B ' + ' 
					Order by VoucherTypeID, VoucherDate, VoucherNo'
		             


--print @sSQL
EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

