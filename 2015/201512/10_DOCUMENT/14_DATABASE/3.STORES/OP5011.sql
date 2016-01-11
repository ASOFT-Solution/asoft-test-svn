IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP5011]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP5011]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
---- Danh mục đóng gói
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 11/08/2004 by Vo Thanh Huong
---- 
---- Edit by: Nguyen Quoc Huy
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/
---- Modified on 18/04/2013 by Le Thi Thu Hien : Bổ sung WHERE DivisionID, TranMonth, TranYear
-- <Example>
---- 
CREATE PROCEDURE  [dbo].[OP5011] 
				@DivisionID AS nvarchar(50), 
				@TranMonth AS int ,
				@TranYear AS int
 AS

Declare @sSQL1 AS nvarchar(4000)
Declare @sSQL2 AS nvarchar(4000)

Set @sSQL1 ='
SELECT  OT5001.DivisionID,
		OT5001.VoucherID,
		OT5001.VoucherTypeID,  
		OT5001.VoucherNo,  
		OT5001.VoucherDate,
		OT5001.Description,
		OT5001.SOrderID, 
		OT5001.ObjectID,
		AT1202.ObjectName,
		AT1202.Address,
		AT1202.Tel,
		AT1202.Fax,     	
		OT5001.ShipDate,
		OT5001.TranMonth,
		OT5001.TranYear
FROM	OT5001 
INNER JOIN AT1202 on OT5001.ObjectID = AT1202.ObjectID and OT5001.DivisionID = AT1202.DivisionID
WHERE	OT5001.DivisionID = N'''+@DivisionID+''' 
		AND TranMonth = '+str(@TranMonth) +' 
		AND TranYear = '+ str(@TranYear) + ''
                  
Set @sSQL2 ='
SELECT	OT5002.DivisionID,
		OT5002.VoucherID, 
		OT5002.TransactionID, 
		OT5002.InventoryID,
		case when isnull(OT5002.InventoryCommonName, '''') = '''' then AT1302.InventoryName else OT5002.InventoryCommonName end AS InventoryName, 		
		AT1302.UnitID,
		AT1302. Image01ID,
		Isnull(AT1302.Specification,NULL) AS Specification,
		Isnull(AT1302.I01ID,NULL) AS I01ID, 
		OT5002.PackageID, 
		OT5002.Quantity, 
		OT5002.PackageQuantity, 
		OT5002.WeighAmount, 
		OT1307.Volume,
		OT5002.Note1, 
		OT5002.Note2 ,
		OT1302.Notes AS YourREf,
		OT1302.Notes01 AS Color
FROM	OT5002 
LEFT JOIN OT5001 ON OT5001.DivisionID = OT5002.DivisionID AND OT5001.VoucherID = OT5002.VoucherID 
INNER JOIN AT1302 on OT5002.InventoryID = AT1302.InventoryID and OT5002.DivisionID = AT1302.DivisionID
INNER JOIN OT1307 on OT5002.PackageID = OT1307.PackageID and OT5002.DivisionID = OT1307.DivisionID
LEFT JOIN  OT1302 on OT5002.PackageID = OT1302.Notes02 and OT5002.DivisionID =OT1302.DivisionID
WHERE	OT5002.DivisionID = N'''+@DivisionID+''' 
		AND OT5001.TranMonth = '+str(@TranMonth) +' 
		AND OT5001.TranYear = '+ str(@TranYear) + '
		'
--print  @sSQL2
IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V'  AND NAME = 'OV5011')
	EXEC('CREATE VIEW OV5011 ---tao boi OP5011 
			as ' + @sSQL1)
ELSE
	EXEC('ALTER VIEW OV5011 ---tao boi OP5011 
			as '+@sSQL1)

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE ='V' AND NAME = 'OV5012')
	EXEC('CREATE VIEW OV5012  --tao boi OP5011 
			as '+@sSQL2)
ELSE
	EXEC('ALTER VIEW OV5012  --- tao boi OP5011 
			as '+@sSQL2)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

