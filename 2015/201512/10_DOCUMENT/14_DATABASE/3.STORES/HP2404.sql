

/****** Object:  StoredProcedure [dbo].[HP2404]    Script Date: 11/26/2011 11:23:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2404]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2404]
GO



/****** Object:  StoredProcedure [dbo].[HP2404]    Script Date: 11/26/2011 11:23:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



--------- 	Created by Vo Thanh Huong, Date 10/08/2004
---------	Purpose: Them du lieu cham cong thang cho nhan vien
---------    Edit by: Dang Le Bao Quynh; Date 13/09/2006
---------	Purpose: Tinh luong nhieu ky	

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2404] 	@DivisionID as nvarchar(50),
				@DepartmentID as nvarchar(50),
				@TeamID as nvarchar(50),
				@EmployeeID as nvarchar(50),
				@AbsentTypeID as nvarchar(50),
				@AbsentAmount as decimal(28,8),
				@TranMonth as int, 
				@TranYear as int,
				@CreateUserID as nvarchar(50),
				@PeriodID nvarchar(50) = Null,
				@BeginDate Datetime = Null,
				@EndDate Datetime = Null

AS
DECLARE 	@sSQL as nvarchar(4000),
			@HV2405Cursor as cursor,
			@TeamID1 as nvarchar(50) ,
			@DepartmentID1 nvarchar(50)

Set @sSQL = '
Select HT2400.DivisionID, HT2400.DepartmentID, HT2400.TeamID ,T01.TeamName , HT2400.EmployeeID
From HT2400
Left Join HT1101 As T01 
On HT2400.TeamID = T01.TeamID 
and HT2400.DepartmentID =T01.DepartmentID and  HT2400.DivisionID = T01.DivisionID
Where HT2400.DivisionID = ''' + @DivisionID + ''' and
	HT2400.DepartmentID like ''' + @DepartmentID + ''' and
	isnull(HT2400.TeamID,'''') like Isnull(''' + @TeamID+ ''', ''' + ''') and
	HT2400.EmployeeID like ''' + @EmployeeID + ''' and
	TranMonth = ' + STR(@TranMonth) + ' and TranYear = ' + STR(@TranYear)

If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='HV2405')
	Exec(' Create view HV2405 ---tao boi HP2404
		as '+@sSQL)
Else
	Exec(' Alter view HV2405 ---tao boi HP2404
		as '+@sSQL)


SET @HV2405Cursor = CURSOR SCROLL KEYSET FOR
		SELECT DivisionID, DepartmentID, TeamID ,EmployeeID
		FROM HV2405

	OPEN @HV2405Cursor
	FETCH NEXT FROM @HV2405Cursor INTO @DivisionID, @DepartmentID1, @TeamID1, @EmployeeID

	WHILE @@FETCH_STATUS = 0
	  BEGIN	
		IF @PeriodID Is Null
			BEGIN	
				IF not Exists(SELECT EmployeeID FROM HT2402 WHERE EmployeeID = @EmployeeID And DivisionID = @DivisionID
					AND TranMonth = @TranMonth and TranYear = @TranYear and  AbsentTypeID = @AbsentTypeID)

					Insert into HT2402 ( TranMonth, TranYear, 
						EmployeeID, DivisionID, DepartmentID, TeamID, AbsentTypeID, AbsentAmount, 
						CreateDate, LastModifyDate, CreateUserID, LastModifyUserID)
					Values (@TranMonth, @TranYear, 
						@EmployeeID, @DivisionID, @DepartmentID1, @TeamID1, @AbsentTypeID, @AbsentAmount, 
						 getdate(), getdate(), @CreateUserID, @CreateUserID)
			END
		Else
			BEGIN
				IF not Exists(SELECT EmployeeID FROM HT2402 WHERE EmployeeID = @EmployeeID And DivisionID = @DivisionID 
					AND TranMonth = @TranMonth and TranYear = @TranYear and  AbsentTypeID = @AbsentTypeID And PeriodID=@PeriodID)

					Insert into HT2402 ( TranMonth, TranYear, 
						EmployeeID, DivisionID, DepartmentID, TeamID, AbsentTypeID, AbsentAmount, 
						CreateDate, LastModifyDate, CreateUserID, LastModifyUserID,PeriodID)
					Values (@TranMonth, @TranYear, 
						@EmployeeID, @DivisionID, @DepartmentID1, @TeamID1, @AbsentTypeID, @AbsentAmount, 
						 getdate(), getdate(), @CreateUserID, @CreateUserID,@PeriodID)
			END		
	
		FETCH NEXT FROM @HV2405Cursor INTO @DivisionID, @DepartmentID1, @TeamID1, @EmployeeID
  	  END
	CLOSE @HV2405Cursor
	DEALLOCATE @HV2405Cursor
--Cap nhat bang HT7777
	If @PeriodID is not null
	Begin
		If not Exists (Select Top 1 1 From HT7777 Where TranYear = @TranYear And DivisionID = @DivisionID 
								and TranMonth = @TranMonth and
								PeriodID = @PeriodID)
			Insert Into HT7777(DivisionID,TranYear,TranMonth,PeriodID,BeginDate,EndDate)
				Values (@DivisionID,@TranYear,@TranMonth,@PeriodID,@BeginDate,@EndDate)
		Else
			Update HT7777 Set BeginDate=@BeginDate, EndDate=@EndDate
					Where 	TranYear = @TranYear and
						TranMonth = @TranMonth and
						PeriodID = @PeriodID and
						DivisionID =@DivisionID	
	End
--Cap nhat bang HT6666
	If @PeriodID is not null
	Begin
		Update HT6666 Set IsDefault=0 Where PeriodID <> @PeriodID and DivisionID =@DivisionID
		Update HT6666 Set IsDefault=1 Where PeriodID = @PeriodID and DivisionID =@DivisionID	
	End

GO


