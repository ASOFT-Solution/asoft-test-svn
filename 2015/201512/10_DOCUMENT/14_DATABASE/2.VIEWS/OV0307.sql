IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OV0307]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[OV0307]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


----Lay du lieu phuc vu bao cao Tong hop tinh hinh nhan hang(OR0302,OR0321)
----Thuy Tuyen
----12/03/2007 
---Last Edit: Thuy Tuyen... them ma phan tich nghiep vu
---- Modified on 03/05/2013 by 
---- Modified on 08/09/2015 by Tiểu Mai: Bổ sung 10 tham số, ngày nhận hàng dự kiến gần nhất
---- Modified on 06/01/2015 by Quốc Tuấn: Bổ sung ngày nhận hàng dự kiến gần nhất
-- <Example>
---- SELECT * FROM OV0307
----
CREATE VIEW [dbo].[OV0307]
as

SELECT 
		OV2400.OrderID ,  		
		OV2400.VoucherNo,           
		OV2400.VoucherDate ,
		OV2400.ObjectID,
		OV2400.ObjectName,
		OV2400.InventoryID, 
		OV2400.InventoryName, 
		OV2400.VATPercent,
		OV2400.UnitName,
		OV2400.Specification,
		OV2400.InventoryTypeID,
		ISNULL(SUM(OV2400.OrderQuantity),0) AS OrderQuantity ,
		0 AS PurchasePrice,	
		ISNULL(SUM(OV2400.OriginalAmount ),0) AS OriginalAmount ,
		ISNULL(SUM(OV2400.ConvertedAmount ),0) AS ConvertedAmount ,
		ISNULL(SUM(OV2400.TotalOriginalAmount ),0) AS TotalOriginalAmount ,
		ISNULL(SUM(OV2400.TotalConvertedAmount) ,0) AS TotalConvertedAmount,
		OV2400.ShipDate,
		OV2400.ExchangeRate,
		OV2400.AdjustQuantity,
		OV2400.DivisionID,
		OV2400.OrderStatus,
		OV2400.TranYear,		OV2400.TranMonth,
		OV2400.Finish,
		CI1ID, CI2ID, CI3ID,  
		I01ID, I02ID, I03ID, I04ID, I05ID,
		CO1ID, CO2ID, CO3ID,
		O01ID, O02ID, O03ID, O04ID, O05ID,
		CurrencyID, 	CurrencyName,
		EmployeeID,
		VAna01ID, 	 VAna02ID, 	 VAna03ID,	VAna04ID, 	 VAna05ID,
		ClassifyID,
		Ana01ID,  Ana02ID, 	Ana03ID,  Ana04ID, Ana05ID,
		Ana06ID,  Ana07ID, 	Ana08ID,  Ana09ID, Ana10ID,
		AnaName01 ,AnaName02, AnaName03 ,AnaName04 ,AnaName05,
		AnaName06 ,AnaName07, AnaName08 ,AnaName09 ,AnaName10,
		Notes, Notes01, Notes02, OV2400.DateEnd,
		OV2400.Parameter01,OV2400.Parameter02,OV2400.Parameter03,OV2400.Parameter04,OV2400.Parameter05,
		OV2400.Parameter06,OV2400.Parameter07,OV2400.Parameter08,OV2400.Parameter09,OV2400.Parameter10,
		OV2400.DateBegin
		
FROM OV2400 

GROUP BY OV2400.OrderID ,OV2400.VoucherNo,           
		OV2400.VoucherDate ,
		OV2400.ObjectID,OV2400.ObjectName,OV2400.InventoryID, OV2400.InventoryName, OV2400.VATPercent,
		OV2400.UnitName,OV2400.Specification,	OV2400.InventoryTypeID,		
		OV2400.ShipDate, OV2400.Finish,
		OV2400.AdjustQuantity,	OV2400.DivisionID,OV2400.OrderStatus,	
		OV2400.TranYear,OV2400.TranMonth,	OV2400.ExchangeRate,
		CI1ID, CI2ID, CI3ID,  		
		I01ID, I02ID, I03ID,		 I04ID, 	 I05ID,		
		CO1ID,	CO2ID,  CO3ID,		 O01ID, O02ID, 		
		O03ID,	O04ID,  O05ID, 
		CurrencyID, CurrencyName, EmployeeID, 
		VAna01ID,  VAna02ID,  VAna03ID,  VAna04ID,  VAna05ID, 
		ClassifyID,
		Ana01ID,  Ana02ID, 	Ana03ID,  Ana04ID, Ana05ID,
		Ana06ID,  Ana07ID, 	Ana08ID,  Ana09ID, Ana10ID,
		AnaName01 ,AnaName02, AnaName03 ,AnaName04 ,AnaName05,
		AnaName06 ,AnaName07, AnaName08 ,AnaName09 ,AnaName10,
		Notes, Notes01, Notes02 , OV2400.DateEnd,
		OV2400.Parameter01,OV2400.Parameter02,OV2400.Parameter03,OV2400.Parameter04,OV2400.Parameter05,
		OV2400.Parameter06,OV2400.Parameter07,OV2400.Parameter08,OV2400.Parameter09,OV2400.Parameter10,
		OV2400.DateBegin


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

