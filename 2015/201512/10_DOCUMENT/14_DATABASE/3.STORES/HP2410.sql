/****** Object:  StoredProcedure [dbo].[HP2410]    Script Date: 07/30/2010 16:35:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created byVo Thanh Huong, Date 16/02/2005
----Purpose: Tinh Ngay cong cho nhan vien -- tam ung 

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[HP2410] @DivisionID nvarchar(50), 
				@DepartmentID nvarchar(50),	
				@TeamID nvarchar(50),
				@EmployeeID nvarchar(50),	
				@TranMonth int, 
				@TranYear int, 		
				@lstGeneralAbsentID nvarchar(150)
				
As

Declare @Type as tinyint,
	@Days as decimal(28,8),
	@sSQL as nvarchar(4000),
	@IsMonth as tinyint,
	@TimeConvert as decimal(28,8),
	@FromDate as int,
	@ToDate as int,
	@GeneralAbsentID nvarchar(50),
	@cur cursor

Set @lstGeneralAbsentID  = '''' +   Replace(@lstGeneralAbsentID, ',', ''',''') + ''''

Set @sSQL = 'Select Distinct GeneralAbsentID From HT5003 
	Where  GeneralAbsentID in  (' +  @lstGeneralAbsentID + ')
	And DivisionID = '''+@DivisionID+''' ' 

If Exists (Select 1 From SysObjects Where Xtype ='V' and name=  'HV2334')
	Drop view HV2334
Exec (' Create view HV2334  ---tao boi HP2410
		as  '+@sSQL)
Set @sSQL = ''

Set  @Cur = CURSOR SCROLL KEYSET FOR
	Select GeneralAbsentID From HV2334

	Open @cur
	Fetch next from @Cur into  @GeneralAbsentID
WHILE @@FETCH_STATUS = 0
BEGIN
	Select @TimeConvert = TimeConvert  FROM HT0000 Where DivisionID = @DivisionID
	
	Select @Type = Type, @Days = Days , @IsMonth = IsMonth,  @FromDate = FromDate, @ToDate = ToDate  
		From HT5002 Where GeneralAbsentID =@GeneralAbsentID And DivisionID = @DivisionID
	Select @Type = isnull(@Type,0),  @Days =  isnull(@Days,24)

	If @IsMonth =1
	Begin
	If @Type =0 --- Luong cong nhat
		Set @sSQL = @sSQL + ' Select 	
			TranMonth,TranYear,
			HT2402.EmployeeID, ''' + @GeneralAbsentID + ''' as  GeneralAbsentID, 
			Sum(AbsentAmount*ConvertUnit/CASE WHEN UnitID = ''' + 'H''' + ' THEN '+ STR(@TimeConvert) +'  ELSE 1 END ) as AbsentAmount, 
			DivisionID,
			DepartmentID,
			TeamID
		From HT2402  inner join HT1013 on HT2402.AbsentTypeID = HT1013.AbsentTypeID and HT2402.DivisionID = HT1013.DivisionID
		Where HT2402.DivisionID = ''' + @DivisionID + ''' and 
			HT2402.DepartmentID like ''' + @DepartmentID + ''' and 
			Isnull(HT2402.TeamID, '''') like isnull(''' + @TeamID + ''', '''') and  
			HT2402.EmployeeID like ''' + @EmployeeID + ''' and 
			HT2402.AbsentTypeID in (Select AbsentTypeID From HT5003 Where DivisionID = '''+@DivisionID+''' And GeneralAbsentID ='''+@GeneralAbsentID+''' )  and
			TranMonth =' + str(@TranMonth)+' and
			TranYear =' + str(@TranYear)+
		' Group by TranMonth, TranYear, 	EmployeeID, DivisionID,DepartmentID,TeamID Union'

	Else	---- Cong loai tru
		Set @sSQL = @sSQL + ' Select 	HT2400.TranMonth,
			HT2400.TranYear,
			HT2400.EmployeeID, ''' + @GeneralAbsentID + ''' as  GeneralAbsentID, 
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
			Left  join 	( Select  DivisionID ,AbsentTypeID , TypeID, UnitID, ConvertUnit From HT1013 Where DivisionID = '''+@DivisionID+''' And IsMonth = 1 and AbsentTypeID in (Select AbsentTypeID From HT5003 Where DivisionID = '''+@DivisionID+''' And GeneralAbsentID  ='''+@GeneralAbsentID+''' ) ) as H
					on  H.AbsentTypeID = HT2402.AbsentTypeID and H.DivisionID = HT2402.DivisionID
		Where HT2400.DivisionID = ''' + @DivisionID + ''' and  
			HT2400.DepartmentID like ''' + @DepartmentID + ''' and 
			Isnull(HT2400.TeamID, '''') like isnull(''' + @TeamID + ''', '''') and  
			HT2400.EmployeeID like ''' + @EmployeeID + ''' and 
 			HT2400.TranMonth =' + str(@TranMonth)+' and
			HT2400.TranYear =' + str(@TranYear) + ' 
		Group by  HT2400.TranMonth, HT2400.TranYear,HT2400.EmployeeID, HT2400.DivisionID,HT2400.DepartmentID,HT2400.TeamID Union '
	End
	Else --- Tu cham cong ngay
	Begin
	If @Type =0 --- Luong cong nhat
		Set @sSQL =  @sSQL + 'Select 
			TranMonth,TranYear,
			HT2401.EmployeeID, ''' + @GeneralAbsentID + ''' as  GeneralAbsentID, 
			Sum(AbsentAmount*ConvertUnit/ CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + STR(@TimeConvert) + ' ELSE 1 END) as AbsentAmount,
			DivisionID,
			DepartmentID,
			TeamID
		From HT2401 inner join HT1013 on HT2401.AbsentTypeID = HT1013.AbsentTypeID and HT2401.DivisionID = HT1013.DivisionID
		Where  HT2401.DivisionID = ''' + @DivisionID + ''' and 
			HT2401.DepartmentID like ''' + @DepartmentID + ''' and 
			Isnull(HT2401.TeamID, '''') like isnull(''' + @TeamID + ''', '''') and  
			HT2401.EmployeeID like ''' + @EmployeeID + ''' and 
			HT2401.AbsentTypeID in (Select AbsentTypeID From HT5003 Where DivisionID = '''+@DivisionID+''' And GeneralAbsentID ='''+@GeneralAbsentID+''' )  and
			TranMonth ='+str(@TranMonth)+' and
			TranYear ='+str(@TranYear)+'  and Day(AbsentDate) between ' + STR(@FromDate) + ' and ' + STR(@ToDate) + ' 
		Group by TranMonth, TranYear, 	EmployeeID, DivisionID,DepartmentID,TeamID Union '
	Else	---- Cong loai tru
	Set @sSQL =  @sSQL + ' Select 	HT2400.TranMonth,
		HT2400.TranYear,
		HT2400.EmployeeID, ''' + @GeneralAbsentID + ''' as  GeneralAbsentID, 
		'+str(@Days)+' + + Sum( Case when isnull(TypeID,'''') in ( ''G'', ''P'' )  then - isnull(AbsentAmount*ConvertUnit, 0) else 
					 Case When  isnull(TypeID,'''') =''T'' then isnull(AbsentAmount*ConvertUnit,0) else 0 end  end/ 
					CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + STR(@TimeConvert) + ' ELSE 1 END) as AbsentAmount,		
		HT2400.DivisionID,
		HT2400.DepartmentID,
		HT2400.TeamID
	From HT2400 	Left join HT2401 on HT2401.EmployeeID = HT2400.EmployeeID and
						 HT2401.DepartmentID = HT2400.DepartmentID and
 						 isnull(HT2401.TeamID,'''') = isnull(HT2400.TeamID,'''') and
						 HT2401.DivisionID = HT2400.DivisionID and
						 Ht2401.TranMonth = HT2400.TranMonth and
						 Ht2401.TranYear = HT2400.TranYear
			Left  join ( Select DivisionID, AbsentTypeID , TypeID, ConvertUnit, UnitID From HT1013 Where DivisionID = '''+@DivisionID+''' And IsMonth = 0 and AbsentTypeID in (Select AbsentTypeID From HT5003 Where DivisionID = '''+@DivisionID+''' And GeneralAbsentID  ='''+@GeneralAbsentID+''' ) ) as H
						on  H.AbsentTypeID = HT2401.AbsentTypeID and H.DivisionID = HT2401.DivisionID
	Where HT2400.DivisionID = ''' + @DivisionID + ''' and 
		HT2400.DepartmentID like ''' + @DepartmentID + ''' and 
		Isnull(HT2400.TeamID, '''') like isnull(''' + @TeamID + ''', '''') and  
		HT2400.EmployeeID like ''' + @EmployeeID + ''' and 
		HT2400.TranMonth ='+str(@TranMonth)+' and
		HT2400.TranYear ='+str(@TranYear)+'  and Day(AbsentDate) between ' + STR(@FromDate) + ' and ' + STR(@ToDate)  + '
	 Group by  HT2400.TranMonth,HT2400.TranYear,HT2400.EmployeeID, HT2400.DivisionID,HT2400.DepartmentID,HT2400.TeamID Union '

	End

	Fetch next from @Cur into  @GeneralAbsentID

END



Close @cur
Deallocate @cur
Set @sSQL = left(@sSQL, len(@sSQL) - 5)

If Exists (Select 1 From SysObjects Where Xtype ='V' and name=  'HV2333')
	Drop view HV2333
Exec (' Create view HV2333  ---tao boi HP2410
		as  '+@sSQL)
	







































