/****** Object: StoredProcedure [dbo].[AP1509] Script Date: 07/29/2010 10:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
----- Created by Hoang Thi Lan
----- Created Date 02/10/2003]
----- purpose: Loc ra nhung tai san chua tinh khau hao trong ky
------ Duoc phep tinh khau hao
---- Tinh toan so hao mon luy ke
---- Edit by Nguyen Quoc Huy

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1509] 
    @DivisionID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT
AS

DECLARE 
    @sSQL NVARCHAR(4000),
    @MonthYearText NVARCHAR(10)

SET @MonthYearText = STR(@TranMonth + @TranYear * 100)

SET @sSQL='
SELECT 
    AT1503.AssetID, 
    AT1503.AssetName,
    AT1503.ConvertedAmount,
    AT1503.DepPercent,
    AT1102.DepartmentName,
    AT1503.DepAccountID,
    AT1503.DivisionID,
    AT1503.ResidualValue 
    - ISNULL((SELECT SUM(DepAmount) FROM AT1504 
                WHERE AssetID = AT1503.AssetID 
                    AND DivisionID = AT1503.DivisionID 
                    AND TranMonth + TranYear * 100 < '+ @MonthYearText + '
            ), 0) AS RemainAmount
FROM AT1503 
    LEFT JOIN AT1102 ON AT1102.DivisionID = AT1503.DivisionID AND AT1503.DepartmentID = AT1102.DepartmentID
WHERE AT1503.AssetStatus = 0 
    AND AT1503.BeginMonth + AT1503.BeginYear * 100 <= ' + @MonthYearText + ' 
    AND AT1503.AssetID NOT IN (SELECT DISTINCT AssetID FROM AT1504 
                                WHERE DivisionID = AT1503.DivisionID 
                                    AND TranMonth + TranYear * 100 = ' + @MonthYearText + ')
    AND AT1503.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + '''))
'

--Print @sSQL

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'AV1509' AND Xtype ='V')
    EXEC ('CREATE VIEW AV1509 -- Tạo bởi AP1509
            AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW AV1509 -- Tạo bởi AP1509
            AS '+@sSQL)