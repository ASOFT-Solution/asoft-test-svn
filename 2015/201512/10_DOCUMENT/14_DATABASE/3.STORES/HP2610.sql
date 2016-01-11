IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2610]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2610]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- Created by Bao Anh	Date: 15/01/2213
--- Purpose: Load du lieu cham cong theo cong trinh
--- Modify on 04/12/2013 by Bảo Anh: Bổ sung Order by
--- Modify on 02/04/2014 by Bảo Anh: Bỏ where TeamID khi join HT2400 và HT2432
--- EXEC HP2610 'as','123',1,2012,'P01',0

CREATE PROCEDURE [dbo].[HP2610]  @DivisionID nvarchar(50),  
    @ProjectID  NVARCHAR(50), 
    @TranMonth int,  
    @TranYear int,  
    @PeriodID  NVARCHAR(50) = NULL,
    @IsInherit int = 0
AS  
Declare @sSQL nvarchar(max),  
 @cur cursor,  
 @Column int,  
 @AbsentTypeID  NVARCHAR(50)  
  
  
Select @Column = 1, @sSQL = ''   
Set @sSQL = N'SELECT * FROM (
Select HT.DivisionID, HT.DepartmentID, HT.TeamID, HT.EmployeeID, FullName, HT.TranMonth, HT.TranYear,(Case When  HT.TranMOnth <10 then ''0''+rtrim(ltrim(str(HT.TranMonth)))+''/''+ltrim(Rtrim(str(HT.TranYear)))   
 Else rtrim(ltrim(str(HT.TranMonth)))+''/''+ltrim(Rtrim(str(HT.TranYear))) End) as MonthYear, Notes, HV.Orders, HT02.ProjectID, HT02.PeriodID,'    
Set @cur = Cursor scroll keyset for  
  Select AbsentTypeID From HT1013 Where IsMonth = 1  and DivisionID = @DivisionID
  Order by Orders, AbsentTypeID  
Open @cur  
Fetch next from @cur into @AbsentTypeID  
  
While @@Fetch_Status = 0  
Begin   
 Set @sSQL = @sSQL + 'sum(case when AbsentTypeID = ''' + @AbsentTypeID +  
    ''' then AbsentAmount else NULL end) as TC' + right('0' + convert(varchar(2), @Column),2) +','   
 Set @Column = @Column + 1  
 Fetch next from @cur into @AbsentTypeID  
End   

Set @sSQL = left(@sSQL, len(@sSQl) - 1) +  ' From HT2400 HT
	LEFT JOIN HT2432 HT02 ON HT.DivisionID=HT02.DivisionID and HT.DepartmentID=HT02.DepartmentID  
	  and HT.EmployeeID=HT02.EmployeeID and  
	  HT.TranMonth=HT02.TranMonth and HT.TranYear=HT02.TranYear and
	  Isnull(HT02.ProjectID,'''') = Isnull(''' + @ProjectID + ''','''') and
	  Isnull(HT02.PeriodID,'''') = Isnull(''' + @PeriodID + ''','''')       
    Left join HV1400 HV on HT.EmployeeID = HV.EmployeeID and HT.DivisionID=HV.DivisionID  
	Where HT.DivisionID = ''' + @DivisionID + ''' and  
		HT.EmployeeID in (Select EmployeeID from HT2421 Where DivisionID = ''' + @DivisionID + ''' And ProjectID = ''' + @ProjectID + '''  and
		TranMonth + 12*TranYear = ' + cast((@TranMonth + 12*@TranYear) as nvarchar(6)) +') and
		HT.TranMonth + 12*HT.TranYear = ' + cast((case when @IsInherit = 0 then @TranMonth+12*@TranYear else (@TranMonth+12*@TranYear)-1 end) as nvarchar(6)) + ' and  
		HT.TranYear = ' + cast(@TranYear as nvarchar(40)) + '    
	Group by  HT.DivisionID, HT.DepartmentID, HT.TeamID, HT.EmployeeID, FullName, HT.TranMonth, HT.TranYear, Notes, HV.Orders, HT02.ProjectID, HT02.PeriodID) A
	Order by EmployeeID'  

---print @sSQL
EXEC(@sSQL)
Close @cur