IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OV2700]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[OV2700]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- (view chet) Loc ra cac don hang phuc vu cho cong tac bao cao Yeu cau mua hang	
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 27/04/2009 by Thuy Tuyen
---- 
--- Edited by Bao Anh	Date: 30/10/2012	Sua lai thanh tien = thanh tien + VAT - Chiet khau
---- Modified on 18/04/2013 by Le Thi Thu Hien : Bo sung Ana06--> Ana10
-- <Example>
----
 
CREATE VIEW [dbo].[OV2700] AS 
SELECT 
	Distinct
	OT3101.DivisionID,
	OT3101.TranMonth,
	OT3101.TranYear,	
	OT3101.TranYear AS Year,	  
	OV9999.MonthYear,
	OV9999.Quarter,
	OT3101.ROrderID AS OrderID, 	
	OT3101.VoucherTypeID, 
	OT3101.VoucherNo, 
	OT3101.OrderDate AS VoucherDate, 
	OT3101.ContractNo, 
	OT3101.ContractDate, 
	OT3101.ClassifyID, 
	OT3101.OrderType, 
	OT3101.ObjectID, 
	case when ISNULL(OT3101.ObjectName, '') = '' then  AT1202.ObjectName else OT3101.ObjectName end AS ObjectName,
	OT3101.ReceivedAddress, 
	OT3101.Description AS VDescription, 
	OT3101.OrderStatus, 	
	 OT3101.CurrencyID, 
	AT1004.CurrencyName,
	OT3101.ExchangeRate, 
	OT3101.EmployeeID, 
	OT3101.Transport, 
	OT3101.PaymentID, 
	OT3101.VatNo, 
	OT3101.Address, 
	OT3101.ShipDate, 
	OT3101.Disabled, 
	ISNULL(OT3101.Ana01ID, '') AS VAna01ID, 		ISNULL(OT3101.Ana02ID, '') AS VAna02ID, 		ISNULL(OT3101.Ana03ID, '') AS VAna03ID, 	
	ISNULL(OT3101.Ana04ID, '') AS VAna04ID, 		ISNULL(OT3101.Ana05ID, '') AS VAna05ID,
	OT3102.TransactionID, 
	OT3102.InventoryID, 
	Isnull (OT3102.InventoryCommonName,AT1302.InventoryName) AS InventoryName  ,
	AT1302.Specification,
	at1302.InventoryTypeID,
	OT3102.OrderQuantity, 
	OT3102.RequestPrice, 
	ISNULL(OT3102.OriginalAmount,0) AS  OriginalAmount,
	ISNULL(OT3102.ConvertedAmount, 	0) AS ConvertedAmount,
	OT3102.VATPercent, 
	ISNULL(OT3102.VATOriginalAmount, 0) AS VATOriginalAmount,
	ISNULL(OT3102.VATConvertedAmount, 0) AS VATConvertedAmount,
	OT3102.DiscountPercent, 
	ISNULL(OT3102.DiscountOriginalAmount, 0)  AS DiscountOriginalAmount,
	ISNULL(OT3102.DiscountConvertedAmount, 0) AS DiscountConvertedAmount,
	
	(ISNULL(OT3102.OriginalAmount, 0) + ISNULL(OT3102.VATOriginalAmount, 0) - ISNULL(OT3102.DiscountOriginalAmount, 0)) AS TotalOriginalAmount,
	(ISNULL(OT3102.ConvertedAmount, 0) + ISNULL(OT3102.VATConvertedAmount, 0) - ISNULL(OT3102.DiscountConvertedAmount, 0)) AS TotalConvertedAmount,
	OT3102.Orders, 
	OT3102.Description AS TDescription,  
	ISNULL(OT3102.Ana01ID, '') AS Ana01ID, 		ISNULL(OT3102.Ana02ID, '') AS Ana02ID, 		
	ISNULL(OT3102.Ana03ID, '') AS Ana03ID, 		ISNULL(OT3102.Ana04ID, '') AS Ana04ID, 		
	ISNULL(OT3102.Ana05ID, '') AS Ana05ID,		ISNULL(OT3102.Ana06ID, '') AS Ana06ID,
	ISNULL(OT3102.Ana07ID, '') AS Ana07ID,		ISNULL(OT3102.Ana08ID, '') AS Ana08ID,
	ISNULL(OT3102.Ana09ID, '') AS Ana09ID,		ISNULL(OT3102.Ana10ID, '') AS Ana10ID,
	OT3102.InventoryCommonName, 
	OT3102.AdjustQuantity, 	
	AT1302.UnitID,	
	AT1304.UnitName,	
	ISNULL(AT1302.S1, '')  AS CI1ID,		ISNULL(AT1302.S2, '')  AS CI2ID, 		ISNULL(AT1302.S3, '') AS CI3ID,  
	ISNULL(AT1302.I01ID, '') AS I01ID, 		ISNULL(AT1302.I02ID, '') AS I02ID, 		ISNULL(AT1302.I03ID, '') AS I03ID,
	ISNULL( AT1302.I04ID, '') AS I04ID, 	ISNULL(AT1302.I05ID, '') AS I05ID,
	ISNULL(AT1202.S1, '')  AS CO1ID,		ISNULL(AT1202.S2, '') AS CO2ID, 		ISNULL(AT1202.S3, '') AS CO3ID,
	ISNULL(AT1202.O01ID, '') AS O01ID,		ISNULL(AT1202.O02ID, '') AS O02ID, 		
	ISNULL(AT1202.O03ID, '') AS O03ID,		ISNULL( AT1202.O04ID, '') AS O04ID,  	ISNULL(AT1202.O05ID, '') AS O05ID,
	OT3102.Finish
FROM OT3102 
INNER JOIN OT3101 on OT3101.ROrderID = OT3102.ROrderID And OT3102.DivisionID = OT3101.DivisionID
LEFT JOIN AT1302 on AT1302.InventoryID = OT3102.InventoryID And AT1302.DivisionID = OT3102.DivisionID
LEFT JOIN AT1202 on AT1202.ObjectID = OT3101.ObjectID And AT1202.DivisionID = OT3101.DivisionID
LEFT JOIN AT1004 on AT1004.CurrencyID = OT3101.CurrencyID And AT1004.DivisionID = OT3101.DivisionID
LEFT JOIN AT1304 on AT1302.UnitID = AT1304.UnitID And AT1302.DivisionID = AT1304.DivisionID
LEFT JOIN OV9999 on OT3101.TranMonth = OV9999.TranMonth and OT3101.TranYear = OV9999.TranYear and OT3101.DivisionID = OV9999.DivisionID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

