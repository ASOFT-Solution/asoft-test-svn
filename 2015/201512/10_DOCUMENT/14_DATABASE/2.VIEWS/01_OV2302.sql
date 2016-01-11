/****** Object:  View [dbo].[OV2302]    Script Date: 12/16/2010 14:55:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---Creater by : Nguyen Thi Thuy Tuyen
--Date : 23/06/2006
--- Modify on 14/05/2015 by Bảo Anh: Bổ sung số đơn hàng
--28/08/2008 

ALTER VIEW [dbo].[OV2302] ---View chet lay du lieu ho tro in tong hop tinh hinh giao hang.
AS
SELECT     OT2002.DivisionID, dbo.OT2002.InventoryID, dbo.OT2002.Quantity01, dbo.OT2003.Date01, dbo.OT2002.Quantity02, dbo.OT2003.Date02, dbo.OT2002.Quantity03, 
                      dbo.OT2003.Date03, dbo.OT2002.Quantity04, dbo.OT2003.Date04, dbo.OT2002.Quantity05, dbo.OT2003.Date05, dbo.OT2002.Quantity06, 
                      dbo.OT2003.Date06, dbo.OT2002.Quantity07, dbo.OT2003.Date07, dbo.OT2002.Quantity08, dbo.OT2003.Date08, dbo.OT2002.Quantity09, 
                      dbo.OT2003.Date09, dbo.OT2002.Quantity10, dbo.OT2003.Date10, dbo.OT2002.Quantity11, dbo.OT2003.Date11, dbo.OT2002.Quantity12, 
                      dbo.OT2003.Date12, dbo.OT2002.Quantity13, dbo.OT2003.Date13, dbo.OT2002.Quantity14, dbo.OT2003.Date14, dbo.OT2002.Quantity15, 
                      dbo.OT2003.Date15, dbo.OT2002.Quantity16, dbo.OT2003.Date16, dbo.OT2002.Quantity17, dbo.OT2003.Date17, dbo.OT2002.Quantity18, 
                      dbo.OT2003.Date18, dbo.OT2002.Quantity19, dbo.OT2003.Date19, dbo.OT2002.Quantity20, dbo.OT2003.Date20, dbo.OT2002.Quantity21, 
                      dbo.OT2003.Date21, dbo.OT2002.Quantity22, dbo.OT2003.Date22, dbo.OT2002.Quantity23, dbo.OT2003.Date23, dbo.OT2002.Quantity24, 
                      dbo.OT2003.Date24, dbo.OT2002.Quantity25, dbo.OT2003.Date25, dbo.OT2002.Quantity26, dbo.OT2003.Date26, dbo.OT2002.Quantity27, 
                      dbo.OT2003.Date27, dbo.OT2002.Quantity28, dbo.OT2003.Date28, dbo.OT2002.Quantity29, dbo.OT2003.Date29, dbo.OT2002.Quantity30, 
                      dbo.OT2003.Date30, OrderDate,TranMonth,TranYear, OT2002.TRansactionID, OT2001.VoucherNo
FROM         dbo.OT2002 inner  JOIN dbo.OT2003 ON dbo.OT2003.SOrderID = dbo.OT2002.SOrderID
			inner  JOIN dbo.OT2001 ON dbo.OT2001.SOrderID = dbo.OT2002.SOrderID

