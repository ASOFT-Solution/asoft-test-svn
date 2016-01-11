IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP03402]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP03402]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- In báo cáo : Bảng thanh toán tàu (CSG)(HR0340)
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
---- EXEC HP03402 'SAS', 'ADMIN', 7,2013,9,2013, 0,'2013-08-11 00:00:00.000','2013-08-11 00:00:00.000', 4

CREATE PROCEDURE HP03402
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
		@Mode TINYINT --2: Bốc xếp, 3: Cơ giới, 4: Giao nhận
) 
AS 
DECLARE @sSQL NVARCHAR(MAX), @sWhere NVARCHAR(MAX)

IF @Mode = 2 -- Bốc xếp
BEGIN
	IF @IsDate = 0 SET @sWhere = N'
AND P50.TranYear * 100 + P50.TranMonth BETWEEN  '''+STR(@FromTranYear * 100 + @FromTranMonth)+''' 
                                       AND '''+STR(@ToTranYear * 100 + @ToTranMonth)+'''  '
    IF @IsDate = 1 SET @sWhere = N'
AND CONVERT(VARCHAR(10),P50.VoucherDate,111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,111)+''' '
	SET @sSQL = N'
SELECT P51.ShipID, P30.ShipName,
(CASE WHEN P51.ServiceType = 0 THEN ''N'' WHEN P51.ServiceType = 1 THEN ''X'' END) AS NX,
CONVERT(VARCHAR(10),P030.BeginDate,103) AS BeginDate, P51.InventoryID, A02.InventoryName, P51.UnitID,
(CASE WHEN P51.UnitID = ''TA'' THEN SUM(ISNULL(P51.[Weight],0)) ELSE 0 END) AS SumWeight, 
(CASE WHEN P51.UnitID = ''TA'' THEN SUM(ISNULL(P51.[Weight],0)* H72.Price) ELSE 0 END) AS TAMoneyAmount,
(CASE WHEN P51.UnitID = ''CT'' THEN SUM(ISNULL(P51.Quantity,0)) ELSE 0 END) AS SumCont, 
(CASE WHEN P51.UnitID = ''CT'' THEN SUM(ISNULL(P51.Quantity,0)* H72.Price) ELSE 0 END) AS CTMoneyAmount,
(CASE WHEN P51.UnitID = ''K'' THEN SUM(ISNULL(P51.Quantity,0)) ELSE 0 END) AS SumKien, 
(CASE WHEN P51.UnitID = ''K'' THEN SUM(ISNULL(P51.Quantity,0)* H72.Price) ELSE 0 END) AS KMoneyAmount,
(CASE WHEN P51.UnitID = ''XE'' THEN SUM(ISNULL(P51.Quantity,0)) ELSE 0 END) AS SumXe, 
(CASE WHEN P51.UnitID = ''XE'' THEN SUM(ISNULL(P51.Quantity,0)* H72.Price) ELSE 0 END) AS XEMoneyAmount
FROM PST2051 P51
LEFT JOIN PST2050 P50 ON P50.DivisionID = P51.DivisionID AND P50.VoucherID = P51.VoucherID
LEFT JOIN HT0272 H72 ON H72.DivisionID = P51.DivisionID AND H72.SalaryPlanID = P51.TurnRoundPlanID
LEFT JOIN HT0271 H71 ON H71.DivisionID = H72.DivisionID AND H71.PriceID = H72.PriceID
LEFT JOIN AT1302 A02 ON A02.DivisionID = P51.DivisionID AND A02.InventoryID = P51.InventoryID
LEFT JOIN PST2040 P40 ON P40.DivisionID = P51.DivisionID AND P40.VoucherID = P51.CommandVoucherID
LEFT JOIN PST2030 P030 ON P030.DivisionID = P40.DivisionID AND P030.VoucherID = P40.CommandVoucherID
LEFT JOIN PST1030 P30 ON P30.DivisionID = P51.DivisionID AND P30.ShipID = P51.ShipID
WHERE H71.FromDate < GETDATE() AND H71.ToDate > GETDATE()
'+@sWhere+'
GROUP BY P51.ShipID, P30.ShipName,
(CASE WHEN P51.ServiceType = 0 THEN ''N'' WHEN P51.ServiceType = 1 THEN ''X'' END),
CONVERT(VARCHAR(10),P030.BeginDate,103),P51.InventoryID, A02.InventoryName, P51.UnitID
ORDER BY P51.ShipID  '
END

IF @Mode = 3 -- Cơ giới
BEGIN
	IF @IsDate = 0 SET @sWhere = N'
AND P10.TranYear * 100 + P10.TranMonth BETWEEN '''+STR(@FromTranYear * 100 + @FromTranMonth)+''' 
                                       AND '''+STR(@ToTranYear * 100 + @ToTranMonth)+'''  '
    IF @IsDate = 1 SET @sWhere = N'
AND CONVERT(VARCHAR(10),P10.VoucherDate,111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,111)+''' '
	SET @sSQL = N'
SELECT P11.ShipID, P30.ShipName,
(CASE WHEN P11.ServiceType = 0 THEN ''N'' WHEN P11.ServiceType = 1 THEN ''X'' END) AS NX,
CONVERT(VARCHAR(10),P030.BeginDate,103) AS BeginDate, P11.InventoryID, A02.InventoryName, P11.UnitID,
(CASE WHEN P11.UnitID = ''TA'' THEN SUM(ISNULL(P11.[Weight],0)) ELSE 0 END) AS SumWeight, 
(CASE WHEN P11.UnitID = ''TA'' THEN SUM(ISNULL(P11.[Weight],0)* H72.Price) ELSE 0 END) AS TAMoneyAmount,
(CASE WHEN P11.UnitID = ''CT'' THEN SUM(ISNULL(P11.Quantity,0)) ELSE 0 END) AS SumCont, 
(CASE WHEN P11.UnitID = ''CT'' THEN SUM(ISNULL(P11.Quantity,0)* H72.Price) ELSE 0 END) AS CTMoneyAmount,
(CASE WHEN P11.UnitID = ''K'' THEN SUM(ISNULL(P11.Quantity,0)) ELSE 0 END) AS SumKien, 
(CASE WHEN P11.UnitID = ''K'' THEN SUM(ISNULL(P11.Quantity,0)* H72.Price) ELSE 0 END) AS KMoneyAmount,
(CASE WHEN P11.UnitID = ''XE'' THEN SUM(ISNULL(P11.Quantity,0)) ELSE 0 END) AS SumXe, 
(CASE WHEN P11.UnitID = ''XE'' THEN SUM(ISNULL(P11.Quantity,0)* H72.Price) ELSE 0 END) AS XEMoneyAmount
FROM PST2111 P11
LEFT JOIN PST2110 P10 ON P10.DivisionID = P11.DivisionID AND P10.VoucherID = P11.VoucherID
LEFT JOIN PST1070 P70 ON P70.DivisionID = P11.DivisionID AND P70.EnginePlanID =  P11.EnginePlanID
LEFT JOIN HT0272 H72 ON H72.DivisionID = P70.DivisionID AND H72.SalaryPlanID = P70.SalaryPlanID
LEFT JOIN HT0271 H71 ON H71.DivisionID = H72.DivisionID AND H71.PriceID = H72.PriceID 
LEFT JOIN PST1030 P30 ON P30.DivisionID = P11.DivisionID AND P30.ShipID = P11.ShipID
LEFT JOIN PST2030 P030 ON P030.DivisionID = P11.DivisionID AND P030.VoucherID = P11.CommandVoucherID
LEFT JOIN AT1302 A02 ON A02.DivisionID = P11.DivisionID AND A02.InventoryID = P11.InventoryID
WHERE H71.FromDate < GETDATE() AND H71.ToDate > GETDATE()
'+@sWhere+'
GROUP BY P11.ShipID, P30.ShipName,
(CASE WHEN P11.ServiceType = 0 THEN ''N'' WHEN P11.ServiceType = 1 THEN ''X'' END),
CONVERT(VARCHAR(10),P030.BeginDate,103), P11.InventoryID, A02.InventoryName, P11.UnitID
'
END

IF @Mode = 4 -- Giao nhận
BEGIN
	IF @IsDate = 0 SET @sWhere = N'
AND P70.TranYear * 100 + P70.TranMonth BETWEEN '''+STR(@FromTranYear * 100 + @FromTranMonth)+''' 
                                       AND '''+STR(@ToTranYear * 100 + @ToTranMonth)+'''  '
    IF @IsDate = 1 SET @sWhere = N'
AND CONVERT(VARCHAR(10),P70.VoucherDate,111) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,111)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,111)+''' '
	SET @sSQL = N'
SELECT P70.ShipID, P30.ShipName,
(CASE WHEN P71.ServiceType = 0 THEN ''N'' WHEN P71.ServiceType = 1 THEN ''X'' END) AS NX,
CONVERT(VARCHAR(10),P030.BeginDate,103) AS BeginDate, P71.InventoryID, A02.InventoryName, P71.UnitID,
(CASE WHEN P71.UnitID = ''TA'' THEN SUM(ISNULL(P71.[Weight],0)) ELSE 0 END) AS SumWeight, 
(CASE WHEN P71.UnitID = ''TA'' THEN SUM(ISNULL(P71.[Weight],0)* H72.Price) ELSE 0 END) AS TAMoneyAmount,
(CASE WHEN P71.UnitID = ''CT'' THEN SUM(ISNULL(P71.Quantity,0)) ELSE 0 END) AS SumCont, 
(CASE WHEN P71.UnitID = ''CT'' THEN SUM(ISNULL(P71.Quantity,0)* H72.Price) ELSE 0 END) AS CTMoneyAmount,
(CASE WHEN P71.UnitID = ''K'' THEN SUM(ISNULL(P71.Quantity,0)) ELSE 0 END) AS SumKien, 
(CASE WHEN P71.UnitID = ''K'' THEN SUM(ISNULL(P71.Quantity,0)* H72.Price) ELSE 0 END) AS KMoneyAmount,
(CASE WHEN P71.UnitID = ''XE'' THEN SUM(ISNULL(P71.Quantity,0)) ELSE 0 END) AS SumXe, 
(CASE WHEN P71.UnitID = ''XE'' THEN SUM(ISNULL(P71.Quantity,0)* H72.Price) ELSE 0 END) AS XEMoneyAmount
FROM PST2071 P71
LEFT JOIN HT0272 H72 ON H72.DivisionID = P71.DivisionID AND H72.SalaryPlanID = P71.DeliveryPlanID
LEFT JOIN HT0271 H71 ON H71.DivisionID = H72.DivisionID AND H71.PriceID = H72.PriceID 
LEFT JOIN PST2070 P70 ON P70.DivisionID = P71.DivisionID AND P70.VoucherID = P71.VoucherID
LEFT JOIN PST2030 P030 ON P030.DivisionID = P70.DivisionID AND P030.VoucherID = P70.OrderVoucherID
LEFT JOIN PST1030 P30 ON P30.DivisionID = P70.DivisionID AND P30.ShipID = P70.ShipID
LEFT JOIN AT1302 A02 ON A02.DivisionID = P71.DivisionID AND A02.InventoryID = P71.InventoryID
WHERE H71.FromDate < GETDATE() AND H71.ToDate > GETDATE()
'+@sWhere+'
GROUP BY P70.ShipID, P30.ShipName,
(CASE WHEN P71.ServiceType = 0 THEN ''N'' WHEN P71.ServiceType = 1 THEN ''X'' END),
CONVERT(VARCHAR(10),P030.BeginDate,103),P71.InventoryID, A02.InventoryName, P71.UnitID
ORDER BY P70.ShipID  '
END


EXEC (@sSQL)
PRINT (@sSQL)
	
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

