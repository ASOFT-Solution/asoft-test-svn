IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0080]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0080]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load thông tin master Đơn hàng mua
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 16/10/2015 by Tieu Mai

-- <Example>
---- 
CREATE PROCEDURE [dbo].[OP0080]
(
	@POrderID AS NVARCHAR(50) = '',
	@DivisionID AS NVARCHAR(50) = ''

)
 AS
DECLARE @sSQL1 AS nvarchar(MAX),
		@sSQL11 AS nvarchar(MAX),
		@SWhereVoucherID AS NVARCHAR(50)


SET @SWhereVoucherID = ''

IF @POrderID <> '' AND @POrderID <> '%'
SET @SWhereVoucherID = N'
			AND		OT3001.POrderID = '''+@POrderID+'''	'
						

SET @sSQL1 =N' 
SELECT	DISTINCT
		OT3001.DivisionID, OT3001.TranMonth, OT3001.TranYear,
		OT3001.POrderID, OT3001.VoucherTypeID, OT3001.VoucherNo, 
		OrderDate, OT3001.InventoryTypeID, InventoryTypeName, OT3001.CurrencyID, CurrencyName, 	
		OT3001.ExchangeRate,  OT3001.PaymentID, 
		OT3001.ObjectID, OT3001.PriceListID, ISNULL(OT3001.ObjectName, AT1202.ObjectName)  AS ObjectName, 
		ISNULL(OT3001.VatNo, AT1202.VatNo)  AS VatNo,  ISNULL( OT3001.Address, AT1202.Address)  AS Address,
		OT3001.ReceivedAddress, OT3001.ClassifyID, ClassifyName, OT3001.Transport,
		OT3001.EmployeeID,  AT1103.FullName,  IsSupplier, IsUpdateName, IsCustomer,
		ConvertedAmount = (	SELECT	SUM(ISNULL(ConvertedAmount,0)- ISNULL(DiscountConvertedAmount,0) + ISNULL(VATConvertedAmount, 0))  
							FROM	OT3002 
		                   	WHERE	OT3002.POrderID = OT3001.POrderID
							),
		OriginalAmount = (	SELECT	SUM(ISNULL(OriginalAmount,0)- ISNULL(DiscountOriginalAmount,0) + ISNULL(VATOriginalAmount, 0))  
		                  	FROM	OT3002 
		                  	WHERE	OT3002.POrderID = OT3001.POrderID
							),
		OT3001.Notes AS NotesMaster, OT3001.Disabled, OT3001.OrderStatus, OV1001.Description AS OrderStatusName, 
		OV1001.EDescription AS EOrderStatusName, 
		OT3001.OrderType,  OV1002.Description AS OrderTypeName, 
		OT3001.ContractNo, OT3001.ContractDate,
		OT3001.Ana01ID, OT3001.Ana02ID, OT3001.Ana03ID, OT3001.Ana04ID, OT3001.Ana05ID,
		OT1002_1.AnaName AS Ana01Name, OT1002_2.AnaName AS Ana02Name, 
		OT1002_3.AnaName AS Ana03Name, OT1002_4.AnaName AS Ana04Name, OT1002_5.AnaName AS Ana05Name, 
		OT3001.CreateUserID, OT3001.CreateDate,  
		OT3001.LastModifyUserID, OT3001.LastModifyDate, OT3001.ShipDate As ShipDateMaster, 
		OT3001.DueDate,OT3001.RequestID,
		OT3001.Varchar01, OT3001.Varchar02, OT3001.Varchar03, OT3001.Varchar04, OT3001.Varchar05,
		OT3001.Varchar06, OT3001.Varchar07, OT3001.Varchar08, OT3001.Varchar09, OT3001.Varchar10,
		OT3001.Varchar11, OT3001.Varchar12, OT3001.Varchar13, OT3001.Varchar14, OT3001.Varchar15,
		OT3001.Varchar16, OT3001.Varchar17, OT3001.Varchar18, OT3001.Varchar19, OT3001.Varchar20,
		OT3001.PaymentTermID,
		OT1102.Description AS  IsConfirm,
		OT1102.EDescription AS EIsConfirm,

		OT3001.DescriptionConfirm,
		OT3001.DeliveryDate,
		OT3001.SOrderID,
		OT3001.IsPrinted'
		
SET @sSQL11 =N' 
From OT3001 
LEFT JOIN AT1202 ON AT1202.ObjectID = OT3001.ObjectID AND AT1202.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_1 ON OT1002_1.AnaID = OT3001.Ana01ID AND OT1002_1.AnaTypeID = ''P01'' AND OT1002_1.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_2 ON OT1002_2.AnaID = OT3001.Ana02ID AND OT1002_2.AnaTypeID = ''P02'' AND OT1002_2.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_3 ON OT1002_3.AnaID = OT3001.Ana03ID AND OT1002_3.AnaTypeID = ''P03'' AND OT1002_3.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_4 ON OT1002_4.AnaID = OT3001.Ana04ID AND OT1002_4.AnaTypeID = ''P04'' AND OT1002_4.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_5 ON OT1002_5.AnaID = OT3001.Ana05ID AND OT1002_5.AnaTypeID = ''P05'' AND OT1002_5.DivisionID = OT3001.DivisionID
LEFT JOIN AT1301 ON AT1301.InventoryTypeID = OT3001.InventoryTypeID  AND AT1301.DivisionID = OT3001.DivisionID
INNER JOIN AT1004 ON AT1004.CurrencyID = OT3001.CurrencyID AND AT1004.DivisionID = OT3001.DivisionID
LEFT JOIN AT1103 ON AT1103.EmployeeID = OT3001.EmployeeID AND AT1103.DivisionID = OT3001.DivisionID 
LEFT JOIN OT1001 ON OT1001.ClassifyID = OT3001.ClassifyID AND OT1001.TypeID = ''PO'' AND OT1001.DivisionID = OT3001.DivisionID
LEFT JOIN OV1001 ON OV1001.OrderStatus = OT3001.OrderStatus AND OV1001.TypeID= ''PO'' AND OV1001.DivisionID = OT3001.DivisionID
LEFT JOIN OV1002 ON OV1002.OrderType = OT3001.OrderType AND OV1002.TypeID =''PO'' AND OV1002.DivisionID = OT3001.DivisionID
LEFT JOIN OT1102 ON OT1102.Code = OT3001.IsConfirm  AND OT1102.DivisionID = OT3001.DivisionID AND OT1102.TypeID = ''SO'' 
WHERE OT3001.DivisionID = '''+@DivisionID+'''
AND ISNULL(OT3001.KindVoucherID,0) = 0
'

EXEC (@sSQL1+ @sSQL11+ @SWhereVoucherID)
