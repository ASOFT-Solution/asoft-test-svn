IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2801]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2801]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---Create Date: 8/6/2005
---Purpose: Tao du lieu ke thua ho so phep

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/
---- Modified on 23/09/2013 by Le Thi Thu Hien : Chinh sua HV2810 thành HV2810S do trùng view với store HP2810
-- <Example>
---- 
CREATE PROCEDURE [dbo].[HP2801]  @DivisionID as nvarchar(50),
				@TranMonth as tinyint, ----------Thang dag dc cap nhat Ho so phep
				@TranYear as smallint,  --------------Nam dg dc cap nhat ho so phep
				@UserID as nvarchar(50),
				@IsFromHV1400 tinyint ----------- Ke thua tu ho so nhan su hay ho so phep
				
AS

DECLARE		@TempYear as nvarchar(50),
			@TempMonth as nvarchar(50),
			@HV1400_Cursor as CURSOR,
			@cur as cursor,
			@WorkDate as datetime,	
			@LeaveDate as datetime, 
			@LoaCondID1 as nvarchar(50),
			@DaysPrevYear as decimal(28,8),
			@DaysInYear as decimal(28,8), 
			@DaysAllowed as decimal(28,8),
			@LoaCondID as nvarchar(50),
			@sSQL as nvarchar(4000),
			@EmpLoaID as nvarchar(50),
			@DivisionID1 as nvarchar(50),
			@EmployeeID as nvarchar(50),
			@DepartmentID1 as nvarchar(50),
			@TeamID as nvarchar(50),
			@EmployeeStatus as tinyint,
			@D AS nvarchar(20), 
			@MM AS nvarchar(6), 
			@YY AS nvarchar(8), 
			@DD AS DATETIME,
			@sHT2810 as nvarchar(4000),
			@PrevYear as smallint,
			@GeneralAbsentID as nvarchar(50),
			@DaysRemained as decimal(28,8),
			@PrevMonth as smallint,
			@cur2 as cursor,
			@BeginDate as datetime,
			@DaysSpent as decimal(28,8),
			@DaysRemained1 as decimal(28,8),
			@DaysAllowed1 as decimal(28,8),
			@WorkMonth as decimal(28,8),
			@IsManage as tinyint
			

SET @D='01/' 
SET @MM=CAST(@TranMonth AS nvarchar(4))+'/'
SET @YY= CAST(@TranYear AS nvarchar(8))
SET @D=@MM+@D+@YY
Set @PrevYear= @TranYear-1
set @PrevMonth = @TranMonth - 1

select @IsManage = IsManage from HT2806
/* ---- */
Set @IsManage = isnull(@IsManage,'')
/* ---- */

SET @DD=CAST(@D AS DATETIME)
--print @DD
------------------XOA HT2809 NEU DA MO HO SO PHEP THANG-----------------------------------------


SET @TempYear = Ltrim(Rtrim(str(@TranYear)))
SET @TempMonth = Case when len(cast(@TranMonth as nvarchar(50)))= 1 then  '0' + cast(@TranMonth as nvarchar(50))
		else Ltrim(Rtrim(str(@TranMonth))) end

If Exists (Select top 1 1 From HT2809 Where DivisionID = @DivisionID 
					  and TranMonth = @TranMonth and TranYear = @TranYear)		

	Delete HT2809 Where 		DivisionID = @DivisionID and
					--DepartmentID like @DepartmentID and
					TranMonth =@TranMonth and 
					TranYear = @TranYear 


-----------------KE THUA HO SO PHEP TU HO SO NHAN SU---------------------------------					

IF @IsFromHV1400 = 1 

BEGIN  ----------KE THUA HO SO PHEP TU HO SO NHAN SU

	select @GeneralAbsentID = GAbsentLoanID from HT0000	 where DivisionID = @DivisionID 
						
	----------------------------------------LAY NGAY PHEP NAM TRUOC-------------------------------

	If Exists (Select top 1 1 From HT2810  Where DivisionID = @DivisionID and TranYear = @PrevYear)	------------NEU CO PHEP NAM TRUOC
		
		BEGIN  ------------NEU CO PHEP NAM TRUOC
	
			Set @sHT2810='Select EmployeeID,DivisionID,DepartmentID,TeamID,TranYear, SUM(DaysRemained) AS DaysRemained 
				From HT2810 Where TranYear =' + cast(@PrevYear as nvarchar(8))+'  and DivisionID= '''+ @DivisionID+''' 
				Group by EmployeeID,DivisionID,DepartmentID,TeamID,TranYear ' 

			If not  exists(Select  1 From sysObjects Where XType = 'V' and Name = 'HV2810S')	
				exec('Create view HV2810S ---tao boi HP2801
							as ' + @sHT2810)
			Else
				exec('Alter view HV2810S ---tao boi HP2801
							as ' + @sHT2810)

			------------Lay cac dieu kien huong phep tu ho so nhan su cho nhan vien dang lam va nhan vien nghi trong nam-------------
			Set @cur = Cursor scroll keyset for
				Select Distinct LoaCondID
				 From HV1400
				Where  isnull(LoaCondID, '''') <> '''' 
			Open @cur
			Fetch next from @cur into @LoaCondID

			While @@Fetch_Status = 0
			Begin ---- @cur
				
				--------------Lay thoi gian lam viec cua nhan vien thoa dieu kien tham nien toi thieu ----------------------------------------

				SET @sSQL='Select HV.DivisionID, HV.DepartmentID, isnull(HV.TeamID,'''') as TeamID, HV.EmployeeID,  EmployeeStatus, isnull(WorkDate,'''') as WorkDate, 
						isnull(LeaveDate,'''') as LeaveDate, isnull(DATEDIFF(month, WorkDate, '''+ cast(@DD as nvarchar(50))+'''),0) as WorkMonth, 
						IsNull(DaysRemained,0) as DaysPrevYear, isnull(LoaCondID,'''') as LoaCondID From HV1400 HV
						left join HV2810S HT on HV.DivisionID=HT.DivisionID and HV.DepartmentID=HT.DepartmentID 
						and isnull(HV.TeamID,'''')=isnull(HT.TeamID,'''') and HV.EmployeeID=HT.EmployeeID
						Where HV.DivisionID= '''+ @DivisionID+'''  and EmployeeStatus=1 and 
						LoaCondID  ='''+ @LoaCondID+''' and
 						isnull(DATEDIFF(month, WorkDate,'''+ cast(@DD as nvarchar(50))+''' ),0 )>= (Select MinWorkPeriod From HT2806 Where LoaCondID ='''+ @LoaCondID+''')
					Union 
							Select HV.DivisionID, HV.DepartmentID, isnull(HV.TeamID,'''') as TeamID, HV.EmployeeID,  EmployeeStatus, isnull(WorkDate,'''') as WorkDate, 
								isnull(LeaveDate,'''') as LeaveDate, isnull(DATEDIFF(month, WorkDate,'''+ cast(@DD as nvarchar(50))+'''),0) as WorkMonth, 
								IsNull(DaysRemained,0) as DaysPrevYear, isnull(LoaCondID,'''') as LoaCondID From HV1400 HV
								left join HV2810S HT on HV.DivisionID=HT.DivisionID and HV.DepartmentID=HT.DepartmentID 
								and isnull(HV.TeamID,'''')=isnull(HT.TeamID,'''') and HV.EmployeeID=HT.EmployeeID
								Where  HV.DivisionID= '''+ @DivisionID+'''  and EmployeeStatus=9 and Year(LeaveDate)= '+cast(@TranYear as nvarchar(8))+' and Month(LeaveDate)=' +cast(@TranMonth as nvarchar(4))+ ' and
								LoaCondID  ='''+ @LoaCondID+''' and
 								isnull(DATEDIFF(month, WorkDate,'''+  cast(@DD as nvarchar(50))+''' ),0 )>= (Select MinWorkPeriod From HT2806 WHERE LoaCondID='''+ @LoaCondID+''')'


				--print @sSQL

				If not  exists(Select  1 From sysObjects Where XType = 'V' and Name = 'HV2801')	
					exec('Create view HV2801 ---tao boi HP2801
						as ' + @sSQL)
				Else
					exec('Alter view HV2801 ---tao boi HP2801
						as ' + @sSQL)

				------------------Lay ngay phep nam cua nhan vien tinh den thoi diem hien tai
		  
				Set @sSQL= 'Select DivisionID,DepartmentID,TeamID,EmployeeID,
						EmployeeStatus ,WorkDate, LeaveDate,WorkMonth, HV.LoaCondID, DaysPrevYear,
						isnull(sum(case when WorkMonth >= FromPeriod and (WorkMonth <ToPeriod or ToPeriod=-1) then DaysBeAllowed
							else   0 end), 0 ) as DaysInYear
						From HV2801 HV inner join HT2807 on HV.LoaCondID=HT2807.LoaCondID and HV.DivisionID=HT2807.DivisionID 
						Group by DivisionID,DepartmentID,TeamID,EmployeeID,
						EmployeeStatus ,WorkDate, LeaveDate,WorkMonth, HV.LoaCondID, DaysPrevYear'

				If not  exists(Select  1 From sysObjects Where XType = 'V' and Name = 'HV2802')	
					exec('Create view HV2802 ---tao boi HP2801
						as ' + @sSQL)
				Else
					exec('Alter view HV2802 ---tao boi HP2801
						as ' + @sSQL)

				-----------Lay ngay phep nhan nhan vien duoc quyen nghi tinh den thoi diem hien tai-------------------------------------------

				Set @sSQL='Select DivisionID,DepartmentID,TeamID,EmployeeID,
						EmployeeStatus ,WorkDate, LeaveDate,WorkMonth, LoaCondID, DaysPrevYear, DaysInYear,
						case when '+str(@IsManage)+' = 1 then
						case  when DaysInYear <12 then  
									case when  '+str(@TranMonth)+'  < = DaysInYear  then   '+str(@TranMonth)+'  + DaysPrevYear  
										else DaysInYear + DaysPrevYear end 
							else round(DaysInYear/12,0) *  '+str(@TranMonth)+'  + DaysPrevYear end 
						else DaysInYear + DaysPrevYear end
						as DaysAllowed
						From  HV2802 Where EmployeeStatus=1
					Union Select DivisionID,DepartmentID,TeamID,EmployeeID,
						EmployeeStatus ,WorkDate, LeaveDate,WorkMonth, LoaCondID, DaysPrevYear, DaysInYear,
						case  when DaysInYear <12 then
										case when  '+str(@TranMonth)+'  < = DaysInYear  then  IsNull(Month(LeaveDate),0) + DaysPrevYear 
											else DaysInYear + DaysPrevYear end 
							else round(DaysInYear/12,0) *  IsNull(Month(LeaveDate),0)  + DaysPrevYear end 
						as DaysAllowed
						From  HV2802 Where EmployeeStatus=9 '
				----print @sSQL

				If not Exists (Select top 1 1  From SysObjects Where Name ='HT2811' and Xtype ='U')

					CREATE TABLE [dbo].[HT2811]  (
						[APK] [uniqueidentifier] NOT NULL,
						[DivisionID] [nvarchar] (50)  NULL,	
						[DepartmentID] [nvarchar] (50)  NULL,
						[TeamID] [nvarchar] (50) NULL,
						[EmployeeID] [nvarchar] (50) NOT NULL,
						[EmployeeStatus] [tinyint] NULL, 
						[WorkDate] [datetime] NULL,
						[LeaveDate] [datetime] NULL,
						[WorkMonth] [int] NULL,
						[LoaCondID] [nvarchar] (50) NULL,
						[DaysPrevYear] [decimal] (28,8) NULL,
						[DaysInYear] [decimal] (28,8) NULL,
						[DaysAllowed] [decimal] (28,8) NULL
						
					) ON [PRIMARY]
					Else
					  Delete  HT2811


				Exec ( 'Insert into HT2811 (DivisionID,DepartmentID, TeamID, EmployeeID, EmployeeStatus, WorkDate, 
				LeaveDate, WorkMonth, LoaCondID, DaysPrevYear, DaysInYear, DaysAllowed)' + @sSQL)

				------------------------INSERT VAO HO SO PHEP-------------------------------------------------------------------

				Set @HV1400_Cursor= CURSOR SCROLL KEYSET FOR
						
				Select EmployeeID, DivisionID,DepartmentID, TeamID,  EmployeeStatus, WorkDate, LeaveDate, LoaCondID, DaysPrevYear,
					DaysInYear, DaysAllowed,WorkMonth
				From HT2811
					
				Open @HV1400_Cursor
					FETCH NEXT FROM @HV1400_Cursor INTO   @EmployeeID, @DivisionID1,@DepartmentID1, @TeamID, @EmployeeStatus,
											 @WorkDate, @LeaveDate,@LoaCondID1, @DaysPrevYear, @DaysInYear, @DaysAllowed,@WorkMonth
					WHILE @@FETCH_STATUS = 0
						 BEGIN		---- @HV1400_Cursor
							Exec AP0000  @DivisionID, @EmpLoaID  OUTPUT, 'HT2809', 'LOM', @TempMonth ,@TempYear,15, 3, 0, '-'
							If not Exists (Select top 1 1 From HT2809 Where DivisionID = @DivisionID and  
								 EmployeeID =@EmployeeID and TranMonth = @TranMonth and TranYear = @TranYear)		
						
							Insert HT2809 (	EmpLoaMonthID,  EmployeeID, DivisionID,  DepartmentID, TeamID,  EmployeeStatus,  WorkDate,	
									LeaveDate, LoaCondID, DaysPrevYear, DaysInYear, DaysAllowed, WorkMonth,TranMonth ,  TranYear,  GeneralAbsentID,CreateUserID,
									CreateDate,LastModifyUserID, LastModifyDate)

								Values (@EmpLoaID, @EmployeeID, @DivisionID1,@DepartmentID1, @TeamID, @EmployeeStatus, @WorkDate,	
									@LeaveDate,@LoaCondID1,@DaysPrevYear,  @DaysInYear, @DaysAllowed, @WorkMonth,@TranMonth, @TranYear, @GeneralAbsentID,
									@UserID,getdate(), @UserID, getdate() )	

							FETCH NEXT FROM @HV1400_Cursor INTO @EmployeeID, @DivisionID1,@DepartmentID1, @TeamID ,  @EmployeeStatus,
												@WorkDate, @LeaveDate, @LoaCondID1, @DaysPrevYear, @DaysInYear, @DaysAllowed,@WorkMonth
						 END	---- @HV1400_Cursor
					Close @HV1400_Cursor

				Fetch next from @cur into @LoaCondID

			End  ---- @cur

		Close @cur

		END ------------NEU CO PHEP NAM TRUOC

	ELSE -----NEU KHONG TON TAI NGAY PHEP NAM TRUOC
		
		BEGIN  -----NEU KHONG TON TAI NGAY PHEP NAM TRUOC
			
			Set @cur = Cursor scroll keyset for
					Select Distinct LoaCondID
					 From HV1400
					Where  isnull(LoaCondID, '''') <> '''' 
			Open @cur
			Fetch next from @cur into @LoaCondID

			While @@Fetch_Status = 0
			Begin  ---- @cur
				------------Lay thoi gian lam viec cua nhan vien thoa dieu kien tham nien toi thieu ----------------------------------------

				SET @sSQL='Select HV.DivisionID, HV.DepartmentID, isnull(HV.TeamID,'''') as TeamID, HV.EmployeeID,  EmployeeStatus, isnull(WorkDate,'''') as WorkDate, 
						isnull(LeaveDate,'''') as LeaveDate, isnull(DATEDIFF(month, WorkDate, '''+ cast(@DD as nvarchar(50))+'''),0) as WorkMonth, 
						0 as DaysPrevYear, isnull(LoaCondID,'''') as LoaCondID From HV1400 HV
						Where  HV.DivisionID= '''+ @DivisionID+'''  and  EmployeeStatus=1 and 
						LoaCondID  ='''+ @LoaCondID+''' and
 						isnull(DATEDIFF(month, WorkDate,'''+ cast(@DD as nvarchar(50))+''' ),0 )>= (Select MinWorkPeriod From HT2806 Where LoaCondID ='''+ @LoaCondID+''')
					Union 
						Select HV.DivisionID, HV.DepartmentID, isnull(HV.TeamID,'''') as TeamID, HV.EmployeeID,  EmployeeStatus, isnull(WorkDate,'''') as WorkDate, 
							isnull(LeaveDate,'''') as LeaveDate, isnull(DATEDIFF(month, WorkDate,'''+ cast(@DD as nvarchar(50))+'''),0) as WorkMonth, 
							0 as DaysPrevYear, isnull(LoaCondID,'''') as LoaCondID From HV1400 HV
							Where  HV.DivisionID= '''+ @DivisionID+'''  and  EmployeeStatus=9 and Year(LeaveDate)= '+cast(@TranYear as nvarchar(8))+' and Month(LeaveDate)=' +cast(@TranMonth as nvarchar(4))+ ' and
							LoaCondID  ='''+ @LoaCondID+''' and
							isnull(DATEDIFF(month, WorkDate,'''+  cast(@DD as nvarchar(50))+''' ),0 )>= (Select MinWorkPeriod From HT2806 WHERE LoaCondID='''+ @LoaCondID+''')'


					-----print @sSQL
					Drop view HV2801
					exec('Create view HV2801 ---tao boi HP2801
							as ' + @sSQL)

----------------------------------------------------------Lay ngay phep nam cua nhan vien tinh den thoi diem hien tai
	  
					Set @sSQL= 'Select DivisionID,DepartmentID,TeamID,EmployeeID,
							EmployeeStatus ,WorkDate, LeaveDate,WorkMonth, HV.LoaCondID, DaysPrevYear,
							isnull(sum(case when WorkMonth >= FromPeriod and (WorKMonth <ToPeriod or ToPeriod=-1) then DaysBeAllowed
								else   0 end), 0 ) as DaysInYear
 							From HV2801 HV inner join HT2807 on HV.LoaCondID=HT2807.LoaCondID and HV.DivisionID=HT2807.DivisionID
							Group by DivisionID,DepartmentID,TeamID,EmployeeID,
							EmployeeStatus ,WorkDate, LeaveDate,WorkMonth, HV.LoaCondID, DaysPrevYear'
					Drop view HV2802;
					exec('Create view HV2802 ---tao boi HP2801
							as ' + @sSQL)

---------------------------------------------------------------Lay ngay phep nhan nhan vien duoc quyen nghi tinh den thoi diem hien tai-------------------------------------------

				Set @sSQL= 'Select DivisionID,DepartmentID,TeamID,EmployeeID,
						EmployeeStatus ,WorkDate, LeaveDate,WorkMonth, LoaCondID, DaysPrevYear, DaysInYear,
						case when '+str(@IsManage)+' = 1 then
						case  when DaysInYear <12 then  
									case when  '+str(@TranMonth)+'  < = DaysInYear  then   '+str(@TranMonth)+'  + DaysPrevYear  
										else DaysInYear + DaysPrevYear end 
							else round(DaysInYear/12,0) *  '+str(@TranMonth)+'  + DaysPrevYear end 
						else DaysInYear + DaysPrevYear end
						as DaysAllowed
						From  HV2802 Where EmployeeStatus=1
					Union Select DivisionID,DepartmentID,TeamID,EmployeeID,
						EmployeeStatus ,WorkDate, LeaveDate,WorkMonth, LoaCondID, DaysPrevYear, DaysInYear,
						case  when DaysInYear <12 then
										case when  '+str(@TranMonth)+'  < = DaysInYear  then  IsNull(Month(LeaveDate),0) + DaysPrevYear 
											else DaysInYear + DaysPrevYear end 
 							else round(DaysInYear/12,0) *  IsNull(Month(LeaveDate),0)  + DaysPrevYear end 
						as DaysAllowed
						From  HV2802 Where EmployeeStatus=9 '
				---print @sSQL

				If not Exists (Select top 1 1  From SysObjects Where Name ='HT2811' and Xtype ='U')

				CREATE TABLE [dbo].[HT2811]  (
					[APK] [uniqueidentifier] NOT NULL,
					[DivisionID] [nvarchar] (50)  NULL,	
					[DepartmentID] [nvarchar] (50)  NULL,
					[TeamID] [nvarchar] (50) NULL,
					[EmployeeID] [nvarchar] (50) NOT NULL,
					[EmployeeStatus] [tinyint] NULL, 
					[WorkDate] [datetime] NULL,
					[LeaveDate] [datetime] NULL,
					[WorkMonth] [int] NULL,
					[LoaCondID] [nvarchar] (50) NULL,
					[DaysPrevYear] [decimal] (28,8) NULL,
					[DaysInYear] [decimal] (28,8) NULL,
					[DaysAllowed] [decimal] (28,8) NULL
					
				) ON [PRIMARY]
				Else
				  Delete  HT2811


				Exec ( 'Insert into HT2811 (DivisionID,DepartmentID, TeamID, EmployeeID, EmployeeStatus, WorkDate, 
				LeaveDate, WorkMonth, LoaCondID, DaysPrevYear, DaysInYear, DaysAllowed)' + @sSQL)

--------------------------------------------------------------------------------------------INSERT VAO HO SO PHEP-------------------------------------------------------------------

			Set @HV1400_Cursor= CURSOR SCROLL KEYSET FOR
					
			Select EmployeeID, DivisionID,DepartmentID, TeamID,  EmployeeStatus, WorkDate, LeaveDate, LoaCondID, DaysPrevYear,
				DaysInYear, DaysAllowed,WorkMonth,DaysInYear + DaysPrevYear as DaysRemained
			From HT2811
				
			Open @HV1400_Cursor
				FETCH NEXT FROM @HV1400_Cursor INTO   @EmployeeID, @DivisionID1,@DepartmentID1, @TeamID, @EmployeeStatus,
										 @WorkDate, @LeaveDate,@LoaCondID1, @DaysPrevYear, @DaysInYear, @DaysAllowed,@WorkMonth,@DaysRemained
				WHILE @@FETCH_STATUS = 0
					 BEGIN		---- @HV1400_Cursor
						Exec AP0000  @DivisionID, @EmpLoaID  OUTPUT, 'HT2809', 'LOM', @TempMonth ,@TempYear,15, 3, 0, '-'
						If not Exists (Select top 1 1 From HT2809 Where DivisionID = @DivisionID and  
							 EmployeeID =@EmployeeID and TranMonth = @TranMonth and TranYear = @TranYear)		
					
						Insert HT2809 (	EmpLoaMonthID,  EmployeeID, DivisionID,  DepartmentID, TeamID,  EmployeeStatus,  WorkDate,	
								LeaveDate, LoaCondID, DaysPrevYear, DaysInYear, DaysAllowed,DaysRemained, WorkMonth,TranMonth ,  TranYear,  GeneralAbsentID,CreateUserID,
								CreateDate, LastModifyUserID, LastModifyDate)

							Values (@EmpLoaID, @EmployeeID, @DivisionID1,@DepartmentID1, @TeamID, @EmployeeStatus, @WorkDate,	
								@LeaveDate,@LoaCondID1,@DaysPrevYear,  @DaysInYear, @DaysAllowed, @DaysRemained,@WorkMonth,@TranMonth, @TranYear, @GeneralAbsentID,@UserID,
								 getdate(), @UserID, getdate() )	

						FETCH NEXT FROM @HV1400_Cursor INTO @EmployeeID, @DivisionID1,@DepartmentID1, @TeamID ,  @EmployeeStatus,
											@WorkDate, @LeaveDate, @LoaCondID1, @DaysPrevYear, @DaysInYear, @DaysAllowed,@WorkMonth,@DaysRemained
					 END   ---- @HV1400_Cursor
				Close @HV1400_Cursor

			Fetch next from @cur into @LoaCondID

			End ---- @cur

			Close @cur

		END   -----NEU KHONG TON TAI NGAY PHEP NAM TRUOC

	--@DepartmentID as nvarchar(50), and  DepartmentID like @DepartmentID
	
	END   ----------KE THUA HO SO PHEP TU HO SO NHAN SU





ELSE -----------KE THUA TU HO SO PHEP THANG 

--------Kiem tra neu thang muon ke thua la thang 1 thi fai tinh lai so ngay phep trong nam moi cua nv.
	if @TranMonth = 1
		begin

---------Tinh so ngay phep co trong nam va so ngay phep trong 1 thang
			Set @sSQL= 'Select DivisionID,DepartmentID,TeamID,EmployeeID,
					EmployeeStatus ,WorkDate, LeaveDate,WorkMonth+1 as WorkMonth, HV.LoaCondID, DaysRemained as DaysPrevYear,
					isnull(sum(case when WorkMonth + 1 >= FromPeriod and (WorKMonth  + 1<ToPeriod or ToPeriod=-1) then DaysBeAllowed
						else   0 end), 0 ) as DaysInYear
 					From HT2809 HV inner join HT2807 on HV.LoaCondID=HT2807.LoaCondID and HV.DivisionID=HT2807.DivisionID 
					where HV.TranMonth = 12 and HV.TranYear = '+ cast (@PrevYear as nvarchar(8)) +'
					Group by DivisionID,DepartmentID,TeamID,EmployeeID,
					EmployeeStatus ,WorkDate, LeaveDate,WorkMonth, HV.LoaCondID, DaysPrevYear '
	
			----print @sSQL
			Drop view HV2811;
			exec('Create view HV2811 ---tao boi HP2801
					as ' + @sSQL)
				
			set @cur2 = CURSOR SCROLL KEYSET FOR
				select HT.EmployeeID, HT.DivisionID, HT.DepartmentID, HT.TeamID, HT.WorkDate, HT.BeginDate, HT.EmployeeStatus, HT.LeaveDate, HT.LoaCondID,
				HV.DaysPrevYear, HV.DaysInYear, 
				case when @IsManage = 1 then
				case when HV.DaysInYear <12 then 1 + HV.DaysPrevYear else  round(HV.DaysInYear/12,0) + HV.DaysPrevYear end 
				else HV.DaysPrevYear + HV.DaysInYear end
				as DaysAllowed,
				HT.GeneralAbsentID as GeneralAbsentID, HV.DaysInYear + HV.DaysPrevYear as DaysRemained,HV.WorkMonth from HT2809 HT inner join HV2811 HV
				on HT.DivisionID = HV.DivisionID and HT.DepartmentID = HV.DepartmentID and HT.EmployeeID = HV.EmployeeID
				where HT.TranMonth = 12 and HT.TranYear = @PrevYear
			open @cur2						FETCH NEXT From @cur2 into @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID, @WorkDate, @BeginDate, @EmployeeStatus, @LeaveDate,
					@LoaCondID, @DaysPrevYear, @DaysInYear, @DaysAllowed, @GeneralAbsentID, @DaysRemained,@WorkMonth
			WHILE @@FETCH_STATUS = 0 
			Begin  ---- @cur2
				Exec AP0000  @DivisionID, @EmpLoaID  OUTPUT, 'HT2809', 'LOM', @TempMonth ,@TempYear,15, 3, 0, '-'
				insert into HT2809 (EmploaMonthID,EmployeeID, DivisionID, DepartmentID, TeamID, WorkDate, BeginDate,TranMonth, TranYear, EmployeeStatus, 
					LeaveDate, LoaCondID, DaysPrevYear, DaysInYear, DaysAllowed, GeneralAbsentID, DaysRemained,CreateUserID, CreateDate, LastModifyUserID,
					LastModifyDate, WorkMonth) 
				VALUES (@EmpLoaID,@EmployeeID, 
					@DivisionID1, @DepartmentID1, @TeamID, @WorkDate, @BeginDate, @TranMonth, @TranYear, @EmployeeStatus, @LeaveDate,
					@LoaCondID, @DaysPrevYear, @DaysInYear, @DaysAllowed, @GeneralAbsentID, @DaysRemained,@UserID, getdate(), @UserID, getdate(), @WorkMonth)
				FETCH NEXT From @cur2 into @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID, @WorkDate, @BeginDate, @EmployeeStatus, @LeaveDate,
					@LoaCondID, @DaysPrevYear, @DaysInYear, @DaysAllowed, @GeneralAbsentID, @DaysRemained,@WorkMonth
			End ---- @cur2
			
		END--------End dong if @TranMonth = 1
	else
		begin
----------------Tinh so ngay phep co dc trong mot thang neu IsManage = 1
			BEGIN				
				
				Set @sSQL= 'Select DivisionID,DepartmentID,TeamID,EmployeeID,
						EmployeeStatus ,WorkDate, LeaveDate,LoaCondID, DaysPrevYear, DaysInYear, WorkMonth + 1 as WorkMonth, 
						case when '+str(@IsManage)+' = 1 then
						case  when DaysInYear <12 then  
									case when  '+str(@TranMonth)+'  < = DaysInYear  then   '+str(@TranMonth)+'  + DaysPrevYear  
										else DaysInYear + DaysPrevYear end 
							else round(DaysInYear/12,0) *  '+str(@TranMonth)+'  + DaysPrevYear end  
						else DaysInYear + DaysPrevYear end
					as DaysAllowed
						From  HT2809 Where EmployeeStatus=1 and DivisionID = ''' + @DivisionID + ''' and TranMonth = '+cast(@PrevMonth as nvarchar(2))+' and TranYear = ' + cast (@TranYear as nvarchar(4))+''
				
				----PRINT @sSQL			
				Drop view HV2810S;
				exec('Create view HV2810S ---tao boi HP2801
						as ' + @sSQL)
				
				set @cur2 = CURSOR SCROLL KEYSET FOR 
							select HT.EmployeeID, HT.DivisionID , HT.DepartmentID, HT.TeamID, HT.WorkDate, HT.BeginDate,
										HT.EmployeeStatus, HT.LeaveDate, HT.LoaCondID, HT.DaysPrevYear, HT.DaysInYear,
										HT.DaysSpent, HT.GeneralAbsentID, HT.DaysRemained,HV.DaysAllowed as DaysAllowed, HT.DaysAllowed as DaysAllowed1,HV.WorkMonth
							From HT2809 HT left join HV2810S HV on HT.DivisionID = HV.DivisionID 
							and HT.DepartmentID = HV.DepartmentID 
							and HT.EmployeeID = HV.EmployeeID
					open @cur2
				FETCH NEXT FROM @cur2 into @EmployeeID,@DivisionID1, @DepartmentID1, @TeamID, @WorkDate, @BeginDate, @EmployeeStatus, @LeaveDate,
							@LoaCondID, @DaysPrevYear,@DaysInYear, @DaysSpent, @GeneralAbsentID, @DaysRemained,@DaysAllowed, @DaysAllowed1,@WorkMonth

				WHILE @@FETCH_STATUS = 0
				BEGIN

					if isnull(@DaysSpent,0) > @DaysAllowed1

						set @DaysAllowed = @DaysAllowed - @DaysAllowed1
						
					else
						set @DaysAllowed = @DaysAllowed - isnull(@DaysSpent,0)

					Exec AP0000 @DivisionID, @EmpLoaID  OUTPUT, 'HT2809', 'LOM', @TempMonth ,@TempYear,15, 3, 0, '-'
			
					insert into HT2809(EmpLoaMonthID, EmployeeID, DivisionID, DepartmentID, TeamID, WorkDate, BeginDate, TranMonth , TranYear, EmployeeStatus,
						LeaveDate, LoaCondID, DaysPrevYear, DaysInYear, DaysAllowed, GeneralAbsentID, DaysRemained,CreateUserID, CreateDate, LastModifyUserID, LastModifyDate,WorkMonth)
						VALUES ( @EmpLoaID, @EmployeeID,
						@DivisionID1, @DepartmentID1, @TeamID, @WorkDate, @BeginDate, @TranMonth , @TranYear, @EmployeeStatus, @LeaveDate, @LoaCondID,
						@DaysPrevYear, @DaysInYear, @DaysAllowed, @GeneralAbsentID, @DaysRemained,@UserID, getdate(), @UserID, getdate(), @WorkMonth)
					
					FETCH NEXT From @cur2 into @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID, @WorkDate, @BeginDate, @EmployeeStatus
						, @LeaveDate, @LoaCondID, @DaysPrevYear, @DaysInYear, @DaysSpent, @GeneralAbsentID, @DaysRemained, @DaysAllowed, @DaysAllowed1,@WorkMonth

				end ----------END DONG VONG LAP WHILE
				
			END -------END DONG BEGIN CUA ELSE KIEM TRA THANG MUON KE THUA DU LIEU KHONG FAI LA THANG 1

				
END --------END DONG BEGIN CUA TRUONG HOP KE THUA TU HS PHEP THANG TRUOC



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

