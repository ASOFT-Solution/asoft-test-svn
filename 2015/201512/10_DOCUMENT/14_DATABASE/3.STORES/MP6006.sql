
/****** Object:  StoredProcedure [dbo].[MP6006]    Script Date: 12/16/2010 13:28:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 15/12/2004
---purpose: IN bang ke thuc hien san xuat

/********************************************
'* Edited by: [GS] [Việt Khánh] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP6006] 
    @DivisionID NVARCHAR(50), 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @FromDepartmentID NVARCHAR(50), 
    @ToDepartmentID NVARCHAR(50), 
    @PlanID NVARCHAR(50)
AS

DECLARE @sSQL NVARCHAR(4000)

--Xac dinh ngay yeu cau hoan thanh
SET @sSQL = 'SELECT T00.DivisionID, T00.PlanID, InventoryID, LinkNo, 
     CASE WHEN ISNULL(Quantity40, 0) <> 0 THEN Date40 
    ELSE CASE WHEN ISNULL(Quantity39, 0) <> 0 THEN Date39 
    ELSE CASE WHEN ISNULL(Quantity38, 0) <> 0 THEN Date38 
    ELSE CASE WHEN ISNULL(Quantity37, 0) <> 0 THEN Date37 
    ELSE CASE WHEN ISNULL(Quantity36, 0) <> 0 THEN Date36 
    ELSE CASE WHEN ISNULL(Quantity35, 0) <> 0 THEN Date35 
    ELSE CASE WHEN ISNULL(Quantity34, 0) <> 0 THEN Date34 
    ELSE CASE WHEN ISNULL(Quantity33, 0) <> 0 THEN Date33 
    ELSE CASE WHEN ISNULL(Quantity32, 0) <> 0 THEN Date32 
    ELSE CASE WHEN ISNULL(Quantity31, 0) <> 0 THEN Date31 
END END END END END END END END END END 
AS EndDate
FROM MT2002 T00 INNER JOIN MT2003 T01 ON T00.PlanID = T01.PlanID 
        INNER JOIN MT2001 T02 ON T02.PlanID = T00.PlanID 
WHERE T00.TranMonth + T00.TranYear*100 between ' + CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)) + ' AND ' + 
        CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)) + ' AND
        T00.PlanID like ''' + @PlanID + ''' AND
        T02.DepartmentID between ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + '''
UNION
SELECT T00.DivisionID, T00.PlanID, InventoryID, LinkNo, CASE WHEN ISNULL(Quantity30, 0) <> 0 THEN Date30 
    ELSE CASE WHEN ISNULL(Quantity29, 0) <> 0 THEN Date29 
    ELSE CASE WHEN ISNULL(Quantity28, 0) <> 0 THEN Date28 
    ELSE CASE WHEN ISNULL(Quantity27, 0) <> 0 THEN Date27 
    ELSE CASE WHEN ISNULL(Quantity26, 0) <> 0 THEN Date26 
    ELSE CASE WHEN ISNULL(Quantity25, 0) <> 0 THEN Date25 
    ELSE CASE WHEN ISNULL(Quantity24, 0) <> 0 THEN Date24 
    ELSE CASE WHEN ISNULL(Quantity23, 0) <> 0 THEN Date23 
    ELSE CASE WHEN ISNULL(Quantity22, 0) <> 0 THEN Date22 
    ELSE CASE WHEN ISNULL(Quantity21, 0) <> 0 THEN Date21 
END END END END END END END END END END 
AS EndDate
FROM MT2002 T00 INNER JOIN MT2003 T01 ON T00.PlanID = T01.PlanID 
        INNER JOIN MT2001 T02 ON T02.PlanID = T00.PlanID 
WHERE T00.TranMonth + T00.TranYear*100 between ' + CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)) + ' AND ' + 
        CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)) + ' AND
        T00.PlanID like ''' + @PlanID + ''' AND
        T02.DepartmentID between ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + '''
UNION
SELECT T00.DivisionID, T00.PlanID, InventoryID, LinkNo, CASE WHEN ISNULL(Quantity20, 0) <> 0 THEN Date20 
    ELSE CASE WHEN ISNULL(Quantity19, 0) <> 0 THEN Date19 
    ELSE CASE WHEN ISNULL(Quantity18, 0) <> 0 THEN Date18 
    ELSE CASE WHEN ISNULL(Quantity17, 0) <> 0 THEN Date17 
    ELSE CASE WHEN ISNULL(Quantity16, 0) <> 0 THEN Date16 
    ELSE CASE WHEN ISNULL(Quantity15, 0) <> 0 THEN Date15 
    ELSE CASE WHEN ISNULL(Quantity14, 0) <> 0 THEN Date14 
    ELSE CASE WHEN ISNULL(Quantity13, 0) <> 0 THEN Date13 
    ELSE CASE WHEN ISNULL(Quantity12, 0) <> 0 THEN Date12 
    ELSE CASE WHEN ISNULL(Quantity11, 0) <> 0 THEN Date11 
END END END END END END END END END END 
AS EndDate
FROM MT2002 T00 INNER JOIN MT2003 T01 ON T00.PlanID = T01.PlanID 
        INNER JOIN MT2001 T02 ON T02.PlanID = T00.PlanID 
WHERE T00.TranMonth + T00.TranYear*100 between ' + CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)) + ' AND ' + 
        CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)) + ' AND
        T00.PlanID like ''' + @PlanID + ''' AND
        T02.DepartmentID between ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + '''
UNION
SELECT T00.DivisionID, T00.PlanID, InventoryID, LinkNo, CASE WHEN ISNULL(Quantity10, 0) <> 0 THEN Date10 
    ELSE CASE WHEN ISNULL(Quantity09, 0) <> 0 THEN Date09 
    ELSE CASE WHEN ISNULL(Quantity08, 0) <> 0 THEN Date08 
    ELSE CASE WHEN ISNULL(Quantity07, 0) <> 0 THEN Date07 
    ELSE CASE WHEN ISNULL(Quantity06, 0) <> 0 THEN Date06 
    ELSE CASE WHEN ISNULL(Quantity05, 0) <> 0 THEN Date05 
    ELSE CASE WHEN ISNULL(Quantity04, 0) <> 0 THEN Date04 
    ELSE CASE WHEN ISNULL(Quantity03, 0) <> 0 THEN Date03 
    ELSE CASE WHEN ISNULL(Quantity02, 0) <> 0 THEN Date02 
    ELSE CASE WHEN ISNULL(Quantity01, 0) <> 0 THEN Date01 
END END END END END END END END END END 
AS EndDate
FROM MT2002 T00 INNER JOIN MT2003 T01 ON T00.PlanID = T01.PlanID 
        INNER JOIN MT2001 T02 ON T02.PlanID = T00.PlanID 
WHERE T00.TranMonth + T00.TranYear*100 between ' + CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)) + ' AND ' + 
        CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)) + ' AND
        T00.PlanID like ''' + @PlanID + ''' AND
        T02.DepartmentID between ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''''

IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV6016')
    DROP VIEW MV6016
EXEC('CREATE VIEW MV6016 ---tao boi MP6006        
 AS ' + @sSQL)

SET @sSQL = 'SELECT T00.PlanID, T01.VoucherNo, T00.DivisionID, T00.BeginDate, T06.SOrderID, T06.ObjectID, T07.ObjectName, 
        T06.VoucherNo AS OrderNo, T06.OrderDate, 
        T01.DepartmentID, T00.Notes, 
        T00.LinkNo, T00.InventoryID, InventoryName, UnitName, 
        SUM(PlanQuantity) AS PlanQuantity, SUM(ISNULL(ActualQuantity, 0)) AS ActualQuantity, Max(T08.VoucherDate) AS ActualDate, 
        Max(V00.EndDate) AS EndDate
    FROM MT2002 T00 INNER JOIN MT2001 T01 ON T00.PlanID = T01.PlanID
        INNER JOIN AT1302 T02 ON T02.InventoryID = T00.InventoryID 
        INNER JOIN AT1304 T03 ON T03.UnitID = T02.UnitID 
        LEFT JOIN AT1102  T04 ON T04.DepartmentID = T01.DepartmentID
        LEFT JOIN MT2005 T05 ON T05.PlanID = T00.PlanID AND T05.InventoryID = T00.InventoryID AND T05.LinkNo = T00.LinkNo
        left  join MT2004 T08 ON T08.VoucherID = T05.VoucherID 
        left  join OT2001 T06 ON T06.SOrderID = T01.SOderID 
        LEFT JOIN AT1202 T07 ON T07.ObjectID = T06.ObjectID      
        LEFT JOIN (SELECT PlanID, InventoryID, LinkNo, Max(ISNULL(EndDate, '''')) AS EndDate
            FROM MV6016 
            GROUP BY PlanID, InventoryID, LinkNo) V00 
            ON V00.PlanID = T00.PlanID AND V00.InventoryID = T00.InventoryID AND V00.LinkNo = T00.LinkNo
    WHERE T01.TranMonth + T01.TranYear*100 between ' + CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)) + ' AND ' + 
        CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)) + ' AND
        T00.PlanID like ''' + @PlanID + ''' AND T01.DepartmentID  between ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + '''    
    GROUP BY T00.PlanID, T01.VoucherNo, T00.DivisionID, T00.BeginDate, T06.SOrderID, T06.ObjectID, T06.VoucherNo, T06.OrderDate, 
         T07.ObjectName, T01.DepartmentID, T00.Notes, 
        T00.LinkNo, T00.InventoryID, InventoryName, UnitName'

IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV6006')
    DROP VIEW MV6006
EXEC('CREATE VIEW MV6006 ---tao boi MP6006        
 AS ' + @sSQL)