IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2460]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2460]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--------Created by Vo Thanh Huong
--------Created Date 29/06/2004
--------Purpose: Tao du lieu ke thua cho ho so bao hiem
--------Edit by: Dang Le Bao Quynh, Date: 28/08/2006
--------Purpose: Chuyen truong so BHYT sang truong so KCB	
--------Edit by: Dang Le Bao Quynh, Date: 30/08/2008
--------Edit by: Huynh Trung Dung, Date: 09/06/2010 (Rem 3 dong 139-141:Muc dich cho phep ke thua HS_BHXH tu HS_Luong ky hien tai )
--------Purpose: Them ke thua benh vien KCB	
--------Modify on 26/08/2013 by Bao Anh: Gan alias cho HFromDate, HToDate
--------Modify on 27/08/2013 by Bao Anh: Chỉ kế thừa từ hồ sơ nhân sự các nhân viên có lương bảo hiểm (Unicare)
--------Modified on 15/11/2013 by Thanh Sơn: bổ sung cách tính lương BHXH của CSG ( CustomerName = 19)
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2460]  @Mode as tinyint, ---1:ho so nhan su, 2- ho so bao hiem, 3-ho so luong
				@DivisionID as nvarchar(50),
				@DepartmentID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@FromTranMonth as int,
				@FromTranYear as int,
				@CreateUserID as nvarchar(50)
AS

DECLARE	@Date as Datetime,
			@TempYear as nvarchar(50),
			@TempMonth as nvarchar(50),
			@cur_HT2460 as cursor,
			@InsurFileID as nvarchar(50),
			@DivisionID1 as nvarchar(50),
			@EmployeeID as nvarchar(50),
			@DepartmentID1 as nvarchar(50),
			@TeamID as nvarchar(50),
			@HospitalID as nvarchar(50),
			@BaseSalary as decimal(28,8),
			@InsuranceSalary as decimal(28,8),
			@Salary01 as decimal(28,8),
			@Salary02 as decimal(28,8),
			@Salary03 as decimal(28,8),	
			@SNo as nvarchar(50),
			@HNo as nvarchar(50),
			@CNo as nvarchar(50),
			@SBeginDate as datetime,			
			@IsS as tinyint,
			@IsH as tinyint,
			@IsT as tinyint,
			@HFromDate as datetime,
			@HToDate as datetime, 
			@CFromDate as datetime,
			@CToDate as datetime,
			@Notes as nvarchar(250),
			@CustomerName NVARCHAR (50)
			
CREATE TABLE #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

SET @Date = GETDATE() 			
SET @TempYear = Right(cast (@TranYear as varchar(10)), 2)
SET @TempMonth = Case when len(cast(@TranMonth as varchar(10))) = 1 then  '0' + cast(@TranMonth as varchar(10))
		else cast(@TranMonth as varchar(10)) end

IF @Mode = 1	 --- ho so nhan su
	BEGIN
		SET @cur_HT2460 = CURSOR SCROLL KEYSET FOR
			SELECT EmployeeID, DivisionID, DepartmenTID, TeamID,
				Isnull(BaseSalary, 0) as BaseSalary, 
				(CASE WHEN @CustomerName = '19' 
				      THEN (CASE WHEN EmployeeID = '1534' OR EmployeeID = '3981' OR EmployeeID ='9713'
				                 THEN (ISNULL(SalaryCoefficient,0) + ISNULL(DutyCoefficient,0)) * ISNULL(BaseSalary,0) 
				                 ELSE ISNULL(SalaryCoefficient,0)  * ISNULL(BaseSalary,0)
				            END) 
				       ELSE Isnull(InsuranceSalary, 0) 
				END) AS InsuranceSalary,
				Isnull(Salary01, 0) as Salary01, Isnull(Salary02, 0) as Salary02, Isnull(Salary03, 0) as Salary03,	
				SoInsuranceNo as SNo, SoInsurBeginDate as SBeginDate, 
				HeInsuranceNo as HNo, HospitalID
			FROM HV1400
			Where DivisionID = @DivisionID and 
				DepartmentID like @DepartmentID and
				EmployeeStatus = 1 and
				(CASE WHEN @CustomerName <> '19' THEN ISNULL(InsuranceSalary,0) ELSE 1 END) <> 0

		OPEN @cur_HT2460
		FETCH NEXT FROM @cur_HT2460 INTO @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID, 
				@BaseSalary, @InsuranceSalary, @Salary01, @Salary02, @Salary03,
				@SNo, @SBeginDate, @HNo, @HospitalID
	
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF not exists (SELECT TOP 1 1 FROM HT2460 
				WHERE EmployeeID = @EmployeeID and 
					TranMonth = @TranMonth and 
					TranYear  = @TranYear and 
					DivisionID = @DivisionID)
				BEGIN
					EXEC AP0000 @DivisionID1,@InsurFileID OUTPUT, 'HT2460', 'IN', @TempYear, @TempMonth, 15, 3, 0, ''
					INSERT INTO HT2460(InsurFileID, EmployeeID, DivisionID, DepartmentID, TeamID, 
							BaseSalary, InsuranceSalary, Salary01, Salary02, Salary03,
							 SNo, SBeginDate, CNo, TranMonth, TranYear, HospitalID,
							CreateUserID, CreateDate ) 
						VALUES (@InsurFileID, @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID, 
							 @BaseSalary, @InsuranceSalary, @Salary01, @Salary02, @Salary03,
							 @SNo, @SBeginDate, @HNo, @TranMonth, @TranYear, @HospitalID,
							 @CreateUserID, 	@Date)  	
	
				END
				FETCH NEXT FROM @cur_HT2460 INTO @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID, 
					@BaseSalary, @InsuranceSalary, @Salary01, @Salary02, @Salary03,
					@SNo, @SBeginDate, @HNo, @HospitalID
		 END
	 	
	END
ELSE --- tu ho so bao hiem, tu ho so luong
	BEGIN
		If @Mode = 2 --tu ho so bao hiem 
			SET @cur_HT2460 = CURSOR SCROLL KEYSET FOR
				SELECT EmployeeID, DivisionID, DepartmenTID, TeamID,
					BaseSalary, InsuranceSalary, Salary01, Salary02, Salary03,
					 SNo,  SBeginDate, 
					HNo, HFromDate, HToDate, CNo, CFromDate, CToDate,  IsS, IsH, IsT,HospitalID,Notes
				FROM   HT2460
				Where   DivisionID = @DivisionID and 
					DepartmentID like @DepartmentID and					
					TranMonth = @FromTranMonth and
					TranYear = @FromTranYear and
					EmployeeID In (Select EmployeeID From HT2400 Where DivisionID = @DivisionID and TranMonth = @TranMonth and TranYear = @TranYear)
		else ---tu ho so luong			
			SET @cur_HT2460 = CURSOR SCROLL KEYSET FOR
				SELECT HT00.EmployeeID, HT00.DivisionID, HT00.DepartmenTID, HT00.TeamID,
					HT00.BaseSalary, HT00.InsuranceSalary, HT00.Salary01, HT00.Salary02, HT00.Salary03,
					case when HT01.SNo is null then HT02.SoInsuranceNo else HT01.SNo end as SNo ,
					case when HT01.SBeginDate is null then HT02.SoInsurBeginDate else HT01.SBeginDate end as SBeginDate, 
					case when HT01.HNo is null then HT02.HeInsuranceNo else HT01.HNo end as HNo, 
					HT01.HFromDate, HT01.HToDate, CNo, CFromDate, CToDate, 
					case when IsS is null then Case When HT00.InsuranceSalary>0 Then 1 else 0 End else IsS end as IsS ,
					case when IsH is null then Case When HT00.InsuranceSalary>0 Then 1 else 0 End else IsH end as IsH,
					case when IsT is null then Case When HT00.InsuranceSalary>0 Then 1 else 0 End else IsT end as IsT, HT01.HospitalID, Null As Notes
				FROM HT2400 HT00 left join HT2460 HT01 on HT01.EmployeeID = HT00.EmployeeID and HT01.DivisionID = HT00.DivisionID
					left join HT1402 HT02 on HT02.EmployeeID = HT00.EmployeeID and HT02.DivisionID = HT00.DivisionID 	
				Where HT00.DivisionID = @DivisionID and 
					HT00.DepartmentID like @DepartmentID and --ISNull(HT00.EmployeeStatus,1)=1 and
					HT00.TranMonth = @FromTranMonth and
					HT00.TranYear = @FromTranYear --and
					--HT01.TranMonth = @FromTranMonth and
					--HT01.TranYear = @FromTranYear

			OPEN @cur_HT2460
			FETCH NEXT FROM @cur_HT2460 INTO @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID,
					@BaseSalary, @InsuranceSalary, @Salary01, @Salary02, @Salary03,
					@SNo,  @SBeginDate, 
					@HNo, @HFromDate, @HToDate, @CNo, @CFromDate, @CToDate,  @IsS, @IsH, @IsT,@HospitalID, @Notes
	
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF not exists (SELECT TOP 1 1 FROM HT2460 
					WHERE DivisionID = @DivisionID1 and
						DepartmentID = @DepartmentID1 and
						EmployeeID = @EmployeeID and 
						TranMonth = @TranMonth and 
						TranYear  = @TranYear)
				BEGIN
					EXEC AP0000 @DivisionID1,@InsurFileID OUTPUT, 'HT2460', 'IN', @TempYear, @TempMonth, 15, 3, 0, ''
					INSERT INTO HT2460(InsurFileID, EmployeeID, DivisionID, DepartmenTID, TeamID, 
						TranMonth, TranYear, BaseSalary, InsuranceSalary, Salary01, Salary02, Salary03,
						SNo,  SBeginDate, HNo, HFromDate, HToDate, CNo, CFromDate, CToDate, 
						IsS, IsH, IsT, HospitalID, Notes, CreateUserID, CreateDate) 
					VALUES (@InsurFileID, @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID, 
						@TranMonth, @TranYear,  @BaseSalary, @InsuranceSalary, @Salary01, @Salary02, 
						@Salary03, @SNo,  @SBeginDate, @HNo, @HFromDate, @HToDate, @CNo, 
						@CFromDate, @CToDate, @IsS, @IsH, @IsT, @HospitalID, @Notes, @CreateUserID, @Date) 				
				END
			FETCH NEXT FROM @cur_HT2460 INTO @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID,
					@BaseSalary, @InsuranceSalary, @Salary01, @Salary02, @Salary03,
					@SNo,  @SBeginDate, 
					@HNo, @HFromDate, @HToDate, @CNo, @CFromDate, @CToDate,  @IsS, @IsH, @IsT,@HospitalID, @Notes
			 END		
	END
CLOSE @cur_HT2460
DEALLOCATE @cur_HT2460


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

