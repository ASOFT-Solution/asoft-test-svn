IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2620]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2620]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
--- Created by Bao Anh Date: 15/01/2213  
--- Purpose: Load du lieu phu cap theo cong trinh  
--- Modify on 03/04/2013 by Bao Anh: Bo PeriodID  
--- Modify on 11/10/2013 by Bao Anh: Bo sung he so C14 -> C25  
---- Modified on 16/09/2013 by Le Thi Thu Hien : Chia doan SQL de khong bi cat chuoi
--- Modified on 22/10/2013 by Bao Anh : Bo sung cac muc luong
--- Modified on 19/11/2013 by Bao Anh : Bo sung cac he so luong, chuc vu, tham nien
--- Modify on 04/12/2013 by Bảo Anh: Bổ sung Order by
--- Modify on 08/01/2014 by Bảo Anh: Bổ sung phí giới thiệu (Unicare)
--- Modify on 11/04/2014 by Bảo Anh: Bỏ where điều kiện TeamID khi join HT2400 và HT2430
--- Modify on 26/01/2015 by Quốc Tuấn: bổ sung join bảng HT3400 để xem đã được tính lương chưa
--- EXEC HP2620 'UN','3A  HCM',11,2013  
  
CREATE PROCEDURE [dbo].[HP2620]  
	@DivisionID nvarchar(50),    
    @ProjectID  NVARCHAR(50),   
    @TranMonth int,    
    @TranYear int  
    ---@PeriodID  NVARCHAR(50) = NULL    
AS    
Declare @sSQL nvarchar(max)  
Declare @sSQL1 nvarchar(max)  
Declare @AP4444 Table(CustomerName Int, Export Int)  
Insert Into @AP4444(CustomerName,Export) EXEC('AP4444')

Set @sSQL = N'SELECT * FROM (  
Select HT.DivisionID, HT.DepartmentID, HT.TeamID, HT.EmployeeID, FullName, HT.TranMonth, HT.TranYear,(Case When  HT.TranMOnth <10 then ''0''+rtrim(ltrim(str(HT.TranMonth)))+''/''+ltrim(Rtrim(str(HT.TranYear)))     
 Else rtrim(ltrim(str(HT.TranMonth)))+''/''+ltrim(Rtrim(str(HT.TranYear))) End) as MonthYear, Notes, HV.Orders, HV.WorkDate, HT02.ProjectID,
 Sum(Isnull(HT02.BaseSalary,HT.BaseSalary)) as BaseSalary, Sum(Isnull(HT02.Salary01,HT.Salary01)) as Salary01, Sum(Isnull(HT02.Salary02,HT.Salary02)) as Salary02, Sum(Isnull(HT02.Salary03,HT.Salary03)) as Salary03,
 Sum(Isnull(HT02.SalaryCoefficient,HT.SalaryCoefficient)) as SalaryCoefficient,
 Sum(Isnull(HT02.DutyCoefficient,HT.DutyCoefficient)) as DutyCoefficient,
 Sum(Isnull(HT02.TimeCoefficient,HT.TimeCoefficient)) as TimeCoefficient,
 Sum(Isnull(HT02.C01,HT.C01)) as C01, Sum(Isnull(HT02.C02,HT.C02)) as C02, Sum(Isnull(HT02.C03,HT.C03)) as C03,
 '
 
IF (Select CustomerName From @AP4444) = 21 --- Unicare
	Set @sSQL = @sSQL + '(case when (Select count(EmployeeID) From HT1403 Where DivisionID = HT.DivisionID And MidEmployeeID = HT.EmployeeID
									And datediff(month,WorkDate,''' + ltrim(@TranMonth) + '/25/' + LTRIM(@TranYear) + ''') >= 1
									And datediff(month,WorkDate,''' + ltrim(@TranMonth) + '/25/' + LTRIM(@TranYear) + ''') < 2
									And EmployeeStatus not in (3,9)) > 0
						 then Isnull(Sum(HT02.C04),(Select count(*) From HT1403 Where DivisionID = HT.DivisionID And MidEmployeeID = HT.EmployeeID
												And datediff(month,WorkDate,''' + ltrim(@TranMonth) + '/25/' + LTRIM(@TranYear) + ''') >= 1 
												And datediff(month,WorkDate,''' + ltrim(@TranMonth) + '/25/' + LTRIM(@TranYear) + ''') < 2
												And EmployeeStatus not in (3,9)) * 100000)
						 else Sum(Isnull(HT02.C04,HT.C04)) end) as C04,'
ELSE
	Set @sSQL = @sSQL + 'Sum(Isnull(HT02.C04,HT.C04)) as C04,'
	
 Set @sSQL = @sSQL + 'Sum(Isnull(HT02.C05,HT.C05)) as C05,  
 Sum(Isnull(HT02.C06,HT.C06)) as C06, Sum(Isnull(HT02.C07,HT.C07)) as C07, Sum(Isnull(HT02.C08,HT.C08)) as C08, Sum(Isnull(HT02.C09,HT.C09)) as C09, Sum(Isnull(HT02.C10,HT.C10)) as C10,  
 Sum(Isnull(HT02.C11,HT.C11)) as C11, Sum(Isnull(HT02.C12,HT.C12)) as C12, Sum(Isnull(HT02.C13,HT.C13)) as C13, Sum(Isnull(HT02.C14,HT.C14)) as C14, Sum(Isnull(HT02.C15,HT.C15)) as C15,  
 Sum(Isnull(HT02.C16,HT.C16)) as C16, Sum(Isnull(HT02.C17,HT.C17)) as C17, Sum(Isnull(HT02.C18,HT.C18)) as C18, Sum(Isnull(HT02.C19,HT.C19)) as C19, Sum(Isnull(HT02.C20,HT.C20)) as C20,  
 Sum(Isnull(HT02.C21,HT.C21)) as C21, Sum(Isnull(HT02.C22,HT.C22)) as C22, Sum(Isnull(HT02.C23,HT.C23)) as C23, Sum(Isnull(HT02.C24,HT.C24)) as C24, Sum(Isnull(HT02.C25,HT.C25)) as C25,
 (CASE WHEN ISNULL(HT3400.EmployeeID,'''')<>'''' THEN 1 ELSE 0 END) IsEdit
 '  
  
Set @sSQL1 = left(@sSQL, len(@sSQl) - 1) +  N' 
FROM HT2400 HT  
LEFT JOIN HT2430 HT02 ON HT.DivisionID=HT02.DivisionID and HT.DepartmentID=HT02.DepartmentID    
---   and IsNull(HT.TeamID,'''')=ISNull(HT02.TeamID,'''')
   and HT.EmployeeID=HT02.EmployeeID and    
   HT.TranMonth=HT02.TranMonth and HT.TranYear=HT02.TranYear and  
   Isnull(HT02.ProjectID,'''') = Isnull(''' + @ProjectID + ''','''')        
    LEFT JOIN HV1400 HV on HT.EmployeeID = HV.EmployeeID and HT.DivisionID=HV.DivisionID 
    LEFT JOIN HT3400 ON HT3400.DivisionID=HT.DivisionID and HT3400.EmployeeID=HT.EmployeeID
      and HT3400.DepartmentID=HT.DepartmentID and IsNull(HT3400.TeamID,'''')=IsNull(HT.TeamID,'''')
      and HT3400.TranMonth=HT.TranMonth and HT3400.TranYear=HT.TranYear  
 WHERE HT.DivisionID = ''' + @DivisionID + ''' and    
  HT.EmployeeID in (Select EmployeeID from HT2421 Where DivisionID = ''' + @DivisionID + ''' And ProjectID = ''' + @ProjectID + '''  and  
  TranMonth = ' + cast(@TranMonth as nvarchar(2)) + ' and TranYear = ' + cast(@TranYear as nvarchar(4)) + ') and  
  HT.TranMonth = ' + cast(@TranMonth as nvarchar(2)) + ' and    
  HT.TranYear = ' + cast(@TranYear as nvarchar(4)) + '      
 GROUP BY  HT.DivisionID, HT.DepartmentID, HT.TeamID, HT.EmployeeID, FullName, HT.TranMonth, HT.TranYear, Notes, HV.Orders, HV.WorkDate, HT02.ProjectID,HT3400.EmployeeID) A
 Order by EmployeeID'   
  
---PRINT @sSQL  
---PRINT @sSQL1 
EXEC(@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
