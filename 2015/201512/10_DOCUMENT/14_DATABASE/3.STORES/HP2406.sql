/****** Object:  StoredProcedure [dbo].[HP2406]    Script Date: 07/30/2010 16:13:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created by: Vo Thanh Huong, date: 26/08/2004
----purpose: X?u ly so lieu load len man hinh truy van cham cong san pham
--- Edited by Bao Anh	Date: 12/11/2012
--- Purpose: Bo sung loc theo ngay (VietRoll)
--- Modify on 20/08/2013 by Bao Anh: Khong Where theo TrackingDate neu khong check vao Ngay
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2406] @TimesID nvarchar(50),
				@DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@TranMonth nvarchar(20),
				@TranYear nvarchar(20),
				@TrackingDate datetime = NULL
AS
Declare @cur cursor,
		@ProductID nvarchar(50),
		@sSQL nvarchar(4000),
		@sSQL1 nvarchar(4000),
		@sSQL2 nvarchar(4000),
		@sSQL3 nvarchar(4000),
		@sSQL4 nvarchar(4000),
		@sSQL5 nvarchar(4000),
		@sSQL6 nvarchar(4000),
		@sSQL7 nvarchar(4000),
		@Column int,
		@sSQLnumber int

Select  @sSQL = '', @sSQL1 = '', @sSQL2 = '', @Column = 1, @sSQL3 = '', @sSQL4 = '', 
		@sSQL5 ='', @sSQL6 = '', @sSQL7='', @sSQLnumber = 0

Set @sSQL =  'Select HT.*,FullName,HV.Orders 
		 From HT2403 HT inner join HV1400 HV on HT.EmployeeID=HV.EmployeeID and HT.DivisionID=HV.DivisionID
			Where HT.DivisionID=''' + @DivisionID + ''' and
				HT.DepartmentID like ''' + @DepartmentID + ''' and
				Isnull(HT.TeamID,'''') like Isnull(''' + @TeamID +''', '''') and
				HT.TranMonth=' + str(@TranMonth) + ' and 
				HT.TranYear=' + str(@TranYear) + ' and
				HT.TimesID=''' + @TimesID + ''''
IF @TrackingDate is not null
	Set @sSQL =	@sSQL + ' AND CONVERT(VARCHAR(10),ISNULL(HT.TrackingDate,''01/01/1900''),101) = ''' + CONVERT(VARCHAR(10),@TrackingDate,101) + ''''

if not  exists (Select 1 From sysObjects Where XType = 'V' and name = 'HV2431')
	exec('Create view HV2431 ---tao boi HP2406
			as ' + @sSQL)
else	
	Begin
	Drop view HV2431
	exec('Create  view HV2431 ---tao boi HP2406
			as ' + @sSQL)
	end

Set @sSQL1 = 'Select DivisionID,DepartmentID,TeamID,EmployeeID,TranMonth,TranYear,FullName,Orders,0 as IsNotYes,'		
Set @sSQL = 'Select Distinct HT.DivisionID,HT.DepartmentID,HT.TeamID, 
			HT.EmployeeID,HT.TranMonth,HT.TranYear,FullName,HT.Orders,1 as IsNotYes, '		
Set @cur = Cursor scroll keyset for
	Select Distinct ProductID 
	From HT1017
	Where DivisionID = @DivisionID and
		DepartmentID like @DepartmentID and
		Isnull(TeamID, '') like Isnull(@TeamID, '') and
		TranMonth = @TranMonth and 
		TranYear = @TranYear and
		TimesID = @TimesID
Open @cur
Fetch next from @cur into @ProductID

While @@FETCH_STATUS = 0
	Begin	
	if @Column <= 100 
		Select @sSQLnumber = 1, @sSQL1 = @sSQL1 + 'sum(case When ProductID=N''' + @ProductID +  ''' then Quantity else NULL end) as C' +cast(@Column as nvarchar(10)) + ', '
		else if @Column <= 200			
			Select @sSQLnumber = 2, @sSQL2 = @sSQL2 + 'sum(case When ProductID=N''' + @ProductID +  ''' then Quantity else NULL end) as C' +cast(@Column as nvarchar(10)) + ', '
			 else if  @Column <= 300			
				Select @sSQLnumber = 3, @sSQL3 = @sSQL3 + 'sum(case When ProductID=N''' + @ProductID +  ''' then Quantity else NULL end) as C' +cast(@Column as nvarchar(10)) + ', '			
				else if @Column <=400
					Select @sSQLnumber = 4, @sSQL4 = @sSQL4 + 'sum(case When ProductID=N''' + @ProductID +  ''' then Quantity else NULL end) as C' +cast(@Column as nvarchar(10)) + ', '			
					else if @Column <=500
						Select @sSQLnumber = 5, @sSQL5 = @sSQL5 + 'sum(case When ProductID=N''' + @ProductID +  ''' then Quantity else NULL end) as C' +cast(@Column as nvarchar(10)) + ', '			
						else if @Column <=600
							Select @sSQLnumber = 6, @sSQL6 = @sSQL6 + 'sum(case When ProductID=N''' + @ProductID +  ''' then Quantity else NULL end) as C' +cast(@Column as nvarchar(10)) + ', '			
							else if @Column <=700
								Select @sSQLnumber = 7, @sSQL7 = @sSQL7 + 'sum(case When ProductID=N''' + @ProductID +  ''' then Quantity else NULL end) as C' +cast(@Column as nvarchar(10)) + ', '			
	
	Set @sSQL = @sSQL + 'NULL as C' + cast(@Column as nvarchar(10)) + ', '
	Set @Column = @Column + 1
	Fetch next from @cur into @ProductID
	End

	IF @sSQLNumber = 1
	Set  @sSQL1 = left(@sSQL1, len(@sSQL1) -1) + ' From HV2431 Where DivisionID = '''+@DivisionID+'''
			Group by DivisionID,DepartmentID,TeamID,EmployeeID,TranMonth,TranYear,FullName,Orders'	
	else if  @sSQLNumber = 2
	Set  @sSQL2 = left(@sSQL2, len(@sSQL2) -1) + ' From HV2431  Where DivisionID = '''+@DivisionID+'''
			Group by DivisionID,DepartmentID,TeamID,EmployeeID,TranMonth,TranYear,FullName,Orders'	
		else if  @sSQLNumber = 3
		Set  @sSQL3 = left(@sSQL3, len(@sSQL3) -1) + ' From HV2431  Where DivisionID = '''+@DivisionID+'''
				Group by DivisionID,DepartmentID,TeamID,EmployeeID,TranMonth,TranYear,FullName,Orders'	
			else if  @sSQLNumber = 4
			Set  @sSQL4 = left(@sSQL4, len(@sSQL4) -1) + ' From HV2431  Where DivisionID = '''+@DivisionID+'''
					Group by DivisionID,DepartmentID,TeamID,EmployeeID,TranMonth,TranYear,FullName,Orders'	
				else if  @sSQLNumber = 5
				Set  @sSQL5 = left(@sSQL5, len(@sSQL5) -1) + ' From HV2431  Where DivisionID = '''+@DivisionID+'''
						Group by DivisionID,DepartmentID,TeamID,EmployeeID,TranMonth,TranYear,FullName,Orders'	
					else if  @sSQLNumber = 6
					Set  @sSQL6 = left(@sSQL6, len(@sSQL6) -1) + ' From HV2431  Where DivisionID = '''+@DivisionID+'''
							Group by DivisionID,DepartmentID,TeamID,EmployeeID,TranMonth,TranYear,FullName,Orders'	
						else if  @sSQLNumber = 7
						Set  @sSQL7 = left(@sSQL7, len(@sSQL7) -1) + ' From HV2431  Where DivisionID = '''+@DivisionID+'''
								Group by DivisionID,DepartmentID,TeamID,EmployeeID,TranMonth,TranYear,FullName,Orders'	
	
	Set @sSQL = left(@sSQL, len(@sSQL) -1) + 
			' From HT2400 HT inner join HV1400 HV on HT.EmployeeID=HV.EmployeeID and HT.DivisionID=HV.DivisionID
			Where HT.DivisionID=''' + @DivisionID + ''' and
				HT.DepartmentID like ''' + @DepartmentID + ''' and
				Isnull(HT.TeamID, ''' + ''') like
				 Isnull(''' + @TeamID +''', ''' + ''') and
				HT.TranMonth=' + cast(@TranMonth as nvarchar(2)) + ' and 
				HT.TranYear=' + cast(@TranYear as nvarchar(4)) + ' and 
				HT.EmployeeID not in (Select Distinct EmployeeID From HV2431 Where DivisionID = '''+ @DivisionID +''' )'	
	
print @sSQL
	

If not exists(Select 1 From sysObjects Where XType = 'V' and name = 'HV2430')
	Begin
		If @sSQLNumber = 0
			exec('Create view HV2430 ---tao boi HP2430
				as ' + @sSQL)
		else
			exec('Create view HV2430 ---tao boi HP2430
				as ' + @sSQL1 + @sSQL2 + @sSQL3 + @sSQL4 + @sSQL5 + @sSQL6 + @sSQL7 + ' Union ' + @sSQL)
	End
	else
		Begin
			Drop view HV2430
			If @sSQLNumber = 0
				exec('Create view HV2430 ---tao boi HP2430
					as ' + @sSQL)
			else
				exec('Create view HV2430 ---tao boi HP2430
					as ' + @sSQL1 + @sSQL2 + @sSQL3 + @sSQL4 + @sSQL5 + @sSQL6 + @sSQL7 + ' Union ' + @sSQL)
		End
Close @cur
Deallocate @cur




















