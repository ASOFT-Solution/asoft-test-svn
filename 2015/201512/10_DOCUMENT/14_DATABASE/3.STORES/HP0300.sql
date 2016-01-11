IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0300]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0300]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 10/09/2013
--- Purpose: Load danh sách đăng ký bảo hiểm tai nạn rủi ro (Hưng Vượng)
--- Modify on 08/11/2013 by Bảo Anh: Bổ sung tình trạng đăng ký, ngày đăng ký, ngày hết hạn
--- EXEC HP0300 'AS',2012,'%','%','%','%'

CREATE PROCEDURE [dbo].[HP0300] 
				@DivisionID nvarchar(50),
				@TranYear int,
				@DepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@EmployeeID nvarchar(50),
				@Status nvarchar(1) = '%'

AS

SELECT * FROM (
--- Nhân viên chưa từng đăng ký
SELECT	'0' as [Status], N'Chưa đăng ký' as StatusName, DivisionID, EmployeeID, FullName,
		Year(Birthday) as YearOfBirth, WorkDate, DepartmentName, TeamName,
		NULL as Amount, Notes, NULL as RegDate, NULL as LimitDate
FROM	HV1400
Where 	DivisionID = @DivisionID And  
		DepartmentID Like @DepartmentID And 
		isnull(TeamID,'') Like @TeamID And 
		EmployeeID Like @EmployeeID And
		EmployeeStatus = 1 And Year(WorkDate) <= @TranYear And
		EmployeeID not in (Select Isnull(EmployeeID,'') From HT0300 Where DivisionID = @DivisionID)
		
UNION --- Nhân viên hết hạn
SELECT	'1' as [Status], N'Hết hạn' as StatusName, H00.DivisionID, H00.EmployeeID, HV14.FullName,
		Year(HV14.Birthday) as YearOfBirth, HV14.WorkDate, HV14.DepartmentName, HV14.TeamName,
		H00.Amount, H00.Notes, H00.RegDate, H00.LimitDate
FROM	HT0300 H00
INNER JOIN HV1400 HV14 On H00.DivisionID = HV14.DivisionID And H00.EmployeeID = HV14.EmployeeID
Where 	H00.DivisionID = @DivisionID And
		TranYear = @TranYear - 1 And Isnull(LimitDate,'01/01/1900') < GETDATE() And
		H00.EmployeeID Like @EmployeeID And
		HV14.DepartmentID like @DepartmentID And ISNULL(HV14.TeamID,'') like @TeamID And HV14.EmployeeStatus = 1
		AND H00.EmployeeID not in (Select EmployeeID From HT0300 WHERE DivisionID = @DivisionID And
									H00.TranYear = @TranYear)
									
UNION --- Nhân viên đã đăng ký
SELECT	'2' as [Status], N'Đã đăng ký' as StatusName, H00.DivisionID, H00.EmployeeID, HV14.FullName,
		Year(HV14.Birthday) as YearOfBirth, HV14.WorkDate, HV14.DepartmentName, HV14.TeamName,
		H00.Amount, H00.Notes, H00.RegDate, H00.LimitDate
FROM	HT0300 H00
INNER JOIN HV1400 HV14 On H00.DivisionID = HV14.DivisionID And H00.EmployeeID = HV14.EmployeeID
Where 	H00.DivisionID = @DivisionID And
		H00.TranYear = @TranYear And
		H00.EmployeeID Like @EmployeeID And
		HV14.DepartmentID like @DepartmentID And ISNULL(HV14.TeamID,'') like @TeamID And HV14.EmployeeStatus = 1
) A
WHERE [Status] like @Status
ORDER BY [Status]
