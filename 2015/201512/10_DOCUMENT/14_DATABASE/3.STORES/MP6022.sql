
/****** Object:  StoredProcedure [dbo].[MP6022]    Script Date: 12/16/2010 13:51:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

---Created by: Vo Thanh Huong, date: 12/06/2005
---purpose: IN bao cao QLSX > Chi tiet tinh hinh thuc hien ke hoach san xuat -Dang 2: Ket qua san xuat toi thoi diem xem bao cao 

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP6022] 
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
    
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[MT6022]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[MT6022] (
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(50) NOT NULL,
    [PlanID] [NVARCHAR] (20) NULL, 
    [PlanDetailID] [NVARCHAR] (20) NULL,
    CONSTRAINT [PK_MT6022] PRIMARY KEY NONCLUSTERED 
    (
	[APK] ASC
    )
) ON [PRIMARY]

ELSE 
    DELETE MT6022

SELECT @sWHERE = '', @sSQL = '', @FromPeriod = CAST(@FromMonth + @FromYear*100 AS NVARCHAR(50)), 
        @ToPeriod = CAST(@ToMonth + @ToYear*100 AS NVARCHAR(50)), 
        @sFromDate = convert(NVARCHAR(50), @FromDate, 101), 
        @sToDate = convert(NVARCHAR(50), @ToDate, 101) + ' 23:59:59'

SET @sWHERE = ' AND '+ CASE WHEN @IsDate = 1 THEN ' convert(NVARCHAR(50), MT2001.VoucherDate, 101) BETWEEN ''' + @sFromDate + ''' AND ''' + @sToDate + '''' 
        ELSE ' MT2001.TranMonth + MT2001.TranYear*100 BETWEEN ' + @FromPeriod + ' AND ' + 
        @ToPeriod END

IF ISNULL(@PlanID, '%') = '%' AND ISNULL(@LinkNo, '%') = '%' AND ISNULL(@OrderID, '%') = '%'
BEGIN

----Lay  nhung LSX, MSK, Mat hang ky truoc chua san xuat xong  loai tru nhung LSX tinh trng 4, 9
----- va nhung LSX co tinh trang 4, 9 nhung ky nay co san xuat
SET @sSQL = '
INSERT MT6022(DivisionID, PlanID, PlanDetailID) 
SELECT Distinct MT2002.DivisionID, MT2002.PlanID, MT2002.PlanDetailID
FROM     MT2002 INNER JOIN MT2001 ON MT2001.PlanID = MT2002.PlanID AND MT2001.DivisionID = MT2002.DivisionID AND MT2002.Finish = 1 
    LEFT JOIN (SELECT MT2005.PlanID, 
        MT2005.InventoryID, 
        ISNULL(MT2005.LinkNo, '''') AS LinkNo, 
        MT2005.WorkID, 
        MT2005.LevelID, 
        SUM(ISNULL(ActualQuantity, 0)) AS ActualQuantity        
    FROM MT2005 INNER JOIN MT2004 ON MT2004.VoucherID = MT2005.VoucherID and MT2004.DivisionID = MT2005.DivisionID
    WHERE ISNULL(MT2005.PlanID, '''') <> '''' AND MT2005.DivisionID like ''' + @DivisionID + ''' AND ' + 
        CASE WHEN @IsDate = 1 THEN ' convert(NVARCHAR(50), MT2004.VoucherDate, 101) < ' + @sFromDate  ELSE
         ' MT2004.TranMonth + MT2004.TranYear*100 < ' + @FromPeriod END + '
    GROUP BY MT2005.PlanID, 
        MT2005.InventoryID, 
        ISNULL(MT2005.LinkNo, ''''), 
        MT2005.WorkID, 
        MT2005.LevelID) MT2005 
    ON MT2005.PlanID = MT2002.PlanID AND 
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
FROM MT2002 INNER JOIN MT2001 ON MT2001.PlanID = MT2002.PlanID
WHERE MT2002.DivisionID = ''' + @DivisionID +  ''' AND 
    PlanDetailID IN (SELECT Distinct PlanDetailID FROM MT2002 INNER JOIN MT2001 ON MT2001.PlanID = MT2002.PlanID and MT2001.DivisionID = MT2002.DivisionID
        INNER JOIN (SELECT Distinct PlanID, InventoryID, LinkNo, WorkID, LevelID
        FROM MT2005 INNER JOIN MT2004 ON MT2004.VoucherID = MT2005.VoucherID AND MT2004.DivisionID = MT2005.DivisionID
        WHERE MT2004.DivisionID = ''' + @DivisionID + ''' AND ' +
        CASE WHEN @IsDate = 1 THEN ' convert(NVARCHAR(50), MT2004.VoucherDate, 101)  BETWEEN ''' + @sFromDate + ''' AND ''' + @sToDate + '''' 
        ELSE ' MT2004.TranMonth + MT2004.TranYear*100 BETWEEN ' + @FromPeriod + ' AND ' + 
        @ToPeriod END + ') MT2005  ON MT2005.PlanID = MT2002.PlanID AND 
        ISNULL(MT2005.LinkNo, '''') = ISNULL(MT2002.LinkNo, '''') AND 
        ISNULL(MT2005.WorkID, '''') = ISNULL(MT2002.WorkID, '''') AND 
        ISNULL(MT2005.LevelID, '''') = ISNULL(MT2002.LevelID, '''') AND
        MT2005.InventoryID = MT2002.InventoryID
    WHERE MT2001.DivisionID = ''' + @DivisionID + '''' + @sWHERE+')'

END 
EXEC(@sSQL)
/*
IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV6022')
    DROP VIEW MV6022
EXEC('CREATE VIEW MV6022 ---tao boi MP6022
 AS ' + @sSQL) 
END
*/

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
FROM MT2002 INNER JOIN MT2001 ON MT2002.PlanID = MT2001.PlanID  and MT2002.DivisionID = MT2001.DivisionID
    LEFT JOIN AT1302 ON AT1302.InventoryID = MT2002.InventoryID AND AT1302.DivisionID = MT2002.DivisionID
    LEFT JOIN AT1304 ON AT1304.UnitID = MT2002.UnitID AND AT1304.DivisionID = MT2002.DivisionID
    LEFT JOIN AT1102 ON AT1102.DepartmentID = MT2002.DepartmentID AND AT1102.DivisionID = MT2002.DivisionID
    LEFT JOIN MT1702 ON MT1702.LevelID = MT2002.LevelID AND MT1702.WorkID = MT2002.WorkID and MT1702.DivisionID = MT2002.DivisionID
    LEFT JOIN (SELECT PlanID, PlanDetailID, max(EndDate) AS EndDate FROM  MT6007 GROUP BY PlanID, PlanDetailID) MT6007 ON
        MT6007.PlanID = MT2002.PlanID AND MT6007.PlanDetailID = MT2002.PlanDetailID 
    LEFT JOIN (SELECT max(MT2004.VoucherDate) AS ActualDate, 
        MT2005.PlanID, 
        MT2005.InventoryID, 
        ISNULL(MT2005.LinkNo, '''') AS LinkNo, 
        MT2005.WorkID, 
        MT2005.LevelID, 
        SUM(ISNULL(ActualQuantity, 0)) AS ActualQuantity        
    FROM MT2005 INNER JOIN MT2004 ON MT2004.VoucherID = MT2005.VoucherID AND MT2004.DivisionID = MT2005.DivisionID
    WHERE ISNULL(MT2005.PlanID, '''') <> '''' AND MT2005.DivisionID like ''' + @DivisionID + ''' AND ' + 
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
WHERE (MT2001.DivisionID like ''' + @DivisionID + ''' AND 
    MT2001.PlanID like ''' + ISNULL(@PlanID, '%') + ''' AND
    MT2002.LinkNo like ''' + ISNULL(@LinkNo, '%') + ''' AND 
    MT2002.InventoryID like ''' + ISNULL(@InventoryID, '%') + ''' AND
    MT2001.SOderID like ''' + ISNULL(@OrderID, '%') + '''
    ' +  @sWHERE + ')' + CASE WHEN
     ISNULL(@PlanID, '%') = '%' AND ISNULL(@LinkNo, '%') = '%' THEN    
    ' or  MT2002.PlanDetailID IN (SELECT Distinct  PlanDetailID FROM MT6022 MV6022) ' ELSE '' END + '
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
FROM MT2005 INNER JOIN MT2004 ON MT2004.VoucherID = MT2005.VoucherID AND MT2004.DivisionID = MT2005.DivisionID
    LEFT JOIN AT1304 ON AT1304.UnitID = MT2005.UnitID and AT1304.DivisionID = MT2005.DivisionID
    LEFT JOIN AT1102 ON AT1102.DepartmentID = MT2005.DepartmentID AND
        AT1102.DivisionID = MT2005.DivisionID 
    LEFT JOIN AT1302 ON AT1302.InventoryID = MT2005.InventoryID AND AT1302.DivisionID = MT2005.DivisionID
    LEFT JOIN MT1702 ON MT1702.LevelID = MT2005.LevelID AND MT1702.DivisionID = MT2005.DivisionID AND
        MT1702.WorkID = MT2005.WorkID  
    INNER JOIN MT2001 ON MT2005.PlanID = MT2001.PlanID AND MT2005.DivisionID = MT2001.DivisionID ' + @sWHERE + '
WHERE MT2004.DivisionID like ''' + @DivisionID + ''' AND 
    MT2005.PlanID like ''' +  ISNULL(@PlanID, '%') + ''' AND 
    ISNULL(MT2005.LinkNo, '''') like ''' + ISNULL(@LinkNo, '%') + ''' AND 
    ISNULL(MT2005.InventoryID, '''') like ''' + ISNULL(@InventoryID, '%') + ''' AND
    ISNULL(MT2001.SOderID, '''') like ''' + ISNULL(@OrderID, '%') + ''' AND ' + 
    CASE WHEN @IsDate = 1 THEN ' convert(NVARCHAR(50), MT2004.VoucherDate, 101)   BETWEEN ''' + @sFromDate + ''' AND ''' + @sToDate + '''' ELSE
        ' MT2004.TranMonth + MT2004.TranYear*100 BETWEEN ' + @FromPeriod + ' AND ' + @ToPeriod   END

IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV6021')
    DROP VIEW MV6021

EXEC('CREATE VIEW MV6021 --tao boi MP6021
 AS ' + @sSQL)