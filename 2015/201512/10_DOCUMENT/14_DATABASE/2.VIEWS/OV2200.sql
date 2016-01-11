IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OV2200]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[OV2200]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- (view chet) Loc ra phieu chao gia phuc vu cho cong tac bao cao	
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 05/07/2005 by Vo Thanh Huong
---- 
---- Last Edit: Thuy Tuyen, date 23/10/2009
---- Edited by B.Anh	Date: 05/08/2010	Purpose: Lay them MPT 4 & 5 cua OT2102
---- Modified on 18/04/2013 by Le Thi Thu Hien : Bo sung Ana06--> Ana10
---- Modified on 29/09/2015 by Tieu Mai: bổ sung 10 tham số, mã và tên 10 MPT
-- <Example>
----

CREATE VIEW [dbo].[OV2200] AS 
SELECT 
	Distinct
	OT2101.DivisionID,
	OT2101.TranMonth,
	OT2101.TranYear,	
	OT2101.TranYear AS Year,	  
	OV9999.MonthYear,
	OV9999.Quarter,
	OT2101.QuotationID AS OrderID, 	
	OT2101.VoucherTypeID, 
	OT2101.QuotationNo AS VoucherNo , 
	OT2101.QuotationDate AS VoucherDate, 
	OT2101.ClassifyID, 
	OT2101.ObjectID, 
	case when ISNULL(OT2101.ObjectName, '') = '' then  AT1202.ObjectName else OT2101.ObjectName end AS ObjectName,
	OT2101.DeliveryAddress, 
	OT2101.Description AS VDescription, 
	OT2101.OrderStatus, 	
	OT2101.CurrencyID, 
	OT2101.ExchangeRate, 
	OT2101.EmployeeID, 
	OT2101.SalesManID, 
	OT2101.Transport, 
	OT2101.PaymentID, 
	OT2101.PaymentTermID,
	OT2101.Disabled, 
	ISNULL(OT2101.Ana01ID, '') AS VAna01ID, 		
	ISNULL(OT2101.Ana02ID, '') AS VAna02ID, 		
	ISNULL(OT2101.Ana03ID, '') AS VAna03ID, 	
	OT2102.TransactionID, 
	OT2102.InventoryID, 
	AT1302.InventoryName,
	
	AT1302.InventoryTypeID,
	AT1302.Notes01 AS InNotes01,
	AT1302.Notes02 AS InNotes02,
	AT1310_S1.SName AS SName1,
	AT1310_S2.SName AS SName2,
	AT1302.Specification,
	OT2102.QuoQuantity AS OrderQuantity, 
	OT2102.UnitPrice, 
	ISNULL(OT2102.OriginalAmount,0) AS  OriginalAmount,
	ISNULL(OT2102.ConvertedAmount, 	0) AS ConvertedAmount,
	OT2102.VATPercent, 
	ISNULL(OT2102.VATOriginalAmount, 0) AS VATOriginalAmount,
	ISNULL(OT2102.VATConvertedAmount, 0) AS VATConvertedAmount,
	OT2102.DiscountPercent, 
	ISNULL(OT2102.DiscountOriginalAmount, 0)  AS DiscountOriginalAmount,
	ISNULL(OT2102.DiscountConvertedAmount, 0) AS DiscountConvertedAmount,
	(ISNULL(OT2102.OriginalAmount, 0) + ISNULL(OT2102.VATOriginalAmount, 0) - ISNULL(OT2102.DiscountOriginalAmount, 0) ) AS TotalOriginalAmount,
	(ISNULL(OT2102.ConvertedAmount, 0) + ISNULL(OT2102.VATConvertedAmount, 0) - ISNULL(OT2102.DiscountConvertedAmount, 0)) AS TotalConvertedAmount,
	OT2102.Orders, 
	ISNULL(OT2102.Ana01ID, '') AS Ana01ID, 		ISNULL(OT2102.Ana02ID, '') AS Ana02ID, 		
	ISNULL(OT2102.Ana03ID, '') AS Ana03ID, 		ISNULL(OT2102.Ana04ID, '') AS Ana04ID, 		
	ISNULL(OT2102.Ana05ID, '') AS Ana05ID,		ISNULL(OT2102.Ana06ID, '') AS Ana06ID,
	ISNULL(OT2102.Ana07ID, '') AS Ana07ID,		ISNULL(OT2102.Ana08ID, '') AS Ana08ID,
	ISNULL(OT2102.Ana09ID, '') AS Ana09ID,		ISNULL(OT2102.Ana10ID, '') AS Ana10ID,
	Ana01.AnaName AS Ana01Name,					Ana02.AnaName AS Ana02Name,
	Ana03.AnaName AS Ana03Name,					Ana04.AnaName AS Ana04Name,
	Ana05.AnaName AS Ana05Name,					Ana06.AnaName AS Ana06Name,
	Ana07.AnaName AS Ana07Name,					Ana08.AnaName AS Ana08Name,
	Ana09.AnaName AS Ana09Name,					Ana10.AnaName AS Ana10Name,
	OT2102.InventoryCommonName, 
	AT1302.UnitID,	
	AT1304.UnitName,
	ISNULL(AT1302.S1, '') AS CI1ID,			ISNULL(AT1302.S2, '') AS CI2ID,			ISNULL(	AT1302.S3, '') AS CI3ID,
	ISNULL(AT1302.I01ID, '') AS I01ID, 		ISNULL(AT1302.I02ID, '') AS I02ID, 		
	ISNULL(AT1302.I03ID, '') AS I03ID,		ISNULL(AT1302.I04ID, '') AS I04ID,		ISNULL(AT1302.I05ID, '') AS I05ID,
	ISNULL(AT1202.S1,'') AS CO1ID,			ISNULL(AT1202.S2, '') AS CO2ID, 		ISNULL(AT1202.S3, '') AS CO3ID,
	ISNULL(AT1202.O01ID, '') AS O01ID, 		ISNULL(AT1202.O02ID, 	'') AS O02ID,
	ISNULL(AT1202.O03ID,	'') AS O03ID,	ISNULL( AT1202.O04ID, '') AS O04ID,
	ISNULL(AT1202.O05ID, '') AS O05ID,
	OV1001.Description AS StatusName,
	OV1001.EDescription AS EStatusName,
	OT2001.OrderDate AS SOrderDate,
	OT2001.VoucherNo AS SOrderNo,
	OT2102.QD01,OT2102.QD02,OT2102.QD03,OT2102.QD04,OT2102.QD05,OT2102.QD06,OT2102.QD07,OT2102.QD08,OT2102.QD09,OT2102.QD10,
	OT2102.QuoQuantity01
	
FROM OT2102 
inner join OT2101 ON OT2101.DivisionID = OT2102.DivisionID and OT2101.QuotationID = OT2102.QuotationID 
LEFT JOIN AT1302 ON AT1302.DivisionID = OT2102.DivisionID and AT1302.InventoryID = OT2102.InventoryID 
LEFT JOIN AT1202 ON AT1202.DivisionID = OT2102.DivisionID and AT1202.ObjectID = OT2101.ObjectID
LEFT JOIN AT1304 ON AT1304.DivisionID = OT2102.DivisionID and AT1302.UnitID = AT1304.UnitID
LEFT JOIN OV9999 ON OV9999.DivisionID = OT2102.DivisionID and OT2101.TranMonth = OV9999.TranMonth and OT2101.TranYear = OV9999.TranYear		
LEFT JOIN OT2001 ON OT2001.DivisionID = OT2102.DivisionID and OT2001.QuotationID = OT2101.QuotationID and OT2001.OrderType = 0
LEFT JOIN OV1001 ON OV1001.DivisionID = OT2102.DivisionID and OV1001.TypeID = 'QO' and OV1001.OrderStatus = OT2101.OrderStatus
LEFT JOIN AT1310  AT1310_S1 ON AT1310_S1.DivisionID = OT2102.DivisionID and AT1310_S1.STypeID= 'I01' and AT1310_S1.S = AT1302.S1 
LEFT JOIN AT1310  AT1310_S2 ON AT1310_S2.DivisionID = OT2102.DivisionID and AT1310_S2.STypeID= 'I02' and AT1310_S2.S = AT1302.S2
LEFT JOIN AT1011 Ana01 ON Ana01.DivisionID = OT2102.DivisionID AND OT2102.Ana01ID = Ana01.AnaID AND Ana01.AnaTypeID = 'A01'
LEFT JOIN AT1011 Ana02 ON Ana02.DivisionID = OT2102.DivisionID AND OT2102.Ana02ID = Ana02.AnaID AND Ana02.AnaTypeID = 'A02'
LEFT JOIN AT1011 Ana03 ON Ana03.DivisionID = OT2102.DivisionID AND OT2102.Ana03ID = Ana03.AnaID AND Ana03.AnaTypeID = 'A03'
LEFT JOIN AT1011 Ana04 ON Ana04.DivisionID = OT2102.DivisionID AND OT2102.Ana04ID = Ana04.AnaID AND Ana04.AnaTypeID = 'A04'
LEFT JOIN AT1011 Ana05 ON Ana05.DivisionID = OT2102.DivisionID AND OT2102.Ana05ID = Ana05.AnaID AND Ana05.AnaTypeID = 'A05'
LEFT JOIN AT1011 Ana06 ON Ana06.DivisionID = OT2102.DivisionID AND OT2102.Ana06ID = Ana06.AnaID AND Ana06.AnaTypeID = 'A06'
LEFT JOIN AT1011 Ana07 ON Ana07.DivisionID = OT2102.DivisionID AND OT2102.Ana07ID = Ana07.AnaID AND Ana07.AnaTypeID = 'A07'
LEFT JOIN AT1011 Ana08 ON Ana08.DivisionID = OT2102.DivisionID AND OT2102.Ana08ID = Ana08.AnaID AND Ana08.AnaTypeID = 'A08'
LEFT JOIN AT1011 Ana09 ON Ana09.DivisionID = OT2102.DivisionID AND OT2102.Ana09ID = Ana09.AnaID AND Ana09.AnaTypeID = 'A09'
LEFT JOIN AT1011 Ana10 ON Ana10.DivisionID = OT2102.DivisionID AND OT2102.Ana10ID = Ana10.AnaID AND Ana10.AnaTypeID = 'A10'


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

