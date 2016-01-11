IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2402]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2402]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--------- 	Created by Nguyen Thi Ngoc Minh, Date 04/05/2004
---------	Purpose: Ket chuyen cham cong ngay sang cham cong thang
---------	edited by: Vo Thanh Huong, date: 01/09/2004
---------    Edit by: Dang Le Bao Quynh; Date 13/09/2006
---------	Purpose: Tinh luong nhieu ky	   
---- Modified on 20/11/2013 by Le Thi Thu Hien : Bo sung them HT1033 (Ket chuyen cham cong ngay sang nhieu thang)
---- Modified on 11/12/2013 by Bao Anh : Sua loi over flow do cast(@TimeConvert AS nvarchar(10))
---- Modified on 14/12/2015 by Bảo Anh : Cộng thêm số giờ phụ nữ cho nhân viên nữ (customize Meiko)
-- <Example>
---- 

CREATE PROCEDURE [dbo].[HP2402] 
				@DivisionID AS nvarchar(50),
				@DepartmentID AS nvarchar(50),
				@TeamID AS nvarchar(50),
				@EmployeeID AS nvarchar(50),
				@AbsentTypeID AS nvarchar(50),
				@TranMonth AS int,
				@TranYear AS int,
				@CreateUserID AS nvarchar(50),
				@PeriodID nvarchar(50) = Null,
				@BeginDate Datetime = Null,
				@EndDate Datetime = Null
AS

DECLARE	@sSQL1 AS nvarchar(4000),
		@sSQL2 AS nvarchar(4000),
		@cursor AS cursor,
		@TimeConvert AS decimal(28,8),	
		@AbsentAmount AS decimal(28,8),
		@ChildUnitID AS nvarchar(50),
		@ParentUnitID AS nvarchar(50),
		@ParentID AS nvarchar(50),
		@ConvertAmount AS decimal(28,8),
		@ParentAmount AS decimal(28,8),		
		@TeamID1 nvarchar(50),
		@DepartmentID1 nvarchar(50),
		@CustomerIndex tinyint

SET @sSQL1 = ''
SET	@sSQL2 = ''

IF NOT EXISTS (SELECT ISNULL(TimeConvert,8) FROM HT0000 WHERE DivisionID = @DivisionID)									
	Set @TimeConvert = 8
Else
	Set @TimeConvert = (SELECT ISNULL(TimeConvert,8) FROM HT0000 WHERE DivisionID = @DivisionID)
	
If @PeriodID IS NULL								
	Set @sSQL1 = '
		SELECT T01.DivisionID, T01.DepartmentID, ISNULL(T01.TeamID,'''') AS TeamID, T01.EmployeeID, T01.TranMonth, T01.TranYear, T01.AbsentTypeID, 
				T13.ConvertUnit, T13.UnitID AS ChildUnitID,
				T13.ParentID, T23.UnitID AS ParentUnitID,
				CASE WHEN (T13.UnitID = T23.UnitID) THEN SUM(ISNULL(T01.AbsentAmount,0) * ISNULL(T23.ConvertUnit,0))
				when T13.UnitID = ''D'' and T23.UnitID = ''H''  then 
				sum(isnull(T01.AbsentAmount,0) * isnull(T23.ConvertUnit,0) * '+ cast(@TimeConvert AS nvarchar(11)) + ')		
			else sum(isnull(T01.AbsentAmount,0) * isnull(T23.ConvertUnit,0) / '+ cast(@TimeConvert AS nvarchar(11)) + ') end AS ParentAmount 
		FROM HT2401 AS T01 
		INNER JOIN (SELECT  HT1013.AbsentTypeID, HT1013.AbsentName, 
							ISNULL (HT1033.ParentID,HT1013.ParentID) AS ParentID, 
							HT1013.UnitID, HT1013.DivisionID, HT1013.ConvertUnit
					FROM	HT1013 HT1013
					LEFT JOIN HT1033 HT1033
							ON HT1013.DivisionID = HT1033.DivisionID 
							AND HT1013.AbsentTypeID = HT1033.AbsentTypeID
					) AS T13 on T01.AbsentTypeID = T13.AbsentTypeID and T01.DivisionID = T13.DivisionID
		INNER JOIN HT1013 AS T23 
				on T23.AbsentTypeID = T13.ParentID 
				and T23.DivisionID = T13.DivisionID
		Where T01.TranMonth = ' + cast(@TranMonth AS nvarchar(2)) + ' and
			T01.TranYear = ' + cast(@TranYear AS nvarchar(4)) + ' and
			T01.DivisionID like ''' + @DivisionID + ''' and
			T01.DepartmentID like ''' + @DepartmentID + ''' and
			isnull(T01.TeamID,'''') like isnull(''' + @TeamID + ''', ''' + ''') and
			T01.EmployeeID like ''' + @EmployeeID + ''' and	
			T13.ParentID like ''' + @AbsentTypeID + ''' 
		Group by T01.DivisionID, T01.DepartmentID, ISNULL(T01.TeamID,''''), T01.EmployeeID, T01.TranMonth, T01.TranYear, T01.AbsentTypeID, 
			T13.ConvertUnit, T13.UnitID, T13.ParentID, T23.UnitID'
Else
	Set @sSQL1 = '
		Select T01.DivisionID, T01.DepartmentID, ISNULL(T01.TeamID,'''') AS TeamID, T01.EmployeeID, T01.TranMonth, T01.TranYear, T01.AbsentTypeID, 
			T13.ConvertUnit, T13.UnitID AS ChildUnitID,
			T13.ParentID, T23.UnitID AS ParentUnitID,
			case when (T13.UnitID = T23.UnitID)  then sum(isnull(T01.AbsentAmount,0) * isnull(T23.ConvertUnit,0))
			when T13.UnitID = ''D'' and T23.UnitID = ''H''  then 
				sum(isnull(T01.AbsentAmount,0) * isnull(T23.ConvertUnit,0) * '+ cast(@TimeConvert AS nvarchar(11)) + ')		
				else sum(isnull(T01.AbsentAmount,0) * isnull(T23.ConvertUnit,0) / '+ cast(@TimeConvert AS nvarchar(11)) + ') end AS ParentAmount 
		 FROM HT2401 AS T01 
		 INNER JOIN (SELECT  HT1013.AbsentTypeID, HT1013.AbsentName, 
							ISNULL (HT1033.ParentID,HT1013.ParentID) AS ParentID, 
							HT1013.UnitID, HT1013.DivisionID, HT1013.ConvertUnit
					FROM	HT1013 HT1013
					LEFT JOIN HT1033 HT1033
							ON HT1013.DivisionID = HT1033.DivisionID 
							AND HT1013.AbsentTypeID = HT1033.AbsentTypeID
					) AS T13 on T01.AbsentTypeID = T13.AbsentTypeID and T01.DivisionID = T13.DivisionID
		INNER JOIN HT1013 AS T23 
				on T23.AbsentTypeID = T13.ParentID 
				and T23.DivisionID = T13.DivisionID
		Where T01.TranMonth = ' + cast(@TranMonth AS nvarchar(2)) + ' and
			T01.TranYear = ' + cast(@TranYear AS nvarchar(4)) + ' and
			T01.DivisionID like ''' + @DivisionID + ''' and
			T01.DepartmentID like ''' + @DepartmentID + ''' and
			isnull(T01.TeamID,'''') like isnull(''' + @TeamID + ''', ''' + ''') and
			T01.EmployeeID like ''' + @EmployeeID + ''' and	
			T13.ParentID like ''' + @AbsentTypeID + ''' and 
			T01.AbsentDate between ''' + ltrim(month(@BeginDate)) + '/' + ltrim(Day(@BeginDate)) + '/' + ltrim(Year(@BeginDate)) + ''' And ''' 
			+ ltrim(month(@EndDate)) + '/' + ltrim(Day(@EndDate)) + '/' + ltrim(Year(@EndDate)) + ''' 				
		Group by T01.DivisionID, T01.DepartmentID, ISNULL(T01.TeamID,'''') , T01.EmployeeID, T01.TranMonth, T01.TranYear, T01.AbsentTypeID, 
			T13.ConvertUnit, T13.UnitID, T13.ParentID, T23.UnitID'
	
--print @sSQL1;	
IF NOT EXISTS (SELECT 1 FROM  SYSOBJECTS WHERE XTYPE ='V' AND NAME ='HV2603')
	EXEC(' CREATE VIEW HV2603  ---tao boi HP2402
			as '+@sSQL1)
ELSE
	EXEC(' ALTER VIEW HV2603  ---tao boi HP2402
			as '+@sSQL1)

Set @sSQL2 = '
		SELECT	DivisionID, DepartmentID, TeamID, EmployeeID, 
				TranMonth, TranYear, ParentID AS AbsentTypeID,
				Sum(ParentAmount) AS AbsentAmount
		FROM	HV2603 
		WHERE	DivisionID = '''+@DivisionID+'''
		GROUP BY DivisionID, DepartmentID, TeamID, 
				EmployeeID, TranMonth, TranYear, ParentID'

IF NOT EXISTS (SELECT 1 FROM  SYSOBJECTS WHERE XTYPE ='V' AND NAME ='HV2604')
	EXEC(' CREATE VIEW HV2604 AS '+@sSQL2) ---tao boi HP2402
ELSE
	EXEC(' ALTER VIEW HV2604 AS '+@sSQL2)  ---tao boi HP2402

SET @cursor = Cursor scroll keyset for
		Select	DivisionID, DepartmentID, TeamID, 
				EmployeeID, TranMonth, TranYear, 
				AbsentTypeID, AbsentAmount
		From	HV2604 
		where	DivisionID = @DivisionID

	Open @cursor
	Fetch next from @cursor into @DivisionID, @DepartmentID1, @TeamID1, @EmployeeID,
					@TranMonth, @TranYear, @AbsentTypeID, @AbsentAmount

	WHILE @@FETCH_STATUS = 0

	  Begin
		If @PeriodID Is Null
			Begin
				If not Exists(Select Top 1 1 from HT2402 where DivisionID = @DivisionID 
											and EmployeeID = @EmployeeID 							
											and TranMonth = @TranMonth 
											and TranYear = @TranYear
											and AbsentTypeID = @AbsentTypeID and 
											DepartmentID = @DepartmentID1 and 
											isnull(TeamID,'')  = isnull(@TeamID1,'')) 
											
					Insert into HT2402 ( EmployeeID, TranMonth, TranYear, DivisionID, DepartmentID, TeamID, 
							AbsentTypeID, AbsentAmount, CreateDate, LastModifyDate, CreateUserID, LastModifyUserID, PeriodID)
						Values (@EmployeeID, @TranMonth, @TranYear, @DivisionID,@DepartmentID1, @TeamID1, 
							@AbsentTypeID, @AbsentAmount, getdate(),
							getdate(), @CreateUserID, @CreateUserID, @PeriodID)
				Else
					Update HT2402 set AbsentAmount = @AbsentAmount 
							where  DivisionID = @DivisionID
											and EmployeeID = @EmployeeID 							
											and TranMonth = @TranMonth 
											and TranYear = @TranYear
											and AbsentTypeID = @AbsentTypeID and 
											DepartmentID = @DepartmentID1 and 
											isnull(TeamID,'')  = isnull(@TeamID1,'')
			End
		Else
			Begin
				If not Exists(Select Top 1 1 from HT2402 where DivisionID = @DivisionID
										    and EmployeeID = @EmployeeID 							
											and TranMonth = @TranMonth 
											and TranYear = @TranYear
											and AbsentTypeID = @AbsentTypeID and 
											DepartmentID = @DepartmentID1 and 
											isnull(TeamID,'')  = isnull(@TeamID1,'') and 
											PeriodID = @PeriodID) 
											
					Insert into HT2402 ( EmployeeID, TranMonth, TranYear, DivisionID, DepartmentID, TeamID, 
							AbsentTypeID, AbsentAmount, CreateDate, LastModifyDate, CreateUserID, LastModifyUserID, PeriodID)
						Values (@EmployeeID, @TranMonth, @TranYear, @DivisionID,@DepartmentID1, @TeamID1, 
							@AbsentTypeID, @AbsentAmount, getdate(),
							getdate(), @CreateUserID, @CreateUserID, @PeriodID)
				Else
					Update HT2402 set AbsentAmount = @AbsentAmount 
							where DivisionID = @DivisionID 
											and EmployeeID = @EmployeeID 							
											and TranMonth = @TranMonth 
											and TranYear = @TranYear
											and AbsentTypeID = @AbsentTypeID and 
											DepartmentID = @DepartmentID1 and 
											isnull(TeamID,'')  = isnull(@TeamID1,'') and 
											PeriodID = @PeriodID
			End
		Fetch next from @cursor into @DivisionID, @DepartmentID1, @TeamID1, @EmployeeID,
					@TranMonth, @TranYear, @AbsentTypeID, @AbsentAmount
  	  End
	Close @cursor
	Deallocate @cursor

--Cap nhat bang HT7777
	If @PeriodID is not null
	Begin
		If not Exists (Select Top 1 1 From HT7777 Where DivisionID = @DivisionID 	
								and TranYear = @TranYear and
								TranMonth = @TranMonth and
								PeriodID = @PeriodID)
			Insert Into HT7777(DivisionID, TranYear,TranMonth,PeriodID,BeginDate,EndDate)
				Values (@DivisionID , @TranYear,@TranMonth,@PeriodID,@BeginDate,@EndDate)
		Else
			Update HT7777 Set BeginDate=@BeginDate, EndDate=@EndDate
					Where DivisionID = @DivisionID
						and TranYear = @TranYear and
						TranMonth = @TranMonth and
						PeriodID = @PeriodID	
	End
--Cap nhat bang HT6666
	If @PeriodID is not null
	Begin
		Update HT6666 Set IsDefault=0 Where PeriodID <> @PeriodID and DivisionID = @DivisionID
		Update HT6666 Set IsDefault=1 Where PeriodID = @PeriodID and DivisionID = @DivisionID
	End

--- Customize Meiko: cộng số giờ OT phụ nữ đối với nhân viên nữ
SELECT @CustomerIndex = CustomerName From CustomerIndex
IF @CustomerIndex = 50
BEGIN
	Declare @FEAbsentTypeID nvarchar(50),
			@UnitID NVARCHAR(50),
			@ConvertUnit decimal(28,8),
			@Amount decimal(28,8)
			
	SELECT @FEAbsentTypeID = FEAbsentTypeID FROM HT0000 WHERE DivisionID = @DivisionID
	SELECT @UnitID = UnitID, @ConvertUnit = Isnull(ConvertUnit,1) FROM HT1013
	WHERE DivisionID = @DivisionID AND AbsentTypeID = @FEAbsentTypeID

	SELECT @Amount = @ConvertUnit*(case when @UnitID = 'H' then 2 else 2/8 end)

	DELETE HT2402 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear
		AND DepartmentID like @DepartmentID AND Isnull(TeamID,'') like @TeamID
		AND EmployeeID like @EmployeeID AND AbsentTypeID = @FEAbsentTypeID AND Isnull(PeriodID,'') = @PeriodID
												
	Insert into HT2402 (EmployeeID, TranMonth, TranYear, DivisionID, DepartmentID, TeamID, 
							AbsentTypeID, AbsentAmount, CreateDate, LastModifyDate, CreateUserID, LastModifyUserID, PeriodID)
	SELECT	HV26.EmployeeID, @TranMonth, @TranYear, @DivisionID, HT1400.DepartmentID, HT1400.TeamID,
			@FEAbsentTypeID, @Amount, getdate(),getdate(), @CreateUserID, @CreateUserID, @PeriodID
	FROM HV2604 HV26
	INNER JOIN HT1400 On HV26.DivisionID = HT1400.DivisionID and HV26.EmployeeID = HT1400.EmployeeID and HT1400.IsMale = 0				
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON