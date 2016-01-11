/****** Object:  StoredProcedure [dbo].[HP2434]    Script Date: 08/02/2010 15:14:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Created by: Vo Thanh Huong, date: 22/10/2004
---purpose: Ket chuyen tu quet the sang cham cong ngay
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2434] @DivisionID nvarchar(50),
				@DepartmentID nvarchar(4000),				
				@TranMonth int,
				@TranYear int,
				@FromDate datetime,
				@ToDate datetime,
				@CreateUserID nvarchar(50)
 AS
Declare @cur cursor,
	@ShiftID nvarchar(50),
	@AbsentDate datetime,
	@AbsentHour  decimal(28,8),
	@TimeConvert decimal(28,8),
	@TransactionID nvarchar(50),
	@TeamID nvarchar(50),
	@EmployeeID nvarchar(50),
	@AbsentTypeID nvarchar(50),
	@AbsentAmount decimal(28,8)

Set @DepartmentID = Replace(@DepartmentID, ',', ''',''') 

Delete HT2410
Delete HT2409 
From HT2409 T00 inner join HV1400 V00 on V00.EmployeeID = T00.EmployeeID
Where T00.DivisionID = @DivisionID and
	V00.DepartmentID in (@DepartmentID) and 
	T00.TranMonth = @TranMonth and
	T00.TranYear = @TranYear and
	AbsentDate between @FromDate and @ToDate		
	
Insert HT2409 (DivisionID, DepartmentID, TeamID, EmployeeID,TranMonth, TranYear, ShiftID, AbsentDate,  AbsentHour) 
Select T00.DivisionID, T01.DepartmentID, T01.TeamID, T00.EmployeeID, T00.TranMonth, T00.TranYear, T00.ShiftID, AbsentDate,
	 sum(AbsentHour) as AbsentHour 
	From HT2407 T00 inner join HT2400 T01 on T00.EmployeeID = T01.EmployeeID
	Where T00.DivisionID = @DivisionID and
		T01.DepartmentID IN (@DepartmentID) and		
		 T00.TranMonth = @TranMonth and
		 T00.TranYear = @TranYear and
		 AbsentDate between @FromDate and @ToDate
		Group by  T00.DivisionID, T01.DepartmentID, T01.TeamID, T00.EmployeeID, T00.TranMonth, T00.TranYear, T00.ShiftID, AbsentDate

---Tính loai cong
Set @cur = Cursor scroll keyset for
		Select DivisionID, DepartmentID, TeamID, EmployeeID, TranMonth, TranYear, ShiftID, AbsentDate,  AbsentHour
			From HT2409
			Where DivisionID = @DivisionID and 
				TranMonth = @TranMonth and
				TranYear = @TranYear and
				AbsentDate between @FromDate and @ToDate 
Open @cur
Fetch next from @cur into  @DivisionID, @DepartmentID, @TeamID, @EmployeeID, @TranMonth, @TranYear, @ShiftID, @AbsentDate, @AbsentHour

While @@Fetch_status = 0
Begin	 	
	Insert HT2410(DivisionID, DepartmentID, TeamID, EmployeeID, TranMonth, TranYear, AbsentDate, AbsentTypeID, AbsentAmount) 
		Select @DivisionID, @DepartmentID, @TeamID, @EmployeeID, @TranMonth, @TranYear, 
			@AbsentDate, AbsentTypeID, case when isnull(AbsentAmount, 0) > 0 then 
			isnull(ConvertUnit, 1) * AbsentAmount else isnull(ConvertUnit, 0) * @AbsentHour end as AbsentAmount
		From HT1021 
		Where ShiftID = @ShiftID and 
			(@AbsentHour >= case when  isnull(FromHour, 0) >0 then FromHour else 0 end) and 
			(@AbsentHour < case when  isnull(ToHour, 0) >0 then ToHour else @AbsentHour + 1  end)  	
	 
	Fetch next from @cur into  @DivisionID, @DepartmentID, @TeamID, @EmployeeID, @TranMonth, @TranYear, @ShiftID, @AbsentDate, @AbsentHour
End

---Ket chuyen vao HT2401
Set @cur =  Cursor scroll keyset for
		Select DivisionID, DepartmentID, TeamID, EmployeeID, TranMonth, TranYear, AbsentDate, AbsentTypeID, sum(AbsentAmount) as AbsentAmount
			From HT2410 
			Group by DivisionID, DepartmentID, TeamID, EmployeeID, TranMonth, TranYear, AbsentDate,  AbsentTypeID, AbsentAmount
			
Fetch next  from @cur into @DivisionID, @DepartmentID, @TeamID, @EmployeeID, 
		@TranMonth, @TranYear, @AbsentDate, @AbsentTypeID, @AbsentAmount		

While @@fetch_Status = 0
Begin
	If not exists (Select Top 1  1 From HT2401 
			Where EmployeeID = @EmployeeID and 
				TranMonth = @TranMonth and
				TranYear = @TranYear and
				AbsentDate = @AbsentDate and
				AbsentTypeID = @AbsentTypeID ) 	
	Insert HT2401(DivisionID, DepartmentID, TeamID, EmployeeID, TranMonth, TranYear, 
			AbsentDate, AbsentTypeID, AbsentAmount,
			CreateUserID, CreateDate, LastModifyuserID, LastModifyDate)
	values(@DivisionID, @DepartmentID, @TeamID, @EmployeeID, @TranMonth, @TranYear, 
			@AbsentDate, @AbsentTypeID, @AbsentAmount,
			@CreateUserID, getdate(), @CreateUserID, getdate())	

	Fetch next  from @cur into @DivisionID, @DepartmentID, @TeamID, @EmployeeID, 
		@TranMonth, @TranYear, @AbsentDate, @AbsentTypeID, @AbsentAmount		
End
GO
