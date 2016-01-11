IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0028]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0028]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 30/09/2013
--- Purpose: Load master đơn hàng bán
--- Modify on 04/08/2014 by Bảo Anh: Bổ sung IsSalesCommission (Sinolife)
--- Modified on 29/06/2015 by Lê Thị Hạnh: Bổ sung ImpactLevel
--- Modify on 15/06/2015 by Hoàng Vũ: Bổ sung trường OrderTypeID (Secoin), Dữ liệu kế thừa Master vào trường InheritSOrderID
--- EXEC OP0028 'TL','BL1/07/2013/0001'

CREATE PROCEDURE [dbo].[OP0028] 
(
	@DivisionID nvarchar(50),
	@SOrderID nvarchar(50)
)
AS

Declare @sSQL1 AS varchar(max),
		@sSQL2 AS varchar(max)
			
			
SET @sSQL1 =' 
SELECT	TOP 1
		OT2001.SOrderID, 
		OT2001.VoucherTypeID, 
		OT2001.VoucherNo,
		OT2001.TranMonth, 
		OT2001.TranYear,
		OT2001.OrderDate, 
		OT2001.ContractNo, 
		OT2001.ContractDate, 
		OT2001.InventoryTypeID, 
		OT2001.CurrencyID,
		OT2001.ExchangeRate,  
		OT2001.PaymentID,
		OT2001.ObjectID,  
		ISNULL(OT2001.ObjectName, AT1202.ObjectName)   AS ObjectName, 
		ISNULL(OT2001.VatNo, AT1202.VatNo)  AS VatNo, 
		ISNULL( OT2001.Address, AT1202.Address)  AS Address,
		OT2001.DeliveryAddress, 
		OT2001.ClassifyID,
		OT2001.InheritSOrderID, --Kế thừa dữ liệu từ đơn hàng bán
		OT2001.EmployeeID,
		OT2001.Transport, 
		AT1202.IsUpdateName,
		OT2001.Notes, 
		OT2001.Disabled, 
		OT2001.OrderStatus,
		OT2001.QuotationID,
		OT2001.OrderType,
		OT2001.OrderTypeID,--Customize secoin phân biệt đơn hàng bán và đơn hàng điều chỉnh
		Ana01ID, 
		Ana02ID, 
		Ana03ID, 
		Ana04ID, 
		Ana05ID,
		SalesManID,
		OT2001.SalesMan2ID,
		ShipDate,
		OT2001.DueDate, 
		OT2001.PaymentTermID,
		OT2001.contact,
		OT2001.VATObjectID,
		ISNULL(OT2001.VATObjectName,T02.ObjectName) AS  VATObjectName,
		OT2001.PriceListID,
		OT2001.varchar01, OT2001.varchar02, OT2001.varchar03, OT2001.varchar04, OT2001.varchar05,
		OT2001.varchar06, OT2001.varchar07, OT2001.varchar08, OT2001.varchar09, OT2001.varchar10,
		OT2001.varchar11, OT2001.varchar12, OT2001.varchar13, OT2001.varchar14, OT2001.varchar15,
		OT2001.varchar16, OT2001.varchar17, OT2001.varchar18, OT2001.varchar19, OT2001.varchar20,
		OT2001.IsPrinted, OT2001.IsSalesCommission, ISNULL(OT2001.ImpactLevel,0) AS ImpactLevel
'
SET @sSQL2 =' 
FROM	OT2001 
LEFT JOIN AT1202 ON AT1202.ObjectID = OT2001.ObjectID And OT2001.DivisionID = AT1202.DivisionID
LEFT JOIN AT1202 T02 ON T02.ObjectID = OT2001.VATObjectID AND OT2001.DivisionID = T02.DivisionID

WHERE	OT2001.DivisionID = ''' + @DivisionID + ''' And OT2001.SOrderID = ''' + @SOrderID + ''''	

EXEC('SELECT * FROM (' + @sSQL1 + @sSQL2 + ') A')

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON