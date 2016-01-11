IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0332]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0332]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Load combo EmployeeID 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 02/12/2013 by Thanh Sơn
---- 
---- Modified on 28/08/2013 by 
-- <Example>
---- EXEC HP0332 'SAS', 'ADMIN', 'a','z','',''
CREATE PROCEDURE HP0332
( 
		@DivisionID VARCHAR(50),
		@UserID VARCHAR(50),
		@FromDepartmentID VARCHAR(50),
		@ToDepartmentID VARCHAR(50),
		@FromTeamID VARCHAR(50),
		@ToTeamID VARCHAR(50)
		
) 
AS 
DECLARE @sWhere NVARCHAR(MAX),
		@sSQL NVARCHAR(MAX)
SET @sWhere = ''

IF (@FromTeamID <> '' AND @FromTeamID IS NOT NULL AND @ToTeamID <> '' AND @ToTeamID IS NOT NULL)
SET @sWhere = @sWhere +N'
AND ISNULL(TeamID,'''') BETWEEN '''+@FromTeamID+''' AND '''+@ToTeamID+''''

SET @sSQL = N'
SELECT EmployeeID,TeamID,
LTRIM(RTRIM(ISNULL(LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(FirstName,''''))) AS EmployeeName
FROM HT1400
WHERE DivisionID = '''+@DivisionID+'''
AND DepartmentID BETWEEN '''+@FromDepartmentID+''' AND '''+@ToDepartmentID+'''
AND EmployeeStatus = 1 '+@sWhere+''


EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

