IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2041]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP2041]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




---- Purpose: Kiem ke mat hang theo kho
---- Created by Nguyen Quoc Huy, Date 05/01/2007
---- Edit by Mai Duyen, Date 01/10/2014: Bo sung truong hop kiem ke kho theo ngay
---- Modified by Tieu Mai on 10/11/2015: Bổ sung trường hợp có thiết lập quản lý hàng theo quy cách.

CREATE PROCEDURE 	[dbo].[AP2041] @DivisionID as nvarchar(50),
				@WareHouseID as nvarchar(50),
				@FromInventoryID as nvarchar(50),
				@ToInventoryID as nvarchar(50),
				@Month as int,
				@Year as int,
				@Date as Datetime,
				@IsDate  as tinyint 

				

AS
Declare @sSQL as nvarchar(4000),
	@KindVoucherListIm  as nvarchar(4000),
	@KindVoucherListEx  as nvarchar(4000),
	@WareHouseID1 as nvarchar(4000)

Set @KindVoucherListIm ='(1,3,5,7,9) '
Set @KindVoucherListEx ='(2,3,4,6,8,10) '
Set  @WareHouseID1 = ' Case When KindVoucherID = 3 then AT2006.WareHouseID2 else AT2006.WareHouseID end '


--Step01: Xac dinh so du ton dau AT2017
IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	Set @sSQL ='SELECT    AT2017.VoucherID as ReVoucherID, AT2017.TransactionID as ReTransactionID, AT2017.VoucherID, AT2017.TransactionID, AT2016.WareHouseID,
				AT2016.VoucherNo, AT2017.InventoryID,  AT2017.DebitAccountID,
				--AT2017.SourceNo, 
				NULL AS SourceNo, 
				ISNULL(AT2017.UnitID, AT2017.ConvertedUnitID) AS UnitID, AT2017.ActualQuantity, AT2017.UnitPrice,
				ISNULL(AT2017.OriginalAmount, 0) AS OriginalAmount, ISNULL(AT2017.ConvertedAmount, 0) AS ConvertedAmount, AT2017.DivisionID,
				WT8899.S01ID, WT8899.S02ID, WT8899.S03ID, WT8899.S04ID, WT8899.S05ID, WT8899.S06ID, WT8899.S07ID, WT8899.S08ID, WT8899.S09ID, WT8899.S10ID,
				WT8899.S11ID, WT8899.S12ID, WT8899.S13ID, WT8899.S14ID, WT8899.S15ID, WT8899.S16ID, WT8899.S17ID, WT8899.S18ID, WT8899.S19ID, WT8899.S20ID
				 FROM AT2017 INNER JOIN AT2016 ON AT2016.VoucherID = AT2017.VoucherID AND AT2016.DivisionID = AT2017.DivisionID
				 LEFT JOIN WT8899 ON WT8899.DivisionID = AT2017.DivisionID AND WT8899.VoucherID = AT2017.VoucherID AND WT8899.TransactionID = AT2017.TransactionID
				 WHERE AT2016.DivisionID =''' + @DivisionID + ''' and 
				(AT2017.InventoryID like N'''+@FromInventoryID+''' or 
				 AT2017.InventoryID between N'''+@FromInventoryID+''' and N'''+@ToInventoryID+''') and
				(AT2016.WareHouseID = N'''+@WareHouseID+''' )
				'
END
ELSE
	Set @sSQL ='SELECT    AT2017.VoucherID as ReVoucherID, AT2017.TransactionID as ReTransactionID, AT2017.VoucherID, AT2017.TransactionID, AT2016.WareHouseID,
				AT2016.VoucherNo, AT2017.InventoryID,  AT2017.DebitAccountID,
				--AT2017.SourceNo, 
				NULL AS SourceNo, 
				ISNULL(AT2017.UnitID, AT2017.ConvertedUnitID) AS UnitID, AT2017.ActualQuantity, AT2017.UnitPrice,
				ISNULL(AT2017.OriginalAmount, 0) AS OriginalAmount, ISNULL(AT2017.ConvertedAmount, 0) AS ConvertedAmount, AT2017.DivisionID
				 FROM AT2017 INNER JOIN AT2016 ON AT2016.VoucherID = AT2017.VoucherID AND AT2016.DivisionID = AT2017.DivisionID
				 WHERE AT2016.DivisionID =''' + @DivisionID + ''' and 
				(AT2017.InventoryID like N'''+@FromInventoryID+''' or 
				 AT2017.InventoryID between N'''+@FromInventoryID+''' and N'''+@ToInventoryID+''') and
				(AT2016.WareHouseID = N'''+@WareHouseID+''' )
'
If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV2141')
	Exec('Create view AV2141  -----tao boi AP2041
		as '+@sSQL) 
Else
	Exec('Alter view AV2141  -----tao boi AP2041
		as '+@sSQL)


--Step02: Xac dinh so du tu thoi diem nay tro ve truoc AT2007
-- Step 021: Xac dinh cac phieu nhap
IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	If @IsDate = 1 -- theo ky 
			Set @sSQL =' SELECT AT2007.VoucherID as ReVoucherID, AT2007.TransactionID as ReTransactionID, AT2007.VoucherID, AT2007.TransactionID, AT2006.WareHouseID,
						AT2006.VoucherNo, AT2007.InventoryID, AT2007.DebitAccountID ,
						NULL AS SourceNo, 
						ISNULL(AT2007.UnitID, AT2007.ConvertedUnitID) AS UnitID, AT2007.ActualQuantity, AT2007.UnitPrice,
						ISNULL(AT2007.OriginalAmount, 0) AS OriginalAmount, ISNULL(AT2007.ConvertedAmount, 0) AS ConvertedAmount, AT2007.DivisionID,
						WT8899.S01ID, WT8899.S02ID, WT8899.S03ID, WT8899.S04ID, WT8899.S05ID, WT8899.S06ID, WT8899.S07ID, WT8899.S08ID, WT8899.S09ID, WT8899.S10ID,
						WT8899.S11ID, WT8899.S12ID, WT8899.S13ID, WT8899.S14ID, WT8899.S15ID, WT8899.S16ID, WT8899.S17ID, WT8899.S18ID, WT8899.S19ID, WT8899.S20ID
						FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.VoucherID = AT2007.VoucherID
						LEFT JOIN WT8899 ON WT8899.DivisionID = AT2007.DivisionID AND WT8899.VoucherID = AT2007.VoucherID AND WT8899.TransactionID = AT2007.TransactionID
						WHERE AT2006.DivisionID =''' + @DivisionID + ''' and 
						(AT2007.InventoryID like N'''+@FromInventoryID+''' or 
						AT2007.InventoryID between N'''+@FromInventoryID+''' and N'''+@ToInventoryID+''') and
						(AT2006.WareHouseID = N'''+@WareHouseID+''' ) and
						(AT2006.TranMonth + AT2006.TranYear*100 <= '+str(@Month)+' + 100*'+str(@Year)+ ')  and
						KindVoucherID in '+ @KindVoucherListIm+'
						'
		Else --theo ngay
			Set @sSQL =' SELECT AT2007.VoucherID as ReVoucherID, AT2007.TransactionID as ReTransactionID, AT2007.VoucherID, AT2007.TransactionID, AT2006.WareHouseID,
						AT2006.VoucherNo, AT2007.InventoryID, AT2007.DebitAccountID ,
						NULL AS SourceNo, 
						ISNULL(AT2007.UnitID, AT2007.ConvertedUnitID) AS UnitID, AT2007.ActualQuantity, AT2007.UnitPrice,
						ISNULL(AT2007.OriginalAmount, 0) AS OriginalAmount, ISNULL(AT2007.ConvertedAmount, 0) AS ConvertedAmount, AT2007.DivisionID,
						WT8899.S01ID, WT8899.S02ID, WT8899.S03ID, WT8899.S04ID, WT8899.S05ID, WT8899.S06ID, WT8899.S07ID, WT8899.S08ID, WT8899.S09ID, WT8899.S10ID,
						WT8899.S11ID, WT8899.S12ID, WT8899.S13ID, WT8899.S14ID, WT8899.S15ID, WT8899.S16ID, WT8899.S17ID, WT8899.S18ID, WT8899.S19ID, WT8899.S20ID
						FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.VoucherID = AT2007.VoucherID
						LEFT JOIN WT8899 ON WT8899.DivisionID = AT2007.DivisionID AND WT8899.VoucherID = AT2007.VoucherID AND WT8899.TransactionID = AT2007.TransactionID
						WHERE AT2006.DivisionID =''' + @DivisionID + ''' and 
						(AT2007.InventoryID like N'''+@FromInventoryID+''' or 
						AT2007.InventoryID between N'''+@FromInventoryID+''' and N'''+@ToInventoryID+''') and
						(AT2006.WareHouseID = N'''+@WareHouseID+''' ) and
						(AT2006.VoucherDate  <= '''+Convert(Varchar(10),@Date,101)+''' )  and
						KindVoucherID in '+ @KindVoucherListIm+'
						'
END
ELSE
	BEGIN
		If @IsDate = 1 -- theo ky 
			Set @sSQL =' SELECT AT2007.VoucherID as ReVoucherID, AT2007.TransactionID as ReTransactionID, AT2007.VoucherID, AT2007.TransactionID, AT2006.WareHouseID,
			AT2006.VoucherNo, AT2007.InventoryID, AT2007.DebitAccountID ,
			 --AT2007.SourceNo, 
			NULL AS SourceNo, 
			 ISNULL(AT2007.UnitID, AT2007.ConvertedUnitID) AS UnitID, AT2007.ActualQuantity, AT2007.UnitPrice,
			ISNULL(AT2007.OriginalAmount, 0) AS OriginalAmount, ISNULL(AT2007.ConvertedAmount, 0) AS ConvertedAmount, AT2007.DivisionID
				 FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.VoucherID = AT2007.VoucherID
				 WHERE AT2006.DivisionID =''' + @DivisionID + ''' and 
				(AT2007.InventoryID like N'''+@FromInventoryID+''' or 
				 AT2007.InventoryID between N'''+@FromInventoryID+''' and N'''+@ToInventoryID+''') and
				(AT2006.WareHouseID = N'''+@WareHouseID+''' ) and
				(AT2006.TranMonth + AT2006.TranYear*100 <= '+str(@Month)+' + 100*'+str(@Year)+ ')  and
				KindVoucherID in '+ @KindVoucherListIm+'

	'
		Else --theo ngay
			Set @sSQL =' SELECT AT2007.VoucherID as ReVoucherID, AT2007.TransactionID as ReTransactionID, AT2007.VoucherID, AT2007.TransactionID, AT2006.WareHouseID,
			AT2006.VoucherNo, AT2007.InventoryID, AT2007.DebitAccountID ,
			 --AT2007.SourceNo, 
			NULL AS SourceNo, 
			 ISNULL(AT2007.UnitID, AT2007.ConvertedUnitID) AS UnitID, AT2007.ActualQuantity, AT2007.UnitPrice,
			ISNULL(AT2007.OriginalAmount, 0) AS OriginalAmount, ISNULL(AT2007.ConvertedAmount, 0) AS ConvertedAmount, AT2007.DivisionID
				 FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.VoucherID = AT2007.VoucherID
				 WHERE AT2006.DivisionID =''' + @DivisionID + ''' and 
				(AT2007.InventoryID like N'''+@FromInventoryID+''' or 
				 AT2007.InventoryID between N'''+@FromInventoryID+''' and N'''+@ToInventoryID+''') and
				(AT2006.WareHouseID = N'''+@WareHouseID+''' ) and
				(AT2006.VoucherDate  <= '''+Convert(Varchar(10),@Date,101)+''' )  and
				KindVoucherID in '+ @KindVoucherListIm+'
	'

	END

If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV2241')
	Exec('Create view AV2241  -----tao boi AP2041
		as '+@sSQL)
Else
	Exec('Alter view AV2241  -----tao boi AP2041
		as '+@sSQL)


-- Step 022: Xac dinh cac phieu xuat
IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
	BEGIN
		If @IsDate = 1 -- theo ky 
			Set @sSQL ='SELECT AT2007.ReVoucherID, AT2007.ReTransactionID, AT2007.VoucherID, AT2007.TransactionID, '+ @WareHouseID1 +' as WareHouseID,
						AT2006.VoucherNo, AT2007.InventoryID, AT2007.CreditAccountID as  DebitAccountID, 
						NULL AS SourceNo, 
						ISNULL(AT2007.UnitID, AT2007.ConvertedUnitID) AS UnitID, -AT2007.ActualQuantity as ActualQuantity, AT2007.UnitPrice,
						-ISNULL(AT2007.OriginalAmount, 0) as OriginalAmount,  -ISNULL(AT2007.ConvertedAmount, 0) as ConvertedAmount, AT2007.DivisionID,
						WT8899.S01ID, WT8899.S02ID, WT8899.S03ID, WT8899.S04ID, WT8899.S05ID, WT8899.S06ID, WT8899.S07ID, WT8899.S08ID, WT8899.S09ID, WT8899.S10ID,
						WT8899.S11ID, WT8899.S12ID, WT8899.S13ID, WT8899.S14ID, WT8899.S15ID, WT8899.S16ID, WT8899.S17ID, WT8899.S18ID, WT8899.S19ID, WT8899.S20ID
						FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
						LEFT JOIN WT8899 ON WT8899.DivisionID = AT2007.DivisionID AND WT8899.VoucherID = AT2007.VoucherID AND WT8899.TransactionID = AT2007.TransactionID
						WHERE AT2006.DivisionID =''' + @DivisionID + ''' and 
						(AT2007.InventoryID like N'''+@FromInventoryID+''' or 
							AT2007.InventoryID between N'''+@FromInventoryID+''' and N'''+@ToInventoryID+''') and
						('+ @WareHouseID1 +' = N'''+@WareHouseID+''' ) and
						(AT2006.TranMonth + AT2006.TranYear*100 <= '+str(@Month)+' + 100*'+str(@Year)+ '  )  and
						KindVoucherID  in '+ @KindVoucherListEx+'
						'
		Else
			Set @sSQL ='SELECT AT2007.ReVoucherID, AT2007.ReTransactionID, AT2007.VoucherID, AT2007.TransactionID, '+ @WareHouseID1 +' as WareHouseID,
						AT2006.VoucherNo, AT2007.InventoryID, AT2007.CreditAccountID as  DebitAccountID,
						---- AT2007.SourceNo, 
						NULL AS SourceNo, 
						ISNULL(AT2007.UnitID, AT2007.ConvertedUnitID) AS UnitID, -AT2007.ActualQuantity as ActualQuantity, AT2007.UnitPrice,
						-ISNULL(AT2007.OriginalAmount, 0) as OriginalAmount,  -ISNULL(AT2007.ConvertedAmount, 0) as ConvertedAmount, AT2007.DivisionID,
						WT8899.S01ID, WT8899.S02ID, WT8899.S03ID, WT8899.S04ID, WT8899.S05ID, WT8899.S06ID, WT8899.S07ID, WT8899.S08ID, WT8899.S09ID, WT8899.S10ID,
						WT8899.S11ID, WT8899.S12ID, WT8899.S13ID, WT8899.S14ID, WT8899.S15ID, WT8899.S16ID, WT8899.S17ID, WT8899.S18ID, WT8899.S19ID, WT8899.S20ID
						FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
						LEFT JOIN WT8899 ON WT8899.DivisionID = AT2007.DivisionID AND WT8899.VoucherID = AT2007.VoucherID AND WT8899.TransactionID = AT2007.TransactionID
						WHERE AT2006.DivisionID =''' + @DivisionID + ''' and 
						(AT2007.InventoryID like N'''+@FromInventoryID+''' or 
						AT2007.InventoryID between N'''+@FromInventoryID+''' and N'''+@ToInventoryID+''') and
						('+ @WareHouseID1 +' = N'''+@WareHouseID+''' ) and
						(AT2006.VoucherDate  <= '''+Convert(Varchar(10),@Date,101)+''' )  and
						KindVoucherID  in '+ @KindVoucherListEx+'
						'
	END
ELSE
	BEGIN
		If @IsDate = 1 -- theo ky 
			Set @sSQL =' SELECT AT2007.ReVoucherID, AT2007.ReTransactionID, AT2007.VoucherID, AT2007.TransactionID, '+ @WareHouseID1 +' as WareHouseID,
			AT2006.VoucherNo, AT2007.InventoryID, AT2007.CreditAccountID as  DebitAccountID,
			---- AT2007.SourceNo, 
			NULL AS SourceNo, 
			ISNULL(AT2007.UnitID, AT2007.ConvertedUnitID) AS UnitID, -AT2007.ActualQuantity as ActualQuantity, AT2007.UnitPrice,
			 -ISNULL(AT2007.OriginalAmount, 0) as OriginalAmount,  -ISNULL(AT2007.ConvertedAmount, 0) as ConvertedAmount, AT2007.DivisionID
				 FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
				 WHERE AT2006.DivisionID =''' + @DivisionID + ''' and 
				(AT2007.InventoryID like N'''+@FromInventoryID+''' or 
				 AT2007.InventoryID between N'''+@FromInventoryID+''' and N'''+@ToInventoryID+''') and
				('+ @WareHouseID1 +' = N'''+@WareHouseID+''' ) and
				(AT2006.TranMonth + AT2006.TranYear*100 <= '+str(@Month)+' + 100*'+str(@Year)+ '  )  and
				KindVoucherID  in '+ @KindVoucherListEx+'

	'
		Else
			Set @sSQL =' SELECT AT2007.ReVoucherID, AT2007.ReTransactionID, AT2007.VoucherID, AT2007.TransactionID, '+ @WareHouseID1 +' as WareHouseID,
			AT2006.VoucherNo, AT2007.InventoryID, AT2007.CreditAccountID as  DebitAccountID,
			---- AT2007.SourceNo, 
			NULL AS SourceNo, 
			ISNULL(AT2007.UnitID, AT2007.ConvertedUnitID) AS UnitID, -AT2007.ActualQuantity as ActualQuantity, AT2007.UnitPrice,
			 -ISNULL(AT2007.OriginalAmount, 0) as OriginalAmount,  -ISNULL(AT2007.ConvertedAmount, 0) as ConvertedAmount, AT2007.DivisionID
				 FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
				 WHERE AT2006.DivisionID =''' + @DivisionID + ''' and 
				(AT2007.InventoryID like N'''+@FromInventoryID+''' or 
				 AT2007.InventoryID between N'''+@FromInventoryID+''' and N'''+@ToInventoryID+''') and
				('+ @WareHouseID1 +' = N'''+@WareHouseID+''' ) and
				(AT2006.VoucherDate  <= '''+Convert(Varchar(10),@Date,101)+''' )  and
				KindVoucherID  in '+ @KindVoucherListEx+'

	'
	END
		
If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV2341')
	Exec('Create view AV2341  -----tao boi AP2041
		as '+@sSQL)
Else
	Exec('Alter view AV2341  -----tao boi AP2041
		as '+@sSQL)



-- Step 023: Xac dinh so du thuc te
IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
	Set @sSQL ='Select	ReVoucherID, ReTransactionID, VoucherID, TransactionID, WareHouseID, 
						VoucherNo, InventoryID, DebitAccountID,
						LTrim(RTrim(SourceNo)) AS SourceNo, UnitID, 
						ActualQuantity, UnitPrice, OriginalAmount, ConvertedAmount , DivisionID,
						S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
						S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID
				From 	AV2141
				Union All
				Select	ReVoucherID, ReTransactionID, VoucherID, TransactionID, WareHouseID, 
						VoucherNo, InventoryID, DebitAccountID,
						LTrim(RTrim(SourceNo)) AS SourceNo, UnitID, 
						ActualQuantity, UnitPrice, OriginalAmount, ConvertedAmount , DivisionID,
						S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
						S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID
				From AV2241 
				Union All
				Select	ReVoucherID, ReTransactionID, VoucherID, TransactionID,WareHouseID, 
						VoucherNo, InventoryID, DebitAccountID,
						LTrim(RTrim(SourceNo)) AS SourceNo, UnitID, 
						ActualQuantity, UnitPrice, OriginalAmount, ConvertedAmount , DivisionID,
						S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
						S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID
				From AV2341
				'
ELSE				
	Set @sSQL ='Select ReVoucherID, ReTransactionID, VoucherID, TransactionID, WareHouseID, 
		VoucherNo, InventoryID, DebitAccountID,
		LTrim(RTrim(SourceNo)) AS SourceNo, UnitID, 
		ActualQuantity, UnitPrice, OriginalAmount, ConvertedAmount , DivisionID
	From 	AV2141

Union All

	        Select ReVoucherID, ReTransactionID, VoucherID, TransactionID, WareHouseID, 
		VoucherNo, InventoryID, DebitAccountID,
		LTrim(RTrim(SourceNo)) AS SourceNo, UnitID, 
		ActualQuantity, UnitPrice, OriginalAmount, ConvertedAmount , DivisionID
	From AV2241 
Union All

	        Select ReVoucherID, ReTransactionID, VoucherID, TransactionID,WareHouseID, 
		VoucherNo, InventoryID, DebitAccountID,
		LTrim(RTrim(SourceNo)) AS SourceNo, UnitID, 
		ActualQuantity, UnitPrice, OriginalAmount, ConvertedAmount , DivisionID
	From AV2341

'

If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV2441')
	Exec('Create view AV2441  -----tao boi AP2041
		as '+@sSQL)
Else
	Exec('Alter view AV2441  -----tao boi AP2041
		as '+@sSQL)


--PRINT @sSQL
IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
	Set @sSQL ='Select	AV2441.InventoryID, AT1302.InventoryName, AV2441.WareHouseID, AT1303.WareHouseName, AV2441.SourceNo, AV2441.UnitID, AV2441.DebitAccountID,
						Sum(AV2441.ActualQuantity) as ActualQuantity , 
						Sum(AV2441.OriginalAmount) as OriginalAmount, 
						Sum(AV2441.ConvertedAmount) as ConvertedAmount ,
						Case when Sum(AV2441.ActualQuantity) <> 0 then
							ABS(Sum(AV2441.ConvertedAmount) / Sum(AV2441.ActualQuantity))
						else
							0 end as UnitPrice ,
						AV2441.DivisionID,
						AV2441.S01ID, AV2441.S02ID, AV2441.S03ID, AV2441.S04ID, AV2441.S05ID, AV2441.S06ID, AV2441.S07ID, AV2441.S08ID, AV2441.S09ID, AV2441.S10ID,
						AV2441.S11ID, AV2441.S12ID, AV2441.S13ID, AV2441.S14ID, AV2441.S15ID, AV2441.S16ID, AV2441.S17ID, AV2441.S18ID, AV2441.S19ID, AV2441.S20ID

				From 	AV2441  
				Inner join AT1302 on AT1302.InventoryID = AV2441.InventoryID and AT1302.DivisionID = AV2441.DivisionID
		 		Inner join AT1303 on AT1303.WareHouseID = AV2441.WareHouseID and  AT1303.DivisionID = AV2441.DivisionID
				Group by AV2441.InventoryID, AT1302.InventoryName,AV2441.WareHouseID,  AT1303.WareHouseName, AV2441.SourceNo, AV2441.UnitID, AV2441.DebitAccountID, AV2441.DivisionID,
						AV2441.S01ID, AV2441.S02ID, AV2441.S03ID, AV2441.S04ID, AV2441.S05ID, AV2441.S06ID, AV2441.S07ID, AV2441.S08ID, AV2441.S09ID, AV2441.S10ID,
						AV2441.S11ID, AV2441.S12ID, AV2441.S13ID, AV2441.S14ID, AV2441.S15ID, AV2441.S16ID, AV2441.S17ID, AV2441.S18ID, AV2441.S19ID, AV2441.S20ID
				'

ELSE
	Set @sSQL ='Select AV2441.InventoryID, AT1302.InventoryName, AV2441.WareHouseID, AT1303.WareHouseName, AV2441.SourceNo, AV2441.UnitID, AV2441.DebitAccountID,
		Sum(AV2441.ActualQuantity) as ActualQuantity , 
		Sum(AV2441.OriginalAmount) as OriginalAmount, 
		Sum(AV2441.ConvertedAmount) as ConvertedAmount ,
		Case when Sum(AV2441.ActualQuantity) <> 0 then
			ABS(Sum(AV2441.ConvertedAmount) / Sum(AV2441.ActualQuantity))
		else
			0 end as UnitPrice ,
		AV2441.DivisionID

	From 	AV2441  Inner join AT1302 on AT1302.InventoryID = AV2441.InventoryID and AT1302.DivisionID = AV2441.DivisionID
		 	Inner join AT1303 on AT1303.WareHouseID = AV2441.WareHouseID and  AT1303.DivisionID = AV2441.DivisionID
	Group by AV2441.InventoryID, AT1302.InventoryName,AV2441.WareHouseID,  AT1303.WareHouseName, AV2441.SourceNo, AV2441.UnitID, AV2441.DebitAccountID, AV2441.DivisionID
	
'

If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV2041')
	Exec('Create view AV2041  -----tao boi AP2041
		as '+@sSQL)
Else
	Exec('Alter view AV2041  -----tao boi AP2041
		as '+@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

