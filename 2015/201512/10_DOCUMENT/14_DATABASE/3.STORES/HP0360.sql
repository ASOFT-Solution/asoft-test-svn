IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0360]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP0360]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-----Created by Nguyễn Thanh Thịnh, date: 11/11/2015
-----purpose: Load email nhân viên check

CREATE PROCEDURE [dbo].[HP0360] 
	@DivisionID nvarchar(20), 
	@TranMonth int,
	@TranYear int,
	@USER NVARCHAR(50),
	@CC nvarchar(max),
	@Type int,
	@Subject nvarchar(200),
	@Content nvarchar(max),
	@StringEmployeeID nvarchar(max)
as
BEGIN
	-- 1. lưu nhân viên được check gởi mail
	-- 2. Chạy Store tính toán thiết lập để tính toán lương
	-- 3. Lưu nhân viên có email và gởi mail.
	-- 4. Load Thong Tin PHiếu lương theo Nhân viên Check


-- 1. Lưu Nhân Viên Được Check gởi mail.
	CREATE TABLE #TMP_EmployeeID([row] int, employeeID nvarchar(50))
	INSERT INTO #TMP_EmployeeID([row],employeeID)
	SELECT ID,Data
	FROM [dbo].[Split](@StringEmployeeID,';') 

-- 2. Chạy Store tính toán thiết lập để tính toán lương
	
	DECLARE 
	@ReportCode NVARCHAR(50),
	@FromDepartmentID NVARCHAR(50),
	@ToDepartmentID NVARCHAR(50),
	@FromEmployeeID NVARCHAR(50),
	@ToEmployeeID NVARCHAR(50)

	SELECT @ReportCode = CASE WHEN @Type = 1 THEN 'PL' ELSE 'PT' END,
		   @FromDepartmentID = MIN(AT11.DepartmentID),
		   @ToDepartmentID =  MAX(AT11.DepartmentID),		
		   @FromEmployeeID = MIN(HV14.EmployeeID),
		   @ToEmployeeID = MAX(HV14.EmployeeID)
	FROM AT1102 AT11
		INNER JOIN HV1400 HV14 
			ON HV14.DepartmentID = AT11.DepartmentID
				AND HV14.DivisionID = AT11.DivisionID
		INNER JOIN #TMP_EmployeeID EM
			ON EM.employeeID = HV14.EmployeeID
	WHERE AT11.DivisionID = @DivisionID
	
		exec HP7006 @DivisionID , @ReportCode,@FromDepartmentID, @ToDepartmentID,N'%',
		@FromEmployeeID, @ToEmployeeID, @TranMonth,	@TranYear, @TranMonth, @TranYear, N'%',
		0, N'Dept'

	
	-- 3. Lưu nhân viên có email và gởi mail.
		INSERT INTO HT0358 (DivisionID,TranMonth,TranYear,EmployeeID,Type,
							EmailReceiver,SendDate,Subject,	Content,
							CreateUserID,CreateDate)
		SELECT @DIVISIONID, @TranMonth, @TranYear, EM.EmployeeID, @TYPE,
				H14.Email, GETDATE(), @Subject, @Content, @USER, GETDATE()
		FROM #TMP_EmployeeID EM
			INNER JOIN HV1400 H14
				ON EM.EmployeeID = h14.EmployeeID
		where h14.divisionID = @DivisionID
		GROUP BY  EM.EmployeeID,h14.Email
		HAVING ISNULL(h14.Email,'') <> ''

	-- 4. Load Thong Tin PHiếu lương theo Nhân viên Check

	IF(@Type = 1)
		BEGIN	
		SELECT	AA.EmployeeID,AA.FullName ,AA.DutyName , AA.ColumnAmount01, AA.ColumnAmount02, 
				AA.ColumnAmount03, AA.ColumnAmount04, AA.ColumnAmount05, AA.ColumnAmount06, AA.ColumnAmount07, 
				AA.ColumnAmount08, AA.ColumnAmount09, AA.ColumnAmount10, AA.ColumnAmount11,	AA.[ColumnAmount12],
				AA.ColumnAmount13, AA.ColumnAmount14, AA.[ColumnAmount15], AA.[ColumnAmount16],	AA.[ColumnAmount17], 
				AA.ColumnAmount18, AA.ColumnAmount19 , AA.ColumnAmount20, 
				AA.[ColumnAmount15] - (AA.[ColumnAmount16] + AA.[ColumnAmount18] + AA.[ColumnAmount19] + AA.[ColumnAmount20]) [ColumnAmount21],
				ISNULL(AA.[ColumnAmount22],0) [ColumnAmount22] ,AA.[ColumnAmount22] + (AA.[ColumnAmount14] - (AA.[ColumnAmount15] + AA.[ColumnAmount17] + AA.[ColumnAmount18] + AA.[ColumnAmount19])) [ColumnAmount23],
				AA.Email
		FROM
		(
			SELECT	HT71.EmployeeID,HT71.FullName ,HT71.DutyName ,
					ISNULL(HT71.ColumnAmount01,0) ColumnAmount01, ISNULL(HT71.ColumnAmount02,0) ColumnAmount02, ISNULL(HT71.ColumnAmount03,0) ColumnAmount03, ISNULL(HT71.ColumnAmount04,0) ColumnAmount04, ISNULL(HT71.ColumnAmount05,0) ColumnAmount05,
					ISNULL(HT71.ColumnAmount06,0) + ISNULL(HT71.ColumnAmount28,0) [ColumnAmount06], ISNULL(HT71.ColumnAmount07,0) ColumnAmount07, ISNULL(HT71.ColumnAmount08,0) ColumnAmount08, 
					ISNULL(HT71.ColumnAmount09,0) ColumnAmount09, ISNULL(HT71.ColumnAmount10,0) ColumnAmount10, ISNULL(HT71.ColumnAmount11,0) + ISNULL(HT71.ColumnAmount12,0) [ColumnAmount11],
					ISNULL(HT71.ColumnAmount23,0) + ISNULL(HT71.ColumnAmount24,0) + ISNULL(HT71.ColumnAmount25,0)  [ColumnAmount12],
					ISNULL(HT71.ColumnAmount13,0) ColumnAmount13, ISNULL(HT71.ColumnAmount14,0) ColumnAmount14,
					ISNULL(HT71.ColumnAmount26,0) + (ISNULL(HT71.ColumnAmount09,0) + ISNULL(HT71.ColumnAmount10,0) + ISNULL(HT71.ColumnAmount11,0) + ISNULL(HT71.ColumnAmount12,0) +
					ISNULL(HT71.ColumnAmount23,0) + ISNULL(HT71.ColumnAmount24,0) + ISNULL(HT71.ColumnAmount25,0) +
					ISNULL(HT71.ColumnAmount13,0) + ISNULL(HT71.ColumnAmount04,0) ) [ColumnAmount15],
					ISNULL(HT71.ColumnAmount12,0) + ISNULL(HT71.ColumnAmount13,0) + ISNULL(HT71.ColumnAmount14,0)  [ColumnAmount16],
					ISNULL(DT.[Qty],0) [ColumnAmount17], ISNULL(HT71.ColumnAmount18,0) ColumnAmount18, ISNULL(HT71.ColumnAmount19,0) ColumnAmount19 , ISNULL(HT71.ColumnAmount20,0) ColumnAmount20,
					ISNULL(HT71.ColumnAmount21,0) [ColumnAmount22] ,
					HV14.Email,HT71.DepartmentID ,IsNull(HT71.TeamID,'') [TeamID],HT71.Orders

			FROM HT7110 HT71
				INNER JOIN #TMP_EmployeeID EM
					ON HT71.EmployeeID = EM.EmployeeID
				INNER JOIN HV1400 HV14 
					ON EM.EmployeeID = HV14.EmployeeID
						AND HV14.DivisionID = @DivisionID
				LEFT JOIN ( SELECT EmployeeID, COUNT(EmployeeID) [Qty]
							 FROM HT0334
							 WHERE DIVISIONID = @DIVISIONID
							 GROUP BY EmployeeID
						   ) DT ON DT.EmployeeID = HT71.EmployeeID					
			WHERE HT71.DivisionID = @DivisionID			
		) AA

		ORDER BY AA.DepartmentID, AA.TeamID, AA.Orders
		END
	ELSE
		BEGIN
			
			SELECT	HT71.EmployeeID,HT71.FullName ,HT71.DutyName ,
					HT71.ColumnAmount01, HT71.ColumnAmount02, HT71.ColumnAmount03, HT71.ColumnAmount04,
					HT71.ColumnAmount05, HT71.ColumnAmount06 , HT71.ColumnAmount07 , HT71.ColumnAmount08, 
					HT71.ColumnAmount09, HT71.ColumnAmount10 ,

					HT71.ColumnAmount03 + HT71.ColumnAmount04 +
					HT71.ColumnAmount05 + HT71.ColumnAmount06 + HT71.ColumnAmount07 + HT71.ColumnAmount08 +
					HT71.ColumnAmount09 + HT71.ColumnAmount10 [ColumnAmount11],
					HV14.Email

			FROM HT7110 HT71
				INNER JOIN #TMP_EmployeeID EM
					ON HT71.EmployeeID = EM.EmployeeID
				INNER JOIN HV1400 HV14 
					ON EM.EmployeeID = HV14.EmployeeID
						AND HV14.DivisionID = @DivisionID

		END
	
	
	DROP TABLE #TMP_EmployeeID	
	
END