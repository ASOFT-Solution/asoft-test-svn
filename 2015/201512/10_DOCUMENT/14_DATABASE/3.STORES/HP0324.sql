IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0324]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0324]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create on 29/10/2013 by Thanh Sơn 
---- Nội dung: Load Grid Form HF0324
---- EXEC HP0324 'SAS',9,2013,'2013-09-05 00:00:00.000','2013-09-05 00:00:00.000',2,0

CREATE PROCEDURE HP0324
(
  @DivisionID VARCHAR (50),
  @TranMonth INT,
  @TranYear INT,
  @FromDate DATETIME,
  @ToDate DATETIME,
  @Mode TINYINT,--2 là Load Cho Tab Bốc xếp, 3 cho Tab Cơ giới, 4 cho Tab Giao nhận
  @IsPayment TINYINT -- 1 là đã được tính lương, 0 là chưa được tính lương
)    
AS 
DECLARE @sSQL NVARCHAR(MAX),
        @sSQL1 NVARCHAR(MAX),
        @sSQL2 NVARCHAR(MAX),
        @sSQL3 NVARCHAR(MAX),
        @sSQL4 NVARCHAR(MAX),
        @sSQL5 NVARCHAR(MAX),
        @sSQL6 NVARCHAR(500)
 
IF @Mode=2
BEGIN
IF @IsPayment = 1 
   BEGIN 
   	SET @sSQL1 = N'H24.Price'
   	SET @sSQL2 = N'H24.SalaryPlanID'	
   	SET @sSQL3 = N'H24.Amount'
   	SET @sSQL4 = N'COUNT(H25.EmployeeID)'
   	SET @sSQL5 = N'LEFT JOIN HT0325  H25 ON H25.DivisionID = P51.DivisionID AND H25.ResultAPK = P51.APK'
   END 
ELSE 
	BEGIN 
		SET @sSQL1 = N'A.Price'
		SET @sSQL2 = N'P51.TurnRoundPlanID'
		SET @sSQL3 = N'(CASE WHEN P51.UnitID = ''TA'' OR P51.UnitID = ''KG'' 
		THEN ISNULL(P51.[Weight],0)* A.Price ELSE  ISNULL(P51.Quantity,0)*A.Price END)'
		SET @sSQL4 = N'COUNT(P52.EmployeeID)'
		SET @sSQL5 = N'LEFT JOIN PST2052 P52 ON P52.DivisionID = P51.DivisionID AND P51.APK = P52.RefAPK'
	END 

SET @sSQL=N'
SELECT P51.APK,P50.VoucherID,P50.TranMonth,P50.TranYear,P50.VoucherNo,P50.VoucherDate,P50.BeginTime,
LTRIM(RTRIM(ISNULL(H00.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H00.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H00.FirstName,''''))) AS FollowPersonName,
P50.WorkingDate,P50.EndTime,H20.ShiftName,P50.WorkDays,P50.WaitHour,P50.Decription,P10.PortName,
P30.ShipName,P51.ArrivalDate,V00.[Description] AS ServiceTypeName,P51.InventoryTypeID,A02.InventoryName,
P51.UnitID,A04.UnitName,P51.TurnRoundPlanID,P80.TurnRoundPlanName,H01.TeamName,P51.Quantity,P51.[Weight],P51.Wharf,
P51.Vault,P51.Crane,P51.Notes,P51.CommandVoucherNo,'+@sSQL2+' AS SalaryPlanID, H69.SalaryPlanName,
'+@sSQL1+' AS Price, '+@sSQL3+' AS Amount, '+@sSQL4+' AS SumEmployee,
(CASE WHEN '+@sSQL4+'>0 THEN '+@sSQL3+' ELSE 0 END) / (CASE WHEN '+@sSQL4+'>0 THEN '+@sSQL4+' ELSE 1 END) SalaryAmount
FROM PST2050 P50
LEFT JOIN PST2051 P51 ON P51.DivisionID = P50.DivisionID AND P51.VoucherID = P50.VoucherID
'+@sSQL5+'
LEFT JOIN PST2040 P40 ON P40.DivisionID = P51.DivisionID AND P40.VoucherID = P51.CommandVoucherID
LEFT JOIN PST2030 P030 ON P030.DivisionID = P40.DivisionID AND P030.VoucherID = P40.CommandVoucherID
LEFT JOIN AT1304  A04 ON A04.DivisionID = P51.DivisionID AND A04.UnitID = P51.UnitID
LEFT JOIN HT0324  H24 ON H24.DivisionID = P51.DivisionID AND H24.ResultAPK = P51.APK
LEFT JOIN HT1400  H00 ON H00.DivisionID = P50.DivisionID AND H00.EmployeeID = P50.FollowPersonID
LEFT JOIN PST1030 P30 ON P30.DivisionID = P51.DivisionID AND P30.ShipID = P51.ShipID
LEFT JOIN PST1010 P10 ON P10.DivisionID = P51.DivisionID AND P10.PortID = P51.PortID
LEFT JOIN HT1020  H20 ON H20.DivisionID = P50.DivisionID AND H20.ShiftID = P50.ShiftID
LEFT JOIN HT1101  H01 ON H01.DivisionID = P51.DivisionID AND H01.TeamID = P51.TeamID
LEFT JOIN PSV1000 V00 ON V00.DivisionID = P51.DivisionID AND V00.[Value] = P51.ServiceType
LEFT JOIN AT1302  A02 ON A02.DivisionID = P51.DivisionID AND A02.InventoryID = P51.InventoryID
LEFT JOIN PST1080 P80 ON P80.DivisionID = P51.DivisionID AND P80.TurnRoundPlanID = P51.TurnRoundPlanID
LEFT JOIN (
	SELECT DISTINCT H72.DivisionID,H72.SalaryPlanID,MAX(H72.Price) AS Price
	FROM HT0272 H72
	LEFT JOIN HT0271 H71 ON H71.DivisionID = H72.DivisionID AND H71.PriceID = H72.PriceID
	WHERE GETDATE() BETWEEN H71.FromDate AND DATEADD(dd,1,H71.ToDate)
    GROUP BY H72.DivisionID,H72.SalaryPlanID
	)A ON A.DivisionID=P51.DivisionID AND A.SalaryPlanID= '+@sSQL2+'
LEFT JOIN HT0269 H69 ON H69.DivisionID = A.DivisionID AND H69.SalaryPlanID = A.SalaryPlanID
WHERE P50.DivisionID='''+@DivisionID+'''
AND P50.TranMonth='''+STR(@TranMonth)+'''
AND P50.TranYear='''+STR(@TranYear)+'''
AND CONVERT(VARCHAR(10),(CASE WHEN P50.VoucherNo LIKE ''KK_____________'' THEN P030.EndDate ELSE P50.VoucherDate END),111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,111)+'''
GROUP BY P51.APK,P50.VoucherID,P50.TranMonth,P50.TranYear,P50.VoucherNo,P50.VoucherDate,P50.BeginTime,
LTRIM(RTRIM(ISNULL(H00.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H00.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H00.FirstName,''''))),
P50.WorkingDate,P50.EndTime,H20.ShiftName,P50.WorkDays,P50.WaitHour,P50.Decription,P10.PortName,
P30.ShipName,P51.ArrivalDate,V00.[Description],P51.InventoryTypeID,A02.InventoryName,
P51.UnitID,A04.UnitName,P51.TurnRoundPlanID,P80.TurnRoundPlanName,H01.TeamName,P51.Quantity,P51.[Weight],P51.Wharf,
P51.Vault,P51.Crane,P51.Notes,P51.CommandVoucherNo,'+@sSQL2+', H69.SalaryPlanName,
'+@sSQL1+', '+@sSQL3+'
ORDER BY P51.ArrivalDate DESC '	
END

IF @Mode=3
BEGIN
IF @IsPayment = 1 
   BEGIN 
   	SET @sSQL1 = N'H24.Price'
   	SET @sSQL2 = N'H24.SalaryPlanID'
   	SET @sSQL3 = N'H24.Amount'
   	SET @sSQL4 = N'COUNT(H25.EmployeeID)'
   	SET @sSQL5 = N'LEFT JOIN HT0325 H25 ON H25.DivisionID = P11.DivisionID AND H25.ResultAPK = P11.APK'
   	SET @sSQL6 =''
   END
ELSE 
   BEGIN
	SET @sSQL1 = N'A.Price'
	SET @sSQL2 = N'P70.SalaryPlanID'	
	SET @sSQL3 = N'(CASE WHEN P11.UnitID = ''TA'' OR P11.UnitID = ''KG'' THEN ISNULL(P11.[Weight],0)* A.Price ELSE  ISNULL(P11.Quantity,0)*A.Price END)'
	SET @sSQL4 = N'(CASE WHEN P10.MainDriverID IS NOT NULL AND P10.SecondDriverID IS NOT NULL THEN 2
                         WHEN P10.MainDriverID IS NULL AND P10.SecondDriverID IS NULL THEN 0 ELSE 1 END)'
    SET @sSQL5 = N''
    SET @sSQL6 = N',(CASE WHEN P10.MainDriverID IS NOT NULL AND P10.SecondDriverID IS NOT NULL THEN 2
                         WHEN P10.MainDriverID IS NULL AND P10.SecondDriverID IS NULL THEN 0 ELSE 1 END)'
    END
--- EXEC HP0324 'SAS',9,2013,'2013-09-01 00:00:00.000','2013-09-10 00:00:00.000',2,1	
SET @sSQL=N'
SELECT P11.APK, P10.VoucherID, P10.VoucherNo, P10.TranMonth, P10.TranYear, P10.VoucherDate, P10.WorkingDate,
P10.ShiftID, H20.ShiftName, C70.DeviceTypeName,C40.DeviceName, A02.ObjectName AS DevicePlace,
LTRIM(RTRIM(ISNULL(H001.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H001.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H001.FirstName,''''))) AS MainDriverName,
LTRIM(RTRIM(ISNULL(H002.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H002.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H002.FirstName,''''))) AS SecondDriverName,
LTRIM(RTRIM(ISNULL(H003.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H003.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H003.FirstName,''''))) AS EmployeeName,
V00.[Description] AS ServiceTypeName,P11.CommandVoucherNo,P101.PortName,P30.ShipName,P11.ArrivalDate,
P11.InventoryID,A302.InventoryName,P11.UnitID,A04.UnitName,P11.Quantity,P11.[Weight],P70.EnginePlanID, P70.EnginePlanName,
'+@sSQL2+',P11.WorkingHours,P11.WorkingTrip,P11.Km,P11.Cont,P11.Fuel,H69.SalaryPlanName,
'+@sSQL1+' AS Price, '+@sSQL3+' AS Amount, '+@sSQL4+' AS SumEmployee,
(CASE WHEN '+@sSQL4+'>0 THEN '+@sSQL3+' ELSE 0 END) / (CASE WHEN '+@sSQL4+'>0 THEN '+@sSQL4+' ELSE 1 END) SalaryAmount   
FROM PST2110 P10
LEFT JOIN PST2111 P11 ON P11.DivisionID = P10.DivisionID AND P11.VoucherID = P10.VoucherID
'+@sSQL5+'
LEFT JOIN PST2030 P030 ON P030.DivisionID = P11.DivisionID AND P030.VoucherID = P11.CommandVoucherID
LEFT JOIN AT1304  A04 ON A04.DivisionID = P11.DivisionID AND A04.UnitID = P11.UnitID
LEFT JOIN AT1302 A302 ON A302.DivisionID = P11.DivisionID AND A302.InventoryID = P11.InventoryID
LEFT JOIN HT0324  H24 ON H24.DivisionID=P11.DivisionID AND H24.ResultAPK=P11.APK
LEFT JOIN HT1400 H001 ON H001.DivisionID=P10.DivisionID AND H001.EmployeeID=P10.MainDriverID
LEFT JOIN HT1400 H002 ON H002.DivisionID=P10.DivisionID AND H002.EmployeeID=P10.SecondDriverID
LEFT JOIN HT1400 H003 ON H003.DivisionID=P10.DivisionID AND H003.EmployeeID=P10.EmployeeID
LEFT JOIN CST1070 C70 ON C70.DivisionID=P10.DivisionID AND C70.DeviceTypeID=P10.DeviceTypeID
LEFT JOIN PST1030 P30 ON P30.DivisionID=P11.DivisionID AND P30.ShipID=P11.ShipID
LEFT JOIN PST1010 P101 ON P101.DivisionID=P11.DivisionID AND P101.PortID=P11.PortID
LEFT JOIN HT1020  H20 ON H20.DivisionID=P10.DivisionID AND H20.ShiftID=P10.ShiftID
LEFT JOIN CST1040 C40 ON C40.DivisionID=P10.DivisionID AND C40.DeviceID=P10.DeviceID
LEFT JOIN AT1202  A02 ON A02.DivisionID=P10.DivisionID AND A02.ObjectID=P10.DevicePlace
LEFT JOIN PSV1000 V00 ON V00.DivisionID=P11.DivisionID AND V00.[Value]=P11.ServiceType
LEFT JOIN PST1070 P70 ON P70.DivisionID=P11.DivisionID AND P70.EnginePlanID=P11.EnginePlanID
LEFT JOIN (
	SELECT DISTINCT H72.DivisionID,H72.SalaryPlanID,MAX(H72.Price) AS Price
	FROM HT0272 H72
	LEFT JOIN HT0271 H71 ON H71.DivisionID = H72.DivisionID AND H71.PriceID = H72.PriceID
	WHERE GETDATE() BETWEEN H71.FromDate AND DATEADD(dd,1,H71.ToDate)
    GROUP BY H72.DivisionID,H72.SalaryPlanID
	)A ON A.DivisionID=P11.DivisionID AND A.SalaryPlanID = '+@sSQL2+'
LEFT JOIN HT0269 H69 ON H69.DivisionID = A.DivisionID AND H69.SalaryPlanID = A.SalaryPlanID
WHERE P10.DivisionID='''+@DivisionID+'''
AND P10.TranMonth='''+STR(@TranMonth)+'''
AND P10.TranYear='''+STR(@TranYear)+'''
AND CONVERT(VARCHAR(10),(CASE WHEN P10.VoucherNo LIKE ''KK_____________'' THEN P030.EndDate ELSE P10.VoucherDate END),111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,111)+'''
GROUP BY P11.APK, P10.VoucherID, P10.VoucherNo, P10.TranMonth, P10.TranYear, P10.VoucherDate, P10.WorkingDate,
P10.ShiftID, H20.ShiftName, C70.DeviceTypeName,C40.DeviceName, A02.ObjectName,
LTRIM(RTRIM(ISNULL(H001.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H001.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H001.FirstName,''''))),
LTRIM(RTRIM(ISNULL(H002.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H002.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H002.FirstName,''''))),
LTRIM(RTRIM(ISNULL(H003.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H003.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H003.FirstName,''''))),
V00.[Description],P11.CommandVoucherNo,P101.PortName,P30.ShipName,P11.ArrivalDate,
P11.InventoryID,A302.InventoryName,P11.UnitID,A04.UnitName,P11.Quantity,P11.[Weight],P70.EnginePlanID, P70.EnginePlanName,
'+@sSQL2+',P11.WorkingHours,P11.WorkingTrip,P11.Km,P11.Cont,P11.Fuel,H69.SalaryPlanName,'+@sSQL1+', '+@sSQL3+' '+@sSQL6+'
ORDER BY P11.ArrivalDate DESC'
END 

IF @Mode=4
BEGIN
IF @IsPayment = 1 
    BEGIN 
    	SET @sSQL1 = N'H24.Price'
    	SET @sSQL2 = N'H24.SalaryPlanID'
    	SET @sSQL3 = N'H24.Amount'
     	SET @sSQL4 = 'COUNT(H25.EmployeeID)'
    	SET @sSQL5 = N'LEFT JOIN HT0325  H25 ON H25.DivisionID = P71.DivisionID AND H25.ResultAPK = P71.APK'
    END
ELSE 
	BEGIN 
		SET @sSQL1 = N'A.Price'
		SET @sSQL2 = N'P71.DeliveryPlanID'
		SET @sSQL3 = N'(CASE WHEN P71.UnitID = ''TA'' OR P71.UnitID = ''KG'' 
		THEN ISNULL(P71.[Weight],0)* A.Price ELSE  ISNULL(P71.Quantity,0)*A.Price END)'
		SET @sSQL4 = 'COUNT(P72.EmployeeID)'
		SET @sSQL5 = N'LEFT JOIN PST2072 P72 ON P72.DivisionID = P71.DivisionID AND P71.APK = P72.RefAPK'
		
	END
SET @sSQL=N'
SELECT P71.APK,P70.VoucherID,P70.TranMonth,P70.TranYear,P70.VoucherNo,P70.OrderVoucherNo,P70.VoucherDate,P10.PortName,P30.ShipName,P70.ArrivalDate,
LTRIM(RTRIM(ISNULL(H00.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H00.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H00.FirstName,''''))) AS FollowPersonName,
V00.[Description] AS ServiceTypeName,A02.InventoryName,P90.DeliveryPlanID,P90.DeliveryPlanName,P71.WorkingDate,H20.ShiftName,P71.BeginHour,P71.EndHour,
LTRIM(RTRIM(ISNULL(H01.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H01.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H01.FirstName,''''))) AS WorkingPersonName,
P71.WorkDays,A04.UnitName,P71.Quantity,P71.[Weight],H02.TeamName,'+@sSQL2+' AS SalaryPlanID, H69.SalaryPlanName,
'+@sSQL1+' AS Price, '+@sSQL3+' AS Amount, '+@sSQL4+' AS SumEmployee,
(CASE WHEN '+@sSQL4+'>0 THEN '+@sSQL3+' ELSE 0 END) / (CASE WHEN '+@sSQL4+'>0 THEN '+@sSQL4+' ELSE 1 END) SalaryAmount
FROM PST2070 P70
LEFT JOIN PST2071 P71 ON P71.DivisionID=P70.DivisionID AND P70.VoucherID=P71.VoucherID
'+@sSQL5+'
LEFT JOIN PST2030 P030 ON P030.DivisionID = P70.DivisionID AND P030.VoucherID = P70.OrderVoucherID
LEFT JOIN HT0324 H24 ON H24.DivisionID=P71.DivisionID AND H24.ResultAPK=P71.APK
LEFT JOIN HT1400 H00 ON H00.DivisionID=P70.DivisionID AND H00.EmployeeID=P70.FollowPersonID
LEFT JOIN HT1400 H01 ON H01.DivisionID=P71.DivisionID AND H01.EmployeeID=P71.WorkingPersonID
LEFT JOIN PST1030 P30 ON P30.DivisionID=P70.DivisionID AND P30.ShipID=P70.ShipID
LEFT JOIN PST1010 P10 ON P10.DivisionID=P70.DivisionID AND P10.PortID=P70.PortID
LEFT JOIN PSV1000 V00 ON V00.DivisionID=P71.DivisionID AND V00.[Value]=P71.ServiceType
LEFT JOIN AT1302 A02 ON A02.DivisionID=P71.DivisionID AND A02.InventoryID=P71.InventoryID
LEFT JOIN PST1090 P90 ON P90.DivisionID=P71.DivisionID AND P90.DeliveryPlanID=P71.DeliveryPlanID
LEFT JOIN HT1020 H20 ON H20.DivisionID=P71.DivisionID AND H20.ShiftID=P71.ShiftID
LEFT JOIN AT1304 A04 ON A04.DivisionID=P71.DivisionID AND A04.UnitID=P71.UnitID
LEFT JOIN HT1101 H02 ON H02.DivisionID=P71.DivisionID AND H02.TeamID=P71.TeamID
LEFT JOIN (
	SELECT DISTINCT H72.DivisionID,H72.SalaryPlanID,MAX(H72.Price) AS Price
	FROM HT0272 H72
	LEFT JOIN HT0271 H71 ON H71.DivisionID = H72.DivisionID AND H71.PriceID = H72.PriceID
	WHERE GETDATE() BETWEEN H71.FromDate AND DATEADD(dd,1,H71.ToDate)
    GROUP BY H72.DivisionID,H72.SalaryPlanID
	)A ON A.DivisionID=P71.DivisionID AND A.SalaryPlanID= '+@sSQL2+'
LEFT JOIN HT0269 H69 ON H69.DivisionID = A.DivisionID AND H69.SalaryPlanID = A.SalaryPlanID
WHERE P70.DivisionID='''+@DivisionID+'''
AND P70.TranMonth='''+STR(@TranMonth)+'''
AND P70.TranYear='''+STR(@TranYear)+'''
AND CONVERT(VARCHAR(10),(CASE WHEN P70.VoucherNo LIKE ''KK_____________'' THEN P030.EndDate ELSE P70.VoucherDate END),111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,111)+'''
GROUP BY P71.APK,P70.VoucherID,P70.TranMonth,P70.TranYear,P70.VoucherNo,P70.OrderVoucherNo,P70.VoucherDate,P10.PortName,P30.ShipName,P70.ArrivalDate,
LTRIM(RTRIM(ISNULL(H00.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H00.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H00.FirstName,''''))),
V00.[Description],A02.InventoryName,P90.DeliveryPlanID,P90.DeliveryPlanName,P71.WorkingDate,H20.ShiftName,P71.BeginHour,P71.EndHour,
LTRIM(RTRIM(ISNULL(H01.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H01.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H01.FirstName,''''))),
P71.WorkDays,A04.UnitName,P71.Quantity,P71.[Weight],H02.TeamName,'+@sSQL2+', H69.SalaryPlanName,
'+@sSQL1+', '+@sSQL3+'
ORDER BY P70.ArrivalDate DESC'
END

EXEC (@sSQL)
PRINT (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

