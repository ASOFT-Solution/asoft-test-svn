/****** Object:  StoredProcedure [dbo].[HP2432]    Script Date: 01/04/2012 11:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET NOCOUNT ON
GO

---Created by: Dang Le Bao Quynh, date: 11/10/2007
---purpose: Xac dinh ca lam viec
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
----- Edited by Tan Phu		Date: 26/12/2012
----- Purpose: fix trường hợp chuyển nhân viên từ phòng ban này sang phòng bang khác, tối ưu hóa sql HV2433 thêm điều kiện month year
----- Purpose: [ TT4522 ] [TIENHUNG] Hỗ trợ phần chấm công bị double dòng, vấn đề 1
'********************************************/
---Edited by: Dang Le Bao Quynh, date: 07/03/2013
---purpose: Tra ve cach xu ly ban goc, version 7.1
--- Modify on 11/08/2013 by Bảo Anh: Bổ sung lấy thông tin chấm công có giờ vào < giờ bắt đầu ca, giờ ra > giờ kết thúc ca làm việc
--- Modify on 30/10/2013 by Bảo Anh: Bổ sung trường hợp ca đêm khi lấy dữ liệu cho trường AbsentDate ở view HV2433
--- Modify on 01/12/2013 by Bảo Anh: Sửa lỗi chấm công ca đêm chưa đúng trong trường hợp 1 ngày có đủ In/Out
--- Modify on 31/12/2013 by Bảo Anh: Sửa lỗi chấm công không lên khi giờ ra = giờ kết thúc ca (Tiến Hưng: CRM TT7818)
--- Modify on 30/06/2015 by Bảo Anh: Bổ sung chấm công theo từng nhân viên và cải tiến tốc độ
----HP2432 'CTY',11,2014,'11/03/2014','MON','%','MK.0011'

ALTER PROCEDURE [dbo].[HP2432] @DivisionID nvarchar(50),				
				@TranMonth int,
				@TranYear int,
				@DateProcess datetime,
				@DateTypeID nvarchar(3),
				@DepartmentID nvarchar(50),	
				@CreateUserID nvarchar(50),
				@EmployeeID nvarchar(50) = '%'

AS
Declare @curHV2432 cursor,
		@curHV2433 cursor,
		@ShiftID nvarchar(50),
		@BeginTime varchar(8),
		@EndTime varchar(8),
		@FromMinute varchar(8),
		@ToMinute varchar(8),
		@IsOverTime bit,
		@IsNextDay bit,
		@NextDateProcess datetime,
		@RestrictID nvarchar(50),	
		@EmployeeID1 nvarchar(50),
		@AbsentCardNo nvarchar(50),	
		@sSQL nvarchar(max),
		@sSQL1 nvarchar(max),
		@ParamDefinition NVARCHAR(MAX)

SELECT  @ParamDefinition= '@DivisionID2 nvarchar(50), @DateProcess2 datetime, @DepartmentID2 nvarchar(50), @EmployeeID2 nvarchar(50)'
		
Set @sSQL = 	'
Delete from HTT2432
Insert into HTT2432 (DivisionID, EmployeeID, ShiftID)
Select DivisionID, EmployeeID, ShiftID
From (
Select HT1025.DivisionID, HT1025.EmployeeID, CASE Day(@DateProcess2)     
                      WHEN 1 THEN D01 WHEN 2 THEN D02 WHEN 3 THEN D03 WHEN 4 THEN D04 WHEN 5 THEN D05 WHEN 6 THEN D06 WHEN    
                       7 THEN D07 WHEN 8 THEN D08 WHEN 9 THEN D09 WHEN 10 THEN D10 WHEN 11 THEN D11 WHEN 12 THEN D12 WHEN    
                       13 THEN D13 WHEN 14 THEN D14 WHEN 15 THEN D15 WHEN 16 THEN D16 WHEN 17 THEN D17 WHEN 18 THEN D18 WHEN    
                       19 THEN D19 WHEN 20 THEN D20 WHEN 21 THEN D21 WHEN 22 THEN D22 WHEN 23 THEN D23 WHEN 24 THEN D24 WHEN    
                       25 THEN D25 WHEN 26 THEN D26 WHEN 27 THEN D27 WHEN 28 THEN D28 WHEN 29 THEN D29 WHEN 30 THEN D30 WHEN    
                       31 THEN D31 ELSE NULL END As ShiftID 
				From HT1025 
				 Inner join HT1400 On HT1025.DivisionID = HT1400.DivisionID And HT1025.EmployeeID = HT1400.EmployeeID
				 WHERE HT1025.DivisionID = @DivisionID2 And (HT1025.TranMonth + HT1025.TranYear*12) = (Month(@DateProcess2) + Year(@DateProcess2)*12)
				 And HT1400.DepartmentID like @DepartmentID2 And HT1400.EmployeeID like @EmployeeID2)A'

--Loc ra nhung ca lam viec lap trong ngay
---EXEC (@sSQL)
EXEC sp_executesql
	@sSQL,
	@ParamDefinition,
	@DivisionID2 = @DivisionID,
	@DateProcess2= @DateProcess,
	@DepartmentID2 = @DepartmentID,
	@EmployeeID2 = @EmployeeID


Set @curHV2432 = cursor static for
	Select Distinct ShiftID From HTT2432 Where isnull(ShiftID,'') <> ''

Open @curHV2432

Fetch Next From @curHV2432 Into @ShiftID
While @@Fetch_Status = 0
Begin

	Select Top 1 @BeginTime = BeginTime, @EndTime = EndTime, @IsNextDay = IsNextDay
	From HV1020 Where ShiftID = @ShiftID And DateTypeID = @DateTypeID and DivisionID = @DivisionID Order by IsNextDay Desc
	
	IF @BeginTime is NULL
	  SET @BeginTime = '00:00:00'
	IF @EndTime is NULL
	  SET @EndTime = '00:00:00'
	    
	--Neu ca lam viec co tinh ngay ke, gan bien ngay ke = ngay xu ly + 1 
	If @IsNextDay = 1
		Set @NextDateProcess = DateAdd(d,1,@DateProcess)
	Else -- Nguoc lai gan bien ngay ke = ngay xu ly
		Set @NextDateProcess = @DateProcess
		
	--- Xét thêm trường hợp ca đêm	
---	IF @IsNextDay = 1
---		Set @sSQL1 = '
	--	Delete from HTT2433
	--	Insert into HTT2433 (DivisionID	, EmployeeID, TranMonth, TranYear, AbsentCardNo, AbsentDate, AbsentTime, MachineCode, ShiftCode, IOCode, InputMethod, ScanDate)
	--	Select 	DivisionID	, EmployeeID, TranMonth, TranYear, AbsentCardNo, AbsentDate, AbsentTime, MachineCode, ShiftCode, IOCode, InputMethod, ScanDate
	--	From (
	--	Select Distinct DivisionID,EmployeeID,TranMonth, TranYear, AbsentCardNo,AbsentDate,AbsentTime,MachineCode,ShiftCode,IOCode,InputMethod,
	--				(Case when IOCode = 1 then Cast(Ltrim(Month(DateAdd(d,1,AbsentDate))) + ''/'' + LTrim(Day(DateAdd(d,1,AbsentDate))) + ''/'' + LTRIM(yEAR(DateAdd(d,1,AbsentDate))) + '' '' + AbsentTime As DateTime)
	--				else Cast(Ltrim(Month(AbsentDate)) + ''/'' + LTrim(Day(AbsentDate)) + ''/'' + LTRIM(yEAR(AbsentDate)) + '' '' + AbsentTime As DateTime) end) As ScanDate
	--				From HTT2408 Where ' +
	--			 '((Cast(Ltrim(Month(AbsentDate)) + ''/'' + LTrim(Day(AbsentDate)) + ''/'' + LTRIM(yEAR(AbsentDate)) + '' '' + AbsentTime As DateTime) Between ''' + ltrim(Cast(@DateProcess + ' ' + @BeginTime As DateTime))  + ''' And ''' + ltrim(Cast(@NextDateProcess + ' ' + @EndTime As DateTime)) + ''') 
	--			 Or (AbsentDate = ''' + ltrim(@DateProcess) + ''' and (Cast(AbsentTime as time) < ''' + ltrim(cast(@BeginTime as time)) + ''' or cast(AbsentTime as time) >= ''' + ltrim(cast(@EndTime as time)) + ''')))
	--			 And EmployeeID In (Select EmployeeID From HTT2432 Where ShiftID = ''' + @ShiftID + '''))B'    
	--ELSE

		SELECT  @ParamDefinition= '@DateProcess2 datetime, @BeginTime2 nvarchar(100), @NextDateProcess2 datetime, @EndTime2 nvarchar(100), @ShiftID2 nvarchar(50)'

		Set @sSQL1 = '
		Delete from HTT2433
		Insert into HTT2433 (DivisionID	, EmployeeID, TranMonth, TranYear, AbsentCardNo, AbsentDate, AbsentTime, MachineCode, ShiftCode, IOCode, InputMethod, ScanDate)
		Select 	DivisionID	, EmployeeID, TranMonth, TranYear, AbsentCardNo, AbsentDate, AbsentTime, MachineCode, ShiftCode, IOCode, InputMethod, ScanDate
		From (
		Select DivisionID,EmployeeID,TranMonth, TranYear, AbsentCardNo,AbsentDate,AbsentTime
					,MachineCode, ShiftCode, IOCode, InputMethod,Cast(Ltrim(Month(AbsentDate)) + ''/'' + LTrim(Day(AbsentDate)) + ''/'' + LTRIM(yEAR(AbsentDate)) + '' '' + AbsentTime As DateTime) As ScanDate From HTT2408 Where ' +
				 '(Convert(nvarchar(20),ltrim(AbsentDate) + '' '' + AbsentTime,101) Between Convert(nvarchar(20),ltrim(@DateProcess2) + '' '' + @BeginTime2,101)  And Convert(nvarchar(20),ltrim(@NextDateProcess2) + '' '' + @EndTime2,101))
				 And exists (Select top 1 1 From HTT2432 Where EmployeeID = HTT2408.EmployeeID and ShiftID = @ShiftID2)) C'
			 
--EXEC (@sSQL1)
EXEC sp_executesql
	@sSQL1,
	@ParamDefinition,
	@DateProcess2 = @DateProcess,
	@BeginTime2= @BeginTime,
	@NextDateProcess2 = @NextDateProcess,
	@EndTime2 = @EndTime,
	@ShiftID2 =@ShiftID

/*			
	-- thêm tranmonth và tranyear vào để kiểm tra trường hợp nhân viên thay đổi phòng ban
Set @curHV2433 = cursor static for
Select Distinct HV1.EmployeeID From HV2433 HV1
inner join HT2400 HT1 on HV1.EmployeeID = HT1.EmployeeID and HV1.DivisionID = HT1.DivisionID
Where HV1.DivisionID = @DivisionID
and HT1.DepartmentID like @DepartmentID
And HT1.TranMonth = @TranMonth And HT1.TranYear = @TranYear
And (select count(*) From HV2433  HV2
inner join HT2400 HT2  on HV2.EmployeeID = HT2.EmployeeID and HV2.DivisionID = HT2.DivisionID
where HV2.DivisionID = @DivisionID
And HT2.TranMonth = @TranMonth And HT2.TranYear = @TranYear
and HT2.DepartmentID like @DepartmentID
And HV2.employeeid = HV1.EmployeeID) % 2 = 0
Open @curHV2433
Fetch Next From @curHV2433 Into @EmployeeID1
--End Thử					
	--Lap tung nhan vien co so lan quet the hop le (so chan) 	
*/

	Set @curHV2433 = cursor static for 
	Select Distinct EmployeeID From HTT2433 HV24
	Where HV24.DivisionID = @DivisionID And (select count(EmployeeID) From HTT2433 where DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear And employeeid = HV24.EmployeeID) % 2 = 0
	Open @curHV2433
	Fetch Next From @curHV2433 Into @EmployeeID1
	While @@Fetch_Status=0
	Begin
		Select Top  1 @AbsentCardNo = AbsentCardNo From HTT2433 Where DivisionID = @DivisionID And EmployeeID= @EmployeeID1
		Exec HP2433 @DivisionID, @TranMonth, @TranYear, @DateProcess, @EmployeeID1, @AbsentCardNo, @ShiftID, @DateTypeID, @IsNextDay, @CreateUserID
		Fetch Next From @curHV2433 Into @EmployeeID1
	End

	Close @curHV2433

	Fetch Next From @curHV2432 Into @ShiftID
End
Close @curHV2432

Deallocate @curHV2432
SET NOCOUNT OFF
