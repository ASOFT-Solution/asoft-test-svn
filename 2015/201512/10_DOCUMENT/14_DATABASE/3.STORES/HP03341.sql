IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP03341]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP03341]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- 
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Khanh Van on: 10/12/2013
---- Modified by Thanh Sơn on 31/03/2015: Bổ sung điều kiện chỉ đếm những người còn phụ thuộc
-- <Example>
/*
	 HP03341 'VK'
*/

CREATE PROCEDURE HP03341
( 
	@DivisionID as nvarchar(50)
) 
AS 

SELECT H34.EmployeeID, V40.FullName, V40.DepartmentName, V40.Birthday, V40.FullAddress, V40.HomePhone, H34.[Status],
	H34.CreateDate, COUNT(H34.TransactionID) MemberQuantity
FROM HT0334 H34
	LEFT JOIN HV1400 V40 ON V40.DivisionID = H34.DivisionID AND V40.EmployeeID = H34.EmployeeID
WHERE H34.DivisionID = @DivisionID
	AND H34.[Status] = 0
GROUP BY H34.EmployeeID, V40.FullName, V40.DepartmentName, V40.Birthday, V40.FullAddress, V40.HomePhone, H34.[Status],
	H34.CreateDate

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
