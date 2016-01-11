IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OV2400]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[OV2400]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--Created by: Vo Thanh Huong, date : 05/07/2005
--Purpose: (view chet) Loc ra cac don hang phuc vu cho cong tac bao cao	
----Nguyen Thi Thuy Tuyen 28/11/2006 Doi don vi tinh  lay tu OT3002 sang AT1302
--- Thuy Tuyen , 19/10/2009
---- Modified on 17/04/2013 by Le Thi Thu Hien : Bo sung Ana06 -->Ana10
---- Modified on 17/04/2013 by Le Thi Thu Hien : CONVERT(VARCHAR(2),OT3001.OrderStatus) 0021061 
---- Modified on 07/09/2015 by Tiểu Mai: Bổ sung StrParameter01 --> StrParameter10, lấy ngày nhận hàng dự kiến cuối cùng, dau tien
---- Modified on 30/12/2015 by Quốc Tuấn: Bổ sung thêm Note03-Note09
CREATE VIEW [dbo].[OV2400] AS 
SELECT OT3002.DivisionID,
	OT3001.TranMonth,
	OT3001.TranYear,	
	OT3001.TranYear AS Year,	  
	OV9999.MonthYear,
	OV9999.Quarter,
	OT3001.POrderID AS OrderID, 	
	OT3001.VoucherTypeID, 
	OT3001.VoucherNo, 
	OT3001.OrderDate AS VoucherDate, 
	OT3001.ContractNo, 
	OT3001.ContractDate, 
	OT3001.ClassifyID, 
	OT3001.OrderType, 
	OT3001.ObjectID, 
	case when ISNULL(OT3001.ObjectName, '') = '' then  AT1202.ObjectName else OT3001.ObjectName end AS ObjectName,
	OT3001.ReceivedAddress, 
	OT3001.Notes AS VDescription, 
	CONVERT(VARCHAR(2),OT3001.OrderStatus) AS OrderStatus, 	
	OT3001.CurrencyID, 
	AT1004.CurrencyName,
	OT3001.ExchangeRate, 
	OT3001.EmployeeID, 
	OT3001.Transport, 
	OT3001.PaymentID, 
	OT3001.VatNo, 
	OT3001.Address, 
	OT3001.ShipDate, 
	OT3001.Disabled, 
	ISNULL(OT3001.Ana01ID, '') AS VAna01ID, 		ISNULL(OT3001.Ana02ID, '') AS VAna02ID, 		
	ISNULL(OT3001.Ana03ID, '') AS VAna03ID, 		ISNULL(OT3001.Ana04ID, '') AS VAna04ID, 		
	ISNULL(OT3001.Ana05ID, '') AS VAna05ID,			ISNULL(OT3001.Ana06ID, '') AS VAna06ID,
	ISNULL(OT3001.Ana07ID, '') AS VAna07ID,			ISNULL(OT3001.Ana08ID, '') AS VAna08ID,
	ISNULL(OT3001.Ana09ID, '') AS VAna09ID,			ISNULL(OT3001.Ana10ID, '') AS VAna10ID,
	OT3002.TransactionID, 
	OT3002.InventoryID, 
	ISNULL(OT3002.InventoryCommonName,AT1302.InventoryName) AS InventoryName  ,
	AT1302.Specification,
	at1302.InventoryTypeID,
	OT3002.OrderQuantity, 
	OT3002.PurchasePrice, 
	ISNULL(OT3002.OriginalAmount,0) AS  OriginalAmount,
	ISNULL(OT3002.ConvertedAmount, 	0) AS ConvertedAmount,
	OT3002.VATPercent, 
	ISNULL(OT3002.VATOriginalAmount, 0) AS VATOriginalAmount,
	ISNULL(OT3002.VATConvertedAmount, 0) AS VATConvertedAmount,
	OT3002.DiscountPercent, 
	ISNULL(OT3002.DiscountOriginalAmount, 0)  AS DiscountOriginalAmount,
	ISNULL(OT3002.DiscountConvertedAmount, 0) AS DiscountConvertedAmount,
	OT3002.IsPicking, 
	OT3002.WareHouseID, 
	(ISNULL(OT3002.OriginalAmount, 0) + ISNULL(OT3002.VATOriginalAmount, 0) - ISNULL(OT3002.DiscountOriginalAmount, 0)) AS TotalOriginalAmount,
	(ISNULL(OT3002.ConvertedAmount, 0) + ISNULL(OT3002.VATConvertedAmount, 0) - ISNULL(OT3002.DiscountConvertedAmount, 0)) AS TotalConvertedAmount,
	OT3002.Orders, 
	OT3002.Description AS TDescription,  
	ISNULL(OT3002.Ana01ID, '') AS Ana01ID, 		ISNULL(OT3002.Ana02ID, '') AS Ana02ID, 		
	ISNULL(OT3002.Ana03ID, '') AS Ana03ID, 		ISNULL(OT3002.Ana04ID, '') AS Ana04ID, 		
	ISNULL(OT3002.Ana05ID, '') AS Ana05ID,		ISNULL(OT3002.Ana06ID, '') AS Ana06ID,
	ISNULL(OT3002.Ana07ID, '') AS Ana07ID,		ISNULL(OT3002.Ana08ID, '') AS Ana08ID,
	ISNULL(OT3002.Ana09ID, '') AS Ana09ID,		ISNULL(OT3002.Ana10ID, '') AS Ana10ID,
	OT3002.InventoryCommonName, 
	OT3002.AdjustQuantity, 	
	AT1302.UnitID,	
	AT1304.UnitName,	
	ISNULL(AT1302.S1, '')  AS CI1ID,	ISNULL(AT1302.S2, '')  AS CI2ID, 	ISNULL(AT1302.S3, '') AS CI3ID,  
	ISNULL(AT1302.I01ID, '') AS I01ID, 	ISNULL(AT1302.I02ID, '') AS I02ID, 	ISNULL(AT1302.I03ID, '') AS I03ID,
	ISNULL(AT1302.I04ID, '') AS I04ID, ISNULL(AT1302.I05ID, '') AS I05ID,
	ISNULL(AT1202.S1, '')  AS CO1ID,	ISNULL(AT1202.S2, '') AS CO2ID, 	ISNULL(AT1202.S3, '') AS CO3ID,
	ISNULL(AT1202.O01ID, '') AS O01ID,  ISNULL(AT1202.O02ID, '') AS O02ID, 		
	ISNULL(AT1202.O03ID, '') AS O03ID,	ISNULL( AT1202.O04ID, '') AS O04ID,  ISNULL(AT1202.O05ID, '') AS O05ID,
	OT3002.Finish,  OT3002.RefTransactionID,ROrderID, OT3002.Notes, OT3002.Notes01, OT3002.Notes02,OT3002.Notes03,
	OT3002.Notes04, OT3002.Notes05, OT3002.Notes06, OT3002.Notes07, OT3002.Notes08,	OT3002.Notes09,
	T01.AnaName AS AnaName01,	T02.AnaName AS AnaName02, 
	T03.AnaName AS AnaName03,	T04.AnaName AS AnaName04,
	T05.AnaName AS AnaName05,	T06.AnaName AS AnaName06,
	T07.AnaName AS AnaName07,	T08.AnaName AS AnaName08,
	T09.AnaName AS AnaName09,	T10.AnaName AS AnaName10,
	ISNULL(OT3002.StrParameter01,'') AS Parameter01,	ISNULL(OT3002.StrParameter02,'') AS Parameter02,
	ISNULL(OT3002.StrParameter03,'') AS Parameter03,	ISNULL(OT3002.StrParameter04,'') AS Parameter04,
	ISNULL(OT3002.StrParameter05,'') AS Parameter05,	ISNULL(OT3002.StrParameter06,'') AS Parameter06,
	ISNULL(OT3002.StrParameter07,'') AS Parameter07,	ISNULL(OT3002.StrParameter08,'') AS Parameter08,
	ISNULL(OT3002.StrParameter09,'') AS Parameter09,	ISNULL(OT3002.StrParameter10,'') AS Parameter10,
	OT3003_APG.DateEnd, OT3003_APG.DateBegin
FROM OT3002 
INNER JOIN OT3001 ON OT3001.POrderID = OT3002.POrderID AND OT3001.DivisionID = OT3002.DivisionID 
LEFT JOIN AT1011 T01  ON T01.AnaID =OT3002.Ana01ID AND T01.AnaTypeID ='A01' AND T01.DivisionID = OT3002.DivisionID
LEFT JOIN AT1011 T02 ON T02.AnaID = OT3002.Ana02ID AND T02.AnaTypeID ='A02' AND T02.DivisionID = OT3002.DivisionID
LEFT JOIN AT1011 T03 ON T03.AnaID = OT3002.Ana03ID AND T03.AnaTypeID ='A03' AND T03.DivisionID = OT3002.DivisionID
LEFT JOIN AT1011 T04 ON T04.AnaID = OT3002.Ana04ID AND T04.AnaTypeID ='A04' AND T04.DivisionID = OT3002.DivisionID
LEFT JOIN AT1011 T05 ON T05.AnaID = OT3002.Ana05ID AND T05.AnaTypeID ='A05' AND T05.DivisionID = OT3002.DivisionID

LEFT JOIN AT1011 T06 ON T06.AnaID = OT3002.Ana06ID AND T06.AnaTypeID ='A06' AND T06.DivisionID = OT3002.DivisionID
LEFT JOIN AT1011 T07 ON T07.AnaID = OT3002.Ana07ID AND T07.AnaTypeID ='A07' AND T07.DivisionID = OT3002.DivisionID
LEFT JOIN AT1011 T08 ON T08.AnaID = OT3002.Ana08ID AND T08.AnaTypeID ='A08' AND T08.DivisionID = OT3002.DivisionID
LEFT JOIN AT1011 T09 ON T09.AnaID = OT3002.Ana09ID AND T09.AnaTypeID ='A09' AND T09.DivisionID = OT3002.DivisionID
LEFT JOIN AT1011 T10 ON T10.AnaID = OT3002.Ana10ID AND T10.AnaTypeID ='A10' AND T10.DivisionID = OT3002.DivisionID

LEFT JOIN AT1302 ON AT1302.InventoryID = OT3002.InventoryID  AND AT1302.DivisionID = OT3002.DivisionID
LEFT JOIN AT1202 ON AT1202.ObjectID = OT3001.ObjectID AND AT1202.DivisionID = OT3001.DivisionID
LEFT JOIN AT1004 ON AT1004.CurrencyID = OT3001.CurrencyID AND AT1004.DivisionID = OT3001.DivisionID
LEFT JOIN AT1304 ON AT1302.UnitID = AT1304.UnitID AND AT1302.DivisionID = AT1304.DivisionID
LEFT JOIN OV9999 ON OT3001.TranMonth = OV9999.TranMonth AND OT3001.TranYear = OV9999.TranYear AND OT3001.DivisionID = OV9999.DivisionID
LEFT JOIN (Select  (select MAX(v) from (Values(OT3003.Date01),(OT3003.Date02),(OT3003.Date03),(OT3003.Date04),(OT3003.Date05),(OT3003.Date06),(OT3003.Date07),(OT3003.Date08),(OT3003.Date09),
										(OT3003.Date10),(OT3003.Date11),(OT3003.Date12),(OT3003.Date13),(OT3003.Date14),(OT3003.Date15),(OT3003.Date16),(OT3003.Date17),(OT3003.Date18),
										(OT3003.Date19),(OT3003.Date20),(OT3003.Date21),(OT3003.Date22),(OT3003.Date23),(OT3003.Date24),(OT3003.Date25),(OT3003.Date26),(OT3003.Date27),
										(OT3003.Date28),(OT3003.Date29),(OT3003.Date30))as value(v)) as DateEnd,
					(select MIN(v) from (Values(OT3003.Date01),(OT3003.Date02),(OT3003.Date03),(OT3003.Date04),(OT3003.Date05),(OT3003.Date06),(OT3003.Date07),(OT3003.Date08),(OT3003.Date09),
										(OT3003.Date10),(OT3003.Date11),(OT3003.Date12),(OT3003.Date13),(OT3003.Date14),(OT3003.Date15),(OT3003.Date16),(OT3003.Date17),(OT3003.Date18),
										(OT3003.Date19),(OT3003.Date20),(OT3003.Date21),(OT3003.Date22),(OT3003.Date23),(OT3003.Date24),(OT3003.Date25),(OT3003.Date26),(OT3003.Date27),
										(OT3003.Date28),(OT3003.Date29),(OT3003.Date30))as value(v)) as DateBegin,					
					OT3003.POrderID, OT3003.DivisionID FROM OT3003) AS OT3003_APG 
					ON OT3003_APG.DivisionID = OT3002.DivisionID AND OT3003_APG.POrderID = OT3002.POrderID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
