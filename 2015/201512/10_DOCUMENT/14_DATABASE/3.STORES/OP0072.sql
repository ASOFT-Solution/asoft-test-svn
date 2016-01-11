IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0072]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0072]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load danh mục phiếu chào giá (viết lại không sinh ra view)
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on:
---- Modified on 
-- <Example>
/*
	exec OP0072 @DivisionID=N'HD',@UserID=N'ASOFTADMIN',@FromTranMonth=6,@FromTranYear=2015,@ToTranMonth=6,@ToTranYear=2015,@Mode=1,@StrWhere='AND OT2102.InventoryID = ''BUDDY_1.20'''
*/
CREATE PROCEDURE OP0072
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@FromTranMonth INT,
	@FromTranYear INT,
	@ToTranMonth INT,
	@ToTranYear INT,
	@Mode TINYINT,	-- 0: Master, 1: Detail
	@StrWhere NVARCHAR(MAX) --Dieu kien tim kiem tren luoi 
)
AS
DECLARE @sSQL NVARCHAR(MAX),
		@sJoin NVARCHAR(500) = ''

IF ISNULL(@Mode, 0) = 1 SET @sJoin = '	LEFT JOIN OT2102 ON OT2102.QuotationID = O01.QuotationID AND OT2102.DivisionID = O01.DivisionID'

SET @sSQL = '
SELECT DISTINCT O01.PriceListID, O01.QuotationID, O01.QuotationNo, O01.DivisionID, O01.TranMonth, O01.TranYear,
	O01.QuotationDate, O01.InventoryTypeID, A01.InventoryTypeName, O01.ObjectID, 
	(CASE WHEN ISNULL(O01.ObjectName, '''') <> '''' THEN O01.ObjectName ELSE A02.ObjectName END) ObjectName, 	
	O01.EmployeeID, A03.FullName,  
	(SELECT	SUM(ISNULL(OriginalAmount,0) + ISNULL(VATOriginalAmount, 0) - ISNULL(DiscountOriginalAmount, 0))  
	 FROM OT2102 
	 WHERE QuotationID = O01.QuotationID AND OT2102.DivisionID = '''+@DivisionID+''') OriginalAmount,
	O01.[Disabled], O01.OrderStatus, V01.[Description] OrderStatusName, V01.[EDescription] EOrderStatusName, 
	O01.RefNo1, O01.RefNo2, O01.RefNo3, O01.Attention1, O01.Attention2, O01.Dear, O01.Condition, O01.SaleAmount, 
	O01.PurchaseAmount,	O01.CurrencyID, A04.CurrencyName, O01.ExchangeRate, O01.Ana01ID, O01.Ana02ID, O01.Ana03ID,
	O01.Ana04ID, O01.Ana05ID, O02_1.AnaName Ana01Name, O02_2.AnaName Ana02Name, O02_3.AnaName Ana03Name,
	O02_4.AnaName Ana04Name, O02_5.AnaName Ana05Name, O01.CreateUserID, O01.CreateDate, O01.LastModifyUserID, 
	O01.LastModifyDate, O01.IsSO, O01.[Description], O01.VoucherTypeID, O01.EndDate, O01.Transport, O01.DeliveryAddress, 
	(CASE WHEN ISNULL(O01.[Address],'''') <> '''' THEN O01.[Address] ELSE A02.[Address] END) [Address],
	O01.PaymentID, O01.PaymentTermID, O01.ApportionID, O12.[Description] IsConfirm, O12.EDescription EIsConfirm,
	O01.DescriptionConfirm, O01.NumOfValidDays, O01.Varchar01, O01.Varchar02, O01.Varchar03, O01.Varchar04,
	O01.Varchar05, O01.Varchar06, O01.Varchar07, O01.Varchar08, O01.Varchar09, O01.Varchar10, O01.Varchar11,
	O01.Varchar12, O01.Varchar13, O01.Varchar14, O01.Varchar15, O01.Varchar16, O01.Varchar17, O01.Varchar18,
	O01.Varchar19, O01.Varchar20, O01.QuotationStatus, OV0002.[Description] QuotationStatusDescription,
	OV0002.EDescription QuotationStatusEDescription, O01.SalesManID, A03_1.FullName SalesMan
FROM OT2101 O01
	LEFT JOIN AT1202 A02 ON A02.DivisionID = O01.DivisionID AND A02.ObjectID = O01.ObjectID
	LEFT JOIN AT1301 A01 ON A01.DivisionID = O01.DivisionID AND A01.InventoryTypeID = O01.InventoryTypeID
	LEFT JOIN AT1103 A03 ON A03.DivisionID = O01.DivisionID AND A03.EmployeeID = O01.EmployeeID
	LEFT JOIN AT1103 A03_1 ON A03_1.EmployeeID = O01.SalesManID AND A03_1.DivisionID = O01.DivisionID
	LEFT JOIN OV1001 V01 ON V01.DivisionID = O01.DivisionID AND V01.OrderStatus = O01.OrderStatus AND V01.TypeID = ''SO''
	LEFT JOIN AT1004 A04 ON A04.DivisionID = O01.DivisionID AND A04.CurrencyID = O01.CurrencyID
	LEFT JOIN OT1102 O12 ON O12.DivisionID = O01.DivisionID AND O12.Code = O01.IsConfirm AND O12.TypeID = ''SO''
	LEFT JOIN OT1002 O02_1 ON O02_1.DivisionID = O01.DivisionID AND O02_1.AnaID = O01.Ana01ID AND O02_1.AnaTypeID = ''S01''
	LEFT JOIN OT1002 O02_2 ON O02_2.DivisionID = O01.DivisionID AND O02_2.AnaID = O01.Ana02ID AND O02_2.AnaTypeID = ''S02''
	LEFT JOIN OT1002 O02_3 ON O02_3.DivisionID = O01.DivisionID AND O02_3.AnaID = O01.Ana03ID AND O02_3.AnaTypeID = ''S03''
	LEFT JOIN OT1002 O02_4 ON O02_4.DivisionID = O01.DivisionID AND O02_4.AnaID = O01.Ana04ID AND O02_4.AnaTypeID = ''S04''
	LEFT JOIN OT1002 O02_5 ON O02_5.DivisionID = O01.DivisionID AND O02_5.AnaID = O01.Ana05ID AND O02_5.AnaTypeID = ''S05''
	LEFT JOIN OV0002 ON OV0002.[Status] = O01.QuotationStatus AND OV0002.DivisionID = O01.DivisionID AND OV0002.Mode = 1 AND OV0002.TypeID = ''QO''
'+@sJoin+'
WHERE O01.DivisionID = '''+@DivisionID+'''
AND O01.TranMonth + O01.TranYear * 100 BETWEEN '+STR(@FromTranMonth + @FromTranYear * 100)+' AND '+STR(@ToTranMonth + @ToTranYear * 100)+'
'+ISNULL(@StrWhere,'')+''

EXEC (@sSQL)
PRINT(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
