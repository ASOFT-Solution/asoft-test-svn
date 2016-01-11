IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP8010]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP8010]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Created BY : Hoang Thi Lan
--Date :26/11/2003
--Purpose:Lay du lieu len Report Ket qua phan bo chi phi cho doi tuong

/********************************************
'* Edited BY: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[MP8010] 
    @PeriodID NVARCHAR(50), 
    @DivisionID NVARCHAR(50) ,
    @MFML000193 NVARCHAR(50) = '',
    @MFML000194 NVARCHAR(50) = '',
    @MFML000195 NVARCHAR(50) = ''
    
AS

DECLARE @sSQL NVARCHAR(4000)

SET @sSQL = N'
SELECT 
    MT0400.ExpenseID, 
    (CASE WHEN MT0400.ExpenseID = ''COST001'' THEN MT0400.MaterialTypeID ELSE MT0400.ExpenseID END ) AS GroupID, 
    --(CASE WHEN MT0400.ExpenseID = ''COST001'' 
    --        THEN ''MFML000193'' 
    --     ELSE CASE WHEN MT0400.ExpenseID =''COST002'' 
    --        THEN ''MFML000194'' 
    --     ELSE ''MFML000195'' END END) AS GroupName, 
    (CASE WHEN MT0400.ExpenseID = ''COST001'' 
            THEN N''' + @MFML000193 + '''
         ELSE CASE WHEN MT0400.ExpenseID =''COST002'' 
            THEN N''' + @MFML000194 + '''
         ELSE N''' + @MFML000195 + ''' END END) AS GroupName, 
    MT0400.ProductID, 
    MT0400.ProductQuantity, 
    P.InventoryName AS ProductName, 
    MT0400.PeriodID, 
    MT0699.UserName, 
    MT0400.QuantityUnit, 
    (CASE WHEN MT0400.ExpenseID = ''COST001'' THEN MT0400.MaterialID ELSE MT0400.MaterialTypeID END) AS MaterialID, 
    (CASE WHEN MT0400.ExpenseID = ''COST001'' THEN M.InventoryName ELSE UserName END) AS MaterialName, 
    MT0400.MaterialQuantity, 
    MT0400.ConvertedAmount, 
    MT0400.ConvertedUnit, 
    MT0400.DivisionID ,
    MT0400.TranMonth,
    MT0400.TranYear,
    MT1601.Description
    ,MT1614.BeginningInprocessCost 
FROM MT0400 
    LEFT JOIN AT1302 M ON M.DivisionID      = MT0400.DivisionID AND M.InventoryID = MT0400.MaterialID
    LEFT JOIN AT1302 P ON P.DivisionID      = MT0400.DivisionID AND P.InventoryID = MT0400.ProductID
    LEFT JOIN MT0699   ON MT0699.DivisionID = MT0400.DivisionID AND MT0699.MaterialTypeID = MT0400.MaterialTypeID
    LEFT JOIN MT1601  ON MT1601.DivisionID      = MT0400.DivisionID AND MT1601.PeriodID = MT0400.PeriodID
    LEFT JOIN MT1614  ON MT1614.DivisionID      = MT0400.DivisionID AND MT1614.PeriodID = MT0400.PeriodID AND MT1614.ProductID = MT0400.ProductID
WHERE MT0400.PeriodID LIKE ''' + @PeriodID + ''' 
    AND MT0400.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + '''))
' 

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV8010' AND Xtype ='V')
    EXEC ('CREATE VIEW MV8010 -- Tao boi MP8010
        AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV8010 -- Tao boi MP8010
        AS '+@sSQL)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

