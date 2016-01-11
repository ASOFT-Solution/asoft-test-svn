/****** Object:  View [dbo].[OV0001]    Script Date: 12/16/2010 15:48:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----Create by: Vo Thanh Huong, date: 30/08/2004
----purpose: Thông tin mặc định cho đơn hàng bán và đơn hàng mua (view chết)

ALTER VIEW [dbo].[OV0001]
AS
SELECT OT00.*, VoucherTypeName, 
    OV01.Description AS OrderTypeName, ClassifyName, 
    OV01.Description AS OrderStatusName, FullName, 
    CurrencyName, InventoryTypeName
FROM OT0001 OT00  left join
    AT1007 AT01 ON 
    AT01.VoucherTypeID = OT00.VoucherTypeID left join
    OV1002 OV01 ON OV01.OrderType = OT00.OrderType AND 
    OV01.TypeID = OT00.TypeID left JOIN
    OT1001 OT01 ON OT01.ClassifyID = OT00.ClassifyID AND 
    OT01.TypeID =OT00.TypeID  left  JOIN
    OV1001 OV02 ON OV02.OrderStatus = OT00.OrderStatus AND 
    OV02.TypeID = OT00.TypeID left JOIN
    AT1103 AT02 ON 
    OT00.EmployeeID = AT02.EmployeeID left JOIN
    AT1004 AT03 ON 
    OT00.CurrencyID = AT03.CurrencyID left  JOIN
    AT1301 AT04 ON 
    AT04.InventoryTypeID = OT00.InventoryTypeID

GO


