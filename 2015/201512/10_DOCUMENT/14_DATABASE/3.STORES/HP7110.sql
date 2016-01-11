IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP7010]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP7010]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Create Date: 20/09/2005, Phuong Loan
---Purpose: In bao cao luong theo thiet lap cua nguoi dung
--Code written by : Luong Bao Anh
--Edit by Trung Dung, 29/06/2011
--Customize cho People Link lay them WorkDate,LeaveDate, Target04ID,Target05ID,Target06ID,Target07ID Insert vao HT7111
--- Edited by Bao Anh	Date: 24/07/2012
--- Purpose: Lay truong Birthday, PersonalTaxID
---- Edited by Bao Anh	Date: 19/12/2012	Bo sung truong EducationLevelID, EducationLevelName, MajorID, MajorName
--- Edited by Bao Anh	Date: 11/12/2013	Bo sung truong ShortName, Alias
----- Modified on 18/06/2014 by Le Thi Thu Hien : Bo sung them Thuế TNCN
----- Modified by Thanh Sơn on 21/01/2015: Bổ sug thêm 3 trường tài khoản kết chuyển cho SG Petro

CREATE PROCEDURE HP7010
(	
	@DivisionID nvarchar(50),
	@ReportCode nvarchar(50),
	@FromDepartmentID nvarchar(50),
	@ToDepartmentID nvarchar(50),
	@TeamID nvarchar(50),
	@FromEmployeeID nvarchar(50),
	@ToEmployeeID nvarchar(50),
	@FromMonth int,
	@FromYear int,
	@ToMonth int,
	@ToYear int,
	@lstPayrollMethodID as nvarchar(800)
)									

AS
Declare @sSQL nvarchar(4000), 
	@sSQL1 nvarchar(4000), 
	@cur as cursor,
	@PayrollMethodID nvarchar(4000),
	@Count as int,
	@sSQLGroup as nvarchar(4000),
	@Caption as nvarchar(250),
	@AmountType as nvarchar(50), 
	@AmountTypeFrom as nvarchar(4000), 
	@AmountTypeTo as nvarchar(4000),
	@Signs as nvarchar(50), 
	@OtherAmount as money,
	@AmountTypeFromOut as nvarchar(4000),
	@AmountTypeToOut as nvarchar(4000),
	@ColumnID as int,
	@IsSerie as tinyint,
	@ColumnAmount as nvarchar(500),
	@FromColumn as int,
	@ToColumn as int, 
	@sGroupBy as nvarchar(4000),
	@sCaption as nvarchar(4000),
	@sColumn as nvarchar(2000),
	@Pos as int,
	@Currency as nvarchar(50),
	@Currency1 as nvarchar(50),
	@RateExchange as money,
	@IsChangeCurrency as tinyint,
	@IsTotal as tinyint,
	@sSQL2 as nvarchar(4000), 	
	@FOrders as int,
	@sSQL_HT2400 nvarchar(4000),
	@sSQL_HT2401 nvarchar(4000),
	@sSQL_HT2402 nvarchar(4000),
	@sSQL_HT3400 nvarchar(4000),
	@sSQL_HT3400GA nvarchar(4000),
	@sSQL_HT0338 NVARCHAR(MAX),
	@TableName nvarchar(4000),
	@IsHT2400 tinyint,
	@IsHT2401 tinyint,
	@IsHT2402 tinyint,
	@IsHT3400 tinyint,
	@IsOT tinyint,
	@sWHERE  nvarchar(4000)

-----BUOC 1: XAC DINH LOAI TIEN TE MA PHUONG PHAP TINH LUONG SU DUNG			

Set @PayrollMethodID = case when @lstPayrollMethodID = '%' then  ' like ''' + @lstPayrollMethodID + ''''  else ' in (''' + replace(@lstPayrollMethodID, ',',''',''') + ''')' end 
Set @Pos=PATINDEX('%,%', @PayrollMethodID)

If @Pos <>0 Or  @lstPayrollMethodID = '%'-----neu in theo nhieu PP tinh luong 
	Begin
	Set @RateExchange=1
	Set @Currency='VND'
	Set @Currency1='USD'
	End	
Else
	Begin
		Select @RateExchange= IsNull(RateExchange,1)  From HT0000 Where DivisionID=@DivisionID
		Select @Currency= CurrencyID From HT5000 Where PayrollMethodID=@lstPayrollMethodID AND DivisionID = @DivisionID 
		If  @Currency='VND' 
			Set @Currency1='USD' 
		else 
			Set @Currency1='VND'

	End

Select @sSQL = ''
Set @sColumn=''
Select @Count = Max(ColumnID) From HT4712 Where ReportCode = @ReportCode AND DivisionID = @DivisionID 


--------BUOC 2: XAC DINH CO NHOM THEO PHONG BAN CAN IN LUONG


Set @sSQL1=' Select T00.DivisionID, T00.DepartmentID,  T01.DepartmentName,  '''' as TeamID,
					'''' as TeamName, '''' as EmployeeID, '''' as FullName, '''' as DutyID,
					 ''''  AS DutyName, 0 as Orders, 2 as Groups, sum(Isnull(SA01,0)) as BaseSalary,
	Max(HV1400.WorkDate),Max(HV1400.LeaveDate),Max(HV1400.CountryName),Max(HT04.TargetName),Max(HT05.TargetName),Max(HT06.TargetName) ,Max(HT07.TargetName),Null,
	HV1400.Birthday, HV1400.PersonalTaxID, HV1400.EducationLevelID, HV1400.EducationLevelName, HV1400.MajorID, HT1004.MajorName, HV1400.ShortName, HV1400.Alias,
	HV1400.ExpenseAccountID, HV1400.PayableAccountID, HV1400.PerInTaxID, T00.TranMonth, T00.TranYear'

Set @sGroupBy=' Group by T00.DivisionID, T00.DepartmentID,  T01.DepartmentName, HV1400.Birthday, HV1400.PersonalTaxID, HV1400.EducationLevelID,
		HV1400.EducationLevelName, HV1400.MajorID, HT1004.MajorName, HV1400.ShortName, HV1400.Alias,
		HV1400.ExpenseAccountID, HV1400.PayableAccountID, HV1400.PerInTaxID, T00.TranMonth, T00.TranYear'			

Set @sSQL2=  ' From HV3400 T00 left join AT1102 T01 on T01.DivisionID = T00.DivisionID and T01.DepartmentID = T00.DepartmentID 
		left join HT1101 T11 on T11.DivisionID = T00.DivisionID and T11.DepartmentID = T00.DepartmentID and IsNull(T00.TeamID,'''')=IsNull(T11.TeamID,'''')
		left join HT1102 T12 on IsNull(T00.DutyID,'''')=IsNull(T12.DutyID,'''')
		----Begin Cutomize cho PeopleLink - Su dung chi tieu 04-05-06-07	
		left join HV1400 on HV1400.EmployeeID = T00.EmployeeID And HV1400.DivisionID = T00.DivisionID
		left join HT1014 HT04 on HT04.DivisionID = HV1400.DivisionID and HT04.TargetID = HV1400.Target04ID And HT04.TargetTypeID=''T04''
		left join HT1014 HT05 on HT05.DivisionID = HV1400.DivisionID and HT05.TargetID = HV1400.Target05ID And HT05.TargetTypeID=''T05''
		left join HT1014 HT06 on HT06.DivisionID = HV1400.DivisionID and HT06.TargetID = HV1400.Target06ID And HT06.TargetTypeID=''T06''
		left join HT1014 HT07 on HT07.DivisionID = HV1400.DivisionID and HT07.TargetID = HV1400.Target07ID And HT07.TargetTypeID=''T07''
		left join HT1004 on HV1400.DivisionID = HT1004.DivisionID And HV1400.MajorID = HT1004.MajorID		
		----End Cutomize cho PeopleLink - Su dung chi tieu 04-05-06-07	
			Where T00.DivisionID = ''' + @DivisionID + ''' and
			T00.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
			isnull(T00.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
			T00.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
			T00.TranMonth + T00.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as varchar(10)) + ' and ' +  
			cast(@ToMonth + @ToYear*100 as varchar(10)) + ' and
			PayrollMethodID ' + @PayrollMethodID 

Delete  HT7110
Exec ( 'Insert into HT7110 ( DivisionID,DepartmentID, DepartmentName, TeamID, TeamName, EmployeeID, FullName, DutyID, DutyName,
				Orders, Groups, BaseSalary,WorkDate,LeaveDate,CountryName,Parameter01,Parameter02,Parameter03,Parameter04,Parameter05, Birthday, PersonalTaxID,
				EducationLevelID, EducationLevelName, MajorID, MajorName, ShortName, Alias,
				ExpenseAccountID, PayableAccountID, PerInTaxID, TranMonth, TranYear)' + @sSQL1+@sSQL2+@sGroupBy)

IF not exists (Select Top 1 1 From HT7110 WHERE DivisionID = @DivisionID ) 

Insert into HT7110  (DivisionID, DepartmentID, DepartmentName,EmployeeID, FullName, Groups,WorkDate,LeaveDate,CountryName,Parameter01,Parameter02,Parameter03,Parameter04,Parameter05, Birthday, PersonalTaxID,
					EducationLevelID, EducationLevelName, MajorID, MajorName, ShortName, Alias, ExpenseAccountID, PayableAccountID, PerInTaxID, TranMonth, TranYear)
Select Distinct  HT2400.DivisionID, HT2400.DepartmentID, AT1102.DepartmentName,HV1400.EmployeeID, HV1400.FullName, 1 as Groups,
		HV1400.WorkDate,HV1400.LeaveDate,HV1400.CountryName,HT04.TargetName AS Parameter01,HT05.TargetName AS Parameter02,HT06.TargetName AS Parameter03,HT07.TargetName AS Parameter04,NULL AS Parameter05, HV1400.Birthday, HV1400.PersonalTaxID,
		HV1400.EducationLevelID, HV1400.EducationLevelName, HV1400.MajorID, HT1004.MajorName, HV1400.ShortName, HV1400.Alias, HV1400.ExpenseAccountID, HV1400.PayableAccountID, HV1400.PerInTaxID, HT2400.TranMonth, HT2400.TranYear
From HT2400 
	left join HV1400 on HV1400.EmployeeID = HT2400.EmployeeID And HV1400.DivisionID = HT2400.DivisionID
	left join HT1014 HT04 on HT04.DivisionID = HV1400.DivisionID And HT04.TargetID = HV1400.Target04ID And HT04.TargetTypeID='T04'
	left join HT1014 HT05 on HT05.DivisionID = HV1400.DivisionID And HT05.TargetID = HV1400.Target05ID And HT05.TargetTypeID='T05'
	left join HT1014 HT06 on HT06.DivisionID = HV1400.DivisionID And HT06.TargetID = HV1400.Target06ID And HT06.TargetTypeID='T06'
	left join HT1014 HT07 on HT07.DivisionID = HV1400.DivisionID And HT07.TargetID = HV1400.Target07ID And HT07.TargetTypeID='T07'	
	inner join AT1102 on  AT1102.DivisionID = HT2400.DivisionID and AT1102.DepartmentID = HT2400.DepartmentID
	left join HT1004 on HV1400.DivisionID = HT1004.DivisionID And HV1400.MajorID = HT1004.MajorID
Where HT2400.DivisionID =  @DivisionID and
	HT2400.DepartmentID between  @FromDepartmentID  and  @ToDepartmentID  and
	isnull(HT2400.TeamID,'') like isnull(@TeamID , '') and
	HT2400.EmployeeID between @FromEmployeeID  and  @ToEmployeeID and
	HT2400.TranMonth + HT2400.TranYear*100 between  cast(@FromMonth + @FromYear*100 as varchar(10)) and   
	cast(@ToMonth + @ToYear*100 as varchar(10)) 


------------------BUOC 3: FETCH TUNG COT TRONG HT4712 DE TINH TOAN

Select @sCaption='',		@IsHT2400 = 0, @IsHT2401 = 0, @IsHT2402 = 0,  @IsHT3400 = 0, @IsOT = 0, 
	@sSQL_HT3400 = '',  @sSQL_HT3400GA = ''

SET @cur = Cursor Scroll KeySet FOR 
	Select 	 ColumnID, FOrders, Caption,  isnull(AmountType,'') as AmountType , isnull(AmountTypeFrom, '') as AmountTypeFrom , isnull(AmountTypeTo,'') as AmountTypeTo , 
		Signs, IsNull(IsSerie,0) as IsSerie, 
		isnull( OtherAmount,0), IsNull(IsChangeCurrency,0) as IsChangeCurrency

	FROM HT4712 Where ReportCode =@ReportCode and IsNull(IsTotal,0)=0  AND DivisionID = @DivisionID  Order by ColumnID
OPEN	@cur
FETCH NEXT FROM @cur INTO  @ColumnID,  @FOrders, @Caption, @AmountType, @AmountTypeFrom, @AmountTypeTo,
						@Signs, @IsSerie, @OtherAmount, @IsChangeCurrency

WHILE @@Fetch_Status = 0		
Begin
IF @AmountType <> 'OT'  ----so lieu khong phai la Khac
Begin				
	Exec HP4700 @DivisionID, @AmountTypeFrom, @AmountType, @lstPayrollMethodID, @AmountTypeFromOut output, @TableName output, @sWHERE output
	Exec HP4700  @DivisionID, @AmountTypeTo, @AmountType, @lstPayrollMethodID, @AmountTypeToOut output,  @TableName output, @sWHERE output
	Exec HP4701 @DivisionID, @AmountTypeFromOut, @AmountTypeToOut, @Signs,  @IsSerie, @IsChangeCurrency, 
			@Currency, @Currency1, @RateExchange, @ColumnAmount output						
	
IF @TableName = 'HT2400'
		BEGIN
		Set @sSQL_HT2400 ='Update HT7110 Set 
							ColumnAmount' +(Case when @FOrders <10 then '0' else '' End)+ltrim(rtrim(str(@FOrders)))	+ '=  A
					 From HT7110 left  join (Select DivisionID, DepartmentID, sum(' + @ColumnAmount + ') as A 
						From HT2400  HV3400
						Where HV3400.DivisionID = ''' + @DivisionID + ''' and
						HV3400.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
						isnull(HV3400.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
						HV3400.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
						HV3400.TranMonth + HV3400.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as varchar(10)) + ' and ' +  
						cast(@ToMonth + @ToYear*100 as varchar(10)) + ' 
						Group by DivisionID, DepartmentID)	HV3400 on HT7110.DivisionID=HV3400.DivisionID and 
						HT7110.DepartmentID=HV3400.DepartmentID'
		EXEC(@sSQL_HT2400)
		END
	ELSE 
		IF @TableName = 'HT2401'
			BEGIN	
			Set @sSQL_HT2401='Update HT7110 Set ColumnAmount' +(Case when @FOrders <10 then '0' else '' End)+ltrim(rtrim(str(@FOrders)))	
						+ '=' + @ColumnAmount +' 
					 From HT7110 left  join (Select  DivisionID, DepartmentID, 
						sum(isnull(AbsentAmount, 0)) as AbsentAmount
					From HT2401 HV3400
					Where AbsentTypeID between ''' + @AmountTypeFrom + ''' and ''' + @AmountTypeTo  + ''' and 
						HV3400.DivisionID = ''' + @DivisionID + ''' and
						HV3400.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
						isnull(HV3400.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
						HV3400.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
						HV3400.TranMonth + HV3400.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as varchar(10)) + ' and ' +  
						cast(@ToMonth + @ToYear*100 as varchar(10)) +'
					Group by HV3400.DivisionID, HV3400.DepartmentID) HV3400 on 
						HT7110.DivisionID=HV3400.DivisionID and 
						HT7110.DepartmentID=HV3400.DepartmentID'

			EXEC(@sSQL_HT2401)
			END
		ELSE
			IF @TableName = 'HT2402'
				BEGIN				
				Set @sSQL_HT2402='Update HT7110 Set ColumnAmount' +(Case when @FOrders <10 then '0' else '' End)+ltrim(rtrim(str(@FOrders)))	
						+ '=' + @ColumnAmount +' 
					From HT7110 left  join (Select DivisionID, DepartmentID, sum(isnull(AbsentAmount, 0)) as AbsentAmount
					From HT2402 HV3400
					Where AbsentTypeID between ''' + @AmountTypeFrom + ''' and ''' + @AmountTypeTo  + ''' and 
						HV3400.DivisionID = ''' + @DivisionID + ''' and
						HV3400.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
						isnull(HV3400.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
						HV3400.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
						HV3400.TranMonth + HV3400.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as varchar(10)) + ' and ' +  
						cast(@ToMonth + @ToYear*100 as varchar(10)) +'
					Group by HV3400.DivisionID, HV3400.DepartmentID) HV3400 on 
						HT7110.DivisionID=HV3400.DivisionID and 
						HT7110.DepartmentID=HV3400.DepartmentID'

				EXEC(@sSQL_HT2402)					 
				END
			ELSE
				IF @TableName = 'HT3400' 
					BEGIN
					Set @sSQL_HT3400 ='Update HT7110 Set 
							ColumnAmount' +(Case when @FOrders <10 then '0' else '' End)+ltrim(rtrim(str(@FOrders)))	+ '=  A
					 From HT7110 left  join (Select DivisionID, DepartmentID, sum(' +  @ColumnAmount + ') as A 
						From HT3400  HV3400
						Where HV3400.DivisionID = ''' + @DivisionID + ''' and
						HV3400.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
						isnull(HV3400.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
						HV3400.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
						HV3400.TranMonth + HV3400.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as varchar(10)) + ' and ' +  
						cast(@ToMonth + @ToYear*100 as varchar(10)) + '  and
						PayrollMethodID ' + @PayrollMethodID  + @sWHERE + '
						Group by DivisionID, DepartmentID)	HV3400 on HT7110.DivisionID=HV3400.DivisionID and 
						HT7110.DepartmentID=HV3400.DepartmentID'

					EXEC (@sSQL_HT3400)
					END
					IF @TableName = 'HT0338' --- Thuế TNCN                            
					 BEGIN
                 		SET @sSQL_HT0338 = '
                 		UPDATE HT7110 
                 		SET ColumnAmount' + ( CASE WHEN @FOrders < 10 THEN '0' ELSE '' END ) + ltrim(rtrim(str(@FOrders))) + '=  VAT
	 					FROM HT7110 
	 					LEFT  JOIN (SELECT	DivisionID, EmployeeID,
											SUM(' + @ColumnAmount + ') AS VAT
									FROM	HT0338  HT0338
									WHERE	HT0338.DivisionID = ''' + @DivisionID + ''' and
											HT0338.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
											HT0338.TranMonth + HT0338.TranYear*100 between ' + CAST(@FromMonth + @FromYear * 100 AS nvarchar(10)) + ' and ' + CAST(@ToMonth + @ToYear * 100 AS nvarchar(10)) + ' 
											' + @sWHERE + '
									GROUP BY DivisionID, EmployeeID
	 								) HT0338 
	 						ON		HT7110.DivisionID = HT0338.DivisionID AND 
									HT7110.EmployeeID = HT0338.EmployeeID '
															   EXEC ( @sSQL_HT0338 )
					 END
							 
End
	
	Else	----- @AmountType = 'OT'  , so lieu la khac thi lay hang so la so lieu cua mot cot
BEGIN
IF @IsOT = 0
	Select  @IsOT = 1,	 @sSQL='Update HT7110 Set '		
	Set @sSQL = @sSQL+ 'ColumnAmount' +(Case when @FOrders <10 then '0' else '' End)+ltrim(rtrim(str(@FOrders)))	
			+'=' +  ' IsNull('+str(@OtherAmount)+ ',0) ' + ','						

END	
			
FETCH NEXT FROM @cur INTO  @ColumnID,  @FOrders, @Caption, @AmountType, @AmountTypeFrom, @AmountTypeTo,
						@Signs, @IsSerie,  @OtherAmount, @IsChangeCurrency
End
Close @cur


IF @IsOT = 1 
BEGIN
Set @sSQL=Left(@sSQL,len(@sSQL)-1)
Set @sSQL=@sSQL+ ' From HT7110 left  join HV3400 on HT7110.DivisionID=HV3400.DivisionID and HT7110.DepartmentID=HV3400.DepartmentID
	and IsNull(HT7110.TeamID,'''')=IsNull(HV3400.TeamID,'''') 
	Where HV3400.DivisionID = ''' + @DivisionID + ''' and
			HV3400.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
			isnull(HV3400.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
			HV3400.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
			HV3400.TranMonth + HV3400.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as varchar(10)) + ' and ' +  
			cast(@ToMonth + @ToYear*100 as varchar(10)) + ' and
			PayrollMethodID ' + @PayrollMethodID 


Exec (@sSQL)
END
---------Neu co tinh tong 

If exists (select top 1 1 From HT4712 Where IsNull(IsTotal,0)=1 and ReportCode = @ReportCode)
Begin	
	Set @sSQL='Update HT7110 Set '
	SET @cur = Cursor Scroll KeySet FOR 
		Select 	 ColumnID, FOrders, Caption,  Signs, IsNull(IsSerie,0) as IsSerie,   FromColumn, ToColumn 
			FROM HT4712 Where ReportCode =@ReportCode and IsNull(IsTotal,0)=1  Order by ColumnID
	OPEN	@cur
	FETCH NEXT FROM @cur INTO  @ColumnID, @FOrders, @Caption, @Signs, @IsSerie, @FromColumn, @ToColumn

WHILE @@Fetch_Status = 0
Begin	
	Exec	HP4702 @Signs , @IsSerie , @FromColumn, @ToColumn ,  @ColumnAmount  OutPut, @ColumnID
	Set @sSQL = @sSQL+ 'ColumnAmount' +(Case when @FOrders <10 then '0' else '' End)+ltrim(rtrim(str(@FOrders)))	
					+ '=' + @ColumnAmount ---+ ','
	exec (@sSQL)
	Set @sSQL='Update HT7110 Set '
FETCH NEXT FROM @cur INTO  @ColumnID, @FOrders,  @Caption, @Signs, @IsSerie, @FromColumn, @ToColumn

End
Close @cur
End
DELETE HT7110 WHERE  
isnull(ColumnAmount01,0)=0 AND  isnull(ColumnAmount02,0)=0 AND isnull(ColumnAmount03,0)=0  AND  isnull(ColumnAmount04,0)=0 AND isnull(ColumnAmount05,0)=0 AND  
isnull(ColumnAmount06,0)=0 AND  isnull(ColumnAmount07,0)=0 AND isnull(ColumnAmount08,0)=0  AND  isnull(ColumnAmount09,0)=0 AND isnull(ColumnAmount10,0)=0 AND  
isnull(ColumnAmount11,0)=0 AND  isnull(ColumnAmount12,0)=0 AND isnull(ColumnAmount13,0)=0  AND  isnull(ColumnAmount14,0)=0 AND isnull(ColumnAmount15,0)=0 AND  
isnull(ColumnAmount16,0)=0 AND  isnull(ColumnAmount17,0)=0 AND isnull(ColumnAmount18,0)=0  AND  isnull(ColumnAmount19,0)=0 AND isnull(ColumnAmount20,0)=0 AND  
isnull(ColumnAmount21,0)=0 AND  isnull(ColumnAmount22,0)=0 AND isnull(ColumnAmount23,0)=0  AND  isnull(ColumnAmount24,0)=0 AND isnull(ColumnAmount25,0)=0 AND  
isnull(ColumnAmount26,0)=0 AND  isnull(ColumnAmount27,0)=0 AND isnull(ColumnAmount28,0)=0  AND  isnull(ColumnAmount29,0)=0 AND isnull(ColumnAmount30,0)=0 AND  
isnull(ColumnAmount31,0)=0 AND  isnull(ColumnAmount32,0)=0 AND isnull(ColumnAmount33,0)=0  AND  isnull(ColumnAmount34,0)=0 AND isnull(ColumnAmount35,0)=0 AND  isnull(ColumnAmount36,0)=0 AND  isnull(ColumnAmount37,0)=0 AND isnull(ColumnAmount38,0)=0  AND  isnull(ColumnAmount39,0)=0 AND isnull(ColumnAmount40,0) =0 AND
isnull(ColumnAmount41,0)=0 AND  isnull(ColumnAmount42,0)=0 AND isnull(ColumnAmount43,0)=0  AND  isnull(ColumnAmount44,0)=0 AND isnull(ColumnAmount45,0)=0 AND  isnull(ColumnAmount46,0)=0 AND  isnull(ColumnAmount47,0)=0 AND isnull(ColumnAmount48,0)=0  AND  isnull(ColumnAmount49,0)=0 AND isnull(ColumnAmount50,0) =0


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
