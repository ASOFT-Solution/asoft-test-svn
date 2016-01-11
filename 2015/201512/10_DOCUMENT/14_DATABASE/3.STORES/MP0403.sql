/****** Object: StoredProcedure [dbo].[MP0403] Script Date: 08/02/2010 14:26:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang Thi Lan
--Date 12/12/2003
---Purpose :Phan bo chi phi cho doi tuong(Dung cho Report MR0403)

/********************************************
'* Edited BY: [GS] [Thanh Trẫm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0403]
    @ParentPeriodID AS NVARCHAR(50), 
    @DivisionID AS NVARCHAR(50), 
    @TranMonth AS INT, 
    @TranYear AS INT
AS

DECLARE 
    @sSQL AS NVARCHAR(4000)

SET @sSQL = '
SELECT 
    MT01.Description AS ParentPeriodName, 
    MT01.Notes AS ParentPeriodNote, 
    MT01.FromMonth, 
    MT01.FromYear, 
    MT01.ToMonth, 
    MT01.ToYear, 
    MT02.Description AS ChildPeriodName, 
    MT06.UserName AS MaterialTypeName, 
    AT13.InventoryName, 
    MT9000.* 
FROM MT9000 
    LEFT JOIN MT1601 MT01 ON MT01.DivisionID = MT9000.DivisionID AND MT9000.ParentPeriodID = MT01.PeriodID 
    LEFT JOIN MT1601 MT02 ON MT02.DivisionID = MT9000.DivisionID AND MT9000.PeriodID = MT02.PeriodID 
    LEFT JOIN MT0699 MT06 ON MT06.DivisionID = MT9000.DivisionID AND MT9000.MaterialTypeID = MT06.MaterialTypeID
    LEFT JOIN AT1302 AT13 ON AT13.DivisionID = MT9000.DivisionID AND MT9000.InventoryID = AT13.InventoryID
WHERE ParentPeriodID = ''' + @ParentPeriodID + ''' 
    AND TranMonth = ' + STR(@TranMonth) + ' 
    AND TranYear = ' + STR(@TranYear) + ' 
    AND MT9000.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + '''))
'

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV0403' AND Xtype = 'V')
    EXEC ('CREATE VIEW MV0403 -- Tao boi MP0403
        AS ' + @sSQL)
ELSE
    EXEC ('ALTER VIEW MV0403 -- Tao boi MP0403
        AS ' + @sSQL)