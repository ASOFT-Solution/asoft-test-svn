if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AV7011]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[AV7011]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



---------------- Last updated by Quoc Huy. Date 12/07/2006
------------------ View chet. Xu ly so du hang ton kho. Giong AV7000 nhung khong lay len ten ma phan tich
---- Edit by: Dang Le Bao Quynh; Date: 16/01/2009
---- Purpose: Bo sung truong hop xuat hang mua tra lai
---- Edited by Bao Anh	Date: 04/10/2012	Bo sung truong Parameter01 -> 05 (2T)

CREATE View AV7011 as 
--- So du No cua tai khoan ton kho
Select  D17.DivisionID, D17.TranMonth, D17.TranYear,
	D16.WareHouseID, D17.InventoryID,
	D17.Parameter01, D17.Parameter02, D17.Parameter03, D17.Parameter04, D17.Parameter05,
	D17.DebitAccountID, D17.CreditAccountID,
	'BD' as D_C,  --- So du No
	'' as RefNo01, '' as RefNo02, 	D17.Notes,
	D16.VoucherID, D16.VoucherDate, D16.VoucherNo, 
	D16.ObjectID,AT1202.ObjectName, 	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID,
	 D03.WareHouseName,	
	ActualQuantity, 
	ConvertedAmount,
	ActualQuantity as SignQuantity, 
	ConvertedAmount as SignAmount,	
	D02.S1,	D02.S2, D02.S3 ,
	D02.S1 as CI1ID, D02.S2 as CI2ID, D02.S3 as CI3ID, 
	D17.Ana01ID,D17.Ana02ID,D17.Ana03ID,
	D16.VoucherTypeID,
	D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID,
	isnull(D03.IsTemp,0) as IsTemp,
	0 as 	 KindVoucherID,
	(Case When  D17.TranMonth <10 then '0'+rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) 
	Else rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) End) as MonthYear,
	('0'+ ltrim(rtrim(Case when D17.TranMonth %3 = 0 then D17.TranMonth/3  Else D17.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D17.TranYear)))
	)  as Quarter ,
	str(D17.TranYear) as Year

From AT2017 as D17 inner join AT2016 as D16 On D16.VoucherID = D17.VoucherID
			Left join AT1202 on AT1202.ObjectID = D16.ObjectID
		inner join AT1302 as D02 on D02.InventoryID = D17.InventoryID
		inner join AT1304 as D04 on D04.UnitID = D02.UnitID
		inner join AT1303 as D03 on D03.WareHouseID = D16.WareHouseID

Where isnull(DebitAccountID,'') <>''

Union All --- So du co hang ton kho

Select  D17.DivisionID, D17.TranMonth, D17.TranYear,
	D16.WareHouseID, D17.InventoryID,
	D17.Parameter01, D17.Parameter02, D17.Parameter03, D17.Parameter04, D17.Parameter05,
	D17.DebitAccountID, D17.CreditAccountID,
	'BC' as D_C,  --- So du Co
	'' as RefNo01, '' as RefNo02, 	D17.Notes,
	D16.VoucherID, D16.VoucherDate, D16.VoucherNo, 
	D16.ObjectID,AT1202.ObjectName, 	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedAmount,
	-ActualQuantity as SignQuantity, 
	-ConvertedAmount as SignAmount,	
	D02.S1,	D02.S2, D02.S3 ,
	D02.S1 as CI1ID, D02.S2 as CI2ID, D02.S3 as CI3ID, 
	D17.Ana01ID,D17.Ana02ID,D17.Ana03ID,
	D16.VoucherTypeID,
	D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID,
	isnull(D03.IsTemp,0) as IsTemp,
	0 as KindVoucherID,
(Case When  D17.TranMonth <10 then '0'+rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) 
	Else rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) End) as MonthYear,
	('0'+ ltrim(rtrim(Case when D17.TranMonth %3 = 0 then D17.TranMonth/3  Else D17.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D17.TranYear)))
	)  as Quarter ,
	str(D17.TranYear) as Year
From AT2017 as D17 inner join AT2016 as D16 On D16.VoucherID = D17.VoucherID
		Left join AT1202 on AT1202.ObjectID = D16.ObjectID
		inner join AT1302 as D02 on D02.InventoryID = D17.InventoryID
		inner join AT1304 as D04 on D04.UnitID = D02.UnitID
		inner join AT1303 as D03 on D03.WareHouseID = D16.WareHouseID

Where isnull(CreditAccountID,'') <>''

Union All  -- Nhap kho

Select  D07.DivisionID, D07.TranMonth, D07.TranYear,
	D06.WareHouseID, 
	D07.InventoryID, D07.Parameter01, D07.Parameter02, D07.Parameter03, D07.Parameter04, D07.Parameter05,
	D07.DebitAccountID, D07.CreditAccountID,
	'D' as D_C,  --- Phat sinh No
	RefNo01 as RefNo01, RefNo02, 	D07.Notes,
	D06.VoucherID, D06.VoucherDate, D06.VoucherNo, 
	D06.ObjectID,AT1202.ObjectName,AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedAmount,
	ActualQuantity as SignQuantity, 
	ConvertedAmount as SignAmount,	
	D02.S1,	D02.S2, D02.S3, 
	D02.S1 as CI1ID, D02.S2 as CI2ID, D02.S3 as CI3ID, 
	D07.Ana01ID,D07.Ana02ID,D07.Ana03ID,
	D06.VoucherTypeID,
	D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID,
	isnull(D03.IsTemp,0) as IsTemp,
	Case when  KindVoucherID = 3 then 3 else 0 end as KindVoucherID,
	(Case When  D07.TranMonth <10 then '0'+rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) 
	Else rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) End) as MonthYear,
	('0'+ ltrim(rtrim(Case when D07.TranMonth %3 = 0 then D07.TranMonth/3  Else D07.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D07.TranYear)))
	)  as Quarter ,
	str(D07.TranYear) as Year

From AT2007 as D07 inner join AT2006 D06 On D06.VoucherID = D07.VoucherID
			Left join AT1202 on AT1202.ObjectID = D06.ObjectID
		inner join AT1302 as D02 on D02.InventoryID = D07.InventoryID
		inner join AT1304 as D04 on D04.UnitID = D02.UnitID
		inner join AT1303 as D03 on D03.WareHouseID = D06.WareHouseID

Where D06.KindVoucherID in (1,3,5,7)

Union All  -- Xuat kho
Select  D07.DivisionID, D07.TranMonth, D07.TranYear,
	Case when D06.KindVoucherID = 3 then D06.WareHouseID2 Else  D06.WareHouseID End as WareHouseID, 
	D07.InventoryID, D07.Parameter01, D07.Parameter02, D07.Parameter03, D07.Parameter04, D07.Parameter05,
	D07.DebitAccountID, D07.CreditAccountID,
	'C' as D_C,  --- So du Co
	RefNo01 as RefNo01, RefNo02, 	D07.Notes,
	D06.VoucherID, D06.VoucherDate, D06.VoucherNo, 
	D06.ObjectID,AT1202.ObjectName, 	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID,
	Case when D06.KindVoucherID = 3 then D031.WareHouseName Else  D03.WareHouseName End  as WareHouseName,	
	ActualQuantity, 
	ConvertedAmount,
	-ActualQuantity as SignQuantity, 
	-ConvertedAmount as SignAmount,	
	D02.S1,	D02.S2, D02.S3, 
	D02.S1 as CI1ID, D02.S2 as CI2ID, D02.S3 as CI3ID, 
	D07.Ana01ID,D07.Ana02ID,D07.Ana03ID,
	D06.VoucherTypeID,
	D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID,
	isnull(D03.IsTemp,0) as IsTemp,
	Case when  KindVoucherID = 3 then 3 else 0 end as KindVoucherID,
	(Case When  D07.TranMonth <10 then '0'+rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) 
	Else rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) End) as MonthYear,
	('0'+ ltrim(rtrim(Case when D07.TranMonth %3 = 0 then D07.TranMonth/3  Else D07.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D07.TranYear)))
	)  as Quarter ,
	str(D07.TranYear) as Year
From AT2007 as D07 inner join AT2006 D06 On D06.VoucherID = D07.VoucherID
			Left join AT1202 on AT1202.ObjectID = D06.ObjectID
		inner join AT1302 as D02 on D02.InventoryID = D07.InventoryID
		inner join AT1304 as D04 on D04.UnitID = D02.UnitID
		inner join AT1303 as D03 on D03.WareHouseID = D06.WareHouseID
		left join AT1303 as  D031 on D031.WareHouseID = D06.WareHouseID2
Where D06.KindVoucherID in (2,3,4,6,8,10)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

