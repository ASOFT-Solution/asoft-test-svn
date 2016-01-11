IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0342]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0342]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- In báo cáo : Bảng in chi tiết từng ca-tàu-tổ
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 11/12/2013 by Thanh Sơn
---- 
-- <Example>
---- EXEC HP0342 'SAS', 'ADMIN', 7,2013,10,2013, 0,'2013-08-11 00:00:00.000','2013-08-11 00:00:00.000', '%', 2

CREATE PROCEDURE HP0342
( 
		@DivisionID VARCHAR(50),
		@UserID VARCHAR(50),
		@FromTranMonth INT,
		@FromTranYear INT,
		@ToTranMonth INT,
		@ToTranYear INT,
		@IsDate TINYINT,  ---1: Theo ngày, 0: theo kì
		@FromDate DATETIME,
		@ToDate DATETIME,
		@ShipID VARCHAR(50),
		@Mode TINYINT --2: Bốc xếp, 3: Cơ giới, 4: Giao nhận
) 
AS 
DECLARE @sSQL NVARCHAR(MAX),
        @sWhere NVARCHAR(MAX)
SET @sWhere = ''

IF @Mode = 2 -- Bốc xếp
BEGIN
	IF @IsDate = 0 SET @sWhere = N'
AND P50.TranYear * 100 + P50.TranMonth BETWEEN  '''+STR(@FromTranYear * 100 + @FromTranMonth)+''' 
AND '''+STR(@ToTranYear * 100 + @ToTranMonth)+'''  '
    IF @IsDate = 1 SET @sWhere = N'
AND CONVERT(VARCHAR(10),P50.VoucherDate,111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' 
AND '''+CONVERT(VARCHAR(10),@ToDate,111)+''' '
	SET @sSQL = N'
SELECT P51.TeamID, H01.TeamName, P51.APK, P50.VoucherDate, P50.ShiftID, H20.ShiftName, P51.ShipID,
P30.ShipName, COUNT(P52.EmployeeID) AS SumEmployee,P51.UnitID,
(CASE WHEN P51.UnitID = ''TA'' THEN  SUM(P51.[Weight]) ELSE 0 END) AS SumWeight,
(CASE WHEN P51.UnitID = ''TA'' THEN H72.Price ELSE 0 END) AS WeightPrice,
(CASE WHEN COUNT(P52.EmployeeID) <> 0 THEN 
	(CASE WHEN P51.UnitID = ''TA'' THEN  SUM(P51.[Weight]) ELSE 0 END) *
	(CASE WHEN P51.UnitID = ''TA'' THEN H72.Price ELSE 0 END)/COUNT(P52.EmployeeID) 
ELSE 0 END) AS WeightMoneyAmount,

(CASE WHEN P51.UnitID = ''CT'' THEN  SUM(P51.Quantity) ELSE 0 END) AS SumCont,
(CASE WHEN P51.UnitID = ''CT'' THEN H72.Price ELSE 0 END) AS ContPrice,
(CASE WHEN COUNT(P52.EmployeeID) <> 0 THEN 
	(CASE WHEN P51.UnitID = ''CT'' THEN  SUM(P51.Quantity) ELSE 0 END)*
	(CASE WHEN P51.UnitID = ''CT'' THEN H72.Price ELSE 0 END)/COUNT(P52.EmployeeID) 
ELSE 0 END) AS ContMoneyAmount,

(CASE WHEN P51.UnitID = ''K'' THEN  SUM(P51.Quantity) ELSE 0 END) AS SumKien,
(CASE WHEN P51.UnitID = ''K'' THEN H72.Price ELSE 0 END) AS KienPrice,
(CASE WHEN COUNT(P52.EmployeeID) <> 0 THEN 
	(CASE WHEN P51.UnitID = ''K'' THEN  SUM(P51.Quantity) ELSE 0 END)*
	(CASE WHEN P51.UnitID = ''K'' THEN H72.Price ELSE 0 END)/COUNT(P52.EmployeeID) 
ELSE 0 END) AS KienMoneyAmount,

(CASE WHEN P51.UnitID = ''XE'' THEN  SUM(P51.Quantity) ELSE 0 END) AS SumXe,
(CASE WHEN P51.UnitID = ''XE'' THEN H72.Price ELSE 0 END) AS XePrice,
(CASE WHEN COUNT(P52.EmployeeID) <> 0 THEN 
	(CASE WHEN P51.UnitID = ''XE'' THEN  SUM(P51.Quantity) ELSE 0 END)*
	(CASE WHEN P51.UnitID = ''XE'' THEN H72.Price ELSE 0 END)/COUNT(P52.EmployeeID) 
ELSE 0 END) AS XeMoneyAmount,
COUNT(P52.EmployeeID) AS WorkDay,
(CASE WHEN P52.IsAdding = 1 THEN P52.EmployeeID+''*'' ELSE P52.EmployeeID END) AS EmployeeID
FROM PST2051 P51
LEFT JOIN HT0272 H72 ON H72.DivisionID = P51.DivisionID AND H72.SalaryPlanID = P51.TurnRoundPlanID
LEFT JOIN HT0271 H71 ON H71.DivisionID = H72.DivisionID AND H71.PriceID = H72.PriceID 
LEFT JOIN PST2040 P40 ON P40.DivisionID = P51.DivisionID AND P40.VoucherID = P51.CommandVoucherID
LEFT JOIN PST2052 P52 ON P52.DivisionID = P51.DivisionID AND P52.RefAPK = P51.APK
LEFT JOIN PST1030 P30 ON P30.DivisionID = P51.DivisionID AND P30.ShipID = P51.ShipID
LEFT JOIN PST2050 P50 ON P50.DivisionID = P51.DivisionID AND P50.VoucherID = P51.VoucherID
LEFT JOIN HT1020 H20 ON H20.DivisionID = P50.DivisionID AND H20.ShiftID = P50.ShiftID
LEFT JOIN HT1101 H01 ON H01.DivisionID = P51.DivisionID AND H01.TeamID = P51.TeamID
WHERE P51.DivisionID = '''+@DivisionID+'''
AND P51.ShipID LIKE '''+ISNULL(@ShipID,'')+''' 
AND H71.FromDate < GETDATE() AND H71.ToDate > GETDATE() '+@sWhere+'
GROUP BY P51.TeamID,P51.APK, H01.TeamName, P50.VoucherDate, P50.ShiftID, H20.ShiftName, P51.ShipID,
P30.ShipName, P51.UnitID, H72.Price, P52.EmployeeID, P52.IsAdding
ORDER BY P51.TeamID, P51.APK, P50.VoucherDate, P50.ShiftID,P51.ShipID, P52.IsAdding  '
END

IF @Mode = 3 --- Cơ giới
BEGIN
	IF @IsDate = 0 SET @sWhere = N'
AND P10.TranYear * 100 + P10.TranMonth BETWEEN  '''+STR(@FromTranYear * 100 + @FromTranMonth)+''' 
AND '''+STR(@ToTranYear * 100 + @ToTranMonth)+'''  '
    IF @IsDate = 1 SET @sWhere = N'
AND CONVERT(VARCHAR(10),P10.VoucherDate,111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' 
AND '''+CONVERT(VARCHAR(10),@ToDate,111)+''' '
	SET @sSQL = N'
SELECT P11.APK, P10.VoucherDate, P10.ShiftID, H20.ShiftName, P11.ShipID,P11.UnitID,
P30.ShipName, 
(CASE WHEN P10.MainDriverID IS NOT NULL AND P10.SecondDriverID IS NOT NULL THEN 2
      WHEN P10.MainDriverID IS NULL AND P10.SecondDriverID IS NULL THEN 0
 ELSE 1 END) AS SumEmployee, 
(CASE WHEN P11.UnitID = ''TA'' THEN  SUM(P11.[Weight]) ELSE 0 END) AS SumWeight,
(CASE WHEN P11.UnitID = ''TA'' THEN H72.Price ELSE 0 END) AS WeightPrice,
(CASE WHEN P10.MainDriverID IS NULL AND P10.SecondDriverID IS NULL THEN 0 ELSE 
	(CASE WHEN P11.UnitID = ''TA'' THEN  SUM(P11.[Weight]) ELSE 0 END) *
	(CASE WHEN P11.UnitID = ''TA'' THEN H72.Price ELSE 0 END)/
	(CASE WHEN P10.MainDriverID IS NOT NULL AND P10.SecondDriverID IS NOT NULL THEN 2 ELSE 1 END)
 END) AS WeightMoneyAmount,

(CASE WHEN P11.UnitID = ''CT'' THEN  SUM(P11.Quantity) ELSE 0 END) AS SumCont,
(CASE WHEN P11.UnitID = ''CT'' THEN H72.Price ELSE 0 END) AS ContPrice,
(CASE WHEN P10.MainDriverID IS NULL AND P10.SecondDriverID IS NULL THEN 0 ELSE 
	(CASE WHEN P11.UnitID = ''CT'' THEN  SUM(P11.Quantity) ELSE 0 END) *
	(CASE WHEN P11.UnitID = ''CT'' THEN H72.Price ELSE 0 END)/
	(CASE WHEN P10.MainDriverID IS NOT NULL AND P10.SecondDriverID IS NOT NULL THEN 2 ELSE 1 END)
 END) AS ContMoneyAmount,

(CASE WHEN P11.UnitID = ''K'' THEN  SUM(P11.Quantity) ELSE 0 END) AS SumKien,
(CASE WHEN P11.UnitID = ''K'' THEN H72.Price ELSE 0 END) AS KienPrice,
(CASE WHEN P10.MainDriverID IS NULL AND P10.SecondDriverID IS NULL THEN 0 ELSE 
	(CASE WHEN P11.UnitID = ''K'' THEN  SUM(P11.Quantity) ELSE 0 END) *
	(CASE WHEN P11.UnitID = ''K'' THEN H72.Price ELSE 0 END)/
	(CASE WHEN P10.MainDriverID IS NOT NULL AND P10.SecondDriverID IS NOT NULL THEN 2 ELSE 1 END)
 END) AS KienMoneyAmount,

(CASE WHEN P11.UnitID = ''XE'' THEN  SUM(P11.Quantity) ELSE 0 END) AS SumXe,
(CASE WHEN P11.UnitID = ''XE'' THEN H72.Price ELSE 0 END) AS XePrice,
(CASE WHEN P10.MainDriverID IS NULL AND P10.SecondDriverID IS NULL THEN 0 ELSE 
	(CASE WHEN P11.UnitID = ''XE'' THEN  SUM(P11.Quantity) ELSE 0 END) *
	(CASE WHEN P11.UnitID = ''XE'' THEN H72.Price ELSE 0 END)/
	(CASE WHEN P10.MainDriverID IS NOT NULL AND P10.SecondDriverID IS NOT NULL THEN 2 ELSE 1 END)
 END) AS XeMoneyAmount,
(CASE WHEN P10.MainDriverID IS NOT NULL AND P10.SecondDriverID IS NOT NULL THEN 2
      WHEN P10.MainDriverID IS NULL AND P10.SecondDriverID IS NULL THEN 0
 ELSE 1 END) AS WorkDay,
 A.MainDriverID AS Employee
FROM PST2111 P11
LEFT JOIN (SELECT P1.APK,P0.MainDriverID FROM PST2110 P0
           LEFT JOIN PST2111 P1 ON P1.DivisionID = P0.DivisionID AND P1.VoucherID = P0.VoucherID
           WHERE P0.MainDriverID IS NOT NULL 
           UNION ALL
           SELECT P11.APK,P00.SecondDriverID FROM PST2110 P00
           LEFT JOIN PST2111 P11 ON P11.DivisionID = P00.DivisionID AND P11.VoucherID = P00.VoucherID
           WHERE P00.SecondDriverID IS NOT NULL)A ON A.APK = P11.APK  
LEFT JOIN PST2110 P10 ON P10.DivisionID = P11.DivisionID AND P10.VoucherID = P11.VoucherID
LEFT JOIN PST1070 P70 ON P70.DivisionID = P11.DivisionID AND P70.EnginePlanID =  P11.EnginePlanID
LEFT JOIN HT0272 H72 ON H72.DivisionID = P70.DivisionID AND H72.SalaryPlanID = P70.SalaryPlanID
LEFT JOIN HT0271 H71 ON H71.DivisionID = H72.DivisionID AND H71.PriceID = H72.PriceID 
LEFT JOIN PST1030 P30 ON P30.DivisionID = P11.DivisionID AND P30.ShipID = P11.ShipID
LEFT JOIN HT1020 H20 ON H20.DivisionID = P10.DivisionID AND H20.ShiftID = P10.ShiftID
WHERE P11.DivisionID = '''+@DivisionID+'''
AND ISNULL(P11.ShipID,'''') LIKE '''+ISNULL(@ShipID,'')+'''
AND H71.FromDate < GETDATE() AND H71.ToDate > GETDATE() '+@sWhere+'  
GROUP BY P11.APK, P10.VoucherDate, P10.ShiftID, H20.ShiftName, P11.ShipID,
P30.ShipName, P11.UnitID, H72.Price,P10.MainDriverID, P10.SecondDriverID, A.MainDriverID
ORDER BY P11.APK, P10.VoucherDate, P10.ShiftID,P11.ShipID   '

END

IF @Mode = 4 -- Giao nhận
BEGIN
	IF @IsDate = 0 SET @sWhere = N'
AND P70.TranYear * 100 + P70.TranMonth BETWEEN  '''+STR(@FromTranYear * 100 + @FromTranMonth)+''' 
AND '''+STR(@ToTranYear * 100 + @ToTranMonth)+'''  '
    IF @IsDate = 1 SET @sWhere = N'
AND CONVERT(VARCHAR(10),P70.VoucherDate,111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' 
AND '''+CONVERT(VARCHAR(10),@ToDate,111)+''' '
	SET @sSQL = N'
SELECT P71.TeamID, H01.TeamName, P71.APK, P70.VoucherDate, P71.ShiftID, H20.ShiftName, P70.ShipID,
P30.ShipName, COUNT(P72.EmployeeID) AS SumEmployee,P71.UnitID,
(CASE WHEN P71.UnitID = ''TA'' THEN  SUM(P71.[Weight]) ELSE 0 END) AS SumWeight,
(CASE WHEN P71.UnitID = ''TA'' THEN H72.Price ELSE 0 END) AS WeightPrice,
(CASE WHEN COUNT(P72.EmployeeID) <> 0 THEN
	(CASE WHEN P71.UnitID = ''TA'' THEN  SUM(P71.[Weight]) ELSE 0 END) *
	(CASE WHEN P71.UnitID = ''TA'' THEN H72.Price ELSE 0 END)/COUNT(P72.EmployeeID)
ELSE 0 END) AS WeightMoneyAmount,

(CASE WHEN P71.UnitID = ''CT'' THEN  SUM(P71.Quantity) ELSE 0 END) AS SumCont,
(CASE WHEN P71.UnitID = ''CT'' THEN H72.Price ELSE 0 END) AS ContPrice,
(CASE WHEN COUNT(P72.EmployeeID) <> 0 THEN
	(CASE WHEN P71.UnitID = ''CT'' THEN  SUM(P71.Quantity) ELSE 0 END)*
	(CASE WHEN P71.UnitID = ''CT'' THEN H72.Price ELSE 0 END)/COUNT(P72.EmployeeID)
ELSE 0 END) AS ContMoneyAmount,

(CASE WHEN P71.UnitID = ''K'' THEN  SUM(P71.Quantity) ELSE 0 END) AS SumKien,
(CASE WHEN P71.UnitID = ''K'' THEN H72.Price ELSE 0 END) AS KienPrice,
(CASE WHEN COUNT(P72.EmployeeID) <> 0 THEN
	(CASE WHEN P71.UnitID = ''K'' THEN  SUM(P71.Quantity) ELSE 0 END)*
	(CASE WHEN P71.UnitID = ''K'' THEN H72.Price ELSE 0 END)/COUNT(P72.EmployeeID)
ELSE 0 END) AS KienMoneyAmount,

(CASE WHEN P71.UnitID = ''XE'' THEN  SUM(P71.Quantity) ELSE 0 END) AS SumXe,
(CASE WHEN P71.UnitID = ''XE'' THEN H72.Price ELSE 0 END) AS XePrice,
(CASE WHEN COUNT(P72.EmployeeID) <> 0 THEN
	(CASE WHEN P71.UnitID = ''XE'' THEN  SUM(P71.Quantity) ELSE 0 END)*
	(CASE WHEN P71.UnitID = ''XE'' THEN H72.Price ELSE 0 END)/COUNT(P72.EmployeeID)
ELSE 0 END) AS XeMoneyAmount,
COUNT(P72.EmployeeID) AS WorkDay,
(CASE WHEN P72.IsAdding = 1 THEN P72.EmployeeID+''*'' ELSE P72.EmployeeID END) AS EmployeeID
FROM PST2071 P71
LEFT JOIN HT0272 H72 ON H72.DivisionID = P71.DivisionID AND H72.SalaryPlanID = P71.DeliveryPlanID
LEFT JOIN HT0271 H71 ON H71.DivisionID = H72.DivisionID AND H71.PriceID = H72.PriceID 
LEFT JOIN PST2072 P72 ON P72.DivisionID = P71.DivisionID AND P72.RefAPK = P71.APK
LEFT JOIN PST2070 P70 ON P70.DivisionID = P71.DivisionID AND P70.VoucherID = P71.VoucherID
LEFT JOIN PST1030 P30 ON P30.DivisionID = P71.DivisionID AND P30.ShipID = P70.ShipID
LEFT JOIN HT1020 H20 ON H20.DivisionID = P70.DivisionID AND H20.ShiftID = P71.ShiftID
LEFT JOIN HT1101 H01 ON H01.DivisionID = P71.DivisionID AND H01.TeamID = P71.TeamID
WHERE P71.DivisionID = '''+@DivisionID+'''
AND ISNULL(P70.ShipID,'''') LIKE '''+ISNULL(@ShipID,'')+'''
AND H71.FromDate < GETDATE() AND H71.ToDate > GETDATE() '+@sWhere+'  
GROUP BY P71.TeamID,P71.APK, H01.TeamName, P70.VoucherDate, P71.ShiftID, H20.ShiftName, P70.ShipID,
P30.ShipName, P71.UnitID, H72.Price, P72.EmployeeID, P72.IsAdding
ORDER BY P71.TeamID, P71.APK, P70.VoucherDate, P71.ShiftID,P70.ShipID, P72.IsAdding '
END

PRINT (@sSQL)
EXEC (@sSQL)
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

