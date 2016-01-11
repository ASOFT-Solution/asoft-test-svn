IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0117]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0117]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by Van Nhan & Thuy Tuyen
---- Purpose: In ton Hop NXT theo ky cua nhung mat hang xuat theo lo
---- Date 10/06/2006
---- Edit by Nguyen Quoc Huy, Date:05/01/2007
---- Modified on 08/02/2012 by Le Thi Thu Hien : Bo sung them JOIN DivisionID
---- Modified on 16/07/2014 by Thanh Sơn: Lấy dữ liệu trực tiếp từ store, không sinh view AV0117
/********************************************
'* Edited by: [GS] [Tố Oanh] [28/07/2010]
'********************************************/

CREATE PROCEDURE 	[dbo].[AP0117]
			@DivisionID AS nvarchar(50),
			@FromWareHouseID AS nvarchar(50),
			@ToWareHouseID AS nvarchar(50),
			@FromMonth AS int,
			@FromYear AS int,
			@ToMonth AS int,
			@ToYear AS int,
			@FromInventoryID AS nvarchar(50),
			@ToInventoryID AS  nvarchar(50),
			@IsInner  AS tinyint ----- (0; khong co VCNB, 1: VCNB)
			
AS


Declare @sSQL AS nvarchar(4000),
		@KindVoucherListEx  AS nvarchar(200),
		@KindVoucherListIm  AS nvarchar(200),
		@WareHouseID1 AS nvarchar(200), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)

If @IsInner =0 
  Begin	
	Set @KindVoucherListIm ='(1,5,7,9,15,17) '
	Set @KindVoucherListEx ='(2,4,6,8,10,14,20) '
	
  End
Else
  Begin
	Set @KindVoucherListIm ='(1,3,5,7,9,15,17) '
	Set @KindVoucherListEx ='(2,3,4,6,8,10,14,20) '
	
 End

Set  @WareHouseID1 = ' Case When KindVoucherID = 3 then AT2006.WareHouseID2 else AT2006.WareHouseID end '

---Step 01:  Xac dinh so du tra ra view AV0124
	Exec AP0111 @DivisionID, @FromWareHouseID, @ToWareHouseID, @FromInventoryID, @ToInventoryID,@FromMonth, @FromYear,@ToMonth,@ToYear,@IsInner
---Step 02:  Xac dinh so phat sinh.
------ Step 02-1:  Xac dinh phat sinh nhap.
Set @sSQL =' 
SELECT AT2007.VoucherID AS ReVoucherID, AT2007.TransactionID AS ReTransactionID, AT2007.VoucherID, AT2007.TransactionID, AT2006.WareHouseID,
		AT2006.VoucherNo, AT2007.InventoryID,  AT2007.SourceNo, AT2007.UnitID, AT2007.ActualQuantity, AT2007.UnitPrice,
		AT2007.OriginalAmount, AT2007.ConvertedAmount, AT2007.DivisionID
FROM AT2007 
INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID and AT2006.DivisionID = AT2007.DivisionID
WHERE AT2006.DivisionID =''' + @DivisionID + ''' and 
		(AT2007.InventoryID like '''+@FromInventoryID+''' or 
		AT2007.InventoryID between '''+@FromInventoryID+''' and '''+@ToInventoryID+''') and
		(AT2006.WareHouseID  like '''+@FromWareHouseID+''' or 
		AT2006.WareHouseID between  '''+@FromWareHouseID+''' and  '''+@ToWareHouseID+''') and
		(AT2006.TranMonth + AT2006.TranYear*100 >= '+@FromMonthYearText+ '  
		and AT2006.TranMonth + AT2006.TranYear*100 <= '+@ToMonthYearText+ '
		)  and
		KindVoucherID in  '+ @KindVoucherListIm +'

'

If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV0118')
	Exec('Create view AV0118  -----tao boi AP0117
		as '+@sSQL)
Else
	Exec('Alter view AV0118  -----tao boi AP0117
		as '+@sSQL)

------ Step 02-2:  Xac dinh phat sinh xuat.
Set @sSQL =' 
SELECT AT2007.ReVoucherID, AT2007.ReTransactionID, AT2007.VoucherID, AT2007.TransactionID,  '+ @WareHouseID1 +' AS WareHouseID,
		AT2006.VoucherNo, AT2007.InventoryID,  AT2007.SourceNo, AT2007.UnitID, AT2007.ActualQuantity , AT2007.UnitPrice,
		 AT2007.OriginalAmount ,  AT2007.ConvertedAmount, AT2007.DivisionID
FROM AT2007 
INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID and AT2006.DivisionID = AT2007.DivisionID
WHERE	AT2006.DivisionID =''' + @DivisionID + ''' and 
		(AT2007.InventoryID like '''+@FromInventoryID+''' or 
		AT2007.InventoryID between '''+@FromInventoryID+''' and '''+@ToInventoryID+''') and
		('+@WareHouseID1+' like '''+@FromWareHouseID+''' or 
		'+@WareHouseID1+' between  '''+@FromWareHouseID+''' and  '''+@ToWareHouseID+''') and
		(AT2006.TranMonth + AT2006.TranYear*100 >= '+@FromMonthYearText+ '  
		and AT2006.TranMonth + AT2006.TranYear*100 <= '+@ToMonthYearText+ '
		)  and
		KindVoucherID in '+ @KindVoucherListEx+'

'

If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV0119')
	Exec('Create view AV0119  -----tao boi AP0117
		as '+@sSQL)
Else
	Exec('Alter view AV0119  -----tao boi AP0117
		as '+@sSQL)
------ Step 02-3:  Xac dinh phat sinh du-nhap-xuat.

Set @sSQL =' 
	Select InventoryID, WareHouseID, SourceNo, UnitID , 
		ActualQuantity AS BeginQuantity , ConvertedAmount AS BeginAmount,
		0 AS DebitQuantity , 0 AS DebitAmount,
		0 AS CreditQuantity, 0 AS CreditAmount, DivisionID 
	From 	AV0124
Union All
	Select InventoryID, WareHouseID,SourceNo, UnitID ,
		0 AS BeginQuantity , 0 AS BeginAmount,
		ActualQuantity AS DebitQuantity , ConvertedAmount AS DebitAmount,
		0 AS CreditQuantity, 0 AS CreditAmount, DivisionID
	From 	AV0118
Union All
	Select InventoryID, WareHouseID,SourceNo, UnitID, 
		0 AS BeginQuantity , 0 AS BeginAmount,
		0 AS DebitQuantity , 0 AS DebitAmount,
		ActualQuantity AS CreditQuantity, ConvertedAmount  AS CreditAmount, DivisionID
	From AV0119 

'

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV0120')
	EXEC('CREATE VIEW AV0120  -----TAO BOI AP0117
		AS '+@sSQL)
ELSE
	EXEC('ALTER VIEW AV0120  -----TAO BOI AP0117
		AS '+@sSQL)

--- Step 03:  Xac dinh du-nhap-xuat-ton.

Set @sSQL ='
SELECT	AV0120.InventoryID, WareHouseID, LTrim(RTrim(SourceNo)) AS SourceNo, AV0120.UnitID, 
		SUM(BeginQuantity) AS BeginQuantity , SUM(BeginAmount) AS BeginAmount, 
		SUM(DebitQuantity) AS DebitQuantity , SUM(DebitAmount) AS DebitAmount, 
		SUM(CreditQuantity) AS CreditQuantity ,SUM(CreditAmount) AS CreditAmount, AV0120.DivisionID  
FROM 	AV0120 
INNER JOIN AT1302 on AT1302.InventoryID = AV0120.InventoryID AND AV0120.DivisionID = AT1302.DivisionID
WHERE  AT1302.IsSource = 1
GROUP BY AV0120.InventoryID,WareHouseID, LTrim(RTrim(SourceNo)), AV0120.UnitID, AV0120.DivisionID
'
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV0121')
	EXEC('CREATE VIEW AV0121  -----TAO BOI AP0117
		AS '+@sSQL)
ELSE
	EXEC('ALTER VIEW AV0121  -----TAO BOI AP0117
		AS '+@sSQL)

Set @sSQL=' 
Select	AV0121.InventoryID, AT1302.InventoryName, AV0121.WareHouseID, AT1303.WareHouseName, AV0121.SourceNo AS ReSourceNo, AV0121.UnitID, 
		AV0121.BeginQuantity, AV0121.BeginAmount, AV0121.DebitQuantity, AV0121.DebitAmount, AV0121.CreditQuantity, AV0121.CreditAmount, AV0121.DivisionID
From	AV0121  
LEFT JOIN AT1302 on AT1302.InventoryID = AV0121.InventoryID and AT1302.DivisionID = AV0121.DivisionID
LEFT JOIN AT1303 on AT1303.WareHouseID = AV0121.WareHouseID and  AT1303.DivisionID =''' + @DivisionID + ''' and AT1303.DivisionID = AV0121.DivisionID 
Where 	AT1302.IsSource = 1 and AV0121.BeginQuantity<>0 or  AV0121.BeginAmount <>0 or AV0121.DebitQuantity <>0 
	or AV0121.DebitAmount <>0 or  AV0121.CreditQuantity <>0 or  AV0121.CreditAmount <>0 
	'
EXEC (@sSQL)
---PRINT @sSQL
--IF NOT EXISTS (SELECT 1 FROM  SYSOBJECTS WHERE XTYPE ='V' AND NAME ='AV0117')
--	EXEC(' CREATE VIEW AV0117 AS '+ @sSQL )---tao boi AP0117
--ELSE
--	EXEC(' ALTER VIEW AV0117 AS '+@sSQL) -------tao boi AP0117

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

