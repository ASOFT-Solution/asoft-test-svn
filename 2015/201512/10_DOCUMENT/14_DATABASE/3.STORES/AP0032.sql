IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0032]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].AP0032
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load chi tiết xuất kho theo bộ
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: Thanh Sơn on 10/07/2014
-- <Example>
/*
    EXEC AP0032
*/

 CREATE PROCEDURE AP0032
(
     @DivisionID NVARCHAR(2000),
     @UserID VARCHAR(50),
     @VoucherID VARCHAR(50)
)
AS
DECLARE @sSQL NVARCHAR(MAX)
SET @ssQL = '
SELECT T26.VoucherTypeID, T26.VoucherNo, T26.VoucherDate, T26.RefNo01, T26.RefNo02, T32.InventoryTypeID, T26.ObjectID, T26.WareHouseID,
	T26.EmployeeID, T27.TransactionID, T26.VoucherID, T27.InventoryID, T32.InventoryName, T27.UnitID, T34.UnitName,
	T27.ActualQuantity OldQuantity, T27.ActualQuantity, T26.[Description], T26.TranMonth, T26.TranYear,	T26.DivisionID, T27.DebitAccountID, 	
	T26.ReDeTypeID,	T26.[Status], T27.ConversionFactor, T27.CreditAccountID, T27.ApportionTable, T27.ApportionID, T27.ReTransactionID,
	T27.ReVoucherID, T27.Ana01ID, T27.Ana02ID, T27.Ana03ID,	T27.Ana04ID, T27.Ana05ID, T27.Ana06ID, T27.Ana07ID, T27.Ana08ID, T27.Ana09ID,
	T27.Ana10ID, T27.Orders, T27.Notes, T24.OrderNo, T32.AccountID,	T27.PeriodID, T27.OrderID, M01.[Description] PeriodName
FROM AT2027 T27	
	INNER JOIN AT1302 T32 on T32.InventoryID = T27.InventoryID and T32.DivisionID = T27.DivisionID
	LEFT JOIN AT1304 T34 on T34.UnitID = T27.UnitID and T34.DivisionID = T27.DivisionID
	INNER JOIN AT2026 T26 on T26.VoucherID = T27.VoucherID and T26.DivisionID = T27.DivisionID
	LEFT JOIN AT2004 T24 on T24.OrderID = T26.OrderID and T24.DivisionID = T26.DivisionID
	LEFT JOIN MT1601 M01 on M01.PeriodID = T27.PeriodID and M01.DivisionID = T27.DivisionID
WHERE T27.DivisionID ='''+@DivisionID+'''
AND T27.VoucherID = '''+@VoucherID+''' '
EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO