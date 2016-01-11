
/****** Object:  StoredProcedure [dbo].[OP3015]    Script Date: 12/16/2010 14:40:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created by: Thuy Tuyen, date: 12/05/2008
----Purpose: Tao view in  trang 1 bao cao to khai hai quan( o man hinh OF3015- khi detail vuot qua 3 dong)

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP3015] 	@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@OrderID as nvarchar(50)
				
AS
Declare 	@sSQL as nvarchar(4000)
	
	
Set @sSQL = 
'
Select OT3002.DivisionID, 
	OT3001.POrderID, 	TransactionID, 
	VoucherTypeID, 	
	VoucherNo, 	
	OrderDate,  
	OT3001.Notes as Descrip,
	OT3001.TransPort,
	OT3001.ObjectID, 	
	case when isnull(OT3001.ObjectName, '''') = '''' then AT1202.ObjectName else 
	OT3001.ObjectName end as ObjectName,
	AT1202.Website, AT1202.Contactor,
	AT1202.Tel, AT1202.Fax,  OT3001.ReceivedAddress,  
	isnull(OT3001.Address, AT1202.Address)  as ObjectAddress, 
	AT1002.CityName,
	OT3001.CurrencyID,  AT1004.CurrencyName,
	OT3001.ShipDate, OT3001.ExchangeRate, 
	OT3001.ContractNo, OT3001.ContractDate,
	AT1202.CountryID,
	AT1001.CountryName,  	
	AT1202.AreaID,
	AT1003.AreaName,
	AT1205.PaymentName,		OT3001.EmployeeID, 
	AT1103.FullName, 	AT1103.Address as EmployeeAddress,
	OT3002.InventoryID, 	
	----case when isnull(OT3002. InventoryCommonName, '''') = '''' then InventoryName else 
	OT3002.InventoryName, 
	AT1302.UnitID, 
	AT1304.UnitName, 
OT3002.InventoryName as Specification,
	AT1302.Notes01 as InNotes01, AT1302.Notes02 as InNotes02,

OT3002.InventoryID  as InNotes03,
	AT1310_S1.SName as SName1, AT1310_S2.SName as SName2,
	OT3002.Quantity as OrderQuantity, 
	OT3002.UnitPrice as PurchasePrice, 
	null as PurchasePriceConverted,
	isnull(VATConvertedAmount,0)  as ConvertedAmount,  
	isnull(IMTaxConvertedAmount,0) as IMConvertedAmount,  
	  
	isnull(OriginalAmount, 0) as OriginalAmount,	
	OT3002.VATPercent,
	null as VATOriginalAmount,
	OT3002.VATAMount as VATConvertedAmount,
	null as DiscountPercent, 
Null as DiscountConvertedAmount,  
null as DiscountOriginalAmount,
null as  TotalOriginalAmount,
null as TotalConvertedAmount,
null as IsPicking, 
'''' as WareHouseID, 
'''' as WareHouseName, 
	OT3002.Orders,
'''' TDescription,
	OT3001.Ana01ID,
	OT3001.Ana02ID,
	OT3001.Ana03ID,
	OT1002.AnaName as AnaName01,
	AT1302.I02ID, 
 OT3002.Source as AnaName,
	OT3002.Notes, '''' as Notes01,'''' as Notes02,
	AT1302.Varchar01, AT1302.Varchar02, AT1302.Varchar03, AT1302.varchar04, AT1302.varchar05,
	OT3001.Varchar01 as PVarchar01 ,OT3001.Varchar02 as PVarchar02, OT3001.Varchar03 as PVarchar03, OT3001.Varchar04 as PVarchar04,OT3001.Varchar05 as PVarchar05, 
	OT3001.Varchar06 as PVarchar06, OT3001.Varchar07 as PVarchar07, OT3001.Varchar08 as PVarchar08,OT3001.Varchar09  as PVarchar09, OT3001.Varchar10 as PVarchar10,
	ImTaxpercent, OT3002.ImTaxAMount as ImtaxConvertedAmount,
	TotalTaxConvertedAmount = ( Select Sum ( isnull (ImTaxAmount,0) + isnull (VATAmount,0)) from OT3015  inner join OT3001 on OT3001.POrderID = OT3002.POrderID   Where OT3001.DivisionID = ''' + @DivisionID + ''' and 
	 OT3001.POrderID = '''+ @OrderID +'''  ) ,
OT3002.OtherPercent,
OT3002.OtherAmount,
'''' as AnaName04
	

From  OT3015 OT3002 left join AT1302 on AT1302.InventoryID= OT3002.InventoryID
	inner join OT3001 on OT3001.POrderID = OT3002.POrderID
	left join OT1002 on OT1002.AnaTypeID = ''P01'' and OT1002.AnaID = OT3001.Ana01ID 
	----left join AT1303 on AT1303.WareHouseID = OT3002.WareHouseID and AT1303.DivisionID = OT3001.DivisionID
	left join AT1301 on AT1301.InventoryTypeID = OT3001.InventoryTypeID 	
	left join AT1304 on AT1304.UnitID = AT1302.UnitID		
	left join AT1103 on AT1103.EmployeeID = OT3001.EmployeeID	and AT1103.DivisionID = OT3001.DivisionID 
	left join AT1202 on AT1202.ObjectID = OT3001.ObjectID
	left join AT1205 on AT1205.PaymentID = OT3001.PaymentID
	left join AT1004 on AT1004.CurrencyID = OT3001.CurrencyID
	left join AT1001 on AT1001.CountryID = AT1202.CountryID
	left join AT1003 on AT1003.AreaID = AT1202.AreaID
	
	left join AT1002 on AT1002.CityID = AT1202.CityID
	left join AT1310  AT1310_S1 on AT1310_S1.STypeID= ''I01'' and AT1310_S1.S = AT1302.S1 
	left join AT1310  AT1310_S2 on AT1310_S2.STypeID= ''I02'' and AT1310_S2.S = AT1302.S2
	left Join AT1015 on AT1015.AnaID = AT1302.I02ID  and AT1015. AnaTypeID =''I02''

Where OT3001.DivisionID = ''' + @DivisionID + ''' and 
	 OT3001.POrderID = ''' + @OrderID + ''''

---Print @sSQL

If Not Exists (Select 1 From sysObjects Where Name ='OV3050')
	Exec ('Create view OV3050  ---tao boi OP3015
		as '+@sSQL)
Else
	Exec( 'Alter view OV3050  ---tao boi OP3015
		as '+@sSQL)