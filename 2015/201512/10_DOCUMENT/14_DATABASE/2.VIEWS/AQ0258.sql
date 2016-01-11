IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AQ0258]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AQ0258]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by: Bao Anh , date : 13/06/2012
--- Purpose: Tra ra cac phieu nhap kho chưa duoc ke thua lap phieu mua hang
--- Edited by: Bao Anh	Date: 22/08/2012
--- Purpose: Bo sung phieu xuat kho

CREATE VIEW [dbo].[AQ0258] as
Select 
	AT2006.DivisionID, AT2006.TranMonth, AT2006.TranYear, AT2007.VoucherID, AT2006.KindVoucherID,
	AT2007.TransactionID, AT2007.InventoryID, AT2007.ActualQuantity,
	(isnull(ActualQuantity, 0) - isnull(ActualQuantityHD,0)) as EndQuantity
From AT2006
inner join AT2007 on AT2007.VoucherID = AT2006.VoucherID and AT2007.DivisionID = AT2006.DivisionID

Left join (
	Select AT9000.DivisionID, AT9000.WOrderID, WTransactionID, InventoryID, sum(Quantity) As ActualQuantityHD
	From AT9000
	Where isnull(AT9000.WOrderID,'') <>'' and TransactionTypeID IN ('T03','T04')
	Group by AT9000.DivisionID, AT9000.WOrderID, InventoryID, WTransactionID
	) as K  on AT2006.DivisionID = K.DivisionID and AT2007.VoucherID = K.WOrderID and AT2007.InventoryID = K.InventoryID and
			AT2007.TransactionID = K.WTransactionID and K.DivisionID = AT2007.DivisionID	

WHERE KindVoucherID IN(1,2)