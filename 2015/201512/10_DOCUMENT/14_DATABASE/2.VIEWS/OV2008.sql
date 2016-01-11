
/****** Object:  View [dbo].[OV2008]    Script Date: 12/16/2010 14:54:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----- Created by Nguyen Van Nhan, Date 02/01/2005
----- Purpose: View ngam lay du lieu tong so luong mat hang da xuat theo giu cho

ALTER VIEW [dbo].[OV2008] as 
Select 	T.DivisionID, 
	T.WareHouseID,
	T.InventoryID,
	isnull(T.PQuantity,0) - isnull(V.PRealQuantity,0) as PQuantity,
	isnull(T.SQuantity,0) -isnull( V.SRealQuantity,0) as SQuantity
From OT2008 T left join  OV2402 V on 	T.DivisionID = V.DivisionID and
					T.InventoryID = V.InventoryID and
					T.WareHouseID = V.WareHouseID

GO


