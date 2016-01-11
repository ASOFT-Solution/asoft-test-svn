IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0036]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV0036]
GO
/****** Object: View [dbo].[AV0036] Script Date: 01/04/2011 15:40:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----- View chet
----- Create By: Dang Le Bao Quynh; Date: 03/07/2007
----- Purpose: View phuc vu In bao cao xuat kho theo bo chi tiet
----- Last Edit Thiên Huỳnh: Lấy InventoryName theo AT2007.InventoryID
----- Last Edit by Mai Duyen Date: 17/06/2014 Purpose: Sua loi mat hang chi tiet len khong dung,khi 1 mat hang co 2 bo Kit(KH Printtech)
----- Last Edit by Mai Duyen Date: 26/08/2014 Purpose: Sua loi mat hang chi tiet len khong dung,khi 1 mat hang co 2 bo Kit co so luong trung nhau(KH Printtech)
CREATE VIEW [dbo].[AV0036]
AS
SELECT 
V35.VOucherNo AS VoucherNo_AV0035, 
V35.VoucherDate AS VoucherDate_AV0035, 
V35.WareHouseID AS WareHouseID_AV0035, 
V35.ObjectID AS ObjectID_AV0035, 
V35.ObjectName AS ObjectName_AV0035, 
V35.Description AS Description_AV0035, 
V35.VoucherID AS VoucherID_AV0035, 
V35.WareHouseName AS WareHouseName_AV0035, 
V35.InventoryID AS InventoryID_AV0035, 
V35.InventoryName AS InventoryName_AV0035, 
V35.UnitID AS UnitID_AV0035, 
V35.ActualQuantity AS ActualQuantity_AV0035, 
V35.Notes AS Notes_AV0035, 
V35.DivisionID AS DivisionID_AV0035, 
V35.TranMonth AS TranMonth_AV0035, 
V35.TranYear AS TranYear_AV0035, 
V35.DebitAccountID AS DebitAccountID_AV0035, 
V35.CreditAccountID AS CreditAcountID_AV0035,
T07.*,
AT1302.InventoryName
--,V35.ApportionID as KitID

FROM AV0035 V35 
INNER JOIN AT2007 T07 ON V35.VoucherID = T07.VoucherID AND V35.DivisionID = T07.DivisionID AND V35.InventoryID = T07.ProductID
						AND T07.ActualQuantity = V35.ActualQuantity * (select ItemQuantity from AT1326 Where InventoryID = V35.InventoryID and KitID = V35.ApportionID and ItemID = T07.InventoryID)	
INNER JOIN AT1302 ON AT1302.InventoryID = T07.InventoryID AND AT1302.DivisionID = T07.DivisionID

GO


