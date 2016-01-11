/****** Object:  View [dbo].[OV2411]    Script Date: 01/13/2011 13:29:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- View chet phuc vu lay so luong ton kho thu te theo thoi gian
--Creater: Thuy Tuyen
--Date:18/05/2010

ALTER VIEW [dbo].[OV2411]
as
Select DivisionID, WareHouseID, InventoryID,KindVoucherID,Voucherdate,Tranmonth,tranyear,
isnull (Case when KindVoucherID = 0 then sum (isnull(ActualQuantity,0))  end,0 ) - 
isnull( Case when KindVoucherID = 2 then isnull(sum (isnull(ActualQuantity,0)),0)  end ,0)+
Isnull(Case when KindVoucherID in (1,3) then sum (isnull(SignQuantity,0))  end ,0)
 as EndQuantity
	From WQ7000 

 Group by KindVoucherID, WareHouseID, DivisionID, WareHouseID, InventoryID, Voucherdate,Tranmonth,Tranyear


GO


