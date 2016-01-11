IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0076]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0076]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load Grid danh sách đơn hàng mua
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 17/06/2015
---- Modified on 
-- <Example>
/*
	OP0076 'HD', '', '2015-06-18 15:32:43.500', '2015-06-18 15:32:43.500', 1,2015, 6,2015, 0,0,NULL, NULL, NULL
*/
CREATE PROCEDURE OP0076
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@FromDate DATETIME,
	@ToDate DATETIME,
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@IsDate TINYINT,
	@IsPrint TINYINT, ----2: tất cả, 0: chưa in, 1 đã in
	@OrderStatus TINYINT,
	@ObjectID VARCHAR(50),
	@VoucherTypeID VARCHAR(50),
	@IsServer INT = 0,
	@StrWhere AS NVARCHAR(4000) = ''
)
AS
DECLARE @sSQL NVARCHAR(MAX),		
		@sWhere NVARCHAR(2000) = ''
		
IF @IsDate = 1 SET @sWhere = @sWhere + '
AND CONVERT(VARCHAR,O31.OrderDate, 112) BETWEEN '''+CONVERT(VARCHAR, @FromDate, 112)+''' AND '''+CONVERT(VARCHAR,@ToDate,112)+''' '
ELSE SET @sWhere = @sWhere + '
AND O31.TranMonth + O31.TranYear * 100 BETWEEN '+STR(@FromMonth + @FromYear * 100)+' AND '+STR(@ToMonth + @ToYear * 100)+' '

IF ISNULL(@IsPrint, 2) <> 2 SET @sWhere = @sWhere + '
AND ISNULL(O31.IsPrinted, 0) = '+STR(@IsPrint)+' '

IF @OrderStatus IS NOT NULL SET @sWhere = @sWhere + '
AND ISNULL(O31.OrderStatus, 0) = '+STR(@OrderStatus)+' '

IF @ObjectID IS NOT NULL SET @sWhere = @sWhere + '
AND O31.ObjectID = '''+@ObjectID+''' '

IF @VoucherTypeID IS NOT NULL SET @sWhere = @sWhere + '
AND O31.VoucherTypeID = '''+@VoucherTypeID+''' '

SET @sSQL = '
SELECT O31.DivisionID, O31.TranMonth, O31.TranYear, O31.POrderID, O31.VoucherTypeID, O31.VoucherNo, 
	O31.OrderDate, O31.InventoryTypeID, A01.InventoryTypeName, O31.CurrencyID, A04.CurrencyName, 	
	O31.ExchangeRate, O31.PaymentID, O31.ObjectID, O31.PriceListID, ISNULL(O31.ObjectName, A02.ObjectName) ObjectName, 
	ISNULL(O31.VatNo, A02.VatNo) VatNo, ISNULL(O31.[Address], A02.[Address]) [Address], O31.ReceivedAddress,
	O31.ClassifyID, O01.ClassifyName, O31.Transport,
	O31.EmployeeID, A03.FullName, A02.IsSupplier, A02.IsUpdateName, A02.IsCustomer,
	(SELECT	SUM(ISNULL(ConvertedAmount, 0) - ISNULL(DiscountConvertedAmount, 0) + ISNULL(VATConvertedAmount, 0))  
	 FROM OT3002
	 WHERE OT3002.POrderID = O31.POrderID) ConvertedAmount,
	(SELECT	SUM(ISNULL(OriginalAmount,0)- ISNULL(DiscountOriginalAmount,0) + ISNULL(VATOriginalAmount, 0))  
	 FROM OT3002 
	 WHERE OT3002.POrderID = O31.POrderID) OriginalAmount,
	O31.Notes NotesMaster, O31.[Disabled], O31.OrderStatus, V01.[Description] OrderStatusName, 
	V01.EDescription EOrderStatusName, O31.OrderType, V02.[Description] OrderTypeName,
	O31.ContractNo, O31.ContractDate, O31.Ana01ID, O31.Ana02ID, O31.Ana03ID, O31.Ana04ID, O31.Ana05ID,
	O02_1.AnaName Ana01Name, O02_2.AnaName Ana02Name, O02_3.AnaName Ana03Name, O02_4.AnaName Ana04Name, O02_5.AnaName Ana05Name, 
	O31.CreateUserID, O31.CreateDate, O31.LastModifyUserID, O31.LastModifyDate, O31.ShipDate ShipDateMaster, 
	O31.DueDate, O31.RequestID, O31.Varchar01, O31.Varchar02, O31.Varchar03, O31.Varchar04, O31.Varchar05,
	O31.Varchar06, O31.Varchar07, O31.Varchar08, O31.Varchar09, O31.Varchar10,
	O31.Varchar11, O31.Varchar12, O31.Varchar13, O31.Varchar14, O31.Varchar15,
	O31.Varchar16, O31.Varchar17, O31.Varchar18, O31.Varchar19, O31.Varchar20,
	O31.PaymentTermID, O02.[Description] IsConfirm, O02.EDescription EIsConfirm,
	O31.DescriptionConfirm, O31.DeliveryDate, O31.SOrderID, O31.IsPrinted
FROM OT3001 O31
	LEFT JOIN OV1001 V01 ON V01.DivisionID = O31.DivisionID AND V01.OrderStatus = O31.OrderStatus AND V01.TypeID= ''PO''
	LEFT JOIN OV1002 V02 ON V02.DivisionID = O31.DivisionID AND V02.OrderType = O31.OrderType AND V02.TypeID = ''PO''
	LEFT JOIN AT1103 A03 ON A03.DivisionID = O31.DivisionID AND A03.EmployeeID = O31.EmployeeID
	LEFT JOIN AT1202 A02 ON A02.DivisionID = O31.DivisionID AND A02.ObjectID = O31.ObjectID
	LEFT JOIN AT1301 A01 ON A01.DivisionID = O31.DivisionID AND A01.InventoryTypeID = O31.InventoryTypeID
	LEFT JOIN AT1004 A04 ON A04.DivisionID = A01.DivisionID AND A04.CurrencyID = O31.CurrencyID
	LEFT JOIN OT1001 O01 ON O01.DivisionID = O31.DivisionID AND O01.ClassifyID = O31.ClassifyID AND O01.TypeID = ''PO''
	LEFT JOIN OT1102 O02 ON O02.Code = O31.IsConfirm AND O02.DivisionID = O31.DivisionID AND O02.TypeID = ''SO''
	LEFT JOIN OT1002 O02_1 ON O02_1.AnaID = O31.Ana01ID AND O02_1.AnaTypeID = ''P01'' AND O02_1.DivisionID = O31.DivisionID
	LEFT JOIN OT1002 O02_2 ON O02_2.AnaID = O31.Ana02ID AND O02_2.AnaTypeID = ''P02'' AND O02_2.DivisionID = O31.DivisionID
	LEFT JOIN OT1002 O02_3 ON O02_3.AnaID = O31.Ana03ID AND O02_3.AnaTypeID = ''P03'' AND O02_3.DivisionID = O31.DivisionID
	LEFT JOIN OT1002 O02_4 ON O02_4.AnaID = O31.Ana04ID AND O02_4.AnaTypeID = ''P04'' AND O02_4.DivisionID = O31.DivisionID
	LEFT JOIN OT1002 O02_5 ON O02_5.AnaID = O31.Ana05ID AND O02_5.AnaTypeID = ''P05'' AND O02_5.DivisionID = O31.DivisionID
WHERE O31.DivisionID = '''+@DivisionID+'''
AND ISNULL(O31.KindVoucherID,0) = 0 '+@sWhere+'
'

EXEC (@sSQL)
PRINT (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
