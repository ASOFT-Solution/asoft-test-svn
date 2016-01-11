
/****** Object:  View [dbo].[WV0114]    Script Date: 12/16/2010 15:44:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Created by Nguyen Quoc Huy, date 10/12/2007
--Su dung trong truong hop hieu chinh phieu nhap kho cho cac mat hang quan ly theo lo, ngay dao han, thuc te dich danh
ALTER VIEW [dbo].[WV0114] as 
Select AT0114.InventoryID, 
	AT0114.DivisionID, AT0114.WareHouseID, AT0114.ReVoucherID, AT0114.ReTransactionID, AT0114.ReVoucherNo, 
	AT0114.ReVoucherDate, AT0114.ReTranMonth, AT0114.ReTranYear, AT0114.ReSourceNo, AT0114.LimitDate, AT0114.ReQuantity, AT0114.DeQuantity, 
	AT0114.EndQuantity, AT0114.UnitPrice, AT0114.DeVoucherID, AT0114.DeTransactionID, AT0114.DeVoucherNo, AT0114.DeVoucherDate, 
	AT0114.DeLocationNo, AT0114.DeTranMonth, AT0114.DeTranYear, AT0114.Status, AT0114.IsLocked, 
	--AT0114.UnitID, AT0114.OriginalUnitID, AT0114.ReOriginalQuantity, AT0114.DeOriginalQuantity, AT0114.EndOriginalQuantity , 
	AT1302.isSource, AT1302.isLimitDate, AT1302.MethodID
From AT0114 
	inner join AT2007 on AT2007.InventoryID = AT0114.InventoryID	
				and AT2007.VoucherID = AT0114.ReVoucherID
				and AT2007.TransactionID = AT0114.ReTransactionID
	left join AT1302 on AT1302.InventoryID = AT0114.InventoryID

GO


