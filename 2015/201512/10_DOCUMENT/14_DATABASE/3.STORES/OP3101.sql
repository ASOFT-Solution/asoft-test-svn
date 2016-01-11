/****** Object:  StoredProcedure [dbo].[OP3101]    Script Date: 01/04/2011 16:08:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created by:Nguyen Thi Thuy Tuyen, date:30/10/2006
----purpose: In Yeu cau mua hang
--- Last edit: Thuy Tuyen date : 24/04/2009  LAy so luong ton kho thu te.
---22/07/2009,30/07/2009
--Edit by: Thuy Tuyen, date 19/05/2010 lay so luong ton kho thuc te theo ngay lap yeu cau mua hang
 /********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/
--Edit by: Mai Duyen, date 20/04/2015: Bo Sung AT1302.Barcode
 
ALTER PROCEDURE [dbo].[OP3101] @DivisionID as nvarchar(50),
				 @TranMonth as int,
				 @TranYear as int,
				 @OrderID as nvarchar(50)
				
AS
Declare @sSQL as nvarchar(max),
		@sSQL1 as  nvarchar (max),
		@OrderDate as datetime

Set  @OrderDate = ( select Orderdate from OT3101 where  OT3101.ROrderID = @OrderID AND DivisionID=@DivisionID)

Set @sSQL = 
'Select Distinct
	OT3101.DivisionID,
	OT3101.ROrderID, 	
	TransactionID, 
	VoucherTypeID, 	
	VoucherNo, 	
	OrderDate,  
	OT3101.Description,
	OT3101.TransPort,
	OT3101.ObjectID, 	
	case when isnull(OT3101.ObjectName, '''') = '''' then AT1202.ObjectName else 
	OT3101.ObjectName end as ObjectName,
	AT1202.Website, AT1202.Contactor,
	AT1202.Tel, AT1202.Fax,  OT3101.ReceivedAddress,  
	isnull(OT3101.Address, AT1202.Address)  as ObjectAddress, 
	AT1002.CityName,
	OT3101.CurrencyID,  AT1004.CurrencyName,
	OT3101.ShipDate, OT3101.ExchangeRate, 
	OT3101.ContractNo, OT3101.ContractDate,
	AT1001.CountryName,  	
	AT1205.PaymentName,		OT3101.EmployeeID, 
	AT1103.FullName, 	AT1103.Address as EmployeeAddress,
	OT3102.InventoryID, 	
	case when isnull(OT3102. InventoryCommonName, '''') = '''' then InventoryName else 
	OT3102.InventoryCommonName end as InventoryName, 
	AT1302.UnitID, 
	AT1304.UnitName, 
	AT1302.Specification,
	AT1302.Notes01 as InNotes01, AT1302.Notes02 as InNotes02,
	AT1310_S1.SName as SName1, AT1310_S2.SName as SName2,
	OrderQuantity, 
	RequestPrice, 
	case when AT1004.Operator = 0 or OT3101.ExchangeRate = 0  then OT3102.RequestPrice*OT3101.ExchangeRate else
	OT3102.RequestPrice/OT3101.ExchangeRate  end as RequestPriceConverted,
	isnull(ConvertedAmount,0) as ConvertedAmount,  
	isnull(OriginalAmount, 0) as OriginalAmount,	
	OT3102.VATPercent,
	VATOriginalAmount,
	OT3102.VATConvertedAmount,
	DiscountPercent, 
	isnull(DiscountConvertedAmount,0) as DiscountConvertedAmount,  
	isnull(DiscountOriginalAmount,0) as DiscountOriginalAmount,
	isnull(OT3102.OriginalAmount, 0) + isnull(OT3102.VATOriginalAmount, 0) - isnull(OT3102.DiscountOriginalAmount, 0) as TotalOriginalAmount,
	isnull(OT3102.ConvertedAmount, 0) + isnull(OT3102.VATConvertedAmount, 0) - isnull(OT3102.DiscountConvertedAmount, 0) as TotalConvertedAmount,
	
	OT3102.Orders,

	OT3101.Ana01ID as OAna01ID ,
	OT3101.Ana02ID as OAna02ID,
	OT3101.Ana03ID  as OAna03ID  ,
	OT3101.Ana04ID  as OAna04ID,
	OT3101.Ana05ID  as OAna05ID,
	OT1002.AnaName as AnaName01,
	AT1302.I02ID, AT1015. AnaName,
	OT3102.Notes, OT3102.Notes01, OT3102.Notes02, A.EndQuantity,
	AT1302.Varchar02, AT1302.Varchar01, AT1302.VArchar03, AT1302.Varchar04, AT1302.Varchar05,
	OT3102.Ana01ID ,
	OT3102.Ana02ID,
	OT3102.Ana03ID,
	OT3102.Ana04ID,
	OT3102.Ana05ID, AT1302.Barcode '
Set @sSQL1 =' From OT3102 left join AT1302 on AT1302.InventoryID= OT3102.InventoryID AND AT1302.DivisionID= OT3102.DivisionID
	inner join OT3101 on OT3101.ROrderID = OT3102.ROrderID AND OT3101.DivisionID = OT3102.DivisionID
	left join OT1002 on OT1002.AnaTypeID =''R01'' and OT1002.AnaID = OT3101.Ana01ID And OT1002.DivisionID = OT3101.DivisionID
	
	left join AT1301 on AT1301.InventoryTypeID = OT3101.InventoryTypeID And  AT1301.DivisionID = OT3101.DivisionID	
	left join AT1304 on AT1304.UnitID = AT1302.UnitID AND 	AT1304.DivisionID = AT1302.DivisionID	
	left join AT1103 on AT1103.EmployeeID = OT3101.EmployeeID	and AT1103.DivisionID = OT3101.DivisionID 
	left join AT1202 on AT1202.ObjectID = OT3101.ObjectID AND AT1202.DivisionID = OT3101.DivisionID
	left join AT1205 on AT1205.PaymentID = OT3101.PaymentID And AT1205.DivisionID = OT3101.DivisionID
	left join AT1004 on AT1004.CurrencyID = OT3101.CurrencyID AND AT1004.DivisionID = OT3101.DivisionID
	left join AT1001 on AT1001.CountryID = AT1202.CountryID AND AT1001.DivisionID = AT1202.DivisionID
	left join AT1002 on AT1002.CityID = AT1202.CityID AND AT1002.DivisionID = AT1202.DivisionID
	left join AT1310  AT1310_S1 on AT1310_S1.STypeID= ''I01'' and AT1310_S1.S = AT1302.S1 AND AT1310_S1.DivisionID = AT1302.DivisionID
	left join AT1310  AT1310_S2 on AT1310_S2.STypeID= ''I02'' and AT1310_S2.S = AT1302.S2 AND AT1310_S2.DivisionID = AT1302.DivisionID
	left Join AT1015 on AT1015.AnaID = AT1302.I02ID AND AT1015.DivisionID = AT1302.DivisionID
	left join ( Select Top 100 Percent DivisionID, InventoryID,	sum(isnull(EndQuantity,0)) as EndQuantity
		From OV2411 Where DivisionID = ''' + @DivisionID + '''  and
				           VoucherDate <= ''' +  convert(nvarchar(10), @OrderDate, 101)  + '''	 -- lay so luong ton kho thu te (khong xet thoi gian OV2401 ,  neu tinh thoi gian OV2411
		Group by DivisionID, InventoryID
		Having  sum(isnull(EndQuantity,0)) <>0
		Order By DivisionID, InventoryID )as A on A.DivisionID = OT3101.DivisionID and 
						          		     	 A.InventoryID = OT3102.InventoryID --and
									----A.WareHouseID = OT3101.Ana01ID
	
Where OT3101.DivisionID = ''' + @DivisionID + ''' and 
	 OT3101.ROrderID = ''' + @OrderID + ''''
print @sSQL
If Not Exists (Select 1 From sysObjects Where Name ='OV3101')
	Exec ('Create view OV3101  ---tao boi OP3101
		as '+@sSQL + @sSQL1)
Else
	Exec( 'Alter view OV3101  ---tao boi OP3101
		as '+@sSQL + @sSQL1)