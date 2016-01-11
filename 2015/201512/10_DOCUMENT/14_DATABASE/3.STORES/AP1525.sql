/****** Object: StoredProcedure [dbo].[AP1525] Script Date: 07/29/2010 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1525]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1525]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

--Creater BY :Nguyen Quoc Huy.
---Creadate:20/03/2007
-- Puppose :Lay du lieu cho man thay doi nguyen gia TSCD
-- Last Edit : Thuy Tuyen 14/07/2008

/********************************************
'* Edited BY: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP1525] 
    @DivisionID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT 
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @sSQL1 NVARCHAR(4000),
    @TranMonthYearText NVARCHAR(8)

SET @TranMonthYearText = STR((@TranYear * 100) + @TranMonth, 6)

SET @sSQL = ' 
SELECT 

(CASE WHEN EXISTS (
        SELECT TOP 1 AssetID 
        FROM AT1506 
        WHERE AT1506.DivisionID = AT1503.DivisionID AND AT1506.AssetID = AT1503.AssetID 
            AND AT1506.TranMonth + 100 * AT1506.TranYear <= ' + @TranMonthYearText + '
        )
    THEN (
        SELECT TOP 1 AT1506.ConvertedNewAmount 
        FROM AT1506 
        WHERE AT1506.DivisionID = AT1503.DivisionID AND AT1506.AssetID = AT1503.AssetID 
            AND AT1506.TranMonth + 100 * AT1506.TranYear <= ' + @TranMonthYearText + '
        ORDER BY AT1506.TranYear DESC, AT1506.TranMonth DESC
        )
    ELSE AT1503.ConvertedAmount END) AS ConvertedAmount, 

ISNULL(AT1503.ConvertedAmount, 0) 
- ISNULL(AT1503.ResidualValue, 0) 
+ (SELECT ISNULL(SUM(DepAmount), 0) FROM AT1504 
    WHERE AT1504.DivisionID = AT1503.DivisionID AND AT1504.AssetID = AT1503.AssetID) AS AccuDepAmount, 
            
(CASE WHEN EXISTS (
        SELECT TOP 1 AssetID 
        FROM AT1506 
        WHERE AT1506.DivisionID = AT1503.DivisionID AND AT1506.AssetID = AT1503.AssetID 
            AND AT1506.TranMonth + 100 * AT1506.TranYear <= ' + @TranMonthYearText + '
        )
    THEN (
        SELECT TOP 1 AT1506.ResidualNewValue 
        FROM AT1506 
        WHERE AT1506.DivisionID = AT1503.DivisionID AND AT1506.AssetID = AT1503.AssetID 
            AND AT1506.TranMonth + 100 * AT1506.TranYear <= ' + @TranMonthYearText + '
        ORDER BY AT1506.TranYear DESC, AT1506.TranMonth DESC
        )
    ELSE AT1503.ResidualValue END)
+ (CASE WHEN EXISTS (
        SELECT TOP 1 AssetID 
        FROM AT1506 
        WHERE AT1506.DivisionID = AT1503.DivisionID AND AT1506.AssetID = AT1503.AssetID 
            AND AT1506.TranMonth + 100 * AT1506.TranYear <= ' + @TranMonthYearText + '
        )
    THEN (
        SELECT TOP 1 ISNULL(AT1506.AccuDepAmount, 0) - (ISNULL(T03.ConvertedAmount, 0) - ISNULL(T03.ResidualValue, 0)) 
        FROM AT1506 
            INNER JOIN AT1503 T03 ON T03.DivisionID = AT1506.DivisionID AND T03.AssetID = AT1506.AssetID
        WHERE AT1506.DivisionID = AT1503.DivisionID AND AT1506.AssetID = AT1503.AssetID 
            AND AT1506.TranMonth + 100 * AT1506.TranYear <= ' + @TranMonthYearText + ' 
        ORDER BY AT1506.TranYear DESC, AT1506.TranMonth DESC
        )
    ELSE 0 END)
- (SELECT ISNULL(SUM(DepAmount), 0) FROM AT1504 
    WHERE DivisionID = AT1503.DivisionID AND AssetID = AT1503.AssetID) AS ResidualNewValue, 

(CASE WHEN EXISTS (
        SELECT TOP 1 AssetID 
        FROM AT1506 
        WHERE AT1506.DivisionID = AT1503.DivisionID
            AND AT1506.AssetID = AT1503.AssetID 
            AND AT1506.TranMonth + 100 * AT1506.TranYear <= ' + @TranMonthYearText + '
        )
    THEN (
        SELECT TOP 1 AT1506.DepNewAmount 
        FROM AT1506 
        WHERE AT1506.DivisionID = AT1503.DivisionID
            AND AT1506.AssetID = AT1503.AssetID 
            AND AT1506.TranMonth + 100 * AT1506.TranYear <= ' + @TranMonthYearText + '
        ORDER BY AT1506.TranYear DESC, AT1506.TranMonth DESC
        )
    ELSE AT1503.DepAmount END) AS DepAmount, 
    
(CASE WHEN EXISTS (
        SELECT TOP 1 AssetID 
        FROM AT1506 
        WHERE AT1506.DivisionID = AT1503.DivisionID
            AND AT1506.AssetID = AT1503.AssetID 
            AND AT1506.TranMonth + 100 * AT1506.TranYear <= ' + @TranMonthYearText + '
        )
    THEN (
        SELECT TOP 1 AT1506.DepNewPeriods 
        FROM AT1506 
        WHERE AT1506.DivisionID = AT1503.DivisionID
            AND AT1506.AssetID = AT1503.AssetID 
            AND AT1506.TranMonth + 100 * AT1506.TranYear <= ' + @TranMonthYearText + '
        ORDER BY AT1506.TranYear DESC, AT1506.TranMonth DESC
        )
    ELSE AT1503.DepPeriods END) AS DepPeriods, 
'
SET @sSQL1 = '
AT1503.DivisionID, 
AssetID, 
AssetName, 
EmployeeID, 
DepartmentID, 
AssetStatus,     
((SELECT ISNULL(COUNT(*), 0)
    FROM (SELECT DISTINCT AssetID, TranMonth, TranYear 
            FROM AT1504 
            WHERE AT1504.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + '''))
            GROUP BY TranMonth, AssetID, TranYear) A 
    WHERE A.AssetID = AT1503.AssetID AND A.TranMonth + A.TranYear * 100 <= ' + @TranMonthYearText + '
) 
+ ISNULL(AT1503.DepMonths, 0)) AS DepreciatedPeriods
FROM AT1503
WHERE AT1503.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + '''))
    AND AssetStatus IN (0, 1, 4) 
    AND AssetID NOT IN (SELECT AssetID FROM AT1504 
                        WHERE AT1504.DivisionID = AT1503.DivisionID AND TranMonth + TranYear * 100 >= ' + @TranMonthYearText + ')
    AND AssetID NOT IN (SELECT AssetID FROM AT1506 
                        WHERE AT1506.DivisionID = AT1503.DivisionID AND TranMonth + TranYear * 100 >= ' + @TranMonthYearText + ') 
'

print @sSQL
print @sSQL1

IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV1525')
    EXEC('CREATE VIEW AV1525 AS '+ @sSQL + @sSQL1)
ELSE
    EXEC('ALTER VIEW AV1525 AS '+ @sSQL + @sSQL1)