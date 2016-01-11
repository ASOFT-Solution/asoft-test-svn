IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3008]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3008]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---Created by: Vo Thanh Huong, date: 23/11/2004
---purpose: In bao cao du toan don hang 
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [03/08/2010]
'**************************************************************/
---- Modified on 22/07/2013 by Lê Thị Thu Hiền : Bổ sung DisCountAmount, CommissionAmount


CREATE PROCEDURE [dbo].[OP3008] 
	@DivisionID nvarchar(50),
	@SOrderID nvarchar(50)
	
AS
Declare @sSQL nvarchar(2000)

Set @sSQL = '
SELECT T01.DivisionID,
	VoucherNo, 
	T00.OrderDate, 
	ContractNo, 
	ContractDate, 
	T00.ObjectID,  
	CASE WHEN ISNULL(T00.ObjectName, '''') = '''' then T03.ObjectName else T00.ObjectName end as ObjectName,  
	CASE WHEN ISNULL(T00.DeliveryAddress, '''') = '''' then T03.Address else T00.DeliveryAddress end as Address,
	T00.EmployeeID, 
	T04.FullName,  
	T01.InventoryID, 
	T01.CostID,  
	T05.UnitID,
	CASE WHEN ISNULL(T01.CostID, '''') = '''' then T05.InventoryName else T06.CostName end as Description, 
	T01.Sales, 
	T01.PrimeCost, 
	T01.OthersCost,
	T02.Sales as TotalSales, 
	T02.PrimeCost as TotalPrimeCost,
	T01.Orders,
	T02.OthersCost as TotalOthersCost ,
	T01.DisCountAmount,
	T01.CommissionAmount
	
FROM OT4002 T01 
INNER JOIN  OT2001 T00 on T00.SOrderID = T01.SOrderID and T00.DivisionID = T01.DivisionID
INNER JOIN OT4001 T02 on T02.SOrderID = T01.SOrderID and T02.DivisionID = T01.DivisionID
INNER JOIN AT1202 T03 on T03.ObjectID = T00.ObjectID and T03.DivisionID = T00.DivisionID
LEFT JOIN AT1103 T04 on T04.EmployeeID = T00.EmployeeID and T04.DivisionID = T00.DivisionID 
LEFT JOIN AT1302 T05 on T05.InventoryID = T01.InventoryID and T05.DivisionID = T01.DivisionID
LEFT JOIN OT1004 T06 on T06.CostID = T01.CostID and T06.DivisionID = T01.DivisionID
WHERE	T01.SOrderID = ''' + @SOrderID + ''' and
		T02.DivisionID = ''' + @DivisionID + '''' 


IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV3013')
	EXEC('CREATE VIEW OV3013 ---TAO BOI OP3008
			AS ' + @sSQL)  
ELSE
	EXEC('ALTER VIEW OV3013 ---TAO BOI OP3008
			AS ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

