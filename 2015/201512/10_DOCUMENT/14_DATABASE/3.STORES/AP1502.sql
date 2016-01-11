/****** Object: StoredProcedure [dbo].[AP1502] Script Date: 07/29/2010 09:45:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created by Hoang Thi Lan, 
----- Created Date 04/10/2003.
----- Last Updated by Nguyen Van Nhan, Date 06/10/2003
----- Purpose: List ra cac but toan cua tai san, phuc vu cau SQL Edit Du lieu len Form "Sua but toan khau hao"

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1502] 
    @AssetID NVARCHAR(50), 
    @DivisionID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT
AS

DECLARE 
    @sSQL NVARCHAR(4000),
    @MonthYearText NVARCHAR(10)

SET @MonthYearText = STR(@TranMonth + @TranYear * 100)

SET @sSQL = '
SELECT 
    AT1503.AssetID, 
    AT1503.AssetName, 
    AT1503.ConvertedAmount, 
    AT1503.DepPercent, 
    AT1102.DepartmentName, 
    AT1504.VoucherDate, 
    AT1504.VoucherTypeID, 
    AT1504.VoucherNo, 
    AT1504.DebitAccountID, 
    AT1504.CreditAccountID, 
    AT1504.DepAmount, 
    AT1504.ObjectID, 
    AT1202.ObjectName, 
    AT1504.SourceID, 
    AT1504.BDescription, 
    AT1504.Ana01ID, 
    AT1504.Ana02ID, 
    AT1504.Ana03ID, 
    AT1504.Ana04ID, 
    AT1504.Ana05ID, 
    AT1504.Ana06ID, 
    AT1504.Ana07ID, 
    AT1504.Ana08ID, 
    AT1504.Ana09ID, 
    AT1504.Ana10ID, 
    AT1504.Status, 
    AT1504.DepreciationID, 
    AT1504.DivisionID,
    AT1503.ResidualValue 
    - ISNULL((SELECT SUM(DepAmount) FROM AT1504 
                WHERE AssetID = ''' + @AssetID + '''
                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + '''))
                    AND TranMonth + TranYear * 100 < ' + @MonthYearText + '
                ), 0) AS RemainAmount
FROM AT1504 
    LEFT JOIN AT1503 ON AT1503.DivisionID = AT1504.DivisionID AND AT1503.AssetID = AT1504.AssetID 
    LEFT JOIN AT1202 ON AT1202.DivisionID = AT1504.DivisionID AND AT1202.ObjectID = AT1504.ObjectID 
    LEFT JOIN AT1102 ON AT1102.DivisionID = AT1504.DivisionID AND AT1503.DepartmentID = AT1102.DepartmentID 
WHERE AT1504.AssetID = ''' + @AssetID + '''
    AND AT1503.AssetStatus = 0         
    AND AT1504.TranMonth + AT1504.TranYear * 100 = ' + @MonthYearText + '
    AND AT1503.BeginMonth + AT1503.BeginYear * 100 < = ' + @MonthYearText + '
    AND AT1504.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + '''))
'

--PRINT @sSQl

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'AV1502' AND Xtype = 'V')
    EXEC ('CREATE VIEW AV1502 -- Tạo bởi AP1502
            AS ' + @sSQL)
ELSE
    EXEC ('ALTER VIEW AV1502 -- Tạo bởi AP1502
            AS ' + @sSQL)