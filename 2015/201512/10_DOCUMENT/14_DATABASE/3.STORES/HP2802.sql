
/****** Object:  StoredProcedure [dbo].[HP2802]    Script Date: 08/04/2010 11:27:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2802]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2802]
GO

/****** Object:  StoredProcedure [dbo].[HP2802]    Script Date: 08/04/2010 11:27:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



--- Create Date: 13/6/2005
---Purpose: Tinh ngay phep thang

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE [dbo].[HP2802]  @DivisionID as nvarchar(50),
				@DepartmentID as nvarchar(50),
				@TeamID1 as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@GeneralAbsentID nvarchar(50)
				
as

Declare @Type as tinyint,
	@Days as decimal(28,8),
	@sSQL as nvarchar(4000),
	@IsMonth as tinyint,
	@TimeConvert as decimal(28,8),
	@FromDate as int,
	@ToDate as int,
	@curHT as Cursor,
	@EmployeeID as nvarchar(50),
	@DivisionID1 as nvarchar(50),
	@DepartmentID1 as nvarchar(50),
	@TeamID as nvarchar(50),	
	@EmployeeStatus as tinyint,
	@LeaveDate as datetime,
	@LoaCondID as nvarchar(50),
	@DaysInYear as decimal(28,8),
	@DaysAllowed as decimal(28,8),
	@TranMonth1 as int,
	@TranYear1 as int,
	@DaysSpent as decimal(28,8),
	@EmpLoaID as nvarchar(50),
	@TempYear as nvarchar(50),
	@TempMonth as nvarchar(50),
	@GeneralAbsentID1 as nvarchar(50),
	@DaysPrevYear as decimal(28,8),
	@IsP as tinyint, ---------- IsP = 1 : Tu cham cong phep 	0 : Cong phep duoc ket chuyen tu cong khac sang
	@DaysRemained as decimal(28,8)

	SET @TempYear = Ltrim(Rtrim(str(@TranYear)))
	SET @TempMonth = Case when len(cast(@TranMonth as nvarchar(50)))= 1 then  '0' + cast(@TranMonth as nvarchar(50))
		else Ltrim(Rtrim(str(@TranMonth))) end
		
	Select @TimeConvert = TimeConvert  FROM HT0000 	where DivisionID = @DivisionID 

	Select @Type = Type, @Days = Days , @IsMonth = IsMonth,  @FromDate = FromDate, @ToDate = ToDate  
		From HT5002 Where GeneralAbsentID =@GeneralAbsentID
	Set @Type = isnull(@Type,0) 
	Set @Days =  isnull(@Days,24)
	select @IsP = IsP from HT5002 where GeneralAbsentID = @GeneralAbsentID

	/* ---- */
	Set @FromDate = isnull(@FromDate,0) 
	Set @ToDate =  isnull(@ToDate,0)
	/* ---- */
----------Tinh tong cong cua tung nhan vien

--------------------Tu cham cong thang -------------------------------------

If @IsMonth =1----Tu cham cong thang
	Begin
		If @Type =0 ---Cong nhat
			begin
				Set @sSQL = 'Select 	
					TranMonth,TranYear,
					EmployeeID,
					Sum(AbsentAmount*ConvertUnit/CASE WHEN UnitID = ''' + 'H''' + ' THEN '+ STR(@TimeConvert) +'  ELSE 1 END ) as AbsentAmount, 
					DivisionID,
					DepartmentID,
					TeamID
				From HT2402  inner join HT1013 on HT2402.AbsentTypeID = HT1013.AbsentTypeID And HT2402.DivisionID = HT1013.DivisionID 
				Where HT2402.DivisionID= '''+ @DivisionID+''' and HT2402.DepartmentID like '''+@DepartmentID +''' and isnull(TeamID,0) like '''+@TeamID1+''' and
					HT2402.AbsentTypeID in (Select AbsentTypeID From HT5003 Where GeneralAbsentID ='''+@GeneralAbsentID+''' )  and
					TranMonth ='+str(@TranMonth)+' and
					TranYear ='+str(@TranYear)+' 
				Group by TranMonth, TranYear, 	EmployeeID, DivisionID,DepartmentID,TeamID '
			----print @sSQL
			end
		Else	---- Cong loai tru
			Set @sSQL = '			Select 	HT2400.TranMonth,
				HT2400.TranYear,
				HT2400.EmployeeID,
				'+str(@Days)+' + + Sum(Case when isnull(TypeID,'''') in ( ''G'', ''P'' )  then - isnull(AbsentAmount*ConvertUnit,0) else 
							 Case When  isnull(TypeID,'''') =''T'' then isnull(AbsentAmount*ConvertUnit,0) else 0 end  end/ 
							CASE WHEN UnitID = ''' + 'H''' + ' THEN '+ STR(@TimeConvert) + ' ELSE 1 END ) as AbsentAmount,		
				HT2400.DivisionID,
				HT2400.DepartmentID,
				HT2400.TeamID
			From HT2400 	Left join 	HT2402 on HT2402.EmployeeID = HT2400.EmployeeID and
								 HT2402.DepartmentID = HT2400.DepartmentID and
 								 isnull(HT2402.TeamID,'''') = isnull(HT2400.TeamID,'''') and
								 HT2402.DivisionID = HT2400.DivisionID and
								 Ht2402.TranMonth = HT2400.TranMonth and
								 Ht2402.TranYear = HT2400.TranYear
					Left  join 	( Select  AbsentTypeID , TypeID, UnitID, ConvertUnit From HT1013 Where IsMonth = 1 and AbsentTypeID in (Select AbsentTypeID From HT5003 WHere GeneralAbsentID  ='''+@GeneralAbsentID+''' ) ) as H
							on  H.AbsentTypeID = HT2402.AbsentTypeID

			 Where
				HT2400.DivisionID ='''+@DivisionID+''' and 
				HT2400.TranMonth ='+str(@TranMonth)+' and
				HT2400.TranYear ='+str(@TranYear)+'  and HT2400.DepartmentID like '''+@DepartmentID+''' and isnull(HT2400.TeamID,0) like '''+@TeamID1+'''

			Group by  HT2400.TranMonth, HT2400.TranYear,HT2400.EmployeeID, HT2400.DivisionID,HT2400.DepartmentID,HT2400.TeamID '
	End
	
--------------------- Tu cham cong ngay	 ---------------------------------------
Else --- Tu cham cong ngay
	Begin
		If @Type =0 --- Luong công nhat
			Set @sSQL ='Select 	
				TranMonth,TranYear,
				EmployeeID,
				Sum(AbsentAmount*ConvertUnit/ CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + STR(@TimeConvert) + ' ELSE 1 END) as AbsentAmount, 
				DivisionID,
				DepartmentID,
				TeamID
			From HT2401 inner join HT1013 on HT2401.AbsentTypeID = HT1013.AbsentTypeID and HT2401.DivisionID = HT1013.DivisionID 
			Where  HT2401.DivisionID= '''+ @DivisionID+''' and HT2401.DepartmentID like '''+@DepartmentID+''' and isnull(HT2401.TeamID,0) like '''+@TeamID1+'''
				and HT2401.AbsentTypeID in (Select AbsentTypeID From HT5003 Where GeneralAbsentID ='''+@GeneralAbsentID+''' )  and
				TranMonth ='+str(@TranMonth)+' and
				TranYear ='+str(@TranYear)+'  and Day(AbsentDate) between ' + STR(@FromDate) + ' and ' + STR(@ToDate) + '
			Group by TranMonth, TranYear, 	EmployeeID, DivisionID,DepartmentID,TeamID '

		Else	---- Cong loai tru
			Set @sSQL = '			Select 	HT2400.TranMonth,
				HT2400.TranYear,
				HT2400.EmployeeID,
				'+str(@Days)+' + + Sum( Case when isnull(TypeID,'''') in ( ''G'', ''P'' )  then - isnull(AbsentAmount*ConvertUnit, 0) else 
							 Case When  isnull(TypeID,'''') =''T'' then isnull(AbsentAmount*ConvertUnit,0) else 0 end  end/ 
							CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + STR(@TimeConvert) + ' ELSE 1 END) as AbsentAmount,		
				HT2400.DivisionID,
				HT2400.DepartmentID,
				HT2400.TeamID
			From HT2400 	Left join 	HT2401 on HT2401.EmployeeID = HT2400.EmployeeID and
								 HT2401.DepartmentID = HT2400.DepartmentID and
 								 isnull(HT2401.TeamID,'''') = isnull(HT2400.TeamID,'''') and
								 HT2401.DivisionID = HT2400.DivisionID and
								 Ht2401.TranMonth = HT2400.TranMonth and
								 Ht2401.TranYear = HT2400.TranYear
					Left  join 	( Select  AbsentTypeID , TypeID, ConvertUnit, UnitID From HT1013 Where IsMonth = 0 and AbsentTypeID in (Select AbsentTypeID From HT5003 WHere GeneralAbsentID  ='''+@GeneralAbsentID+''' ) ) as H
							on  H.AbsentTypeID = HT2401.AbsentTypeID

			Where 
				HT2400.DivisionID ='''+@DivisionID+''' and HT2400.DepartmentID like '''+@DepartmentID+''' and isnull(HT2400.TeamID,0) like '''+@TeamID1+''' and
				HT2400.TranMonth ='+str(@TranMonth)+' and
				HT2400.TranYear ='+str(@TranYear)+'  and Day(AbsentDate) between ' + STR(@FromDate) + ' and ' + STR(@ToDate) + '
			Group by  HT2400.TranMonth,HT2400.TranYear,HT2400.EmployeeID, HT2400.DivisionID,HT2400.DepartmentID,HT2400.TeamID '
	End	

----print @sSQL
If Not Exists (Select 1  From SysObjects Where Xtype ='V' and name=  'HV2803')
	Exec ('Create View HV2803--- tao boi HP2802
				 as  ' + @sSQL)
Else
	Exec (' Alter View HV2803 --- tao boi HP2802
				 as  ' + @sSQL)


-------------------------------------------------------INSERT VAO HT2809-------------------------------------------------------
Print isnull(@IsP,0)

if isnull(@IsP,0) = 1
	BEGIN

	/*If Exists (Select top 1 1 From HT2809 Where DivisionID = @DivisionID
						  and TranMonth = @TranMonth and TranYear = @TranYear and GeneralAbsentID= @GeneralAbsentID)		

		Delete HT2809 Where 	DivisionID = @DivisionID and
					TranMonth =@TranMonth and 
					TranYear = @TranYear and
					GeneralAbsentID= @GeneralAbsentID*/

	Set @curHT = Cursor scroll  static for
				Select HT.EmployeeID, HT.DivisionID,  HT.DepartmentID, HT.TeamID,  EmployeeStatus, 
					LeaveDate,LoaCondID, DaysPrevYear, DaysInYear, DaysAllowed, IsNull(AbsentAmount,0) as DaysSpent, DaysRemained

					
					From HT2809 HT left join HV2803 HV on HT.DivisionID= HV.DivisionID and
					HT.DepartmentID like HV.DepartmentID and
					isnull(HT.TeamID,'')=isnull(HV.TeamID,'') and 
					HT.EmployeeID=HV.EmployeeID and
					HT.TranMonth=HV.TranMonth and
					HT.TranYear=HV.TranYear 
					Where HT.TranYear= @TranYear and HT.TranMonth=@TranMonth and HT.DivisionID= @DivisionID 
					



			Open @curHT
			Fetch next from @curHT into @EmployeeID, @DivisionID1,@DepartmentID1, @TeamID ,  @EmployeeStatus,
						@LeaveDate, @LoaCondID, @DaysPrevYear, @DaysInYear, @DaysAllowed, @DaysSpent,@DaysRemained
	---print str(@DaysSpent)

	While @@Fetch_Status = 0
	Begin
	if @DaysSpent > @DaysAllowed
		set @DaysRemained = @DaysRemained - @DaysAllowed
	else
		set @DaysRemained = @DaysRemained - @DaysSpent
	/*Exec AP0000  @EmpLoaID  OUTPUT, 'HT2809', 'LOM', @TempMonth ,@TempYear,15, 3, 0, '-'
					If  Exists (Select top 1 1 From HT2809 Where DivisionID = @DivisionID and  
						 EmployeeID =@EmployeeID and TranMonth = @TranMonth and TranYear = @TranYear and 
						GeneralAbsentID= @GeneralAbsentID)		
				
					insert  HT2809 (	EmpLoaMonthID,  EmployeeID, DivisionID,  DepartmentID, TeamID,  EmployeeStatus,  
							LeaveDate, LoaCondID, TranMonth, TranYear, DaysPrevYear, DaysInYear, DaysAllowed, DaysSpent,GeneralAbsentID)

					Values (@EmpLoaID,@EmployeeID, @DivisionID1,@DepartmentID1, @TeamID ,  @EmployeeStatus,
				@LeaveDate, @LoaCondID, @TranMonth, @TranYear ,@DaysPrevYear, @DaysInYear, @DaysAllowed, @DaysSpent, @GeneralAbsentID) 

	---print str(@DaysSpent)		*/
		Update HT2809 set  DaysSpent = @DaysSpent, DaysRemained = @DaysRemained where DivisionID = @DivisionID1 and DepartmentID = @DepartmentID1 and
			Isnull(TeamID,0) = Isnull(@TeamID,0) and EmployeeID = @EmployeeID and TranMonth = @TranMonth and TranYear = @TranYear and 
				GeneralAbsentID = @GeneralAbsentID
	Fetch next from @curHT into @EmployeeID, @DivisionID1,@DepartmentID1, @TeamID ,  @EmployeeStatus,
						@LeaveDate, @LoaCondID,@DaysPrevYear, @DaysInYear, @DaysAllowed, @DaysSpent,@DaysRemained

	End
	Close @curHT
	-----------DEALLOCATE @curHT
	END  ----------Dong IF isnull (IsP,0) = 1
Else

	BEGIN
	----------print 'babbbbbbbbbbbb'
	Set @curHT = Cursor scroll  static for
				Select HT.EmployeeID, HT.DivisionID,  HT.DepartmentID, HT.TeamID,  EmployeeStatus, 
					LeaveDate,LoaCondID, DaysPrevYear, DaysInYear, DaysAllowed, HT5005.AbsentAmount - IsNull(HV.AbsentAmount,0) as DaysSpent, DaysRemained

					
					From HT2809 HT left join HV2803 HV on HT.DivisionID= HV.DivisionID and
					HT.DepartmentID like HV.DepartmentID and
					isnull(HT.TeamID,'')=isnull(HV.TeamID,'') and 
					HT.EmployeeID=HV.EmployeeID and
					HT.TranMonth=HV.TranMonth and
					HT.TranYear=HV.TranYear inner join HT5005 on HT5005.GeneralAbsentID = HT.GeneralAbsentID
					Where HT.TranYear= @TranYear and HT.TranMonth=@TranMonth and HT.DivisionID= @DivisionID 
					



			Open @curHT
			Fetch next from @curHT into @EmployeeID, @DivisionID1,@DepartmentID1, @TeamID ,  @EmployeeStatus,
						@LeaveDate, @LoaCondID, @DaysPrevYear, @DaysInYear, @DaysAllowed, @DaysSpent,@DaysRemained
	---print str(@DaysSpent)

	While @@Fetch_Status = 0
	Begin
	if @DaysSpent > @DaysAllowed
		set @DaysRemained = @DaysRemained - @DaysAllowed
	else
		set @DaysRemained = @DaysRemained - @DaysSpent

		Update HT2809 set  DaysSpent = @DaysSpent, DaysRemained = @DaysRemained where DivisionID = @DivisionID1 and DepartmentID = @DepartmentID1 and
			Isnull(TeamID,0) = Isnull(@TeamID,0) and EmployeeID = @EmployeeID and TranMonth = @TranMonth and TranYear = @TranYear and 
				GeneralAbsentID = @GeneralAbsentID
	Fetch next from @curHT into @EmployeeID, @DivisionID1,@DepartmentID1, @TeamID ,  @EmployeeStatus,
						@LeaveDate, @LoaCondID,@DaysPrevYear, @DaysInYear, @DaysAllowed, @DaysSpent,@DaysRemained

	End
	Close @curHT
	DEALLOCATE @curHT

	End


------------print 'aaaaaaaaaaaaa'
-----------------------------------------Moi thang,  insert cong phep vao bang cham cong HT2401, HT2402 de tinh luong cho nhan vien khong nghi het phep 

IF Exists (select EmployeeID From HT2809 where DivisionID= @DivisionID and TranMonth=  @TranMonth and TranYear= @TranYear and IsNull(IsCal,0)=1)
	Begin 
		Exec HP2803 @DivisionID, '%', '%' , @TranMonth, @TranYear ,@GeneralAbsentID			
			
		If @IsMonth =1 -----Tu cham cong thang; HT2812 la bang tam  luu cham cong HT2402, HT2401. 
			
			Begin 

				If Exists (Select top 1 1 From HT2812 Where DivisionID = @DivisionID
				  and TranMonth = @TranMonth and TranYear = @TranYear and GeneralAbsentID= @GeneralAbsentID and IsMonth=1)		
				Begin
					Delete HT2812 Where 	DivisionID = @DivisionID and
								TranMonth =@TranMonth and 
								TranYear = @TranYear and
								DepartmentID like @DepartmentID and
								Isnull(TeamID,0) like @TeamID1 and
								GeneralAbsentID= @GeneralAbsentID and
								IsMonth=1
				End
--------Insert vao HT2812 cong phep thang hien tai

				INSERT INTO HT2812
                            (EmployeeID,
                             TranMonth,
                             TranYear,
                             DivisionID,
                             DepartmentID,
                             TeamID,
                             GeneralAbsentID,
                             AbsentTypeID,
                             AbsentAmount,
                             IsMonth)
                SELECT HT2402.EmployeeID,
                       HT2402.TranMonth,
                       HT2402.TranYear,
                       HT2402.DivisionID,
                       HT2402.DepartmentID,
                       HT2402.TeamID,
                       @GeneralAbsentID AS GeneralAbsentID,
                       HT2402.AbsentTypeID,
                       HT2402.AbsentAmount,
                       1                AS IsMonth
                FROM   HT2402
                       INNER JOIN (SELECT HT03.AbsentTypeID, HT03.DivisionID
                                   FROM   HT5003 HT03
                                          INNER JOIN HT1013 HT13
                                            ON HT03.AbsentTypeID = HT13.AbsentTypeID
                                               AND HT03.DivisionID = HT13.DivisionID
                                   WHERE  HT03.GeneralAbsentID = @GeneralAbsentID AND HT03.DivisionID = @DivisionID) HT
                         ON HT2402.AbsentTypeID = HT.AbsentTypeID
                            AND HT2402.DivisionID = HT.DivisionID
                       INNER JOIN HV2805
                         ON HT2402.DivisionID = HV2805.DivisionID
                            AND HT2402.DepartmentID = HV2805.DepartmentID
                            AND HT2402.EmployeeID = HV2805.EmployeeID
                            AND HT2402.DivisionID = HV2805.DivisionID
                WHERE  HT2402.TranMonth = @TranMonth
                       AND HT2402.TranYear = @TranYear
                       AND HT2402.DivisionID = @DivisionID
                       AND HT2402.DepartmentID LIKE @DepartmentID
                       AND Isnull(HT2402.TeamID, 0) LIKE @TeamID1
                       AND HT2402.EmployeeID IN
                           (SELECT EmployeeID
                            FROM   HT2808
                            WHERE  DivisionID = @DivisionID
                                   AND TranMonth = @TranMonth
                                   AND TranYear = @TranYear
                                   AND Isnull(IsCal, 0) = 1) 

-------Update HT2402 tong ngay phep tu dau nam den thang hien tai de tinh luong

				Update HT2402 set AbsentAmount= HT2402.AbsentAmount+ HV2805.DaysRemained
				
				From HT2402
				inner join (Select HT03.AbsentTypeID from HT5003 HT03 inner join HT1013 HT13 on
				HT03.AbsentTypeID=HT13.AbsentTypeID and HT03.DivisionID=HT13.DivisionID 
				where HT03.GeneralAbsentID = @GeneralAbsentID ) HT on HT2402.AbsentTypeID=HT.AbsentTypeID
				inner join HV2805 on HT2402.DivisionID=HV2805.DivisionID 
				and HT2402.DepartmentID=HV2805.DepartmentID and HT2402.EmployeeID=HV2805.EmployeeID 
				
				where  HT2402.TranMonth=@TranMonth  and HT2402.TranYear= @TranYear 
				and HT2402.DivisionID= @DivisionID and HT2402.DepartmentID like @DepartmentID and isnull(HT2402.TeamID,0) like @TeamID1 and HT2402.EmployeeID IN 
				(SELECT EmployeeID FROM HT2808  WHERE DivisionID= @DivisionID and TranMonth=@TranMonth and TranYear=@TranYear and isnull(IsCal,0)=1)
				
			End 
		Else------tu cham cong ngay 
				
			Begin
				
				If Exists (Select top 1 1 From HT2812 Where DivisionID = @DivisionID
				  and TranMonth = @TranMonth and TranYear = @TranYear and GeneralAbsentID= @GeneralAbsentID and IsMonth=0)		
				Begin
					Delete HT2812 Where 	DivisionID = @DivisionID and DepartmentID like @DepartmentID and isnull(TeamID,0) like @TeamID1 and
							TranMonth =@TranMonth and 
							TranYear = @TranYear and
							GeneralAbsentID= @GeneralAbsentID and
							IsMonth=0
				End
--------Insert vao HT2812 cong phep thang hien tai

				Insert into HT2812 (EmployeeID, TranMonth, TranYear, DivisionID,
						 DepartmentID, TeamID, GeneralAbsentID, AbsentTypeID, AbsentAmount, IsMonth)

				Select HT2401.EmployeeID, HT2401.TranMonth, HT2401.TranYear, HT2401.DivisionID, HT2401.DepartmentID, 
					HT2401.TeamID, @GeneralAbsentID as GeneralAbsentID,  HT2401.AbsentTypeID, HT2401.AbsentAmount, 0 as IsMonth
				
				From HT2401
				Inner join (Select HT03.AbsentTypeID from HT5003 HT03 inner join HT1013 HT13 on
				HT03.AbsentTypeID=HT13.AbsentTypeID and HT03.DivisionID=HT13.DivisionID
				Where HT03.GeneralAbsentID =  @GeneralAbsentID ) HT on HT2401.AbsentTypeID=HT.AbsentTypeID
				Inner join HV2805 on HT2401.DivisionID=HV2805.DivisionID 
				and HT2401.DepartmentID=HV2805.DepartmentID and HT2401.EmployeeID=HV2805.EmployeeID 
				
				Where  HT2401.TranMonth=@TranMonth  and HT2401.TranYear= @TranYear 
				and HT2401.DivisionID= @DivisionID and HT2401.DepartmentID like @DepartmentID and isnull(HT2401.TeamID,0) like @TeamID1
				and HT2401.EmployeeID IN 
				(SELECT EmployeeID FROM HT2808  WHERE DivisionID= @DivisionID and TranMonth=@TranMonth and TranYear=@TranYear and isnull(IsCal,0)=1)

--------Update HT2401 tong ngay phep tu dau nam den thang hien tai de tinh luong

				UPDATE HT2401
                SET    AbsentAmount = HT2401.AbsentAmount + HV2805.DaysRemained
                FROM   HT2401
                       INNER JOIN (SELECT HT03.AbsentTypeID, HT03.DivisionID
                                   FROM   HT5003 HT03
                                          INNER JOIN HT1013 HT13
                                            ON HT03.AbsentTypeID = HT13.AbsentTypeID
                                               AND HT03.DivisionID = HT13.DivisionID
                                   WHERE  HT03.GeneralAbsentID = @GeneralAbsentID) HT
                         ON HT2401.AbsentTypeID = HT.AbsentTypeID
                            AND HT2401.DivisionID = HT.DivisionID
                       INNER JOIN HV2805
                         ON HT2401.DivisionID = HV2805.DivisionID
                            AND HT2401.DepartmentID = HV2805.DepartmentID
                            AND HT2401.EmployeeID = HV2805.EmployeeID
                WHERE  HT2401.TranMonth = @TranMonth
                       AND HT2401.TranYear = @TranYear
                       AND HT2401.DivisionID = @DivisionID
                       AND HT2401.DepartmentID LIKE @DepartmentID
                       AND Isnull(HT2401.TeamID, 0) LIKE @TeamID1
                       AND HT2401.EmployeeID IN
                           (SELECT EmployeeID
                            FROM   HT2808
                            WHERE  DivisionID = @DivisionID
                                   AND TranMonth = @TranMonth
                                   AND TranYear = @TranYear
                                   AND Isnull(IsCal, 0) = 1) 
                
			
	
			End

	
	End

----------------------------------INSERT VAO BANG HT2810 NGAY PHEP CON LAI CUA NAM NEU KHONG NGHI HET PHEP NAM------------------------
If @TranMonth=12
	Begin
	
	If Exists (select EmployeeID From HT2809 where TranMonth=  @TranMonth and TranYear= @TranYear and IsNull(IsAdded,0)=1)
		Exec HP2806 @DivisionID, @TranMonth , @TranYear, @GeneralAbsentID

	End




 ---Cursor scroll  keyset for


























GO

