IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP0289]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP0289]
GO
----Create on 08/10/2013 by Nguyễn Thanh Sơn
----In report chấm công theo ca
----  EXEC HP0289 'CTY','BKS','SX','%','%','2013-10-01 00:00:00','2013-10-31 00:00:00',1

CREATE PROCEDURE HP0289
(
     @DivisionID NVARCHAR(50),  
     @DepartmentID NVARCHAR(50),   
     @ToDepartmentID NVARCHAR(50),  
     @TeamID NVARCHAR(50),  
     @EmployeeID NVARCHAR(50),       
     @FromDate DATETIME,   
     @ToDate DATETIME,  
     @gnLang TINYINT  
)    
AS 

DECLARE 
 @sSQL NVARCHAR(4000),  
 @sSQL0 NVARCHAR(4000),   
 @AbsentDate DATETIME,  
 @DateAmount INT,  
 @i INT,  
 @DateName NVARCHAR(50),
 @sSQL2 NVARCHAR(4000) 
 
SELECT @sSQL0 = '', @sSQL = ''
SELECT @DateAmount = DATEDIFF(DAY, @FromDate, @ToDate) + 2, @i = 1  
SET @AbsentDate = @FromDate  

IF @gnLang = 0
BEGIN
  WHILE @i < @DateAmount  
  BEGIN 
    SET @DateName = 
    CASE 
    WHEN DATENAME(dw, @AbsentDate) = 'Monday' THEN 'T2'  
    WHEN DATENAME(dw, @AbsentDate) = 'Tuesday' THEN 'T3'        
    WHEN DATENAME(dw, @AbsentDate) = 'Wednesday' THEN 'T4'    
    WHEN DATENAME(dw, @AbsentDate) = 'Thursday' THEN 'T5'        
    WHEN DATENAME(dw, @AbsentDate) = 'Friday' THEN 'T6'        
    WHEN DATENAME(dw, @AbsentDate) = 'Saturday' THEN 'T7'        
    ELSE 'CN'        
    END      
    SET @sSQL0 = @sSQL0 + ' Select   
    cast(''' + LTRIM(MONTH(@AbsentDate)) + '/' + LTRIM(DAY(@AbsentDate)) + '/' + LTRIM(YEAR(@AbsentDate)) + ''' as datetime) as AbsentDate,''' +  
    CONVERT(NVARCHAR(5), @AbsentDate, 103) + ''' as Days,''' + @DateName + ''' as Dates,''' + @DivisionID + ''' as  DivisionID   Union'  
    SET @i = @i + 1  
    SET @AbsentDate =  DATEADD(DAY, 1, @AbsentDate)   
  END
  SET @sSQL0 = left(@sSQL0, LEN(@sSQL0) - 5) 
  IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV0290')   
  EXEC('Create View HV0290 --- tao boi HP0289  
   as ' + @sSQL0)  
  EXEC('Alter View HV0290 --- tao boi HP0289 
   as ' + @sSQL0) 
      
  Set @sSQL = '
  SELECT HT00.ShiftID, H20.ShiftName, HT00.DivisionID, HT00.DepartmentID, AT00.DepartmentName, HT00.TeamID, HT1101.TeamName, HT00.EmployeeID, FullName,   
  Birthday, HT00.AbsentDate, HT00.AbsentTypeID, AbsentName, UnitID, AbsentAmount,   
  HV00.Orders, HT01.Orders AS OrdersAbsentType, H07.FromTimeValid, H07.ToTimeValid
  FROM HT0284  HT00  
  INNER JOIN HV1400 HV00 ON HV00.EmployeeID = HT00.EmployeeID AND HV00.DivisionID = HT00.DivisionID   
  INNER JOIN AT1102  AT00 ON AT00.DepartmentID = HT00.DepartmentID AND AT00.DivisionID = HT00.DivisionID   
  INNER JOIN HT1013 HT01 ON HT01.AbsentTypeID = HT00.AbsentTypeID AND HT01.DivisionID = HT00.DivisionID
  LEFT JOIN HT1101  ON HT1101.DivisionID = HT00.DivisionID AND HT1101.TeamID = HT00.TeamID
  LEFT JOIN HT2407 H07 ON H07.DivisionID = HT00.DivisionID AND H07.EmployeeID = HT00.EmployeeID AND H07.AbsentDate = HT00.AbsentDate AND H07.AbsentTypeID = HT00.AbsentTypeID
  LEFT JOIN HT1020 H20 ON H20.DivisionID=HT00.DivisionID AND H20.ShiftID=HT00.ShiftID
  WHERE HT00.DivisionID = ''' + @DivisionID + ''' 
  AND   HT00.DepartmentID BETWEEN ''' + @DepartmentID + ''' AND ''' + @ToDepartmentID + ''' 
  AND   ISNULL(HT00.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''') 
  AND   HT00.EmployeeID LIKE ''' + @EmployeeID + ''' 
  AND  (HT00.AbsentDate BETWEEN ''' +  CONVERT(NVARCHAR(10), @FromDate, 101) + '''  AND ''' + CONVERT(NVARCHAR(10), @ToDate, 101) + ''')
  '  
If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV0289')   
 EXEC('Create view HV0289 --- tao boi HP0289  
   as ' + @sSQL)  
 EXEC('Alter view HV0289--- tao boi HP0289  
   as ' + @sSQL)    
END --ket thuc tieng Viet

IF @gnLang = 1 --bắt đầu tiếng Anh
BEGIN
  WHILE @i < @DateAmount  
  BEGIN 
    SET @DateName = 
    CASE 
    WHEN DATENAME(dw, @AbsentDate) = 'Monday' THEN 'Mon'  
    WHEN DATENAME(dw, @AbsentDate) = 'Tuesday' THEN 'Tue'        
    WHEN DATENAME(dw, @AbsentDate) = 'Wednesday' THEN 'Wed'    
    WHEN DATENAME(dw, @AbsentDate) = 'Thursday' THEN 'Thu'        
    WHEN DATENAME(dw, @AbsentDate) = 'Friday' THEN 'Fri'        
    WHEN DATENAME(dw, @AbsentDate) = 'Saturday' THEN 'Sat'        
    ELSE 'Sun'        
    END      
    SET @sSQL0 = @sSQL0 + ' Select   
    cast(''' + LTRIM(MONTH(@AbsentDate)) + '/' + LTRIM(DAY(@AbsentDate)) + '/' + LTRIM(YEAR(@AbsentDate)) + ''' as datetime) as AbsentDate,''' +  
    CONVERT(NVARCHAR(5), @AbsentDate, 103) + ''' as Days,''' + @DateName + ''' as Dates,''' + @DivisionID + ''' as  DivisionID   Union'  
    SET @i = @i + 1  
    SET @AbsentDate =  DATEADD(DAY, 1, @AbsentDate)   
  END
  SET @sSQL0 = left(@sSQL0, LEN(@sSQL0) - 5) 
  IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND Name = 'HV0290')   
  EXEC('Create View HV0290 --- tao boi HP0289  
   as ' + @sSQL0)  
  EXEC('Alter View HV0290 --- tao boi HP0289 
   as ' + @sSQL0) 
      
  Set @sSQL = '
  SELECT HT00.ShiftID, H20.ShiftName, HT00.DivisionID, HT00.DepartmentID, AT00.DepartmentName, HT00.TeamID, HT1101.TeamName, HT00.EmployeeID, FullName,   
  Birthday, HT00.AbsentDate, HT00.AbsentTypeID, AbsentName, UnitID, AbsentAmount,   
  HV00.Orders, HT01.Orders AS OrdersAbsentType, H07.FromTimeValid, H07.ToTimeValid
  FROM HT0284  HT00  
  INNER JOIN HV1400 HV00 ON HV00.EmployeeID = HT00.EmployeeID AND HV00.DivisionID = HT00.DivisionID   
  INNER JOIN AT1102  AT00 ON AT00.DepartmentID = HT00.DepartmentID AND AT00.DivisionID = HT00.DivisionID   
  INNER JOIN HT1013 HT01 ON HT01.AbsentTypeID = HT00.AbsentTypeID AND HT01.DivisionID = HT00.DivisionID
  LEFT JOIN HT1101  ON HT1101.DivisionID = HT00.DivisionID AND HT1101.TeamID = HT00.TeamID
  LEFT JOIN HT2407 H07 ON H07.DivisionID = HT00.DivisionID AND H07.EmployeeID = HT00.EmployeeID AND H07.AbsentDate = HT00.AbsentDate AND H07.AbsentTypeID = HT00.AbsentTypeID
  LEFT JOIN HT1020 H20 ON H20.DivisionID=HT00.DivisionID AND H20.ShiftID=HT00.ShiftID
  WHERE HT00.DivisionID = ''' + @DivisionID + ''' 
  AND   HT00.DepartmentID BETWEEN ''' + @DepartmentID + ''' AND ''' + @ToDepartmentID + ''' 
  AND   ISNULL(HT00.TeamID, '''') LIKE ISNULL(''' + @TeamID + ''', '''') 
  AND   HT00.EmployeeID LIKE ''' + @EmployeeID + ''' 
  AND  (HT00.AbsentDate BETWEEN ''' +  CONVERT(NVARCHAR(10), @FromDate, 101) + '''  AND ''' + CONVERT(NVARCHAR(10), @ToDate, 101) + ''')
  '  
If not exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV0289')   
 EXEC('Create view HV0289 --- tao boi HP0289  
   as ' + @sSQL)  
 EXEC('Alter view HV0289--- tao boi HP0289  
   as ' + @sSQL)    
END --ket thuc tieng Anh
 
SET @sSQL2=N'
SELECT  HV0289.ShiftID, HV0289.ShiftName, HV0289.DepartmentID, HV0289.DepartmentName, HV0289.EmployeeID, HV0289.FullName,HV0289.Birthday, HV0289.AbsentTypeID,
		HV0289.AbsentName, HV0289.UnitID, HV0289.AbsentAmount,HV0290.AbsentDate , HV0290.Days, HV0290.Dates
FROM HV0289,HV0290
WHERE HV0289.AbsentDate = HV0290.AbsentDate and HV0289.DivisionID = HV0290.DivisionID
AND ((ISNULL(HV0289.DepartmentID,''#'') in ('''') OR (0=0)))
AND HV0289.DivisionID = '''+@DivisionID+'''
ORDER BY HV0289.ShiftID
' 
EXEC(@sSQL2)
 
