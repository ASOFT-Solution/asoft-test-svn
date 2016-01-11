IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0261]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0261]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bao Anh		Date: 08/01/2013
---- Purpose: Tra ra danh sach cong nhan san xuat san pham
---- EXEC HP0261 'AS','0000000001,0000000002,0000000003'

CREATE PROCEDURE HP0261
( 
	@DivisionID as nvarchar(50),
	@List AS NVARCHAR(max)
	
) 
AS 

SELECT EmployeeID, FullName, DepartmentID, DepartmentName, TeamID, TeamName, cast(1 as tinyint) as IsChecked 
FROM HV1400 Where DivisionID = @DivisionID And EmployeeID in (Select Isnull(DATA,'') from (SELECT DATA FROM [Split] (@List,',')) A)
UNION
SELECT EmployeeID, FullName, DepartmentID, DepartmentName, TeamID, TeamName, cast(0 as tinyint) as IsChecked 
FROM HV1400 Where DivisionID = @DivisionID And EmployeeStatus = 1 And EmployeeID not in (Select Isnull(DATA,'') from (SELECT DATA FROM [Split] (@List,',')) A)
Order by DepartmentID, TeamID, EmployeeID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

