
/****** Object:  StoredProcedure [dbo].[HP5003]    Script Date: 08/02/2010 08:37:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


----Created by Nguyen Van Nhan, Date 29/04/200
----Purpose: Tinh Ngay cong cho nhan vien (tong hop Ngay cong cho nhan vien)
----Edited by:Vo Thanh Huong, date 01/07/2004
----Edit by: Dang Le Bao Quynh, Date 31/07/2007
----Purpose: Sua lai cach tinh ngay cong tong hop theo phuong phap luong 2 ky
/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[HP5003]	 @DivisionID nvarchar(50), 
				@TranMonth int, 
				@TranYear int, 
				@PayrollMethodID nvarchar(50), 
				@GeneralAbsentID nvarchar(50),
				@DepartmentID1 as nvarchar(50),
				@TeamID1 as nvarchar(50)
							
As

Declare @Type as tinyint,
	@Days as decimal (28,8),
	@sSQLSelect as nvarchar(4000),
	@sSQLFrom as nvarchar(4000),
	@sSQLWhere as nvarchar(4000),
	@IsMonth as tinyint,
	@TimeConvert as decimal (28,8),
	@FromDate as int,
	@ToDate as int,
	@PeriodID nvarchar(50)

	Select  @PeriodID = PeriodID From HT5002 Where GeneralAbsentID = @GeneralAbsentID AND DivisionID = @DivisionID
		
	Select @TimeConvert = TimeConvert  FROM HT0000

	Select @Type = Type, @Days = Days , @IsMonth = IsMonth,  @FromDate = FromDate, @ToDate = ToDate  
		From HT5002 Where GeneralAbsentID =@GeneralAbsentID AND DivisionID = @DivisionID
	Set @Type = isnull(@Type,0) 
	Set @Days =  isnull(@Days,24)

IF @DepartmentID1 ='%'
BEGIN

IF @IsMonth =1
BEGIN
	IF @Type =0 --- Luong công nhat
		BEGIN
			Set @sSQLSelect = 'Select 	
				TranMonth,TranYear,
				EmployeeID,
				Sum(AbsentAmount*ConvertUnit/CASE WHEN UnitID = ''' + 'H''' + ' THEN '+ STR(@TimeConvert) +'  ELSE 1 END ) as AbsentAmount, 
				DivisionID,
				DepartmentID,
				TeamID '
				
			Set @sSQLFrom =  ' From HT2402  inner join HT1013 on HT2402.AbsentTypeID = HT1013.AbsentTypeID and HT2402.DivisionID = HT1013.DivisionID
			Where DepartmentID in (Select DepartmentID From HT5004 Where 	DivisionID ='''+@DivisionID+''' and										
											PayrollMethodID = '''+@PayrollMethodID+''' ) and
				HT2402.AbsentTypeID in (Select AbsentTypeID From HT5003 Where DivisionID ='''+@DivisionID+''' and GeneralAbsentID ='''+@GeneralAbsentID+''' )  and
				isnull(HT2402.PeriodID,'''') IN (''' + isnull(@PeriodID,'')  + ''','''') and
				TranMonth ='+str(@TranMonth)+' and
				TranYear ='+str(@TranYear)+' and HT2402.DivisionID ='''+@DivisionID+'''' 
			Set @sSQLWhere = ' Group by TranMonth, TranYear, 	EmployeeID, DivisionID,DepartmentID,TeamID '
		END
	ELSE	---- Cong loai tru
		BEGIN
			Set @sSQLSelect = '			Select 	HT2400.TranMonth,
				HT2400.TranYear,
				HT2400.EmployeeID,
				'+str(@Days)+' + + Sum(Case when isnull(TypeID,'''') in ( ''G'', ''P'' )  then - isnull(AbsentAmount*ConvertUnit,0) ELSE 
							 Case When  isnull(TypeID,'''') =''T'' then isnull(AbsentAmount*ConvertUnit,0) ELSE 0 END  END/ 
							CASE WHEN UnitID = ''' + 'H''' + ' THEN '+ STR(@TimeConvert) + ' ELSE 1 END ) as AbsentAmount,		
				HT2400.DivisionID,
				HT2400.DepartmentID,
				HT2400.TeamID '
			Set @sSQLFrom =  ' From HT2400 	Left join 	HT2402 on HT2402.EmployeeID = HT2400.EmployeeID and
								 HT2402.DepartmentID = HT2400.DepartmentID and
 								 isnull(HT2402.TeamID,'''') = isnull(HT2400.TeamID,'''') and
								 HT2402.DivisionID = HT2400.DivisionID and
								 Ht2402.TranMonth = HT2400.TranMonth and
								 Ht2402.TranYear = HT2400.TranYear
					Left  join 	( Select DivisionID, AbsentTypeID , TypeID, UnitID, ConvertUnit From HT1013 Where IsMonth = 1 and AbsentTypeID in (Select AbsentTypeID From HT5003 WHere GeneralAbsentID  ='''+@GeneralAbsentID+''' and DivisionID  ='''+@DivisionID+''' ) ) as H
							on  H.AbsentTypeID = HT2402.AbsentTypeID and H.DivisionID = HT2402.DivisionID'

			Set @sSQLWhere = ' Where HT2400.DepartmentID in (Select DepartmentID From HT5004 Where 	DivisionID ='''+@DivisionID+''' and										
											PayrollMethodID = '''+@PayrollMethodID+''' )  and
									HT2400.DivisionID ='''+@DivisionID+''' and
									isnull(HT2402.PeriodID,'''') IN (''' + isnull(@PeriodID,'')  + ''','''') and
									HT2400.TranMonth ='+str(@TranMonth)+' and
									HT2400.TranYear ='+str(@TranYear)+' 
								Group by  HT2400.TranMonth, HT2400.TranYear,HT2400.EmployeeID, HT2400.DivisionID,HT2400.DepartmentID,HT2400.TeamID '
		END	
	END
ELSE --- Tu cham cong ngay
BEGIN
IF @Type =0 --- Luong công nhat
BEGIN
	Set @sSQLSelect ='Select 	
		TranMonth,TranYear,
		EmployeeID,
		Sum(AbsentAmount*ConvertUnit/ CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + STR(@TimeConvert) + ' ELSE 1 END) as AbsentAmount,
		DivisionID,
		DepartmentID,
		TeamID '
	Set @sSQLFrom =  ' From HT2401 inner join HT1013 on HT2401.AbsentTypeID = HT1013.AbsentTypeID and HT2401.DivisionID = HT1013.DivisionID '
	Set @sSQLWhere =  ' Where DepartmentID in (Select DepartmentID From HT5004 Where 	DivisionID ='''+@DivisionID+''' and										
									PayrollMethodID = '''+@PayrollMethodID+''' ) and
									HT2401.AbsentTypeID in (Select AbsentTypeID From HT5003 Where GeneralAbsentID ='''+@GeneralAbsentID+''' and DivisionID ='''+@DivisionID+''')  and
									TranMonth ='+str(@TranMonth)+' and
									TranYear ='+str(@TranYear)+'  and Day(AbsentDate) between ' + STR(@FromDate) + ' and ' + STR(@ToDate) + '
									and HT2401.DivisionID ='''+@DivisionID+'''
						Group by TranMonth, TranYear, 	EmployeeID, DivisionID,DepartmentID,TeamID '
END
ELSE	---- Cong loai tru
	Set @sSQLSelect = '	Select 	HT2400.TranMonth,
		HT2400.TranYear,
		HT2400.EmployeeID,
		'+str(@Days)+' + + Sum( Case when isnull(TypeID,'''') in ( ''G'', ''P'' )  then - isnull(AbsentAmount*ConvertUnit, 0) ELSE 
					 Case When  isnull(TypeID,'''') =''T'' then isnull(AbsentAmount*ConvertUnit,0) ELSE 0 END  END/ 
					CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + STR(@TimeConvert) + ' ELSE 1 END) as AbsentAmount,		
		HT2400.DivisionID,
		HT2400.DepartmentID,
		HT2400.TeamID '
	Set @sSQLFrom =  ' From HT2400 	Left join 	HT2401 on HT2401.EmployeeID = HT2400.EmployeeID and
						 HT2401.DepartmentID = HT2400.DepartmentID and
 						 isnull(HT2401.TeamID,'''') = isnull(HT2400.TeamID,'''') and
						 HT2401.DivisionID = HT2400.DivisionID and
						 Ht2401.TranMonth = HT2400.TranMonth and
						 Ht2401.TranYear = HT2400.TranYear
			Left  join 	( Select DivisionID, AbsentTypeID , TypeID, ConvertUnit, UnitID From HT1013 Where IsMonth = 0 and AbsentTypeID in (Select AbsentTypeID From HT5003 WHere GeneralAbsentID  ='''+@GeneralAbsentID+''' and DivisionID  ='''+@DivisionID+''') ) as H
					on  H.AbsentTypeID = HT2401.AbsentTypeID and H.DivisionID = HT2401.DivisionID'

	Set @sSQLWhere =  ' Where HT2400.DepartmentID in (Select DepartmentID From HT5004 Where 	DivisionID ='''+@DivisionID+''' and										
									PayrollMethodID = '''+@PayrollMethodID+''' )  and
									HT2400.DivisionID ='''+@DivisionID+''' and
									HT2400.TranMonth ='+str(@TranMonth)+' and
									HT2400.TranYear ='+str(@TranYear)+'  and Day(AbsentDate) between ' + STR(@FromDate) + ' and ' + STR(@ToDate) + '
						Group by  HT2400.TranMonth,HT2400.TranYear,HT2400.EmployeeID, HT2400.DivisionID,HT2400.DepartmentID,HT2400.TeamID '
END 
END
ELSE -----@DepartmentID1 <>'%'
BEGIN

IF @IsMonth =1
BEGIN
IF @Type =0 --- Luong công nhat
BEGIN
	Set @sSQLSelect = 'Select 	
		TranMonth,TranYear,
		EmployeeID,
		Sum(AbsentAmount*ConvertUnit/CASE WHEN UnitID = ''' + 'H''' + ' THEN '+ STR(@TimeConvert) +'  ELSE 1 END ) as AbsentAmount, 
		DivisionID,
		DepartmentID,
		TeamID '
	Set @sSQLFrom =  ' From HT2402  inner join HT1013 on HT2402.AbsentTypeID = HT1013.AbsentTypeID and HT2402.DivisionID = HT1013.DivisionID '
	Set @sSQLWhere = ' Where DepartmentID in (Select DepartmentID From HT5004 Where 	DivisionID ='''+@DivisionID+''' and										
							PayrollMethodID = '''+@PayrollMethodID+''' ) and
							HT2402.AbsentTypeID in (Select AbsentTypeID From HT5003 Where DivisionID ='''+@DivisionID+''' and GeneralAbsentID ='''+@GeneralAbsentID+''' )  and
							HT2402.DepartmentID = ''' + @DepartmentID1+ ''' and 
							IsNull(HT2402.TeamID,'''') like  ''' + @TeamID1+ ''' and 
							isnull(HT2402.PeriodID,'''') IN (''' + isnull(@PeriodID,'')  + ''','''') and
							TranMonth ='+str(@TranMonth)+' and
							TranYear ='+str(@TranYear)+' 
							and HT2402.DivisionID ='''+@DivisionID+'''  
						Group by TranMonth, TranYear, 	EmployeeID, DivisionID,DepartmentID,TeamID '
END
ELSE	---- Cong loai tru
BEGIN
	Set @sSQLSelect = '	Select 	HT2400.TranMonth,
		HT2400.TranYear,
		HT2400.EmployeeID,
		'+str(@Days)+' + + Sum(Case when isnull(TypeID,'''') in ( ''G'', ''P'' )  then - isnull(AbsentAmount*ConvertUnit,0) ELSE 
					 Case When  isnull(TypeID,'''') =''T'' then isnull(AbsentAmount*ConvertUnit,0) ELSE 0 END  END/ 
					CASE WHEN UnitID = ''' + 'H''' + ' THEN '+ STR(@TimeConvert) + ' ELSE 1 END ) as AbsentAmount,		
		HT2400.DivisionID,
		HT2400.DepartmentID,
		HT2400.TeamID '
	Set @sSQLFrom =  ' From HT2400 	Left join 	HT2402 on HT2402.EmployeeID = HT2400.EmployeeID and
						 HT2402.DepartmentID = HT2400.DepartmentID and
 						 isnull(HT2402.TeamID,'''') = isnull(HT2400.TeamID,'''') and
						 HT2402.DivisionID = HT2400.DivisionID and
						 Ht2402.TranMonth = HT2400.TranMonth and
						 Ht2402.TranYear = HT2400.TranYear
			Left  join 	( Select DivisionID, AbsentTypeID , TypeID, UnitID, ConvertUnit From HT1013 Where IsMonth = 1 and AbsentTypeID in (Select AbsentTypeID From HT5003 WHere GeneralAbsentID  ='''+@GeneralAbsentID+''' and DivisionID  ='''+@DivisionID+''' ) ) as H
					on  H.AbsentTypeID = HT2402.AbsentTypeID and H.DivisionID = HT2402.DivisionID'

	Set @sSQLWhere = ' Where HT2400.DepartmentID in (Select DepartmentID From HT5004 Where 	DivisionID ='''+@DivisionID+''' and										
							PayrollMethodID = '''+@PayrollMethodID+''' )  and
							HT2400.DivisionID ='''+@DivisionID+''' and
							HT2400.DepartmentID = ''' + @DepartmentID1+ ''' and 
							IsNull(HT2400.TeamID,'''') like  ''' + @TeamID1+ ''' and 
							isnull(HT2402.PeriodID,'''') IN (''' + isnull(@PeriodID,'')  + ''','''') and
							HT2400.TranMonth ='+str(@TranMonth)+' and
							HT2400.TranYear ='+str(@TranYear)+' 
						Group by  HT2400.TranMonth, HT2400.TranYear,HT2400.EmployeeID, HT2400.DivisionID,HT2400.DepartmentID,HT2400.TeamID '
END
END
ELSE --- Tu cham cong ngay
BEGIN
IF @Type =0 --- Luong công nhat
BEGIN
	Set @sSQLSelect ='Select 	
		TranMonth,TranYear,
		EmployeeID,
		Sum(AbsentAmount*ConvertUnit/ CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + STR(@TimeConvert) + ' ELSE 1 END) as AbsentAmount,
		DivisionID,
		DepartmentID,
		TeamID '
	Set @sSQLFrom =  ' From HT2401 inner join HT1013 on HT2401.AbsentTypeID = HT1013.AbsentTypeID and HT2401.DivisionID = HT1013.DivisionID'
	Set @sSQLWhere = ' Where DepartmentID in (Select DepartmentID From HT5004 Where 	DivisionID ='''+@DivisionID+''' and										
									PayrollMethodID = '''+@PayrollMethodID+''' ) and
									HT2401.DepartmentID = ''' + @DepartmentID1+ ''' and 
									IsNull(HT2401.TeamID,'''') like  ''' + @TeamID1+ ''' and 
									HT2401.AbsentTypeID in (Select AbsentTypeID From HT5003 Where GeneralAbsentID ='''+@GeneralAbsentID+''' and DivisionID ='''+@DivisionID+''')  and
									TranMonth ='+str(@TranMonth)+' and
									TranYear ='+str(@TranYear)+'  and Day(AbsentDate) between ' + STR(@FromDate) + ' and ' + STR(@ToDate) + '
									and HT2401.DivisionID ='''+@DivisionID+'''
						Group by TranMonth, TranYear, 	EmployeeID, DivisionID,DepartmentID,TeamID '
END
ELSE	---- Cong loai tru	BEGIN
		Set @sSQLSelect = '
		Select 	HT2400.TranMonth,
			HT2400.TranYear,
			HT2400.EmployeeID,
			'+str(@Days)+' + + Sum( Case when isnull(TypeID,'''') in ( ''G'', ''P'' )  then - isnull(AbsentAmount*ConvertUnit, 0) ELSE 
						 Case When  isnull(TypeID,'''') =''T'' then isnull(AbsentAmount*ConvertUnit,0) ELSE 0 END  END/ 
						CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + STR(@TimeConvert) + ' ELSE 1 END) as AbsentAmount,		
			HT2400.DivisionID,
			HT2400.DepartmentID,
			HT2400.TeamID '
		Set @sSQLFrom =  ' From HT2400 	Left join 	HT2401 on HT2401.EmployeeID = HT2400.EmployeeID and
							 HT2401.DepartmentID = HT2400.DepartmentID and
 							 isnull(HT2401.TeamID,'''') = isnull(HT2400.TeamID,'''') and
							 HT2401.DivisionID = HT2400.DivisionID and
							 Ht2401.TranMonth = HT2400.TranMonth and
							 Ht2401.TranYear = HT2400.TranYear
				Left  join 	( Select DivisionID, AbsentTypeID , TypeID, ConvertUnit, UnitID From HT1013 Where IsMonth = 0 and AbsentTypeID in (Select AbsentTypeID From HT5003 WHere GeneralAbsentID  ='''+@GeneralAbsentID+''' and DivisionID  ='''+@DivisionID+''' ) ) as H
						on  H.AbsentTypeID = HT2401.AbsentTypeID and H.DivisionID = HT2401.DivisionID '

		Set @sSQLWhere = ' Where HT2400.DepartmentID in (Select DepartmentID From HT5004 Where 	DivisionID ='''+@DivisionID+''' and										
										PayrollMethodID = '''+@PayrollMethodID+''' )  and
										HT2400.DivisionID ='''+@DivisionID+''' and
										HT2400.DepartmentID = ''' + @DepartmentID1+ ''' and 
										IsNull(HT2400.TeamID,'''') like  ''' + @TeamID1+ ''' and 
										HT2400.TranMonth ='+str(@TranMonth)+' and
										HT2400.TranYear ='+str(@TranYear)+'  and Day(AbsentDate) between ' + STR(@FromDate) + ' and ' + STR(@ToDate) + '
							Group by  HT2400.TranMonth,HT2400.TranYear,HT2400.EmployeeID, HT2400.DivisionID,HT2400.DepartmentID,HT2400.TeamID '
	END 
  END
END
IF Not Exists (Select 1 From SysObjects Where Xtype ='V' and name=  'HV5003')
	Exec ('Create View HV5003 as '+ @sSQLSelect +  @sSQLFrom + @sSQLWhere )
ELSE
	Exec (' Alter View HV5003 as  '+ @sSQLSelect +  @sSQLFrom + @sSQLWhere)