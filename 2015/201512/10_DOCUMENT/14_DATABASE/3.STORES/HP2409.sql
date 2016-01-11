/****** Object:  StoredProcedure [dbo].[HP2409]    Script Date: 07/30/2010 16:29:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


---Created by: Vo Thanh Huong, date: 16/10/2004
---Purpose:  Insert vào HT2408 tu Table tam  HT2406
---Edit by: Dang Le Bao Quynh, date 05/10/2007
---Thay doi cach luu du lieu vao bang tam 

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2409] @DivisionID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@FromDate datetime, 
				@ToDate datetime,
				@DepartmentID nvarchar(50),
				@CreateUserID nvarchar(50)				
AS

Declare @cur as cursor,
	@EmployeeID nvarchar(50),
	@BeginDate datetime,
	@EndDate datetime

Delete HT2408 
From HT2408 inner join  HV1400 on HV1400.EmployeeID=HT2408.EmployeeID and HV1400.DivisionID=HT2408.DivisionID
Where 	HT2408.DivisionID = @DivisionID and
	HT2408.TranMonth = @TranMonth and
	HT2408.TranYear = @TranYear and
	HV1400.DepartmentID like @DepartmentID and
	HT2408.AbsentDate between @FromDate and @ToDate
	
Set @cur = cursor static for
Select HT1407.EmployeeID, HT1407.BeginDate, isnull(HT1407.EndDate,'12/31/9999') From HT1407 
inner join  HV1400 on HV1400.EmployeeID=HT1407.EmployeeID and HV1400.DivisionID=HT1407.DivisionID
Where 	HT1407.EmployeeID In (Select EmployeeID From HV1400 Where DivisionID = @DivisionID And DepartmentID like @DepartmentID)
And HT1407.DivisionID = @DivisionID
And HV1400.DepartmentID like @DepartmentID
And HT1407.BeginDate<=@ToDate And @FromDate<=isnull(EndDate,'12/31/9999')
	
	
Open @cur
Fetch Next From @cur Into  @EmployeeID, @BeginDate, @EndDate
While @@Fetch_Status=0
Begin
	Insert HT2408(DivisionID, TranMonth, TranYear, AbsentCardNo,  EmployeeID, AbsentDate, AbsentTime, 
		CreateUserID, CreateDate, LastModifyUserID, LastModifyDate, MachineCode, ShiftCode, IOCode,InputMethod) 
	Select 	@DivisionID, @TranMonth, @TranYear, T00.AbsentCardNo, T01.EmployeeID, T00.AbsentDate, T00.AbsentTime,
		@CreateUserID, getdate(), @CreateUserID, getdate(), MachineCode, ShiftCode, IOCode,InputMethod
	From 	HT2406 T00 left  join HT1407 T01 on T00.AbsentCardNo = T01.AbsentCardNo and T00.DivisionID = T01.DivisionID
	Where 	T00.AbsentDate Between  @BeginDate And  @EndDate
		And T00.AbsentDate Between @FromDate And @ToDate
		And T01.EmployeeID = @EmployeeID
		And T00.DivisionID = @DivisionID
		And TranMonth = @TranMonth 
		And	TranYear = @TranYear
		 
	Fetch Next From @cur Into  @EmployeeID, @BeginDate, @EndDate
End

Close @Cur


--EXEC HP2430  @DivisionID, 	@TranMonth,	 @TranYear,	@FromDate,	 @ToDate, 	@CreateUserID