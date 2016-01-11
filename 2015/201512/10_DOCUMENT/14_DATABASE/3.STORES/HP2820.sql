/****** Object:  StoredProcedure [dbo].[HP2820]    Script Date: 11/15/2011 15:11:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2820]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2820]
GO


/****** Object:  StoredProcedure [dbo].[HP2820]    Script Date: 11/15/2011 15:11:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
---Create Date: 1/8/2005
---Purpose: Tinh mot muc luong dua vao muc luong khac

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE [dbo].[HP2820]  @DivisionID as nvarchar(50),
				@SalaryCondID as nvarchar(50),
				@TranMonth as tinyint,
				@TranYear as smallint,
				@Mode as tinyint-- 0 insert vao ho so nhan su; 1 insert vao ho so luong thang
				
AS

DECLARE		
			@sSQL as nvarchar(4000),
			@ParaBased as nvarchar(50), -- ten cot
			@ParaCal as nvarchar(50), -- ten cot
			@IsPercent as tinyint
			

Select  @ParaBased =  ParameterBased, @ParaCal= ParameterCal , @IsPercent =IsPercent From HT2820 Where SalaryCondID= @SalaryCondID and DivisionID = @DivisionID

/* ---- */
Set @IsPercent = isnull(@IsPercent,0)
Set @ParaBased = isnull(@ParaBased,'')
Set @ParaCal = isnull(@ParaCal,'')
/* ---- */

If @Mode=0 
	
	Begin
		If @IsPercent=0
		
			Set @sSQL='Select EmployeeID, HT1403.DivisionID, DepartmentID, IsNull(TeamID,'''') as TeamID, ' + @ParaBased + ' ,
				IsNull( sum(Case When ' + IsNull(@ParaBased,0) + ' >= FromValue and ( ' + IsNull(@ParaBased,0) +  ' < ToValue or ToValue =-1)
				then Value else 0 end), 0)  as Col
				From HT1403, HT2821  Where HT1403.DivisionID= ''' + @DivisionID + ''' and EmployeeStatus=1 
				and SalaryCondID= ''' + @SalaryCondID + ''' 
				Group by EmployeeID, HT1403.DivisionID, DepartmentID, IsNull(TeamID,''''), ' + @ParaBased + '  '
		Else 
			
			Set @sSQL='Select EmployeeID, HT1403.DivisionID, DepartmentID, IsNull(TeamID,'''') as TeamID, ' + @ParaBased + ' ,
				IsNull( sum(Case When ' + IsNull(@ParaBased,0) + ' >= FromValue and ( ' + IsNull(@ParaBased,0) +  ' < ToValue or ToValue =-1)
				then Value* '+ @ParaBased+ '  else 0 end), 0) /100 as Col
				From HT1403, HT2821  Where HT1403.DivisionID= ''' + @DivisionID + ''' and EmployeeStatus=1 
				and SalaryCondID= ''' + @SalaryCondID + '''
				Group by EmployeeID, HT1403.DivisionID, DepartmentID,  IsNull(TeamID,'''') , ' + @ParaBased + '  '
		---print @sSQL
		
		If not  exists(Select  1 From sysObjects Where XType = 'V' and Name = 'HV2823')	
			exec('Create view HV2823 ---tao boi HP2820
			as ' + @sSQL)
		Else
			exec('Alter view HV2823 ---tao boi HP2820
			as ' + @sSQL)

	----Insert vao HT2822 luu gia tri cu 

		If exists ( select top 1 1 from HT2822 Where SalaryCondID= @SalaryCondID and DivisionID=@DivisionID and TranMonth=@TranMonth
				and TranYear=@TranYear and TableID='HT1403')
		delete HT2822 Where SalaryCondID= @SalaryCondID and DivisionID=@DivisionID and TranMonth=@TranMonth
				and TranYear=@TranYear and TableID='HT1403'
		Set @sSQL='Insert into HT2822 (SalaryCondID, EmployeeID, DivisionID, DepartmentID, TeamID, ParameterCalOld,
				ParameterCalNew, TranMonth, TranYear, TableID)
				Select '''+ @SalaryCondID+'''  as SalaryConID, HV.EmployeeID, HV.DivisionID, HV.DepartmentID, HV.TeamID,
				HV.' + @ParaBased+ '  as ParameterCalOld, HV.Col as ParameterCalNew, ' + Str(@TranMonth) + ' as TranMonth, 
				' +Str(@TranYear)+  '  as TranYear, ''HT1403'' as TableID
				From HV2823 HV'
		Exec (@sSQL)
	-----//Xong phan Insert 
		exec ( 'Update HT1403 Set ' + @ParaCal+  '= Col   From HT1403 HT inner join HV2823 HV on HT.EmployeeID=HV.EmployeeID
				and HT.DivisionID=HV.DivisionID and HT.DepartmentID=HV.DepartmentID and IsNull(HT.TeamID,'''')=IsNull(HV.TeamID,'''') 
				Where HT.DivisionID= ''' + @DivisionID+ ''' ' )
				
	----print 	@sSQL		

	End


Else----@Mode=1


	Begin
			
		If @IsPercent=0
			
				Set @sSQL='Select EmployeeID, HT2400.DivisionID, DepartmentID, IsNull(TeamID,'''') as TeamID, ' + @ParaBased + ' ,
					IsNull( sum(Case When ' + IsNull(@ParaBased,0) + ' >= FromValue and ( ' + IsNull(@ParaBased,0) +  ' < ToValue or ToValue =-1)
					then Value else 0 end), 0)  as Col
					From HT2400, HT2821  Where HT2400.DivisionID= ''' + @DivisionID + ''' and TranMonth= ' +str(@TranMonth)+' and TranYear = '+ str(@TranYear) +' 
					and SalaryCondID= ''' + @SalaryCondID + '''
					Group by EmployeeID, HT2400.DivisionID, DepartmentID, IsNull(TeamID,''''), ' + @ParaBased + '  '
			Else 
				
				Set @sSQL='Select EmployeeID, HT2400.DivisionID, DepartmentID, IsNull(TeamID,'''') as TeamID, ' + @ParaBased + ' ,
					IsNull( sum(Case When ' + IsNull(@ParaBased,0) + ' >= FromValue and ( ' + IsNull(@ParaBased,0) +  ' < ToValue or ToValue =-1)
					then Value* '+ @ParaBased+ '  else 0 end), 0) /100 as Col
					From HT2400, HT2821  Where HT2400.DivisionID= ''' + @DivisionID + '''  and TranMonth= ' +str(@TranMonth)+' and TranYear = '+ str(@TranYear) +'  
					and SalaryCondID= ''' + @SalaryCondID + '''
					Group by EmployeeID, HT2400.DivisionID, DepartmentID,  IsNull(TeamID,'''') , ' + @ParaBased + '  '

		If not  exists(Select  1 From sysObjects Where XType = 'V' and Name = 'HV2823')	
			exec('Create view HV2823 ---tao boi HP2820
			as ' + @sSQL)
		Else
			exec('Alter view HV2823 ---tao boi HP2820
			as ' + @sSQL)

	----Insert vao HT2822 luu gia tri cu 

		If exists ( select top 1 1 from HT2822 Where SalaryCondID= @SalaryCondID and DivisionID=@DivisionID and TranMonth=@TranMonth
				and TranYear=@TranYear and TableID='HT2400')
		delete HT2822 Where SalaryCondID= @SalaryCondID and DivisionID=@DivisionID and TranMonth=@TranMonth
				and TranYear=@TranYear and TableID='HT2400'

		Set @sSQL='Insert into HT2822 (SalaryCondID, EmployeeID, DivisionID, DepartmentID, TeamID, ParameterCalOld,
				ParameterCalNew, TranMonth, TranYear, TableID)
				Select '''+ @SalaryCondID+'''  as SalaryConID, HV.EmployeeID, HV.DivisionID, HV.DepartmentID, HV.TeamID,
				HV.' + @ParaBased+ '  as ParameterCalOld, HV.Col as ParameterCalNew, ' + Str(@TranMonth) + ' as TranMonth, 
				' +Str(@TranYear)+  '  as TranYear, ''HT2400'' as TableID
				From HV2823 HV'
		Exec (@sSQL)

	----// Xong phan Insert

		Set @sSQL= 'Update HT2400 Set ' + @ParaCal+  '= Col   From HT2400 HT inner join HV2823 HV on HT.EmployeeID=HV.EmployeeID
				and HT.DivisionID=HV.DivisionID and HT.DepartmentID=HV.DepartmentID and IsNull(HT.TeamID,'''')=IsNull(HV.TeamID,'''')
				Where HT.TranMonth= ' +str(@TranMonth)+ ' 
				and TranYear = '+ str(@TranYear) + '   and HT.DivisionID= ''' + @DivisionID+ ''' ' 

		Exec (@sSQL)


	End







GO


