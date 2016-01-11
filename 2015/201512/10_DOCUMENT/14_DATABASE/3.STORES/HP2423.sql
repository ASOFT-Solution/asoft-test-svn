IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2423]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2423]
GO
---- Created by Vo Thanh Huong  
-----Created date 20/08/2004  
----- purpose: Xu ly In cham cong ngay, Mau1: (C?t: AbsentDate)  
---Edit Huynh Trung Dung ,date 14/12/2010 --- Them tham so @ToDepartmentID
---- Modify on 27/07/2013 by Bao Anh: Bo sung to nhom, gio vao/ra (Thuan Loi)
---- Modify on 30/12/2013 by Bao Anh: Sua loi Tien Hung CRM TT7818 (sua cach lay FromTimeValid,ToTimeValid không join HT2407)
 
CREATE  PROCEDURE HP2423  @DivisionID nvarchar(50),  
     @DepartmentID nvarchar(50),   
     @ToDepartmentID nvarchar(50),  
     @TeamID nvarchar(50),  
     @EmployeeID nvarchar(50),       
     @FromDate Datetime,   
     @ToDate Datetime,  
     @gnLang int      
AS  
  
Declare @sSQL nvarchar(4000),  
 @sSQL0 nvarchar(4000),   
 @AbsentDate datetime,  
 @DateAmount int,  
 @i int,  
 @DateName nvarchar(50)  
  
Select @sSQL0 = '', @sSQL = ''  
Select @DateAmount = DATEDIFF(day, @FromDate, @ToDate) + 2, @i = 1  
Set @AbsentDate = @FromDate  
  
If @gnLang=0 --tieng Viet  
  
Begin  
  
While @i < @DateAmount  
Begin  
Set @DateName =    CASE WHEN DATENAME(dw, @AbsentDate) = 'Monday' THEN 'T2'  
        WHEN DATENAME(dw, @AbsentDate) = 'Tuesday' THEN 'T3'        
        WHEN DATENAME(dw, @AbsentDate) = 'Wednesday' THEN 'T4'    
         WHEN DATENAME(dw, @AbsentDate) = 'Thursday' THEN 'T5'        
         WHEN DATENAME(dw, @AbsentDate) = 'Friday' THEN 'T6'        
          WHEN DATENAME(dw, @AbsentDate) = 'Saturday' THEN 'T7'        
          ELSE 'CN'        
           END      
 Set @sSQL0 = @sSQL0 + ' Select   
    cast(''' + ltrim(month(@AbsentDate)) + '/' + ltrim(Day(@AbsentDate)) + '/' + ltrim(year(@AbsentDate)) + ''' as datetime) as AbsentDate,''' +  
    convert(nvarchar(5), @AbsentDate, 103) + ''' as Days,''' + @DateName + ''' as Dates,''' + @DivisionID + ''' as  DivisionID   Union'  
         
--- Insert HT2412(AbsentDate, Day, Date) values (@AbsentDate, convert(nvarchar(5), @AbsentDate, 103), @DateName)  
   
 Set @i = @i + 1  
 Set @AbsentDate =  Dateadd(Day, 1, @AbsentDate)   
End  
  
Set @sSQL0 = left(@sSQL0, len(@sSQL0) - 5)  
  
If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV1406')   
 EXEC('Create View HV1406 --- tao boi HP2423  
   as ' + @sSQL0)  
 EXEC('Alter View HV1406 --- tao boi HP2423  
   as ' + @sSQL0)  
  
  
Set @sSQL = ' Select  HT00.DivisionID, HT00.DepartmentID,  AT00.DepartmentName, HT00.TeamID, HT1101.TeamName, HT00.EmployeeID, FullName,   
  Birthday,   
  --convert(nvarchar(10), HT00.AbsentDate,103) as AbsentDate,   
  HT00.AbsentDate,  
  HT00.AbsentTypeID, AbsentName, UnitID, AbsentAmount,   
  HV00.Orders, HT01.Orders as OrdersAbsentType,
  (Select top 1 FromTimeValid From HT2407 Where DivisionID = HT00.DivisionID and EmployeeID = HT00.EmployeeID and AbsentDate = HT00.AbsentDate and AbsentTypeID = HT00.AbsentTypeID) as FromTimeValid,
  (Select top 1 ToTimeValid From HT2407 Where DivisionID = HT00.DivisionID and EmployeeID = HT00.EmployeeID and AbsentDate = HT00.AbsentDate and AbsentTypeID = HT00.AbsentTypeID) as ToTimeValid
 
 From HT2401  HT00  inner join HV1400 HV00 on HV00.EmployeeID = HT00.EmployeeID and HV00.DivisionID = HT00.DivisionID   
  inner join AT1102  AT00 on AT00.DepartmentID = HT00.DepartmentID and AT00.DivisionID = HT00.DivisionID   
  inner join HT1013 HT01 on HT01.AbsentTypeID = HT00.AbsentTypeID and HT01.DivisionID = HT00.DivisionID
  left join HT1101  on HT1101.DivisionID = HT00.DivisionID and HT1101.TeamID = HT00.TeamID
 
 Where HT00.DivisionID = ''' + @DivisionID + ''' and  
  HT00.DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' and  
  Isnull(HT00.TeamID, ''' + ''') like Isnull(''' + @TeamID + ''', ''' + ''') and    
  HT00.EmployeeID like ''' + @EmployeeID + ''' and    
  (HT00.AbsentDate between ''' +  convert(nvarchar(10), @FromDate, 101) + '''  and ''' + convert(nvarchar(10), @ToDate, 101) + ''')'  
/*  
 Select  HT00.DivisionID, ''zzzzzzzz'' as DepartmentID,  ''TOÅNG COÄNG'' as DepartmentName, '''' as EmployeeID, '''' asFullName,   
  NULL as Birthday, convert(nvarchar(10), HT00.AbsentDate, 103) as AbsentDate, HT00.AbsentTypeID, AbsentName, UnitID,sum( AbsentAmount) as AbsentAmount,   
  0 as Orders, HT01.Orders as OrdersAbsentType  
 From HT2401  HT00  inner join HT1013 HT01 on HT01.AbsentTypeID = HT00.AbsentTypeID    
 Where HT00.DivisionID = ''' + @DivisionID + ''' and  
  HT00.DepartmentID like ''' + @DepartmentID + ''' and  
  Isnull(HT00.TeamID, ''' + ''') like Isnull(''' + @TeamID + ''', ''' + ''') and    
  HT00.EmployeeID like ''' + @EmployeeID + ''' and    
  (HT00.AbsentDate between ''' +  convert(nvarchar(10), @FromDate, 101) + '''  and ''' + convert(nvarchar(10), @ToDate, 101) + ''')  
 Group by HT00.DivisionID, HT00.AbsentTypeID, AbsentName, UnitID, HT01.Orders, HT00.AbsentDate'  
*/  
If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2403')   
 EXEC('Create view HV2403 --- tao boi HP2423  
   as ' + @sSQL)  
 EXEC('Alter view HV2403 --- tao boi HP2423  
   as ' + @sSQL)  
End ----Ket thuc tieng Viet  
  
Else   
  
Begin --tieng Anh  
  
While @i < @DateAmount  
Begin  
Set @DateName =    CASE WHEN DATENAME(dw, @AbsentDate) = 'Monday' THEN 'Mon'  
        WHEN DATENAME(dw, @AbsentDate) = 'Tuesday' THEN 'Tue'        
        WHEN DATENAME(dw, @AbsentDate) = 'Wednesday' THEN 'Wed'    
         WHEN DATENAME(dw, @AbsentDate) = 'Thursday' THEN 'Thu'        
         WHEN DATENAME(dw, @AbsentDate) = 'Friday' THEN 'Fri'        
          WHEN DATENAME(dw, @AbsentDate) = 'Saturday' THEN 'Sat'        
          ELSE 'Sun'        
           END      
 Set @sSQL0 = @sSQL0 + ' Select   
    cast(''' + ltrim(month(@AbsentDate)) + '/' + ltrim(Day(@AbsentDate)) + '/' + ltrim(year(@AbsentDate)) + ''' as datetime) as AbsentDate,''' +  
    convert(nvarchar(5), @AbsentDate, 103) + ''' as Days,''' + @DateName + ''' as Dates,''' + @DivisionID + ''' as  DivisionID Union'  
         
--- Insert HT2412(AbsentDate, Day, Date) values (@AbsentDate, convert(nvarchar(5), @AbsentDate, 103), @DateName)  
   
 Set @i = @i + 1  
 Set @AbsentDate =  Dateadd(Day, 1, @AbsentDate)   
End  
  
Set @sSQL0 = left(@sSQL0, len(@sSQL0) - 5)  
  
If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV1406')   
 EXEC('Create View HV1406 --- tao boi HP2423  
   as ' + @sSQL0)  
 EXEC('Alter View HV1406 --- tao boi HP2423  
   as ' + @sSQL0)  
  
  
Set @sSQL = ' Select  HT00.DivisionID, HT00.DepartmentID,  AT00.DepartmentName, HT00.TeamID, HT1101.TeamName, HT00.EmployeeID, FullName,   
  Birthday,   
  --convert(nvarchar(10), HT00.AbsentDate,103) as AbsentDate,   
  HT00.AbsentDate,  
  HT00.AbsentTypeID, AbsentName, UnitID, AbsentAmount,   
  HV00.Orders, HT01.Orders as OrdersAbsentType,
  (Select top 1 FromTimeValid From HT2407 Where DivisionID = HT00.DivisionID and EmployeeID = HT00.EmployeeID and AbsentDate = HT00.AbsentDate and AbsentTypeID = HT00.AbsentTypeID) as FromTimeValid,
  (Select top 1 ToTimeValid From HT2407 Where DivisionID = HT00.DivisionID and EmployeeID = HT00.EmployeeID and AbsentDate = HT00.AbsentDate and AbsentTypeID = HT00.AbsentTypeID) as ToTimeValid

 From HT2401  HT00  inner join HV1400 HV00 on HV00.EmployeeID = HT00.EmployeeID and HV00.DivisionID = HT00.DivisionID   
  inner join AT1102  AT00 on AT00.DepartmentID = HT00.DepartmentID and AT00.DivisionID = HT00.DivisionID   
  inner join HT1013 HT01 on HT01.AbsentTypeID = HT00.AbsentTypeID and HT01.DivisionID = HT00.DivisionID
  left join HT1101  on HT1101.DivisionID = HT00.DivisionID and HT1101.TeamID = HT00.TeamID

 Where HT00.DivisionID = ''' + @DivisionID + ''' and  
  HT00.DepartmentID between ''' + @DepartmentID + ''' and ''' + @ToDepartmentID + ''' and  
  Isnull(HT00.TeamID, ''' + ''') like Isnull(''' + @TeamID + ''', ''' + ''') and    
  HT00.EmployeeID like ''' + @EmployeeID + ''' and    
  (HT00.AbsentDate between ''' +  convert(nvarchar(10), @FromDate, 101) + '''  and ''' + convert(nvarchar(10), @ToDate, 101) + ''')'  
/*  
 Select  HT00.DivisionID, ''zzzzzzzz'' as DepartmentID,  ''TOÅNG COÄNG'' as DepartmentName, '''' as EmployeeID, '''' asFullName,   
  NULL as Birthday, convert(nvarchar(10), HT00.AbsentDate, 103) as AbsentDate, HT00.AbsentTypeID, AbsentName, UnitID,sum( AbsentAmount) as AbsentAmount,   
  0 as Orders, HT01.Orders as OrdersAbsentType  
 From HT2401  HT00  inner join HT1013 HT01 on HT01.AbsentTypeID = HT00.AbsentTypeID    
 Where HT00.DivisionID = ''' + @DivisionID + ''' and  
  HT00.DepartmentID like ''' + @DepartmentID + ''' and  
  Isnull(HT00.TeamID, ''' + ''') like Isnull(''' + @TeamID + ''', ''' + ''') and    
  HT00.EmployeeID like ''' + @EmployeeID + ''' and    
  (HT00.AbsentDate between ''' +  convert(nvarchar(10), @FromDate, 101) + '''  and ''' + convert(nvarchar(10), @ToDate, 101) + ''')  
 Group by HT00.DivisionID, HT00.AbsentTypeID, AbsentName, UnitID, HT01.Orders, HT00.AbsentDate'  
*/  
If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2403')   
 EXEC('Create view HV2403 --- tao boi HP2423  
   as ' + @sSQL)  
 EXEC('Alter view HV2403 --- tao boi HP2423  
   as ' + @sSQL)  
End