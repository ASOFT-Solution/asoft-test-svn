IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP00941]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP00941]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Exec WP00941 'sth', '','',1,2013,2,2013,0
CREATE PROCEDURE [dbo].[WP00941] 
(
    @DivisionID NVARCHAR(50),
	@FromDate datetime,
	@ToDate datetime,
	@FromMonth int,
	@FromYear int,
	@ToMonth int,
	@ToYear int,
	@IsDate tinyint
)
AS
	DECLARE @sSQL AS NVARCHAR(4000),
	 @sSQL0 AS NVARCHAR(4000),
	 @sSQL1 AS NVARCHAR(4000),
	 @sSQL2 AS NVARCHAR(4000)
--- Load Master
If @IsDate =1
Begin
SET @sSQL = 'SELECT * FROM (
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
	AT2006.WareHouseID,
	AT2006.Description,	AT2006.VoucherID, AT2006.Status,		AT2006.DivisionID,	AT2006.TranMonth,
	AT2006.TranYear, AT2006.CreateUserID, AT2006.KindVoucherID,	AT2006.EVoucherID

From AT2006 	
    LEFT JOIN AT1202 on AT1202.DivisionID = AT2006.DivisionID AND AT1202.ObjectID = AT2006.ObjectID

Where AT2006.DivisionID = ''' + @DivisionID + '''
	AND (AT2006.VoucherDate between ''' + convert(varchar(20),@FromDate,101) + ''' and ''' + convert(varchar(20),@ToDate,101) + ''') and KindVoucherID in (2,4,3,6,8,10) 
) A

Order by VoucherTypeID, VoucherDate, VoucherNo'
End
Else
Begin
SET @sSQL = 'SELECT * FROM (
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
	AT2006.WareHouseID ,
	AT2006.Description,	AT2006.VoucherID, AT2006.Status,		AT2006.DivisionID,	AT2006.TranMonth,
	AT2006.TranYear, AT2006.CreateUserID, AT2006.KindVoucherID,	AT2006.EVoucherID

From AT2006 	
    LEFT JOIN AT1202 on AT1202.DivisionID = AT2006.DivisionID AND AT1202.ObjectID = AT2006.ObjectID

Where AT2006.DivisionID = ''' + @DivisionID + '''
	AND ((AT2006.TranMonth  + AT2006.TranYear*100) between (''' + STR(@FromMonth) + '''+'''+STR(@FromYear)+'''*100) and (''' + STR(@ToMonth) + '''+'''+STR(@ToYear)+'''*100) )and KindVoucherID in (2,4,3,6,8,10) 
) A

Order by VoucherTypeID, VoucherDate, VoucherNo'
End

EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
