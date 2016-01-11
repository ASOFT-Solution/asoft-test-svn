IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0074]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0074]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load Grid danh sách phiếu điều chỉnh đơn hàng bán
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by:Thanh Sơn on: 17/06/2015
---- Modified on 
-- <Example>
/*
	OP0074 'HD','', 1, 2015, 6, 2015
*/
CREATE PROCEDURE OP0074
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT 
)
AS
SELECT O06.VoucherID, O06.DivisionID, O06.TranMonth, O06.TranYear, O06.VoucherTypeID, O06.VoucherNo, 
	O06.VoucherDate, O06.CurrencyID, O06.ExchangeRate, O06.[Description], O06.ObjectID, 
	(CASE WHEN ISNULL(O06.ObjectName, '') = '' THEN A02.ObjectName ELSE O06.ObjectName END) ObjectName,
	(CASE WHEN ISNULL(O06.[Address], '') = '' THEN A02.[Address] ELSE O06.[Address] END) [Address],
	O06.DeliveryAddress, O06.EmployeeID, O06.OrderStatus, V01.[Description] OrderStatusName, 
	V01.EDescription EOrderStatusName, O06.RefOrderID, O06.CreateDate, O06.CreateUserID, 
	O06.LastModifyDate, O06.LastModifyUserID, O06.Ana01ID, O06.Ana02ID, O06.Ana03ID, O06.Ana04ID, 
	O06.Ana05ID, O02_1.AnaName Ana01Name, O02_2.AnaName Ana02Name, O02_3.AnaName Ana03Name, 
	O02_4.AnaName Ana04Name, O02_5.AnaName Ana05Name, 
	A03.FullName, A04.CurrencyName, O06.OrderType, 
	(SELECT SUM(ISNULL(OriginalAmount, 0)) OriginalAmount FROM OT2007 WHERE VoucherID = O06.VoucherID) OriginalAmount,
	(SELECT SUM(ISNULL(ConvertedAmount, 0)) FROM OT2007 WHERE VoucherID = O06.VoucherID) ConvertedAmount
FROM OT2006 O06
left join AT1103 A03 ON A03.DivisionID = O06.DivisionID AND A03.EmployeeID = O06.EmployeeID
LEFT JOIN AT1202 A02 ON A02.DivisionID = O06.DivisionID AND A02.ObjectID = O06.ObjectID
LEFT JOIN OV1001 V01 ON V01.DivisionID = O06.DivisionID AND V01.OrderStatus = O06.OrderStatus AND V01.TypeID = 'AO'
LEFT JOIN AT1004 A04 ON A04.DivisionID = O06.DivisionID AND A04.CurrencyID = O06.CurrencyID
LEFT JOIN OT1002 O02_1 ON O02_1.DivisionID = O06.DivisionID AND O02_1.AnaID = O06.Ana01ID AND O02_1.AnaTypeID = 'S01'
LEFT JOIN OT1002 O02_2 ON O02_2.DivisionID = O06.DivisionID AND O02_2.AnaID = O06.Ana02ID AND O02_2.AnaTypeID = 'S02'
LEFT JOIN OT1002 O02_3 ON O02_3.DivisionID = O06.DivisionID AND O02_3.AnaID = O06.Ana03ID AND O02_3.AnaTypeID = 'S03'
LEFT JOIN OT1002 O02_4 ON O02_4.DivisionID = O06.DivisionID AND O02_4.AnaID = O06.Ana04ID AND O02_4.AnaTypeID = 'S04'
LEFT JOIN OT1002 O02_5 ON O02_5.DivisionID = O06.DivisionID AND O02_5.AnaID = O06.Ana05ID AND O02_5.AnaTypeID = 'S05'
WHERE O06.DivisionID = @DivisionID
AND O06.TranMonth + O06.TranYear * 100 BETWEEN @FromMonth + @FromYear * 100 AND @ToMonth + @ToYear * 100


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
