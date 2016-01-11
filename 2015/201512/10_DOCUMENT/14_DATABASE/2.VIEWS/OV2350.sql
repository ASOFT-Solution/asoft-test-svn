
/****** Object:  View [dbo].[OV2350]    Script Date: 12/16/2010 15:01:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----Created by: Vo Thanh Huong, date: 22/12/2005
----purpose: Tinh Luong ton kho tuc thoi


ALTER VIEW [dbo].[OV2350] as 
--So du hang ton kho
Select 	AT2017.DivisionID, InventoryID, 
	Sum(isnull(ActualQuantity,0)) as 	DebitQuantity,
	0 as			CreditQuantity
From AT2017 inner join AT2016 on AT2016.VoucherID = AT2017.VoucherID
Group by  AT2017.DivisionID, InventoryID
Union All  --- Nhap kho
Select 	AT2007.DivisionID,InventoryID, 
	Sum(isnull(ActualQuantity,0)) as 	DebitQuantity,
	0 as			CreditQuantity
From AT2007 inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID
Where KindVoucherID in (1,3,5,7,9)
Group by  AT2007.DivisionID, InventoryID
Union All  ---- Xuat kho
Select 	 AT2007.DivisionID,InventoryID, 
	0 as 	DebitQuantity,
	Sum(isnull(ActualQuantity,0)) as			CreditQuantity
From AT2007 inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID
Where KindVoucherID in (2,4,6,8)
Group by AT2007.DivisionID, InventoryID

GO


