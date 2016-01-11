IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV1328]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV1328]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--- Created by: Nguyen Quoc Huy
--- Created Date: 25/05/2009
--- Purpose: Loc ra danh muc mat hang khuyen mai
-- Last Edit Thuy Tuyen , date 12/08/2009
-- Last Edit Quốc Tuấn lấy thêm trường PromotePercent date 08/07/2014

CREATE VIEW [dbo].[AV1328] as 

Select AT1328.DivisionID,	
	AT1328.PromoteID , 
	AT1328.VoucherID , 
	AT1328.InventoryID , 
	AT01.InventoryName,
	AT1328.FromQuantity , 
	AT1328.ToQuantity , 
	AT1328.FromDate,
	AT1328.ToDate,
	AT1328.OID,
	AT1328.Description,
	AT1338.PromoteInventoryID , 
	AT02.InventoryName as PromoteInventoryName,
	AT1338.Notes , 
	AT1338.PromoteQuantity , 
	AT1338.PromotePercent,
	AT1328.Disabled , 
	AT1328.CreateDate , 
	AT1328.CreateUserID , 
	AT1328.LastModifyDate , 
	AT1328.LastModifyUserID ,
	AT1328.IsCommon

From  AT1328 	
	Left Join AT1338  on  AT1338.VoucherID = AT1328.VoucherID AND AT1338.DivisionID = AT1328.DivisionID
	Left Join AT1302 as AT01 on  AT01.InventoryID = AT1328.InventoryID ANd AT01.DivisionID = AT1328.DivisionID
	Left Join AT1302 as AT02 on  AT02.InventoryID = AT1338.PromoteInventoryID And AT02.DivisionID = AT1338.DivisionID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

