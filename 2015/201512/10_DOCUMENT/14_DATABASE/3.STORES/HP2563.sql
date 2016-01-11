IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2563]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2563]
GO
----Created date: 11/07/2005  
----purpose: In bang cham cong  
---Edit by Huynh Trung Dung ,date 17/12/2010 --- Them tham so @ToDepartmentID  
CREATE PROCEDURE HP2563  @DivisionID nvarchar(50),  
    @DepartmentID nvarchar(50),   
    @ToDepartmentID nvarchar(50),   
    @TeamID nvarchar(50),  
    @FromDate datetime,  
    @ToDate datetime  
      
      
  
AS   
DECLARE   
 @sSQL1 nvarchar(4000)  
   
  
  
  
Set @sSQL1= 'Select HV.TeamID ,HV.TeamName, HV.EmployeeID, HV.FullName, HV.DivisionID,HV.DepartmentID, AT02.DepartmentName, HV.DutyID, HV.DutyName, WorkDate   
  From HV1400 HV left join AT1102  AT02 on HV.DivisionID=AT02.DivisionID and HV.DepartmentID=AT02.DepartmentID   
  Where HV.DivisionID= ''' + @DivisionID + ''' and HV.DepartmentID between '''+ @DepartmentID+''' and '''+ @ToDepartmentID+''' and IsNull(HV.TeamID,'''') like  ''' + IsNull(@TeamID,'') +'''   
  and HV.EmployeeStatus=1'  
  
  
If not exists (Select Top 1 1 From SysObjects Where Xtype = 'V' and Name = 'HV2564' )  
 EXEC('Create View HV2564 ---tao boi HP2563  
   as ' + @sSQL1)  
else  
 EXEC('Alter View HV2564 ---tao boi HP2563  
   as ' + @sSQL1)