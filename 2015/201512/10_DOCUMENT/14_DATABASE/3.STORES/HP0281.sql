IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0281]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0281]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load danh sách he so theo ca nhân viên
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 15/08/2013 by Thanh Sơn
---- 
---- Modified on 05/09/2013 by Le Thi Thu Hien
-- <Example>
---- EXEC HP0281  'CTY', 'Admin', 3, 2013, 'PKZ', 'CANLUYEN','VR.001'

CREATE PROCEDURE HP0281
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@DepartmentID AS NVARCHAR(50),
		@TeamID AS NVARCHAR(50),
		@EmployeeID AS NVARCHAR(50)	
)
AS
DECLARE @sWhere AS NVARCHAR (MAX),
        @sSQL AS NVARCHAR(MAX)

SET @sWhere = ''
        
IF @DepartmentID <> ''
   SET @sWhere=@sWhere +  N'
   AND ISNULL(HT.DepartmentID, '''') = '''+@DepartmentID+'''  '
   
IF @TeamID <>''
   SET @sWhere=@sWhere + N'
   AND ISNULL(HT.TeamID, '''') = ISNULL('''+@TeamID+''', '''')'

IF @EmployeeID<>''
   SET @sWhere=@sWhere+N'
   AND ISNULL (H.EmployeeID,'''')=ISNULL('''+@EmployeeID+''','''')'   
   
SET @sSQL=N'
SELECT H.APK,
H.DivisionID,
H.EmployeeID,
H.FromDate,
H.ToDate,
H.FromShiftID,
H.ToShiftID,
H.DayCoefficient AS Salary,
H.Notes, 
HT.DepartmentID,
AT.DepartmentName,
HT.TeamID,
HT1.TeamName
FROM  HT0281 H
INNER JOIN HT1400 HT ON HT.DivisionID=H.DivisionID AND HT.EmployeeID = H.EmployeeID 
INNER JOIN AT1102 AT ON HT.DivisionID=AT.DivisionID AND HT.DepartmentID=AT.DepartmentID
LEFT JOIN HT1101 HT1 ON HT.DivisionID = HT1.DivisionID AND HT.TeamID=HT1.TeamID    
WHERE H.DivisionID= '''+@DivisionID+'''
AND   H.TranMonth= '''+STR(@TranMonth)+'''
AND   H.TranYear= '''+STR(@TranYear)+'''
'

PRINT (@sSQL)
PRINT (@sWhere)

EXEC (@sSQL+@sWhere)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

