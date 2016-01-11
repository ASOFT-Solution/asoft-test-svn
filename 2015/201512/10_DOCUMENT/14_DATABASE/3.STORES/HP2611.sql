IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2611]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2611]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created by: Bao Anh, date: 15/01/2013
----purpose: Luu cham cong theo cong trinh
	
CREATE PROCEDURE [dbo].[HP2611] @DivisionID  NVARCHAR(50),
				@ProjectID  NVARCHAR(50),
				@PeriodID  NVARCHAR(50) = Null,
				@DepartmentID  NVARCHAR(50),
				@TeamID  NVARCHAR(50),
				@EmployeeID  NVARCHAR(50),
				@TranMonth int,
				@TranYear int,
				@AbsentTypeID  NVARCHAR(50),
				@AbsentAmount decimal (28, 8),
				@CreateUserID  NVARCHAR(50),				
				@BeginDate Datetime = Null,
				@EndDate Datetime = Null
AS
Declare @sSQL nvarchar(4000),
	@cur cursor,
	@DepartmentID1  NVARCHAR(50),
	@TeamID1  NVARCHAR(50),	
	@EmployeeID1  NVARCHAR(50)
	
Set @cur = Cursor scroll keyset for
	Select  DepartmentID, TeamID, EmployeeID
		 From HT2400
		Where DivisionID  = @DivisionID and
			DepartmentID like @DepartmentID and
			isnull(TeamID, '')  like isnull(@TeamID, '') and
			EmployeeID like @EmployeeID and
			TranMonth = @TranMonth and
			TranYear = @TranYear 
		 	
Open @cur
Fetch next from @cur into @DepartmentID1, @TeamID1, @EmployeeID1
While @@fetch_status = 0
Begin 
	If @PeriodID is Null
		Begin

			if not exists(Select Top 1 1 From HT2432 Where DivisionID = @DivisionID and
								DepartmentID = @DepartmentID1 and
								EmployeeID = @EmployeeID1 and
								TranMonth = @TranMonth and
								TranYear = @TranYear and
								AbsentTypeID = @AbsentTypeID and
								ProjectID = @ProjectID)			
			
				insert HT2432(DivisionID, ProjectID, DepartmentID, TeamID, EmployeeID, TranMonth, TranYear, AbsentTypeID, AbsentAmount,
						CreateUserID, CreateDate, LastModifyUserID, LastModifydate ) 
					values  (@DivisionID, @ProjectID, @DepartmentID1, @TeamID1, @EmployeeID1, @TranMonth, @TranYear,
						@AbsentTypeID, @AbsentAmount, @CreateUserID, getdate(),  @CreateUserID, getdate()) 
			
			else
				Update HT2432 Set AbsentAmount = @AbsentAmount, LastModifyDate = getdate(), LastModifyUserID = @CreateUserID
						Where DivisionID = @DivisionID and
							ProjectID = @ProjectID and
							DepartmentID = @DepartmentID1 and
							EmployeeID = @EmployeeID1 and
							TranMonth = @TranMonth and
							TranYear = @TranYear and
							AbsentTypeID = @AbsentTypeID 
		End
	Else
		Begin

			if not exists(Select Top 1 1 From HT2432 Where DivisionID = @DivisionID and
								DepartmentID = @DepartmentID1 and
								EmployeeID = @EmployeeID1 and
								TranMonth = @TranMonth and
								TranYear = @TranYear and
								AbsentTypeID = @AbsentTypeID and 
								PeriodID = @PeriodID and
								ProjectID = @ProjectID)			
			
				insert HT2432(DivisionID, ProjectID, DepartmentID, TeamID, EmployeeID, TranMonth, TranYear, AbsentTypeID, AbsentAmount,
						CreateUserID, CreateDate, LastModifyUserID, LastModifydate, PeriodID ) 
					values  (@DivisionID, @ProjectID, @DepartmentID1, @TeamID1, @EmployeeID1, @TranMonth, @TranYear,
						@AbsentTypeID, @AbsentAmount, @CreateUserID, getdate(),  @CreateUserID, getdate(), @PeriodID) 
			
			else
				Update HT2432 Set AbsentAmount = @AbsentAmount, LastModifyDate = getdate(), LastModifyUserID = @CreateUserID
						Where DivisionID = @DivisionID and
							ProjectID = @ProjectID and
							DepartmentID = @DepartmentID1 and
							EmployeeID = @EmployeeID1 and
							TranMonth = @TranMonth and
							TranYear = @TranYear and
							AbsentTypeID = @AbsentTypeID and
							PeriodID = @PeriodID 
		End			
	Fetch next from @cur into @DepartmentID1, @TeamID1, @EmployeeID1
End
Close @cur
--Cap nhat bang HT7777
	If @PeriodID is not null
	Begin
		If not Exists (Select Top 1 1 From HT7777 Where DivisionID = @DivisionID And TranYear = @TranYear and
								TranMonth = @TranMonth and
								PeriodID = @PeriodID)
			Insert Into HT7777(DivisionID, TranYear,TranMonth,PeriodID,BeginDate,EndDate)
				Values (@DivisionID, @TranYear,@TranMonth,@PeriodID,@BeginDate,@EndDate)
		Else
			Update HT7777 Set BeginDate=@BeginDate, EndDate=@EndDate
					Where 	TranYear = @TranYear and
						TranMonth = @TranMonth and
						PeriodID = @PeriodID and
						DivisionID = @DivisionID	
	End
--Cap nhat bang HT6666
	If @PeriodID is not null
	Begin
		Update HT6666 Set IsDefault=0 Where PeriodID <> @PeriodID and DivisionID = @DivisionID
		Update HT6666 Set IsDefault=1 Where PeriodID = @PeriodID and DivisionID = @DivisionID	
	End
