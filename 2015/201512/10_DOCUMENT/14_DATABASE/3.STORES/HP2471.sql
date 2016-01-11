/****** Object:  StoredProcedure [dbo].[HP2471]    Script Date: 11/18/2011 13:18:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2471]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2471]
GO
/****** Object:  StoredProcedure [dbo].[HP2471]    Script Date: 11/18/2011 13:18:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
--------- 	Created date : August 16 2005,  Pham Thi Phuong Loan
---------	Purpose: Luu dieu chuyen tam thoi
---------	Edit by: Dang Le Bao Quynh; Date: 09/10/2006
---------	Purpose: Xoa thong tin luong cu
---------	Modify on 31/07/2013 by Bao Anh: Bo sung cac he so C14 -> C25 (Hung Vuong)

create PROCEDURE [dbo].[HP2471]  @DivisionID as nvarchar(50), @FromDepartmentID as nvarchar(50), @FromTeamID as nvarchar(50),
				@EmployeeID as nvarchar(50),  @TaxObjectID as nvarchar(50), @ToDepartmentID as nvarchar(50),
				@ToTeamID as nvarchar(50), @CBaseSalary money, @CInsuranceSalary money,
				@CSalary01 money, @CSalary02 money, @CSalary03 money,
				@SalaryCo money, @TimeCo money, @DutyCo money,
				@CC01 money,@CC02 money, @CC03 money, @CC04 money, @CC05 money, @CC06 money, @CC07 money, @CC08 money, @CC09 money, @CC10 money,
				@CC11 money, @CC12 money, @CC13 money, @CC14 money, @CC15 money, @CC16 money, @CC17 money, @CC18 money, @CC19 money, @CC20 money,
				@CC21 money, @CC22 money, @CC23 money, @CC24 money, @CC25 money,
				@TranMonth as int, @TranYear as int,
				@CreateUserID nvarchar(50),
				@FromDateTranfer datetime,
				@ToDateTranfer datetime				

AS
DECLARE	@TempYear as nvarchar(50),
		@TempMonth as nvarchar(50),
		@Appointed as int,
		@EmpFileID as nvarchar(50)
			
				
SET @TempYear = Right(Ltrim(Rtrim(str(@TranYear))),2)
SET @TempMonth = Case when len(Ltrim(Rtrim(str(@TranMonth))))= 1 then  '0' + Ltrim(Rtrim(str(@TranMonth)))
		else Ltrim(Rtrim(str(@TranMonth))) end

Select @Appointed= max(IsNull(Appointed,0)) From HT2400 Where DivisionID=@DivisionID  and EmployeeID=@EmployeeID
Set @Appointed = @Appointed+1
			
SET @TempYear = Right(Ltrim(Rtrim(str(@TranYear))),2)
SET @TempMonth = Case when len(Ltrim(Rtrim(str(@TranMonth))))= 1 then  '0' + Ltrim(Rtrim(str(@TranMonth)))
		else Ltrim(Rtrim(str(@TranMonth))) end

		 Exec AP0000  @DivisionID, @EmpFileID  OUTPUT, 'HT2400', 'HS', @TempYear, @TempMonth, 15, 3, 0, ''

			INSERT INTO HT2400 (EmpFileID, EmployeeID, DivisionID, DepartmentID,  TranMonth, TranYear, TeamID, 
					SalaryCoefficient, TimeCoefficient, DutyCoefficient, BaseSalary, InsuranceSalary, Salary01, Salary02,
					Salary03, C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11, C12, C13,
					C14, C15, C16, C17, C18, C19, C20, C21, C22, C23, C24, C25,
					TaxObjectID, CreateDate, CreateUserID, Appointed, FromDateTranfer, ToDateTranfer)
					VALUES (@EmpFileID, @EmployeeID, @DivisionID, @ToDepartmentID,  @TranMonth, @TranYear, ISNull(@ToTeamID,''),
						@SalaryCo, @TimeCo, @DutyCo, @CBaseSalary, @CInsuranceSalary, 
						@CSalary01, @CSalary02, @CSalary03, @CC01, @CC02, @CC03, @CC04, @CC05, @CC06, @CC07, @CC08,
						@CC09, @CC10,  @CC11,  @CC12,  @CC13, @CC14, @CC15, @CC16, @CC17, @CC18, @CC19, @CC20,
						@CC21, @CC22, @CC23, @CC24, @CC25,
						@TaxObjectID,getdate() ,@CreateUserID, @Appointed, @FromDateTranfer, @ToDateTranfer)

			UPDATE HT2401 Set DepartmentID = @ToDepartmentID , TeamID = ISNull(@ToTeamID,'')
			WHERE 	EmployeeID = @EmployeeID And
				DivisionID = @DivisionID And
				TranMonth = @TranMonth And
				TranYear = @TranYear

			UPDATE HT2402 Set DepartmentID = @ToDepartmentID , TeamID = ISNull(@ToTeamID,'')
			WHERE 	EmployeeID = @EmployeeID And
				DivisionID = @DivisionID And
				TranMonth = @TranMonth And
				TranYear = @TranYear

			UPDATE HT2460 Set DepartmentID = @ToDepartmentID , TeamID = ISNull(@ToTeamID,'')
			WHERE 	EmployeeID = @EmployeeID And
				DivisionID = @DivisionID And
				TranMonth = @TranMonth And
				TranYear = @TranYear

			UPDATE HT2461 Set DepartmentID = @ToDepartmentID , TeamID = ISNull(@ToTeamID,'')
			WHERE 	EmployeeID = @EmployeeID And
				DivisionID = @DivisionID And
				TranMonth = @TranMonth And
				TranYear = @TranYear

			UPDATE HT3400 Set DepartmentID = @ToDepartmentID , TeamID = ISNull(@ToTeamID,'')
			WHERE 	EmployeeID = @EmployeeID And
				DivisionID = @DivisionID And
				TranMonth = @TranMonth And
				TranYear = @TranYear

			UPDATE HT2500 Set DepartmentID = @ToDepartmentID, TeamID = ISNull(@ToTeamID,'')
			WHERE 	EmployeeID = @EmployeeID And
				DivisionID = @DivisionID And
				TranMonth = @TranMonth And
				TranYear = @TranYear

			Delete From HT2400 Where EmployeeID= @EmployeeID
				AND DivisionID = @DivisionID
				AND DepartmentID=@FromDepartmentID 
				AND IsNull(TeamID,'') = IsNull(@FromTeamID,'')
				AND TranMonth = @TranMonth	
				AND TranYear = @TranYear


GO


