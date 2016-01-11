IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0158]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0158]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 03/03/2014
--- Purpose: In danh sách đề nghị xác nhận sổ BHXH
--- EXEC HP0158 'AS','000','PJS','0000000005,0000000020'

CREATE PROCEDURE [dbo].[HP0158]
				@DivisionID nvarchar(50),
				@FromDepartmentID nvarchar(50),
				@ToDepartmentID nvarchar(50),
				@EmployeeIDList varchar(max)		
AS
	
Declare @SQL nvarchar(max),
		@Cur AS cursor,
		@EmployeeID nvarchar(50),
		@VoucherDateFrom datetime,
		@VoucherDateTo datetime

SET @EmployeeIDList = '''' + REPLACE(@EmployeeIDList,',',''',''') + ''''

--- Lấy thời gian nghỉ thai sản (nếu có)
IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#TAM')) 
	DROP TABLE #TAM
	
CREATE TABLE #TAM (EmployeeID varchar(50), VoucherDateFrom datetime, VoucherDateTo datetime, LeaveTime varchar(max))

SET @SQL = N'INSERT INTO #TAM (EmployeeID, VoucherDateFrom, VoucherDateTo)
			SELECT EmployeeID, VoucherDate, dateadd(day,InLeaveDays,VoucherDate)
			FROM HT0315
			WHERE DivisionID = ''' + @DivisionID + ''' And EmployeeID in (' + @EmployeeIDList + ') And ConditionTypeID = 2'
EXEC(@SQL)

SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT EmployeeID,VoucherDateFrom,VoucherDateTo From #TAM ORDER BY EmployeeID, VoucherDateFrom

OPEN @Cur
FETCH NEXT FROM @Cur INTO @EmployeeID, @VoucherDateFrom, @VoucherDateTo
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @SQL = N'UPDATE #TAM SET LeaveTime = Isnull(LeaveTime,'''') + (case when ltrim(rtrim(Isnull(LeaveTime,''''))) = '''' then '''' else '', '' end) + ''' +
											convert(nvarchar(20),@VoucherDateFrom,103) + ' - ' + convert(nvarchar(20),@VoucherDateTo,103) + '''
				WHERE EmployeeID = ''' + @EmployeeID + ''''
	
	EXEC(@SQL)

	FETCH NEXT FROM @Cur INTO @EmployeeID, @VoucherDateFrom, @VoucherDateTo
END
CLOSE @Cur

SET @SQL = N'SELECT EmployeeID, FullName, SoInsuranceNo, SoInsurBeginDate, LeaveDate as SoInsurEndDate,
			(Select top 1 LeaveTime From #TAM Where EmployeeID = HV1400.EmployeeID ORDER BY VoucherDateFrom DESC) as Notes
			
			FROM HV1400
			WHERE DivisionID = ''' + @DivisionID + '''
			And (DepartmentID between ''' + @FromDepartmentID + ''' And ''' + @ToDepartmentID + ''')
			And EmployeeID in (' + @EmployeeIDList + ')
			
			ORDER BY DepartmentID,EmployeeID'

EXEC(@SQL)
