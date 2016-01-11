IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3011]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP3011]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



----Created by: Vo Thanh Huong, date: 16/11/2004
----purpose: In don hang  mua
------ Thuy Tuyen edit: 24/01/2008
----Edit by: Dang Le Bao Quynh; Date 02/04/2008
----Purpose: Tao view in bao cao to khai hai quan
-- Last Edit Thuy Tuyen, date 25/08/2008, 29/08/2008, 05/06/2009,18/06/2009,26/06/2009,10/07/2009
--- Last edit B.Anh, date 30/11/2009	Lay them truong SL, DG, DVT quy doi
--- Edit by B.Anh, date 05/12/2009	Lay them truong OrderStatus, OrderStatusName
--- Edit by B.Anh, date 18/01/2010	Lay them truong RequestID

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/
--- Edit by B.Anh, date 17/07/2012	Lay them truong
--- Edit by T.Oanh, date 24/01/2014	Lay them truong AT1202.VATNo
--- Edit by Trí Thiện, date 12/11/2014	Bổ sung GROUP BY cho trường hợp tạo VIEW OV3055 với số lượng chi tiết OV3054 lớn hơn 3
--- Edit by Mai Duyen, date 20/04/2015	Bổ sung AT1302.BarCode
--- Edit by Tiểu Mai, date 07/09/2015 Bổ sung Mã và tên mã phân tích 06->10
--- Edit by Tiểu Mai, date 21/09/2015 Bổ sung trường LicenseNo
CREATE PROCEDURE [dbo].[OP3011] 	@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@OrderID as nvarchar(50)
				
AS
SET NOCOUNT ON
Declare 	@sSQLSelect nvarchar(max),
			@sSQLFrom as nvarchar(MAX),
			@sSQL as nvarchar(MAX),
			@For as int,
			@FieldCount as int,
			@NullRowInsert as nvarchar(1000),
			@RemainRows as int,
			@IsSubForm as tinyint,
			@IsEdit  as TINYINT,
			@sSQLFrom1 as nvarchar(MAX)
	---@Quantity as Money,
	---@OriginalAmount as money 
 	
set @sSQLSelect = 
N'Select OT3002.DivisionID,
	OT3001.POrderID, 	TransactionID, 
	Ot3001.VoucherTypeID, 	
	OT3001.VoucherNo, 	
	Ot3001.OrderDate,  
	OT3001.Notes as Description,
	OT3001.TransPort,
	OT3001.ObjectID, 	
	case when isnull(OT3001.ObjectName, '''') = '''' then AT1202.ObjectName else OT3001.ObjectName end as ObjectName,
	AT1202.Website, AT1202.Contactor, AT1202.Email as ObjectEmail, AT1202.LicenseNo,
	AT1202.Tel, AT1202.Fax, AT1202.VATNo,  OT3001.ReceivedAddress,  
	isnull(OT3001.Address, AT1202.Address)  as ObjectAddress, 
	AT1202.BankName as ObjectBankName, AT1202.BankAddress as ObjectBankAddress, AT1202.BankAccountNo as ObjectBankAccountNo, 
	AT1202.Note as ObjectNote1, AT1202.Note1 as ObjectNote2,
	AT1002.CityName,AT1202.Email,
	OT3001.CurrencyID,  AT1004.CurrencyName,
	OT3001.ShipDate, OT3001.ExchangeRate, 
	OT3001.ContractNo, OT3001.ContractDate,
	AT1202.CountryID,
	AT1001.CountryName,  	
	AT1202.AreaID,
	AT1003.AreaName,
	AT1205.PaymentName,		
	OT3001.EmployeeID, AT1103.FullName, AT1103.Address as EmployeeAddress, AT1103.HireDate as EmployeeHireDate, AT1103.EndDate as EmployeeEndDate, AT1103.BirthDay as EmployeeBirthDay, AT1103.Tel as EmployeeTel, AT1103.Fax as EmployeeFax, AT1103.Email as EmployeeEmail,
	OT3002.InventoryID, 	
	case when isnull(OT3002. InventoryCommonName, '''') = '''' then InventoryName else 
	OT3002.InventoryCommonName end as InventoryName, 
	AT1302.UnitID, 
	AT1304.UnitName, 
	AT1302.Specification,
	AT1302.Notes01 as InNotes01, AT1302.Notes02 as InNotes02,AT1302.Notes03 as InNotes03,
	AT1310_S1.SName as SName1, AT1310_S2.SName as SName2,
	OrderQuantity, 
	PurchasePrice, 
	case when AT1004.Operator = 0 or OT3001.ExchangeRate = 0  then OT3002.PurchasePrice*OT3001.ExchangeRate else
	OT3002.PurchasePrice/OT3001.ExchangeRate  end as PurchasePriceConverted,
	isnull(ConvertedAmount,0) as ConvertedAmount,  
	isnull(ConvertedAmount,0) as IMConvertedAmount,  
	----isnull(ConvertedAmount,0) as VATConvertedAmount,  
	isnull(OriginalAmount, 0) as OriginalAmount,	
	OT3002.VATPercent,
	VATOriginalAmount,
	OT3002.VATConvertedAmount,
	DiscountPercent, 
	isnull(DiscountConvertedAmount,0) as DiscountConvertedAmount,  
	isnull(DiscountOriginalAmount,0) as DiscountOriginalAmount,
	isnull(OT3002.OriginalAmount, 0) + isnull(OT3002.VATOriginalAmount, 0) - isnull(OT3002.DiscountOriginalAmount, 0) as TotalOriginalAmount,
	isnull(OT3002.ConvertedAmount, 0) + isnull(OT3002.VATConvertedAmount, 0) - isnull(OT3002.DiscountConvertedAmount, 0) as TotalConvertedAmount,
	IsPicking, 
	OT3002.WareHouseID, 
	WareHouseName, 
	OT3002.Orders,
	OT3002.Description as TDescription,
	OT3001.Ana01ID,
	OT3001.Ana02ID,
	OT3001.Ana03ID,
	OT3001.Ana04ID,
	OT3001.Ana05ID,
	P01.AnaName as PO01AnaName,
	P02.AnaName as PO02AnaName,
	P03.AnaName as PO03AnaName,
	P04.AnaName as PO04AnaName,
	P05.AnaName as PO05AnaName,
	
	OT3002.Ana01ID as TAna01ID,
	OT3002.Ana02ID as TAna02ID,
	OT3002.Ana03ID as TAna03ID,
	OT3002.Ana04ID as TAna04ID,
	OT3002.Ana05ID as TAna05ID,
	
	A01.AnaName as A01AnaName,
	A02.AnaName as A02AnaName,
	A03.AnaName as A03AnaName,
	A04.AnaName as A04AnaName,
	A05.AnaName as A05AnaName,
	
	OT3002.Ana06ID as TAna06ID,
	OT3002.Ana07ID as TAna07ID,
	OT3002.Ana08ID as TAna08ID,
	OT3002.Ana09ID as TAna09ID,
	OT3002.Ana10ID as TAna10ID,
	
	A06.AnaName as A06AnaName,
	A07.AnaName as A07AnaName,
	A08.AnaName as A08AnaName,
	A09.AnaName as A09AnaName,
	A10.AnaName as A10AnaName,
	
	AT1302.I01ID, 
	AT1302.I02ID, 
	AT1302.I03ID, 
	AT1302.I04ID, 
	AT1302.I05ID, 
	
	I01.AnaName as I01AnaName,
	I02.AnaName as I02AnaName,
	I03.AnaName as I03AnaName,
	I04.AnaName as I04AnaName,
	I05.AnaName as I05AnaName,
	
	AT1015. AnaName,
	isnull(OT3002.Notes02,  T03. AnaName) as AnaName03,

	OT3002.Notes, OT3002.Notes01, OT3002.Notes02,
	
'
Set @sSQL =  
N'	AT1302.Varchar01 as InventoryVarchar01, AT1302.Varchar02 as InventoryVarchar02, AT1302.Varchar03 as InventoryVarchar03, AT1302.varchar04 as InventoryVarchar04, AT1302.varchar05 as InventoryVarchar05,
	OT3001.Varchar01 as PVarchar01 ,OT3001.Varchar02 as PVarchar02, OT3001.Varchar03 as PVarchar03, OT3001.Varchar04 as PVarchar04,OT3001.Varchar05 as PVarchar05, 
	OT3001.Varchar06 as PVarchar06, OT3001.Varchar07 as PVarchar07, OT3001.Varchar08 as PVarchar08,OT3001.Varchar09  as PVarchar09, OT3001.Varchar10 as PVarchar10,
	OT3001.Varchar11 as PVarchar11 ,OT3001.Varchar12 as PVarchar12, OT3001.Varchar13 as PVarchar13, OT3001.Varchar14 as PVarchar14,OT3001.Varchar15 as PVarchar15, 
	OT3001.Varchar16 as PVarchar16, OT3001.Varchar17 as PVarchar17, OT3001.Varchar18 as PVarchar18,OT3001.Varchar19  as PVarchar19, OT3001.Varchar20 as PVarchar20,
	ImTaxpercent,ImTaxOriginalAmount,ImtaxConvertedAmount,
	TotalTaxConvertedAmount = ( Select Sum ( isnull (ImTaxConvertedAmount,0) + isnull (VATConvertedAmount,0)) from OT3002  inner join OT3001 on OT3001.POrderID = OT3002.POrderID Where OT3001.DivisionID = ''' + isnull(@DivisionID,'') + ''' and 
	OT3001.POrderID = N''' + isnull(@OrderID,'') + N'''  ) ,
	null as OtherPercent,
	Null as OtherAmount,
	T04.AnaName as  AnaName04,

	OT3101.ROrderID,
	OT3101.OrderDate as ROrderDate , OT3101.Shipdate as RShipdate,
	OT3002.Quantity01,
	OT3002.Quantity02,
	OT3002.Quantity03,
	OT3002.Quantity04,
	OT3002.Quantity05,
	OT3002.Quantity06,
	OT3003.Date01,
	OT3003.Date02,	
	OT3003.Date03,
	OT3003.Date04,
	OT3003.Date05,
	OT3003.Date06,
	OT3003.Date07,	
	OT3003.Date08,
	OT3003.Date09,
	OT3003.Date10,
	OT3002.ConvertedQuantity,
	OT3002.ConvertedSalePrice,
	OT3002.UnitID as ConvertedUnitID,
	T34.UnitName as ConvertedUnitName,
	OT3001.OrderStatus, OV1101.Description as OrderStatusName, OV1101.Description as OrderStatusNameE,
	OT3001.RequestID
	, OT3001.ClassifyID, OT1001.ClassifyName, OT1001.Note as ClassifyNote,
	OT3001.PaymentTermID, AT1208.PaymentTermName,
	P01.AnaNameE as PO01AnaNameE,
	P02.AnaNameE as PO02AnaNameE,
	P03.AnaNameE as PO03AnaNameE,
	P04.AnaNameE as PO04AnaNameE,
	P05.AnaNameE as PO05AnaNameE,
	OT3001.Varchar01, OT3001.Varchar02, OT3001.Varchar03, OT3001.Varchar04, OT3001.Varchar05,
	OT3001.Varchar06, OT3001.Varchar07, OT3001.Varchar08, OT3001.Varchar09, OT3001.Varchar10,
	OT3001.Varchar11, OT3001.Varchar12, OT3001.Varchar13, OT3001.Varchar14, OT3001.Varchar15,
	OT3001.Varchar16, OT3001.Varchar17, OT3001.Varchar18, OT3001.Varchar19, OT3001.Varchar20,
	AT1302.Barcode, OT3002.StrParameter01, OT3002.StrParameter02, OT3002.StrParameter03, OT3002.StrParameter04, 
	OT3002.StrParameter05, OT3002.StrParameter06, OT3002.StrParameter07, OT3002.StrParameter08, OT3002.StrParameter09, 
	OT3002.StrParameter10
'
Set @sSQLFrom =  
N'  From OT3002 left join AT1302 on AT1302.InventoryID= OT3002.InventoryID and AT1302.DivisionID= OT3002.DivisionID
	inner join OT3001 on OT3001.POrderID = OT3002.POrderID and OT3001.DivisionID= OT3002.DivisionID
	left join AT1303 on AT1303.WareHouseID = OT3002.WareHouseID and AT1303.DivisionID = OT3001.DivisionID
	left join AT1301 on AT1301.InventoryTypeID = OT3001.InventoryTypeID 	 and AT1301.DivisionID= OT3002.DivisionID
	left join AT1304 on AT1304.UnitID = AT1302.UnitID		 and AT1304.DivisionID= OT3002.DivisionID
	left join AT1103 on AT1103.EmployeeID = OT3001.EmployeeID	and AT1103.DivisionID = OT3001.DivisionID 
	left join AT1202 on AT1202.ObjectID = OT3001.ObjectID and AT1202.DivisionID= OT3002.DivisionID
	left join AT1205 on AT1205.PaymentID = OT3001.PaymentID and AT1205.DivisionID= OT3002.DivisionID
	left join AT1004 on AT1004.CurrencyID = OT3001.CurrencyID and AT1004.DivisionID= OT3002.DivisionID
	left join AT1001 on AT1001.CountryID = AT1202.CountryID and AT1001.DivisionID= OT3002.DivisionID
	left join AT1003 on AT1003.AreaID = AT1202.AreaID	 and AT1003.DivisionID= OT3002.DivisionID
	left join AT1002 on AT1002.CityID = AT1202.CityID and AT1002.DivisionID= OT3002.DivisionID
	left join AT1310 AT1310_S1 on AT1310_S1.STypeID= ''I01'' and AT1310_S1.S = AT1302.S1  and AT1310_S1.DivisionID= OT3002.DivisionID
	left join AT1310 AT1310_S2 on AT1310_S2.STypeID= ''I02'' and AT1310_S2.S = AT1302.S2 and AT1310_S2.DivisionID= OT3002.DivisionID
	left Join AT1015 on AT1015.AnaID = AT1302.I02ID  and AT1015. AnaTypeID =''I02'' and AT1015.DivisionID= OT3002.DivisionID
	left Join AT1015 T03 on T03.AnaID = AT1302.I03ID  and T03. AnaTypeID =''I03'' and T03.DivisionID= OT3002.DivisionID
	left Join AT1015 T04 on T04.AnaID = AT1302.I04ID  and  T04. AnaTypeID =''I04'' and T04.DivisionID= OT3002.DivisionID
	left join  OT3101 On OT3002.ROrderID = OT3101.ROrderID and OT3101.DivisionID= OT3002.DivisionID
	left  join OT3003 on OT3003.POrderID = OT3002.POrderID and OT3003.DivisionID= OT3002.DivisionID
	left join AT1304 T34 on T34.UnitID = OT3002.UnitID and T34.DivisionID= OT3002.DivisionID
	left join OV1101 on OT3001.OrderStatus = OV1101.OrderStatus and OV1101.TypeID=''PO''		 and OV1101.DivisionID= OT3002.DivisionID
	Left Join OT1001 on IsNull(OT1001.Disabled,0) = 0 And OT1001.TypeID = N''PO'' And OT1001.ClassifyID = OT3001.ClassifyID And OT1001.DivisionID = OT3002.DivisionID
'
SET @sSQLFrom1 =  
N'	left join OT1002 P01 on P01.AnaTypeID = ''P01'' and P01.AnaID = OT3001.Ana01ID  and P01.DivisionID= OT3002.DivisionID
	left join OT1002 P02 on P02.AnaTypeID = ''P02'' and P02.AnaID = OT3001.Ana02ID  and P02.DivisionID= OT3002.DivisionID
	left join OT1002 P03 on P03.AnaTypeID = ''P03'' and P03.AnaID = OT3001.Ana03ID  and P03.DivisionID= OT3002.DivisionID
	left join OT1002 P04 on P04.AnaTypeID = ''P04'' and P04.AnaID = OT3001.Ana04ID  and P04.DivisionID= OT3002.DivisionID
	left join OT1002 P05 on P05.AnaTypeID = ''P05'' and P05.AnaID = OT3001.Ana05ID  and P05.DivisionID= OT3002.DivisionID
		
	left join AT1011 A01 on A01.AnaTypeID = ''A01'' and A01.AnaID = OT3002.Ana01ID  and A01.DivisionID= OT3002.DivisionID
	left join AT1011 A02 on A02.AnaTypeID = ''A02'' and A02.AnaID = OT3002.Ana02ID  and A02.DivisionID= OT3002.DivisionID
	left join AT1011 A03 on A03.AnaTypeID = ''A03'' and A03.AnaID = OT3002.Ana03ID  and A03.DivisionID= OT3002.DivisionID
	left join AT1011 A04 on A04.AnaTypeID = ''A04'' and A04.AnaID = OT3002.Ana04ID  and A04.DivisionID= OT3002.DivisionID
	left join AT1011 A05 on A05.AnaTypeID = ''A05'' and A05.AnaID = OT3002.Ana05ID  and A05.DivisionID= OT3002.DivisionID
	left join AT1011 A06 on A06.AnaTypeID = ''A06'' and A06.AnaID = OT3002.Ana06ID  and A06.DivisionID= OT3002.DivisionID
	left join AT1011 A07 on A07.AnaTypeID = ''A07'' and A07.AnaID = OT3002.Ana07ID  and A07.DivisionID= OT3002.DivisionID
	left join AT1011 A08 on A08.AnaTypeID = ''A08'' and A08.AnaID = OT3002.Ana08ID  and A08.DivisionID= OT3002.DivisionID
	left join AT1011 A09 on A09.AnaTypeID = ''A09'' and A09.AnaID = OT3002.Ana09ID  and A09.DivisionID= OT3002.DivisionID
	left join AT1011 A10 on A10.AnaTypeID = ''A10'' and A10.AnaID = OT3002.Ana10ID  and A10.DivisionID= OT3002.DivisionID
	
	left join AT1015 I01 on I01.AnaTypeID = ''I01'' and I01.AnaID = AT1302.I01ID  and I01.DivisionID = OT3002.DivisionID
	left join AT1015 I02 on I02.AnaTypeID = ''I02'' and I02.AnaID = AT1302.I02ID  and I02.DivisionID = OT3002.DivisionID
	left join AT1015 I03 on I03.AnaTypeID = ''I03'' and I03.AnaID = AT1302.I03ID  and I03.DivisionID = OT3002.DivisionID
	left join AT1015 I04 on I04.AnaTypeID = ''I04'' and I04.AnaID = AT1302.I04ID  and I04.DivisionID = OT3002.DivisionID
	left join AT1015 I05 on I05.AnaTypeID = ''I05'' and I05.AnaID = AT1302.I05ID  and I05.DivisionID = OT3002.DivisionID
	
	Left Join AT1208 on OT3001.PaymentTermID = AT1208.PaymentTermID and AT1208.DivisionID = OT3002.DivisionID
'
+
N'	Where OT3001.DivisionID = N''' + isnull(@DivisionID,'') + N''' and 
	 OT3001.POrderID = N''' + isnull(@OrderID,'') + N''''

If Not Exists (Select 1 From sysObjects Where Name ='OV3002')
	Exec ('Create view OV3002  ---tao boi OP3011
		as '+ @sSQLSelect + @sSQL + @sSQLFrom + @sSQLFrom1)
Else
	Exec( 'Alter view OV3002  ---tao boi OP3011
		as '+ @sSQLSelect + @sSQL + @sSQLFrom + @sSQLFrom1)
PRINT ( @sSQLSelect + @sSQL + @sSQLFrom + @sSQLFrom1)
-- Xu ly in nhom theo mat hang, mau bao cao OR3002
Set @sSQL =N'
Select OT3002.DivisionID, 
	OT3001.POrderID, 	
	OT3001.VoucherNo, 	
	OT3001.OrderDate,  
	OT3001.Notes as Description,
	OT3002.Description as TDescription,
	OT3001.TransPort,
	OT3001.ObjectID, 	
	case when isnull(OT3001.ObjectName, '''') = '''' then AT1202.ObjectName else 
	OT3001.ObjectName end as ObjectName,
	AT1202.Website, AT1202.Contactor,
	AT1202.Tel, AT1202.Fax,  AT1202.VATNo, OT3001.ReceivedAddress,  
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
	case when isnull(OT3002. InventoryCommonName,'''') = '''' then InventoryName else 
	OT3002.InventoryCommonName end as InventoryName, 
	AT1302.UnitID, 
	AT1304.UnitName, 
	AT1302.Specification,
	AT1302.Notes01 as InNotes01, AT1302.Notes02 as InNotes02,AT1302.Notes03 as InNotes03,
	AT1310_S1.SName as SName1, AT1310_S2.SName as SName2,
sum (isnull(OrderQuantity,0)) as OrderQuantity , 
	PurchasePrice, 
Sum (isnull(ConvertedAmount,0)) as ConvertedAmount,  
sum (isnull(ConvertedAmount,0)) as IMConvertedAmount,  
Sum (isnull(OriginalAmount, 0)) as OriginalAmount,	
 sum (isnull(OT3002.OriginalAmount, 0)) +  sum(isnull(OT3002.VATOriginalAmount, 0)) -  sum(isnull(OT3002.DiscountOriginalAmount, 0)) as TotalOriginalAmount,
 Sum(isnull(OT3002.ConvertedAmount, 0)) +  sum(isnull(OT3002.VATConvertedAmount, 0)) - sum( isnull(OT3002.DiscountConvertedAmount, 0)) as TotalConvertedAmount,
	 OT3002.VATPercent,
Sum ( Isnull (OT3002.VATOriginalAmount,0)) as VATOriginalAmount ,
Sum ( Isnull (OT3002.VATConvertedAmount,0)) as VATConvertedAmount ,
	DiscountPercent, 

sum(isnull(DiscountConvertedAmount,0)) as DiscountConvertedAmount,  
sum (isnull(DiscountOriginalAmount,0)) as DiscountOriginalAmount,
	OT3001.Ana01ID,
	OT3001.Ana02ID,
	OT3001.Ana03ID,
	OT1002.AnaName as AnaName01,
	AT1302.I02ID, AT1015. AnaName,
	ImTaxpercent,
 Sum(Isnull (ImTaxOriginalAmount,0)) As ImTaxOriginalAmount ,
 Sum(Isnull (ImtaxConvertedAmount,0)) As ImtaxConvertedAmount ,
	T04.AnaName as  AnaName04, 
	V01.EndQuantity, -- Ton kho thuc te
	SQuantity,-- Giu cho
	PQuantity, -- Chan bi ban,
	OT3002.WareHouseID,
	OT3101.ROrderID,
OT3101.OrderDate as ROrderDate , OT3101.Shipdate as RShipdate,
OT3002.Notes, OT3002.Notes01, OT3002.Notes02,
Sum (isnull(OT3002.ConvertedQuantity,0)) as ConvertedQuantity,
	ConvertedSalePrice,
	OT3002.UnitID as ConvertedUnitID,
	T34.UnitName as ConvertedUnitName,
	OT3001.OrderStatus, OV1101.Description as OrderStatusName,
	OT3002.Orders, OT3001.RequestID,
	OT3001.PaymentTermID, AT1208.PaymentTermName,
	AT1202.Email,
	OT3001.Varchar01, OT3001.Varchar02, OT3001.Varchar03, OT3001.Varchar04, OT3001.Varchar05,
	OT3001.Varchar06, OT3001.Varchar07, OT3001.Varchar08, OT3001.Varchar09, OT3001.Varchar10,
	OT3001.Varchar11, OT3001.Varchar12, OT3001.Varchar13, OT3001.Varchar14, OT3001.Varchar15,
	OT3001.Varchar16, OT3001.Varchar17, OT3001.Varchar18, OT3001.Varchar19, OT3001.Varchar20,
	OT3001.Ana04ID,
	OT3001.Ana05ID,
	P01.AnaName as PO01AnaName,
	P02.AnaName as PO02AnaName,
	P03.AnaName as PO03AnaName,
	P04.AnaName as PO04AnaName,
	P05.AnaName as PO05AnaName,
	P01.AnaNameE as PO01AnaNameE,
	P02.AnaNameE as PO02AnaNameE,
	P03.AnaNameE as PO03AnaNameE,
	P04.AnaNameE as PO04AnaNameE,
	P05.AnaNameE as PO05AnaNameE
'
SET @sSQLFrom = N'
From OT3002 left join AT1302 on AT1302.InventoryID= OT3002.InventoryID and AT1302.DivisionID= OT3002.DivisionID
	inner join OT3001 on OT3001.POrderID = OT3002.POrderID and OT3001.DivisionID= OT3002.DivisionID
	left join OT1002 on OT1002.AnaTypeID = ''P01'' and OT1002.AnaID = OT3001.Ana01ID  and OT1002.DivisionID= OT3002.DivisionID
	left join AT1301 on AT1301.InventoryTypeID = OT3001.InventoryTypeID 	 and AT1301.DivisionID= OT3002.DivisionID
	left join AT1304 on AT1304.UnitID = AT1302.UnitID		 and AT1304.DivisionID= OT3002.DivisionID
	left join AT1103 on AT1103.EmployeeID = OT3001.EmployeeID	and AT1103.DivisionID = OT3001.DivisionID 
	left join AT1202 on AT1202.ObjectID = OT3001.ObjectID and AT1202.DivisionID= OT3002.DivisionID
	left join AT1205 on AT1205.PaymentID = OT3001.PaymentID and AT1205.DivisionID= OT3002.DivisionID
	left join AT1004 on AT1004.CurrencyID = OT3001.CurrencyID and AT1004.DivisionID= OT3002.DivisionID
	left join AT1001 on AT1001.CountryID = AT1202.CountryID and AT1001.DivisionID= OT3002.DivisionID
	left join AT1003 on AT1003.AreaID = AT1202.AreaID and AT1003.DivisionID= OT3002.DivisionID
	
	left join AT1002 on AT1002.CityID = AT1202.CityID and AT1002.DivisionID= OT3002.DivisionID
	left join AT1310  AT1310_S1 on AT1310_S1.STypeID= ''I01'' and AT1310_S1.S = AT1302.S1  and AT1310_S1.DivisionID= OT3002.DivisionID
	left join AT1310  AT1310_S2 on AT1310_S2.STypeID= ''I02'' and AT1310_S2.S = AT1302.S2 and AT1310_S2.DivisionID= OT3002.DivisionID
	left Join AT1015 on AT1015.AnaID = AT1302.I02ID  and AT1015. AnaTypeID =''I02'' and AT1015.DivisionID= OT3002.DivisionID
	left Join AT1015 T03   on T03.AnaID = AT1302.I03ID  and T03. AnaTypeID =''I03'' and T03.DivisionID= OT3002.DivisionID
	left Join AT1015 T04  on T04.AnaID = AT1302.I04ID  and  T04. AnaTypeID =''I04'' and T04.DivisionID= OT3002.DivisionID
	Left Join  (Select DivisionID, InventoryID,WareHouseID, sum(isnull(DebitQuantity,0))-sum(isnull(CreditQuantity,0)) as EndQuantity
		From OV2401 
		Group by DivisionID, WareHouseID,  InventoryID Having  sum(isnull(DebitQuantity,0))-sum(isnull(CreditQuantity,0)) <>0
		) V01 on V01.DivisionID = OT3002.DivisionID and V01.InventoryID = ot3002.InventoryID and V01.WareHouseID = OT3002.WareHouseID

	Left Join (Select DivisionID, InventoryID, WareHouseID,
			SUM(case when TypeID <> ''PO'' and Finish <> 1 then OrderQuantity - ActualQuantity else  0 end) as SQuantity,
			SUM(case when TypeID = ''PO'' and Finish <> 1  then OrderQuantity - ActualQuantity else  0 end) as PQuantity
		From OV2800
		Group by DivisionID, InventoryID,WareHouseID
		) V02 on V02.DivisionID = OT3002.DivisionID and V02.InventoryID = ot3002.InventoryID and OT3002.WareHouseID = V02.WareHouseID
	left join  OT3101 On OT3002.ROrderID = OT3101.ROrderID and OT3101.DivisionID= OT3002.DivisionID
	left join AT1304 T34 on T34.UnitID = OT3002.UnitID and T34.DivisionID= OT3002.DivisionID
	left join OV1101 on OT3001.OrderStatus = OV1101.OrderStatus and OV1101.TypeID=''PO'' and OV1101.DivisionID= OT3002.DivisionID
	Left Join AT1208 on OT3001.PaymentTermID = AT1208.PaymentTermID
	left join OT1002 P01 on P01.AnaTypeID = ''P01'' and P01.AnaID = OT3001.Ana01ID  and P01.DivisionID= OT3002.DivisionID
	left join OT1002 P02 on P02.AnaTypeID = ''P02'' and P02.AnaID = OT3001.Ana02ID  and P02.DivisionID= OT3002.DivisionID
	left join OT1002 P03 on P03.AnaTypeID = ''P03'' and P03.AnaID = OT3001.Ana03ID  and P03.DivisionID= OT3002.DivisionID
	left join OT1002 P04 on P04.AnaTypeID = ''P04'' and P04.AnaID = OT3001.Ana04ID  and P04.DivisionID= OT3002.DivisionID
	left join OT1002 P05 on P05.AnaTypeID = ''P05'' and P05.AnaID = OT3001.Ana05ID  and P05.DivisionID= OT3002.DivisionID
'
SET @sSQLFrom1 = 
N' Where OT3001.DivisionID = N''' + isnull(@DivisionID,'') + N''' and 
	 OT3001.POrderID = N''' + isnull(@OrderID,'') + N'''


Group by OT3002.DivisionID, 

OT3001.POrderID,OT3001.VoucherNo,OT3001.OrderDate,  OT3001.Notes,OT3001.TransPort, OT3001.ObjectID, OT3001.ObjectName,  AT1202.ObjectName ,
	AT1202.Website, AT1202.Contactor, AT1202.Tel, AT1202.Fax, AT1202.VATNo, OT3001.ReceivedAddress,  
	OT3001.Address, AT1202.Address, AT1002.CityName, OT3001.CurrencyID,  AT1004.CurrencyName,
	OT3001.ShipDate, OT3001.ExchangeRate, OT3001.ContractNo, OT3001.ContractDate,
	AT1202.CountryID,AT1001.CountryName,  AT1202.AreaID,
	AT1003.AreaName,AT1205.PaymentName,OT3001.EmployeeID, AT1103.FullName, AT1103.Address ,
	OT3002.InventoryID,OT3002. InventoryCommonName,
	AT1302.InventoryName,	AT1302.UnitID, 	AT1304.UnitName, AT1302.Specification,
	AT1302.Notes01 , AT1302.Notes02 ,AT1302.Notes03,
	AT1310_S1.SName , AT1310_S2.SName ,PurchasePrice, 
	OT3002.VATPercent,	DiscountPercent, 
	OT3001.Ana01ID,OT3001.Ana02ID,OT3001.Ana03ID,OT1002.AnaName ,
	AT1302.I02ID, AT1015. AnaName,ImTaxpercent,T04.AnaName , V01.EndQuantity,
	SQuantity,PQuantity, Ot3002.WareHouseID, OT3101.ROrderID,
	OT3101.OrderDate ,OT3101.Shipdate,OT3002.Notes, OT3002.Notes01, OT3002.Notes02, ConvertedSalePrice, OT3002.UnitID, T34.UnitName,
	OT3001.OrderStatus, OV1101.Description, OT3002.Orders, OT3001.RequestID,
	OT3001.PaymentTermID, AT1208.PaymentTermName,
	AT1202.Email,
	OT3001.Varchar01, OT3001.Varchar02, OT3001.Varchar03, OT3001.Varchar04, OT3001.Varchar05,
	OT3001.Varchar06, OT3001.Varchar07, OT3001.Varchar08, OT3001.Varchar09, OT3001.Varchar10,
	OT3001.Varchar11, OT3001.Varchar12, OT3001.Varchar13, OT3001.Varchar14, OT3001.Varchar15,
	OT3001.Varchar16, OT3001.Varchar17, OT3001.Varchar18, OT3001.Varchar19, OT3001.Varchar20,
	OT3001.Ana04ID, OT3001.Ana05ID,OT3002.Description,
	P01.AnaName,
	P02.AnaName,
	P03.AnaName,
	P04.AnaName,
	P05.AnaName,
	P01.AnaNameE,
	P02.AnaNameE,
	P03.AnaNameE,
	P04.AnaNameE,
	P05.AnaNameE
	'
---OP3011 'PMT',7,2012,'PO/07/2012/0001'

If Not Exists (Select 1 From sysObjects Where Name ='OV3110')
	Exec ('Create view OV3110---tao boi OP3011
		as '+@sSQL + @sSQLFrom + @sSQLFrom1)
Else
	Exec( 'Alter view OV3110---tao boi OP3011
		as '+@sSQL + @sSQLFrom + @sSQLFrom1)


/*
--Xu ly in to khai hai quan

Delete From OT3050    

If Exists (Select 1 From sysObjects Where Name ='OV3050' and xType = 'V') Drop view OV3050

-- IN trang 1
If (Select COUNT(*) From OV3002)   < = 3

BEGIN
	
	Insert Into OT3050 (TransactionID, DivisionID) Select Top 3 TransactionID, @DivisionID From OV3002 Order by Orders

	If Not Exists (Select 1 From sysObjects Where Name ='OV3050' and xType = 'V')
	Exec ('Create view OV3050  ---tao boi OP3011
		as 
		Select Top 100 Percent * from OV3002 Where TransactionID In (Select TransactionID From OT3050) Order by Orders')
	Else
	Exec( 'Alter view OV3050  ---tao boi OP3011
		as 
		Select Top 100 Percent * from OV3002 Where TransactionID In (Select TransactionID From OT3050) Order by Orders')

Set @sSQLSelect = ''
Set @FieldCount = (select count(name) From syscolumns where id = object_id('OV3002'))
Set @NullRowInsert = REPLICATE('Null,',@FieldCount)
Set @NullRowInsert = LEFT(@NullRowInsert,LEN(@NullRowInsert)-1)

Select @RemainRows = 3 - Count(*) From OV3050

If @RemainRows>0 And @RemainRows<3
Begin
	Set @For = 1
	While @For <=@RemainRows
	Begin
		Set @sSQLSelect = @sSQLSelect +  ' Union All 
					Select ' + @NullRowInsert + ' 
					'		
		Set @For = @For + 1
	End
End
PRINT @sSQLSelect
If Not Exists (Select 1 From sysObjects Where Name ='OV3050' and xType = 'V')
	Exec ('Create view OV3050 ---tao boi OP3011
		as 
		Select * From (Select Top 100 Percent * from OV3002 Where TransactionID In (Select TransactionID From OT3050) Order by Orders) as OV02 ' + @sSQLSelect)
Else
	Exec( 'Alter view OV3050 ---tao boi OP3011
		as 
		Select * From (Select  Top 100 Percent * from OV3002 Where TransactionID In (Select TransactionID From OT3050) Order by Orders) as OV02 ' + @sSQLSelect)

End
-------------------------------

	Set @sSQLSelect =' Select  DivisionID, Quantity  = ( Select Sum(isnull (OrderQuantity,0))  from OV3002 ),
	                OriginalAmount = ( Select Sum(isnull (OriginalAmount,0))  from OV3002 ),
		Sum(isnull (ConvertedAMount,0)) as ConvertedAMount, ImTaxPercent, VATPercent  From OV3002
		Group by DivisionID, ImTaxPercent, VATPercent'
 

	If Not Exists (Select 1 From sysObjects Where Name ='OV3054')
	Exec ('Create view OV3054 ---tao boi OP3011
		as '+@sSQLSelect)
	Else
	Exec( 'Alter view OV3054  ---tao boi OP3011
		as '+@sSQLSelect)


IF (Select  count(*) from OV3054 )  > 3

Set @sSQLSelect = ' Select  DivisionID, Quantity  = ( Select Sum(isnull (OrderQuantity,0))  from OV3002 ),
					OriginalAmount = ( Select Sum(isnull (OriginalAmount,0))  from OV3002 ),
					ImAmount =  ( Select Sum(isnull (ImTaxConVertedAmount,0))  from OV3002 ),
					VATAmount =  ( Select Sum(isnull (VATConvertedAmount,0))  from OV3002 ),
					Sum(isnull (ConvertedAMount,0)) as ConvertedAMount, null as  ImTaxPercent,  null as VATPercent  From OV3002
					Group by DivisionID -- updated: 12/11/2014
		'

ELSE 
Set @sSQLSelect = ' Select  DivisionID, Quantity  = ( Select Sum(isnull (OrderQuantity,0))  from OV3002 ),
					OriginalAmount = ( Select Sum(isnull (OriginalAmount,0))  from OV3002 ),
					ImAmount =  ( Select Sum(isnull (ImTaxConVertedAmount,0))  from OV3002 ),
					VATAmount =  ( Select Sum(isnull (VATConvertedAmount,0))  from OV3002 ),
					Sum(isnull (ConvertedAMount,0)) as ConvertedAMount, ImTaxPercent, VATPercent  From OV3002
					Group by DivisionID, ImTaxPercent, VATPercent'




If Not Exists (Select 1 From sysObjects Where Name ='OV3055')
	Exec ('Create view OV3055 ---tao boi OP3011
		as '+@sSQLSelect)
	Else
	Exec( 'Alter view OV3055 ---tao boi OP3011
		as '+@sSQLSelect)


--:  Xu ly co goi  subFrom hay khong  ! @IsSubFrom = 0: khong goi from OF3015, @IsSubFrom = 1 co goi From
  Set @IsSubForm = 0
  Set @IsEdit = 0 


If (Select COUNT(*) From OV3002)    >  3
      Begin
	 sET  @IsSubForm = 1
	----Goto BaoANH

      End	



-- Tinh toan so lieu dua ra From OF3015


If  ( (Select distinct POrderID from OT3015 WHere  POrderID = @OrderID ) = @OrderID)
Begin
Set @IsEdit = 1 -- Load edit
End


Select @IsEdit as IsEdit, @IsSubForm as  IsSubForm

SET NOCOUNT OFF

*/

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
