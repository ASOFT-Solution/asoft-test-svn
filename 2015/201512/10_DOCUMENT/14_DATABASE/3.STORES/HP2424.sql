IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2424]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2424]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[HP2424]  
@DivisionID nvarchar(50),    
     @DepartmentID nvarchar(50),
     @ToDepartmentID nvarchar(50),        
     @TeamID nvarchar(50),    
     @EmployeeID nvarchar(50),         
     @TranMonth int,    
     @TranYear int        
AS    
Declare @sSQL1 nvarchar(4000),    
 @sSQL2 nvarchar(4000),     
 @AbsentTypeID nvarchar(50),    
 @DateAmount int,    
 @i int,    
 @AbsentTypeName nvarchar(50)    
    
Set @sSQL1 = 'Select Distinct H00.DivisionID, H00.AbsentTypeID, Caption, Orders, UnitID    
  From HT2402 H00 inner join HT1013 H01 on H00.AbsentTypeID = H01.AbsentTypeID and H00.DivisionID = H01.DivisionID    
  Where H00.DivisionID = N''' + @DivisionID + ''' and    
   DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' and
   Isnull(TeamID, '''') like Isnull(N''' + @TeamID + ''', '''') and    
   TranMonth = ' + cast(@TranMonth as varchar(2)) + ' and    
   TranYear = ' + cast(@TranYear as varchar(4))    
        
    
If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2415')    
 exec('Create view HV2415 ----tao boi HP2424    
   as ' + @sSQL1)    
else    
 exec('Alter view HV2415 ----tao boi HP2424    
   as ' + @sSQL1)    
    
Set @sSQL2 = N'Select  H00.DivisionID, H00.DepartmentID,H00.TeamID , AT00.DepartmentName, H00.EmployeeID, FullName,     
  Case when Birthday is Null then Null else convert(Varchar(10),Birthday,103) end as Birthday, H00.AbsentTypeID,  sum(AbsentAmount) as AbsentAmount, HV00.Orders, DutyName    
 From HT2402  H00  inner join HV1400 HV00 on HV00.EmployeeID = H00.EmployeeID and HV00.DivisionID = H00.DivisionID     
  inner join AT1102  AT00 on AT00.DepartmentID = H00.DepartmentID and AT00.DivisionID = H00.DivisionID     
 Where H00.DivisionID = N''' + @DivisionID + ''' and    
  H00.DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' and
  Isnull(H00.TeamID, ''' + ''') like Isnull(N''' + @TeamID + ''', ''' + ''') and      
  H00.EmployeeID like N''' + @EmployeeID + ''' and      
  H00.TranMonth = ' + cast(@TranMonth as varchar(2)) + ' and     
  H00.TranYear = ' + cast(@TranYear as varchar(4)) +     
 ' Group by  H00.DivisionID, H00.DepartmentID,  AT00.DepartmentName, H00.EmployeeID, FullName,     
  Birthday, H00.AbsentTypeID, HV00.Orders,  DutyName,H00.TeamID '    
/*    
Union    
Select  H00.DivisionID, ''zzzzzzzz'' as DepartmentID, ''TOÅNG COÄNG'' as DepartmentName, '''' as EmployeeID, '''' asFullName,     
  NULL as Birthday,  H00.AbsentTypeID, sum( AbsentAmount) as AbsentAmount,     
  0 as Orders, '''' as DutyName    
 From HT2402  H00      
 Where H00.DivisionID = ''' + @DivisionID + ''' and    
  H00.DepartmentID like ''' + @DepartmentID + ''' and    
  Isnull(H00.TeamID, ''' + ''') like Isnull(''' + @TeamID + ''', ''' + ''') and      
  H00.EmployeeID like ''' + @EmployeeID + ''' and      
  TranYear = ' + cast(@TranYear as varchar(4)) + ' and    
  TranMonth = ' + cast(@TranMonth as varchar(2)) +     
 ' Group by H00.DivisionID, H00.AbsentTypeID'    
*/    
    
If not exists (Select  1 From sysObjects Where XType = 'V' and Name = 'HV2424')    
 exec('Create view HV2424 ----tao boi HP2424    
   as '+ @sSQL2)    
else    
 exec('Alter view HV2424 ----tao boi HP2424    
   as ' + @sSQL2)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

