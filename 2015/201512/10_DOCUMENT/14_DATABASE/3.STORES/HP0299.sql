IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP0299]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP0299]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- Created by Bảo Anh	Date: 08/09/2013
--- Purpose: In báo cáo theo dõi thi đua theo tháng/quý/năm (Hưng Vượng)
--- Modify on 08/11/2013 by Bảo Anh: Bổ sung isnull khi lấy dữ liệu cho WorkMarks, RegulationsMarks
--- EXEC HP0299 'AS','%','%',1,2012,0,'Order by DepartmentID, EmployeeID'

CREATE PROCEDURE [dbo].[HP0299]
	@DivisionID nvarchar(50),
	@DepartmentID nvarchar(50),
	@TeamID nvarchar(50),	
    @TranMonth int,
    @TranYear int,
    @IsTime int,
    @Orderby nvarchar(1000) = ''
    
AS  
Declare @sSQL nvarchar(max),
		@FromMonth int,
		@ToMonth int,
		@WorkMarks int,
		@RegulationsMarks int
		
--- Lấy các số điểm tối đa theo quy định
SELECT @WorkMarks = Isnull(WorkMarks,0), @RegulationsMarks = Isnull(RegulationsMarks,0)
FROM HT0000
WHERE DivisionID = @DivisionID

IF @IsTime = 0
BEGIN
	SET @FromMonth = @TranMonth
	SET @ToMonth = @TranMonth
END
	
IF @IsTime = 1
BEGIN
	IF @TranMonth = 1
		Begin
			SET @FromMonth = 1
			SET @ToMonth = 3
		End
	IF @TranMonth = 2
		Begin
			SET @FromMonth = 4
			SET @ToMonth = 6
		End
	IF @TranMonth = 3
		Begin
			SET @FromMonth = 7
			SET @ToMonth = 9
		End
	IF @TranMonth = 4
		Begin
			SET @FromMonth = 10
			SET @ToMonth = 12
		End
END

IF @IsTime = 2
BEGIN
	SET @FromMonth = 1
	SET @ToMonth = 12
END
	
--- Tạo bảng tạm
CREATE TABLE #TAM
(
	EmployeeID nvarchar(50),
	EndWorkMarks int,
	EndRegulationsMarks int
)

INSERT INTO #TAM (EmployeeID, EndWorkMarks, EndRegulationsMarks)
SELECT EmployeeID, (Isnull(@WorkMarks,0) - Isnull(HavePermission,0) - Isnull(NoPermission,0)),
		(Isnull(@RegulationsMarks,0) - Isnull(NoScanning,0) - Isnull(InLate,0) - Isnull(Moving,0) - Isnull(Uniform,0)
		- Isnull(NameTable,0) - Isnull(LabourSafety,0) - Isnull(InOut,0))
FROM HT0298
WHERE DivisionID = @DivisionID AND (TranMonth Between  @FromMonth And @ToMonth) AND TranYear = @TranYear
AND EmployeeID in (Select EmployeeID From HT2400 WHERE DivisionID = @DivisionID AND (TranMonth Between  @FromMonth And @ToMonth) AND TranYear = @TranYear
					And DepartmentID like @DepartmentID And ISNULL(TeamID,'') like @TeamID)

--- Lấy dữ liệu báo cáo
SET @sSQL = 'SELECT * FROM (
SELECT HT98.*, HV14.FullName, HV14.DepartmentID, HV14.DepartmentName, HV14.TeamID, HV14.TeamName, ' + str(@WorkMarks) + ' As WorkMarks, ' +
				str(@RegulationsMarks) + ' As RegulationsMarks,	#TAM.EndRegulationsMarks, #TAM.EndWorkMarks, (#TAM.EndRegulationsMarks + #TAM.EndWorkMarks) as TotalMarks, 
				(Select TypeID From HT0296 Where DivisionID = ''' + @DivisionID + ''' And TypeOf = ' + STR(@IsTime) + '
					And ((#TAM.EndRegulationsMarks + #TAM.EndWorkMarks) Between FromMark And ToMark)) as Rank
	
			FROM HT0298 HT98
			INNER JOIN #TAM ON HT98.EmployeeID = #TAM.EmployeeID
			INNER JOIN HV1400 HV14 On HT98.DivisionID = HV14.DivisionID And HT98.EmployeeID = HV14.EmployeeID
			Where HT98.DivisionID = ''' + @DivisionID + '''
			AND (TranMonth Between ' + str(@FromMonth) + ' And ' + str(@ToMonth) + ') AND TranYear = ' + str(@TranYear) + '
			AND HT98.EmployeeID in (Select EmployeeID From HT2400 WHERE DivisionID = ''' + @DivisionID + '''
								AND (TranMonth Between ' + str(@FromMonth) + ' And ' + str(@ToMonth) + ') AND TranYear = ' + str(@TranYear) + '
								And DepartmentID like ''' + @DepartmentID + ''' And ISNULL(TeamID,'''') like ''' + @TeamID + ''')
) A' + ' ' + @Orderby

---print @sSQL
EXEC(@sSQL)