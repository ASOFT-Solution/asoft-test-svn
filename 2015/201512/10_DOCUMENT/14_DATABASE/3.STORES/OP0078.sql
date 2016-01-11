IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0078]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0078]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load danh sách phiếu yêu cầu mua hàng
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 18/06/2015
---- Modified on 
-- <Example>
/*
	OP0078 'HD', '', 1,2015, 6, 2015
*/
CREATE PROCEDURE OP0078
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT
)
AS
SELECT O01.ROrderID, O01.VoucherTypeID, O01.VoucherNo, O01.DivisionID, O01.TranMonth, O01.TranYear, O01.OrderDate, 
	O01.ContractNo, O01.ContractDate, O01.InventoryTypeID, A01.InventoryTypeName, O01.CurrencyID, A04.CurrencyName,
	O01.ExchangeRate, O01.PaymentID, O01.ObjectID, O01.PriceListID, ISNULL(O01.ObjectName, A02.ObjectName) ObjectName,
	ISNULL(O01.VatNo, A02.VatNo) VatNo, ISNULL(O01.[Address], A02.[Address]) [Address], O01.ReceivedAddress,
	O01.ClassifyID, O11.ClassifyName, O01.EmployeeID, A03.FullName, O01.Transport, A02.IsUpdateName, A02.IsCustomer,
	A02.IsSupplier, 	
	(SELECT SUM(ISNULL(ConvertedAmount, 0) - ISNULL(DiscountConvertedAmount, 0) + ISNULL(VATConvertedAmount, 0))
	 FROM OT3102 
	 WHERE ROrderID = O01.ROrderID AND DivisionID = O01.DivisionID) ConvertedAmount,
	(SELECT SUM(ISNULL(OriginalAmount, 0) - ISNULL(DiscountOriginalAmount, 0) + ISNULL(VAToriginalAmount, 0))
	 FROM OT3102
	 WHERE ROrderID = O01.ROrderID AND DivisionID = O01.DivisionID) OriginalAmount,
	O01.[Description], O01.[Disabled], O01.OrderType, O01.OrderStatus, V01.[Description] OrderStatusName,
	V01.EDescription EOrderStatusName, V02.[Description] OrderTypeName, O01.Ana01ID, O01.Ana02ID, O01.Ana03ID,
	O01.Ana04ID, O01.Ana05ID, O02_1.AnaName Ana01Name, O02_2.AnaName Ana02Name, O02_3.AnaName Ana03Name,
	O02_4.AnaName Ana04Name, O02_5.AnaName Ana05Name, A03.FullName SalesManName, O01.SOrderID, O01.ShipDate,
	O01.DueDate, O01.CreateUserID, O01.CreateDate, O01.LastModifyUserID, O01.LastModifyDate,
	O12.[Description] IsConfirm, O12.EDescription EIsConfirm, O01.DescriptionConfirm
FROM OT3101 O01
LEFT JOIN AT1202 A02 ON A02.DivisionID = O01.DivisionID AND A02.ObjectID = O01.ObjectID
LEFT JOIN AT1004 A04 ON A04.DivisionID = O01.DivisionID AND A04.CurrencyID = O01.CurrencyID
LEFT JOIN OT1001 O11 ON O11.DivisionID = O01.DivisionID AND O11.ClassifyID = O01.ClassifyID AND O11.TypeID = 'RO'
LEFT JOIN AT1301 A01 ON A01.DivisionID = O01.DivisionID AND A01.InventoryTypeID = O01.InventoryTypeID
LEFT JOIN AT1103 A03 ON A03.DivisionID = O01.DivisionID AND A03.EmployeeID = O01.EmployeeID
LEFT JOIN OV1001 V01 ON V01.DivisionID = O01.DivisionID AND V01.OrderStatus = O01.OrderStatus AND V01.TypeID = CASE WHEN O01.OrderType <> 1 THEN 'RO' ELSE 'MO' END
LEFT JOIN OT1102 O12 ON O12.DivisionID = O01.DivisionID AND O12.Code = O01.IsConfirm AND O12.TypeID = 'SO'
LEFT JOIN OV1002 V02 ON V02.DivisionID = O01.DivisionID AND V02.OrderType = O01.OrderType AND V02.TypeID = 'RO'
LEFT JOIN OT1002 O02_1 ON O02_1.DivisionID = O01.DivisionID AND O02_1.AnaID = O01.Ana01ID AND O02_1.AnaTypeID = 'P01' 
LEFT JOIN OT1002 O02_2 ON O02_1.DivisionID = O01.DivisionID AND O02_2.AnaID = O01.Ana02ID AND O02_2.AnaTypeID = 'P02'
LEFT JOIN OT1002 O02_3 ON O02_1.DivisionID = O01.DivisionID AND O02_3.AnaID = O01.Ana03ID AND O02_3.AnaTypeID = 'P03'
LEFT JOIN OT1002 O02_4 ON O02_1.DivisionID = O01.DivisionID AND O02_4.AnaID = O01.Ana04ID AND O02_4.AnaTypeID = 'P04'
LEFT JOIN OT1002 O02_5 ON O02_1.DivisionID = O01.DivisionID AND O02_5.AnaID = O01.Ana05ID AND O02_5.AnaTypeID = 'P05'
WHERE O01.DivisionID = @DivisionID
AND O01.TranMonth + O01.TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
