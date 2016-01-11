
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- Created by Bao Anh	Date: 30/10/2012
--- Puppose: Customize bao cao nhap xuat ton theo quy cach cho 2T
--- Modified on 08/03/2013 by Bao Anh: Bo sung truong lo nhap va 15 tham so, doi tuong
--- Modified on 22/04/2013 by Bao Anh: Sua inner join thanh left join khi ket AT0114 va AV3004
--- Modified on 20/08/2013 by Khanh Van: Load lai du lieu Notes03

ALTER PROCEDURE [dbo].[AP3005_2T]    @DivisionID  as nvarchar(50),		
				@FromMonth as int,
				@ToMonth as int,
				@FromYear as int,
				@ToYear as int,
				@FromDate as datetime,
				@ToDate as datetime,
				@FromWareHouseID as nvarchar(50),
				@ToWareHouseID as nvarchar(50),
				@FromInventoryID as nvarchar(50),
				@ToInventoryID  as nvarchar(50),		
				@IsDate as tinyint

AS

Declare @sSQL   as  nvarchar(max),
		@FromMonthYearText NVARCHAR(20), 
		@ToMonthYearText NVARCHAR(20), 
		@FromDateText NVARCHAR(20), 
		@ToDateText NVARCHAR(20),
		@ConvertionFactor as decimal(28,8)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

-----------Tao View AV3001 -Ton dau ky
If @IsDate = 0 ---theo ky 
BEGIN
	Set   @sSQL = N' 
	Select AT0114.DivisionID, AT0114.InventoryID, AT1302.InventoryName, AV3004.ConvertedUnitID, AT0114.WarehouseID, AT1303.WarehouseName,
		AV3004.Parameter01, AV3004.Parameter02, AV3004.Parameter03, AV3004.Parameter04, AV3004.Parameter05,
		AT0114.ReVoucherNo, AT0114.ReVoucherDate, AT0114.ReVoucherID, AT0114.ReTransactionID,
		AV3004.Ana04ID, AV3004.Ana05ID, AV3004.Notes, AT0114.UnitPrice,
		Isnull(AT0114.EndQuantity,0) as BeginQuantity,
		Isnull(AT0114.EndMarkQuantity,0) as BeginMarkQuantity,
		0 as ReQuantity, 0 as ReMarkQuantity, 0 as DeQuantity, 0 as DeMarkQuantity,
		Isnull(AV3004.ConvertedQuantity,0)/Isnull(ActualQuantity,1) as ConversionFactor, AT0114.ReSourceNo,
		AV3004.Notes01, AV3004.Notes02, (Case when (isnull(AV3004.Notes03,'''')<>'''') and (isnull(AV3004.Notes04,'''')<>'''') then AV3004.Notes03+''/''+ AV3004.Notes04 else isnull(AV3004.Notes03,'''')+isnull(AV3004.Notes04,'''') end) as Notes03, AV3004.Notes04, AV3004.Notes05, AV3004.Notes06, AV3004.Notes07, AV3004.Notes08,
		AV3004.Notes09, AV3004.Notes10, AV3004.Notes11, AV3004.Notes12, AV3004.Notes13, AV3004.Notes14, AV3004.Notes15,
		AV3004.ObjectID, AV3004.ObjectName, AV3004.ConvertedUnitName
	From  AT0114
		left Join AV3004 on AV3004.VoucherID = AT0114.ReVoucherID And AV3004.DivisionID = AT0114.DivisionID
			and AV3004.TransactionID = AT0114.ReTransactionID
		inner  join AT1302 on AT1302.InventoryID = AT0114.InventoryID And AT1302.DivisionID =AT0114.DivisionID
		inner join AT1303 on AT1303.WarehouseID = AT0114.WarehouseID and AT1303.DivisionID =AT0114.DivisionID
	Where AT0114.DivisionID ='''+@DivisionID+''' and
		(AT0114.InventoryID between '''+@FromInventoryID+''' and ''' + @ToInventoryID + ''') and
		(ReTranMonth + ReTranYear*100 < ''' + @FromMonthYearText + ''') and
		(AT0114.WareHouseID between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''') and
		Isnull(AT0114.EndQuantity,0) > 0'
END

Else
BEGIN
	Set   @sSQL = N' 
	Select AT0114.DivisionID, AT0114.InventoryID, AT1302.InventoryName, AV3004.ConvertedUnitID, AT0114.WarehouseID, AT1303.WarehouseName,
		AV3004.Parameter01, AV3004.Parameter02, AV3004.Parameter03, AV3004.Parameter04, AV3004.Parameter05,
		AT0114.ReVoucherNo, AT0114.ReVoucherDate, AT0114.ReVoucherID, AT0114.ReTransactionID,
		AV3004.Ana04ID, AV3004.Ana05ID, AV3004.Notes, AT0114.UnitPrice,
		Isnull(AT0114.EndQuantity,0) as BeginQuantity,
		Isnull(AT0114.EndMarkQuantity,0) as BeginMarkQuantity,
		0 as ReQuantity, 0 as ReMarkQuantity, 0 as DeQuantity, 0 as DeMarkQuantity,
		Isnull(AV3004.ConvertedQuantity,0)/Isnull(ActualQuantity,1) as ConversionFactor, AT0114.ReSourceNo,
		AV3004.Notes01, AV3004.Notes02, (Case when (isnull(AV3004.Notes03,'''')<>'''') and (isnull(AV3004.Notes04,'''')<>'''') then AV3004.Notes03+''/''+ AV3004.Notes04 else isnull(AV3004.Notes03,'''')+isnull(AV3004.Notes04,'''') end) as Notes03, AV3004.Notes04, AV3004.Notes05, AV3004.Notes06, AV3004.Notes07, AV3004.Notes08,
		AV3004.Notes09, AV3004.Notes10, AV3004.Notes11, AV3004.Notes12, AV3004.Notes13, AV3004.Notes14, AV3004.Notes15,
		AV3004.ObjectID, AV3004.ObjectName, AV3004.ConvertedUnitName
	From  AT0114
		left Join AV3004 on AV3004.VoucherID = AT0114.ReVoucherID And AV3004.DivisionID = AT0114.DivisionID
			and AV3004.TransactionID = AT0114.ReTransactionID
		inner  join AT1302 on AT1302.InventoryID =AT0114.InventoryID And AT1302.DivisionID =AT0114.DivisionID
		inner join AT1303 on AT1303.WarehouseID = AT0114.WarehouseID and AT1303.DivisionID =AT0114.DivisionID
	Where AT0114.DivisionID ='''+@DivisionID+''' and
		(AT0114.InventoryID between '''+@FromInventoryID+''' and ''' + @ToInventoryID + ''') and
		( AT0114.ReVoucherDate <'''+@FromDateText+''') and
		(AT0114.WareHouseID between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''') and
		Isnull(AT0114.EndQuantity,0) > 0'
END
print @ssQl
If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='AV3001')
	Exec(' Create view AV3001  --Create by AP3005_2T
	as '+ @sSQL)----tao boi AP3005_2T----
Else
	Exec(' Alter view AV3001  --Create by AP3005_2T
	as '+@sSQL) ----tao boi AP3005_2T----

-----------Tao View AV3002 -Phat sinh trong ky
If @Isdate = 0
BEGIN
	Set @sSQL= N'
	Select AT0114.DivisionID, AT0114.InventoryID, AT1302.InventoryName, AV3004.ConvertedUnitID, AT0114.WarehouseID, AT1303.WarehouseName,
		AV3004.Parameter01, AV3004.Parameter02, AV3004.Parameter03, AV3004.Parameter04, AV3004.Parameter05,
		AT0114.ReVoucherNo, AT0114.ReVoucherDate, AT0114.ReVoucherID, AT0114.ReTransactionID,
		AV3004.Ana04ID, AV3004.Ana05ID, AV3004.Notes, AT0114.UnitPrice,
		0 BeginQuantity, 0 as BeginMarkQuantity,
		ReQuantity, ReMarkQuantity, DeQuantity, DeMarkQuantity,
		(Case when Isnull(ActualQuantity,0)<>0 then Isnull(AV3004.ConvertedQuantity,0)/ActualQuantity else 0 end) as ConversionFactor, AT0114.ReSourceNo,
		AV3004.Notes01, AV3004.Notes02, (Case when (isnull(AV3004.Notes03,'''')<>'''') and (isnull(AV3004.Notes04,'''')<>'''') then AV3004.Notes03+''/''+ AV3004.Notes04 else isnull(AV3004.Notes03,'''')+isnull(AV3004.Notes04,'''') end) as Notes03, AV3004.Notes04, AV3004.Notes05, AV3004.Notes06, AV3004.Notes07, AV3004.Notes08,
		AV3004.Notes09, AV3004.Notes10, AV3004.Notes11, AV3004.Notes12, AV3004.Notes13, AV3004.Notes14, AV3004.Notes15,
		AV3004.ObjectID, AV3004.ObjectName, AV3004.ConvertedUnitName
	From  AT0114
		left Join AV3004 on AV3004.VoucherID = AT0114.ReVoucherID And AV3004.DivisionID = AT0114.DivisionID
			and AV3004.TransactionID = AT0114.ReTransactionID 
		inner  join AT1302 on AT1302.InventoryID =AT0114.InventoryID And AT1302.DivisionID =AT0114.DivisionID
		inner join AT1303 on AT1303.WarehouseID = AT0114.WarehouseID and AT1303.DivisionID =AT0114.DivisionID
	Where AT0114.DivisionID ='''+@DivisionID+''' and
	(AT0114.InventoryID between '''+@FromInventoryID+''' and ''' + @ToInventoryID + ''') and
	(ReTranMonth + ReTranYear*100 between ''' + @FromMonthYearText + ''' and ''' +
	@ToMonthYearText + ''') and
	(AT0114.WareHouseID between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''')
	'
END

else 
BEGIN
	Set @sSQL= N'
	Select AT0114.DivisionID, AT0114.InventoryID, AT1302.InventoryName, AV3004.ConvertedUnitID, AT0114.WarehouseID, AT1303.WarehouseName,
			AV3004.Parameter01, AV3004.Parameter02, AV3004.Parameter03, AV3004.Parameter04, AV3004.Parameter05,
			AT0114.ReVoucherNo, AT0114.ReVoucherDate, AT0114.ReVoucherID, AT0114.ReTransactionID,
			AV3004.Ana04ID, AV3004.Ana05ID, AV3004.Notes, AT0114.UnitPrice,
			0 BeginQuantity, 0 as BeginMarkQuantity,
			ReQuantity, ReMarkQuantity, DeQuantity, DeMarkQuantity,
			(Case when Isnull(ActualQuantity,0)<>0 then Isnull(AV3004.ConvertedQuantity,0)/ActualQuantity else 0 end) as ConversionFactor, AT0114.ReSourceNo,
			AV3004.Notes01, AV3004.Notes02, (Case when (isnull(AV3004.Notes03,'''')<>'''') and (isnull(AV3004.Notes04,'''')<>'''') then AV3004.Notes03+''/''+ AV3004.Notes04 else isnull(AV3004.Notes03,'''')+isnull(AV3004.Notes04,'''') end) as Notes03, AV3004.Notes04, AV3004.Notes05, AV3004.Notes06, AV3004.Notes07, AV3004.Notes08,
			AV3004.Notes09, AV3004.Notes10, AV3004.Notes11, AV3004.Notes12, AV3004.Notes13, AV3004.Notes14, AV3004.Notes15,
			AV3004.ObjectID, AV3004.ObjectName, AV3004.ConvertedUnitName
	From  AT0114
			left Join AV3004 on AV3004.VoucherID = AT0114.ReVoucherID And AV3004.DivisionID = AT0114.DivisionID
				and AV3004.TransactionID = AT0114.ReTransactionID 
			inner  join AT1302 on AT1302.InventoryID =AT0114.InventoryID And AT1302.DivisionID =AT0114.DivisionID
			inner join AT1303 on AT1303.WarehouseID = AT0114.WarehouseID and AT1303.DivisionID =AT0114.DivisionID
	Where AT0114.DivisionID ='''+@DivisionID+''' and
		(AT0114.InventoryID between '''+@FromInventoryID+''' and ''' + @ToInventoryID + ''') and
		( AT0114.ReVoucherDate Between '''+@FromDateText+'''  and  '''+@ToDateText+''') and
		(AT0114.WareHouseID between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''')
	'
END

If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='AV3002')
	Exec(' Create view AV3002  --Create by AP3005_2T
	as '+ @sSQL) ----tao boi AP3005_2T----
Else
	Exec(' Alter view AV3002  --Create by AP3005_2T
	as '+@sSQL) ----tao boi AP3005_2T----

-----------Tao View AV3005 - Tong hop
Set   @sSQL = N' 
	Select DivisionID, InventoryID, InventoryName, ConvertedUnitID, WarehouseID, WarehouseName,
			Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
			ReVoucherNo, ReVoucherDate, ReVoucherID, ReTransactionID,
			Ana04ID, Ana05ID, Notes, UnitPrice,
			BeginQuantity, BeginMarkQuantity,
			ReQuantity, ReMarkQuantity, DeQuantity, DeMarkQuantity, ConversionFactor,
			(BeginQuantity + ReQuantity - DeQuantity) as EndQuantity,
			(BeginMarkQuantity + ReMarkQuantity - DeMarkQuantity) as EndMarkQuantity,
			((BeginQuantity + ReQuantity - DeQuantity) * ConversionFactor) as EndConvertedQuantity,
			ReSourceNo,	Notes01, Notes02, Notes03, Notes04, Notes05, Notes06, Notes07, Notes08,
			Notes09, Notes10, Notes11, Notes12, Notes13, Notes14, Notes15, ObjectID, ObjectName, ConvertedUnitName
	From AV3001
	UNION
	Select DivisionID, InventoryID, InventoryName, ConvertedUnitID, WarehouseID, WarehouseName,
			Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
			ReVoucherNo, ReVoucherDate, ReVoucherID, ReTransactionID,
			Ana04ID, Ana05ID, Notes, UnitPrice,
			BeginQuantity, BeginMarkQuantity,
			ReQuantity, ReMarkQuantity, DeQuantity, DeMarkQuantity, ConversionFactor,
			(BeginQuantity + ReQuantity - DeQuantity) as EndQuantity,
			(BeginMarkQuantity + ReMarkQuantity - DeMarkQuantity) as EndMarkQuantity,
			((BeginQuantity + ReQuantity - DeQuantity) * ConversionFactor) as EndConvertedQuantity,
			ReSourceNo,	Notes01, Notes02, Notes03, Notes04, Notes05, Notes06, Notes07, Notes08,
			Notes09, Notes10, Notes11, Notes12, Notes13, Notes14, Notes15, ObjectID, ObjectName, ConvertedUnitName
	From AV3002
'
print @sSql
If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='AV3005')
	Exec(' Create view AV3005  --Create by AP3005_2T
	as '+ @sSQL) ----tao boi AP3005_2T----
Else
	Exec(' Alter view AV3005  --Create by AP3005_2T
	as '+@sSQL) ----tao boi AP3005_2T----
	select * from AT0114
----------- Tao View AV30051 - Bao cao ton kho mau 2
If @IsDate = 0 ---theo ky 
BEGIN
	Set   @sSQL = N' 
	Select AT0114.DivisionID, AT0114.InventoryID, AV3004.ConvertedUnitID, AT0114.WarehouseID,
		AV3004.Parameter01, AV3004.Parameter02, AV3004.Parameter03, AV3004.Parameter04, AV3004.Parameter05,
		AT0114.ReVoucherNo, AT0114.ReVoucherDate, AT0114.ReVoucherID, AT0114.ReTransactionID,
		AV3004.Ana04ID, AV3004.Ana05ID, AV3004.Notes, AV3004.VoucherTypeID, AT0114.UnitPrice,
		AT0114.EndQuantity, AT0114.EndMarkQuantity,
		(Case when Isnull(ActualQuantity,0)<> 0 then Isnull(AV3004.ConvertedQuantity,0)/ActualQuantity else 0 end) as ConversionFactor,
		(Case when Isnull(ActualQuantity,0)<>0 then AT0114.EndQuantity * (Isnull(AV3004.ConvertedQuantity,0)/ActualQuantity) else 0 end) as EndConvertedQuantity,
		
		(case when (Select Sum(Isnull(ConvertedQuantity,0)) From AV3004 V04 Where V04.VoucherID = AV3004.VoucherID and V04.DivisionID = AV3004.DivisionID) = 0 then 0 else
		((case when AT9000.Ana01ID = ''CPGC'' then AT9000.ConvertedAmount else 0 end) * Isnull(AV3004.ConvertedQuantity,0)
		/(Select Sum(Isnull(ConvertedQuantity,1)) From AV3004 V04 Where V04.VoucherID = AV3004.VoucherID and V04.DivisionID = AV3004.DivisionID)) end) as CPGC,
		
		(case when (Select Sum(Isnull(ConvertedQuantity,0)) From AV3004 V04 Where V04.VoucherID = AV3004.VoucherID and V04.DivisionID = AV3004.DivisionID) = 0 then 0 else
		((case when AT9000.Ana01ID = ''CPVC'' then AT9000.ConvertedAmount else 0 end) * Isnull(AV3004.ConvertedQuantity,0)
		/(Select Sum(Isnull(ConvertedQuantity,1)) From AV3004 V04 Where V04.VoucherID = AV3004.VoucherID and V04.DivisionID = AV3004.DivisionID)) end) as CPVC,
		
		AT0114.ReSourceNo,
		AV3004.Notes01, AV3004.Notes02, (Case when (isnull(AV3004.Notes03,'''')<>'''') and (isnull(AV3004.Notes04,'''')<>'''') then AV3004.Notes03+''/''+ AV3004.Notes04 else isnull(AV3004.Notes03,'''')+isnull(AV3004.Notes04,'''') end) as Notes03, AV3004.Notes04, AV3004.Notes05, AV3004.Notes06, AV3004.Notes07, AV3004.Notes08,
		AV3004.Notes09, AV3004.Notes10, AV3004.Notes11, AV3004.Notes12, AV3004.Notes13, AV3004.Notes14, AV3004.Notes15,
		AV3004.ObjectID, AV3004.ObjectName, AV3004.ConvertedUnitName
		
	From  AT0114
		left Join AV3004 on AV3004.VoucherID = AT0114.ReVoucherID And AV3004.DivisionID = AT0114.DivisionID
			and AV3004.TransactionID = AT0114.ReTransactionID
		Left join AT9000 on AV3004.VoucherID = AT9000.VoucherID and AV3004.DivisionID = AT0114.DivisionID
						And AT9000.TransactionTypeID = ''T20''
	
	Where AT0114.DivisionID ='''+@DivisionID+''' and
		(AT0114.InventoryID between '''+@FromInventoryID+''' and ''' + @ToInventoryID + ''') and
		(ReTranMonth + ReTranYear*100 < ''' + @ToMonthYearText + ''') and
		(AT0114.WareHouseID between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''') and
		Isnull(AT0114.EndQuantity,0) > 0'
END

Else
BEGIN
	Set   @sSQL = N' 
	Select AT0114.DivisionID, AT0114.InventoryID, AV3004.ConvertedUnitID, AT0114.WarehouseID,
		AV3004.Parameter01, AV3004.Parameter02, AV3004.Parameter03, AV3004.Parameter04, AV3004.Parameter05,
		AT0114.ReVoucherNo, AT0114.ReVoucherDate, AT0114.ReVoucherID, AT0114.ReTransactionID,
		AV3004.Ana04ID, AV3004.Ana05ID, AV3004.Notes, AV3004.VoucherTypeID, AT0114.UnitPrice,
		AT0114.EndQuantity, AT0114.EndMarkQuantity,
		(Case when Isnull(ActualQuantity,0)<>0 then Isnull(AV3004.ConvertedQuantity,0)/ActualQuantity else 0 end) as ConversionFactor,
		(Case when Isnull(ActualQuantity,0)<>0 then AT0114.EndQuantity * (Isnull(AV3004.ConvertedQuantity,0)/ActualQuantity) else 0 end) as EndConvertedQuantity,
		
		(case when (Select Sum(Isnull(ConvertedQuantity,0)) From AV3004 V04 Where V04.VoucherID = AV3004.VoucherID and V04.DivisionID = AV3004.DivisionID) = 0 then 0 else
		((case when AT9000.Ana01ID = ''CPGC'' then AT9000.ConvertedAmount else 0 end) * Isnull(AV3004.ConvertedQuantity,0)
		/(Select Sum(Isnull(ConvertedQuantity,1)) From AV3004 V04 Where V04.VoucherID = AV3004.VoucherID and V04.DivisionID = AV3004.DivisionID)) end) as CPGC,
		
		(case when (Select Sum(Isnull(ConvertedQuantity,0)) From AV3004 V04 Where V04.VoucherID = AV3004.VoucherID and V04.DivisionID = AV3004.DivisionID) = 0 then 0 else
		((case when AT9000.Ana01ID = ''CPVC'' then AT9000.ConvertedAmount else 0 end) * Isnull(AV3004.ConvertedQuantity,0)
		/(Select Sum(Isnull(ConvertedQuantity,1)) From AV3004 V04 Where V04.VoucherID = AV3004.VoucherID and V04.DivisionID = AV3004.DivisionID)) end) as CPVC,
		
		AT0114.ReSourceNo,
		AV3004.Notes01, AV3004.Notes02, (Case when (isnull(AV3004.Notes03,'''')<>'''') then AV3004.Notes03 else AV3004.Notes04 end) as Notes03, AV3004.Notes04, AV3004.Notes05, AV3004.Notes06, AV3004.Notes07, AV3004.Notes08,
		AV3004.Notes09, AV3004.Notes10, AV3004.Notes11, AV3004.Notes12, AV3004.Notes13, AV3004.Notes14, AV3004.Notes15,
		AV3004.ObjectID, AV3004.ObjectName, AV3004.ConvertedUnitName
	From  AT0114
		left Join AV3004 on AV3004.VoucherID = AT0114.ReVoucherID And AV3004.DivisionID = AT0114.DivisionID
			and AV3004.TransactionID = AT0114.ReTransactionID
		Left join AT9000 on AV3004.VoucherID = AT9000.VoucherID and AV3004.DivisionID = AT0114.DivisionID
						And AT9000.TransactionTypeID = ''T20''
						
	Where AT0114.DivisionID ='''+@DivisionID+''' and
		(AT0114.InventoryID between '''+@FromInventoryID+''' and ''' + @ToInventoryID + ''') and
		( AT0114.ReVoucherDate <'''+@ToDateText+''') and
		(AT0114.WareHouseID between '''+@FromWareHouseID+''' and ''' + @ToWareHouseID + ''') and
		Isnull(AT0114.EndQuantity,0) > 0'
END

If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='AV30051')
	Exec(' Create view AV30051 --Create by AP3005_2T
	as '+ @sSQL)----tao boi AP3005_2T----
Else
	Exec(' Alter view AV30051  --Create by AP3005_2T
	 as '+@sSQL) ----tao boi AP3005_2T----