
/****** Object:  View [dbo].[OV2402]    Script Date: 12/16/2010 15:06:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

------ Create by Nguyen Van Nhan.
------ Created Date 24/08/2004.
-----  Purpose:  	Tinh hinh hang giu cho va giao hang cua SO
----		Tinh hinh hang giu cho va nhan hang cua PO

ALTER VIEW [dbo].[OV2402] as 


select 	AT2007.DivisionID,  InventoryID, WareHouseID,
	Sum(Case when KindVoucherID in (2,4,6,8) then ActualQuantity else 0 End )   SRealQuantity,
	Sum(Case when KindVoucherID in (1,5,7,9) then ActualQuantity else 0 End )   PRealQuantity
From AT2007 inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID
Where KindVoucherID in (1,2,4,5,6,7,8) and Isnull(AT2007.OrderID,'')<>''
Group by AT2007.DivisionID,  InventoryID, WareHouseID

GO


