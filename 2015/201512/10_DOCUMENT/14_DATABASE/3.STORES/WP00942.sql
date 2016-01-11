IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP00942]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP00942]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Modified on 21/08/2014 by Quốc Tuấn : bổ sung thêm kho tài khoản
--Exec WP00942 'cTY','AD20130000000102,AD20130000000103'
CREATE PROCEDURE [dbo].[WP00942] 
(
    @DivisionID NVARCHAR(50),
	@ListVoucherID nvarchar(MAX)
)
AS
	DECLARE @sSQL AS NVARCHAR(4000),
	 @sSQL0 AS NVARCHAR(4000),
	 @sSQL1 AS NVARCHAR(4000),
	 @sSQL2 AS NVARCHAR(4000)
--- Load Master
--- Load Detail

SET @ssQL0 = '
Select 		
	AT2006.VoucherNo as invoice_serial,	
	AT2006.VoucherDate as invoice_date,		
	AT2006.RDAddress as Provider_address,
	AT2006.ObjectID as Provider_id,	
	AT1202.ObjectName as Provider_name,
	AT2006.VoucherID,		
	AT2007.InventoryID as drug_id,				
	AT1302.InventoryName as drug_name,       
	AT2007.UnitID as input_unit_id,		
	AT1304.UnitName as input_unit_name,
    ActualQuantity as input_unit_quantity,     
    UnitPrice as unit_price,       		
    OriginalAmount as amount,      	
    SourceNo as batch_number,	
	AT2007.Orders, 
	AT2006.EmployeeID as execute_by,
	LimitDate as expired, 
	AT2007.Notes as Note,
	null as headquater_id,
	null as headquater_name,
	AT1302.AccountID account_stock,
	AT1302.SalesAccountID account_revenue,
	AT2006.WareHouseID stock_code 
'
SET @sSQL1 = 
	    '
FROM AT2007
INNER JOIN AT1302			on AT1302.DivisionID    = AT2007.DivisionID AND AT1302.InventoryID =AT2007.InventoryID
LEFT JOIN AT1304			on AT1304.DivisionID    = AT2007.DivisionID AND AT1304.UnitID = AT2007.UnitID
INNER JOIN AT2006			on AT2006.DivisionID    = AT2007.DivisionID AND AT2006.VoucherID =AT2007.VoucherID
LEFT JOIN AT1202			on AT1202.DivisionID    = AT2006.DivisionID AND AT1202.ObjectID = AT2006.ObjectID

WHERE  	AT2007.DivisionID =''' + @DivisionID + ''' and
		AT2007.VoucherID in ('''+@ListVoucherID+''' )

ORDER BY AT2007.Orders'
PRINT(@sSQL0 + @sSQL1)
EXEC(@sSQL0 + @sSQL1)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
