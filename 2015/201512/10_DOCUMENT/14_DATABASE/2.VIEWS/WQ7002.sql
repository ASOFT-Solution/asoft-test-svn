
/****** Object:  View [dbo].[WQ7002]    Script Date: 12/16/2010 15:43:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Creater:  Thuy Tuyen.
--Date:  31/03/2010
-- View chet. Xu ly so du hang ton kho cho DVT qui doi
----Edit: Thuy Tuyen, date : 13/04/2010
----Them truong parameterID

ALTER VIEW [dbo].[WQ7002] as 
--- So du No cua tai khoan ton kho
Select distinct  D17.DivisionID, D17.TranMonth, D17.TranYear,
	D16.WareHouseID, D17.InventoryID, D17.DebitAccountID, D17.CreditAccountID,
	'BD' as D_C,  --- So du No
	'' as RefNo01, '' as RefNo02, 	D17.Notes,
	D16.VoucherID, D16.VoucherDate, D16.VoucherNo, 
	D16.ObjectID,AT1202.ObjectName,
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID, D02.VATPercent,
	 D03.WareHouseName,	
	ActualQuantity, 
	ConvertedAmount,
	ActualQuantity as SignQuantity, 
	ConvertedAmount as SignAmount,	
	D02.S1,	D02.S2, D02.S3 ,
	D02.S1 as CI1ID, D02.S2 as CI2ID, D02.S3 as CI3ID, 
	D17.Ana01ID,D17.Ana02ID,D17.Ana03ID, D17.Ana04ID,D17.Ana05ID,
	D16.VoucherTypeID,
	S1.SName As S1Name,
	S2.SName As S2Name,
	S3.SName As S3Name,
	D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID, D02.Specification, 
	D02.Notes01, D02.Notes02, D02.Notes03,
	I1.AnaName as  InAnaName1, 
	I2.AnaName as  InAnaName2, 
	I3.AnaName as  InAnaName3, 
	I4.AnaName as  InAnaName4, 
	I5.AnaName as  InAnaName5, 
	isnull(D03.IsTemp,0) as IsTemp,
	0 as 	 KindVoucherID,
	(Case When  D17.TranMonth <10 then '0'+rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) 
	Else rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) End) as MonthYear,
	('0'+ ltrim(rtrim(Case when D17.TranMonth %3 = 0 then D17.TranMonth/3  Else D17.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D17.TranYear)))
	)  as Quarter ,
	str(D17.TranYear) as Year,D17.SourceNo,
	---Thong tin DVT qui doi
	 Parameter01,  Parameter02,   Parameter03,  Parameter04,   Parameter05,
		D17.InventoryID+'T01'+ cast (isnull(Parameter01,0) as varchar)  +   'T02'+ cast (isnull(Parameter02,0) as varchar)
	+  'T03'+ cast (isnull(Parameter03,0) as varchar)  + 'T04'+  cast (isnull(Parameter04,0) as varchar)   +  'T05'+  cast (isnull(Parameter03,0) as varchar)   as ParameterID,
	CASE WHEN D17.UnitID = D17.ConvertedUnitID THEN NULL ELSE D17.ConvertedUnitID END AS ConvertedUnitID, D05.UnitName  AS ConvertedUnitName,
	D17.ConvertedQuantity , D17.ConvertedQuantity AS  SignConvertedQuantity, D17.ConvertedPrice

From AT2017 as D17 inner join AT2016 as D16 On D16.VoucherID = D17.VoucherID and D16.DivisionID = D17.DivisionID
			Left join AT1202 on AT1202.ObjectID = D16.ObjectID and AT1202.DivisionID = D17.DivisionID
		inner join AT1302 as D02 on D02.InventoryID = D17.InventoryID and D02.DivisionID = D17.DivisionID
		inner join AT1304 as D04 on D04.UnitID = D02.UnitID and D04.DivisionID = D17.DivisionID
		inner join AT1303 as D03 on D03.WareHouseID = D16.WareHouseID and D03.DivisionID = D17.DivisionID
		Left join AT1310 S1 on 	S1.STypeID = 'I01' and
					S1.S = D02.S1 and S1.DivisionID = D17.DivisionID
		Left join AT1310 S2 on 	S2.STypeID = 'I02' and
					S2.S = D02.S2 and S2.DivisionID = D17.DivisionID
		Left join AT1310 S3 on 	S3.STypeID = 'I03' and
					S3.S = D02.S3 and S3.DivisionID = D17.DivisionID
		Left join AT1015 I1 on 	I1.AnaTypeID = 'I01' and
					I1.AnaID = D02.I01ID and I1.DivisionID = D17.DivisionID
		Left join AT1015 I2 on 	I2.AnaTypeID = 'I02' and
					I2.AnaID = D02.I02ID and I2.DivisionID = D17.DivisionID
		Left join AT1015 I3 on 	I3.AnaTypeID = 'I01' and
					I3.AnaID = D02.I03ID and I3.DivisionID = D17.DivisionID
		Left join AT1015 I4 on 	I4.AnaTypeID = 'I04' and
					I4.AnaID = D02.I04ID and I4.DivisionID = D17.DivisionID
		Left join AT1015 I5 on 	I5.AnaTypeID = 'I05' and
					I5.AnaID = D02.I05ID and I5.DivisionID = D17.DivisionID
		left join AT1304 as D05 on D05.UnitID = CASE WHEN D17.UnitID = D17.ConvertedUnitID THEN NULL ELSE D17.ConvertedUnitID END and D05.DivisionID = D17.DivisionID


Where isnull(DebitAccountID,'') <>''

Union All --- So du co hang ton kho

Select distinct  D17.DivisionID, D17.TranMonth, D17.TranYear,
	D16.WareHouseID, D17.InventoryID, D17.DebitAccountID, D17.CreditAccountID,
	'BC' as D_C,  --- So du Co
	'' as RefNo01, '' as RefNo02, 	D17.Notes,
	D16.VoucherID, D16.VoucherDate, D16.VoucherNo, 
	D16.ObjectID,AT1202.ObjectName, 	
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID , D02.VATPercent,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedAmount,
	-ActualQuantity as SignQuantity, 
	-ConvertedAmount as SignAmount,	
	D02.S1,	D02.S2, D02.S3 ,
	D02.S1 as CI1ID, D02.S2 as CI2ID, D02.S3 as CI3ID, 
	D17.Ana01ID,D17.Ana02ID,D17.Ana03ID, D17.Ana04ID,D17.Ana05ID,
	D16.VoucherTypeID,
	S1.SName As S1Name,
	S2.SName As S2Name,

	S3.SName As S3Name,
	D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID, D02.Specification,
	D02.Notes01, D02.Notes02, D02.Notes03,
	I1.AnaName as  InAnaName1, 
	I2.AnaName as  InAnaName2, 
	I3.AnaName as  InAnaName3, 
	I4.AnaName as  InAnaName4, 
	I5.AnaName as  InAnaName5, 
	isnull(D03.IsTemp,0) as IsTemp,
	0 as KindVoucherID,
(Case When  D17.TranMonth <10 then '0'+rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) 
	Else rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) End) as MonthYear,
	('0'+ ltrim(rtrim(Case when D17.TranMonth %3 = 0 then D17.TranMonth/3  Else D17.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D17.TranYear)))
	)  as Quarter ,
	str(D17.TranYear) as Year, D17.SourceNo,

---Thong tin DVT qui doi
	 Parameter01,  Parameter02,   Parameter03,  Parameter04,   Parameter05,
	D17.InventoryID+'T01'+ cast (isnull(Parameter01,0) as varchar)  +   'T02'+ cast (isnull(Parameter02,0) as varchar)
	+  'T03'+ cast (isnull(Parameter03,0) as varchar)  + 'T04'+  cast (isnull(Parameter04,0) as varchar)   +  'T05'+  cast (isnull(Parameter03,0) as varchar)   as ParameterID,
	CASE WHEN D17.UnitID = D17.ConvertedUnitID THEN NULL ELSE D17.ConvertedUnitID END AS ConvertedUnitID, D05.UnitName  AS ConvertedUnitName,
	D17.ConvertedQuantity , -  D17.ConvertedQuantity AS  SignConvertedQuantity, D17.ConvertedPrice

From AT2017 as D17 inner join AT2016 as D16 On D16.VoucherID = D17.VoucherID and  D16.DivisionID = D17.DivisionID
		Left join AT1202 on AT1202.ObjectID = D16.ObjectID and  AT1202.DivisionID = D17.DivisionID
		inner join AT1302 as D02 on D02.InventoryID = D17.InventoryID and  D02.DivisionID = D17.DivisionID
		inner join AT1304 as D04 on D04.UnitID = D02.UnitID and  D04.DivisionID = D17.DivisionID
		inner join AT1303 as D03 on D03.WareHouseID = D16.WareHouseID and  D03.DivisionID = D17.DivisionID
		Left join AT1310 S1 on 	S1.STypeID = 'I01' and
					S1.S = D02.S1 and  S1.DivisionID = D17.DivisionID
		Left join AT1310 S2 on 	S2.STypeID = 'I02' and
					S2.S = D02.S2 and  S2.DivisionID = D17.DivisionID
		Left join AT1310 S3 on 	S3.STypeID = 'I03' and
					S3.S = D02.S3 and  S3.DivisionID = D17.DivisionID
		Left join AT1015 I1 on 	I1.AnaTypeID = 'I01' and
					I1.AnaID = D02.I01ID and  I1.DivisionID = D17.DivisionID
		Left join AT1015 I2 on 	I2.AnaTypeID = 'I02' and
					I2.AnaID = D02.I02ID and  I2.DivisionID = D17.DivisionID
		Left join AT1015 I3 on 	I3.AnaTypeID = 'I01' and
					I3.AnaID = D02.I03ID and  I3.DivisionID = D17.DivisionID
		Left join AT1015 I4 on 	I4.AnaTypeID = 'I04' and
					I4.AnaID = D02.I04ID and  I4.DivisionID = D17.DivisionID
		Left join AT1015 I5 on 	I5.AnaTypeID = 'I05' and
					I5.AnaID = D02.I05ID and  I5.DivisionID = D17.DivisionID
		left join AT1304 as D05 on D05.UnitID = CASE WHEN D17.UnitID = D17.ConvertedUnitID THEN NULL ELSE D17.ConvertedUnitID END and  D05.DivisionID = D17.DivisionID

Where isnull(CreditAccountID,'') <>''

Union All  -- Nhap kho

Select distinct  D07.DivisionID, D07.TranMonth, D07.TranYear,
	D06.WareHouseID, 
	D07.InventoryID, D07.DebitAccountID, D07.CreditAccountID,
	'D' as D_C,  --- Phat sinh No
	RefNo01 as RefNo01, RefNo02, 	D07.Notes,
	D06.VoucherID, D06.VoucherDate, D06.VoucherNo, 
	D06.ObjectID,AT1202.ObjectName,
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID , D02.VATPercent,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedAmount,
	ActualQuantity as SignQuantity, 
	ConvertedAmount as SignAmount,	
	D02.S1,	D02.S2, D02.S3, 
	D02.S1 as CI1ID, D02.S2 as CI2ID, D02.S3 as CI3ID, 
	D07.Ana01ID,D07.Ana02ID,D07.Ana03ID, D07.Ana04ID,D07.Ana05ID,
	D06.VoucherTypeID,
	S1.SName As S1Name,
	S2.SName As S2Name,
	S3.SName As S3Name,
	D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID, D02.Specification,
	D02.Notes01, D02.Notes02, D02.Notes03,
	I1.AnaName as  InAnaName1, 
	I2.AnaName as  InAnaName2, 
	I3.AnaName as  InAnaName3, 
	I4.AnaName as  InAnaName4, 
	I5.AnaName as  InAnaName5, 

	isnull(D03.IsTemp,0) as IsTemp,
	Case when  KindVoucherID = 3 then 3 else 0 end as KindVoucherID,
	(Case When  D07.TranMonth <10 then '0'+rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) 
	Else rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) End) as MonthYear,
	('0'+ ltrim(rtrim(Case when D07.TranMonth %3 = 0 then D07.TranMonth/3  Else D07.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D07.TranYear)))
	)  as Quarter ,
	str(D07.TranYear) as Year, D07.SourceNo,
	D07.Parameter01,D07.Parameter02, D07.Parameter03,D07.Parameter04, D07.Parameter05,
	D07.InventoryID+'T01'+ cast (isnull(Parameter01,0) as varchar)  +   'T02'+ cast (isnull(Parameter02,0) as varchar)
	+  'T03'+ cast (isnull(Parameter03,0) as varchar)  + 'T04'+  cast (isnull(Parameter04,0) as varchar)   +  'T05'+  cast (isnull(Parameter03,0) as varchar)   as ParameterID,
	CASE WHEN D07.UnitID = D07.ConvertedUnitID THEN NULL ELSE D07.ConvertedUnitID END AS ConvertedUnitID,  D05.UnitName as ConvertedUnitName,
	D07.ConvertedQuantity,D07.ConvertedQuantity as SignQuantityC, D07.ConvertedPrice

From AT2007 as D07 inner join AT2006 D06 On D06.VoucherID = D07.VoucherID and D06.DivisionID = D07.DivisionID
			Left join AT1202 on AT1202.ObjectID = D06.ObjectID and AT1202.DivisionID = D07.DivisionID
		inner join AT1302 as D02 on D02.InventoryID = D07.InventoryID and D02.DivisionID = D07.DivisionID
		inner join AT1304 as D04 on D04.UnitID = D02.UnitID and D04.DivisionID = D07.DivisionID
		inner join AT1303 as D03 on D03.WareHouseID = D06.WareHouseID and D03.DivisionID = D07.DivisionID
		Left join AT1310 S1 on 	S1.STypeID = 'I01' and
					S1.S = D02.S1 and S1.DivisionID = D07.DivisionID
		Left join AT1310 S2 on 	S2.STypeID = 'I02' and
					S2.S = D02.S2 and S2.DivisionID = D07.DivisionID
		Left join AT1310 S3 on 	S3.STypeID = 'I03' and
					S3.S = D02.S3 and S3.DivisionID = D07.DivisionID
		Left join AT1015 I1 on 	I1.AnaTypeID = 'I01' and
					I1.AnaID = D02.I01ID and I1.DivisionID = D07.DivisionID
		Left join AT1015 I2 on 	I2.AnaTypeID = 'I02' and

					I2.AnaID = D02.I02ID and I2.DivisionID = D07.DivisionID
		Left join AT1015 I3 on 	I3.AnaTypeID = 'I01' and
					I3.AnaID = D02.I03ID and I3.DivisionID = D07.DivisionID
		Left join AT1015 I4 on 	I4.AnaTypeID = 'I04' and
					I4.AnaID = D02.I04ID and I4.DivisionID = D07.DivisionID
		Left join AT1015 I5 on 	I5.AnaTypeID = 'I05' and
					I5.AnaID = D02.I05ID and I5.DivisionID = D07.DivisionID
		left join AT1304 as D05 on D05.UnitID = CASE WHEN D07.UnitID = D07.ConvertedUnitID THEN NULL ELSE D07.ConvertedUnitID END and D05.DivisionID = D07.DivisionID

Where D06.KindVoucherID in (1,3,5,7,9,15,17)

Union All  -- xuat kho
Select distinct  D07.DivisionID, D07.TranMonth, D07.TranYear,
	Case when D06.KindVoucherID = 3 then D06.WareHouseID2 Else  D06.WareHouseID End as WareHouseID, 
	D07.InventoryID, D07.DebitAccountID, D07.CreditAccountID,
	'C' as D_C,  --- So du Co
	RefNo01 as RefNo01, RefNo02, 	D07.Notes,
	D06.VoucherID, D06.VoucherDate, D06.VoucherNo, 
	D06.ObjectID,AT1202.ObjectName, 	
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID , D02.VATPercent,

	Case when D06.KindVoucherID = 3 then D031.WareHouseName Else  D03.WareHouseName End  as WareHouseName,	

	ActualQuantity, 
	ConvertedAmount,
	-ActualQuantity as SignQuantity, 
	-ConvertedAmount as SignAmount,	
	D02.S1,	D02.S2, D02.S3, 
	D02.S1 as CI1ID, D02.S2 as CI2ID, D02.S3 as CI3ID, 
	D07.Ana01ID,D07.Ana02ID,D07.Ana03ID, D07.Ana04ID,D07.Ana05ID,
	D06.VoucherTypeID,
	S1.SName As S1Name,
	S2.SName As S2Name,
	S3.SName As S3Name,
	D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID, D02.Specification,
	D02.Notes01, D02.Notes02, D02.Notes03,
	I1.AnaName as  InAnaName1, 
	I2.AnaName as  InAnaName2, 
	I3.AnaName as  InAnaName3, 
	I4.AnaName as  InAnaName4, 
	I5.AnaName as  InAnaName5, 

	isnull(D03.IsTemp,0) as IsTemp,
	Case when  KindVoucherID = 3 then 3 else 0 end as KindVoucherID,
	(Case When  D07.TranMonth <10 then '0'+rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) 
	Else rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) End) as MonthYear,
	('0'+ ltrim(rtrim(Case when D07.TranMonth %3 = 0 then D07.TranMonth/3  Else D07.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D07.TranYear)))
	)  as Quarter ,
	str(D07.TranYear) as Year, D07.SourceNo,
	D07.Parameter01,D07.Parameter02, D07.Parameter03,D07.Parameter04, D07.Parameter05,
	D07.InventoryID+'T01'+ cast (isnull(Parameter01,0) as varchar)  +   'T02'+ cast (isnull(Parameter02,0) as varchar)
	+  'T03'+ cast (isnull(Parameter03,0) as varchar)  + 'T04'+  cast (isnull(Parameter04,0) as varchar)   +  'T05'+  cast (isnull(Parameter03,0) as varchar)   as ParameterID,
	CASE WHEN D07.UnitID = D07.ConvertedUnitID THEN NULL ELSE D07.ConvertedUnitID END,  D05.UnitName as ConvertedUnitName,
	D07.ConvertedQuantity, -D07.ConvertedQuantity as SignQuantityC, D07.ConvertedPrice

From AT2007 as D07 inner join AT2006 D06 On D06.VoucherID = D07.VoucherID and D06.DivisionID = D07.DivisionID
			Left join AT1202 on AT1202.ObjectID = D06.ObjectID and AT1202.DivisionID = D07.DivisionID
		inner join AT1302 as D02 on D02.InventoryID = D07.InventoryID and D02.DivisionID = D07.DivisionID
		inner join AT1304 as D04 on D04.UnitID = D02.UnitID and D04.DivisionID = D07.DivisionID
		inner join AT1303 as D03 on D03.WareHouseID = D06.WareHouseID and D03.DivisionID = D07.DivisionID
		left join AT1303 as  D031 on D031.WareHouseID = D06.WareHouseID2 and D031.DivisionID = D07.DivisionID
		Left join AT1310 S1 on 	S1.STypeID = 'I01' and
					S1.S = D02.S1 and S1.DivisionID = D07.DivisionID
		Left join AT1310 S2 on 	S2.STypeID = 'I02' and
					S2.S = D02.S2 and S2.DivisionID = D07.DivisionID
		Left join AT1310 S3 on 	S3.STypeID = 'I03' and
					S3.S = D02.S3 and S3.DivisionID = D07.DivisionID
		Left join AT1015 I1 on 	I1.AnaTypeID = 'I01' and
					I1.AnaID = D02.I01ID and I1.DivisionID = D07.DivisionID
		Left join AT1015 I2 on 	I2.AnaTypeID = 'I02' and
					I2.AnaID = D02.I02ID and I2.DivisionID = D07.DivisionID
		Left join AT1015 I3 on 	I3.AnaTypeID = 'I01' and
					I3.AnaID = D02.I03ID and I3.DivisionID = D07.DivisionID
		Left join AT1015 I4 on 	I4.AnaTypeID = 'I04' and
					I4.AnaID = D02.I04ID and I4.DivisionID = D07.DivisionID
		Left join AT1015 I5 on 	I5.AnaTypeID = 'I05' and
					I5.AnaID = D02.I05ID and I5.DivisionID = D07.DivisionID
		left join AT1304 as D05 on D05.UnitID = CASE WHEN D07.UnitID = D07.ConvertedUnitID THEN NULL ELSE D07.ConvertedUnitID END and D05.DivisionID = D07.DivisionID

Where D06.KindVoucherID in (2,3,4,6,8,10,14,20)

GO


