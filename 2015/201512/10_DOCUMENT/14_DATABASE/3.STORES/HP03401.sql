IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP03401]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP03401]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- In báo cáo : Bảng thanh toán tàu (CSG)(HR0341)
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
---- EXEC HP03401 'SAS', 'ADMIN', 7,2013,9,2013, 0,'2013-08-11 00:00:00.000','2013-08-11 00:00:00.000', 'OB10092013','2013-09-10 00:00:00.000', 4

CREATE PROCEDURE HP03401
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
		@ArrivalDate DATETIME,
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
AND CONVERT(VARCHAR(10),P50.VoucherDate,111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,111)+''' '
	SET @sSQL = N'
SELECT P51.ShipID, P30.ShipName, P51.InventoryID, A02.InventoryName,
SUM((CASE WHEN P51.ServiceType = 0 THEN P51.[Weight] ELSE 0 END)) AS Import,
SUM((CASE WHEN P51.ServiceType = 1 THEN P51.[Weight] ELSE 0 END)) AS Export,
SUM((CASE WHEN P51.UnitID = ''CT'' THEN P51.Quantity ELSE 0 END)) AS Cont,
P030.BeginDate, P030.EndDate, P51.ArrivalDate, DATEDIFF(d,P030.BeginDate, P030.EndDate) AS WorkDays,
DATEDIFF(hh,P030.BeginDate, P030.EndDate) - 24*DATEDIFF(d,P030.BeginDate, P030.EndDate) AS WorkHours,
SUM(CASE WHEN P51.UnitID = ''TA'' THEN P51.[Weight] ELSE 0 END) AS SumWeight,
SUM((CASE WHEN P51.UnitID = ''TA'' THEN P51.[Weight] ELSE 0 END)* H72.Price) AS MoneyAmount, P030.VoucherNo
FROM PST2051 P51
LEFT JOIN HT0272 H72 ON H72.DivisionID = P51.DivisionID AND H72.SalaryPlanID = P51.TurnRoundPlanID
LEFT JOIN HT0271 H71 ON H71.DivisionID = H72.DivisionID AND H71.PriceID = H72.PriceID                          
LEFT JOIN PST2040 P40 ON P40.DivisionID = P51.DivisionID AND P40.VoucherID = P51.CommandVoucherID
LEFT JOIN PST2030 P030 ON P030.DivisionID = P40.DivisionID AND P030.VoucherID = P40.CommandVoucherID
LEFT JOIN PST2050 P50 ON P50.DivisionID = P51.DivisionID AND P50.VoucherID = P51.VoucherID
LEFT JOIN AT1302 A02 ON A02.DivisionID = P51.DivisionID AND A02.InventoryID = P51.InventoryID
LEFT JOIN PST1030 P30 ON P30.DivisionID = P51.DivisionID AND P30.ShipID = P51.ShipID
WHERE P51.DivisionID = '''+@DivisionID+'''
AND P51.ShipID = '''+@ShipID+'''
'+@sWhere+'
AND CONVERT(VARCHAR(10),P51.ArrivalDate,111) = '''+CONVERT(VARCHAR(10),@ArrivalDate,111)+'''
AND H71.FromDate < GETDATE() AND H71.ToDate > GETDATE()
GROUP BY P51.ShipID, P30.ShipName, P51.InventoryID, A02.InventoryName,
P030.BeginDate, P030.EndDate, P51.ArrivalDate, DATEDIFF(d,P030.BeginDate, P030.EndDate),
DATEDIFF(hh,P030.BeginDate, P030.EndDate) - 24*DATEDIFF(d,P030.BeginDate, P030.EndDate), 
P030.VoucherNo
ORDER BY P51.InventoryID     '
END

IF @Mode = 3 --- Cơ giới
BEGIN
	IF @IsDate = 0 SET @sWhere = N'
AND P10.TranYear * 100 + P10.TranMonth BETWEEN '''+STR(@FromTranYear * 100 + @FromTranMonth)+''' 
                                       AND '''+STR(@ToTranYear * 100 + @ToTranMonth)+'''  '
    IF @IsDate = 1 SET @sWhere = N'
AND CONVERT(VARCHAR(10),P10.VoucherDate,111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,111)+''' '
   SET @sSQL = N'
SELECT P11.ShipID, P30.ShipName, P11.InventoryID, A02.InventoryName, P11.ArrivalDate,
SUM((CASE WHEN P11.ServiceType = 0 THEN P11.[Weight] ELSE 0 END)) AS Import,
SUM((CASE WHEN P11.ServiceType = 1 THEN P11.[Weight] ELSE 0 END)) AS Export,
SUM((CASE WHEN P11.UnitID = ''CT'' THEN P11.Quantity ELSE 0 END)) AS Cont,
P030.BeginDate, P030.EndDate, DATEDIFF(d,P030.BeginDate, P030.EndDate) AS WorkDays,
DATEDIFF(hh,P030.BeginDate, P030.EndDate) - 24*DATEDIFF(d,P030.BeginDate, P030.EndDate) AS WorkHours,
SUM(CASE WHEN P11.UnitID = ''TA'' THEN P11.[Weight] ELSE 0 END) AS SumWeight,
SUM((CASE WHEN P11.UnitID = ''TA'' THEN P11.[Weight] ELSE 0 END)* H72.Price) AS MoneyAmount, P030.VoucherNo
FROM PST2111 P11
LEFT JOIN PST2110 P10 ON P10.DivisionID = P11.DivisionID AND P10.VoucherID = P11.VoucherID
LEFT JOIN PST1070 P70 ON P70.DivisionID = P11.DivisionID AND P70.EnginePlanID =  P11.EnginePlanID
LEFT JOIN HT0272 H72 ON H72.DivisionID = P70.DivisionID AND H72.SalaryPlanID = P70.SalaryPlanID
LEFT JOIN HT0271 H71 ON H71.DivisionID = H72.DivisionID AND H71.PriceID = H72.PriceID 
LEFT JOIN PST2030 P030 ON P030.DivisionID = P11.DivisionID AND P030.VoucherID = P11.CommandVoucherID
LEFT JOIN PST1030 P30 ON P30.DivisionID = P11.DivisionID AND P30.ShipID = P11.ShipID
LEFT JOIN AT1302 A02 ON A02.DivisionID = P11.DivisionID AND A02.InventoryID = P11.InventoryID
WHERE P11.DivisionID = '''+@DivisionID+'''
AND P11.ShipID = '''+@ShipID+'''
'+@sWhere+'
AND CONVERT(VARCHAR(10),P11.ArrivalDate,101) = '''+CONVERT(VARCHAR(10),@ArrivalDate,101)+'''
AND H71.FromDate < GETDATE() AND H71.ToDate > GETDATE()
GROUP BY P11.ShipID, P30.ShipName, P11.InventoryID, A02.InventoryName, P11.ArrivalDate,
P030.BeginDate, P030.EndDate, DATEDIFF(d,P030.BeginDate, P030.EndDate),
DATEDIFF(hh,P030.BeginDate, P030.EndDate) - 24*DATEDIFF(d,P030.BeginDate, P030.EndDate), P030.VoucherNo
ORDER BY P11.ShipID, P11.InventoryID, P030.VoucherNo  '

END

IF @Mode = 4 -- Giao nhận
BEGIN
	IF @IsDate = 0 SET @sWhere = N'
AND P70.TranYear * 100 + P70.TranMonth BETWEEN '''+STR(@FromTranYear * 100 + @FromTranMonth)+''' 
                                       AND '''+STR(@ToTranYear * 100 + @ToTranMonth)+'''  '
    IF @IsDate = 1 SET @sWhere = N'
AND CONVERT(VARCHAR(10),P70.VoucherDate,111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,111)+''' '
	SET @sSQL = N'
SELECT P70.ShipID, P30.ShipName, P71.InventoryID, A02.InventoryName, P70.ArrivalDate,
SUM((CASE WHEN P71.ServiceType = 0 THEN P71.[Weight] ELSE 0 END)) AS Import,
SUM((CASE WHEN P71.ServiceType = 1 THEN P71.[Weight] ELSE 0 END)) AS Export,
SUM((CASE WHEN P71.UnitID = ''CT'' THEN P71.Quantity ELSE 0 END)) AS Cont,
P030.BeginDate, P030.EndDate, P70.ArrivalDate, DATEDIFF(d,P030.BeginDate, P030.EndDate) AS WorkDays,
DATEDIFF(hh,P030.BeginDate, P030.EndDate) - 24*DATEDIFF(d,P030.BeginDate, P030.EndDate) AS WorkHours,
SUM(CASE WHEN P71.UnitID = ''TA'' THEN P71.[Weight] ELSE 0 END) AS SumWeight, P71.UnitID,
SUM((CASE WHEN P71.UnitID = ''TA'' THEN P71.[Weight] ELSE 0 END)* H72.Price) AS MoneyAmount, P030.VoucherNo
FROM PST2071 P71
LEFT JOIN HT0272 H72 ON H72.DivisionID = P71.DivisionID AND H72.SalaryPlanID = P71.DeliveryPlanID
LEFT JOIN HT0271 H71 ON H71.DivisionID = H72.DivisionID AND H71.PriceID = H72.PriceID 
LEFT JOIN PST2070 P70 ON P70.DivisionID = P71.DivisionID AND P70.VoucherID = P71.VoucherID
LEFT JOIN PST2030 P030 ON P030.DivisionID = P70.DivisionID AND P030.VoucherID = P70.OrderVoucherID
LEFT JOIN PST1030 P30 ON P30.DivisionID = P70.DivisionID AND P30.ShipID = P70.ShipID
LEFT JOIN AT1302 A02 ON A02.DivisionID = P71.DivisionID AND A02.InventoryID = P71.InventoryID
WHERE P71.DivisionID = '''+@DivisionID+'''
AND P70.ShipID = '''+@ShipID+'''
'+@sWhere+'
AND CONVERT(VARCHAR(10),P70.ArrivalDate,101) = '''+CONVERT(VARCHAR(10),@ArrivalDate,101)+'''
AND H71.FromDate < GETDATE() AND H71.ToDate > GETDATE()
GROUP BY P70.ShipID, P30.ShipName, P71.InventoryID, A02.InventoryName,
P030.BeginDate, P030.EndDate, P70.ArrivalDate, DATEDIFF(d,P030.BeginDate, P030.EndDate),
DATEDIFF(hh,P030.BeginDate, P030.EndDate) - 24*DATEDIFF(d,P030.BeginDate, P030.EndDate),
P030.VoucherNo, P71.UnitID
ORDER BY P71.InventoryID'

END
EXEC (@sSQL)
PRINT (@sSQL)
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

