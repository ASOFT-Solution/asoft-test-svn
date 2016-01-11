

/****** Object:  StoredProcedure [dbo].[HP2600]    Script Date: 11/26/2011 12:12:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2600]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2600]
GO



/****** Object:  StoredProcedure [dbo].[HP2600]    Script Date: 11/26/2011 12:12:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE [dbo].[HP2600]  @DivisionID nvarchar(50),  
    @DepartmentID  NVARCHAR(50), 
    @ToDepartmentID nvarchar(50), 
    @TeamID  NVARCHAR(50),  
    @EmployeeID  NVARCHAR(50),  
    @TranMonth int,  
    @TranYear int,  
    @PeriodID  NVARCHAR(50)=Null  
AS  
Declare @sSQL nvarchar(max),  
 @cur cursor,  
 @Column int,  
 @AbsentTypeID  NVARCHAR(50)  
  
  
Select @Column = 1, @sSQL = ''   
Set @sSQL = 'Select HT.DivisionID, HT.DepartmentID, HT.TeamID, HT.EmployeeID, FullName, HT.TranMonth, HT.TranYear,(Case When  HT.TranMOnth <10 then ''0''+rtrim(ltrim(str(HT.TranMonth)))+''/''+ltrim(Rtrim(str(HT.TranYear)))   
 Else rtrim(ltrim(str(HT.TranMonth)))+''/''+ltrim(Rtrim(str(HT.TranYear))) End) as MonthYear, Notes, HV.Orders, '    
Set @cur = Cursor scroll keyset for  
  Select AbsentTypeID From HT1013 Where IsMonth = 1  and DivisionID = @DivisionID
  Order by Orders, AbsentTypeID  
Open @cur  
Fetch next from @cur into @AbsentTypeID  
  
While @@Fetch_Status = 0  
Begin   
 Set @sSQL = @sSQL + 'sum(case when AbsentTypeID = ''' + @AbsentTypeID +  
    ''' then AbsentAmount else NULL end) as C' + right('0' + convert(varchar(2), @Column),2) +', '   
 Set @Column = @Column + 1  
 Fetch next from @cur into @AbsentTypeID  
End   
if @PeriodID is Null  
 Set @sSQL = left(@sSQL, len(@sSQl) - 1) +  ' From HT2400 HT LEFT JOIN HT2402 HT02 ON HT.EmployeeID=HT02.EmployeeID  
      and HT.DivisionID=HT02.DivisionID and HT.DepartmentID=HT02.DepartmentID  
      and IsNull(HT.TeamID,'''')=ISNull(HT02.TeamID,'''') and HT.EmployeeID=HT02.EmployeeID and  
      HT.TranMonth=HT02.TranMonth and HT.TranYear=HT02.TranYear  
      left join HV1400 HV on HT.EmployeeID = HV.EmployeeID and HT.DivisionID=HV.DivisionID  
   Where HT.DivisionID = ''' + @DivisionID + ''' and  
    HT.DepartmentID between ''' + @DepartmentID + ''' and  ''' + @ToDepartmentID + ''' and   
    isnull(HT.TeamID, '''') like isnull(''' + @TeamID + ''', '''')  and   
    HT.EmployeeID like ''' + @EmployeeID + '''  and  
    HT.TranMonth = ' + cast(@TranMonth as nvarchar(2)) + ' and  
    HT.TranYear = ' + cast(@TranYear as nvarchar(40)) + ' and
    HT02.PeriodID like ''' + @PeriodID + '''  
   Group by  HT.DivisionID, HT.DepartmentID, HT.TeamID, HT.EmployeeID, FullName, HT.TranMonth, HT.TranYear, Notes, HV.Orders'  
else  
 Set @sSQL = left(@sSQL, len(@sSQl) - 1) +  ' From HT2400 HT LEFT JOIN HT2402 HT02 ON HT.EmployeeID=HT02.EmployeeID  
      and HT.DivisionID=HT02.DivisionID and HT.DepartmentID=HT02.DepartmentID  
      and IsNull(HT.TeamID,'''')=ISNull(HT02.TeamID,'''') and HT.EmployeeID=HT02.EmployeeID and  
      HT.TranMonth=HT02.TranMonth and HT.TranYear=HT02.TranYear  
      left join HV1400 HV on HT.EmployeeID = HV.EmployeeID and HT.DivisionID=HV.DivisionID  
   Where HT.DivisionID = ''' + @DivisionID + ''' and   
    HT.DepartmentID between ''' + @DepartmentID + ''' and  ''' + @ToDepartmentID + ''' and     
    isnull(HT.TeamID, '''') like isnull(''' + @TeamID + ''', '''')  and   
    HT.EmployeeID like ''' + @EmployeeID + '''  and   
    HT.TranMonth = ' + cast(@TranMonth as nvarchar(2)) + ' and   
    HT.TranYear = ' + cast(@TranYear as nvarchar(40)) + ' and   
    HT02.PeriodID like ''' + @PeriodID + '''   
   Group by  HT.DivisionID, HT.DepartmentID, HT.TeamID, HT.EmployeeID, FullName, HT.TranMonth, HT.TranYear, Notes, HV.Orders'  
  
If not  exists(Select  1 From sysObjects Where XType = 'V' and Name = 'HV2600')   
 exec('Create view HV2600 ---tao boi HP2600  
  as ' + @sSQL)  
Else  
 exec('Alter view HV2600 ---tao boi HP2600  
  as ' + @sSQL)  
    
Close @cur

GO


