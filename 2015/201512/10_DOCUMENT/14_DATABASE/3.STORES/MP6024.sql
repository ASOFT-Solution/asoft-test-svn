
/****** Object:  StoredProcedure [dbo].[MP6024]    Script Date: 12/16/2010 13:55:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 12/06/2005
---purpose: IN bao cao QLSX > Chi tiet tinh hinh san xuat thanh pham -Dang 2: Ket qua san xuat toi thoi diem xem bao cao 

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER  PROCEDURE [dbo].[MP6024]  
    @DivisionID NVARCHAR(50), 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @IsDate TINYINT, 
    @PlanID NVARCHAR(50), 
    @LinkNo NVARCHAR(50), 
    @InventoryID NVARCHAR(50), 
    @OrderID NVARCHAR(50)
AS

DECLARE  
    @sSQL NVARCHAR(max), 
    @sWHERE NVARCHAR(max), 
    @FromPeriod NVARCHAR(50), 
    @ToPeriod NVARCHAR(50), 
    @sFromDate NVARCHAR(50), 
    @sToDate NVARCHAR(50)

SELECT @sWHERE = '', @sSQL = '', @FromPeriod = CAST(@FromMonth + @FromYear*100 AS NVARCHAR(50)), 
        @ToPeriod = CAST(@ToMonth + @ToYear*100 AS NVARCHAR(50)), 
        @sFromDate = convert(NVARCHAR(50), @FromDate, 101), 
        @sToDate = convert(NVARCHAR(50), @ToDate, 101)  + ' 23:59:59'
        
SET @sWHERE = ' AND '+ CASE WHEN @IsDate = 1 THEN ' convert(NVARCHAR(50), MT2001.VoucherDate, 101) BETWEEN ''' + @sFromDate + ''' AND ''' + @sToDate + '''' 
        ELSE ' MT2001.TranMonth + MT2001.TranYear*100 BETWEEN ' + @FromPeriod + ' AND ' + 
        @ToPeriod END

IF ISNULL(@PlanID, '%') = '%' AND ISNULL(@LinkNo, '%') = '%' AND ISNULL(@OrderID, '%') = '%'
BEGIN
----Lay  nhung LSX, MSK, Mat hang ky truoc chua san xuat xong  loai tru nhung LSX tinh trng 4, 9
----- va nhung LSX co tinh trang 4, 9 nhung ky nay co san xuat
SET @sSQL = '
SELECT Distinct MT2002.DivisionID, MT2002.PlanID, MT2002.PlanDetailID
FROM     MT2002 INNER JOIN MT2001 ON MT2001.PlanID = MT2002.PlanID AND MT2001.DivisionID = MT2002.DivisionID AND MT2002.Finish = 1 
    LEFT JOIN (SELECT MT2005.PlanID, 
        MT2005.InventoryID, 
        ISNULL(MT2005.LinkNo, '''') AS LinkNo, 
        MT2005.WorkID, 
        MT2005.LevelID, 
        SUM(ISNULL(ActualQuantity, 0)) AS ActualQuantity        
    FROM MT2005 INNER JOIN MT2004 ON MT2004.VoucherID = MT2005.VoucherID AND MT2004.DivisionID = MT2005.DivisionID 
    WHERE ISNULL(MT2005.PlanID, '''') <> '''' AND MT2005.DivisionID LIKE ''' + @DivisionID + ''' AND ' + 
        CASE WHEN @IsDate = 1 THEN ' convert(NVARCHAR(50), MT2004.VoucherDate, 101) < ' + @sFromDate  ELSE
         ' MT2004.TranMonth + MT2004.TranYear*100 < ' + @FromPeriod END + '
    GROUP BY MT2005.PlanID, 
        MT2005.InventoryID, 
        ISNULL(MT2005.LinkNo, ''''), 
        MT2005.WorkID, 
        MT2005.LevelID) MT2005 
    ON MT2005.PlanID = MT2002.PlanID And
    ISNULL(MT2005.LinkNo, '''') = ISNULL(MT2002.LinkNo, '''') AND 
    ISNULL(MT2005.WorkID, '''') = ISNULL(MT2002.WorkID, '''') AND 
    ISNULL(MT2005.LevelID, '''') = ISNULL(MT2002.LevelID, '''') AND
    MT2005.InventoryID = MT2002.InventoryID
WHERE MT2002.DivisionID = ''' + @DivisionID + ''' AND ' +    
    CASE WHEN @IsDate = 1 THEN ' convert(NVARCHAR(50), MT2001.VoucherDate, 101) < ' + @sFromDate  ELSE
     ' MT2001.TranMonth + MT2001.TranYear*100 < ' + @FromPeriod END + ' AND 
    MT2001.PlanStatus NOT IN(4, 9) AND 
    MT2002.PlanQuantity*0.9 > MT2005.ActualQuantity
UNION
SELECT Distinct MT2002.DivisionID, MT2002.PlanID, MT2002.PlanDetailID
FROM MT2002 INNER JOIN MT2001 ON MT2001.PlanID = MT2002.PlanID AND MT2002.Finish = 1
WHERE MT2002.DivisionID = ''' + @DivisionID +  ''' AND 
    PlanDetailID IN (SELECT Distinct PlanDetailID FROM MT2002 INNER JOIN MT2001 ON MT2001.PlanID = MT2002.PlanID AND MT2001.DivisionID = MT2002.DivisionID
        INNER JOIN (SELECT Distinct PlanID, InventoryID, LinkNo, WorkID, LevelID
        FROM MT2005 INNER JOIN MT2004 ON MT2004.VoucherID = MT2005.VoucherID AND MT2004.DivisionID = MT2005.DivisionID
        WHERE MT2004.DivisionID = ''' + @DivisionID + ''' AND ' +
        CASE WHEN @IsDate = 1 THEN '  convert(NVARCHAR(50), MT2004.VoucherDate, 101) BETWEEN ''' + @sFromDate + ''' AND ''' + @sToDate + '''' 
        ELSE ' MT2004.TranMonth + MT2004.TranYear*100 BETWEEN ' + @FromPeriod + ' AND ' + 
        @ToPeriod END + ') MT2005  ON MT2005.PlanID = MT2002.PlanID AND 
        ISNULL(MT2005.LinkNo, '''') = ISNULL(MT2002.LinkNo, '''') AND 
        ISNULL(MT2005.WorkID, '''') = ISNULL(MT2002.WorkID, '''') AND 
        ISNULL(MT2005.LevelID, '''') = ISNULL(MT2002.LevelID, '''') AND
        MT2005.InventoryID = MT2002.InventoryID
    WHERE MT2001.DivisionID = ''' + @DivisionID + '''' + @sWHERE+')'


IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV6024')
    DROP VIEW MV6024
EXEC('CREATE VIEW MV6024 ---tao boi MP6024
 AS ' + @sSQL) 
END
EXEC MP6020 @DivisionID, 1, 1990, @ToMonth, @ToYear, '01/01/1990', '01/01/1990', @IsDate, 
        NULL, NULL, '%', NULL, 0

SET @sSQL = '
SELECT MT2002.DivisionID, MT2001.PlanID AS VoucherID, 
    MT2001.VoucherNo, 
    MT2001.VoucherDate, 
    MT2001.PlanID AS PlanID, 
    MT2002.BeginDate, 
    MT2005.ActualDate, 
    MT6007.EndDate, 
    MT2002.InventoryID, 
    AT1302.InventoryName, 
    AT1304.UnitName, 
    MT2002.LinkNo, 
    MT2002.WorkID, 
    MT2002.LevelID, 
    MT1702.LevelName, 
    MT2002.Finish, 
    MT2002.PlanQuantity, 
    MT2005.ActualQuantity, 
    MT2002.DepartmentID, 
    AT1102.DepartmentName, 
    MT2002.Notes AS Description, 
    MT2001.SOderID AS MOrderID, 
    0 AS IsNotPlan    
FROM MT2002 INNER JOIN MT2001 ON MT2002.PlanID = MT2001.PlanID AND MT2002.DivisionID = MT2001.DivisionID And  MT2002.Finish = 1 
    LEFT JOIN AT1302 ON AT1302.InventoryID = MT2002.InventoryID AND AT1302.DivisionID = MT2002.DivisionID
    LEFT JOIN AT1304 ON AT1304.UnitID = MT2002.UnitID  AND AT1304.DivisionID = MT2002.DivisionID
    LEFT JOIN AT1102 ON AT1102.DepartmentID = MT2002.DepartmentID AND AT1102.DivisionID = MT2002.DivisionID
    LEFT JOIN MT1702 ON MT1702.LevelID = MT2002.LevelID AND MT1702.WorkID = MT2002.WorkID AND MT1702.DivisionID = MT2002.DivisionID
    LEFT JOIN (SELECT PlanID, PlanDetailID, MAX(EndDate) AS EndDate FROM  MT6007 GROUP BY  PlanID, PlanDetailID) MT6007 ON
        MT6007.PlanID = MT2002.PlanID AND MT6007.PlanDetailID = MT2002.PlanDetailID
    LEFT JOIN (SELECT MAX(MT2004.VoucherDate) AS ActualDate, 
        MT2005.PlanID, 
        MT2005.InventoryID, 
        ISNULL(MT2005.LinkNo, '''') AS LinkNo, 
        MT2005.WorkID, 
        MT2005.LevelID, 
        SUM(ISNULL(ActualQuantity, 0)) AS ActualQuantity        
    FROM MT2005 INNER JOIN MT2004 ON MT2004.VoucherID = MT2005.VoucherID AND MT2004.DivisionID = MT2005.DivisionID
    WHERE ISNULL(MT2005.PlanID, '''') <> '''' AND MT2005.DivisionID LIKE ''' + @DivisionID + ''' AND ' + 
        CASE WHEN @IsDate = 1 THEN ' convert(NVARCHAR(50), MT2004.VoucherDate, 101) <= ''' + @sToDate + '''' ELSE '
            MT2004.TranMonth + MT2004.TranYear*100 <= '     + @ToPeriod END + '    
    GROUP BY MT2005.PlanID, 
        MT2005.InventoryID, 
        ISNULL(MT2005.LinkNo, ''''), 
        MT2005.WorkID, 
        MT2005.LevelID) MT2005 ON MT2005.PlanID = MT2002.PlanID AND 
        ISNULL(MT2005.LinkNo, '''') = ISNULL(MT2002.LinkNo, '''') AND 
        ISNULL(MT2005.WorkID, '''') = ISNULL(MT2002.WorkID, '''') AND 
        ISNULL(MT2005.LevelID, '''') = ISNULL(MT2002.LevelID, '''') AND
        MT2005.InventoryID = MT2002.InventoryID
WHERE (MT2001.DivisionID LIKE ''' + @DivisionID + ''' AND 
    MT2001.PlanID LIKE ''' + ISNULL(@PlanID, '%') + ''' AND
    MT2002.LinkNo LIKE ''' + ISNULL(@LinkNo, '%') + ''' AND 
    MT2002.InventoryID LIKE ''' + ISNULL(@InventoryID, '%') + ''' AND 
    MT2001.SOderID LIKE ''' + ISNULL(@OrderID, '%') + '''' +  @sWHERE + ')' + CASE WHEN
     ISNULL(@PlanID, '%') = '%' AND ISNULL(@LinkNo, '%') = '%' THEN    
    ' or  MT2002.PlanDetailID IN (SELECT Distinct  PlanDetailID FROM MV6024) ' ELSE '' END + '
UNION
SELECT MT2005.DivisionID, MT2004.VoucherID, 
    MT2004.VoucherNo, 
    MT2004.VoucherDate, 
    MT2005.PlanID AS PlanID, 
    '''' AS BeginDate, 
    '''' AS ActualDate, 
    '''' AS EndDate, 
    MT2005.InventoryID, 
    AT1302.InventoryName, 
    AT1304.UnitName, 
    MT2005.LinkNo, 
    MT2005.WorkID, 
    MT2005.LevelID, 
    MT1702.LevelName, 
    1 AS Finish, 
    0 AS PlanQuantity, 
    MT2005.ActualQuantity, 
    MT2005.DepartmentID, 
    AT1102.DepartmentName, 
    MT2005.Description, 
    MT2001.SOderID AS MOrderID, 
    1 AS IsNotPlan
FROM MT2005 INNER JOIN MT2004 ON MT2004.VoucherID = MT2005.VoucherID  AND MT2004.DivisionID = MT2005.DivisionID
    LEFT JOIN AT1304 ON AT1304.UnitID = MT2005.UnitID AND AT1304.DivisionID = MT2005.DivisionID
    LEFT JOIN AT1102 ON AT1102.DepartmentID = MT2005.DepartmentID AND AT1102.DivisionID = MT2005.DivisionID 
    LEFT JOIN AT1302 ON AT1302.InventoryID = MT2005.InventoryID AND AT1302.DivisionID = MT2005.DivisionID 
    LEFT JOIN MT1702 ON MT1702.LevelID = MT2005.LevelID AND MT1702.DivisionID = MT2005.DivisionID AND 
        MT1702.WorkID = MT2005.WorkID  
    INNER JOIN MT2001 ON MT2005.PlanID = MT2001.PlanID ' + @sWHERE + '
    INNER JOIN MT2002 ON MT2002.PlanID = MT2001.PlanID AND MT2002.Finish = 1
WHERE MT2004.DivisionID LIKE ''' + @DivisionID + ''' AND 
    MT2005.PlanID LIKE ''' +  ISNULL(@PlanID, '%') + ''' AND 
    ISNULL(MT2005.LinkNo, '''') LIKE ''' + ISNULL(@LinkNo, '%') + ''' AND 
    ISNULL(MT2005.InventoryID, '''') LIKE ''' + ISNULL(@InventoryID, '%') + ''' AND 
    ISNULL(MT2001.SOderID, '''') LIKE ''' + ISNULL(@OrderID, '%') + ''' AND ' + 
    CASE WHEN @IsDate = 1 THEN ' convert(NVARCHAR(50), MT2004.VoucherDate, 101) BETWEEN ''' + @sFromDate + ''' AND ''' + @sToDate + '''' ELSE
        ' MT2004.TranMonth + MT2004.TranYear*100 BETWEEN ' + @FromPeriod + ' AND ' + @ToPeriod   END

IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV6023')
    DROP VIEW MV6023

EXEC('CREATE VIEW MV6023 --tao boi MP6024
 AS ' + @sSQL)
