
/****** Object:  StoredProcedure [dbo].[MP6012]    Script Date: 12/16/2010 13:40:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 28/06/2005
---purpose:Bao cao QLSX>Tinh hinh san xuat thanh pham

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP6012] 
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
    @PlanID NVARCHAR(50) 
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @FromPeriod NVARCHAR(50), 
    @ToPerioD NVARCHAR(50), 
    @sFromDate NVARCHAR(50), 
    @sToDate NVARCHAR(50)

SELECT @FromPeriod = CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)), 
    @ToPerioD = CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)), 
    @sFromDate = convert(NVARCHAR(50), @FromDate, 103), 
    @sToDate = convert(NVARCHAR(50), @ToDate, 103)

--Lay ngay yeu cau hoan thanh cuoi cung cua tung SP cua LSX
EXEC MP6020 @DivisionID, 1, 1990, @ToMonth, @ToYear, '01/01/1990', @ToDate, @IsDate, 
        @FromDepartmentID, @ToDepartmentID, @PlanID, 1 --tra ra MT6007

--lay Ket qua san xuat cua ky truoc 
SET @sSQL = 
'SELECT MT2005.DivisionID,MT2005.PlanID, InventoryID, ISNULL(LinkNo, '''') AS LinkNo, WorkID, LevelID, SUM(ISNULL(ActualQuantity, 0)) AS ActualQuantity
FROM MT2005 INNER JOIN MT2004 ON MT2005.VoucherID = MT2004.VoucherID AND MT2005.Finish = 1
WHERE MT2004.DivisionID  like  ''' + @DivisionID + ''' AND ' + 
    CASE WHEN @IsDate = 1 THEN ' MT2004.VoucherDate < ''' + @sFromDate + '''' ELSE ' MT2004.TranMonth <' + @FromPeriod   END + ' AND 
    MT2005.DepartmentID BETWEEN '''+ @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''' AND 
    MT2005.PlanID like ''' + @PlanID + ''' 
GROUP BY MT2005.DivisionID, MT2005.PlanID, InventoryID, LinkNo, WorkID, LevelID' 

IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV6013')
     DROP VIEW MV6013
EXEC('CREATE VIEW MV6013 ---tao boi MP6012
 AS ' + @sSQL)

--Lay ra nhung ke hoach san xuat chua san xuat xong cua cac ky truoc 
SET @sSQL ='
SELECT Distinct MT2002.DivisionID, MT2002.PlanID, MT2002.PlanDetailID, MT2002.BeginDate, MT2002.InventoryID, MT2002.UnitID, PlanQuantity, 
    MT2001.VoucherNo, MT2001.VoucherDate, MT2002.LinkNo, MT2002.WorkID, MT2002.LevelID, SOderID
FROM MT2002 INNER JOIN MT2001 ON MT2002.PlanID = MT2001.PlanID AND MT2002.Finish = 1 AND MT2001.PlanStatus IN(0, 1, 2)
    LEFT JOIN MV6013 ON MV6013.PlanID = MT2002.PlanID AND 
    MT2002.InventoryID = MV6013.InventoryID AND 
    MT2002.LinkNo = CASE WHEN ISNULL(MT2002.LinkNo, '''') <> '''' THEN   MV6013.LinkNo ELSE MT2002.LinkNo END AND 
    MT2002.WorkID = CASE WHEN ISNULL(MT2002.WorkID, '''') <> '''' THEN MV6013.WorkID ELSE MT2002.WorkID END AND 
    MT2002.LevelID = CASE WHEN ISNULL(MT2002.LevelID, '''') <> '''' THEN MV6013.LevelID ELSE MT2002.LevelID END 
WHERE MT2001.DivisionID  like  ''' + @DivisionID + ''' AND ' +  
    CASE WHEN @IsDate = 1 THEN ' MT2001.VoucherDate < ''' + @sFromDate +  '''' ELSE ' MT2001.TranMonth <' + @FromPeriod   END + ' AND 
    MT2002.DepartmentID BETWEEN '''+ @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''' AND 
    MT2001.PlanID like ''' + @PlanID + ''' AND 
    MT2002.Finish = 1 AND MT2002.PlanQuantity - ISNULL(MV6013.ActualQuantity, 0) > 0 '

IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV6014')
     DROP VIEW MV6014
EXEC('CREATE VIEW MV6014 ---tao boi MP6012
 AS ' + @sSQL)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Ket qua san xuat den ky hien tai
SET @sSQL = 
'SELECT MT2005.DivisionID, MT2005.PlanID, InventoryID, ISNULL(LinkNo, '''') AS LinkNo, WorkID, LevelID, 
    SUM(ISNULL(ActualQuantity, 0)) AS ActualQuantity, Max(VoucherDate) AS ActualDate
FROM MT2005 INNER JOIN MT2004 ON MT2005.VoucherID = MT2004.VoucherID AND MT2005.Finish = 1
WHERE MT2004.DivisionID  like  ''' + @DivisionID + ''' AND ' + 
    CASE WHEN @IsDate = 1 THEN ' MT2004.VoucherDate <= ''' + @sToDate + '''' ELSE ' MT2004.TranMonth <=' + @ToPeriod   END + ' AND 
    MT2005.DepartmentID BETWEEN '''+ @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''' AND 
    MT2005.PlanID like ''' + @PlanID + ''' 
GROUP BY MT2005.DivisionID, MT2005.PlanID, InventoryID, LinkNo, WorkID, LevelID' 

IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV6013')
     DROP VIEW MV6013
EXEC('CREATE VIEW MV6013 ---tao boi MP6012
 AS ' + @sSQL)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET @sSQL = 
'SELECT MT2002.DivisionID, MT2001.VoucherNo AS PlanNo, MT2001.VoucherDate AS PlanDate, MT2001.SOderID AS MOrderID, MT2002.InventoryID, AT1302.InventoryName, MT2002.UnitID, 
    PlanQuantity, ISNULL(MV6013.ActualQuantity, 0) AS ActualQuantity, MT2002.LinkNo, MT2002.WorkID, MT2002.LevelID, 
     MT2002.BeginDate, MT6007.EndDate, ISNULL(MV6013.ActualDate, '''') AS ActualDate
FROM MT2002 INNER JOIN MT2001 ON MT2001.PlanID = MT2002.PlanID 
    INNER JOIN AT1302 ON AT1302.InventoryID = MT2002.InventoryID 
    INNER JOIN MT6007 ON MT2002.PlanID = MT6007.PlanID AND MT2002.PlanDetailID = MT6007.PlanDetailID
    LEFT JOIN MV6013 ON MV6013.PlanID = MT2002.PlanID AND 
    MT2002.InventoryID = MV6013.InventoryID AND 
    MT2002.LinkNo = CASE WHEN ISNULL(MT2002.LinkNo, '''') <> '''' THEN   MV6013.LinkNo ELSE MT2002.LinkNo END AND 
    MT2002.WorkID = CASE WHEN ISNULL(MT2002.WorkID, '''') <> '''' THEN MV6013.WorkID ELSE MT2002.WorkID END AND 
    MT2002.LevelID = CASE WHEN ISNULL(MT2002.LevelID, '''') <> '''' THEN MV6013.LevelID ELSE MT2002.LevelID END 
WHERE MT2001.DivisionID  like  ''' + @DivisionID + ''' AND ' + 
    CASE WHEN @IsDate = 1 THEN ' MT2001.VoucherDate BETWEEN ''' + @sFromDate + ''' AND ''' + @sToDate + '''' 
    ELSE ' MT2001.TranMonth BETWEEN ' + @FromPeriod  + ' AND ' + @ToPeriod  END + ' AND 
    MT2002.DepartmentID BETWEEN '''+ @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''' AND 
    MT2002.PlanID like ''' + @PlanID + ''' UNION 
SELECT MV6014.DivisionID, MT2002.VoucherNo AS PlanNo, MT2002.VoucherDate AS PlanDate, MT2002.SOderID AS MOrderID, MT2002.InventoryID, AT1302.InventoryName, MT2002.UnitID, 
    PlanQuantity, ISNULL(MV6013.ActualQuantity, 0) AS ActualQuantity, MT2002.LinkNo, MT2002.WorkID, MT2002.LevelID, 
     MT2002.BeginDate, MT6007.EndDate, ISNULL(MV6013.ActualDate, '''') AS ActualDate
FROM MV6014 MT2002 INNER JOIN AT1302 ON AT1302.InventoryID = MT2002.InventoryID 
    INNER JOIN MT6007 ON MT2002.PlanID = MT6007.PlanID AND MT2002.PlanDetailID = MT6007.PlanDetailID
    LEFT JOIN MV6013 ON MV6013.PlanID = MT2002.PlanID AND 
    MT2002.InventoryID = MV6013.InventoryID AND 
    MT2002.LinkNo = CASE WHEN ISNULL(MT2002.LinkNo, '''') <> '''' THEN   MV6013.LinkNo ELSE MT2002.LinkNo END AND 
    MT2002.WorkID = CASE WHEN ISNULL(MT2002.WorkID, '''') <> '''' THEN MV6013.WorkID ELSE MT2002.WorkID END AND 
    MT2002.LevelID = CASE WHEN ISNULL(MT2002.LevelID, '''') <> '''' THEN MV6013.LevelID ELSE MT2002.LevelID END '


IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV6012')
     DROP VIEW MV6012
EXEC('CREATE VIEW MV6012 ---tao boi MP6012
 AS ' + @sSQL)


SET NOCOUNT OFF