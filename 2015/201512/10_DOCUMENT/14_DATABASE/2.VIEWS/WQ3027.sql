IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[WQ3027]'))
DROP VIEW [dbo].[WQ3027]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----- Create By: Dang Le Bao Quynh; Date 03/11/2009
----- Purpose: View chet phuc vu viec ke thua du tru chi phi lam phieu xuat kho

CREATE VIEW [dbo].[WQ3027]
AS

Select 
OT2201.EstimateID, OT2201.DivisionID, OT2201.TranMonth, OT2201.TranYear, 
OT2201.VoucherTypeID, OT2201.VoucherNo, OT2201.VoucherDate, OT2201.ObjectID, AT1202.ObjectName, OT2201.Description,  
OT2201.WareHouseID, 
OT2203.TransactionID,
OT2203.Orders, OT2203.MaterialID, M.InventoryName As MaterialName, M.UnitID, M.AccountID, OT2203.MaterialDate As EstimateExportDate,  
M.MethodID, M.IsSource, M.IsLimitDate, 
OT2203.MaterialQuantity, 
(Select Max(VoucherDate) From AT2006 Inner Join AT2007 on AT2006.VoucherID = AT2007.VoucherID Where AT2007.ETransactionID = OT2203.TransactionID) As ExportDate,
isnull((Select Sum(isnull(ActualQuantity,0)) From AT2007 Where AT2007.ETransactionID = OT2203.TransactionID),0) As InheritedQuantity,
OT2203.MaterialQuantity - isnull((Select Sum(isnull(ActualQuantity,0)) From AT2007 Where AT2007.ETransactionID = OT2203.TransactionID),0) As RemainQuantity,
MDescription, 
OT2201.PeriodID, MT1601.Description As PeriodName,
OT2202.ProductID, P.InventoryName As ProductName ,
OT2202.Ana01ID, OT2202.Ana02ID, OT2202.Ana03ID, OT2202.Ana04ID, OT2202.Ana05ID, 
OT2202.Ana06ID, OT2202.Ana07ID, OT2202.Ana08ID, OT2202.Ana09ID, OT2202.Ana10ID, 
A1.AnaName as Ana01Name, A2.AnaName as Ana02Name, A3.AnaName as Ana03Name, A4.AnaName as Ana04Name, A5.AnaName as Ana05Name,
A1.AnaName as Ana06Name, A2.AnaName as Ana07Name, A3.AnaName as Ana08Name, A4.AnaName as Ana09Name, A5.AnaName as Ana10Name,
OT2202.MOrderID, OT2202.SOrderID, OT2202.MTransactionID, OT2202.STransactionID
From OT2201 
Inner Join OT2202 On OT2201.EstimateID = OT2202.EstimateID
Inner Join OT2203 On OT2202.EstimateID = OT2203.EstimateID And OT2202.EDetailID = OT2203.EDetailID
Left Join AT1202 On OT2201.ObjectID = AT1202.ObjectID
Left Join AT1302 P On OT2202.ProductID = P.InventoryID
Left Join AT1302 M On OT2203.MaterialID = M.InventoryID
Left Join MT1601 On OT2201.PeriodID = MT1601.PeriodID
Left Join AT1011 A1 On OT2202.Ana01ID = A1.AnaID And A1.AnaTypeID = 'A01'
Left Join AT1011 A2 On OT2202.Ana02ID = A2.AnaID And A2.AnaTypeID = 'A02'
Left Join AT1011 A3 On OT2202.Ana03ID = A3.AnaID And A3.AnaTypeID = 'A03'
Left Join AT1011 A4 On OT2202.Ana04ID = A4.AnaID And A4.AnaTypeID = 'A04'
Left Join AT1011 A5 On OT2202.Ana05ID = A5.AnaID And A5.AnaTypeID = 'A05'
Left Join AT1011 A6 On OT2202.Ana06ID = A6.AnaID And A6.AnaTypeID = 'A06'
Left Join AT1011 A7 On OT2202.Ana07ID = A7.AnaID And A7.AnaTypeID = 'A07'
Left Join AT1011 A8 On OT2202.Ana08ID = A8.AnaID And A8.AnaTypeID = 'A08'
Left Join AT1011 A9 On OT2202.Ana09ID = A9.AnaID And A9.AnaTypeID = 'A09'
Left Join AT1011 A10 On OT2202.Ana10ID = A10.AnaID And A10.AnaTypeID = 'A10'

Where OT2201.OrderStatus = 1