IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2400]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2400]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--------- 	Created by Nguyen Thi Ngoc Minh, Date 01/04/2004
---------	Purpose: Tao du lieu ke thua so luong nhân viên
---------	Edit by: Dang Le Bao Quynh; Date: 09/10/2006
---------	Purpose: Them dieu kien ke thua tung to nhom va tung nhan vien
---------    Edit by: Dang Le Bao Quynh; Date 20/10/2007
---------    Purpose: Ke thua ho so luong tu ho so nhan su lay them nhan vien thu viec
---------    Edit by: Dang Le Bao Quynh,  Date 12/03/2008
---------    Purpose: Them tinh trang nhan vien dang lam viec khi ke thua tu ho so luong
---------	Modify on 31/07/2013 by Bao Anh: Bo sung cac he so tu C14 -> C25 (Hung Vuong)
---------	Modify on 27/08/2013 by Bao Anh: Khi kế thừa hồ sơ lương, bổ sung lấy cả nhân viên nghỉ việc nhưng tháng trước còn làm (Unicare)
---------   Modied on 04/11/2013 by Thanh Sơn: Lấy thêm 2 trường IsJobWage và IsPiecework
---------	Modify on 06/01/2014 by Bao Anh: Khi kế thừa hồ sơ lương, không lấy nhân viên nghỉ việc nữa (Unicare)
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2400]  @Mode as tinyint,
				@DivisionID as nvarchar(50),
				@DepartmentID as nvarchar(50),
				@TeamIDIn as nvarchar(50),
				@EmployeeIDIn as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@FromTranMonth as int,
				@FromTranYear as int,
				@CreateDate as datetime,
				@CreateUserID as nvarchar(50)
				
AS

	DECLARE	@TempYear as nvarchar(20),
			@TempMonth as nvarchar(20),
			@HT2400Cursor as CURSOR,
			@EmpFileID as nvarchar(50),
			@DivisionID1 as nvarchar(50),
			@EmployeeID as nvarchar(50),
			@DepartmentID1 as nvarchar(50),
			@TeamID as nvarchar(50),
			@SalaryCoefficient as decimal(28,8),
			@TimeCoefficient as decimal(28,8),
			@DutyCoefficient as decimal(28,8),
			@BaseSalary as decimal(28,8),
			@TaxObjectID as nvarchar(50),
			@InsuranceSalary as decimal(28,8),
			@Salary01 as decimal(28,8),
			@Salary02 as decimal(28,8),
			@Salary03 as decimal(28,8),
			@C01 as decimal(28,8),
			@C02 as decimal(28,8),
			@C03 as decimal(28,8),
			@C04 as decimal(28,8),
			@C05 as decimal(28,8),
			@C06 as decimal(28,8),
			@C07 as decimal(28,8),
			@C08 as decimal(28,8),
			@C09 as decimal(28,8),
			@C10 as decimal(28,8),
			@C11 as decimal(28,8),
			@C12 as decimal(28,8),
			@C13 as decimal(28,8),
			@C14 as decimal(28,8),
			@C15 as decimal(28,8),
			@C16 as decimal(28,8),
			@C17 as decimal(28,8),
			@C18 as decimal(28,8),
			@C19 as decimal(28,8),
			@C20 as decimal(28,8),
			@C21 as decimal(28,8),
			@C22 as decimal(28,8),
			@C23 as decimal(28,8),
			@C24 as decimal(28,8),
			@C25 as decimal(28,8),
			@WorkDate as datetime,
			@RecruitDate as datetime,
			@EmployeeStatus as  int,
			@IsOtherDayPerMonth as tinyint,
			@WorkTerm as decimal(28,8),
			@IsJobWage AS tinyint,
			@IsPiecework AS TINYINT,
			@HV1400Cursor as CURSOR
Set nocount on
SET @TempYear = cast(@TranYear as nvarchar(20))
SET @TempMonth = Case when len(Ltrim(Rtrim(str(@TranMonth))))= 1 then  '0' + Ltrim(Rtrim(str(@TranMonth)))
		else Ltrim(Rtrim(str(@TranMonth))) end

IF @Mode = 1	 --- 	ho so nhan su
  BEGIN

	SET @HV1400Cursor = CURSOR SCROLL KEYSET FOR
		SELECT EmployeeID, DivisionID , DepartmentID, case when isnull(TeamID,'') = '' then NULL else TeamID end as TeamID,
			BaseSalary, TaxObjectID,InsuranceSalary, Salary01, Salary02, Salary03, 
			SalaryCoefficient, TimeCoefficient, DutyCoefficient,
			C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11, C12, C13,
			C14, C15, C16, C17, C18, C19, C20, C21, C22, C23, C24, C25,
			WorkDate, Datediff(m,WorkDate,Getdate()) as WorkTerm, EmployeeStatus,  IsOtherDayPerMonth,RecruitDate,IsJobWage,IsPiecework
		FROM HV1400 
		WHERE 	DivisionID = @DivisionID and
				DepartmentID LIKE @DepartmentID and
				isnull(TeamID,'') Like @TeamIDIn and
				EmployeeID Like @EmployeeIDIn And
				(EmployeeStatus  = 1 or EmployeeStatus  = 2)

	OPEN @HV1400Cursor
	FETCH FIRST FROM @HV1400Cursor INTO  @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID,
		@BaseSalary,@TaxObjectID, @InsuranceSalary, @Salary01, @Salary02, @Salary03,  
		@SalaryCoefficient, @TimeCoefficient, @DutyCoefficient,  
		@C01, @C02, @C03, @C04, @C05, @C06, @C07, @C08, @C09, @C10, @C11, @C12, @C13,
		@C14, @C15, @C16, @C17, @C18, @C19, @C20, @C21, @C22, @C23, @C24, @C25,
		@WorkDate, @WorkTerm, @EmployeeStatus, @IsOtherDayPerMonth, @RecruitDate,@IsJobWage,@IsPiecework

--print "1";
	WHILE @@FETCH_STATUS = 0
	  BEGIN

		IF not Exists(SELECT EmployeeID FROM HT2400 WHERE EmployeeID = @EmployeeID AND DivisionID = @DivisionID1
							AND DepartmentID = @DepartmentID1 
							AND isnull(TeamID,'') = isnull(@TeamID,'') 
							and TranMonth = @TranMonth	
							AND TranYear = @TranYear)
		  BEGIN

			Exec AP0000 @DivisionID1, @EmpFileID  OUTPUT, 'HT2400', 'HS', @TempYear, @TempMonth, 15, 3, 0, ''
			INSERT INTO HT2400 (EmpFileID, EmployeeID, DivisionID, DepartmentID, TeamID,
					BaseSalary, TaxObjectID,InsuranceSalary, Salary01, Salary02, Salary03, 
					SalaryCoefficient, TimeCoefficient, DutyCoefficient,
					C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11, C12, C13,
					C14, C15, C16, C17, C18, C19, C20, C21, C22, C23, C24, C25,
					TranMonth, TranYear ,WorkTerm, EmployeeStatus, IsOtherDayPerMonth,
					CreateDate, CreateUserID,LastModifyDate,LastmodifyUserID,
					IsJobWage,IsPiecework )
				VALUES (@EmpFileID, @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID,
					@BaseSalary, @TaxObjectID, @InsuranceSalary, @Salary01, @Salary02, @Salary03, 
					@SalaryCoefficient, @TimeCoefficient, @DutyCoefficient,
					@C01, @C02, @C03, @C04, @C05, @C06, @C07, @C08, @C09, @C10, @C11, @C12, @C13,
					@C14, @C15, @C16, @C17, @C18, @C19, @C20, @C21, @C22, @C23, @C24, @C25,
					@TranMonth, @TranYear, @WorkTerm, @EmployeeStatus, @IsOtherDayPerMonth,
					@CreateDate,@CreateUserID,@CreateDate,@CreateUserID,
					@IsJobWage,@IsPiecework )

		  END
		FETCH NEXT FROM @HV1400Cursor INTO  @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID,
		@BaseSalary,@TaxObjectID, @InsuranceSalary, @Salary01, @Salary02, @Salary03,  
		@SalaryCoefficient, @TimeCoefficient, @DutyCoefficient,  
		@C01, @C02, @C03, @C04, @C05, @C06, @C07, @C08, @C09, @C10, @C11, @C12, @C13,
		@C14, @C15, @C16, @C17, @C18, @C19, @C20, @C21, @C22, @C23, @C24, @C25,  
		@WorkDate, @WorkTerm, @EmployeeStatus, @IsOtherDayPerMonth,@RecruitDate,@IsJobWage,@IsPiecework
  	  END
--print "2";
	CLOSE @HV1400Cursor
	DEALLOCATE @HV1400Cursor 	
	  
  END

ELSE  ---Tu ho so luong
--print "3";
BEGIN	

	SET @HT2400Cursor = CURSOR SCROLL KEYSET FOR
		SELECT	HT00.EmployeeID, HT00.DivisionID, HT00.DepartmentID,  case when isnull(HT00.TeamID,'') = '' then NULL else HT00.TeamID end,
				HT00.SalaryCoefficient, HT00.TimeCoefficient, HT00.DutyCoefficient, HT00.BaseSalary, 
				HT00.TaxObjectID, HT00.InsuranceSalary, HT00.Salary01, HT00.Salary02, HT00.Salary03, 
				HT00.C01, HT00.C02, HT00.C03, HT00.C04, HT00.C05, HT00.C06, HT00.C07, HT00.C08, HT00.C09, HT00.C10, HT00.C11, HT00.C12, HT00.C13, 
				HT00.C14, HT00.C15, HT00.C16, HT00.C17, HT00.C18, HT00.C19, HT00.C20, HT00.C21, HT00.C22, HT00.C23, HT00.C24, HT00.C25,
				HT01.WorkDate, Datediff(m, HT01.WorkDate,Getdate()) as WorkTerm, 
				HT01.EmployeeStatus, HT01.IsOtherDayPerMonth, HT01.RecruitDate, HT00.IsJobWage,HT00.IsPiecework
		FROM	HT2400 HT00  
		INNER JOIN	HV1400 HT01 on  HT00.DivisionID = HT01.DivisionID and
					HT00.EmployeeID = HT01.EmployeeID
		WHERE	HT00.DivisionID = @DivisionID and HT00.DepartmentID LIKE @DepartmentID And
				isnull(HT00.TeamID,'') Like @TeamIDIn and
				HT00.EmployeeID Like @EmployeeIDIn And (HT01.EmployeeStatus  = 1 or HT01.EmployeeStatus  = 2)
			---	((HT01.EmployeeStatus  = 1 or HT01.EmployeeStatus  = 2)
			---	Or ((HT01.EmployeeStatus  = 3 or HT01.EmployeeStatus  = 9)
			---	And ((Select top 1 1 From HT2402 Where DivisionID = @DivisionID And TranMonth = @FromTranMonth
			---			And TranYear = @FromTranYear And EmployeeID = HT00.EmployeeID And Isnull(AbsentAmount,0) > 0) = 1)))
				And	HT00.TranMonth = @FromTranMonth AND HT00.TranYear = @FromTranYear

	OPEN @HT2400Cursor
	FETCH NEXT FROM @HT2400Cursor INTO  @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID, 
			@SalaryCoefficient,	@TimeCoefficient, @DutyCoefficient, @BaseSalary, 
			@TaxObjectID,@InsuranceSalary, @Salary01, @Salary02, @Salary03, 
			@C01,@C02, @C03, @C04, @C05, @C06, @C07, @C08, @C09, @C10, @C11, @C12, @C13,
			@C14, @C15, @C16, @C17, @C18, @C19, @C20, @C21, @C22, @C23, @C24, @C25, @WorkDate, @WorkTerm, 
			@EmployeeStatus, @IsOtherDayPerMonth,@RecruitDate, @IsJobWage, @IsPiecework
--print "4";
	WHILE @@FETCH_STATUS = 0
	  BEGIN

		IF not Exists(SELECT EmployeeID FROM HT2400 WHERE EmployeeID = @EmployeeID AND DivisionID = @DivisionID1
							AND DepartmentID = @DepartmentID1 AND TranMonth = @TranMonth	
							AND TranYear = @TranYear and isnull(TeamID, '') =isnull( @TeamID,''))
		  BEGIN
			Exec AP0000  @DivisionID1, @EmpFileID  OUTPUT, 'HT2400', 'HS', @TempYear, @TempMonth, 15, 3, 0, ''
			
			INSERT INTO HT2400 (EmpFileID, EmployeeID, DivisionID, DepartmentID, TeamID,
					BaseSalary, TaxObjectID,InsuranceSalary, Salary01, Salary02, Salary03, 
					SalaryCoefficient, TimeCoefficient, DutyCoefficient,
					C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11, C12, C13,
					C14, C15, C16, C17, C18, C19, C20, C21, C22, C23, C24, C25,
					TranMonth, TranYear ,WorkTerm, EmployeeStatus, IsOtherDayPerMonth,
					CreateDate, CreateUserID,LastModifyDate,LastmodifyUserID,
					IsJobWage, IsPiecework)
				VALUES (@EmpFileID, @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID,
					@BaseSalary, @TaxObjectID, @InsuranceSalary, @Salary01, @Salary02, @Salary03, 
					@SalaryCoefficient, @TimeCoefficient, @DutyCoefficient,
					@C01, @C02, @C03, @C04, @C05, @C06, @C07, @C08, @C09, @C10, @C11, @C12, @C13,
					@C14, @C15, @C16, @C17, @C18, @C19, @C20, @C21, @C22, @C23, @C24, @C25,
					@TranMonth, @TranYear, @WorkTerm, @EmployeeStatus, @IsOtherDayPerMonth,
					@CreateDate,@CreateUserID,@CreateDate,@CreateUserID,
					@IsJobWage, @IsPiecework )
			
		  END

	FETCH NEXT FROM @HT2400Cursor INTO  @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID, 
			@SalaryCoefficient,	@TimeCoefficient, @DutyCoefficient, @BaseSalary, 
			@TaxObjectID,@InsuranceSalary, @Salary01, @Salary02, @Salary03, 
			@C01,@C02, @C03, @C04, @C05, @C06, @C07, @C08, @C09, @C10, @C11, @C12,  @C13,
			@C14, @C15, @C16, @C17, @C18, @C19, @C20, @C21, @C22, @C23, @C24, @C25, @WorkDate, @WorkTerm, 
			@EmployeeStatus, @IsOtherDayPerMonth,@RecruitDate,@IsJobWage, @IsPiecework
 	 END

	CLOSE @HT2400Cursor
	DEALLOCATE @HT2400Cursor 	
  END
Set nocount off
--print "5";

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON