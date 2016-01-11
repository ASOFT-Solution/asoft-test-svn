IF EXISTS (SELECT   TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV1023]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV1023]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
---- Tao view de load combo cho man hinh Hoa Don ban hang AF3016  khi ke thua don hang
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 20/05/2008 by Thuy Tuyen
---- 
---- Modified on 24/12/2009 by Bao Anh : Bo sung cac don hang mua
---- Modified on 08/01/2013 by Lê Thị Thu Hiền : Tách Đơn hàng sản xuất ra khỏi đơn hàng bán OrderType = 0 
-- <Example>
---- SELECT   * FROM AV1023
--- 


CREATE VIEW [dbo].[AV1023] AS
----------- Đơn hàng bán
SELECT    T00.DivisionID, SOrderID AS OrderID, VoucherNo, OrderDate, T00.OrderStatus, T00.ObjectID, T01.ObjectName, Notes, 
		T00.TranMonth, T00.TranYear, T00.OrderType, T00.ContractNo, T00.PaymentID,
		T00.Disabled, T00.DeliveryAddress AS Address , 'SO' AS Type , T00.VoucherTypeID
FROM	OT2001 T00 
LEFT JOIN AT1202 T01 on T00.ObjectID = T01.ObjectID AND T00.DivisionID = T01.DivisionID
WHERE OrderStatus not in (0, 9) AND  T00.Disabled = 0 --- not in (0, 3, 4, 9) 
AND T00.OrderType = 0
UNION ALL
----------- Đơn hàng sản xuất
SELECT  T00.DivisionID, SOrderID AS OrderID, VoucherNo, OrderDate, T00.OrderStatus, T00.ObjectID, T01.ObjectName, Notes, 
		T00.TranMonth, T00.TranYear, T00.OrderType, T00.ContractNo, T00.PaymentID,
		T00.Disabled, T00.DeliveryAddress AS Address , 'IO' AS Type , T00.VoucherTypeID
FROM	OT2001 T00 
LEFT JOIN AT1202 T01 on T00.ObjectID = T01.ObjectID AND T00.DivisionID = T01.DivisionID
WHERE OrderStatus not in (0, 9) AND  T00.Disabled = 0 --- not in (0, 3, 4, 9)
AND T00.OrderType = 1
UNION  ALL
----------Don hang hieu chinh
SELECT  T00.DivisionID, VoucherID AS OrderID, VoucherNo, VoucherDate, T00.OrderStatus, T00.ObjectID, T01.ObjectName, Description AS Notes, 
		T00.TranMonth, T00.TranYear, 0 AS OrderType, '' AS ContractNo, '' AS PaymentID,
		T00.Disabled, T00.DeliveryAddress AS Address , 'AS' AS Type , T00.VoucherTypeID
FROM	OT2006 T00 
LEFT JOIN AT1202 T01 on T00.ObjectID = T01.ObjectID AND T00.DivisionID = T01.DivisionID
WHERE OrderStatus not in (2, 3, 9) AND  T00.Disabled = 0 --- not in (0, 3, 4, 9) 
UNION ALL 
---------- Don hang mua

SELECT  T00.DivisionID, POrderID AS OrderID, VoucherNo, OrderDate, T00.OrderStatus, T00.ObjectID, T01.ObjectName, Notes, 
		T00.TranMonth, T00.TranYear, T00.OrderType, T00.ContractNo, T00.PaymentID,
		T00.Disabled, T00.ReceivedAddress AS Address , 'PO' AS Type , T00.VoucherTypeID
FROM	OT3001 T00 
LEFT JOIN AT1202 T01 on T00.ObjectID = T01.ObjectID AND T00.DivisionID = T01.DivisionID
WHERE OrderStatus not in (0, 9) AND  T00.Disabled = 0 --- not in (0, 3, 4, 9)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

