IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2461]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2461]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


----Created by: Vo Thanh Huong
----Created date: 29/06/2004
----purpose: Tinh BHXH, BHYT, KPCD
----Edit by: Dang Le Bao Quynh; 10/01/2008
----Purpose: Tinh BHXH trong truong hop muc luong dong BHXH > 10800000
----Edit by: Tr.Dung; 11/03/2011
----Purpose: Bo han che muc luong dong BHXH > 10800000
---- Modified on 20/12/2012 by Lê Thị Thu Hiền : Kiểm tra @Condition = ''

CREATE PROCEDURE [dbo].[HP2461] 
	@EmployeeID nvarchar(50), 
	@DivisionID nvarchar(50),  
	@DepartmentID nvarchar(50),	  
	@ToDepartmentID nvarchar(50), 
	@TeamID nvarchar(50),
	@SRate money,	 
	@HRate money, 
	@TRate money, 
	@SRate2 money, 
	@HRate2 money, 
	@TRate2 money,
	@BaseSalaryFieldID nvarchar(50),	
	@BaseSalary money, 
	@IsGeneralCo tinyint, 
	@GeneralCoID nvarchar(50), 
	@IsGeneralAbsent tinyint, 
	@GeneralAbsentID nvarchar(50), 
	@AbsentAmount money,
	@TranMonth int, 
	@TranYear int,	
	@CalDate datetime, 
	@CreateUserID nvarchar(50), 
	@Condition nvarchar(1000)=''

AS
DECLARE @cur_HT2460 cursor, 	
		@cur_HT2461 cursor,	
		@TempMonth int,	
		@TempYear int,
		@InsurID  nvarchar(50),	
		@IsS tinyint,	
		@IsH tinyint,	
		@IsT tinyint,
		@GeneralCo as money,	
		@Temp as nvarchar(50),	
		@ListOfCo as nvarchar(4000),	
		@TimeConvert int,
		@sSQL nvarchar(4000),	
		@Type tinyint,	
		@Days int,	
		@sSQL_AbsentAmount nvarchar(4000),
		@sSQL_AbsentAmount1 nvarchar(200), 	
		@IsMonth tinyint,	
		@FromDate int,
		@ToDate int,	
		@GeneralAbsent money,	
		@AbsentAmount0 money
--PRINT(@Condition)
SELECT  @TempYear = cast(@TranYear as nvarchar(4)), 
		@TempMonth = case when @TranMonth < 10 then  '0' else '' end  + cast(@TranMonth as nvarchar(2))

----Xac dinh luong dong BHXH
Set @Temp = case when @BaseSalaryFieldID = 'Others' then cast(@BaseSalary as nvarchar(50)) else  'HT00.' + ltrim(rtrim( @BasesalaryFieldID))  end +
								 ' as BaseSalary'

---Xac dinh ngay cong tong hop 
Select @sSQL_AbsentAmount = '',  
@sSQL_AbsentAmount1 = ''
If @IsGeneralAbsent = 1
Begin	

	Select @TimeConvert = TimeConvert  
	FROM HT0000 
	Where DivisionID = @DivisionID
	Select	@Type = Type, 
			@Days = Days , 
			@IsMonth = IsMonth,  
			@FromDate = FromDate, 
			@ToDate = ToDate  
	From	HT5002 
	Where	GeneralAbsentID =@GeneralAbsentID 
			and DivisionID = @DivisionID
			
	Select	@Type = isnull(@Type,0) , 
			@Days =  isnull(@Days, 24), 
			@AbsentAmount = isnull(@AbsentAmount, 1)
	
	If @IsMonth =1
	Begin
	If @Type =0 ---Ngay công nhat
		Set @sSQL_AbsentAmount = N'
		Select HT2402.DivisionID, EmployeeID,
				Sum(AbsentAmount/ CASE WHEN UnitID = ''' + 'H''' + ' THEN '+ STR(@TimeConvert) +'  ELSE 1 END ) as AbsentAmount
		From	HT2402  
		inner join HT1013 on HT2402.AbsentTypeID = HT1013.AbsentTypeID	And HT2402.DivisionID = HT1013.DivisionID			
		Where 	HT2402.AbsentTypeID in (Select AbsentTypeID From HT5003 Where GeneralAbsentID ='''+@GeneralAbsentID+''' AND DivisionID = '''+@DivisionID+''')  AND
				TranMonth = ' + cast(@TranMonth as nvarchar(2))+' AND
				TranYear = ' + cast(@TranYear as nvarchar(4))  + '
				and HT2402.DivisionID = '''+@DivisionID+'''
		Group by HT2402.DivisionID, EmployeeID '

	Else	---- Cong loai tru
		Set @sSQL_AbsentAmount = '
		Select 	HT2460.DivisionID, HT2460.EmployeeID,' + 
				cast(@Days as nvarchar(10)) + ' + + Sum( Case when isnull(TypeID,'''') in ( ''G'', ''P'' )  then - isnull(AbsentAmount,0) else 
				Case When  isnull(TypeID,'''') =''T'' then isnull(AbsentAmount,0) else 0 end  end/ 
				CASE WHEN UnitID = ''' + 'H''' + ' THEN '+ cast(@TimeConvert  as nvarchar(10)) + ' ELSE 1 END ) as AbsentAmount
		From HT2460 	
		Left join 	HT2402 
			on		HT2402.EmployeeID = HT2460.EmployeeID AND
					 HT2402.DepartmentID = HT2460.DepartmentID AND
					 isnull(HT2402.TeamID,'''') = isnull(HT2460.TeamID,'''') AND
					 HT2402.DivisionID = HT2460.DivisionID AND
					 HT2402.TranMonth = HT2460.TranMonth AND
					 HT2402.TranYear = HT2460.TranYear
					 AND HT2402.DivisionID = HT2460.DivisionID
		Left  join 	( Select	DivisionID,AbsentTypeID , TypeID, UnitID 
		           	  From		HT1013 
		           	  Where		IsMonth = 1 
		           	  AND DivisionID = '''+@DivisionID+''' 
		           	  AND AbsentTypeID in (Select AbsentTypeID 
		           	                       From HT5003 
		           	                       Where GeneralAbsentID  ='''+@GeneralAbsentID+''' 
		           									and DivisionID = '''+@DivisionID+''' ) ) as H
			on  H.AbsentTypeID = HT2402.AbsentTypeID AND H.DivisionID = HT2402.DivisionID
		Where 	HT2460.TranMonth = ' + cast(@TranMonth as nvarchar(2))+' AND
			HT2460.TranYear = ' + cast(@TranYear as nvarchar(4)) + '  AND
			HT2460.DivisionID = ''' + @DivisionID + ''' AND
			HT2460.DepartmentID between ''' + @DepartmentID + '''  AND   ''' + @ToDepartmentID + '''
			'+CASE WHEN ISNULL(@Condition,'') <> '' THEN ' AND isnull(HT2460.DepartmentID,''#'') in ('+@Condition+')' ELSE '' END +' 
			and  isnull(HT2460.TeamID, '''') like isnull(''' + @TeamID + ''', '''') AND 
			HT2460.EmployeeID like ''' + @EmployeeID + '''
		Group by HT2460.DivisionID, HT2460.EmployeeID '

	End

	Else --- Tu cham cong ngay
	Begin
	If @Type =0 --- Luong cong nhat
		Set @sSQL_AbsentAmount='
		Select 	
			HT2401.DivisionID, EmployeeID,
			Sum(AbsentAmount*ConvertUnit/ CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + STR(@TimeConvert) + ' ELSE 1 END) as AbsentAmount
		From HT2401 inner join HT1013 on HT2401.AbsentTypeID = HT1013.AbsentTypeID AND HT2401.DivisionID = HT1013.DivisionID
		Where 	HT2401.AbsentTypeID in (Select AbsentTypeID From HT5003 Where GeneralAbsentID ='''+@GeneralAbsentID+''' AND DivisionID = '''+@DivisionID+''' )  AND
			TranMonth = ' + cast(@TranMonth as nvarchar(2))+' AND
			TranYear = ' + cast(@TranYear as nvarchar(4))+
			'  AND Day(AbsentDate) between ''' + str(@FromDate) + ''' AND ''' + str(@ToDate) + '''
			 AND HT2401.DivisionID = '''+@DivisionID+'''
		Group by HT2401.DivisionID, EmployeeID'
	
	Else	---- Cong loai tru
		Set @sSQL_AbsentAmount = '
		Select 	HT2460.DivisionID, HT2460.EmployeeID,
			' + cast(@Days as nvarchar(10))+' + + Sum( Case when isnull(TypeID,'''') in ( ''G'', ''P'' )  then - isnull(AbsentAmount*ConvertUnit,0) else 
						 Case When  isnull(TypeID,'''') =''T'' then isnull(AbsentAmount*ConvertUnit,0) else 0 end  end/ 
						CASE WHEN UnitID = ''' + 'H''' + ' THEN ' + cast(@TimeConvert as nvarchar(10)) + ' ELSE 1 END) as AbsentAmount
		From HT2460 	Left join 	HT2401 on HT2401.EmployeeID = HT2460.EmployeeID						
						and HT2401.DepartmentID = HT2460.DepartmentID 
						and isnull(HT2401.TeamID,'''') = isnull(HT2460.TeamID,'''') 
						and HT2401.DivisionID = HT2460.DivisionID 
						and HT2401.TranMonth = HT2460.TranMonth 
						and HT2401.TranYear = HT2460.TranYear
			Left  join 	( Select DivisionID, AbsentTypeID , TypeID, ConvertUnit, UnitID From HT1013 Where IsMonth = 0 AND DivisionID = '''+@DivisionID+''' AND AbsentTypeID in (Select AbsentTypeID From HT5003 Where GeneralAbsentID  ='''+@GeneralAbsentID+''' AND DivisionID ='''+@DivisionID+''' ) ) as H
					on  H.AbsentTypeID = HT2401.AbsentTypeID AND H.DivisionID = HT2401.DivisionID
		Where 	HT2460.TranMonth = ' + cast(@TranMonth as nvarchar(2))+' AND
			HT2460.TranYear = ' + cast(@TranYear as nvarchar(4)) + '  AND
			HT2460.DivisionID = ''' + @DivisionID + ''' AND
			HT2460.DepartmentID between ''' + @DepartmentID + '''  AND  ''' + @ToDepartmentID + ''' 	
			'+CASE WHEN ISNULL(@Condition,'') <> '' THEN ' AND isnull(HT2460.DepartmentID,''#'') in '+@Condition+'' ELSE '' END +'  
			and isnull(HT2460.TeamID, '''') like isnull(''' + @TeamID + ''', '''') AND 
			HT2460.EmployeeID like ''' + @EmployeeID + '''
		Group by  HT2460.DivisionID, HT2460.EmployeeID'
	End	
PRINT(@sSQL_AbsentAmount)
	If exists(Select Top 1 1 From sysObjects Where XType = 'V' AND Name = 'HV2462')
		DROP VIEW HV2462 
		EXEC('Create view HV2462 ----tao boi HP2461
				as ' + @sSQL_AbsentAmount)

	Set @sSQL_AbsentAmount = ', HV2462.AbsentAmount '	
	Set @sSQL_AbsentAmount1 = ' left join HV2462 on HV2462.EmployeeID = HT00.EmployeeID AND HV2462.DivisionID = HT00.DivisionID '
End
else
	Set @sSQL_AbsentAmount = ', 1 as AbsentAmount '
--//ket thuc tinh ngay cong tong hop

-----Xac dinh he so chung 
IF @IsGeneralCo = 1 
	BEGIN
	 Set @ListOfCo =''
	 Set @ListOfCo =@ListOfCo+'( '  + (Select top 1  'isnull( '+isnull(C01ID,'') +',0) '+ 
				(Case when isnull(C02ID,'') <>'' then '+ isnull('+isnull(C02ID,'')+',0)' else '' end)+
				(Case when isnull(C03ID,'') <>'' then '+ isnull('+isnull(C03ID,'')+',0)'  else '' end)+
				(Case when isnull(C04ID,'') <>'' then '+ isnull('+isnull(C04ID,'')+',0)'  else '' end)+
				(Case when isnull(C05ID,'') <>'' then '+ isnull('+isnull(C05ID,'')+',0)'  else '' end)
				 From HT5001 Where GeneralCoID = @GeneralCoID AND DivisionID = @DivisionID Order by LineID )+')'

	if Exists (Select top 1 1   From HT5001 Where GeneralCoID = @GeneralCoID AND LineID = 2 AND DivisionID = @DivisionID)
		  Set @ListOfCo =@ListOfCo+ (Select top 1 [Sign]+'('+' isnull('+isnull(C01ID,'')+',0)'  + 
					(Case when isnull(C02ID,'') <>'' then '+ isnull('+isnull(C02ID,'')+',0)'  else '' end)+
					(Case when isnull(C03ID,'') <>'' then '+ isnull('+isnull(C03ID,'')+',0)'  else '' end)+
					(Case when isnull(C04ID,'') <>'' then '+ isnull('+isnull(C04ID,'')+',0)'  else '' end)+
					(Case when isnull(C05ID,'') <>'' then '+ isnull('+isnull(C05ID,'')+',0)'  else '' end)
					 From HT5001 Where GeneralCoID = @GeneralCoID  AND DivisionID = @DivisionID AND LineID =2 )+')'

	if Exists (Select top 1 1   From HT5001 Where GeneralCoID = @GeneralCoID AND LineID =3 AND DivisionID = @DivisionID)
		  Set @ListOfCo =@ListOfCo+ (Select top 1 [Sign]+'('+' isnull('+isnull(C01ID,'')+',0)' +
					(Case when isnull(C02ID,'') <>'' then '+ isnull('+isnull(C02ID,'')+',0)'  else '' end)+
					(Case when isnull(C03ID,'') <>'' then '+ isnull('+isnull(C03ID,'')+',0)' else '' end)+
					(Case when isnull(C04ID,'') <>'' then '+ isnull('+isnull(C04ID,'')+',0)'  else '' end)+
					(Case when isnull(C05ID,'') <>'' then '+ isnull('+isnull(C05ID,'')+',0)'  else '' end)
					 From HT5001 Where GeneralCoID = @GeneralCoID AND DivisionID = @DivisionID AND LineID =3 )+')'

	if Exists (Select top 1 1   From HT5001 Where GeneralCoID = @GeneralCoID AND LineID =4 AND DivisionID = @DivisionID)
		  Set @ListOfCo =@ListOfCo+ (Select top 1 [Sign]+'(' +' isnull('+isnull(C01ID,'')+',0)' +
					(Case when isnull(C02ID,'') <>'' then '+ isnull('+isnull(C02ID,'')+',0)'  else '' end)+
					(Case when isnull(C03ID,'') <>'' then '+ isnull('+isnull(C03ID,'')+',0)'  else '' end)+
					(Case when isnull(C04ID,'') <>'' then '+ isnull('+isnull(C04ID,'')+',0)'  else '' end)+
					(Case when isnull(C05ID,'') <>'' then '+ isnull('+isnull(C05ID,'')+',0)'  else '' end)
					 From HT5001 Where GeneralCoID = @GeneralCoID AND DivisionID = @DivisionID AND LineID =4 )+')'

	if Exists (Select top 1 1   From HT5001 Where GeneralCoID = @GeneralCoID AND LineID =5 AND DivisionID = @DivisionID)
	  Set @ListOfCo =@ListOfCo+ (Select top 1 [Sign]+'(' +' isnull('+isnull(C01ID,'')+',0)' +
					(Case when isnull(C02ID,'') <>'' then '+ isnull('+isnull(C02ID,'')+',0)'  else '' end)+
					(Case when isnull(C03ID,'') <>'' then '+ isnull('+isnull(C03ID,'')+',0)'  else '' end)+
					(Case when isnull(C04ID,'') <>'' then '+ isnull('+isnull(C04ID,'')+',0)'  else '' end)+
					(Case when isnull(C05ID,'') <>'' then '+ isnull('+isnull(C05ID,'')+',0)'  else '' end)
					 From HT5001 Where GeneralCoID = @GeneralCoID AND DivisionID = @DivisionID AND LineID =5 )+')'
	
	END
ELSE
	SET @ListOfCo =  ' 1 '
	SET @ListOfCo = @ListOfCo+ ' as GeneralCo'
--//Ket thuc tinh he so chung		
			

SET @sSQL= ' SELECT HT00.EmployeeID, HT00.DivisionID, HT00.DepartmentID, HT00.TeamID, HT00.TranMonth, HT00.TranYear,
				 IsS, IsH, IsT, ' +  @Temp + ',  ' + 
				@ListOfCo + @sSQL_AbsentAmount + '
			FROM HT2460 HT00 left join HT2400 HT01 on HT00.EmployeeID  = HT01.EmployeeID AND HT00.DivisionID  = HT01.DivisionID AND
				 HT00.TranMonth = HT01.TranMonth AND HT00.TranYear = HT01.TranYear ' + 
				@sSQL_AbsentAmount1 + '
			WHERE HT00.DivisionID = ''' + @DivisionID + ''' AND
				HT00.DepartmentID between ''' + @DepartmentID + '''  AND ''' + @ToDepartmentID + '''
				'+CASE WHEN ISNULL(@Condition,'') <> '' THEN ' AND isnull(HT00.DepartmentID,''#'') in '+@Condition+'' ELSE '' END +'  
				And Isnull(HT00.TeamID, ''' + ''' ) like Isnull(''' + @TeamID + ''' , ''' + ''') AND
				HT00.EmployeeID like ''' + @EmployeeID + ''' AND 
				HT00.TranMonth = '+ STR(@TranMonth) + ' AND
				HT00.TranYear  = ' + STR(@TranYear)
PRINT(@sSQL)
if  Exists (Select top 1 1 From SysObjects Where Xtype ='V' AND Name = 'HV2461')
	Drop view HV2461
Exec (' Create View HV2461  ---tao boi HP2461
				as ' + @sSQL)
SET @cur_HT2460 = CURSOR SCROLL KEYSET FOR
		SELECT EmployeeID, DivisionID, DepartmentID, TeamID,
			TranMonth, TranYear, IsS, IsH, IsT, BaseSalary, GeneralCo, AbsentAmount 
		FROM HV2461
		
OPEN @cur_HT2460
FETCH NEXT FROM @cur_HT2460 INTO @EmployeeID, @DivisionID, @DepartmentID, @TeamID,
		@TranMonth, @TranYear, @IsS, @IsH, @IsT, @BaseSalary, @GeneralCo, @GeneralAbsent

WHILE @@FETCH_STATUS = 0
BEGIN
	IF not exists (SELECT TOP 1 1 FROM HT2461 
			WHERE DivisionID = @DivisionID AND
				DepartmentID between @DepartmentID AND  @ToDepartmentID AND
				Isnull(TeamID, '') LIKE  Isnull(@TeamID, '') AND
				EmployeeID = @EmployeeID AND 
				TranMonth = @TranMonth AND
				TranYear  = @TranYear)	
		BEGIN
			EXEC AP0000 @DivisionID,@InsurID OUTPUT, 'HT2461', 'IF', @TempYear, @TempMonth, 15, 3, 0, ''			
	
			INSERT INTO HT2461(EmployeeID,  DivisionID, DepartmentID, TeamID,  InsurID, 
					BaseSalaryfieldID, IsGeneralCo, GeneralCoID, BaseSalary, GeneralCo, GeneralAbsent, AbsentAmount,
					TranMonth,TranYear, CalDate, CreateUserID, CreateDate)
				VALUES(@EmployeeID, @DivisionID, @DepartmentID, @TeamID,  @InsurID,
					@BaseSalaryfieldID, @IsGeneralCo,@GeneralCoID,@BaseSalary,@GeneralCo,@GeneralAbsent, @AbsentAmount,
					@TranMonth,@TranYear, @CalDate, @CreateUserID, GETDATE())
		END	
		Set @AbsentAmount0 = case when @IsGeneralAbsent = 1 then
					 ( @GeneralAbsent/ case when isnull(@AbsentAmount, 0) <> 0 then  @AbsentAmount else 1 end)   

						else 1 end
		UPDATE HT2461 SET 	SRate = CASE WHEN @IsS = 1 THEN @SRate ELSE 0 END,
				SRate2 = CASE WHEN @IsS = 1 THEN @SRate2 ELSE 0 END,
				HRate = CASE WHEN @IsH = 1 THEN @HRate ELSE 0 END,
				HRate2 = CASE WHEN @IsH = 1 THEN @HRate2 ELSE 0 END,
				TRate = CASE WHEN @IsT = 1 THEN @TRate ELSE 0 END,
				TRate2 = CASE WHEN @IsT = 1 THEN @TRate2 ELSE 0 END,
				SAmount = CASE WHEN @IsS = 1 THEN (@BaseSalary*@GeneralCo*@SRate * @AbsentAmount0 /100)  ELSE 0 END,
				SAmount2 = CASE WHEN @IsS = 1 THEN (@BaseSalary*@GeneralCo*@SRate2 * @AbsentAmount0/100)  ELSE 0 END,
				HAmount = CASE WHEN @IsH = 1 THEN (@BaseSalary*@GeneralCo*@HRate * @AbsentAmount0/100)  ELSE 0 END,
				HAmount2 = CASE WHEN @IsH = 1 THEN (@BaseSalary*@GeneralCo*@HRate2 * @AbsentAmount0/100)  ELSE 0 END,
				TAmount = CASE WHEN @IsT = 1 THEN (@BaseSalary*@GeneralCo*@TRate * @AbsentAmount0/100)  ELSE 0 END,
				TAmount2 = CASE WHEN @IsT = 1 THEN (@BaseSalary*@GeneralCo*@TRate2 * @AbsentAmount0/100)  ELSE 0 END,
				GeneralAbsent = @GeneralAbsent, AbsentAmount = @AbsentAmount,
				CalDate = @CalDate
		WHERE DivisionID = @DivisionID AND
				DepartmentID between @DepartmentID AND  @ToDepartmentID AND
				Isnull(TeamID, '') LIKE  Isnull(@TeamID, '') AND
				EmployeeID = @EmployeeID AND 
				TranMonth = @TranMonth AND
				TranYear  = @TranYear	
	
	FETCH NEXT FROM @cur_HT2460 INTO @EmployeeID, @DivisionID, @DepartmentID, @TeamID,
		@TranMonth, @TranYear, @IsS, @IsH, @IsT, @BaseSalary, @GeneralCo, @GeneralAbsent
				
END



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

