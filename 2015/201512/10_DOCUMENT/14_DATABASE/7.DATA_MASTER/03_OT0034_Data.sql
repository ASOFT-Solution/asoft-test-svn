-- <Summary>
---- Insert dữ liệu vào bảng tồn kho sẵn sàng OT0034 (dùng trong store duyệt đơn hàng OP0034)
-- <History>
---- Created on 01/10/2013 by Bảo Anh
---- Modified on ... by ...
---- <Example>
DELETE FROM OT0034
INSERT INTO OT0034 (DivisionID,WarehouseID,InventoryID,SQuantity,PQuantity,EndQuantity)
SELECT		ISNULL(OP.DivisionID, WH.DivisionID) as DivisionID,
			ISNULL(OP.WareHouseID, WH.WareHouseID) AS WareHouseID,
			ISNULL(OP.InventoryID, WH.InventoryID) AS InventoryID,
			SUM(CASE WHEN OP.TypeID <> 'PO' AND OP.Finish <> 1 THEN OP.OrderQuantity - OP.ActualQuantity ELSE 0 END) AS SQuantity,
			SUM(CASE WHEN TypeID = 'PO' AND OP.Finish <> 1 THEN OP.OrderQuantity - OP.ActualQuantity ELSE 0 END) AS PQuantity,
			SUM(ISNULL(WH.DebitQuantity, 0)) - SUM(ISNULL(WH.CreditQuantity, 0)) AS EndQuantity
FROM		OV2800 OP
FULL JOIN	OV2401 WH
ON	WH.DivisionID = OP.DivisionID AND WH.WareHouseID = OP.WareHouseID AND WH.InventoryID = OP.InventoryID
GROUP BY	ISNULL(OP.DivisionID, WH.DivisionID),ISNULL(OP.WareHouseID, WH.WareHouseID),ISNULL(OP.InventoryID, WH.InventoryID)
