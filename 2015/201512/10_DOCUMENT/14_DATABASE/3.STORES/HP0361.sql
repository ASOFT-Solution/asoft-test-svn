IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0361]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP0361]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- 
-- <History>
---- Create on 03/12/2015 by Bảo Anh: Load dữ liệu đi trễ, về sớm
---- Modified on ... by ...
---- <Example> HP0361 'CTY',4,2015,'04/03/2015','04/03/2015','%'
  
CREATE PROCEDURE [dbo].[HP0361]  @DivisionID nvarchar(50),      
    @TranMonth int,  
    @TranYear int,
    @FromDate datetime,  
    @ToDate datetime,  
    @DepartmentID nvarchar(50)  
                                                    
AS    
   
Declare @DateProcess datetime,  
		@DateTypeID nvarchar(3),
		@BeginTime varchar(8),
		@EndTime varchar(8),
		@IsNextDay bit,
		@ShiftID nvarchar(50),
		@NextDateProcess datetime,
		@EmployeeID nvarchar(50),
		@AbsentCardNo nvarchar(50),
		@curHT2408 cursor,
		@curHT2433 cursor,
		@SQL varchar(max)

DELETE HT0356 Where DivisionID = @DivisionID and TranMonth = @TranMonth and TranYear = @TranYear
and (AbsentDate between @FromDate and @ToDate) and DepartmentID like @DepartmentID and Isnull(IsConfirm,0) = 0

Select HT08.EmployeeID,	HT08.AbsentCardNo, HT08.AbsentDate, HT08.AbsentTime,
		CASE Day(HT08.AbsentDate)     
                      WHEN 1 THEN T25.D01 WHEN 2 THEN D02 WHEN 3 THEN D03 WHEN 4 THEN D04 WHEN 5 THEN D05 WHEN 6 THEN D06 WHEN    
                       7 THEN D07 WHEN 8 THEN D08 WHEN 9 THEN D09 WHEN 10 THEN D10 WHEN 11 THEN D11 WHEN 12 THEN D12 WHEN    
                       13 THEN D13 WHEN 14 THEN D14 WHEN 15 THEN D15 WHEN 16 THEN D16 WHEN 17 THEN D17 WHEN 18 THEN D18 WHEN    
                       19 THEN D19 WHEN 20 THEN D20 WHEN 21 THEN D21 WHEN 22 THEN D22 WHEN 23 THEN D23 WHEN 24 THEN D24 WHEN    
                       25 THEN D25 WHEN 26 THEN D26 WHEN 27 THEN D27 WHEN 28 THEN D28 WHEN 29 THEN D29 WHEN 30 THEN D30 WHEN    
                       31 THEN D31 ELSE NULL END As ShiftID
Into #HT2408
From HT2408 HT08
inner join HT1400 T00 on T00.EmployeeID = HT08.EmployeeID and T00.DivisionID = HT08.DivisionID
Left join HT1025 T25 On HT08.DivisionID = T25.DivisionID And HT08.TranMonth = T25.TranMonth and HT08.TranYear = T25.TranYear and HT08.EmployeeID = T25.EmployeeID  
Where	HT08.AbsentDate between @FromDate and DateAdd(d,2,@ToDate)  
		and HT08.DivisionID =@DivisionID 
		and T00.DepartmentID like @DepartmentID
		and not exists (Select top 1 1 From HT0356 Where DivisionID = @DivisionID and AbsentDate = HT08.AbsentDate
						and EmployeeID = HT08.EmployeeID and (convert(time,FromTime) = HT08.AbsentTime or convert(time,ToTime) = HT08.AbsentTime) and Isnull(IsConfirm,0) <> 0)


Set @DateProcess = @FromDate  
--Lap tung ngay va thuc hien viec tinh toan  
While @DateProcess <= @ToDate
Begin  
 --Gan gia tri DataTypeID, xac dinh ngay thu may trong tuan  
 IF exists (Select Top 1 1 From HT1026 Where DivisionID = @DivisionID And Tranyear = @TranYear And Holiday = @DateProcess And Isnull(IsTimeOff,0) = 0)  
  Set @DateTypeID = 'HOL'  
 ELSE IF exists (Select Top 1 1 From HT1026 Where DivisionID = @DivisionID And Tranyear = @TranYear And Holiday = @DateProcess And Isnull(IsTimeOff,0) <> 0)  
  Set @DateTypeID = 'SUN'  
 Else  
  Set @DateTypeID = DateName(dw,@DateProcess)
   
 Set @curHT2408 = cursor static for
 Select Distinct ShiftID From #HT2408 Where AbsentDate = @DateProcess and isnull(ShiftID,'') <> ''
 
 Open @curHT2408
 Fetch Next From @curHT2408 Into @ShiftID
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
		
		Select 	EmployeeID, AbsentCardNo, AbsentDate, AbsentTime, ScanDate
		Into ##HT03566
		From (
			Select EmployeeID, AbsentCardNo,AbsentDate,AbsentTime,
						Cast(Ltrim(Month(AbsentDate)) + '/' + LTrim(Day(AbsentDate)) + '/' + LTRIM(yEAR(AbsentDate)) + ' ' + AbsentTime As DateTime) As ScanDate
			From #HT2408
			Where (Convert(nvarchar(20),ltrim(AbsentDate) + ' ' + AbsentTime,101) Between Convert(nvarchar(20),ltrim(@DateProcess) + ' ' + @BeginTime,101)  And Convert(nvarchar(20),ltrim(@NextDateProcess) + ' ' + @EndTime,101))
			And ShiftID = @ShiftID) C
		
		Set @curHT2433 = cursor static for 
		Select Distinct EmployeeID, AbsentCardNo From ##HT03566 HV24
		Open @curHT2433
		Fetch Next From @curHT2433 Into @EmployeeID, @AbsentCardNo
		While @@Fetch_Status=0
		Begin
			SET @SQL = 'EXEC HP0357 ''' + @DivisionID + ''',' + ltrim(@TranMonth) + ',' + ltrim(@TranYear) + ',''' + ltrim(@DateProcess) + ''',''' + @ShiftID + ''',''' + @DateTypeID + ''',' + ltrim(@IsNextDay) + ',''' + @EmployeeID + ''',''' + @AbsentCardNo + ''''
			EXEC (@SQL)
			Fetch Next From @curHT2433 Into @EmployeeID, @AbsentCardNo
		End
		Close @curHT2433

		DROP TABLE ##HT03566

		Fetch Next From @curHT2408 Into @ShiftID
	End --- kết thúc lặp cursor @curHT2408

	Close @curHT2408
	Set @DateProcess = DateAdd(d,1,@DateProcess)  
End --- kết thúc while

DROP TABLE #HT2408

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON