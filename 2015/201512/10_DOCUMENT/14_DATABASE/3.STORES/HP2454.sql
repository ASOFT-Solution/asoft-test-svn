IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2454]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2454]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Tính sản phẩm theo phương pháp phân bổ theo từng nhân viên
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 23/08/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 14/11/2013 by Lê Thị Thu Hiền : Bổ sung thêm customize cho cảng sài gòn
-- <Example>
---- 

CREATE PROCEDURE HP2454
(
		@DivisionID nvarchar(50), 
		@TranMonth int, 
		@TranYear int, 
		@PayrollMethodID nvarchar(50), 
		@GeneralAbsentID as nvarchar(50)  
)  
As
Declare @BeginDate datetime, 
		@EndDate datetime,
		@TimeConvert decimal(28,8), 
		@AbsentDecimals tinyint

Delete	HT2414 
Where	DivisionID = @DivisionID 
		And TranMonth = @TranMonth 
		And TranYear = @TranYear 
		And PayrollMethodID = @PayrollMethodID

----------->>>> Kiem tra customize cho CSG
Declare @AP4444 Table(CustomerName Int, Export Int)
Declare @CustomerName AS Int
Insert Into @AP4444(CustomerName,Export) EXEC('AP4444')
Select @CustomerName=CustomerName From @AP4444
-----------<<<< Kiem tra customize cho CSG


Select	@BeginDate=BeginDate, 
		@EndDate = EndDate 
From	HT9999 
Where	DivisionID = @DivisionID 
		And TranMonth = @TranMonth 
		And TranYear = @TranYear
		
Select	@TimeConvert=TimeConvert, 
		@AbsentDecimals=AbsentDecimals 
From	HT0000 
Where	DivisionID = @DivisionID

While @BeginDate<=@EndDate
Begin

		Insert Into HT2414
			(APK,DivisionID, TranMonth, TranYear,
			PayrollMethodID, DepartmentID, TeamID,	EmployeeID,	
			AbsentDate,	AbsentHour,	AbsentDay, Coefficient, TeamAmount)
		SELECT	NewID(),DivisionID, TranMonth, TranYear,
				@PayrollMethodID,	'CHUYEN_TEAM',	TeamID,
				EmployeeID,		@BeginDate,
				Round(WorkingHours,@AbsentDecimals),
				Round(WorkingHours/@TimeConvert,@AbsentDecimals),
				(	Select ISNULL(HT0256.DayCoefficient,HT2400.SalaryCoefficient) 
					From	HT2400 
					Left Join HT0256 
							On	HT2400.DivisionID = HT0256.DivisionID 
							And HT2400.TranMonth = HT0256.TranMonth
							And HT2400.TranYear = HT0256.TranYear 
							And HT2400.EmployeeID = HT0256.EmployeeID
							And @BeginDate Between HT0256.FromDate And HT0256.ToDate
					Where	HT2400.DivisionID = @DivisionID 
							And HT2400.TranMonth = @TranMonth 
							And HT2400.TranYear = @TranYear
							And HT2400.EmployeeID = HT0257.EmployeeID),
				(	Select	Sum(isnull(Quantity,0)*isnull(UnitPrice ,0))
		
		 FROM	HT2413 
		Inner Join HT1015 
				On HT2413.ProductID = HT1015.ProductID 
				And HT2413.DivisionID = HT1015.DivisionID
		Where	HT2413.DivisionID = @DivisionID 
				And HT2413.TranMonth = @TranMonth 
				And HT2413.TranYear = @TranYear 
				And HT2413.TrackingDate = @BeginDate 
				And HT2413.TeamID = HT0257.TeamID)
		From	HT0257 
		Where	DivisionID = @DivisionID 
				And TranMonth = @TranMonth 
				And TranYear = @TranYear 
				And WorkingDate = @BeginDate

	Insert Into HT2414
	(APK,DivisionID, TranMonth, TranYear,
	PayrollMethodID, DepartmentID, TeamID,	EmployeeID,	
	AbsentDate,	AbsentHour,	AbsentDay, Coefficient, TeamAmount)
	
	Select NewID(), DivisionID, TranMonth, TranYear,
	@PayrollMethodID, 
	'TEAM_THEOCONGNGAY',
	TeamID,
	EmployeeID,
	@BeginDate,
	Round(Sum(Isnull(AbsentAmount,0)), @AbsentDecimals),
	Round(Sum(Isnull(AbsentAmount,0))/@TimeConvert, @AbsentDecimals),
	(Select ISNULL(HT0256.DayCoefficient,HT2400.SalaryCoefficient) From HT2400 Left Join HT0256 On
	HT2400.DivisionID = HT0256.DivisionID And HT2400.TranMonth = HT0256.TranMonth
	And HT2400.TranYear = HT0256.TranYear And HT2400.EmployeeID = HT0256.EmployeeID
	And @BeginDate Between HT0256.FromDate And HT0256.ToDate
	Where HT2400.DivisionID = @DivisionID And HT2400.TranMonth = @TranMonth And HT2400.TranYear = @TranYear
	And HT2400.EmployeeID = HT2401.EmployeeID),
	(Select Sum(isnull(Quantity,0)*isnull(UnitPrice ,0))
	From HT2413 Inner Join HT1015 
	On HT2413.ProductID = HT1015.ProductID And HT2413.DivisionID = HT1015.DivisionID
	Where HT2413.DivisionID = @DivisionID And HT2413.TranMonth = @TranMonth And HT2413.TranYear = @TranYear 
	And HT2413.TrackingDate = @BeginDate And HT2413.TeamID = HT2401.TeamID)
	From HT2401
	Where DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear And AbsentDate = @BeginDate
	And AbsentTypeID In (Select AbsentTypeID From HT5003 Where DivisionID = @DivisionID And GeneralAbsentID = @GeneralAbsentID)
	And @PayrollMethodID + ' _' + TeamID + '_' + EmployeeID not in (Select PayrollMethodID + '_' + TeamID + '_' + EmployeeID From HT2414 
	Where DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear And AbsentDate = @BeginDate) 
	Group By DivisionID, TranMonth, TranYear, TeamID, EmployeeID
	
	Set @BeginDate = Dateadd(d,1,@BeginDate)
End

IF @CustomerName = 19 AND @PayrollMethodID LIKE 'PPLSP%'
	DELETE FROM HT2414 WHERE EmployeeID NOT IN (SELECT	EmployeeID 
	                                            FROM	HT2400 
	                                            WHERE	DivisionID = @DivisionID
														AND TranMonth = @TranMonth
														AND TranYear = @TranYear 
														AND IsPiecework = 1 ) 

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

