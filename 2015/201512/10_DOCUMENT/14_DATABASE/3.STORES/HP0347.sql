IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0347]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0347]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Quét dữ liệu chấm công theo công trình theo ca
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 25/09/2014 by Lê Thị Thu Hiền
---- 
---- Modified on 25/09/2014 by 
-- <Example>
---- 
CREATE PROCEDURE HP0347
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@TranMonth AS TINYINT, 
	@TranYear AS INT,
	@FromDate AS DATETIME,
	@ToDate AS DATETIME,
	@ProjectID AS NVARCHAR(50),
	@DepartmentID AS NVARCHAR(50),
	@EmployeeID AS NVARCHAR(50)
) 
AS 
SELECT	CONVERT(TINYINT,0) AS Selected,
		H.APK, H.DivisionID, H.TranMonth, H.Tranyear, H.AbsentCardNo, 
		H2.DepartmentID, H.EmployeeID, 
		Ltrim(RTrim(isnull(H2.LastName,'')))+ ' ' + LTrim(RTrim(isnull(H2.MiddleName,''))) + ' ' + LTrim(RTrim(Isnull(H2.FirstName,''))) AS EmployeeName,
		H.ProjectID,
		H.AbsentDate, H.ShiftCode, H.AbsentTime, H.PeriodID, H.Notes
FROM HT2416 H
LEFT JOIN HT1400 H2 ON H2.DivisionID = H.DivisionID AND H2.EmployeeID = H.EmployeeID
WHERE H.DivisionID = @DivisionID
		AND H.TranMonth = @TranMonth
		AND H.Tranyear = @TranYear
		AND H.ProjectID LIKE @ProjectID
		AND H2.DepartmentID LIKE @DepartmentID
		AND H.EmployeeID LIKE @EmployeeID
		AND H.AbsentDate BETWEEN @FromDate AND @ToDate


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

