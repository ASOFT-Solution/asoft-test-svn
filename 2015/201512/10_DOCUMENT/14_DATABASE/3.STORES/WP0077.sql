IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0077]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP0077]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- <Summary>
---- Truy vấn tồn kho theo mã vạch
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 08/02/2012 by Le Thi Thu Hien
---- 
---- Modified on 21/02/2012 by Lê Thị Thu Hiền
---- Modified on 10/08/2015 by hoàng vũ: BỔ sung phân quyền xem dữ liệu của người khác
/* <Example> 

	exec WP0077 @DivisionID=N'AS',@UserID=N'NV003',@IsDate=1,@FromMonth=8,@FromYear=2015,@ToMonth=8,@ToYear=2015,@FromDate='2015-08-01 00:00:00',@ToDate='2015-08-31 00:00:00',@WareHouseID=N'%',@Barcode=N'%'

*/
---- 
CREATE PROCEDURE [dbo].[WP0077]
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@IsDate AS TINYINT,
		@FromMonth AS INT,
		@FromYear AS INT,
		@ToMonth AS INT,
		@ToYear AS INT,
		@FromDate AS DATETIME,
		@ToDate AS DATETIME,
		@WareHouseID AS NVARCHAR(50),
		@Barcode AS NVARCHAR(50)
		
) 
AS 
Declare 	@sSQl1 AS nvarchar(4000),
			@sSQl2 AS nvarchar(4000),
			@sSQl3 AS nvarchar(4000),
			@sSQl4 AS nvarchar(4000),
		 	@WareHouseName AS nvarchar(250),
			@KindVoucherListIm AS nvarchar(200),
			@KindVoucherListEx1 AS nvarchar(200),
			@KindVoucherListEx2 AS nvarchar(200)
			----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
		DECLARE @sSQLPer AS NVARCHAR(MAX),
				@sWHEREPer AS NVARCHAR(MAX)
		SET @sSQLPer = ''
		SET @sWHEREPer = ''		

		IF EXISTS (SELECT TOP 1 1 FROM WT0000 WHERE DefDivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
			BEGIN
				SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = At2006.DivisionID 
													AND AT0010.AdminUserID = '''+@UserID+''' 
													AND AT0010.UserID = At2006.CreateUserID '
				SET @sWHEREPer = ' AND (At2006.CreateUserID = AT0010.UserID
										OR  At2006.CreateUserID = '''+@UserID+''') '		
			END

		-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		

	Select @WareHouseName =   WareHouseName From AT1303 Where WareHouseID =@WareHouseID 

	Set @KindVoucherListEx1 ='(2,4,3, 6,8,10 ,14,20) '
	Set @KindVoucherListEx2 ='(2,4,6,8,10 ,14,20) '
	Set @KindVoucherListIm ='(1,3,5,7,9,15,17) '
	

--------  Lay so du dau
if @isDate = 0 
BEGIN
Set @Ssql1 =N'
SELECT 	AT2008.InventoryID, AT1302.InventoryName,AT1302.Barcode,
		AT1302.UnitID,	AT1304.UnitName,
		AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,
		sum(BeginQuantity) AS BeginQuantity,
		sum(EndQuantity) AS EndQuantity,
		sum(BeginAmount)  AS BeginAmount,
		sum(EndAmount)  AS EndAmount, AT2008.DivisionID,
		AT2008.WareHouseID'
	
Set @Ssql2 =N'
FROM AT2008 	
INNER JOIN AT1302 on AT1302.InventoryID = AT2008.InventoryID AND AT1302.DivisionID = AT2008.DivisionID
INNER JOIN AT1304 on AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = AT2008.DivisionID
WHERE 	AT1302.Barcode LIKE '''+@Barcode+''' AND
		AT2008.WareHouseID like  N'''+@WareHouseID+''' AND 
		TranMonth + TranYear*100 = '+str(@FromMonth)+' + 100*'+str(@FromYear)+' 
GROUP BY	AT2008.InventoryID,	AT1302.InventoryName,  AT1302.UnitID,	AT1304.UnitName,
			AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, AT2008.DivisionID,
			AT2008.WareHouseID,AT1302.Barcode
HAVING  sum(BeginQuantity) <> 0 or sum(EndQuantity) <> 0 
 '
 END
Else
BEGIN
Set @Ssql1 =N' 
SELECT	InventoryID, InventoryName,AV7000.Barcode,
		UnitID, UnitName,
		Specification, Notes01, Notes02, Notes03,
		Sum(SignQuantity)  AS BeginQuantity,
		Sum(SignAmount)  AS BeginAmount,
		0 AS EndQuantity,
		0 AS EndAmount, DivisionID,
		AV7000.WareHouseID'
	
Set @Ssql2 =N'
FROM	AV7000
WHERE 	DivisionID LIKE '''+@DivisionID+''' AND
		(  (D_C in (''D'', ''C'')  AND CONVERT(DATETIME,CONVERT(nvarchar(10),VoucherDate,101),101) < '''+Convert(nvarchar(10),@FromDate,101)+''') Or D_C =''BD'' ) 
		and	WareHouseID like N'''+@WareHouseID+''' AND 
		AV7000.Barcode LIKE N'''+@Barcode+''' 
GROUP BY InventoryID, InventoryName, UnitID, UnitName, Specification, 
			Notes01, Notes02, Notes03, DivisionID, AV7000.WareHouseID,AV7000.Barcode
HAVING Sum(SignQuantity)<>0 or Sum(SignAmount)<>0   '

END

--PRINT(@sSQL1+@sSQL2)

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='WV0078')
	EXEC('CREATE VIEW WV0078 AS  -- Create by WP0077
	'+@sSQL1+@sSQL2)
ELSE
	EXEC('ALTER VIEW WV0078 AS  -- Create by WP0077
	'+@sSQL1+@sSQL2)
---- Lay so phat sinh	

If @IsDate = 0 
BEGIN
--- Phan Nhap kho
Set @sSQl1 =N'
SELECT 	AT2007.VoucherID,
		''T05'' AS TransactionTypeID,
		AT2007.TransactionID,
		AT2007.Orders,
		VoucherDate,
		VoucherNo,	
		VoucherDate AS ImVoucherDate,
		VoucherNo AS ImVoucherNo,		
		SourceNo AS ImSourceNo,
		LimitDate AS ImLimitDate,	
 		WareHouseID AS ImWareHouseID,		
		AT2007.ActualQuantity AS ImQuantity,
		AT2007.UnitPrice AS ImUnitPrice ,
		AT2007.ConvertedAmount AS ImConvertedAmount,
		AT2007.OriginalAmount AS ImOriginalAmount,
		isnull(AT2007.ConversionFactor ,1)*ActualQuantity AS ImConvertedQuantity,
		Null AS ExVoucherDate,
		Null AS ExVoucherNo,		
		Null AS ExSourceNo,
		Null AS ExLimitDate,	
 		Null AS ExWareHouseID,		
		Null AS ExQuantity,
		Null AS ExUnitPrice ,
		Null AS ExConvertedAmount,
		Null AS ExOriginalAmount,
		Null AS ExConvertedQuantity,
		VoucherTypeID,
		AT2006.Description,
		AT2007.Notes,
		AT2007.InventoryID,	
		AT1302.InventoryName,
		AT1302.Barcode,
		AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,

		AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,

		AT2007.UnitID,
		AT1304.UnitName,
		isnull(AT2007.ConversionFactor ,1) AS ConversionFactor, 
		AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID, AT2006.CreateUserID'

Set @sSQl2 =N'
FROM AT2007 	
INNER JOIN AT1302 on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
LEFT JOIN AT1304 on AT1304.UnitID = AT2007.UnitID AND AT1304.DivisionID = AT2007.DivisionID
INNER JOIN AT2006 on At2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
LEFT JOIN AT1202 on AT2006.ObjectID = AT1202.ObjectID AND AT1202.DivisionID = AT2007.DivisionID
' + @sSQLPer+ '
WHERE	AT2007.DivisionID ='''+@DivisionID+''' AND
	(AT2007.TranMonth + AT2007.TranYear*100 between ('+str(@FromMonth)+' + '+str(@FromYear)+' *100) AND  ('+str(@ToMonth)+' + '+str(@ToYear)+' *100) )  AND
	KindVoucherID in ' + @KindVoucherListIm + ' AND
	(AT1302.Barcode LIKE N'''+@Barcode+''') AND
	WareHouseID like N'''+@WareHouseID+''''+ @sWHEREPer+'

Union

--- Phan Xuat kho'

Set @sSQl3 =N'
Select 	
	AT2007.VoucherID,
	''T06'' AS TransactionTypeID,
	AT2007.TransactionID,
	AT2007.Orders,
	VoucherDate,
	VoucherNo,	
	Null AS ImVoucherDate,
	Null AS ImVoucherNo,		
	Null AS ImSourceNo,
	Null AS ImLimitDate,	
 	Null AS ExWareHouseID,	
	Null AS ImQuantity,
	Null AS ImUnitPrice ,
	Null AS ImConvertedAmount,
	Null AS ImOriginalAmount,
	Null AS ImConvertedQuantity,
	VoucherDate AS ExVoucherDate,
	VoucherNo AS ExVoucherNo,		
	SourceNo AS ExSourceNo,
	LimitDate AS ExLimitDate,	
 	(Case when KindVoucherID = 3 then WareHouseID2 else WareHouseID end) AS ExWareHouseID,	
	AT2007.ActualQuantity AS ExQuantity,
	AT2007.UnitPrice AS ExUnitPrice ,
	AT2007.ConvertedAmount AS ExConvertedAmount,
	AT2007.OriginalAmount AS ExOriginalAmount,
	isnull(AT2007.ConversionFactor ,1)*ActualQuantity AS ExConvertedQuantity,
	VoucherTypeID,
	AT2006.Description,
	AT2007.Notes,
	AT2007.InventoryID,	
	AT1302.InventoryName,
	AT1302.Barcode,
	AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,

	AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,

	AT2007.UnitID,		
	AT1304.UnitName,
	isnull(AT2007.ConversionFactor ,1) AS ConversionFactor, AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID,AT2006.CreateUserID '
	
Set @sSQl4 =N'
From AT2007 	
INNER JOIN AT1302 on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
LEFT JOIN AT1304 on AT1304.UnitID = AT2007.UnitID AND AT1304.DivisionID = AT2007.DivisionID
INNER JOIN AT2006 on At2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
LEFT JOIN AT1202 on AT2006.ObjectID = AT1202.ObjectID AND AT1202.DivisionID = AT2007.DivisionID
' + @sSQLPer+ '
Where	AT2007.DivisionID ='''+@DivisionID+ ''' AND
	(AT2007.TranMonth + AT2007.TranYear*100 between ('+str(@FromMonth)+' + '+str(@FromYear)+' *100) AND  ('+str(@ToMonth)+' + '+str(@ToYear)+' *100) )  AND
	(AT1302.Barcode Like '''+@Barcode+''' ) AND
	(KindVoucherID in ' + @KindVoucherListEx1 + ' ) AND 
	( (KindVoucherID  in ' + @KindVoucherListEx2 + ' AND WareHouseID like'''+ @WareHouseID+''') or  (KindVoucherID = 3 AND WareHouseID2 like '''+@WareHouseID+''')) '+ @sWHEREPer+''
	

END
Else
BEGIN
Set @sSQl1 =N'
--- Phan Nhap kho
Select 	AT2007.VoucherID,
	''T05'' AS TransactionTypeID,
	AT2007.TransactionID,
	AT2007.Orders,
	VoucherDate,
	VoucherNo,	
	VoucherDate AS ImVoucherDate,
	VoucherNo AS ImVoucherNo,		
	SourceNo AS ImSourceNo,
	LimitDate AS ImLimitDate,	
 	WareHouseID AS ImWareHouseID,		
	AT2007.ActualQuantity AS ImQuantity,
	AT2007.UnitPrice AS ImUnitPrice ,
	AT2007.ConvertedAmount AS ImConvertedAmount,
	AT2007.OriginalAmount AS ImOriginalAmount,
	isnull(AT2007.ConversionFactor ,1)*ActualQuantity AS ImConvertedQuantity,
	Null AS ExVoucherDate,
	Null AS ExVoucherNo,		
	Null AS ExSourceNo,
	Null AS ExLimitDate,	
 	Null AS ExWareHouseID,		
	Null AS ExQuantity,
	Null AS ExUnitPrice ,
	Null AS ExConvertedAmount,
	Null AS ExOriginalAmount,
	Null AS ExConvertedQuantity,
	VoucherTypeID,
	AT2006.Description,
	AT2007.Notes,
	AT2007.InventoryID,	
	AT1302.InventoryName,
	AT1302.Barcode,
	AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,

	AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,

	AT2007.UnitID,		

	AT1304.UnitName,
	isnull(AT2007.ConversionFactor ,1) AS ConversionFactor, AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID, AT2006.CreateUserID'
	
Set @sSQl2 =N'
FROM AT2007 	
INNER JOIN AT1302 on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
LEFT JOIN AT1304 on AT1304.UnitID = AT2007.UnitID AND AT1304.DivisionID = AT2007.DivisionID
INNER JOIN AT2006 on At2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
LEFT JOIN AT1202 on AT2006.ObjectID = AT1202.ObjectID AND AT1202.DivisionID = AT2007.DivisionID
' + @sSQLPer+ '
WHERE	AT2007.DivisionID ='''+@DivisionID+''' AND
	(CONVERT(DATETIME,CONVERT(nvarchar(10),AT2006.VoucherDate,101),101) Between '''+Convert(nvarchar(10),@FromDate,101)+''' AND '''+convert(nvarchar(10), @ToDate,101)+''' ) AND
	KindVoucherID in ' + @KindVoucherListIm + ' AND
	(AT1302.Barcode LIKE N'''+@Barcode+''' ) AND
	WareHouseID like N'''+@WareHouseID+''''+ @sWHEREPer+'
	
UNION ALL'

--- Phan Xuat kho

Set @sSQl3 =N'
SELECT 	
	AT2007.VoucherID,
	''T06'' AS TransactionTypeID,
	AT2007.TransactionID,
	AT2007.Orders,
	VoucherDate,
	VoucherNo,	
	Null AS ImVoucherDate,
	Null AS ImVoucherNo,		
	Null AS ImSourceNo,
	Null AS ImLimitDate,	
 	Null AS ExWareHouseID,	
	Null AS ImQuantity,
	Null AS ImUnitPrice ,
	Null AS ImConvertedAmount,
	Null AS ImOriginalAmount,
	Null AS ImConvertedQuantity,
	VoucherDate AS ExVoucherDate,
	VoucherNo AS ExVoucherNo,		
	SourceNo AS ExSourceNo,
	LimitDate AS ExLimitDate,	
 	(Case when KindVoucherID = 3 then WareHouseID2 else WareHouseID end) AS ExWareHouseID,	
	AT2007.ActualQuantity AS ExQuantity,
	AT2007.UnitPrice AS ExUnitPrice ,
	AT2007.ConvertedAmount AS ExConvertedAmount,
	AT2007.OriginalAmount AS ExOriginalAmount,
	isnull(AT2007.ConversionFactor ,1)*ActualQuantity AS ExConvertedQuantity,
	VoucherTypeID,
	AT2006.Description,
	AT2007.Notes,
	AT2007.InventoryID,	
	AT1302.InventoryName,
	AT1302.Barcode,
	AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,

	AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,

	AT2007.UnitID,		
	AT1304.UnitName,
	isnull(AT2007.ConversionFactor ,1) AS ConversionFactor, AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID, AT2006.CreateUserID '
	
Set @sSQl4 =N'
From AT2007 	
INNER JOIN AT1302 on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
INNER JOIN AT2006 on At2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
LEFT JOIN AT1202 on AT2006.ObjectID = AT1202.ObjectID AND AT1202.DivisionID = AT2007.DivisionID
LEFT JOIN AT1304 on AT1304.UnitID = AT2007.UnitID AND AT1304.DivisionID = AT2007.DivisionID
' + @sSQLPer+ '
WHERE	AT2007.DivisionID = '''+@DivisionID+''' AND
		(CONVERT(DATETIME,CONVERT(nvarchar(10),AT2006.VoucherDate,101),101) BETWEEN '''+Convert(nvarchar(10),@FromDate,101)+''' AND '''+convert(nvarchar(10), @ToDate,101)+''' ) AND
		(AT1302.Barcode LIKE N'''+@Barcode+''' ) AND
		(KindVoucherID in ' + @KindVoucherListEx1 + ' ) AND 
		( (KindVoucherID  in ' + @KindVoucherListEx2 + ' AND WareHouseID like'''+ @WareHouseID+''') or  (KindVoucherID = 3 AND WareHouseID2 like '''+@WareHouseID+'''))'+ @sWHEREPer+' '


END
--print 	@sSQl1+@sSQl2+@sSQl3+@sSQl4

If not Exists (Select 1 From SysObjects Where Xtype='V' AND Name ='WV0077')
	Exec('CREATE VIEW WV0077 -- Create by WP0077
	as '+@sSQL1+@sSQL2+@sSQL3+@sSQL4)
Else
	Exec('ALTER VIEW WV0077 AS  -- Create by WP0077
	'+@sSQL1+@sSQL2+@sSQL3+@sSQL4)
	
Set @sSQL1 = N'
SELECT A.*
INTO #WT0077
FROM(

SELECT 	WV0077.DivisionID,
		ISNULL(WV0077.ImWareHouseID , WV0077.ExWareHouseID) AS WareHouseID,
		WV0077.Barcode AS Barcode,
		WV0077.InventoryID AS InventoryID,	
		WV0077.InventoryName AS InventoryName,
		WV0077.Notes AS Description,
		WV0077.ExVoucherDate,
		WV0077.ExVoucherNo,	
		WV0077.ImVoucherDate,
		WV0077.ImVoucherNo,	
		NULL AS BeginQuantity,
		isnull(WV0077.ExQuantity,0) AS ExQuantity,
		isnull(WV0077.ImQuantity,0) AS ImQuantity,
		isnull(WV0077.ImQuantity,0) - isnull(WV0077.ExQuantity,0) AS EndQ,
		NULL AS EndQuantity,
		1 AS Mode
	
FROM	WV0077 
LEFT JOIN AT1303 ON AT1303.WareHouseID = ISNULL(WV0077.ImWareHouseID , WV0077.ExWareHouseID) AND AT1303.DivisionID = WV0077.DivisionID
WHERE	isnull(ImQuantity,0) <> 0 
		or isnull(ImConvertedAmount,0) <> 0 
		or isnull(ExQuantity,0) <> 0 
		or isnull(ExConvertedAmount,0) <>0 

UNION ALL
SELECT 	WV0078.DivisionID,
		WV0078.WareHouseID,
		WV0078.Barcode,
		WV0078.InventoryID,	
		WV0078.InventoryName,
		N''Đầu kỳ'' AS Description,
		NULL AS ExVoucherDate,
		NULL AS ExVoucherNo,	
		NULL AS ImVoucherDate,
		NULL AS ImVoucherNo,	
		ISNULL(WV0078.BeginQuantity,0) AS BeginQuantity,
		NULL AS ExQuantity,
		NULL AS ImQuantity,
		ISNULL(WV0078.BeginQuantity,0) AS EndQ,
		NULL AS EndQuantity,
		0 AS Mode
	
FROM	WV0078 
--WHERE	WV0078.BeginQuantity <> 0

)A
ORDER BY WareHouseID, InventoryID, Mode

INSERT INTO #WT0077
SELECT DISTINCT DivisionID, WareHouseID, Barcode, 
		InventoryID, InventoryName,
		N''Cuối kỳ'' AS Description,
		NULL AS ExVoucherDate,
		NULL AS ExVoucherNo,	
		NULL AS ImVoucherDate,
		NULL AS ImVoucherNo,	
		NULL AS BeginQuantity,
		NULL AS ExQuantity,
		NULL AS ImQuantity,
		0 AS EndQ,
		0 AS EndQuantity,
		2 AS Mode
FROM	#WT0077
'

SET @sSQl2 = N'
UPDATE A
SET A.EndQuantity = B.EndQuantity
FROM #WT0077 A
LEFT JOIN (	SELECT SUM (C.EndQ) AS EndQuantity, WareHouseID, InventoryID, DivisionID
			FROM #WT0077 C 
           	GROUP BY WareHouseID, InventoryID, DivisionID
			)B	
	ON A.WareHouseID = B.WareHouseID AND A.InventoryID = B.InventoryID AND A.DivisionID = B.DivisionID
WHERE A.Mode = 2


SELECT * FROM #WT0077 
ORDER BY WareHouseID, InventoryID, Mode
'
PRINT(@sSQL1)
PRINT(@sSQl2)
EXEC(@sSQL1 + @sSQl2)

