IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0279]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0279]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Do nguon danh sách trợ cấp thôi việc
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 14/08/2013 by Lê Thị Thu Hiền
---- Modified on 23/10/2013 by Thanh Sơn: bổ sung thêm một số trường để in và fix bug: 0021729
----
-- <Example>
---- EXEC HP0279 'SAS', 'ADMIN', 8, 2013,'2011-11-10 00:00:00.000'

CREATE PROCEDURE HP0279
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@TranMonth AS INT,
	@TranYear AS INT,
	@LeaveDate DATETIME = NULL,
	@EmployeeID VARCHAR(50) = '%'
	
	
) 
AS 
IF (@EmployeeID='') SET @EmployeeID='%'
IF @LeaveDate IS NULL SELECT @LeaveDate = LeaveDate FROM HT1403 WHERE DivisionID=@DivisionID AND EmployeeID=@EmployeeID

SELECT	HT00.DivisionID, HT00.EmployeeID,
LTRIM(RTRIM(ISNULL(HT00.LastName,'')))+ ' ' + LTRIM(RTRIM(ISNULL(HT00.MiddleName,''))) + ' ' + LTRIM(RTRIM(ISNULL(HT00.FirstName,''))) AS FullName,
(CASE WHEN HT00.IsMale = 1 THEN N'Nam' ELSE N'Nữ' END) AS Sex,
HT00.Birthday, YEAR(HT00.Birthday) AS BornYear, HT03.WorkDate,HT00.EmployeeStatus,
(CASE WHEN DATEDIFF(Month, HT03.WorkDate,'2008-12-31') - (12 * (DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')))+ 1 = 12 
 THEN DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')+1 ELSE DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31') END) AS Years,
(CASE WHEN DATEDIFF(Month, HT03.WorkDate,'2008-12-31') - (12 * (DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')) )+ 1 = 12 
 THEN 0 ELSE DATEDIFF(Month, HT03.WorkDate,'2008-12-31') - (12 * (DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')) )+ 1 END) AS Months,	 
CONVERT(VARCHAR(2),(CASE WHEN DATEDIFF(Month, HT03.WorkDate,'2008-12-31') - (12 * (DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')))+ 1 = 12 
 THEN DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')+1 ELSE DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31') END)) +N' năm '+ CONVERT(VARCHAR(2),(CASE WHEN DATEDIFF(Month, HT03.WorkDate,'2008-12-31') - (12 * (DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')) )+ 1 = 12 
 THEN 0 ELSE DATEDIFF(Month, HT03.WorkDate,'2008-12-31') - (12 * (DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')) )+ 1 END)) +N' tháng'  AS WorkTime,
(CASE WHEN DATEDIFF(Month, HT03.WorkDate,'2008-12-31') - (12 * (DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')))+ 1 >=6 AND DATEDIFF(Month, HT03.WorkDate,'2008-12-31') - (12 * (DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')))+ 1 <= 12
      THEN DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31') + 1
      WHEN DATEDIFF(Month, HT03.WorkDate,'2008-12-31') - (12 * (DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')))+ 1 = 0
      THEN DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')
      ELSE DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31') + 0.5 END) AS YearsNo,
ISNULL(ISNULL(HT13.SalaryAmounts,HT03.BaseSalary),0) AS BaseSalary1,
ISNULL(ISNULL(HT14.SalaryAmounts,HT03.BaseSalary),0) AS BaseSalary2,
ISNULL(ISNULL(HT15.SalaryAmounts,HT03.BaseSalary),0) AS BaseSalary3,
ISNULL(ISNULL(HT16.SalaryAmounts,HT03.BaseSalary),0) AS BaseSalary4,
ISNULL(ISNULL(HT17.SalaryAmounts,HT03.BaseSalary),0) AS BaseSalary5, 
ISNULL(ISNULL(HT18.SalaryAmounts,HT03.BaseSalary),0) AS BaseSalary6,	
	
(ISNULL(ISNULL(HT13.SalaryCoefficient,HT03.SalaryCoefficient),0) + 
ISNULL(ISNULL(HT14.SalaryCoefficient,HT03.SalaryCoefficient),0) +
ISNULL(ISNULL(HT15.SalaryCoefficient,HT03.SalaryCoefficient),0) +
ISNULL(ISNULL(HT16.SalaryCoefficient,HT03.SalaryCoefficient),0) +
ISNULL(ISNULL(HT17.SalaryCoefficient,HT03.SalaryCoefficient),0) + 
ISNULL(ISNULL(HT18.SalaryCoefficient,HT03.SalaryCoefficient),0))/6 AS SalaryCoefficient,

HT03.DutyID,@LeaveDate AS LeaveDate,AT02.DepartmentName,HT02.DutyName, NULL AS FirstTime, LTRIM(STR(MONTH(HT03.WorkDate))) + '/'+LTRIM(STR(YEAR(HT03.WorkDate))) AS FromMonth,LTRIM(STR(MONTH(@LeaveDate))) + '/'+LTRIM(STR(YEAR(@LeaveDate))) AS ToMonth,
(CASE WHEN MONTH(@LeaveDate)-1>0 THEN LTRIM(STR(MONTH(@LeaveDate)-1))+'/'+LTRIM(STR(YEAR(@LeaveDate))) ELSE LTRIM(STR(11+MONTH(@LeaveDate)))+'/'+LTRIM(STR(YEAR(@LeaveDate)-1)) END) AS Month5,
(CASE WHEN MONTH(@LeaveDate)-2>0 THEN LTRIM(STR(MONTH(@LeaveDate)-2))+'/'+LTRIM(STR(YEAR(@LeaveDate))) ELSE LTRIM(STR(10+MONTH(@LeaveDate)))+'/'+LTRIM(STR(YEAR(@LeaveDate)-1)) END) AS Month4,
(CASE WHEN MONTH(@LeaveDate)-3>0 THEN LTRIM(STR(MONTH(@LeaveDate)-3))+'/'+LTRIM(STR(YEAR(@LeaveDate))) ELSE LTRIM(STR(9+MONTH(@LeaveDate)))+'/'+LTRIM(STR(YEAR(@LeaveDate)-1)) END) AS Month3,
(CASE WHEN MONTH(@LeaveDate)-4>0 THEN LTRIM(STR(MONTH(@LeaveDate)-4))+'/'+LTRIM(STR(YEAR(@LeaveDate))) ELSE LTRIM(STR(8+MONTH(@LeaveDate)))+'/'+LTRIM(STR(YEAR(@LeaveDate)-1)) END) AS Month2,
(CASE WHEN MONTH(@LeaveDate)-5>0 THEN LTRIM(STR(MONTH(@LeaveDate)-5))+'/'+LTRIM(STR(YEAR(@LeaveDate))) ELSE LTRIM(STR(7+MONTH(@LeaveDate)))+'/'+LTRIM(STR(YEAR(@LeaveDate)-1)) END) AS Month1,
LTRIM(STR(CASE WHEN DATEDIFF(MONTH,HT03.WorkDate,'2010-09-01')-DATEDIFF(YEAR,HT03.WorkDate,'2010-09-01')*12>-1 THEN DATEDIFF(YEAR,HT03.WorkDate,'2010-09-01')	ELSE DATEDIFF(YEAR,HT03.WorkDate,'2010-09-01')-1  END))+N' năm '+LTRIM(STR(CASE WHEN DATEDIFF(MONTH,HT03.WorkDate,'2010-09-01')-DATEDIFF(YEAR,HT03.WorkDate,'2010-09-01')*12>=-1 THEN DATEDIFF(MONTH,HT03.WorkDate,'2010-09-01')-DATEDIFF(YEAR,HT03.WorkDate,'2010-09-01')*12+1 ELSE 13+DATEDIFF(MONTH,HT03.WorkDate,'2010-09-01')-DATEDIFF(YEAR,HT03.WorkDate,'2010-09-01')*12  END))+N' tháng' AS SecondTime,
LTRIM(STR(CASE WHEN DATEDIFF(MONTH,'2010-10-01',@LeaveDate)-DATEDIFF(YEAR,'2010-10-01',@LeaveDate)*12>-1 THEN DATEDIFF(YEAR,'2010-10-01',@LeaveDate) ELSE DATEDIFF(YEAR,'2010-10-01',@LeaveDate)-1  END))+N' năm '+LTRIM(STR(CASE WHEN DATEDIFF(MONTH,'2010-10-01',@LeaveDate)-DATEDIFF(YEAR,'2010-10-01',@LeaveDate)*12>=-1 THEN DATEDIFF(MONTH,'2010-10-01',@LeaveDate)-DATEDIFF(YEAR,'2010-10-01',@LeaveDate)*12+1 ELSE 13+DATEDIFF(MONTH,'2010-10-01',@LeaveDate)-DATEDIFF(YEAR,'2010-10-01',@LeaveDate)*12  END))+N' tháng' AS ThirdTime,
LTRIM(STR(CASE WHEN DATEDIFF(MONTH,WorkDate,@LeaveDate)-DATEDIFF(YEAR,WorkDate,@LeaveDate)*12>-1 THEN DATEDIFF(YEAR,WorkDate,@LeaveDate)	ELSE DATEDIFF(YEAR,WorkDate,@LeaveDate)-1  END))+N' năm '+LTRIM(STR(CASE WHEN DATEDIFF(MONTH,WorkDate,@LeaveDate)-DATEDIFF(YEAR,WorkDate,@LeaveDate)*12>=-1 THEN DATEDIFF(MONTH,WorkDate,@LeaveDate)-DATEDIFF(YEAR,WorkDate,@LeaveDate)*12+1 ELSE 13+DATEDIFF(MONTH,WorkDate,@LeaveDate)-DATEDIFF(YEAR,WorkDate,@LeaveDate)*12  END))+N' tháng' AS FourthTime,
(ISNULL(ISNULL(HT13.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT14.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT15.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT16.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT17.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT18.SalaryAmounts,HT03.BaseSalary),0))/6 AS BaseSalaryAverage,
(ISNULL(ISNULL(HT13.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT14.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT15.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT16.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT17.SalaryAmounts,HT03.BaseSalary),0)+
ISNULL(ISNULL(HT18.SalaryAmounts,HT03.BaseSalary),0))/6 
*(ISNULL(ISNULL(HT13.SalaryCoefficient,HT03.SalaryCoefficient),0) + 
ISNULL(ISNULL(HT14.SalaryCoefficient,HT03.SalaryCoefficient),0) +
ISNULL(ISNULL(HT15.SalaryCoefficient,HT03.SalaryCoefficient),0) +
ISNULL(ISNULL(HT16.SalaryCoefficient,HT03.SalaryCoefficient),0) +
ISNULL(ISNULL(HT17.SalaryCoefficient,HT03.SalaryCoefficient),0) + 
ISNULL(ISNULL(HT18.SalaryCoefficient,HT03.SalaryCoefficient),0))/6 
* (CASE WHEN DATEDIFF(Month, HT03.WorkDate,'2008-12-31') - (12 * (DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')))+ 1 >=6 AND DATEDIFF(Month, HT03.WorkDate,'2008-12-31') - (12 * (DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')))+ 1 <= 12
      THEN DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31') + 1
      WHEN DATEDIFF(Month, HT03.WorkDate,'2008-12-31') - (12 * (DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')))+ 1 = 0
      THEN DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31')
      ELSE DATEDIFF(YEAR, HT03.WorkDate, '2008-12-31') + 0.5 END) * 0.5 AS SubsidiesAmount

FROM HT1400  HT00 
LEFT JOIN HT1403 HT03 ON HT00.EmployeeID = HT03.EmployeeID AND  HT00.DivisionID = HT03.DivisionID
LEFT JOIN AT1102 AT02 ON AT02.DivisionID=HT00.DivisionID AND AT02.DepartmentID=HT00.DepartmentID		
LEFT JOIN HT1102 HT02 ON HT02.DivisionID=HT03.DivisionID AND HT02.DutyID=HT03.DutyID	
LEFT JOIN HT1302 HT13 ON HT13.DivisionID = HT00.DivisionID AND HT13.EmployeeID = HT00.EmployeeID AND +STR(@TranYear*100+@TranMonth) BETWEEN HT13.FromYear*100+HT13.FromMonth AND HT13.ToYear*100+HT13.ToMonth
LEFT JOIN HT1302 HT14 ON HT14.DivisionID = HT00.DivisionID AND HT14.EmployeeID = HT00.EmployeeID AND STR(@TranYear*100+@TranMonth - 1) BETWEEN HT14.FromYear*100+HT14.FromMonth AND HT14.ToYear*100+HT14.ToMonth
LEFT JOIN HT1302 HT15 ON HT15.DivisionID = HT00.DivisionID AND HT15.EmployeeID = HT00.EmployeeID AND STR(@TranYear*100+@TranMonth - 2) BETWEEN HT15.FromYear*100+HT15.FromMonth AND HT15.ToYear*100+HT15.ToMonth
LEFT JOIN HT1302 HT16 ON HT16.DivisionID = HT00.DivisionID AND HT16.EmployeeID = HT00.EmployeeID AND STR(@TranYear*100+@TranMonth - 3) BETWEEN HT16.FromYear*100+HT16.FromMonth AND HT16.ToYear*100+HT16.ToMonth
LEFT JOIN HT1302 HT17 ON HT17.DivisionID = HT00.DivisionID AND HT17.EmployeeID = HT00.EmployeeID AND STR(@TranYear*100+@TranMonth - 4) BETWEEN HT17.FromYear*100+HT17.FromMonth AND HT17.ToYear*100+HT17.ToMonth
LEFT JOIN HT1302 HT18 ON HT18.DivisionID = HT00.DivisionID AND HT18.EmployeeID = HT00.EmployeeID AND STR(@TranYear*100+@TranMonth - 5) BETWEEN HT18.FromYear*100+HT18.FromMonth AND HT18.ToYear*100+HT18.ToMonth				
WHERE	HT00.DivisionID = @DivisionID
AND HT00.EmployeeStatus IN ( 1,3) 
AND HT03.WorkDate < '2008-12-31'
AND HT00.EmployeeID LIKE @EmployeeID
ORDER BY HT00.EmployeeID  

PRINT (@EmployeeID)




GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

