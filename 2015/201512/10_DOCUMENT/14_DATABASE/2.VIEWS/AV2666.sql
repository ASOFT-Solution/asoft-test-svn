IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AV2666]'))
DROP VIEW [dbo].[AV2666]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[AV2666] 
AS

SELECT
VoucherID, 
TableID, 
TranMonth, 
TranYear, 
DivisionID, 
VoucherTypeID, 
VoucherDate, 
VoucherNo, 
ObjectID, 
ProjectID, 
OrderID, 
BatchID, 
WareHouseID, 
ReDeTypeID, 
KindVoucherID, 
WareHouseID2, 
Status, 
EmployeeID, 
Description, 
RefNo01, 
RefNo02, 
RDAddress, 
ContactPerson, 
VATObjectName 
FROM AT2006

UNION ALL

SELECT
VoucherID, 
'AT9000' AS TableID, 
TranMonth, 
TranYear, 
DivisionID, 
VoucherTypeID, 
VoucherDate, 
VoucherNo, 
ObjectID, 
ProjectID, 
OrderID, 
BatchID, 
WareHouseID, 
ReDeTypeID, 
0 AS  KindVoucherID, 
WareHouseID2, 
Status, 
EmployeeID, 
Description, 
'' AS RefNo01, 
'' AS RefNo02, 
'' AS RDAddress, 
'' AS ContactPerson, 
'' AS VATObjectName 
FROM AT2016

GO


