/****** Object: StoredProcedure [dbo].[AP1625] Script Date: 07/28/2010 15:16:41 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1625]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1625]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

--Creater by :Nguyen Quoc Huy.
---Creadate:14/07/2009
-- Puppose :Lay du lieu cho man thay doi nguyen gia CCDC
-- Last Edit Thuy Tuyen, sua cach tinh so tien con lai, date 04/02/2010
--- Edited by Bao Anh	Date: 08/07/2012
--- Purpose: Where them dieu kien VoucherID
/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/
--Example: AP1625 'MP',5,2012

CREATE PROCEDURE [dbo].[AP1625] 
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
DivisionID, 
ToolID, 
ToolName, 

(CASE WHEN EXISTS (
        SELECT TOP 1 ToolID 
        FROM AT1606 
        WHERE AT1606.DivisionID = AT1603.DivisionID AND AT1606.ToolID = AT1603.ToolID And AT1606.ReVoucherID = AT1603.VoucherID
            AND AT1606.TranMonth + 100 * AT1606.TranYear <= ' + @TranMonthYearText + ')
    THEN (
        SELECT TOP 1 AT1606.ConvertedNewAmount 
        FROM AT1606 
        WHERE AT1606.DivisionID = AT1603.DivisionID AND AT1606.ToolID = AT1603.ToolID And AT1606.ReVoucherID = AT1603.VoucherID
            AND AT1606.TranMonth + 100 * AT1606.TranYear <= ' + @TranMonthYearText + '
        ORDER BY AT1606.TranYear DESC, AT1606.TranMonth DESC
        )
    ELSE AT1603.ConvertedAmount END) AS ConvertedAmount, 

(SELECT ISNULL(SUM(DepAmount), 0) FROM AT1604 
WHERE AT1604.DivisionID = AT1603.DivisionID AND AT1604.ToolID = AT1603.ToolID And AT1604.ReVoucherID = AT1603.VoucherID) AS AccuDepAmount, 

(CASE WHEN EXISTS (
        SELECT TOP 1 ToolID 
        FROM AT1606 
        WHERE AT1606.DivisionID = AT1603.DivisionID AND AT1606.ToolID = AT1603.ToolID And AT1606.ReVoucherID = AT1603.VoucherID
            AND AT1606.TranMonth + 100 * AT1606.TranYear <= ' + @TranMonthYearText + ')
    THEN (
        SELECT TOP 1 AT1606.ResidualNewValue 
        FROM AT1606 
        WHERE AT1606.DivisionID = AT1603.DivisionID AND AT1606.ToolID = AT1603.ToolID And AT1606.ReVoucherID = AT1603.VoucherID
            AND AT1606.TranMonth + 100 * AT1606.TranYear <= ' + @TranMonthYearText + '
        ORDER BY AT1606.TranYear DESC, AT1606.TranMonth DESC
        )
ELSE AT1603.ConvertedAmount END)
+ (CASE WHEN EXISTS (
        SELECT TOP 1 ToolID 
        FROM AT1606 
        WHERE AT1606.DivisionID = AT1603.DivisionID AND AT1606.ToolID = AT1603.ToolID And AT1606.ReVoucherID = AT1603.VoucherID
            AND AT1606.TranMonth + 100 * AT1606.TranYear <= ' + @TranMonthYearText + '
        )
    THEN (
        SELECT TOP 1 AT1606.AccuDepAmount 
        FROM AT1606 
            INNER JOIN AT1603 T03 ON T03.DivisionID = AT1606.DivisionID AND T03.ToolID = AT1606.ToolID And T03.VoucherID = AT1606.ReVoucherID
        WHERE ---AT1606.DivisionID = AT1603.DivisionID AND AT1606.ToolID = AT1603.ToolID AND
             AT1606.TranMonth + 100 * AT1606.TranYear <= ' + @TranMonthYearText + '
        ORDER BY AT1606.TranYear DESC, AT1606.TranMonth DESC 
        )
    ELSE 0 END)
- (SELECT ISNULL(SUM(DepAmount), 0) FROM AT1604 
    WHERE AT1604.DivisionID = AT1603.DivisionID AND AT1604.ToolID = AT1603.ToolID And AT1604.ReVoucherID = AT1603.VoucherID) AS ResidualNewValue, 
'
SET @sSQL1 = ' 
(CASE WHEN EXISTS (
        SELECT TOP 1 ToolID 
        FROM AT1606 
        WHERE AT1606.DivisionID = AT1603.DivisionID AND AT1606.ToolID = AT1603.ToolID And AT1606.ReVoucherID = AT1603.VoucherID
            AND AT1606.TranMonth + 100 * AT1606.TranYear <= ' + @TranMonthYearText + '
        )
    THEN (
        SELECT TOP 1 AT1606.ConvertedNewAmount 
        FROM AT1606 
        WHERE AT1606.DivisionID = AT1603.DivisionID AND AT1606.ToolID = AT1603.ToolID And AT1606.ReVoucherID = AT1603.VoucherID
            AND AT1606.TranMonth + 100 * AT1606.TranYear <= ' + @TranMonthYearText + '
        ORDER BY AT1606.TranYear DESC, AT1606.TranMonth DESC
        )
    ELSE AT1603.ConvertedAmount END) 
/ (CASE WHEN EXISTS (
        SELECT TOP 1 ToolID 
        FROM AT1606 
        WHERE AT1606.DivisionID = AT1603.DivisionID AND AT1606.ToolID = AT1603.ToolID And AT1606.ReVoucherID = AT1603.VoucherID
            AND AT1606.TranMonth + 100 * AT1606.TranYear <= ' + @TranMonthYearText + '
        )
    THEN (
        SELECT TOP 1 AT1606.DepNewPeriods 
        FROM AT1606 
        WHERE AT1606.DivisionID = AT1603.DivisionID AND AT1606.ToolID = AT1603.ToolID And AT1606.ReVoucherID = AT1603.VoucherID
            AND AT1606.TranMonth + 100 * AT1606.TranYear <= ' + @TranMonthYearText + '
        ORDER BY AT1606.TranYear DESC, AT1606.TranMonth DESC 
        )
    ELSE AT1603.Periods END) AS DepAmount, 

(CASE WHEN EXISTS (
        SELECT TOP 1 ToolID 
        FROM AT1606 
        WHERE AT1606.DivisionID = AT1603.DivisionID AND AT1606.ToolID = AT1603.ToolID And AT1606.ReVoucherID = AT1603.VoucherID
            AND AT1606.TranMonth + 100 * AT1606.TranYear <= ' + @TranMonthYearText + '
        )
    THEN (
        SELECT TOP 1 AT1606.DepNewPeriods 
        FROM AT1606 
        WHERE AT1606.DivisionID = AT1603.DivisionID AND AT1606.ToolID = AT1603.ToolID And AT1606.ReVoucherID = AT1603.VoucherID
            AND AT1606.TranMonth + 100 * AT1606.TranYear <= ' + @TranMonthYearText + '
        ORDER BY AT1606.TranYear DESC, AT1606.TranMonth DESC 
        )
    ELSE AT1603.Periods END) AS DepPeriods, 

(SELECT ISNULL(COUNT(*), 0)
    FROM (SELECT DISTINCT ToolID, TranMonth, TranYear, ReVoucherID 
            FROM AT1604 
            WHERE AT1604.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + '''))
            GROUP BY TranMonth, ToolID, TranYear, ReVoucherID) A 
    WHERE A.ToolID = AT1603.ToolID And A.ReVoucherID = AT1603.VoucherID AND A.TranMonth + A.TranYear * 100 <= ' + @TranMonthYearText + ')  AS DepreciatedPeriods,

VoucherID as ReVoucherID, VoucherNo as ReVoucherNo

FROM AT1603
WHERE VoucherID NOT IN (SELECT ReVoucherID FROM AT1604 
                        WHERE AT1604.DivisionID = AT1603.DivisionID AND TranMonth + TranYear * 100 >= ' + @TranMonthYearText + ')
    AND VoucherID NOT IN (SELECT ReVoucherID FROM AT1606 
                        WHERE AT1606.DivisionID = AT1603.DivisionID AND TranMonth + TranYear * 100 >= ' + @TranMonthYearText + ') 
'

IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV1625')
    EXEC('CREATE VIEW AV1625 AS '+ @sSQL + @sSQL1 )
ELSE
    EXEC('ALTER VIEW AV1625 AS '+ @sSQL + @sSQL1 )

