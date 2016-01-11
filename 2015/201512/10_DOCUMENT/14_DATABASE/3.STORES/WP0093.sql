IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0093]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0093]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- In nhat ky xuat nhap ton kho va van chuyen noi bo
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: Khanh Van	Date: 26/08/2013
---- Modified by Thanh Sơn on 16/07/2014: lấy dữ liệu trực tiếp từ store (không sinh ra view WV0093)
-- <Example>
/*
    EXEC WP0093 @DivisionID=N'KC',@FromDate='2014-06-01 13:30:32',@ToDate='2014-06-30 13:30:32',@FromWareHouseID=N'A3001001-KC12-07',
		@ToWareHouseID=N'WH-W02',@FromInventoryID=N'BBDE0002',@ToInventoryID=N'TPXTN008',@IsMode=0
*/

CREATE PROCEDURE WP0093
(
    @DivisionID NVARCHAR(50),
    @FromDate DATETIME,
    @ToDate DATETIME,
    @FromWareHouseID NVARCHAR(50),
    @ToWareHouseID NVARCHAR(50),
    @FromInventoryID NVARCHAR(50),
    @ToInventoryID NVARCHAR(50),
    @IsMode TINYINT --0: Nhập kho; 1: Xuất kho; 2: Vận chuyển nội bộ
)
AS

DECLARE
	@sSQL AS nvarchar(4000),
	@sSQL1 AS nvarchar(4000),
	@sSQL2 AS nvarchar(4000),
	@sSQL3 AS nvarchar(4000),
	@sSQL4 AS nvarchar(4000),
	@sSQLUnion AS nvarchar(4000) ,
	@FromDateText NVARCHAR(20), 
	@ToDateText NVARCHAR(20)
    
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'
Set @sSQLUnion = ''

IF @IsMode = 0 -- Nhật ký nhập hàng
	BEGIN
		SET @sSQL = '
SELECT AV7000.DivisionID, AV7000.VoucherDate, AV7000.VoucherNo, AV7000.ObjectID,AV7000.ObjectName, 
	AV7000.InventoryID,AV7000.InventoryName, AV7000.Parameter01, AV7000.Parameter02, AV7000.Parameter03,
	AV7000.Parameter04, AV7000.Parameter05, AV7000.WareHouseID,	AV7000.WareHouseName, AV7000.UnitID,
	AV7000.UnitName, AV7000.Specification, AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04,
	AV7000.Notes05, AV7000.Notes06, AV7000.Notes07, AV7000.Notes08, AV7000.Notes09, AV7000.Notes10,
	AV7000.Notes11, AV7000.Notes12, AV7000.Notes13, AV7000.Notes14, AV7000.Notes15, AV7000.SourceNo,
	SUM(ISNULL(AV7000.ActualQuantity,0)) ActualQuantity,
	SUM(ISNULL(AV7000.ConvertedQuantity,0)) ConvertedQuantity,
	SUM(ISNULL(AV7000.MarkQuantity,0)) MarkQuantity,
	SUM(ISNULL(AV7000.ConvertedAmount,0)) ConvertedAmount
FROM AV7000	
WHERE AV7000.DivisionID =''' + @DivisionID + '''
AND AV7000.KindVoucherID = 0
AND (AV7000.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''')
AND (AV7000.WareHouseID BETWEEN N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')
AND D_C in (''D'') and (AV7000.VoucherDate  BETWEEN  ''' + @FromDateText + '''  AND ''' + @ToDateText + '''  )
AND VoucherID IN (SELECT VoucherID FROM AT9000 WHERE AV7000.DivisionID = AT9000.DivisionID AND isStock = 1) 
GROUP BY AV7000.DivisionID, AV7000.VoucherDate, AV7000.VoucherNo, AV7000.ObjectID,AV7000.ObjectName, 
		AV7000.InventoryID,AV7000.InventoryName, AV7000.Parameter01, AV7000.Parameter02, AV7000.Parameter03,
		AV7000.Parameter04, AV7000.Parameter05, AV7000.WareHouseID,	AV7000.WareHouseName, AV7000.UnitID, AV7000.UnitName,
		AV7000.Specification, AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04, AV7000.Notes05, 
		AV7000.Notes06, AV7000.Notes07, AV7000.Notes08, AV7000.Notes09, AV7000.Notes10, AV7000.Notes11, AV7000.Notes12,
		AV7000.Notes13, AV7000.Notes14, AV7000.Notes15, AV7000.SourceNo'
	END
ELSE
	BEGIN
		IF @IsMode = 1 -- Nhật ký xuất hàng
			BEGIN
				SET @sSQL = '
SELECT AV7000.DivisionID, AV7000.VoucherDate, AV7000.VoucherNo, AV7000.ObjectID,AV7000.ObjectName, 
	AV7000.InventoryID,AV7000.InventoryName, AV7000.Parameter01, AV7000.Parameter02, AV7000.Parameter03,
	AV7000.Parameter04, AV7000.Parameter05, AV7000.WareHouseID,	AV7000.WareHouseName, AV7000.UnitID,
	AV7000.UnitName, AV7000.Specification, AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04,
	AV7000.Notes05, AV7000.Notes06, AV7000.Notes07, AV7000.Notes08, AV7000.Notes09, AV7000.Notes10,
	AV7000.Notes11, AV7000.Notes12, AV7000.Notes13, AV7000.Notes14, AV7000.Notes15, AV7000.SourceNo,	
	AT2007.UnitPrice, SUM(ISNULL(AT2007.ActualQuantity,0)) ActualQuantity,
	SUM(ISNULL(AT2007.ConvertedQuantity,0)) ConvertedQuantity, SUM(ISNULL(AT2007.MarkQuantity,0)) MarkQuantity,
	SUM(ISNULL(AT2007.ConvertedAmount,0)) ConvertedAmount,
	(CASE WHEN SUM(ISNULL(AT07.ActualQuantity,0)) <> 0 THEN SUM(ISNULL(AT07.OExpenseConvertedAmount,0)) 
		/ SUM(ISNULL(AT07.ActualQuantity,0)) ELSE 0 END) OExpenseConvertedAmount
FROM AV7000 
	LEFT JOIN AT2007 ON AT2007.VoucherID = AV7000.VoucherID AND AT2007.DivisionID = AV7000.DivisionID AND AT2007.InventoryID = AV7000.InventoryID
		AND ISNULL(AT2007.Parameter01,0) = ISNULL(AV7000.Parameter01,0)
		AND ISNULL(AT2007.Parameter02,0) = ISNULL(AV7000.Parameter02,0) 
		AND ISNULL(AT2007.Parameter03,0) = ISNULL(AV7000.Parameter03,0) 
		AND ISNULL(AT2007.Parameter04,0) = ISNULL(AV7000.Parameter04,0)
		AND isnull(AT2007.Parameter05,0) = ISNULL(AV7000.Parameter05,0) 
 	LEFT JOIN AT2007 AT07 ON AT2007.RevoucherID = AT07.VoucherID AND AT2007.DivisionID = AT07.DivisionID AND AT2007.InventoryID = AT07.InventoryID 
		AND ISNULL(AT2007.Parameter01,0) = ISNULL(AT07.Parameter01,0)
		AND ISNULL(AT2007.Parameter02,0) = ISNULL(AT07.Parameter02,0) 
		AND ISNULL(AT2007.Parameter03,0) = ISNULL(AT07.Parameter03,0)
		AND ISNULL(AT2007.Parameter04,0) = ISNULL(AT07.Parameter04,0)
		AND ISNULL(AT2007.Parameter05,0) = ISNULL(AT07.Parameter05,0)	
WHERE AV7000.DivisionID = ''' + @DivisionID + '''
	AND AV7000.KindVoucherID = 0 
	AND (AV7000.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''')
	AND (AV7000.WareHouseID BETWEEN N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')
	AND D_C IN (''C'') AND (AV7000.VoucherDate  BETWEEN  ''' + @FromDateText + '''  AND ''' + @ToDateText + '''  )
	AND AV7000.VoucherTypeID LIKE (''B%'')
GROUP BY  AV7000.DivisionID, AV7000.VoucherDate, AV7000.VoucherNo, AV7000.ObjectID,AV7000.ObjectName, 
		AV7000.InventoryID,AV7000.InventoryName, AV7000.Parameter01, AV7000.Parameter02, AV7000.Parameter03,
		AV7000.Parameter04, AV7000.Parameter05, AV7000.WareHouseID,	AV7000.WareHouseName, AV7000.UnitID, AV7000.UnitName,
		AV7000.Specification, AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04, AV7000.Notes05, 
		AV7000.Notes06, AV7000.Notes07, AV7000.Notes08, AV7000.Notes09, AV7000.Notes10, AV7000.Notes11, AV7000.Notes12,
		AV7000.Notes13, AV7000.Notes14, AV7000.Notes15, AV7000.SourceNo, AT2007.UnitPrice '
			END
		ELSE -- VCNB
			BEGIN   
				SET @sSQL1 = '
(SELECT DivisionID, VoucherID,VoucherDate, VoucherNo, ObjectID,ObjectName, InventoryID,InventoryName, Parameter01,
	Parameter02, Parameter03, Parameter04, Parameter05, WareHouseID, UnitID, UnitName, Specification, Notes01,
	Notes02, Notes03, Notes04, Notes05, Notes06, Notes07, Notes08, Notes09, Notes10, Notes11, Notes12, Notes13,
	Notes14, Notes15, SourceNo,	SUM(ISNULL(ActualQuantity,0)) ActualQuantity, SUM(ISNULL(ConvertedQuantity,0)) ConvertedQuantity,
	SUM(ISNULL(MarkQuantity,0)) MarkQuantity, SUM(ISNULL(ConvertedAmount,0)) ConvertedAmount,
	SUM(ISNULL(OExpenseConvertedAmount,0)) OExpenseConvertedAmount
FROM AV7000 
WHERE DivisionID = ''' + @DivisionID + '''
	AND KindVoucherID = 100
	AND (InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''')
	AND (WareHouseID BETWEEN N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')
	AND D_C IN (''D'') and (VoucherDate  BETWEEN ''' + @FromDateText + '''  AND ''' + @ToDateText + '''  )
GROUP BY  DivisionID, VoucherID,VoucherDate, VoucherNo, ObjectID,ObjectName, InventoryID,InventoryName, Parameter01,
	Parameter02, Parameter03, Parameter04, Parameter05, WareHouseID, UnitID, UnitName, Specification, Notes01, Notes02,
	Notes03, Notes04, Notes05, Notes06, Notes07, Notes08, Notes09, Notes10, Notes11, Notes12, Notes13, Notes14, Notes15, SourceNo)A  '

				SET @sSQL2 = '
(SELECT DivisionID, VoucherID, VoucherDate, VoucherNo, ObjectID, ObjectName, InventoryID,InventoryName, Parameter01, Parameter02,
	Parameter03, Parameter04, Parameter05, WareHouseID,	WareHouseName, UnitID, UnitName, Specification, Notes01, Notes02, Notes03,
	Notes04, Notes05, Notes06, Notes07, Notes08, Notes09, Notes10, Notes11, Notes12, Notes13, Notes14, Notes15, SourceNo,	
	SUM(ISNULL(ActualQuantity,0)) ActualQuantity, SUM(ISNULL(ConvertedQuantity,0)) ConvertedQuantity,
	SUM(ISNULL(MarkQuantity,0)) MarkQuantity, SUM(ISNULL(ConvertedAmount,0)) ConvertedAmount,
	SUM(ISNULL(OExpenseConvertedAmount,0)) OExpenseConvertedAmount
FROM AV7000 
WHERE DivisionID = ''' + @DivisionID + '''
	AND KindVoucherID = 100 
	AND (InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''')
	AND (WareHouseID BETWEEN N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')
	AND D_C IN (''C'') AND (VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''')
GROUP BY  DivisionID, VoucherID,VoucherDate, VoucherNo, ObjectID,ObjectName, InventoryID,InventoryName,
	Parameter01, Parameter02, Parameter03, Parameter04, Parameter05, WareHouseID, WareHouseName, UnitID, UnitName,
	Specification, Notes01, Notes02, Notes03, Notes04, Notes05, Notes06, Notes07, Notes08, Notes09, Notes10,
	Notes11, Notes12, Notes13, Notes14, Notes15, SourceNo)B'
	
				SET @sSQL3 = '
(SELECT	DivisionID, VoucherID, VoucherDate, VoucherNo, ObjectID,ObjectName, InventoryID, InventoryName, Parameter01,
	Parameter02, Parameter03, Parameter04, Parameter05, WareHouseID, WareHouseName,	UnitID, UnitName, Specification,
	Notes01, Notes02, Notes03, Notes04, Notes05, Notes06, Notes07, Notes08, Notes09, Notes10, Notes11, Notes12, Notes13,
	Notes14, Notes15, SourceNo,	SUM(ISNULL(ActualQuantity,0)) ActualQuantity, SUM(ISNULL(ConvertedQuantity,0)) ConvertedQuantity,
	SUM(ISNULL(MarkQuantity,0)) MarkQuantity, SUM(ISNULL(ConvertedAmount,0)) ConvertedAmount,
	SUM(ISNULL(OExpenseConvertedAmount,0)) OExpenseConvertedAmount
FROM AV7000 
WHERE DivisionID =''' + @DivisionID + '''
	AND KindVoucherID = 0
	AND (InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''')
	AND (WareHouseID BETWEEN N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')
	AND D_C IN (''D'') AND (VoucherDate  BETWEEN ''' + @FromDateText + '''  AND ''' + @ToDateText + '''  )
GROUP BY  DivisionID, VoucherID, VoucherDate, VoucherNo, ObjectID,ObjectName, InventoryID,InventoryName,
	Parameter01, Parameter02, Parameter03, Parameter04, Parameter05, WareHouseID, WareHouseName, UnitID,
	UnitName, Specification, Notes01, Notes02, Notes03, Notes04, Notes05, Notes06, Notes07, Notes08, Notes09,
	Notes10, Notes11, Notes12, Notes13, Notes14, Notes15, SourceNo )C'	

				SET @sSQL4 = '
(SELECT T06.DivisionID, T061.VoucherID, T06.WareHouseID 
FROM AT2006 T06 
	INNER JOIN AT2006 T061 on T06.DivisionID = T061.DivisionID AND T06.VoucherID = T061.EVoucherID
WHERE T06.DivisionID = ''' + @DivisionID + '''
AND (T06.VoucherDate BETWEEN ''' + @FromDateText + ''' and ''' + @ToDateText + '''  ))D'

				SET @sSQL = '
SELECT 	A.DivisionID, A.VoucherDate, A.VoucherNo, A.ObjectID,A.ObjectName, A.InventoryID,A.InventoryName,
	A.Parameter01, A.Parameter02, A.Parameter03, A.Parameter04, A.Parameter05, A.WareHouseID FromWareHouseID,
	A.UnitID, A.UnitName, A.Specification, A.Notes01, A.Notes02, A.Notes03, A.Notes04, A.Notes05, A.Notes06,
	A.Notes07, A.Notes08, A.Notes09, A.Notes10, A.Notes11, A.Notes12, A.Notes13, A.Notes14, A.Notes15, A.SourceNo,	
	A.ActualQuantity,A.ConvertedQuantity,A.MarkQuantity,A.ConvertedAmount, B.WareHouseID ToWareHouseID, A.OExpenseConvertedAmount
FROM '+@sSQL1+' 
	INNER JOIN '+@sSQL2+' on A.DivisionID = B.DivisionID 
	AND A.VoucherID = B.VoucherID and A.InventoryID = B.InventoryID and A.Parameter01 = B.Parameter01
	AND A.Parameter02 = B.Parameter02 and A.Parameter03 = B.Parameter03
	AND A.Parameter04 = B.Parameter04 and A.Parameter05 = B.Parameter05'
	
				SET @sSQLUnion = '
UNION ALL 
SELECT C.DivisionID, C.VoucherDate, C.VoucherNo, C.ObjectID,C.ObjectName, C.InventoryID,C.InventoryName, C.Parameter01,
	C.Parameter02, C.Parameter03, C.Parameter04, C.Parameter05, D.WareHouseID FromWareHouseID, C.UnitID, C.UnitName,
	C.Specification, C.Notes01, C.Notes02, C.Notes03, C.Notes04, C.Notes05, C.Notes06, C.Notes07, C.Notes08, 
	C.Notes09, C.Notes10, C.Notes11, C.Notes12, C.Notes13, C.Notes14, C.Notes15, C.SourceNo, C.ActualQuantity,
	C.ConvertedQuantity,C.MarkQuantity,C.ConvertedAmount, C.WareHouseID as ToWareHouseID, C.OExpenseConvertedAmount
FROM '+@sSQL3+' 
	INNER JOIN '+@sSQL4+' on C.DivisionID = D.DivisionID and C.VoucherID = D.VoucherID AND C.VoucherID = D.VoucherID'
			END
	END

EXEC (@sSQL)

--IF NOT EXISTS ( SELECT	1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'WV0093' )
--	   BEGIN
--			 EXEC ( ' Create view WV0093 --WP0093
--			 as '+@sSQL+@sSQLUnion)
--	   END
--	ELSE
--	   BEGIN
--			 EXEC ( ' Alter view WV0093 --WP0093
--			 as  '+@sSQL+@sSQLUnion)
--	   END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

