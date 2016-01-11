/****** Object:  View [dbo].[OV2401]    Script Date: 12/16/2010 15:05:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

------- 	Created by Nguyen Van Nhan.
------- 	Created Date 24/08/2004
------ 	Purpose:  Tinh hinh nhap xuat cua cac mat hang (view chet)
---------    Last Update 12/100/2006

ALTER VIEW [dbo].[OV2401] as 
----- So du
Select 	AT2017.DivisionID,  WareHouseID,  InventoryID, 
	Sum(ActualQuantity) as 	DebitQuantity,
	0 as			CreditQuantity
From AT2017 inner join AT2016 on AT2016.VoucherID = AT2017.VoucherID
Group by AT2017.DivisionID,  WareHouseID,  InventoryID
Union All  --- Nhap kho
Select 	AT2008.DivisionID,  WareHouseID,  InventoryID, 
	Sum(DebitQuantity) as 	DebitQuantity,
	0 as			CreditQuantity
From AT2008 

Group by AT2008.DivisionID, WareHouseID ,  InventoryID

Union All  ---- Xuat kho

Select 	AT2008.DivisionID,  WareHouseID,  InventoryID, 
	0 as 	DebitQuantity,
	Sum(CreditQuantity) as	CreditQuantity
From AT2008 

Group by AT2008.DivisionID,  WareHouseID, InventoryID

GO


