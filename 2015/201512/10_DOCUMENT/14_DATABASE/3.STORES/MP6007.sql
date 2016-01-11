
/****** Object:  StoredProcedure [dbo].[MP6007]    Script Date: 12/16/2010 13:35:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 15/12/2004
---purpose: IN bao cao tong hop thanh pham 

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP6007] 
    @DivisionID NVARCHAR(50), 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @FromDate datetime, 
    @ToDate datetime, 
    @IsDate TINYINT, 
    @FromDepartmentID NVARCHAR(50), 
    @ToDepartmentID NVARCHAR(50), 
    @VouchertypeID NVARCHAR(50)
AS

DECLARE @sSQL NVARCHAR(4000), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

SET @sSQL = '
SELECT distinct MT2005.DivisionID, MT2005.DepartmentID, 
    AT1102.DepartmentName, 
    MT2005.LinkNo, MT2005.InventoryID, 
    AT1302.InventoryName, AT1304.UnitName, 
    ISNULL(MT2005.WorkID, '''') AS WorkID, 
    ISNULL(MT2005.LevelID, '''') AS LevelID, 
    ISNULL(MT1702.LevelName, '''') AS LevelName, 
     SUM(MT2005.ActualQuantity) AS ActualQuantity, 
    AVG(ISNULL(MT2002.PlanQuantity, 0)) AS PlanQuantity, 
    ISNULL(MT2005.Description, '''') AS Description, 
    OT2002.InventoryID AS ProductID, 
    AT1302_P.InventoryName AS ProductName
FROM MT2005  INNER JOIN MT2004  ON MT2004.VoucherID = MT2005.VoucherID and MT2004.DivisionID = MT2005.DivisionID
    INNER JOIN AT1302 ON AT1302.InventoryID = MT2005.InventoryID and AT1302.DivisionID = MT2005.DivisionID
    LEFT JOIN AT1304  ON AT1304.UnitID = MT2005.UnitID and AT1304.DivisionID = MT2005.DivisionID
    LEFT JOIN MT1702 ON MT1702.LevelID = MT2005.LevelID AND MT1702.WorkID = MT2005.WorkID and MT1702.DivisionID = MT2005.DivisionID
    LEFT JOIN MT2001 ON MT2001.PlanID = MT2005.PlanID     and MT2001.DivisionID = MT2005.DivisionID
    LEFT JOIN MT2002 ON MT2002.PlanID = MT2005.PlanID AND MT2002.LinkNo = MT2005.LinkNo AND
        MT2002.InventoryID = MT2005.InventoryID and MT2002.DivisionID = MT2005.DivisionID
    LEFT JOIN OT2002 ON OT2002.SOrderID = MT2001.SOderID AND OT2002.LinkNo = MT2005.LinkNo    and OT2002.DivisionID = MT2005.DivisionID    
    LEFT JOIN AT1302 AT1302_P ON AT1302_P.InventoryID = OT2002.InventoryID  and AT1302_P.DivisionID = MT2005.DivisionID
    LEFT JOIN AT1102 ON AT1102.DepartmentID = MT2005.DepartmentID AND 
        AT1102.DivisionID = MT2005.DivisionID
WHERE MT2004.DivisionID like ''' + @DivisionID + ''' AND ' + CASE WHEN @IsDate = 1 THEN ' 
    MT2004.VoucherDate between ''' + @FromDateText + ''' AND ''' + @ToDateText +  '''' ELSE '
    MT2004.TranMonth + MT2004.TranYear*100 between ' + @FromMonthYearText + ' AND ' + 
    @ToMonthYearText END + ' 
 AND ISNULL(MT2005.DepartmentID, ''' +@FromDepartmentID + ''') between ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''' 
 AND MT2004.VoucherTypeID like ''' + @VoucherTypeID + '''
GROUP BY     MT2005.DivisionID, MT2005.DepartmentID, 
    AT1102.DepartmentName, 
    MT2005.LinkNo, 
    MT2005.InventoryID, 
    AT1302.InventoryName, AT1304.UnitName, 
    ISNULL(MT2005.WorkID, ''''), 
    ISNULL(MT2005.LevelID, ''''), 
    ISNULL(MT1702.LevelName, ''''), 
    ISNULL(MT2005.Description, ''''), 
    OT2002.InventoryID, 
    AT1302_P.InventoryName'

--print @sSQL

IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV6007')
    DROP VIEW MV6007
EXEC('CREATE VIEW MV6007 ---tao boi MP6007        
 AS ' + @sSQL)