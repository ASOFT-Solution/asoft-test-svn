/****** Object:  StoredProcedure [dbo].[HP2436]    Script Date: 08/02/2010 15:14:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Created by : Dang Le Bao Quynh, Date : 15/10/2007
---Purpose: Ket chuyen sang cham cong ngay 
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
'********************************************/
--- Modify on 04/08/2013 by Bao Anh: Bo sung tinh so cong theo dieu kien (Hung Vuong)
--- Modify on 27/12/2013 by Bao Anh: Sửa thứ tự Where cho các bảng HT2407, HT2401 theo Index để cải thiện tốc độ
--- Modify on 07/02/2015 by Bảo Anh: Gọi HP0354 customize cho IPL
--- Modify on 14/12/2015 by Bảo Anh: Nhân thêm hệ số khi tính số công, kết chuyển chấm công từ các loại đơn xin phép trên ApproveOnline (Meiko)

ALTER PROCEDURE [dbo].[HP2436]   	@DivisionID nvarchar(50),
					@DepartmentID nvarchar(50),
					@EmployeeID nvarchar(50),
				 	@TranMonth int,
				 	@TranYear int,
				 	@FromDate datetime,
				 	@ToDate datetime,
					@UserID nvarchar(50)
				
AS
	DECLARE 	@curHT2407 cursor,
			@mDepartmentID nvarchar(50),
			@mTeamID nvarchar(50),
			@mEmployeeID nvarchar(50),
			@AbsentTypeID nvarchar(50),
			@AbsentDate datetime,
			@AbsentAmount decimal(28,8),
			@ShiftID nvarchar(50),
			@UnitID nvarchar(50),
			@WorkingTime decimal(28,8),
			@IsCondition tinyint,
			@ConditionCode nvarchar(4000),
			@ConditionAmount decimal(28,8),
			@CustomerIndex int,
			@ConvertUnit DECIMAL(28,8)

Set @ConditionAmount = 0
Set @AbsentDate = @FromDate

While @AbsentDate<=@ToDate
Begin
	Set @curHT2407 = cursor static for 
	Select HT00.DepartmentID,HT00.TeamID,HT00.EmployeeID,HT07.ShiftID,Sum(isnull(HT07.AbsentHour,0)),HT07.AbsentTypeID,
			HT1013.IsCondition, HT1013.ConditionCode, Isnull(HT1013.ConvertUnit,1)
	From HT2407 HT07 Inner Join 
	(Select DivisionID, DepartmentID, TeamID, EmployeeID From HT2400 
			Where 	DivisionID = @DivisionID And
				TranMonth = @TranMonth And
				TranYear = @TranYear And
				DepartmentID Like @DepartmentID And
				EmployeeID Like @EmployeeID) HT00
	On HT07.EmployeeID = HT00.EmployeeID and HT07.DivisionID = HT00.DivisionID
	Left join HT1013 On HT07.DivisionID = HT1013.DivisionID And HT07.AbsentTypeID = HT1013.AbsentTypeID
	Where 	HT07.DivisionID = @DivisionID And
		HT07.AbsentDate = @AbsentDate ---And
	---	HT07.TranMonth = @TranMonth And
	---	HT07.TranYear = @TranYear 
	Group by HT00.DepartmentID,HT00.TeamID,HT00.EmployeeID,ShiftID,HT07.AbsentTypeID,IsCondition,ConditionCode,Isnull(HT1013.ConvertUnit,1)
	
	Open @curHT2407
	
	Fetch Next From @curHT2407 Into @mDepartmentID,@mTeamID,@mEmployeeID,@ShiftID,@AbsentAmount,@AbsentTypeID,@IsCondition,@ConditionCode,@ConvertUnit
	While @@Fetch_Status = 0
	Begin
		IF @IsCondition = 1 and ISNULL(@ConditionCode,'') <> ''
			BEGIN
				EXEC HP5556 @AbsentAmount , @ConditionCode , @ConditionAmount OUTPUT
				SET @AbsentAmount = @ConditionAmount
			END
		--- Nhân thêm hệ số vào số công
		SELECT @AbsentAmount = @AbsentAmount * @ConvertUnit
				
		Select @WorkingTime = WorkingTime From HT1020 Where DivisionID = @DivisionID And ShiftID = @ShiftID
		If isnull(@WorkingTime,0)<=0
			Begin
				Set @WorkingTime = 8
			End
		Select Top 1 @UnitID = UnitID From HT1013 Where DivisionID = @DivisionID And AbsentTypeID = @AbsentTypeID

		If exists (Select Top 1 1 From HT2401 Where DivisionID = @DivisionID And TranYear = @TranYear And TranMonth = @TranMonth And DepartmentID = @mDepartmentID And EmployeeID = @mEmployeeID And AbsentDate = @AbsentDate And AbsentTypeID = @AbsentTypeID)
			Begin
				Update HT2401 Set AbsentAmount = (Case When @UnitID = 'H' Then  @AbsentAmount Else @AbsentAmount / @WorkingTime End), LastModifyUserID = @UserID, LastModifyDate = getDate()
				Where DivisionID = @DivisionID And TranYear = @TranYear And TranMonth = @TranMonth And DepartmentID = @mDepartmentID And EmployeeID = @mEmployeeID And AbsentDate = @AbsentDate And AbsentTypeID = @AbsentTypeID
			End
		Else
			Begin
				Insert Into HT2401(AbsentDate,EmployeeID,DivisionID,TranMonth,TranYear,DepartmentID,TeamID,AbsentTypeID,AbsentAmount,CreateDate,LastModifyDate,CreateUserID,LastModifyUserID)
				Values(@AbsentDate,@mEmployeeID,@DivisionID,@TranMonth,@TranYear,@mDepartmentID,@mTeamID,@AbsentTypeID,(Case When @UnitID = 'H' Then  @AbsentAmount Else @AbsentAmount / @WorkingTime End),getDate(),getDate(),@UserID,@UserID)				
			End

		Fetch Next From @curHT2407 Into @mDepartmentID,@mTeamID,@mEmployeeID,@ShiftID,@AbsentAmount,@AbsentTypeID,@IsCondition,@ConditionCode,@ConvertUnit
	End
	Close @curHT2407

	Set @AbsentDate = DateAdd(d,1,@AbsentDate)
End

--- Customize IPL: Chuyển số tiền bị trừ đi trễ/về sớm vào loại công tương ứng trong bảng chấm công ngày
SELECT @CustomerIndex = CustomerName From CustomerIndex
IF @CustomerIndex = 17
	EXEC HP0354 @DivisionID, @TranMonth, @TranYear, @FromDate, @ToDate, @DepartmentID, @EmployeeID, @UserID

--- Customize Meiko: Chuyển phần chấm công từ Approve Online vào bảng chấm công ngày
IF @CustomerIndex = 50
	INSERT INTO HT2401 (AbsentDate,EmployeeID,DivisionID,TranMonth,TranYear,DepartmentID,TeamID,AbsentTypeID,AbsentAmount,CreateDate,LastModifyDate,CreateUserID,LastModifyUserID)
	SELECT AbsentDate,EmployeeID,DivisionID,TranMonth,TranYear,DepartmentID,TeamID,AbsentTypeID,AbsentAmount,CreateDate,LastModifyDate,CreateUserID,LastModifyUserID
	FROM HT2401_MK
	WHERE DivionID = @DivisionID AND DepartmentID like @DepartmentID AND EmployeeID like @EmployeeID
	AND TranMonth = @TranMonth AND TranYear = @TranYear AND (AbsentDate between @FromDate and @ToDate)