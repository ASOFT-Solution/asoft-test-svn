
/****** Object:  StoredProcedure [dbo].[MP6021]    Script Date: 12/16/2010 13:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 12/06/2005
---purpose: IN bao cao QLSX > Chi tiet tinh hinh san xuat > Dang 1 : Ket qua san xuat den thoi diem hien tai 
--- Modified on 06/10/2015 by Tieu Mai: bổ sung MPT, tham số DHSX, BeginDateKHSX, EndDateKHSX
/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP6021]  
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
    @sSQL1 NVARCHAR(MAX),
    @sSQL2 NVARCHAR(MAX),
    @sSQL3 NVARCHAR(MAX),
    @sWHERE NVARCHAR(max),  
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

SELECT @sWHERE = '', @sSQL = ''

SET @sWHERE = ' AND '+ CASE WHEN @IsDate = 1 THEN ' convert(NVARCHAR(50), MT2001.VoucherDate, 101) BETWEEN ''' + @FromDateText + ''' AND ''' + 
        @ToDateText + '''' 
        ELSE ' MT2001.TranMonth + MT2001.TranYear*100 BETWEEN ' + @FromMonthYearText + ' AND ' + 
        @ToMonthYearText END 


EXEC MP6020 @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate, @IsDate, 
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
    0 AS IsNotPlan,
    OT2002.nvarchar01,		OT2002.nvarchar02,
	OT2002.nvarchar03,		OT2002.nvarchar04,
	OT2002.nvarchar05,		OT2002.nvarchar06,
	OT2002.nvarchar07,		OT2002.nvarchar08,
	OT2002.nvarchar09,		OT2002.nvarchar10,
	OT2002.Ana01ID,			OT2002.Ana02ID,
	OT2002.Ana03ID,			OT2002.Ana04ID,
	OT2002.Ana05ID,			OT2002.Ana06ID,
	OT2002.Ana07ID,			OT2002.Ana08ID,
	OT2002.Ana09ID,			OT2002.Ana10ID,
	A01.AnaName AS Ana01Name,	A02.AnaName AS Ana02Name,
	A03.AnaName AS Ana03Name,	A04.AnaName AS Ana04Name,
	A05.AnaName AS Ana05Name,	A06.AnaName AS Ana06Name,
	A07.AnaName AS Ana07Name,	A08.AnaName AS Ana08Name,
	A09.AnaName AS Ana09Name,	A10.AnaName AS Ana10Name,
	MT0810.BeginDateKHSX,
	MT0811.EndDateKHSX
FROM MT2002 INNER JOIN MT2001 ON MT2002.PlanID = MT2001.PlanID  AND MT2002.DivisionID = MT2001.DivisionID
    LEFT JOIN AT1302 ON AT1302.InventoryID = MT2002.InventoryID AND  AT1302.DivisionID = MT2002.DivisionID
    LEFT JOIN AT1304 ON AT1304.UnitID = MT2002.UnitID AND AT1304.DivisionID = MT2002.DivisionID
    LEFT JOIN AT1102 ON AT1102.DepartmentID = MT2002.DepartmentID AND AT1102.DivisionID = MT2002.DivisionID
    LEFT JOIN MT1702 ON MT1702.LevelID = MT2002.LevelID AND MT1702.WorkID = MT2002.WorkID AND MT1702.DivisionID = MT2002.DivisionID
    LEFT JOIN (SELECT PlanID, PlanDetailID, max(EndDate) AS EndDate FROM  MT6007 GROUP BY PlanID, PlanDetailID) MT6007 ON
        MT6007.PlanID = MT2002.PlanID AND MT6007.PlanDetailID = MT2002.PlanDetailID
    LEFT JOIN (SELECT max(MT2004.VoucherDate) AS ActualDate, 
        MT2005.PlanID, 
        MT2005.InventoryID, 
        ISNULL(MT2005.LinkNo, '''') AS LinkNo, 
        MT2005.WorkID, 
        MT2005.LevelID, 
        SUM(ISNULL(ActualQuantity, 0)) AS ActualQuantity        
    FROM MT2005 INNER JOIN MT2004 ON MT2004.VoucherID = MT2005.VoucherID 
    WHERE ISNULL(MT2005.PlanID, '''') <> '''' AND MT2005.DivisionID like ''' + @DivisionID + '''   
    GROUP BY MT2005.PlanID, 
        MT2005.InventoryID, 
        ISNULL(MT2005.LinkNo, ''''), 
        MT2005.WorkID, 
        MT2005.LevelID) MT2005 ON MT2005.PlanID = MT2002.PlanID AND 
        ISNULL(MT2005.LinkNo, '''') = ISNULL(MT2002.LinkNo, '''') AND 
        ISNULL(MT2005.WorkID, '''') = ISNULL(MT2002.WorkID, '''') AND 
        ISNULL(MT2005.LevelID, '''') = ISNULL(MT2002.LevelID, '''') AND
        MT2005.InventoryID = MT2002.InventoryID '
SET @sSQL1 = '
    LEFT JOIN (SELECT O02.* FROM OT2002 O02 LEFT JOIN OT2001 O01 ON O01.DivisionID = O02.DivisionID AND O01.SOrderID = O02.SOrderID 
               WHERE O02.DivisionID = ''' + @DivisionID + ''' AND O01.OrderType = 1 )  OT2002 ON OT2002.DivisionID = AT1102.DivisionID AND OT2002.SOrderID = MT2001.SOderID  AND MT2002.InventoryID = MT2002.InventoryID
    LEFT JOIN  AT1011 A01  ON  A01.DivisionID = OT2002.DivisionID AND A01.AnaID = OT2002.Ana01ID AND A01.AnaTypeID = ''A01'' 
    LEFT JOIN  AT1011 A02  ON  A02.DivisionID = OT2002.DivisionID AND A02.AnaID = OT2002.Ana02ID AND A01.AnaTypeID = ''A02''  
    LEFT JOIN  AT1011 A03  ON  A03.DivisionID = OT2002.DivisionID AND A03.AnaID = OT2002.Ana03ID AND A01.AnaTypeID = ''A03''  
    LEFT JOIN  AT1011 A04  ON  A04.DivisionID = OT2002.DivisionID AND A04.AnaID = OT2002.Ana04ID AND A01.AnaTypeID = ''A04''
    LEFT JOIN  AT1011 A05  ON  A05.DivisionID = OT2002.DivisionID AND A05.AnaID = OT2002.Ana05ID AND A01.AnaTypeID = ''A05''
    LEFT JOIN  AT1011 A06  ON  A06.DivisionID = OT2002.DivisionID AND A06.AnaID = OT2002.Ana06ID AND A01.AnaTypeID = ''A06''  
    LEFT JOIN  AT1011 A07  ON  A07.DivisionID = OT2002.DivisionID AND A07.AnaID = OT2002.Ana07ID AND A01.AnaTypeID = ''A07''  
    LEFT JOIN  AT1011 A08  ON  A08.DivisionID = OT2002.DivisionID AND A08.AnaID = OT2002.Ana08ID AND A01.AnaTypeID = ''A08''  
    LEFT JOIN  AT1011 A09  ON  A09.DivisionID = OT2002.DivisionID AND A09.AnaID = OT2002.Ana09ID AND A01.AnaTypeID = ''A09''  
    LEFT JOIN  AT1011 A10  ON  A10.DivisionID = OT2002.DivisionID AND A10.AnaID = OT2002.Ana10ID AND A01.AnaTypeID = ''A10''
    LEFT JOIN  (SELECT MIN(VoucherDate) AS BeginDateKHSX, MT0810.DivisionID, SOrderID
	            FROM MT0810 WHERE MT0810.DivisionID = ''' + @DivisionID + '''
	            GROUP BY MT0810.DivisionID, SOrderID) MT0810 ON MT0810.DivisionID = OT2002.DivisionID AND MT0810.SOrderID = OT2002.SOrderID
	LEFT JOIN  (SELECT MAX(VoucherDate) AS EndDateKHSX, MT0810.DivisionID, SOrderID
	            FROM MT0810 WHERE MT0810.DivisionID = ''' + @DivisionID + '''
	            GROUP BY MT0810.DivisionID, SOrderID) MT0811 ON MT0810.DivisionID = OT2002.DivisionID AND MT0810.SOrderID = OT2002.SOrderID           
WHERE MT2001.DivisionID like ''' + @DivisionID + ''' AND 
    ISNULL(MT2001.PlanID, '''') like ''' + ISNULL(@PlanID, '%') + ''' AND
    ISNULL(MT2002.LinkNo, '''') like ''' + ISNULL(@LinkNo, '%') + ''' AND 
    ISNULL(MT2001.SOderID, '''') like ''' + ISNULL(@OrderID, '%') + ''' AND 
    MT2002.InventoryID like ''' + ISNULL(@InventoryID, '%') + '''' +  @sWHERE

SET @sSQL2 = '
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
    0 AS Finish, 
    0 AS PlanQuantity, 
    MT2005.ActualQuantity, 
    MT2005.DepartmentID, 
    AT1102.DepartmentName, 
    MT2005.Description, 
    MT2001.SOderID AS MOrderID, 
    1 AS IsNotPlan,
    OT2002.nvarchar01,		OT2002.nvarchar02,
	OT2002.nvarchar03,		OT2002.nvarchar04,
	OT2002.nvarchar05,		OT2002.nvarchar06,
	OT2002.nvarchar07,		OT2002.nvarchar08,
	OT2002.nvarchar09,		OT2002.nvarchar10,
	OT2002.Ana01ID,			OT2002.Ana02ID,
	OT2002.Ana03ID,			OT2002.Ana04ID,
	OT2002.Ana05ID,			OT2002.Ana06ID,
	OT2002.Ana07ID,			OT2002.Ana08ID,
	OT2002.Ana09ID,			OT2002.Ana10ID,
	A01.AnaName AS Ana01Name,	A02.AnaName AS Ana02Name,
	A03.AnaName AS Ana03Name,	A04.AnaName AS Ana04Name,
	A05.AnaName AS Ana05Name,	A06.AnaName AS Ana06Name,
	A07.AnaName AS Ana07Name,	A08.AnaName AS Ana08Name,
	A09.AnaName AS Ana09Name,	A10.AnaName AS Ana10Name,
	'''' AS BeginDateKHSX,
	'''' AS EnddateKHSX'
SET @sSQL3 = '
FROM MT2005 INNER JOIN MT2004 ON MT2004.VoucherID = MT2005.VoucherID AND MT2004.DivisionID = MT2005.DivisionID
    LEFT JOIN AT1304 ON AT1304.UnitID = MT2005.UnitID AND AT1304.DivisionID = MT2005.DivisionID
    LEFT JOIN AT1102 ON AT1102.DepartmentID = MT2005.DepartmentID AND
        AT1102.DivisionID = MT2005.DivisionID 
    LEFT JOIN AT1302 ON AT1302.InventoryID = MT2005.InventoryID AND AT1302.DivisionID = MT2005.DivisionID
    LEFT JOIN MT1702 ON MT1702.LevelID = MT2005.LevelID AND MT1702.DivisionID = MT2005.DivisionID AND
        MT1702.WorkID = MT2005.WorkID  
    INNER JOIN MT2001 ON MT2005.PlanID = MT2001.PlanID AND MT2005.DivisionID = MT2001.DivisionID ' + @sWHERE + '
    LEFT JOIN (SELECT O02.* FROM OT2002 O02 LEFT JOIN OT2001 O01 ON O01.DivisionID = O02.DivisionID AND O01.SOrderID = O02.SOrderID 
               WHERE O02.DivisionID = ''' + @DivisionID + ''' AND O01.OrderType = 1 )  OT2002 ON OT2002.DivisionID = MT2001.DivisionID AND OT2002.SOrderID = MT2001.SOderID  AND MT2005.InventoryID = OT2002.InventoryID
    LEFT JOIN  AT1011 A01  ON  A01.DivisionID = OT2002.DivisionID AND A01.AnaID = OT2002.Ana01ID AND A01.AnaTypeID = ''A01''  
    LEFT JOIN  AT1011 A02  ON  A02.DivisionID = OT2002.DivisionID AND A02.AnaID = OT2002.Ana02ID AND A01.AnaTypeID = ''A02'' 
    LEFT JOIN  AT1011 A03  ON  A03.DivisionID = OT2002.DivisionID AND A03.AnaID = OT2002.Ana03ID AND A01.AnaTypeID = ''A03''  
    LEFT JOIN  AT1011 A04  ON  A04.DivisionID = OT2002.DivisionID AND A04.AnaID = OT2002.Ana04ID AND A01.AnaTypeID = ''A04'' 
    LEFT JOIN  AT1011 A05  ON  A05.DivisionID = OT2002.DivisionID AND A05.AnaID = OT2002.Ana05ID AND A01.AnaTypeID = ''A05''  
    LEFT JOIN  AT1011 A06  ON  A06.DivisionID = OT2002.DivisionID AND A06.AnaID = OT2002.Ana06ID AND A01.AnaTypeID = ''A06''  
    LEFT JOIN  AT1011 A07  ON  A07.DivisionID = OT2002.DivisionID AND A07.AnaID = OT2002.Ana07ID AND A01.AnaTypeID = ''A07''  
    LEFT JOIN  AT1011 A08  ON  A08.DivisionID = OT2002.DivisionID AND A08.AnaID = OT2002.Ana08ID AND A01.AnaTypeID = ''A08''  
    LEFT JOIN  AT1011 A09  ON  A09.DivisionID = OT2002.DivisionID AND A09.AnaID = OT2002.Ana09ID AND A01.AnaTypeID = ''A09''  
    LEFT JOIN  AT1011 A10  ON  A10.DivisionID = OT2002.DivisionID AND A10.AnaID = OT2002.Ana10ID AND A01.AnaTypeID = ''A10'' 
    LEFT JOIN (SELECT MIN(VoucherDate) AS VoucherDate,MT2004.DivisionID, PLanID FROM MT2004 LEFT JOIN MT2005 ON MT2005.DivisionID = MT2004.DivisionID AND MT2005.VoucherID = MT2004.VoucherID 
               WHERE MT2004.DivisionID = ''' + @DivisionID + '''
               GROUP BY MT2004.DivisionID, PLanID) M04 ON M04.DivisionID = MT2005.DivisionID AND M04.PLanID = MT2005.PLanID
WHERE MT2004.DivisionID like ''' + @DivisionID + ''' AND 
    MT2005.PlanID like ''' +  ISNULL(@PlanID, '%') + ''' AND 
    ISNULL(MT2005.LinkNo, '''') like ''' + ISNULL(@LinkNo, '%') + ''' AND 
    ISNULL(MT2005.InventoryID, '''') like ''' + ISNULL(@InventoryID, '%') + ''' AND 
    ISNULL(MT2001.SOderID, '''') like ''' + ISNULL(@OrderID, '%') + ''''


IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV6021')
    DROP VIEW MV6021

EXEC('CREATE VIEW MV6021 --tao boi MP6021
 AS ' + @sSQL + @sSQL1 + @sSQL2 + @sSQL3)
 --PRINT @sSQL3

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO