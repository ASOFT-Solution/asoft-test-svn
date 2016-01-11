/****** Object:  StoredProcedure [dbo].[HP2500]    Script Date: 11/25/2011 14:54:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2500]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2500]
GO

/****** Object:  StoredProcedure [dbo].[HP2500]    Script Date: 11/25/2011 14:54:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


----Created by: Vo Thanh Huong, date: 01/09/2004
----purpose: Xu ly so lieu load len man hinh cham cong ngay
----Edit by Huynh Trung Dung ,date 14/12/2010 --- Them tham so @ToDepartmentID
--- Modify on 23/01/2014 by Bảo Anh: Bỏ convert sang nvarchar khi Where AbsentDate

CREATE PROCEDURE [dbo].[HP2500]  @DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@ToDepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@EmployeeID nvarchar(50),
				@FromDate datetime,
				@Todate datetime, 
				@TranMonth int,
				@TranYear int
AS
Declare @sSQL nvarchar(max),
	@cur cursor,
	@Column int,
	@AbsentTypeID nvarchar(50)

Select @Column = 1, @sSQL = '' 
Set @sSQL = 'Select HT.EmpFileID, HT.DivisionID,HT.DepartmentID, isnull(HT.TeamID, '''') as TeamID, HT.EmployeeID, FullName, AbsentDate, Notes, ' 	
Set @cur = Cursor scroll keyset for
		Select AbsentTypeID From HT1013 Where DivisionID = @DivisionID And IsMonth = 0
		Order by Orders, AbsentTypeID
Open @cur
Fetch next from @cur into @AbsentTypeID




While @@Fetch_Status = 0
Begin	
	Set @sSQL = @sSQL + 'sum(case when AbsentTypeID = N''' + @AbsentTypeID +
			 ''' then (case when AbsentAmount = 0 then NULL else AbsentAmount end)  else NULL end) as C' + right('0' + convert(varchar(2), @Column),2) +', '	
	Set @Column = @Column + 1
	Fetch next from @cur into @AbsentTypeID
End

Set @sSQL = left(@sSQL, len(@sSQl) - 1) +  ' From HT2400 HT LEFT JOIN HT2401 HT02 ON HT.EmployeeID=HT02.EmployeeID
						and HT.DivisionID=HT02.DivisionID and HT.DepartmentID=HT02.DepartmentID
						and IsNull(HT.TeamID,'''')=ISNull(HT02.TeamID,'''') and HT.EmployeeID=HT02.EmployeeID and
						HT.TranMonth=HT02.TranMonth and HT.TranYear=HT02.TranYear
						left join HV1400 HV on HT.EmployeeID = HV.EmployeeID and HT.DivisionID=HV.DivisionID

			Where HT.DivisionID = ''' + @DivisionID + ''' and
				HT.DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' and 
				isnull(HT.TeamID, '''') like isnull(''' + @TeamID + ''', '''')  and 
				HT.EmployeeID like ''' + @EmployeeID + ''' and
				HT.TranMonth = ' + cast(@TranMonth as nvarchar(2)) + ' and HT.TranYear = ' + cast(@TranYear as nvarchar(4)) + ' and 
				AbsentDate between ''' + convert(nvarchar(10), @FromDate, 101) + ''' and ''' + 
				convert(nvarchar(10), @ToDate, 101) + ''' 
			Group by  HT.EmpFileID, HT.DivisionID,HT.DepartmentID, isnull(HT.TeamID,''''), HT.EmployeeID, FullName, AbsentDate, Notes'

Close @cur

If  exists(Select  1 From sysObjects Where XType = 'V' and Name = 'HV2500')
	Drop view HV2500
	exec('Create view HV2500 ---tao boi HP2500
		as ' + @sSQL)


