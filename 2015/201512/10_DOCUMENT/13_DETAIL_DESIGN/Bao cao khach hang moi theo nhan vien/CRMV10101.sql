IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CRMV10101]'))
DROP VIEW [dbo].[CRMV10101]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--Create on 12/01/2016 by Thị Phượng 
--Purpose : Load view danh sách khách hàng theo nhân viên

CREATE VIEW [dbo].[CRMV10101] AS
SELECT CR01.DivisionID, OT01.OrderDate, CR01.AccountID, CR01.AccountName, 
CR01.Address, CR01.Tel, CR01.CreateUserID, isnull(OT02.OrderQuantity,0) as OrderQuantity,
AT02.InventoryID,AT02.InventoryName, OT01.Notes, OT01.SalesManID, AT03.FullName
FROM CRMT10101 CR01
INNER JOIN OT2001 OT01 ON OT01.DivisionID = CR01.DivisionID AND OT01.ObjectID = CR01.AccountID
INNER JOIN OT2002 OT02 ON OT02.DivisionID = CR01.DivisionID AND OT01.SOrderID = OT02.SOrderID
INNER JOIN AT1302 AT02 ON AT02.DivisionID = CR01.DivisionID AND AT02.InventoryID = OT02.InventoryID
INNER JOIN AT1103 AT03 ON AT03.DivisionID = CR01.DivisionID AND AT03.EmployeeID = OT01.SalesManID
Group by OT01.SalesManID, CR01.DivisionID, OT01.OrderDate, CR01.AccountID, CR01.AccountName, 
CR01.Address, CR01.Tel, CR01.CreateUserID, isnull(OT02.OrderQuantity,0),
AT02.InventoryID,AT02.InventoryName, OT01.Notes,AT03.FullName 
GO