IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0065]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0065]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load master màn hình nghiep vu Xac nhan hoan thanh cua khach hang BOURBON
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 29/09/2014 by Le Thi Thu Hien
---- 
---- Modified on 29/09/2014 by 
-- <Example>
---- 
CREATE PROCEDURE OP0065
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@TranMonth AS TINYINT,
	@TranYear AS INT,
	@VoucherID AS NVARCHAR(50)
) 
AS 
SELECT	OT3001.POrderID, OT3001.DivisionID, OT3001.VoucherTypeID, OT3001.VoucherNo,
		OT3001.InventoryTypeID, OT3001.CurrencyID, OT3001.ExchangeRate,
		OT3001.OrderType, OT3001.ObjectID, OT3001.ObjectName, 
		OT3001.ReceivedAddress, OT3001.Notes,
		OT3001.[Description], OT3001.[Disabled], OT3001.OrderStatus, OV1001.Description AS OrderStatusName,
		OT3001.Ana01ID,	OT3001.Ana02ID, OT3001.Ana03ID, OT3001.Ana04ID, OT3001.Ana05ID,
		OT1002_1.AnaName AS Ana01Name, OT1002_2.AnaName AS Ana02Name, 
		OT1002_3.AnaName AS Ana03Name, OT1002_4.AnaName AS Ana04Name, OT1002_5.AnaName AS Ana05Name, 
		OT3001.TranMonth, OT3001.TranYear, OT3001.EmployeeID, OT3001.OrderDate,
		OT3001.Transport, OT3001.PaymentID, OT3001.VATNo,
		OT3001.[Address], OT3001.ShipDate, OT3001.ContractNo, OT3001.ContractDate,
		OT3001.CreateUserID, OT3001.Createdate, OT3001.LastModifyUserID,
		OT3001.LastModifyDate, OT3001.DueDate, OT3001.RequestID, OT3001.Varchar01,
		OT3001.Varchar02, OT3001.Varchar03, OT3001.Varchar04, OT3001.Varchar05,
		OT3001.Varchar06, OT3001.Varchar07, OT3001.Varchar08, OT3001.Varchar09,
		OT3001.Varchar10, OT3001.Varchar11, OT3001.Varchar12, OT3001.Varchar13,
		OT3001.Varchar14, OT3001.Varchar15, OT3001.Varchar16, OT3001.Varchar17,
		OT3001.Varchar18, OT3001.Varchar19, OT3001.Varchar20, OT3001.PaymentTermID,
		OT3001.IsConfirm, OT3001.DescriptionConfirm, OT3001.DeliveryDate,
		OT3001.SOrderID, OT3001.Ana06ID, OT3001.Ana07ID, OT3001.Ana08ID,
		OT3001.Ana09ID, OT3001.Ana10ID, OT3001.PriceListID, OT3001.IsPrinted,OT3001.ClassifyID,
		OT3001.KindVoucherID, AT1202.IsUpdateName
FROM OT3001 OT3001
LEFT JOIN OT1002 OT1002_1 ON OT1002_1.AnaID = OT3001.Ana01ID AND OT1002_1.AnaTypeID = 'P01' AND OT1002_1.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_2 ON OT1002_2.AnaID = OT3001.Ana02ID AND OT1002_2.AnaTypeID = 'P02' AND OT1002_2.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_3 ON OT1002_3.AnaID = OT3001.Ana03ID AND OT1002_3.AnaTypeID = 'P03' AND OT1002_3.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_4 ON OT1002_4.AnaID = OT3001.Ana04ID AND OT1002_4.AnaTypeID = 'P04' AND OT1002_4.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_5 ON OT1002_5.AnaID = OT3001.Ana05ID AND OT1002_5.AnaTypeID = 'P05' AND OT1002_5.DivisionID = OT3001.DivisionID
LEFT JOIN OV1001 ON OV1001.OrderStatus = OT3001.OrderStatus AND OV1001.TypeID= 'PO' AND OV1001.DivisionID = OT3001.DivisionID
LEFT JOIN AT1202 ON AT1202.DivisionID = OT3001.DivisionID AND AT1202.ObjectID = OT3001.ObjectID
WHERE OT3001.DivisionID = @DivisionID
AND OT3001.POrderID = @VoucherID
AND ISNULL(OT3001.KindVoucherID,0) = 2
--AND OT3001.TranYear*100+OT3001.TranMonth = @TranYear*100+@TranMonth


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

