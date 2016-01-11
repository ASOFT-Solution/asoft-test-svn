IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3001]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3001]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----Created by: Vo Thanh Huong, date: 07/09/2004
----purpose: In don hang ban 
----Last Update: nguyen thi Thuy Tuyen, date:01/09/2006
--- Thuy Tuyen edit: 24/01/2008, 05/08/2008 - Lay ma phan tich mat hang.22/06/2009,09/07/2009,14/07/2009,08/08/2009
-- last Update: 15/09/2009, 24/09/2009,26/09/2009
--- Edit by B.Anh, date 08/10/2009, lay truong IsDiscount (thuong doanh so)
--- Edit by B.Anh, date 14/10/2009, lay truong Operator,
-- Edit Thuy Tuyen, date 16/11/2009 
---- Modified on 10/10/2011 by Le Thi Thu Hien : Bo sung 1 so truong 
---- Modified on 10/10/2011 by Le Thi Thu Hien : Bo sung truong ReDueDays
---- Modified on 01/03/2012 by Le Thi Thu Hien : Bo sung truong PaymentTermID
---- Modified on 05/09/2012 by Bao Anh : Bo sung truong ConvertedQuantity, cac truong tham so, dung sai (2T)
---- Modified on 01/03/2012 by Le Thi Thu Hien : Bo sung truong SignAmount lấy công nợ 131 tại thời điểm hiện tại
---- Modified on 31/01/2013 by Dang Le Bao Quynh : Doi view lay cong no den thoi diem hien tai tu AV5000 thanh AV4301, rem dieu kien loc VoucherDate
---- Modified on 20/03/2013 by Dang Le Bao Quynh : Xu ly toc do, xu ly so du cong no luu vao bien truoc thay vi dung sub query
---- Modified on 05/04/2013 by Le Thi Thu Hien : Bo sung them ISNULL vao ISNULL (Sum(SignAmount), 0) 
---- Modified on 04/08/2014 by Bảo Anh : Bo sung tên các MPT từ 6-10 

---- Modified on 25/03/2015 by Hoàng Vũ : Customize theo secoin (Viết chết 4 đơn vị tính Viên, Mét, Hộp, Pallets)
---- Modified on 03/11/2015 by Tiểu Mai: fix phép tính ở ConversionQuantity

---- exec OP3001 @Divisionid=N'AS',@Tranmonth=8,@Tranyear=2015,@Orderid=N'DHB_BD_08_2015_00001'

CREATE PROCEDURE [dbo].[OP3001] 
				@DivisionID AS nvarchar(3),
				@TranMonth AS int,
				@TranYear AS int,
				@OrderID AS nvarchar(4000)

AS

Declare @sSQL AS nvarchar(max);
Declare @sSQL1 AS nvarchar(max);
Declare @sSQL2 AS nvarchar(max);
Declare @sSQL3 AS nvarchar(max);
Declare @sSQL4 AS nvarchar(max);
Declare @sSQL5 AS nvarchar(max);
Declare @ObjectID nvarchar(50), @OrderDate as datetime, @VoucherTypeID as nvarchar(50);

Declare @AmountBookCN decimal (28,8); --công nợ tổng, tính theo dữ liệu
Declare @AmountCN decimal (28,8); --công nợ tính đến ngày phát sinh đơn hàng trở về trước.
SET @AmountBookCN = 0

Select @ObjectID = ObjectID, @OrderDate = OrderDate, @VoucherTypeID = VoucherTypeID From OT2001 Where DivisionID = @DivisionID And SOrderID = @OrderID
Select @AmountBookCN = ISNULL (Sum(SignAmount), 0) From AQ4301 where DivisionID = @DivisionID And ObjectID = @ObjectID And AccountID like '131%'
Select @AmountCN = ISNULL(Sum(SignAmount),0) From AQ4301 where DivisionID = @DivisionID And ObjectID = @ObjectID And AccountID like '131%' AND VoucherDate<= @OrderDate




Set @sSQL = N'
SELECT  OT2002.DivisionID,
	ReceivedAmount = ' + ltrim(@AmountCN) + ' ,
	OT2001.SOrderID, 	OT2002.TransactionID, 
	VoucherTypeID, 	VoucherNo, 	OrderDate, 	
	ContractNo,	 	ContractDate,
	OT2001.CurrencyID,
	OT2001.ObjectID, AT1202.ObjectName ,AT1202.Address ,  AT1202.VATNo AS OVATNo, AT1202.Tel, AT1202.Fax, AT1202.Email, 
	-- Edit Thanh Nguyen, date 23/03/2011
	AT1202.Website AS ObjectWebsite, AT1202.Contactor AS ObjectContactor, AT1202.BankName AS ObjectBankName, AT1202.BankAddress AS ObjectBankAddress, AT1202.BankAccountNo AS ObjectBankAccountNo, AT1202.Note AS ObjectNote1, AT1202.Note1 AS ObjectNote2
	,
	OT2001.DeliveryAddress,
 	OT2001.Notes AS Descrip,
	OT2001.SalesManID, 	
	AT1103_2.FullName AS SalesManName, 
	AT1103_2.Email AS EmailSalesMan,
	AT1103_2.EmployeeTypeID AS SaleManEmployeeTypeID	,AT1103_2.HireDate AS SaleManHireDate	,AT1103_2.EndDate AS SaleManEndDate	,AT1103_2.BirthDay AS SaleManBirthDay	,AT1103_2.Address AS SaleManAddress	,AT1103_2.Tel AS SaleManTel	,AT1103_2.Fax AS SaleManFax,
	OT2001.TransPort, OT2001.EmployeeID, AT1103.FullName, AT1103.Address AS EmployeeAddress,
	AT1103.EmployeeTypeID AS EmployeeTypeID	,AT1103.HireDate AS EmployeeHireDate	,AT1103.EndDate AS EmployeeEndDate	,AT1103.BirthDay AS EmployeeBirthDay	,AT1103.Tel AS EmployeeTel	,AT1103.Fax AS EmployeeFax	,AT1103.Email AS EmployeeEmail,
	OT2002.InventoryID, 	ISNULL(OT2002.InventoryCommonName, 	AT1302.InventoryName)  AS InventoryName,
	AT1302.UnitID, AT1304.UnitName,
	Isnull(AV1319.UnitID,AT1302.UnitID)  AS ConversionUnitID, 
	AV1319.ConversionFactor,
	Isnull(AV1319.UnitName, AT1304.UnitName) AS ConversionUnitName,
	AT1002.CityName,
	AT1302.Notes01 AS InNotes01, AT1302.Notes02 AS InNotes02, AT1302.notes03 AS InNotes03, AT1302.Specification,
	AT1302.S1, AT1302.S2,  AT1302.S3, 
	AT1310_S1.SName AS SName1, AT1310_S2.SName AS SName2, 
	AT1310_S3.SName AS SName3,
	OT2002.MethodID, 	MethodName, 	
	OT2001.PaymentTermID,AT1208.PaymentTermName, 
	OrderQuantity, 		
	'
Set @sSQL1 = N'
	(case when AV1319.Operator = 0 OR  AV1319.ConversionFactor=0  then (OrderQuantity * AV1319.ConversionFactor  )
	else
	(OrderQuantity /  ISNULL(AV1319.ConversionFactor,1)   ) end)   AS ConversionQuantity , 		
	OT2002.SalePrice, 	OT2001.ExchangeRate, 
	case when AT1004.Operator = 0 or OT2001.ExchangeRate = 0  then SalePrice*OT2001.ExchangeRate else
	OT2002.SalePrice/OT2001.ExchangeRate  end AS SalePriceConverted,
	ISNULL(OT2002.ConvertedAmount,0) AS ConvertedAmount, 
	ISNULL(OT2002.OriginalAmount,0) AS OriginalAmount, 
	OT2002.VATPercent, 	
	ISNULL(OT2002.VATConvertedAmount,0) AS VATConvertedAmount, 	
	ISNULL(OT2002.VATOriginalAmount, 0) AS VATOriginalAmount,
	DiscountPercent, 	
	ISNULL(DiscountConvertedAmount,0) AS DiscountConvertedAmount, 	
	ISNULL(DiscountOriginalAmount,0) AS DiscountOriginalAmount,
	OT2002.CommissionPercent, 	
	ISNULL(OT2002.CommissionCAmount, 0) AS CommissionCAmount,
	ISNULL(OT2002.CommissionOAmount,0) AS CommissionOAmount, 
	IsPicking, OT2002.WareHouseID, WareHouseName, OT2002.ShipDate, OT2002.RefInfor,
	OT2002.Orders, AT1205.PaymentName, AT1004.CurrencyName,
	ISNULL(OT2002.OriginalAmount, 0) + ISNULL(OT2002.VATOriginalAmount, 0)	 -
	ISNULL(OT2002.DiscountOriginalAmount, 0) - ISNULL(CommissionOAmount,0) AS TotalOriginalAmount,
	ISNULL(OT2002.ConvertedAmount, 0) + ISNULL(OT2002.VATConvertedAmount, 0) - 
	ISNULL(OT2002.DiscountConvertedAmount, 0)-ISNULL(CommissionCAmount, 0)as TotalConvertedAmount,
	OT2001.Ana01ID AS SOAna01ID, 
	OT2001.Ana02ID AS SOAna02ID, 
	OT2001.Ana03ID AS SOAna03ID, 
	OT2001.Ana04ID AS SOAna04ID, 
	OT2001.Ana05ID AS SOAna05ID,
	OT1001_1.AnaName AS SOAnaName1,
	OT1001_2.AnaName AS SOAnaName2,
	OT1001_3.AnaName AS SOAnaName3,
	OT1001_4.AnaName AS SOAnaName4,
	OT1001_5.AnaName AS SOAnaName5,

	OT2002.Ana01ID, 
	OT2002.Ana02ID, 
	OT2002.Ana03ID, 
	OT2002.Ana04ID, 
	OT2002.Ana05ID,
	OT2002.Ana06ID,
	OT2002.Ana07ID,
	OT2002.Ana08ID,
	OT2002.Ana09ID,
	OT2002.Ana10ID,
	 '
	
set @sSQL2 = N'

	OT1002_1.AnaName AS AnaName1,
	OT1002_2.AnaName AS AnaName2, 
	OT1002_3.AnaName AS AnaName3,
	OT1002_4.AnaName AS AnaName4,
	OT1002_5.AnaName AS AnaName5,
	OT1002_6.AnaName AS AnaName6,
	OT1002_7.AnaName AS AnaName7,
	OT1002_8.AnaName AS AnaName8,
	OT1002_9.AnaName AS AnaName9,
	OT1002_10.AnaName AS AnaName10,
 	OT2002.Description ,
	ISNULL(OT2001.Contact, AT1202.contactor)as contactor ,
	OT2002.Notes, OT2002.Notes01, OT2002.Notes02,
	OT2001.VATObjectID,
	ISNULL(OT2001.VATObjectName,T02.ObjectName) AS VATObjectName,
	ISNULL(OT2001.Address,		 T02.Address) AS VATAddress,
	ISNULL(OT2001.VATNo,T02.VatNo) AS VATNo ,
	T02.Email AS VATEmail,T02.Website AS VATWebsite, T02.Contactor AS VATContactor, T02.BankName AS VATBankName, T02.BankAddress AS VATBankAddress, T02.BankAccountNo AS VATBankAccountNo, T02.Note AS VATNote1, T02.Note1 AS VATNote2, 
	OT2002.EndDate,
	AT1302.Varchar01 AS InventoryVarchar01, AT1302.Varchar02 AS InventoryVarchar02, AT1302.Varchar03 AS InventoryVarchar03, AT1302.varchar04 AS InventoryVarchar04, AT1302.varchar05 AS InventoryVarchar05,
	AT1302.I01ID, T15.AnaName AS AnaNameI01,  
	AT1302.I02ID, T16.AnaName AS AnaNameI02,
	AT1302.I03ID, T17.AnaName AS AnaNameI03,
	AT1302.I04ID, T18.AnaName AS AnaNameI04,
	AT1302.I05ID, T19.AnaName AS AnaNameI05,
	OT2002.SaleOffPercent01,OT2002.SaleOffAmount01,
	OT2002.SaleOffPercent02,OT2002.SaleOffAmount02,
	OT2002.SaleOffPercent03,OT2002.SaleOffAmount03,
	OT2002.SaleOffPercent04,OT2002.SaleOffAmount04,
	OT2002.SaleOffPercent05,OT2002.SaleOffAmount05,
	OT2002.QuoTransactionID,OT2002.Pricelist,  AT1202. TradeName, OT3019.SOKitID,
	(   salePrice - (salePrice * ISNULL(DiscountPercent,0) /100) - isnull (OT2002.SaleOffAmount02,0)       - isnull (OT2002.SaleOffAmount02,0) -isnull (OT2002.SaleOffAmount03,0)-isnull (OT2002.SaleOffAmount04,0)-isnull (OT2002.SaleOffAmount02,0)    )  AS PriceLast,
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
	AT1302.IsDiscount, AV1319.Operator
	, OT2002.Varchar01, OT2002.Varchar02, OT2002.Varchar03, OT2002.Varchar04, OT2002.Varchar05 
	, OT2002.Varchar06, OT2002.Varchar07, OT2002.Varchar08, OT2002.Varchar09, OT2002.Varchar10
	, OT2002.nvarchar01, OT2002.nvarchar02, OT2002.nvarchar03, OT2002.nvarchar04, OT2002.nvarchar05 
	, OT2002.nvarchar06, OT2002.nvarchar07, OT2002.nvarchar08, OT2002.nvarchar09, OT2002.nvarchar10
	, OT2001.OrderStatus, OV1101.Description AS OrderStatusName, OV1101.Description AS OrderStatusNameE
	, OT2001.ClassifyID, OT1001.ClassifyName, OT1001.Note AS ClassifyNote
	, OT2001.QuotationID
	, OT2001.DueDate,
'
set @sSQL3 = N'	

	AT1202.Phonenumber,
	AT1202.DeAddress,
	AT1202.ReDueDays,
	OT2001.Varchar01 AS SVarchar01,
	OT2001.Varchar02 AS SVarchar02,
	OT2001.Varchar03 AS SVarchar03,
	OT2001.Varchar04 AS SVarchar04,
	OT2001.Varchar05 AS SVarchar05,
	OT2001.Varchar06 AS SVarchar06,
	OT2001.Varchar07 AS SVarchar07,
	OT2001.Varchar08 AS SVarchar08,
	OT2001.Varchar09 AS SVarchar09,
	OT2001.Varchar10 AS SVarchar10,
	OT2001.Varchar11 AS SVarchar11,
	OT2001.Varchar12 AS SVarchar12,
	OT2001.Varchar13 AS SVarchar13,
	OT2001.Varchar14 AS SVarchar14,
	OT2001.Varchar15 AS SVarchar15,
	OT2001.Varchar16 AS SVarchar16,
	OT2001.Varchar17 AS SVarchar17,
	OT2001.Varchar18 AS SVarchar18,
	OT2001.Varchar19 AS SVarchar19,
	OT2001.Varchar20 AS SVarchar20,

	OT2002.Markup,
	OT2002.DeliveryDate,
	OT2002.ConvertedQuantity,
	OT2002.ExtraID,
	AT1320.ExtraName,
	O1.UserName as UserName01, O1.UserNameE as UserName01E,
	O2.UserName as UserName02, O2.UserNameE as UserName02E,
	O3.UserName as UserName03, O3.UserNameE as UserName03E,
	O4.UserName as UserName04, O4.UserNameE as UserName04E,
	O5.UserName as UserName05, O5.UserNameE as UserName05E,
	O6.UserName as UserName06, O6.UserNameE as UserName06E,
	O7.UserName as UserName07, O7.UserNameE as UserName07E,
	O8.UserName as UserName08, O8.UserNameE as UserName08E,
	O9.UserName as UserName09, O9.UserNameE as UserName09E,
	OT2002.Allowance, OT2002.Parameter01, OT2002.Parameter02, OT2002.Parameter03, OT2002.Parameter04, OT2002.Parameter05,
	A00003.Image01ID,
	SignAmount = ' + ltrim(@AmountBookCN) + ',
	AT1302.UnitID as Vien,
	AT1302.I04ID as Code_mau,
	   AT1302.I02ID as Kich_thuoc_Cm,
	   OT2002.OrderQuantity as Vien_Quantity,
	   AT1309_M.UnitID  as Met,
	   AT1309_M.ConversionFactor as Met_Rate,
	   Case	  When AT1309_M.Operator = 0 then isnull(OT2002.Met_Quantity, OT2002.OrderQuantity / AT1309_M.ConversionFactor)
			  When AT1309_M.Operator = 1 then isnull(OT2002.Met_Quantity,OT2002.OrderQuantity * AT1309_M.ConversionFactor)
			  When Isnull(AT1309_M.Operator, '''') = '''' then isnull(OT2002.Met_Quantity,0)
			  end as Met_Quantity,
	   AT1309_H.UnitID as Hop,	
	   AT1309_H.ConversionFactor as Hop_Rate,
	   Case	  When AT1309_H.Operator = 0 then isnull(OT2002.Hop_Quantity, OT2002.OrderQuantity / AT1309_H.ConversionFactor)
			  When AT1309_H.Operator = 1 then isnull(OT2002.Hop_Quantity,OT2002.OrderQuantity * AT1309_H.ConversionFactor)
			  When Isnull(AT1309_H.Operator, '''') = '''' then isnull(OT2002.Hop_Quantity,0)
			  end as Hop_Quantity,
	   AT1309_P.UnitID as Pallets,
 '
set @sSQL4 = N'		

	   AT1309_P.ConversionFactor as Pallets_Rate,
	   Case	  When AT1309_P.Operator = 0 then isnull(OT2002.Pallets_Quantity , OT2002.OrderQuantity / AT1309_H.ConversionFactor)
			  When AT1309_P.Operator = 1 then isnull(OT2002.Pallets_Quantity, OT2002.OrderQuantity * AT1309_H.ConversionFactor)
			  When Isnull(AT1309_P.Operator, '''') = '''' then isnull(OT2002.Pallets_Quantity,0)
			  end as Pallets_Quantity
	From (
							Select OT2002.*,  
									Case When OT2002.UnitID =''M2'' then OT2002.ConvertedQuantity else null end as Met_Quantity,
									Case When OT2002.UnitID =''HO'' then OT2002.ConvertedQuantity else null end as Hop_Quantity,
									Case When OT2002.UnitID =''PA'' then OT2002.ConvertedQuantity else null end as Pallets_Quantity
							from OT2002 
		) OT2002 
	LEFT JOIN AT1302 on AT1302.InventoryID= OT2002.InventoryID	and AT1302.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1320 on AT1320.ExtraID= OT2002.ExtraID	and AT1302.DivisionID = OT2002.DivisionID
	left join AT1309 AT1309_M on AT1309_M.InventoryID = OT2002.InventoryID and AT1309_M.UnitID = ''M2''
	left join AT1309 AT1309_H on AT1309_H.InventoryID = OT2002.InventoryID and AT1309_H.UnitID = ''HO''
	left join AT1309 AT1309_P on AT1309_P.InventoryID = OT2002.InventoryID and AT1309_P.UnitID = ''PA''	
	LEFT JOIN A00003 on AT1302.InventoryID= A00003.InventoryID	and AT1302.DivisionID = A00003.DivisionID	
	LEFT JOIN OT1003 on OT1003.MethodID = OT2002.MethodID AND OT1003.DivisionID = OT2002.DivisionID 
	INNER JOIN OT2001 on OT2001.SOrderID = OT2002.SOrderID AND OT2001.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1205 on AT1205.PaymentID = OT2001.PaymentID AND AT1205.DivisionID = OT2001.DivisionID 
	LEFT JOIN AT1303 on AT1303.WareHouseID = OT2002.WareHouseID AND AT1303.DivisionID = OT2001.DivisionID
	LEFT JOIN AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID AND AT1301.DivisionID = OT2001.DivisionID 	
	LEFT JOIN AT1304 on AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = AT1302.DivisionID	         
	LEFT JOIN AT1103 on AT1103.EmployeeID = OT2001.EmployeeID AND AT1103.DivisionID = OT2001.DivisionID
	LEFT JOIN AT1103 AT1103_2 on AT1103_2.EmployeeID = OT2001.SalesManID AND AT1103_2.DivisionID = OT2001.DivisionID
	LEFT JOIN AT1004 on AT1004.CurrencyID = OT2001.CurrencyID AND AT1004.DivisionID = OT2001.DivisionID
	LEFT JOIN AT1202 on AT1202.ObjectID = OT2001.ObjectID AND AT1202.DivisionID = OT2001.DivisionID
	LEFT JOIN AT1202 T02 on T02.ObjectID = OT2001.VATObjectID AND T02.DivisionID = OT2001.DivisionID
	LEFT JOIN AT1208 on AT1208.PaymentTermID = OT2001.PaymentTermID AND AT1208.DivisionID = OT2001.DivisionID
	LEFT JOIN AT1310  AT1310_S1 on AT1310_S1.STypeID= ''I01'' AND AT1310_S1.S = AT1302.S1 AND AT1310_S1.DivisionID = AT1302.DivisionID
	LEFT JOIN AT1310  AT1310_S2 on AT1310_S2.STypeID= ''I02'' AND AT1310_S2.S = AT1302.S2 AND AT1310_S2.DivisionID = AT1302.DivisionID
	LEFT JOIN AT1310  AT1310_S3 on AT1310_S3.STypeID= ''I03'' AND AT1310_S2.S = AT1302.S3 AND AT1310_S2.DivisionID = AT1302.DivisionID
	LEFT JOIN AT1002 on AT1002.CityID = AT1202.CityID AND AT1002.DivisionID = AT1202.DivisionID
	LEFT JOIN OT1002  OT1001_1 on OT1001_1.AnaID = OT2001.Ana01ID AND  OT1001_1.AnaTypeID = ''S01'' AND OT1001_1.DivisionID = OT2001.DivisionID
	LEFT JOIN OT1002  OT1001_2 on OT1001_2.AnaID = OT2001.Ana02ID AND  OT1001_2.AnaTypeID = ''S02'' AND OT1001_2.DivisionID = OT2001.DivisionID
	LEFT JOIN OT1002  OT1001_3 on OT1001_3.AnaID = OT2001.Ana03ID AND  OT1001_3.AnaTypeID = ''S03'' AND OT1001_3.DivisionID = OT2001.DivisionID
	LEFT JOIN OT1002  OT1001_4 on OT1001_4.AnaID = OT2001.Ana04ID AND  OT1001_4.AnaTypeID = ''S04'' AND OT1001_4.DivisionID = OT2001.DivisionID
	LEFT JOIN OT1002  OT1001_5 on OT1001_5.AnaID = OT2001.Ana05ID AND  OT1001_5.AnaTypeID = ''S05'' AND OT1001_5.DivisionID = OT2001.DivisionID

 '
set @sSQL5 = N'		
	

	LEFT JOIN AT1011  OT1002_1 on OT1002_1.AnaID = OT2002.Ana01ID AND  OT1002_1.AnaTypeID = ''A01'' AND OT1002_1.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011  OT1002_2 on OT1002_2.AnaID = OT2002.Ana02ID AND  OT1002_2.AnaTypeID = ''A02'' AND OT1002_2.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011  OT1002_3 on OT1002_3.AnaID = OT2002.Ana03ID AND  OT1002_3.AnaTypeID = ''A03'' AND OT1002_3.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011  OT1002_4 on OT1002_4.AnaID = OT2002.Ana04ID AND  OT1002_4.AnaTypeID = ''A04'' AND OT1002_4.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011  OT1002_5 on OT1002_5.AnaID = OT2002.Ana05ID AND  OT1002_5.AnaTypeID = ''A05'' AND OT1002_5.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011  OT1002_6 on OT1002_6.AnaID = OT2002.Ana06ID AND  OT1002_6.AnaTypeID = ''A06'' AND OT1002_6.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011  OT1002_7 on OT1002_7.AnaID = OT2002.Ana07ID AND  OT1002_7.AnaTypeID = ''A07'' AND OT1002_7.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011  OT1002_8 on OT1002_8.AnaID = OT2002.Ana08ID AND  OT1002_8.AnaTypeID = ''A08'' AND OT1002_8.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011  OT1002_9 on OT1002_9.AnaID = OT2002.Ana09ID AND  OT1002_9.AnaTypeID = ''A09'' AND OT1002_9.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011  OT1002_10 on OT1002_10.AnaID = OT2002.Ana10ID AND  OT1002_10.AnaTypeID = ''A10'' AND OT1002_10.DivisionID = OT2002.DivisionID
	
	LEFT JOIN AT1015  T15 on T15.AnaID = AT1302.I01ID AND T15.AnaTypeID =''I01'' AND T15.DivisionID = AT1302.DivisionID
	LEFT JOIN AT1015  T16 on T16.AnaID = AT1302.I02ID AND T16.AnaTypeID =''I02'' AND T16.DivisionID = AT1302.DivisionID
	LEFT JOIN AT1015  T17 on T17.AnaID = AT1302.I03ID AND T17.AnaTypeID =''I03'' AND T17.DivisionID = AT1302.DivisionID
	LEFT JOIN AT1015  T18 on T18.AnaID = AT1302.I04ID AND T18.AnaTypeID =''I04'' AND T18.DivisionID = AT1302.DivisionID
	LEFT JOIN AT1015  T19 on T19.AnaID = AT1302.I05ID AND T19.AnaTypeID =''I05'' AND T19.DivisionID = AT1302.DivisionID
	
	LEFT JOIN AV1319 on AV1319.InventoryID = OT2002.InventoryID  AND  AV1319.UnitID  = OT2002.UnitID AND AV1319.DivisionID = OT2002.DivisionID
	LEFT JOIN OT3019 on OT3019.SOKitTransactionID = OT2002.SOKitTransactionID AND OT3019.DivisionID = OT2002.DivisionID
	LEFT JOIN OV1101 on OV1101.TypeID = N''SO'' AND OV1101.OrderStatus = OT2001.OrderStatus AND OV1101.DivisionID = OT2001.DivisionID
	LEFT JOIN OT1001 on ISNULL(OT1001.Disabled,0) = 0 AND OT1001.TypeID = N''SO'' AND OT1001.ClassifyID = OT2001.ClassifyID AND OT1001.DivisionID = OT2001.DivisionID
	left join OT0005 O1 on OT2001.DivisionID = O1.DivisionID and O1.TypeID = ''Q01''
	left join OT0005 O2 on OT2001.DivisionID = O2.DivisionID and O2.TypeID = ''Q02''
	left join OT0005 O3 on OT2001.DivisionID = O3.DivisionID and O3.TypeID = ''Q03''
	left join OT0005 O4 on OT2001.DivisionID = O4.DivisionID and O4.TypeID = ''Q04''
	left join OT0005 O5 on OT2001.DivisionID = O5.DivisionID and O5.TypeID = ''Q05''
	left join OT0005 O6 on OT2001.DivisionID = O6.DivisionID and O6.TypeID = ''Q06''
	left join OT0005 O7 on OT2001.DivisionID = O7.DivisionID and O7.TypeID = ''Q07''
	left join OT0005 O8 on OT2001.DivisionID = O8.DivisionID and O8.TypeID = ''Q08''
	left join OT0005 O9 on OT2001.DivisionID = O9.DivisionID and O9.TypeID = ''Q09''
'
set @sSQL5 = @sSQL5 + N'
WHERE	OT2001.DivisionID = N''' + ISNULL(@DivisionID,'') + N''' AND 
		OT2001.SOrderID in ( N''' + ISNULL(@OrderID,'') + ''')'
--Print @sSQL+ @sSQLfrom
--print @sSQLfrom1
--PRINT @sSQL
--PRINT(@sSQL1)
--PRINT(@sSQL2)
--PRINT(@sSQL3)
--PRINT(@sSQL4)
--PRINT(@sSQL5)
	IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='OV3001')
		EXEC ('CREATE VIEW OV3001  ---TAO BOI OP3001
			AS '+@sSQL + @sSQL1 + @sSQL2 + @sSQL3+ @sSQL4 + @sSQL5)
	ELSE
		EXEC( 'ALTER VIEW OV3001  ---TAO BOI OP3001
			AS '+@sSQL + @sSQL1 + @sSQL2 + @sSQL3+ @sSQL4 + @sSQL5)




GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

