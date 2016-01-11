IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0111]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0111]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Purpose: So du theo mat hang theo kho, co the chon theo ngay hay theo ky (cho mat hang theo lo)
---- Created by Nguyen Quoc Huy, Date 23/12/2006
---- Edit By: Dang Le Bao Quynh; Date 16/04/2009
---- Purpose: Sua lai dieu kien khi tao view AV0122
---- Modified on 10/02/2012 by Le Thi Thu Hien : JOIN DividionID
/********************************************
'* Edited by: [GS] [Tố Oanh] [28/07/2010]
'********************************************/
CREATE PROCEDURE [dbo].[AP0111] 
				@DivisionID nvarchar(50), 
				@FromWareHouseID as nvarchar(50),
				@ToWareHouseID as nvarchar(50),
				@FromInventoryID as nvarchar(50),
				@ToInventoryID as nvarchar(50),
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,
				@IsInner  as tinyint ----- (0; khong co VCNB, 1: VCNB)

AS

Declare @sSQL as nvarchar(4000),
	@KindVoucherListEx  as nvarchar(200),
	@KindVoucherListIm  as nvarchar(200),
	@WareHouseID1 as varchar(200)
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
--Step01: Xac dinh so du ton dau AT2017

Set @sSQL ='
SELECT  AT2017.VoucherID as ReVoucherID, AT2017.TransactionID as ReTransactionID, AT2017.VoucherID, AT2017.TransactionID,AT2016.WareHouseID,
		AT2016.VoucherNo, AT2017.InventoryID,  AT2017.SourceNo, AT2017.UnitID, AT2017.ActualQuantity, AT2017.UnitPrice,
		AT2017.OriginalAmount, AT2017.ConvertedAmount, AT2017.DivisionID
FROM	AT2017 
INNER JOIN AT2016 ON AT2016.VoucherID = AT2017.VoucherID AND AT2016.DivisionID = AT2017.DivisionID
WHERE	AT2016.DivisionID =''' + @DivisionID + ''' and 
		(AT2017.InventoryID like '''+@FromInventoryID+''' or 
		 AT2017.InventoryID between '''+@FromInventoryID+''' and '''+@ToInventoryID+''') and
		(AT2016.WareHouseID like '''+@FromWareHouseID+''' or 
		 AT2016.WareHouseID between  '''+@FromWareHouseID+''' and  '''+@ToWareHouseID+''')
'
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV0111')
	EXEC('CREATE VIEW AV0111  -----TAO BOI AP0111
		AS '+@sSQL) 
ELSE
	EXEC('ALTER VIEW AV0111  -----TAO BOI AP0111
		AS '+@sSQL)

--Step02: Xac dinh so du tu thoi diem nay tro ve truoc AT2007
-- Step 021: Xac dinh cac phieu nhap
Set @sSQL =' 
SELECT	AT2007.VoucherID as ReVoucherID, AT2007.TransactionID as ReTransactionID, AT2007.VoucherID, AT2007.TransactionID, AT2006.WareHouseID,
		AT2006.VoucherNo, AT2007.InventoryID,  AT2007.SourceNo, AT2007.UnitID, AT2007.ActualQuantity, AT2007.UnitPrice,
		AT2007.OriginalAmount, AT2007.ConvertedAmount, AT2007.DivisionID
FROM AT2007 
INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
	         WHERE AT2006.DivisionID =''' + @DivisionID + ''' and 
			(AT2007.InventoryID like '''+@FromInventoryID+''' or 
			 AT2007.InventoryID between '''+@FromInventoryID+''' and '''+@ToInventoryID+''') and
			(AT2006.WareHouseID like '''+@FromWareHouseID+''' or AT2006.WareHouseID between  '''+@FromWareHouseID+''' and  '''+@ToWareHouseID+''') and
			(AT2006.TranMonth + AT2006.TranYear*100 < '+str(@FromMonth)+' + 100*'+str(@FromYear)+ '  
			--and AT2006.TranMonth + AT2006.TranYear*100 <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+ '
			 )  and
			KindVoucherID in '+ @KindVoucherListIm+'

'

If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV0112')
	Exec('Create view AV0112  -----tao boi AP0111
		as '+@sSQL)
Else
	Exec('Alter view AV0112  -----tao boi AP0111
		as '+@sSQL)


-- Step 022: Xac dinh cac phieu xuat
Set @sSQL =' 
SELECT	AT2007.ReVoucherID, AT2007.ReTransactionID, AT2007.VoucherID, AT2007.TransactionID, AT2006.VoucherNo, AT2007.InventoryID, '+ @WareHouseID1 +' as WareHouseID,
		AT2007.SourceNo, AT2007.UnitID, -AT2007.ActualQuantity as ActualQuantity, AT2007.UnitPrice,
		-AT2007.OriginalAmount as OriginalAmount,  -AT2007.ConvertedAmount as ConvertedAmount, AT2007.DivisionID
FROM AT2007 
INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
	         WHERE AT2006.DivisionID =''' + @DivisionID + ''' and 
			(AT2007.InventoryID like '''+@FromInventoryID+''' or 
			 AT2007.InventoryID between '''+@FromInventoryID+''' and '''+@ToInventoryID+''') and
			(' + @WareHouseID1 + ' like '''+@FromWareHouseID+''' or ' + @WareHouseID1 + ' between  '''+@FromWareHouseID+''' and  '''+@ToWareHouseID+''') and 
			(AT2006.TranMonth + AT2006.TranYear*100 < '+str(@FromMonth)+' + 100*'+str(@FromYear)+ '  
			--and AT2006.TranMonth + AT2006.TranYear*100 <= '+str(@ToMonth)+' + 100*'+str(@ToYear)+ '
			 )  and
			KindVoucherID in '+ @KindVoucherListEx+'
'

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV0122')
	EXEC('CREATE VIEW AV0122  -----TAO BOI AP0111
		AS '+@sSQL)
ELSE
	EXEC('ALTER VIEW AV0122  -----TAO BOI AP0111
		AS '+@sSQL)

-- Step 023: Xac dinh so du thuc te
Set @sSQL ='
SELECT	ReVoucherID, ReTransactionID, VoucherID, TransactionID,  WareHouseID, 
		VoucherNo, InventoryID, SourceNo, UnitID, 
		ActualQuantity, UnitPrice, OriginalAmount, ConvertedAmount, AV0111.DivisionID
FROM 	AV0111

UNION ALL

SELECT ReVoucherID, ReTransactionID, VoucherID, TransactionID, WareHouseID, VoucherNo, InventoryID, SourceNo, UnitID, 
		ActualQuantity, UnitPrice, OriginalAmount, ConvertedAmount, AV0112.DivisionID 
FROM	AV0112 

UNION ALL

SELECT	ReVoucherID, ReTransactionID, VoucherID, TransactionID, WareHouseID, VoucherNo, InventoryID, SourceNo, UnitID, 
		ActualQuantity, UnitPrice, OriginalAmount, ConvertedAmount, AV0122.DivisionID 
FROM	AV0122 

'

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV0123')
	EXEC('CREATE VIEW AV0123  -----TAO BOI AP0111
		AS '+@sSQL)
ELSE
	EXEC('ALTER VIEW AV0123  -----TAO BOI AP0111
		AS '+@sSQL)


Set @sSQL ='
SELECT	InventoryID, SourceNo, UnitID, WareHouseID,
		Sum(ActualQuantity) as ActualQuantity , Sum(OriginalAmount) as OriginalAmount, Sum(ConvertedAmount) as ConvertedAmount, DivisionID  
FROM 	AV0123 
GROUP BY InventoryID, SourceNo, UnitID,WareHouseID, DivisionID
'

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE='V' AND NAME ='AV0124')
	EXEC('CREATE VIEW AV0124  -----TAO BOI AP0111
		AS '+@sSQL)
ELSE
	EXEC('ALTER VIEW AV0124  -----TAO BOI AP0111
		AS '+@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

