/****** Object:  StoredProcedure [dbo].[HP2803]    Script Date: 07/30/2010 09:57:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2803]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2803]
GO

/****** Object:  StoredProcedure [dbo].[HP2803]    Script Date: 07/30/2010 09:57:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--- Create Date: 13/6/2005
---Purpose: Xem tong ngay phep tu thang 1 den thang hien tai

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE [dbo].[HP2803]  @DivisionID as nvarchar(50),
				@DepartmentID as nvarchar(50),
				@EmployeeID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@GeneralAbsentID as nvarchar(50)
				
as

Declare @cur as cursor,
	@TranMonth1 as nvarchar(4),
	@TranYear1 as int, 
	@Column as int,
	@sSQL as nvarchar(4000),
	@SQL as nvarchar(4000),
	@qSQL as nvarchar(4000)
	
--print @sSQL

SET @sSQL='Select HV04.DivisionID, HV04.DepartmentID,  HV04.TeamID, TranYear, HV04.EmployeeID, HV00.FullName, HV04.GeneralAbsentID,
		 max(IsNull(DaysPrevYear,0)) as DaysPrevYear, max(IsNull(DaysInYear,0)) as DaysInYear, max(IsNull(DaysAllowed,0)) as DaysAllowed,
		min(IsNull(DaysRemained,0)) as DaysRemained,' 


Set @cur = Cursor scroll keyset for

		--Select TranMonth
		--From HT9999 Where TranYear= @TranYear and TranMonth<=@TranMonth and DivisionID = @DivisionID
		--Order by TranMonth
		Select '01' as TranMonth union select '02' as TranMonth
		Union Select '03' as TranMonth Union Select '04' as TranMonth
		Union Select '05' as TranMonth Union Select '06' as TranMonth
		Union Select '07' as TranMonth Union Select '08' as TranMonth
		Union Select '09' as TranMonth Union Select '10' as TranMonth
		Union Select '11' as TranMonth Union Select '12' as TranMonth	
		Order by TranMonth
		
Open @cur
Fetch next from @cur into @TranMonth1


Set @qSQL=''
While @@Fetch_Status = 0
 
	Begin	
		Set @sSQL= @sSQL +   'sum(case when TranMonth = ' + convert( nvarchar(4), @TranMonth1)+
				 ' then IsNull(DaysSpent,0) else 0 end) as Month' +  (Case when @TranMonth1 <10 then '0' else '' End )+ltrim(rtrim(str(@TranMonth1))) + ','
		Set @qSQL=@qSQL+ '  Month' +  (Case when @TranMonth1 <10 then '0' else '' End )+ltrim(rtrim(str(@TranMonth1))) + '+'
		Fetch next from @cur into @TranMonth1
		
	End

Close @cur
Set @qSQL=left(@qSQL, len(@qSQL) - 1)
Set @sSQL = left(@sSQL, len(@sSQL) - 1) + ' From HT2809  HV04 Inner Join HV1400  HV00 on HV04.DivisionID=HV00.DivisionID and 
					HV04.DepartmentID=HV00.DepartmentID and
					IsNull(HV04.TeamID,'''')= IsNull(HV00.TeamID,'''') and HV04.EmployeeID=HV00.EmployeeID
					Where TranYear= '+ convert( nvarchar(8), @TranYear)+ ' and TranMonth <= '+ convert( nvarchar(4), @TranMonth)+
					 ' and HV04.DivisionID= '''+ @DivisionID+''' and HV04.DepartmentID like '''+ @DepartmentID+'''
					and HV04.EmployeeID like '''+ @EmployeeID+ '''
					and HV04.GeneralAbsentID= '''+@GeneralAbsentID+'''
					 Group by HV04.DivisionID, HV04.DepartmentID,  HV04.TeamID, HV04.TranYear, HV04.EmployeeID, FullName, HV04.GeneralAbsentID '


--print @sSQL

If Not Exists (Select 1  From SysObjects Where Xtype ='V' and name=  'HV2804')
	Exec ('Create View HV2804 ------tao boi HP2803 
				as  '+@sSQL)
Else
	Exec (' Alter View HV2804 ---tao boi HP2803 
				 as  '+@sSQL)



Set @SQL='Select HV04.*,  ' + @qSQL+' as TotalDaysSpent, DaysAllowed - ( ' + @qSQL+')  as DaysRemained1
From HV2804 HV04'

If Not Exists (Select 1  From SysObjects Where Xtype ='V' and name=  'HV2805')
	Exec ('Create View HV2805 ------tao boi HP2803 
				as  '+@SQL)
Else
	Exec (' Alter View HV2805 ---tao boi HP2803 
				 as  '+@SQL)

--print @SQL




GO

