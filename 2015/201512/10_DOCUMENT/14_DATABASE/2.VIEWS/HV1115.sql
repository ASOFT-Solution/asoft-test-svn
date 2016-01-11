/****** Object:  View [dbo].[HV1115]    Script Date: 12/16/2010 15:08:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

------Create Date: 22/09/2005
------Purpose: View chet, phuc vu thiet lap bao cao luong
------Edit by: Dang Le Bao Quynh
------Edit Date: 07/06/2006
ALTER VIEW [dbo].[HV1115]
AS
SELECT IncomeID AS CodeID, Caption AS Caption, 
	'IO'  AS Type, 'Thu nhaäp' as Description
FROM HT0002
WHERE IsUsed = 1
UNION
SELECT CoefficientID  as CodeID,    Caption ,
	    'CO'  AS Type,  'Heä soá' as Description
FROM HV1111
UNION
SELECT GeneralAbsentID    AS CodeID,   Description AS Caption,
	 'GA'  AS Type, 'Ngaøy coâng toång hôïp' as Description
FROM HT5002
UNION
SELECT AbsentTypeID as CodeID, AbsentName as Caption, 
	'MA' AS Type, 'Ngaøy coâng thaùng' as Description	
FROM HT1013 
WHERE IsMonth = 1
UNION
SELECT AbsentTypeID as CodeID, AbsentName as Caption, 
	'DA' AS Type, 'Ngaøy coâng ngaøy' as Description	
FROM HT1013 
WHERE IsMonth <> 1
UNION
SELECT FieldID AS CodeID, Description AS Caption, 
    'SA'  AS Type, 'Möùc löông' as Description
FROM HV1112
WHERE FOrders < 5
UNION
SELECT SubID AS CodeID, Caption, 
	'SU'  AS Type, 'Giaûm tröø' as Description
FROM HT0005
WHERE IsUsed = 1
UNION
SELECT     'S00' AS Code, 'Thueá thu nhaäp' AS Caption, 'SU' AS Type, 'Giaûm tröø' AS Description
UNION
SELECT 'TA' AS CodeID, 'Thue thu nhap' AS Caption, 
	'TA'  AS Type, 'Thueá thu nhaäp' as Description
UNION 
Select '' as Code, '' as Caption,
	'OT' as Type, 'Khaùc' as Description

GO


