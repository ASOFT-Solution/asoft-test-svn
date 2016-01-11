
/****** Object: StoredProcedure [dbo].[OP3007] Script Date: 12/16/2010 14:31:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 22/11/2004
---purpose: In bao cao bo sung chi phi cho du toan don hang
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [03/08/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[OP3007] 
    @DivisionID NVARCHAR(50),
    @SOrderID NVARCHAR(50)
AS

DECLARE @sSQL NVARCHAR(2000)

SET @sSQL = '
SELECT 
OT2004.DivisionID, 
OT2001.VoucherNo, 
OT2001.OrderDate, 
OT2001.ObjectID,
OT2001.ContractNo,
OT2001.ContractDate, 
CASE WHEN ISNULL(OT2001.ObjectName, '''') = '''' THEN AT1202.ObjectName ELSE OT2001.ObjectName END AS ObjectName, 
CASE WHEN ISNULL(OT2001.DeliveryAddress, '''') = '''' THEN AT1202.Address ELSE OT2001.DeliveryAddress END AS Address, 

OT2001.EmployeeID, 
AT1103.FullName, 
OT2004.CostID, 
OT1004.CostName, 
OT2004.Description, 
OT2004.Amount, 
OT2004.Orders 

FROM OT2004
INNER JOIN OT2001 ON OT2001.SOrderID = OT2004.SOrderID AND OT2001.DivisionID = OT2004.DivisionID 
INNER JOIN OT1004 ON OT1004.CostID = OT2004.CostID AND OT1004.DivisionID = OT2004.DivisionID 
LEFT JOIN AT1202 ON AT1202.ObjectID = OT2001.ObjectID AND AT1202.DivisionID = OT2004.DivisionID 
LEFT JOIN AT1103 ON AT1103.EmployeeID = OT2001.EmployeeID AND AT1103.DivisionID = OT2004.DivisionID 

WHERE OT2004.SOrderID = ''' + @SOrderID + '''
AND OT2004.DivisionID = ''' + @DivisionID + '''
'

If NOT EXISTS (SELECT Top 1 1 FROM sysObjects Where Xtype = 'V' AND Name = 'OV3012')
    EXEC('CREATE VIEW OV3012 -- Tạo bởi OP3007
        AS ' + @sSQL)
ELSE
    EXEC('ALTER VIEW OV3012 -- Tạo bởi OP3007
        AS ' + @sSQL)
