IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3004]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP3004]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




----Create by: Vo Thanh Huong, date: 16/09/2004
---purpose: Xu ly so lieu in Chao gia 
------Last Update : Nguyen thi Thuy Tuyen  :24/11/2006 lay truong InNotes03
------Last Update : Nguyen thi Thuy Tuyen  :15/10/2007  lay InventoryCommonName
--Update : Thuy Tuyen , date 24/07/2008
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [03/08/2010]
'**************************************************************/
--- Edited by Bao Anh	Date: 04/09/2012
--- Purpose: Bo sung cac truong dung cho phieu bao gia thep cua 2T
--- Edited by Bao Anh	Date: 08/10/2012	Lay them truong don gia quy doi, so ngay hieu luc, DVT quy doi
--- Edited by Bao Anh	Date: 22/10/2012	Bo sung truong MPT o detail
--- Edited by Trung Dung	Date: 22/10/2012	Bo sung truong SumConvertedAmount
--- Edited by Tieu Mai	Date: 01/09/2015 Bo sung truong QuoQuantity01, Parameter06->10, Contactor,...
CREATE PROCEDURE [dbo].[OP3004] @DivisionID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@QuotationID nvarchar(50),
				@CustomerIndex int
AS
Declare 
    @sSQL nvarchar(4000), 
    @sSQL2 nvarchar(4000), 
    @sSQLFrom nvarchar(4000), 
    @sSQLFrom2 nvarchar(4000)

Set @sSQL = '
Select OT2101.DivisionID, 
	OT2101.QuotationID, QuotationNo, QuotationDate,
	OT2101.ObjectID, 
	AT1202.ObjectName,
	AT1202.Address as ObjectAddress, 		
	AT1202.Website, 
    AT1202.Contactor,
    AT1202.Phonenumber AS PhoneContactor,
    AT1202.Email,
	AT1202.VATNo,
	OT2101.DeliveryAddress, 
	OT2101.Transport,
	OT2101.Description,
	AT1202.Tel, 	
              AT1202.Fax, 		
	OT2101.EmployeeID,  	
	
             AT1103.FullName, 	
            AT1103.Address as EmployeeAddress, 	
	OT2101.SalesManID,  	
            AT1103_SM.FullName as SalesManName, 	
           AT1103_SM.Address as SalesManAddress, 	
	OT2101.CurrencyID, AT1004.CurrencyName, OT2101.ExchangeRate,
	Attention1,	 Attention2, 	Dear, 	Condition, 
	OT2101.RefNo1, 	OT2101.RefNo2, 	OT2101.RefNo3, 	
	OT2102.InventoryID, 	
	Isnull (OT2102.InventoryCommonName,AT1302.InventoryName) as InventoryName,
 		AT1302.UnitID, 	AT1304.UnitName, 
	AT1302.I01ID, AT1302.I02ID, AT1302.I03ID, AT1302.I04ID, AT1302.I05ID,
	AT1302.Specification,   
	AT1302.Notes01 as InNotes01, AT1302.Notes02 as InNotes02,  AT1302.Notes03 as InNotes03,

	AT1310_S1.SName as SName1, AT1310_S2.SName as SName2,
	OT2102.QuoQuantity, 		OT2102.UnitPrice, 		
	OT2102.OriginalAmount, 	OT2102.ConvertedAmount, 
	OT2102.VATPercent, 	OT2102.VATOriginalAmount,	OT2102.VATConvertedAmount, 	
	OT2102.DiscountPercent, OT2102.DiscountConvertedAmount,
              isnull( OT2102.DiscountOriginalAmount,0) as DiscountOriginalAmount,
	OT2102.Orders, 	OT2101.EndDate,
	OT2101.Ana01ID,
	OT2101.Ana02ID,
	OT2101.Ana03ID,
	OT2101.Ana04ID,
	OT2101.Ana05ID,
	Ana01.AnaName as Ana01Name ,
	Ana02.AnaName as Ana02Name ,
	Ana03.AnaName as Ana03Name ,
	Ana04.AnaName as Ana04Name ,
	Ana05.AnaName as Ana05Name ,
	Ana01.AnaNameE as Ana01NameE ,
	Ana02.AnaNameE as Ana02NameE ,
	Ana03.AnaNameE as Ana03NameE ,
	Ana04.AnaNameE as Ana04NameE ,
	Ana05.AnaNameE as Ana05NameE ,	
	isnull(OT2102.OriginalAmount, 0) + isnull(OT2102.VATOriginalAmount, 0) - isnull(OT2102.DiscountOriginalAmount, 0) as TotalOriginalAmount,
	isnull(OT2102.ConvertedAmount, 0) + isnull(OT2102.VATConvertedAmount, 0) - isnull(OT2102.DiscountConvertedAmount, 0) as TotalConvertedAmount,
	OT2102.Notes,  OT2102.Notes01, OT2102.Notes02  ,
	OT2101.PaymentTermID,
	CASE WHEN ' + CAST(@CustomerIndex AS NVARCHAR) + ' = 5 THEN OT2101.Varchar01 ELSE AT1208.PaymentTermName END AS PaymentTermName,
	OT2101.PaymentID,
	CASE WHEN ' + CAST(@CustomerIndex AS NVARCHAR) + ' = 5 THEN OT2101.Varchar02 ELSE AT1205.PaymentName END AS PaymentName,
	AT1103.Tel AS EmployeeTel,
	a00003.Image01ID,
	 (CASE WHEN a00003.Image01ID IS NULL THEN 0 ELSE 1 END ) AS IsImage01,
	 OT2101.OrderStatus,
	 QOStatus.Description as OrderStatusName,
	 QOStatus.EDescription as OrderStatusNameE,
'
set @sSQL2 = '
	OT2101.Varchar01,
	OT2101.Varchar02,
	OT2101.Varchar03,
	OT2101.Varchar04,
	OT2101.Varchar05,
	OT2101.Varchar06,
	OT2101.Varchar07,
	OT2101.Varchar08,
	OT2101.Varchar09,
	OT2101.Varchar10,
	OT2101.Varchar11,
	OT2101.Varchar12,
	OT2101.Varchar13,
	OT2101.Varchar14,
	OT2101.Varchar15,
	OT2101.Varchar16,
	OT2101.Varchar17,
	OT2101.Varchar18,
	OT2101.Varchar19,
	OT2101.Varchar20,	
	OT2102.Barcode,
	OT2102.Markup,
	AT1202.Note,
	O1.UserName as UserName01, O1.UserNameE as UserName01E,
	O2.UserName as UserName02, O2.UserNameE as UserName02E,
	O3.UserName as UserName03, O3.UserNameE as UserName03E,
	O4.UserName as UserName04, O4.UserNameE as UserName04E,
	O5.UserName as UserName05, O5.UserNameE as UserName05E,
	O6.UserName as UserName06, O6.UserNameE as UserName06E,
	O7.UserName as UserName07, O7.UserNameE as UserName07E,
	O8.UserName as UserName08, O8.UserNameE as UserName08E,
	O9.UserName as UserName09, O9.UserNameE as UserName09E,
	OT2101.IsConfirm,
	AT1202.Note1, AT1001.CountryName, AT1202.PhoneNumber,
	OT2102.Parameter01, OT2102.Parameter02, OT2102.Parameter03, OT2102.Parameter04, OT2102.Parameter05,
	OT2102.ConvertedQuantity, OT2102.QuoQuantity01, OT2102.ConvertedSalePrice, OT2101.NumOfValidDays, OT2102.UnitID as ConvertedUnitID,
	AT1304_1.UnitName as ConvertedUnitName,
	OT2102.Ana01ID as DAna01ID, OT2102.Ana02ID as DAna02ID, OT2102.Ana03ID as DAna03ID, OT2102.Ana04ID as DAna04ID, OT2102.Ana05ID as DAna05ID,
	A01.AnaName as DAna01Name, A02.AnaName as DAna02Name, A03.AnaName as DAna03Name, A04.AnaName as DAna04Name, A05.AnaName as DAna05Name,
	OT2102.Ana06ID as DAna06ID, OT2102.Ana07ID as DAna07ID, OT2102.Ana08ID as DAna08ID, OT2102.Ana09ID as DAna09ID, OT2102.Ana10ID as DAna10ID,
	A07.AnaName as DAna06Name, A08.AnaName as DAna07Name, A09.AnaName as DAna08Name, A10.AnaName as DAna09Name, A00.AnaName as DAna10Name,
	SumConvertedAmount=(Select sum(ConvertedAmount) from OT2102 Where QuotationID='''+@QuotationID+'''),
	A06.DivisionName, A06.[Address] AS Address01, A06.Tel AS Tel01, A06.Email AS Email01, A06.Fax AS Fax01,
	OT2102.QD01, OT2102.QD02,OT2102.QD03,OT2102.QD04,OT2102.QD05,OT2102.QD06,OT2102.QD07,OT2102.QD08,OT2102.QD09,OT2102.QD10,AT1302.InventoryTypeID
'
set @sSQLFrom = 
'From OT2101 inner join OT2102 on OT2102.QuotationID = OT2101.QuotationID and OT2102.DivisionID = OT2101.DivisionID
	left join AT1202 on  AT1202.ObjectID = OT2101.ObjectID 	and AT1202.DivisionID = OT2101.DivisionID
	left join AT1302 on AT1302.InventoryID = OT2102.InventoryID and AT1302.DivisionID = OT2102.DivisionID
	left join AT1310  AT1310_S1 on AT1310_S1.STypeID= ''I01'' and AT1310_S1.S = AT1302.S1 and AT1310_S1.DivisionID = AT1302.DivisionID
	left join AT1310  AT1310_S2 on AT1310_S2.STypeID= ''I02'' and AT1310_S2.S = AT1302.S2 and AT1310_S2.DivisionID = AT1302.DivisionID
	left join AT1304 on AT1304.UnitID = AT1302.UnitID and AT1304.DivisionID = AT1302.DivisionID
	left join AT1103 on  AT1103.EmployeeID = OT2101.EmployeeID and AT1103.DivisionID = OT2101.DivisionID 
	left join AT1103 AT1103_SM on  AT1103_SM.EmployeeID = OT2101.SalesManID and AT1103_SM.DivisionID = OT2101.DivisionID 
	left join AT1205 on AT1205.PaymentID = OT2101.PaymentID and AT1205.DivisionID = OT2101.DivisionID
	left join AT1208 on AT1208.PaymentTermID = OT2101.PaymentTermID and AT1208.DivisionID = OT2101.DivisionID
	left join AT1004 on AT1004.CurrencyID = OT2101.CurrencyID and AT1004.DivisionID = OT2101.DivisionID
	left join A00003 a00003 on AT1302.InventoryID = a00003.InventoryID and AT1302.DivisionID = a00003.DivisionID
'
set @sSQLFrom2 = '
	left join OT1002 Ana01 on OT2101.Ana01ID = Ana01.AnaID and OT2101.DivisionID = Ana01.DivisionID and Ana01.AnaTypeID = ''S01''
	left join OT1002 Ana02 on OT2101.Ana02ID = Ana02.AnaID and OT2101.DivisionID = Ana02.DivisionID and Ana02.AnaTypeID = ''S02''
	left join OT1002 Ana03 on OT2101.Ana03ID = Ana03.AnaID and OT2101.DivisionID = Ana03.DivisionID and Ana03.AnaTypeID = ''S03''
	left join OT1002 Ana04 on OT2101.Ana04ID = Ana04.AnaID and OT2101.DivisionID = Ana04.DivisionID and Ana04.AnaTypeID = ''S04''
	left join OT1002 Ana05 on OT2101.Ana05ID = Ana05.AnaID and OT2101.DivisionID = Ana05.DivisionID and Ana05.AnaTypeID = ''S05''
	left join OT1101 QOStatus on OT2101.OrderStatus = QOStatus.OrderStatus And OT2101.DivisionID = QOStatus.DivisionID and QOStatus.TypeID = ''QO''
	left join OT0005 O1 on OT2101.DivisionID = O1.DivisionID and O1.TypeID = ''Q01''
	left join OT0005 O2 on OT2101.DivisionID = O2.DivisionID and O2.TypeID = ''Q02''
	left join OT0005 O3 on OT2101.DivisionID = O3.DivisionID and O3.TypeID = ''Q03''
	left join OT0005 O4 on OT2101.DivisionID = O4.DivisionID and O4.TypeID = ''Q04''
	left join OT0005 O5 on OT2101.DivisionID = O5.DivisionID and O5.TypeID = ''Q05''
	left join OT0005 O6 on OT2101.DivisionID = O6.DivisionID and O6.TypeID = ''Q06''
	left join OT0005 O7 on OT2101.DivisionID = O7.DivisionID and O7.TypeID = ''Q07''
	left join OT0005 O8 on OT2101.DivisionID = O8.DivisionID and O8.TypeID = ''Q08''
	left join OT0005 O9 on OT2101.DivisionID = O9.DivisionID and O9.TypeID = ''Q09''
	left join OT0005 c on OT2102.DivisionID = c.DivisionID and c.TypeID = ''Q01''
	left join OT0005 c1 on OT2102.DivisionID = c1.DivisionID and c1.TypeID = ''Q02''
	left join OT0005 c2 on OT2102.DivisionID = c2.DivisionID and c2.TypeID = ''Q03''
	left join OT0005 c3 on OT2102.DivisionID = c3.DivisionID and c3.TypeID = ''Q04''
	left join OT0005 c4 on OT2102.DivisionID = c4.DivisionID and c4.TypeID = ''Q05''
	left join OT0005 c5 on OT2102.DivisionID = c5.DivisionID and c5.TypeID = ''Q06''
	left join OT0005 c6 on OT2102.DivisionID = c6.DivisionID and c6.TypeID = ''Q07''
	left join OT0005 c7 on OT2102.DivisionID = c7.DivisionID and c7.TypeID = ''Q08''
	left join OT0005 c8 on OT2102.DivisionID = c8.DivisionID and c8.TypeID = ''Q09''
	left join OT0005 c9 on OT2102.DivisionID = c9.DivisionID and c9.TypeID = ''Q10''
	left join AT1001 on AT1202.CountryID = AT1001.CountryID and AT1202.DivisionID = AT1001.DivisionID
	left join AT1304 AT1304_1 on AT1304_1.UnitID = OT2102.UnitID and AT1304_1.DivisionID = OT2102.DivisionID
	left join AT1011 A01 on OT2102.Ana01ID = A01.AnaID and OT2102.DivisionID = A01.DivisionID and A01.AnaTypeID = ''A01''
	left join AT1011 A02 on OT2102.Ana02ID = A02.AnaID and OT2102.DivisionID = A02.DivisionID and A02.AnaTypeID = ''A02''
	left join AT1011 A03 on OT2102.Ana03ID = A03.AnaID and OT2102.DivisionID = A03.DivisionID and A03.AnaTypeID = ''A03''
	left join AT1011 A04 on OT2102.Ana04ID = A04.AnaID and OT2102.DivisionID = A04.DivisionID and A04.AnaTypeID = ''A04''
	left join AT1011 A05 on OT2102.Ana05ID = A05.AnaID and OT2102.DivisionID = A05.DivisionID and A05.AnaTypeID = ''A05''
	LEFT JOIN AT1101 A06 ON OT2101.DivisionID = A06.DivisionID
	left join AT1011 A07 on OT2102.Ana06ID = A07.AnaID and OT2102.DivisionID = A07.DivisionID and A07.AnaTypeID = ''A06''
	left join AT1011 A08 on OT2102.Ana07ID = A08.AnaID and OT2102.DivisionID = A08.DivisionID and A08.AnaTypeID = ''A07''
	left join AT1011 A09 on OT2102.Ana08ID = A09.AnaID and OT2102.DivisionID = A09.DivisionID and A09.AnaTypeID = ''A08''
	left join AT1011 A10 on OT2102.Ana09ID = A10.AnaID and OT2102.DivisionID = A10.DivisionID and A10.AnaTypeID = ''A09''
	left join AT1011 A00 on OT2102.Ana10ID = A00.AnaID and OT2102.DivisionID = A00.DivisionID and A00.AnaTypeID = ''A10''
Where OT2101.QuotationID =''' + @QuotationID + ''''

---PRINT @sSQL + @sSQL2 + @sSQLFrom + @sSQLFrom2

If not exists (Select 1 From sysObjects Where Xtype = 'V' and Name = 'OV2101')
	exec('Create view OV2101 ----tao boi OP3004
			as ' + @sSQL + @sSQL2 + @sSQLFrom + @sSQLFrom2)
else
	exec('Alter view OV2101 ---tao boi OP3004
			as ' + @sSQL + @sSQL2 + @sSQLFrom + @sSQLFrom2)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
