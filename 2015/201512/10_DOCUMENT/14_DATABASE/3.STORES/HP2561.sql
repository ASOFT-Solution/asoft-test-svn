/****** Object:  StoredProcedure [dbo].[HP2561]    Script Date: 12/12/2011 20:05:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2561]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2561]
GO

/****** Object:  StoredProcedure [dbo].[HP2561]    Script Date: 12/12/2011 20:05:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----Created by: Vo Thanh Huong
----Created date: 22/07/2004
----purpose: In bao cao danh sach lao dong, quy tien luong dieu chinh muc nop BHXH theo thang
----Modify on 15/08/2013 by Bao Anh: Tach chuoi @sSQL3 thanh @sSQL3 + @sSQL4 (mantis 0020730)
/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2561]  @DivisionID NVARCHAR(50),
				@DepartmentID NVARCHAR(50),	
				@TeamID NVARCHAR(50),
				@TranMonth as int,
				@TranYear as int

AS 
DECLARE @FromMonth int, 
	@ToMonth int,
	@FromMonth0 int,
	@ToMonth0 int,
	@TranYear0 int,
	@sSQL1 nvarchar(4000),
	@sSQL2 nvarchar(4000) ,
	@sSQL3 nvarchar(4000),
	@sSQL4 nvarchar(4000)

IF  @TranMonth = 1 
	Begin
	Set @TranYear0 = @TranYear - 1 
	Set @FromMonth0 = 12
		  
	End
ELSE
	Begin
	Set @TranYear0 = @TranYear 
	Set @FromMonth0 =@TranMonth-1
	
	End

---Danh sach nhan vien nop BHXH thang nay
Set @sSQL1 = 'Select HT00.DivisionID, HT00.EmployeeID, Max(Isnull(SNo, ''' + ''')) as SNo, Max(Isnull(CNo, ''' + ''')) as CNo, Max(Isnull(HospitalID, ''' + ''' )) as HospitalID, 
		 Max(Isnull(HT01.BaseSalary*GeneralCo,0)) as BaseSalary,   
		Max(Isnull(HT01.BaseSalary*GeneralCo,0)) as MaxBS,
		Sum(Isnull(HT01.BaseSalary*GeneralCo,0)) as BS1

		
	From HT2460 HT00 inner join HT2461 HT01 on HT00.DivisionID = HT01.DivisionID And HT00.EmployeeID = HT01.EmployeeID and 
			HT00.TranMonth = HT01.TranMonth and HT01.TranYear = HT01.TranYear
	Where HT00.DivisionID = ''' + @DivisionID + ''' and
		HT00.DepartmentID like ''' + @DepartmentID + ''' and
		Isnull(HT00.TeamID, ''' + ''') like Isnull('''+ @TeamID + ''', ''' + ''') and 
		HT00.TranMonth = ' +STR(@TranMonth) +  ' and
		HT00.TranYear = ' + STR(@TranYear) + '
	Group by HT00.DivisionID, HT00.EmployeeID' 


---Danh sach nhan vien nop BHXH thang truoc
Set @sSQL2 =  'Select HT00.DivisionID, HT00.EmployeeID,  Max(Isnull(SNo,''' + ''')) as SNo, Max(Isnull(CNo,''' + ''')) as CNo, Max(Isnull(HospitalID,''' + ''')) as HospitalID,
		Max(Isnull(HT01.BaseSalary*GeneralCo,0)) as BaseSalary, 
		Sum(Isnull( HT01.BaseSalary*GeneralCo ,0)) as BS0
	From HT2460 HT00 inner join HT2461 HT01  on  HT00.DivisionID = HT01.DivisionID and HT00.EmployeeID = HT01.EmployeeID and
		HT00.TranMonth = HT01.TranMonth and HT00.TranYear = HT01.TranYear 
	Where HT00.DivisionID = ''' + @DivisionID + ''' and
		HT00.DepartmentID like ''' + @DepartmentID + ''' and
		Isnull(HT00.TeamID, ''' + ''') like Isnull('''+ @TeamID + ''', ''' + ''' ) and
		HT00.TranMonth = ' +STR(@FromMonth0) + ' and
		HT00.TranYear = ' + STR(@TranYear0) + '
	Group by HT00.DivisionID, HT00.EmployeeID' 

--print @sSQL2

If not exists (Select Top 1 1 From SysObjects Where Xtype = 'V' and Name = 'HV2561' )
	EXEC('Create View HV2561 ---tao boi HP2561
			as ' + @sSQL1)
else
	EXEC('Alter View HV2561 ---tao boi HP2561
			as ' + @sSQL1)

If not exists (Select Top 1 1 From SysObjects Where Xtype = 'V' and Name = 'HV2562' )
	EXEC('Create View HV2562 ---tao boi HP2561
			as ' + @sSQL2)
else
	EXEC('Alter View HV2562 ---tao boi HP2561
			as ' + @sSQL2)
Set @sSQL3 = 
	---tang moi
	case when exists(Select Top 1 1 From HV2561 Where DivisionID = @DivisionID) then
	' Select HV00.DivisionID, HV00.EmployeeID, Status = 1,
			0 as BaseSalary1, HV00.BaseSalary as BaseSalary2, 
			Isnull(''' + 'HÑ T'''  + ' + ltrim(rtrim(Month(SignDate))) + ltrim(rtrim(year(SignDate))), ''' + ''') as Notes, 	
			HV01.Orders, CNo, SNo, IsMale, Birthday, FullName, HT00.HospitalName, FullAddress, DutyName		
		From HV2561 HV00 inner join HV1400 HV01 on HV00.EmployeeID = HV01.EmployeeID and HV00.DivisionID = HV01.DivisionID
			left join HT1009 HT00 on HV00.HospitalID = HT00.HospitalID and HV00.DivisionID = HT00.DivisionID
			left join (Select DivisionID,EmployeeID, min(Isnull(SignDate,''' + ''')) as SignDate From HT1360 Where DivisionID = '''+@DivisionID+''' group by DivisionID,EmployeeID) HT01
				 on HV00.EmployeeID = HT01.EmployeeID and HV00.DivisionID = HT01.DivisionID
		Where HV00.DivisionID = ''' + @DivisionID + ''' and 
			HV00.EmployeeID not in (Select EmployeeID From HV2562)
	Union ' 
	else ''
	end

Set @sSQL3 = @sSQL3 + 
	-----giam
	case When exists(select Top 1 1 From HV2562 Where DivisionID = @DivisionID)  then
	'Select HV00.DivisionID, HV00.EmployeeID, Status = 3,
			HV00.BaseSalary as BaseSalary1, 0 as BaseSalary2, Case When EmployeeStatus = 9 Then ''' + 'Nghæ vieäc''' + ' else ''' + '''
			end as Notes,
			HV01.Orders, CNo, SNo, IsMale, Birthday, FullName, HT.HospitalName, FullAddress,  DutyName
		From HV2562 HV00 inner join HV1400 HV01 on HV00.EmployeeID = HV01.EmployeeID and HV00.DivisionID = HV01.DivisionID
			left join HT1009 HT on HV00.HospitalID = HT.HospitalID and HV00.DivisionID = HT.DivisionID
		Where HV00.DivisionID = ''' + @DivisionID + ''' and 
			HV00.EmployeeID not in (Select EmployeeID From HV2561)	
	Union '
	else ''
	end

Set @sSQL3 = @sSQL3 + 
	case when exists (select Top 1 1 from HV2561 Where DivisionID = @DivisionID) then 										
	------tang luong
	' Select HV00.DivisionID, HV00.EmployeeID,5 as Status, 
			Case When  (BS0 < MaxBS and BS1 = MaxBS and BS0 <> 0) Then BS0
			 Else BS1 End as BaseSalary1,
			MaxBS as BaseSalay2, ''' + 'Taêng löông''' + ' as Notes, 
			HV02.Orders, HV00.CNo, HV00.SNo, IsMale, Birthday, FullName, HT.HospitalName, FullAddress, DutyName
		From HV2561 HV00 inner join HV2562 Hv01 on HV00.EmployeeID = HV01.EmployeeID and HV00.DivisionID = HV01.DivisionID
			inner join HV1400 HV02 on HV02.EmployeeID = HV00.EmployeeID and HV02.DivisionID = HV00.DivisionID 
			left  join HT1009 HT on HT.HospitalID = HV00.HospitalID and HT.DivisionID = HV00.DivisionID
		Where HV00.DivisionID = ''' + @DivisionID + ''' and 
		HV00.EmployeeID in (Select EmployeeID From HV2562)  and
			(BS0 < MaxBS and BS1 = MaxBS and BS0 <> 0) 
	Union	' 
	else ''
	end

Set @sSQL3 = @sSQL3 + 
	case when exists (select Top 1 1 From HV2562 Where DivisionID = @DivisionID) then 										
	----giam luong
	' Select HV00.DivisionID, HV00.EmployeeID, 5 as Status, 
			Case When  (BS0 >  BS1 and BS1= MaxBS and BS1 <> 0) Then BS0 
			 Else BS1 End as BaseSalary1,
			Case When  (BS0 > BS1 and BS1= MaxBS and BS1<> 0) Then BS1 
			 Else BS0 End as BaseSalary2,
			 ''' + 'Giaûm  löông''' + ' as Notes,
			HV02.Orders, HV00.CNo, HV00.SNo, IsMale, Birthday, FullName, HT.HospitalName, FullAddress,  DutyName
		From HV2561 HV00 inner join HV2562 HV01 on HV00.EmployeeID = HV01.EmployeeID and HV00.DivisionID = HV01.DivisionID
			inner join HV1400 HV02 on HV02.EmployeeID = HV00.EmployeeID and HV02.DivisionID = HV00.DivisionID 
			left join HT1009 HT on HT.HospitalID = HV00.HospitalID and HT.DivisionID = HV00.DivisionID
		Where HV00.DivisionID = ''' + @DivisionID + ''' and 
			HV00.EmployeeID in (Select EmployeeID From HV2562)  and
			(BS0 >  BS1 and BS1= MaxBS and BS1 <> 0)  
			
	Union ' 
	else ''
	end

Set @sSQL4 = 
---	tinh tong so lao dong, luong thang truoc
	'Select ''' + @DivisionID + ''' AS DivisionID, ''' + ''' as EmployeeID, 6 as Status, Count(EmployeeID) as BaseSalaty1, Sum(BS0) as BaseSalary2,
		''' + '''  as Notes, 0 as Orders, ''' + ''' as CNo, ''' + ''' as SNo, ''' + ''' as IsMale, ''' + ''' as Birthday, ''' + '''
		 as FullName, ''' + ''' as HospitalName, ''' + ''' as FullAddress, ''' + ''' as  DutyName
	From HV2562

	Union ' +					
---	tinh tong so lao dong, luong thang nay
	' Select ''' + @DivisionID + ''' AS DivisionID,''' + ''' as EmployeeID, 7 as Status, Count(EmployeeID) as BaseSalaty1, Sum(BS1) as BaseSalary2,
		''' + '''  as Notes, 0 as Orders, ''' + ''' as CNo, ''' + ''' as SNo, ''' + ''' as IsMale, ''' + ''' as Birthday, ''' + ''' 
		as FullName, ''' + ''' as HospitalName, ''' + ''' FullAddress,  ''' + ''' as  DutyName
	From HV2561
	Union ' + 
---    insert dong de in bao cao 
	' Select ''' + @DivisionID + ''' AS DivisionID,''' + ''' as EmployeeID, 0 as Status, 0 as BaseSalaty1, 0 as BaseSalary2,
		''' + '''  as Notes, 0 as Orders, ''' + ''' as CNo, ''' + ''' as SNo, ''' + ''' as IsMale, ''' + ''' as Birthday, ''' + ''' 
		as FullName, ''' + ''' as HospitalName, ''' + ''' FullAddress,  ''' + ''' as  DutyName
	From HV2561
	Union ' + 
---    insert dong de in bao cao 
	' Select ''' + @DivisionID + ''' AS DivisionID,''' + ''' as EmployeeID, 2 as Status, 0 as BaseSalaty1, 0 as BaseSalary2,
		''' + '''  as Notes, 0 as Orders, ''' + ''' as CNo, ''' + ''' as SNo, ''' + ''' as IsMale, ''' + ''' as Birthday, ''' + ''' 
		as FullName, ''' + ''' as HospitalName, ''' + ''' FullAddress,  ''' + ''' as  DutyName
	From HV2561 
	Union ' +
---    insert dong de in bao cao 
	' Select ''' + @DivisionID + ''' AS DivisionID,''' + ''' as EmployeeID, 4 as Status, 0 as BaseSalaty1, 0 as BaseSalary2,
		''' + '''  as Notes, 0 as Orders, ''' + ''' as CNo, ''' + ''' as SNo, ''' + ''' as IsMale, ''' + ''' as Birthday, ''' + ''' 
		as FullName, ''' + ''' as HospitalName, ''' + ''' FullAddress,  ''' + ''' as  DutyName
	From HV2561 '

	
If not exists (Select Top 1 1 From SysObjects Where Xtype = 'V' and Name = 'HV2563' )
	EXEC('Create View HV2563 ---tao boi HP2561
			as ' + @sSQL3 + @sSQL4)
else
	EXEC('Alter View HV2563 ---tao boi HP2561
			as ' + @sSQL3 + @sSQL4)


