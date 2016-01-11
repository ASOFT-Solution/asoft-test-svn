
/****** Object:  StoredProcedure [dbo].[HP2805]    Script Date: 08/04/2010 11:52:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2805]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2805]
GO

/****** Object:  StoredProcedure [dbo].[HP2805]    Script Date: 08/04/2010 11:52:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


---Create Date: 21/6/2005
---Purpose: In tong ngay phep tu thang 1 den thang hien tai

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE [dbo].[HP2805]  @DivisionID as nvarchar(50),
				@DepartmentID as nvarchar(50),
				@EmployeeID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@GeneralAbsentID as nvarchar(50)


	
AS
Declare @sSQL1 nvarchar(4000), 
	@sSQL2 nvarchar(4000),
	@sSQL3 nvarchar(4000),
	@sSQL4 nvarchar(4000),
	@sSQL5 nvarchar(4000),
	@sSQL6 nvarchar(4000),
	@FromTranMonth as int

	Select  @FromTranMonth=min(TranMonth)
	From HT9999 Where TranYear= @TranYear

	/* ---- */
	Set @FromTranMonth = isnull(@FromTranMonth,0)
	/* ---- */

If exists (select 1 from HT2810 where  DivisionID=@DivisionID AND TranYear= @TranYear-1) ---Neu nhan vien co ngay phep nam truoc
	
	Begin

		Set @sSQL1=' Select HV04.DivisionID, HV04.DepartmentID,  AT02.DepartmentName, HV04.TeamID, 
				TranMonth,TranYear, HV04.EmployeeID, HV00.FullName, HV04.GeneralAbsentID, max(IsNull(DaysInYear,0)) as DaysInYear,
				 ''Tha?ng'' as Notes,
				max(IsNull(DaysPrevYear,0)) as TimeOff,  -1 as Signs, N''Năm trước '' as Caption, 0 AS Status
				From HT2809  HV04 Inner Join HV1400  HV00 on HV04.DivisionID=HV00.DivisionID and 
				HV04.DepartmentID=HV00.DepartmentID and
				IsNull(HV04.TeamID,'''')= IsNull(HV00.TeamID,'''') and HV04.EmployeeID=HV00.EmployeeID
				Left Join AT1102 AT02 on HV04.DivisionID=AT02.DivisionID and HV04.DepartmentID=AT02.DepartmentID
				Where TranYear=  '+str(@TranYear)+ ' and TranMonth between ' + cast(@FromTranMonth as nvarchar(4)) +' and '+ cast(@TranMonth as nvarchar(4)) +' 
				and HV04.DivisionID= '''+@DivisionID+'''  and HV04.DepartmentID like '''+ @DepartmentID+''' 
				and HV04.EmployeeID like '''+ @EmployeeID+'''
				and HV04.GeneralAbsentID like ''' + @GeneralAbsentID+'''
				Group by HV04.DivisionID, HV04.DepartmentID, AT02.DepartmentName, HV04.TeamID, 
				HV04.EmployeeID, FullName, TranMonth,HV04.TranYear, HV04.GeneralAbsentID '

	--print @sSQL1

		Set @sSQL2=' Union 

				Select HV04.DivisionID, HV04.DepartmentID,  AT02.DepartmentName,HV04.TeamID, 
				TranMonth,TranYear, HV04.EmployeeID, HV00.FullName, HV04.GeneralAbsentID, max(IsNull(DaysInYear,0)) as DaysInYear,
				 ''Tha?ng'' as Notes,
				max(IsNull(DaysAllowed,0)) as TimeOff,  -1 as Signs, N''Ngày nghỉ'' as Caption,  0 AS Status
				From HT2809  HV04 Inner Join HV1400  HV00 on HV04.DivisionID=HV00.DivisionID and 
				HV04.DepartmentID=HV00.DepartmentID and
				IsNull(HV04.TeamID,'''')= IsNull(HV00.TeamID,'''') and HV04.EmployeeID=HV00.EmployeeID
				Left Join AT1102 AT02 on HV04.DivisionID=AT02.DivisionID and HV04.DepartmentID=AT02.DepartmentID
				Where TranYear= ' +str(@TranYear)+ ' and TranMonth between ' + cast(@FromTranMonth as nvarchar(4)) +' and '+ cast(@TranMonth as nvarchar(4)) +' 
				and HV04.DivisionID= '''+@DivisionID+'''  and HV04.DepartmentID like '''+ @DepartmentID+''' 
				and HV04.EmployeeID like '''+ @EmployeeID+'''
				and HV04.GeneralAbsentID like ''' + @GeneralAbsentID+'''
				Group by HV04.DivisionID, HV04.DepartmentID,  AT02.DepartmentName, HV04.TeamID, 
				HV04.EmployeeID, FullName, TranMonth,HV04.TranYear, HV04.GeneralAbsentID '

		Set @sSQL3=' Union 
				Select HV04.DivisionID, HV04.DepartmentID,  AT02.DepartmentName, HV04.TeamID, 
				TranMonth,TranYear, HV04.EmployeeID, HV00.FullName, HV04.GeneralAbsentID, max(IsNull(DaysInYear,0)) as DaysInYear,
				 ''Tha?ng'' as Notes,
			 
				-avg(IsNull(DaysSpent ,0)) as TimeOff,  1 as Signs, N''Ngày nghỉ'' as Caption,  0 AS Status
				From HT2809  HV04 Inner Join HV1400  HV00 on HV04.DivisionID=HV00.DivisionID and 
				HV04.DepartmentID=HV00.DepartmentID and
				IsNull(HV04.TeamID,'''')= IsNull(HV00.TeamID,'''') and HV04.EmployeeID=HV00.EmployeeID
				Left Join AT1102 AT02 on HV04.DivisionID=AT02.DivisionID and HV04.DepartmentID=AT02.DepartmentID
				Where TranYear= ' +str(@TranYear)+ ' and TranMonth between ' + cast(@FromTranMonth as nvarchar(4)) +' and '+ cast(@TranMonth as nvarchar(4)) +' 
				and HV04.DivisionID= '''+@DivisionID+'''  and HV04.DepartmentID like '''+ @DepartmentID+''' 
				and HV04.EmployeeID like '''+ @EmployeeID+'''
				and HV04.GeneralAbsentID like ''' + @GeneralAbsentID+'''
				Group by HV04.DivisionID, HV04.DepartmentID, AT02.DepartmentName, HV04.TeamID, 
				HV04.EmployeeID, FullName, TranMonth,HV04.TranYear, HV04.GeneralAbsentID '
		Set @sSQL4=' 				
			Union 
				Select HV04.DivisionID, HV04.DepartmentID,  AT02.DepartmentName, HV04.TeamID, 
				0 AS TranMonth, ' +str(@TranYear)+ ' AS TranYear, HV04.EmployeeID, HV00.FullName, HV04.GeneralAbsentID, max(IsNull(DaysInYear,0)) as DaysInYear,
				 ''To?ng'' as Notes,
			 
				sum(IsNull(DaysSpent ,0)) as TimeOff,  1 as Signs, N''Ngày nghỉ'' as Caption,  1 AS Status
				From HT2809  HV04 Inner Join HV1400  HV00 on HV04.DivisionID=HV00.DivisionID and 
				HV04.DepartmentID=HV00.DepartmentID and
				IsNull(HV04.TeamID,'''')= IsNull(HV00.TeamID,'''') and HV04.EmployeeID=HV00.EmployeeID
				Left Join AT1102 AT02 on HV04.DivisionID=AT02.DivisionID and HV04.DepartmentID=AT02.DepartmentID
				Where TranYear= ' +str(@TranYear)+ ' and TranMonth between ' + cast(@FromTranMonth as nvarchar(4)) +' and '+ cast(@TranMonth as nvarchar(4)) +' 
				and HV04.DivisionID= '''+@DivisionID+'''  and HV04.DepartmentID like '''+ @DepartmentID+''' 
				and HV04.EmployeeID like '''+ @EmployeeID+'''
				and HV04.GeneralAbsentID like ''' + @GeneralAbsentID+'''
				Group by HV04.DivisionID, HV04.DepartmentID, AT02.DepartmentName, HV04.TeamID, 
				HV04.EmployeeID, FullName, HV04.GeneralAbsentID'
				
		Set @sSQL5=' Union 
				Select HV04.DivisionID, HV04.DepartmentID,  AT02.DepartmentName, HV04.TeamID, 
				TranMonth,TranYear, HV04.EmployeeID, HV00.FullName, HV04.GeneralAbsentID, max(IsNull(DaysInYear,0)) as DaysInYear,
				 ''Tha?ng'' as Notes,
		 		case when  avg(isnull(DaysSpent,0)) >avg( isnull(DaysAllowed,0)) then
				avg(IsNull(DaysSpent ,0) - Isnull(DaysAllowed,0)) else 0 end  as TimeOff
				,  1 as Signs, ''?a? ngh?'' as Caption,  0 AS Status
				From HT2809  HV04 Inner Join HV1400  HV00 on HV04.DivisionID=HV00.DivisionID and 
				HV04.DepartmentID=HV00.DepartmentID and
				IsNull(HV04.TeamID,'''')= IsNull(HV00.TeamID,'''') and HV04.EmployeeID=HV00.EmployeeID
				Left Join AT1102 AT02 on HV04.DivisionID=AT02.DivisionID and HV04.DepartmentID=AT02.DepartmentID
				Where TranYear= ' +str(@TranYear)+ ' and TranMonth between ' + cast(@FromTranMonth as nvarchar(4)) +' and '+ cast(@TranMonth as nvarchar(4)) +' 
				and HV04.DivisionID= '''+@DivisionID+'''  and HV04.DepartmentID like '''+ @DepartmentID+''' 
				and HV04.EmployeeID like '''+ @EmployeeID+'''
				and HV04.GeneralAbsentID like ''' + @GeneralAbsentID+'''
				Group by HV04.DivisionID, HV04.DepartmentID, AT02.DepartmentName, HV04.TeamID, 
				HV04.EmployeeID, FullName, TranMonth,HV04.TranYear, HV04.GeneralAbsentID '
		Set @sSQL6=' 				
			Union 
				Select HV04.DivisionID, HV04.DepartmentID,  AT02.DepartmentName, HV04.TeamID, 
				0 AS TranMonth,TranYear, HV04.EmployeeID, HV00.FullName, HV04.GeneralAbsentID, max(IsNull(DaysInYear,0)) as DaysInYear, 
				''To?ng'' as Notes,
				min(IsNull(DaysRemained ,0))  as TimeOff,  1 as Signs, ''Phe?p co?n la?i'' as Caption,  1 AS Status
				From HT2809  HV04 Inner Join HV1400  HV00 on HV04.DivisionID=HV00.DivisionID and 
				HV04.DepartmentID=HV00.DepartmentID and
				IsNull(HV04.TeamID,'''')= IsNull(HV00.TeamID,'''') and HV04.EmployeeID=HV00.EmployeeID
				Left Join AT1102 AT02 on HV04.DivisionID=AT02.DivisionID and HV04.DepartmentID=AT02.DepartmentID
				Where TranYear= ' +str(@TranYear)+ ' and TranMonth between ' + cast(@FromTranMonth as nvarchar(4)) +' and '+ cast(@TranMonth as nvarchar(4)) +' 
				and HV04.DivisionID= '''+@DivisionID+'''  and HV04.DepartmentID like '''+ @DepartmentID+''' 
				and HV04.EmployeeID like '''+ @EmployeeID+'''
				and HV04.GeneralAbsentID like ''' + @GeneralAbsentID+'''
				Group by HV04.DivisionID, HV04.DepartmentID, AT02.DepartmentName,  HV04.TeamID, 
				HV04.EmployeeID, FullName, TranMonth,HV04.TranYear, HV04.GeneralAbsentID'


	End

Else ---nhan vien khong co ngay phep nam truoc

	Begin

		Set @sSQL1= ''

	----print @sSQL1

		Set @sSQL2=' 	Select HV04.DivisionID, HV04.DepartmentID,  AT02.DepartmentName, HV04.TeamID, 
				TranMonth,TranYear, HV04.EmployeeID, HV00.FullName, HV04.GeneralAbsentID, max(IsNull(DaysInYear,0)) as DaysInYear, 
				 ''Tha?ng'' as Notes,
				max(IsNull(DaysAllowed,0)) as TimeOff,  -1 as Signs, '' ????c ngh?'' as Caption,  0 AS Status
				From HT2809  HV04 Inner Join HV1400  HV00 on HV04.DivisionID=HV00.DivisionID and 
				HV04.DepartmentID=HV00.DepartmentID and
				IsNull(HV04.TeamID,'''')= IsNull(HV00.TeamID,'''') and HV04.EmployeeID=HV00.EmployeeID

				Left Join AT1102 AT02 on HV04.DivisionID=AT02.DivisionID and HV04.DepartmentID=AT02.DepartmentID			
				Where TranYear= ' +str(@TranYear)+ ' and TranMonth between ' + cast(@FromTranMonth as nvarchar(4)) +' and '+ cast(@TranMonth as nvarchar(4)) +' 
				and HV04.DivisionID= '''+@DivisionID+'''  and HV04.DepartmentID like '''+ @DepartmentID+''' 
				and HV04.EmployeeID like '''+ @EmployeeID+'''
				and HV04.GeneralAbsentID like ''' + @GeneralAbsentID+'''

				Group by HV04.DivisionID, HV04.DepartmentID, AT02.DepartmentName, HV04.TeamID, 
				HV04.EmployeeID, FullName, TranMonth,HV04.TranYear, HV04.GeneralAbsentID '

			Set @sSQL3=' Union 
				Select HV04.DivisionID, HV04.DepartmentID,  AT02.DepartmentName, HV04.TeamID, 
				TranMonth,TranYear, HV04.EmployeeID, HV00.FullName, HV04.GeneralAbsentID, max(IsNull(DaysInYear,0)) as DaysInYear, 
				''Tha?ng'' as Notes,
			 
				-avg(IsNull(DaysSpent ,0)) as TimeOff,  1 as Signs, ''?a? ngh?'' as Caption,  0 AS Status
				From HT2809  HV04 Inner Join HV1400  HV00 on HV04.DivisionID=HV00.DivisionID and 
				HV04.DepartmentID=HV00.DepartmentID and
				IsNull(HV04.TeamID,'''')= IsNull(HV00.TeamID,'''') and HV04.EmployeeID=HV00.EmployeeID
				Left Join AT1102 AT02 on HV04.DivisionID=AT02.DivisionID and HV04.DepartmentID=AT02.DepartmentID
				Where TranYear= ' +str(@TranYear)+ ' and TranMonth between ' + cast(@FromTranMonth as nvarchar(4)) +' and '+ cast(@TranMonth as nvarchar(4)) +' 
				and HV04.DivisionID= '''+@DivisionID+'''  and HV04.DepartmentID like '''+ @DepartmentID+''' 
				and HV04.EmployeeID like '''+ @EmployeeID+'''
				and HV04.GeneralAbsentID like ''' + @GeneralAbsentID+'''
				
				Group by HV04.DivisionID, HV04.DepartmentID, AT02.DepartmentName,  HV04.TeamID, 
				HV04.EmployeeID, FullName, TranMonth,HV04.TranYear, HV04.GeneralAbsentID'
			
			Set @sSQL4=' 
			Union 
				Select HV04.DivisionID, HV04.DepartmentID,  AT02.DepartmentName, HV04.TeamID, 
				0  AS TranMonth, ' +str(@TranYear)+ ' AS TranYear, HV04.EmployeeID, HV00.FullName, HV04.GeneralAbsentID, max(IsNull(DaysInYear,0)) as DaysInYear,
				 ''To?ng'' as Notes,
			 
				-sum(IsNull(DaysSpent ,0)) as TimeOff,  1 as Signs, '' ?a? ngh?'' as Caption,  1 AS Status
				From HT2809  HV04 Inner Join HV1400  HV00 on HV04.DivisionID=HV00.DivisionID and 
				HV04.DepartmentID=HV00.DepartmentID and
				IsNull(HV04.TeamID,'''')= IsNull(HV00.TeamID,'''') and HV04.EmployeeID=HV00.EmployeeID
				Left Join AT1102 AT02 on HV04.DivisionID=AT02.DivisionID and HV04.DepartmentID=AT02.DepartmentID
				Where TranYear= ' +str(@TranYear)+ ' and TranMonth between ' + cast(@FromTranMonth as nvarchar(4)) +' and '+ cast(@TranMonth as nvarchar(4)) +' 
				and HV04.DivisionID= '''+@DivisionID+'''  and HV04.DepartmentID like '''+ @DepartmentID+''' 
				and HV04.EmployeeID like '''+ @EmployeeID+'''
				and HV04.GeneralAbsentID like  ''' + @GeneralAbsentID+'''
				Group by HV04.DivisionID, HV04.DepartmentID, AT02.DepartmentName, HV04.TeamID, 
				HV04.EmployeeID, FullName, HV04.GeneralAbsentID'
		
			
		Set @sSQL5=' Union 
				Select HV04.DivisionID, HV04.DepartmentID,  AT02.DepartmentName, HV04.TeamID, 
				TranMonth,TranYear, HV04.EmployeeID, HV00.FullName, HV04.GeneralAbsentID, max(IsNull(DaysInYear,0)) as DaysInYear, 
				''Tha?ng'' as Notes,
		 		case when  avg(isnull(DaysSpent,0)) >avg( isnull(DaysAllowed,0)) then
				avg(IsNull(DaysSpent ,0) - Isnull(DaysAllowed,0)) else 0 end  as TimeOff,  1 as Signs, ''Kho?ng phe?p'' as Caption,  0 AS Status
				From HT2809  HV04 Inner Join HV1400  HV00 on HV04.DivisionID=HV00.DivisionID and 
				HV04.DepartmentID=HV00.DepartmentID and
				IsNull(HV04.TeamID,'''')= IsNull(HV00.TeamID,'''') and HV04.EmployeeID=HV00.EmployeeID
				Left Join AT1102 AT02 on HV04.DivisionID=AT02.DivisionID and HV04.DepartmentID=AT02.DepartmentID
				Where TranYear= ' +str(@TranYear)+ ' and TranMonth between ' + cast(@FromTranMonth as nvarchar(4)) +' and '+ cast(@TranMonth as nvarchar(4)) +' 
				and HV04.DivisionID= '''+@DivisionID+'''  and HV04.DepartmentID like '''+ @DepartmentID+''' 
				and HV04.EmployeeID like '''+ @EmployeeID+'''
				and HV04.GeneralAbsentID like ''' + @GeneralAbsentID+'''				
				Group by HV04.DivisionID, HV04.DepartmentID, AT02.DepartmentName,  HV04.TeamID, 
				HV04.EmployeeID, FullName, TranMonth,HV04.TranYear, HV04.GeneralAbsentID'
				
			Set @sSQL6=' 	
		
		Union 
				Select HV04.DivisionID, HV04.DepartmentID,  AT02.DepartmentName, HV04.TeamID, 
				0 AS TranMonth,TranYear, HV04.EmployeeID, HV00.FullName, HV04.GeneralAbsentID, max(IsNull(DaysInYear,0)) as DaysInYear, 
				''To?ng'' as Notes,
				min(IsNull(DaysRemained ,0))  as TimeOff,  1 as Signs, ''Phe?p co?n la?i'' as Caption,  1 AS Status
				From HT2809  HV04 Inner Join HV1400  HV00 on HV04.DivisionID=HV00.DivisionID and 
				HV04.DepartmentID=HV00.DepartmentID and
				IsNull(HV04.TeamID,'''')= IsNull(HV00.TeamID,'''') and HV04.EmployeeID=HV00.EmployeeID
				Left Join AT1102 AT02 on HV04.DivisionID=AT02.DivisionID and HV04.DepartmentID=AT02.DepartmentID
				Where TranYear= ' +str(@TranYear)+ ' and TranMonth between ' + cast(@FromTranMonth as nvarchar(4)) +' and '+ cast(@TranMonth as nvarchar(4)) +' 
				and HV04.DivisionID= '''+@DivisionID+'''  and HV04.DepartmentID like '''+ @DepartmentID+''' 
				and HV04.EmployeeID like '''+ @EmployeeID+'''
				and HV04.GeneralAbsentID like ''' + @GeneralAbsentID+'''				
				Group by HV04.DivisionID, HV04.DepartmentID, AT02.DepartmentName,  HV04.TeamID, 
				HV04.EmployeeID, FullName, TranMonth,HV04.TranYear, HV04.GeneralAbsentID '
--print @sSQL6
	End


If Not Exists (Select 1  From SysObjects Where Xtype ='V' and name=  'HV2812')
	Exec ('Create View HV2812 ------tao boi HP2805
				as  '  + @sSQL1 +@sSQL2 + @sSQL3 + @sSQL4 + @sSQL5 + @sSQL6)
Else
	Exec (' Alter View HV2812 ---tao boi HP2805
				 as  ' + @sSQL1 + @sSQL2 + @sSQL3 + @sSQL4 + @sSQL5 + @sSQL6)


GO

