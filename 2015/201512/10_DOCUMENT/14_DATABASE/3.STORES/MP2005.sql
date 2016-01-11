/****** Object: StoredProcedure [dbo].[MP2005] Script Date: 08/02/2010 09:33:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 09/11/2004
---purpose: In Phieu san xuat
--Edit by : Nguyen Quoc Huy
---- Modified by Tieu Mai on 04/12/2015: Bo sung 20 cot quy cach khi có thiet lap quan ly mat hang theo quy cach.
---- Modified by Tieu Mai on 04/01/2016: Bo sung truong BatchNo cua table MT0107 (phieu pha tron)
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP2005] 
    @DivisionID NVARCHAR(50), 
    @VoucherID NVARCHAR(50)
AS

DECLARE @sSQL NVARCHAR(4000),
		@sSQL1 NVARCHAR(MAX),
		@sSQL2 NVARCHAR(MAX)
SET @sSQL2 = ''
IF EXISTS (SELECT top 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	Set @sSQL = '
SELECT 
    MT2004.VoucherNo, 
    MT2004.VoucherDate, 
    MT2005.DepartmentID, 
    MT2005.DivisionID, 
    ISNULL(DepartmentName, '''') AS DepartmentName, 
    MT2004.KCSEmployeeID, 
    ISNULL(AT1103_KCS.FullName, '''') AS KCSFullName, 
    MT2004.EmployeeID, 
    ISNULL(AT1103.FullName, '''') AS FullName, 
    MT2005.InventoryID, 
    AT1302.InventoryName, 
    ISNULL(UnitName, '''') AS UnitName, 
    MT2005.ActualQuantity, 
    MT2005.LinkNo, 
    MT2005.PlanID AS PlanNo, 
    MT2005.Description AS Notes, 
    MT2004.Description, 
    MT2005.WorkID, 
    MT1701.WorkName, 
    MT2005.LevelID, 
    MT1702.LevelName, 
    MT2005.Finish, 
    MT2005.Orders, 
    AT1302_P.InventoryName AS ProductName,
    MT2005.Ana01ID, MT2005.Ana02ID, MT2005.Ana03ID, MT2005.Ana04ID, MT2005.Ana05ID, 
			OT1002_1.AnaName AS AnaName1,
			OT1002_2.AnaName AS AnaName2,
			OT1002_3.AnaName AS AnaName3,
			OT1002_4.AnaName AS AnaName4,
			OT1002_5.AnaName AS AnaName5,
    M89.S01ID, M89.S02ID, M89.S03ID, M89.S04ID, M89.S05ID, M89.S06ID, M89.S07ID, M89.S08ID, M89.S09ID, M89.S10ID,
	M89.S11ID, M89.S12ID, M89.S13ID, M89.S14ID, M89.S15ID, M89.S16ID, M89.S17ID, M89.S18ID, M89.S19ID, M89.S20ID,
	B01.StandardName as StandardName01, B02.StandardName as StandardName02, B03.StandardName as StandardName03, B04.StandardName as StandardName04,
	B05.StandardName as StandardName05, B06.StandardName as StandardName06, B07.StandardName as StandardName07, B08.StandardName as StandardName08,
	B09.StandardName as StandardName09, B10.StandardName as StandardName10 , B11.StandardName as StandardName11, B12.StandardName as StandardName12,
	B13.StandardName as StandardName13, B14.StandardName as StandardName14, B15.StandardName as StandardName15, B16.StandardName as StandardName16,
	B17.StandardName as StandardName17, B18.StandardName as StandardName18, B19.StandardName as StandardName19, B20.StandardName as StandardName20,
	MT0107.BatchNo '

	SET @sSQL1 ='
	FROM MT2005 
    INNER JOIN MT2004  ON MT2004.DivisionID = MT2005.DivisionID     AND MT2005.VoucherID = MT2004.VoucherID
    LEFT JOIN AT1302  ON AT1302.DivisionID = MT2005.DivisionID     AND AT1302.InventoryID =MT2005.InventoryID
    LEFT JOIN AT1304  ON AT1304.DivisionID = MT2005.DivisionID     AND AT1304.UnitID = AT1302.UnitID 
    LEFT JOIN AT1102  ON AT1102.DivisionID = MT2005.DivisionID     AND AT1102.DepartmentID = MT2005.DepartmentID 
    LEFT JOIN AT1103 AT1103_KCS ON AT1103_KCS.DivisionID = MT2005.DivisionID AND AT1103_KCS.EmployeeID = MT2004.KCSEmployeeID
    LEFT JOIN AT1103  ON AT1103.DivisionID = MT2005.DivisionID     AND AT1103.EmployeeID = MT2004.EmployeeID
    LEFT JOIN MT1701  ON MT1701.DivisionID = MT2005.DivisionID     AND MT1701.WorkID = MT2005.WorkID 
    LEFT JOIN MT1702  ON MT1702.DivisionID = MT2005.DivisionID     AND MT1702.WorkID = MT2005.WorkID AND MT1702.LevelID = MT2005.LevelID
    LEFT JOIN MT2001  ON MT2001.DivisionID = MT2005.DivisionID     AND MT2001.PlanID = MT2005.PlanID
	LEFT JOIN MT0107 ON MT0107.DivisionID = MT2001.DivisionID AND MT0107.VoucherID = MT2001.MixVoucherID AND MT0107.ProductID = MT2001.ProductID 
    --LEFT JOIN OT2002   ON OT2002.DivisionID = MT2005.DivisionID     AND OT2002.LinkNo = MT2005.LinkNo AND OT2002.SOrderID = MT2001.SOderID
    LEFT JOIN AT1302 AT1302_P   ON AT1302_P.DivisionID = MT2005.DivisionID   AND AT1302_P.InventoryID = MT2005.InventoryID
    LEFT JOIN AT1011 OT1002_1 ON OT1002_1.AnaID = MT2005.Ana01ID AND  OT1002_1.AnaTypeID = ''A01''  AND OT1002_1.DivisionID = MT2005.DivisionID
	LEFT JOIN AT1011 OT1002_2 ON OT1002_2.AnaID = MT2005.Ana02ID AND  OT1002_2.AnaTypeID = ''A02''  AND OT1002_2.DivisionID = MT2005.DivisionID
	LEFT JOIN AT1011 OT1002_3 ON OT1002_3.AnaID = MT2005.Ana03ID AND  OT1002_3.AnaTypeID = ''A03''  AND OT1002_3.DivisionID = MT2005.DivisionID
	LEFT JOIN AT1011 OT1002_4 ON OT1002_4.AnaID = MT2005.Ana04ID AND  OT1002_4.AnaTypeID = ''A04''  AND OT1002_4.DivisionID = MT2005.DivisionID
	LEFT JOIN AT1011 OT1002_5 ON OT1002_5.AnaID = MT2005.Ana05ID AND  OT1002_5.AnaTypeID = ''A05''  AND OT1002_5.DivisionID = MT2005.DivisionID '
    
    SET @sSQL2 = '
    LEFT JOIN MT8899 M89 ON M89.DivisionID = MT2005.DivisionID AND M89.VoucherID = MT2005.VoucherID and M89.TransactionID = MT2005.TransactionID and M89.TableID = ''MT2005''
    left join AT0128 B01 ON B01.StandardTypeID = ''S01'' and B01.StandardID = M89.S01ID  and B01.DivisionID= M89.DivisionID
	left join AT0128 B02 ON B02.StandardTypeID = ''S02'' and B02.StandardID = M89.S02ID  and B02.DivisionID= M89.DivisionID
	left join AT0128 B03 ON B03.StandardTypeID = ''S03'' and B03.StandardID = M89.S03ID  and B03.DivisionID= M89.DivisionID
	left join AT0128 B04 ON B04.StandardTypeID = ''S04'' and B04.StandardID = M89.S04ID  and B04.DivisionID= M89.DivisionID
	left join AT0128 B05 ON B05.StandardTypeID = ''S05'' and B05.StandardID = M89.S05ID  and B05.DivisionID= M89.DivisionID
	left join AT0128 B06 ON B06.StandardTypeID = ''S06'' and B06.StandardID = M89.S06ID  and B06.DivisionID= M89.DivisionID
	left join AT0128 B07 ON B07.StandardTypeID = ''S07'' and B07.StandardID = M89.S07ID  and B07.DivisionID= M89.DivisionID
	left join AT0128 B08 ON B08.StandardTypeID = ''S08'' and B08.StandardID = M89.S08ID  and B08.DivisionID= M89.DivisionID
	left join AT0128 B09 ON B09.StandardTypeID = ''S09'' and B09.StandardID = M89.S09ID  and B09.DivisionID= M89.DivisionID
	left join AT0128 B10 ON B10.StandardTypeID = ''S10'' and B10.StandardID = M89.S10ID  and B10.DivisionID= M89.DivisionID
	left join AT0128 B11 ON B11.StandardTypeID = ''S11'' and B11.StandardID = M89.S11ID  and B11.DivisionID= M89.DivisionID
	left join AT0128 B12 ON B12.StandardTypeID = ''S12'' and B12.StandardID = M89.S12ID  and B12.DivisionID= M89.DivisionID
	left join AT0128 B13 ON B13.StandardTypeID = ''S13'' and B13.StandardID = M89.S13ID  and B13.DivisionID= M89.DivisionID
	left join AT0128 B14 ON B14.StandardTypeID = ''S14'' and B14.StandardID = M89.S14ID  and B14.DivisionID= M89.DivisionID
	left join AT0128 B15 ON B15.StandardTypeID = ''S15'' and B15.StandardID = M89.S15ID  and B15.DivisionID= M89.DivisionID
	left join AT0128 B16 ON B16.StandardTypeID = ''S16'' and B16.StandardID = M89.S16ID  and B16.DivisionID= M89.DivisionID
	left join AT0128 B17 ON B17.StandardTypeID = ''S17'' and B17.StandardID = M89.S17ID  and B17.DivisionID= M89.DivisionID
	left join AT0128 B18 ON B18.StandardTypeID = ''S18'' and B18.StandardID = M89.S18ID  and B18.DivisionID= M89.DivisionID
	left join AT0128 B19 ON B19.StandardTypeID = ''S19'' and B19.StandardID = M89.S19ID  and B19.DivisionID= M89.DivisionID
	left join AT0128 B20 ON B20.StandardTypeID = ''S20'' and B20.StandardID = M89.S20ID  and B20.DivisionID= M89.DivisionID
WHERE MT2004.DivisionID = ''' + @DivisionID + ''' 
    AND MT2004.VoucherID = ''' + @VoucherID + ''''

END
ELSE
	BEGIN
		Set @sSQL = '
		SELECT 
			MT2004.VoucherNo, 
			MT2004.VoucherDate, 
			MT2005.DepartmentID, 
			MT2005.DivisionID, 
			ISNULL(DepartmentName, '''') AS DepartmentName, 
			MT2004.KCSEmployeeID, 
			ISNULL(AT1103_KCS.FullName, '''') AS KCSFullName, 
			MT2004.EmployeeID, 
			ISNULL(AT1103.FullName, '''') AS FullName, 
			MT2005.InventoryID, 
			AT1302.InventoryName, 
			ISNULL(UnitName, '''') AS UnitName, 
			MT2005.ActualQuantity, 
			MT2005.LinkNo, 
			MT2005.PlanID AS PlanNo, 
			MT2005.Description AS Notes, 
			MT2004.Description, 
			MT2005.WorkID, 
			MT1701.WorkName, 
			MT2005.LevelID, 
			MT1702.LevelName, 
			MT2005.Finish, 
			MT2005.Orders, 
			AT1302_P.InventoryName AS ProductName,
			MT2005.Ana01ID, MT2005.Ana02ID, MT2005.Ana03ID, MT2005.Ana04ID, MT2005.Ana05ID, 
			OT1002_1.AnaName AS AnaName1,
			OT1002_2.AnaName AS AnaName2,
			OT1002_3.AnaName AS AnaName3,
			OT1002_4.AnaName AS AnaName4,
			OT1002_5.AnaName AS AnaName5,
			MT0107.BatchNo '
		
		SET @sSQL1 = '	
		FROM MT2005 
			INNER JOIN MT2004           ON MT2004.DivisionID = MT2005.DivisionID     AND MT2005.VoucherID = MT2004.VoucherID
			LEFT JOIN AT1302            ON AT1302.DivisionID = MT2005.DivisionID     AND AT1302.InventoryID =MT2005.InventoryID
			LEFT JOIN AT1304            ON AT1304.DivisionID = MT2005.DivisionID     AND AT1304.UnitID = AT1302.UnitID 
			LEFT JOIN AT1102            ON AT1102.DivisionID = MT2005.DivisionID     AND AT1102.DepartmentID = MT2005.DepartmentID 
			LEFT JOIN AT1103 AT1103_KCS ON AT1103_KCS.DivisionID = MT2005.DivisionID AND AT1103_KCS.EmployeeID = MT2004.KCSEmployeeID
			LEFT JOIN AT1103            ON AT1103.DivisionID = MT2005.DivisionID     AND AT1103.EmployeeID = MT2004.EmployeeID
			LEFT JOIN MT1701            ON MT1701.DivisionID = MT2005.DivisionID     AND MT1701.WorkID = MT2005.WorkID 
			LEFT JOIN MT1702            ON MT1702.DivisionID = MT2005.DivisionID     AND MT1702.WorkID = MT2005.WorkID AND MT1702.LevelID = MT2005.LevelID
			LEFT JOIN MT2001            ON MT2001.DivisionID = MT2005.DivisionID     AND MT2001.PlanID = MT2005.PlanID
			LEFT JOIN MT0107			ON MT0107.DivisionID = MT2001.DivisionID AND MT0107.VoucherID = MT2001.MixVoucherID AND MT0107.ProductID = MT2001.ProductID  
			--LEFT JOIN OT2002            ON OT2002.DivisionID = MT2005.DivisionID     AND OT2002.LinkNo = MT2005.LinkNo AND OT2002.SOrderID = MT2001.SOderID
			LEFT JOIN AT1302 AT1302_P   ON AT1302_P.DivisionID = MT2005.DivisionID   AND AT1302_P.InventoryID = MT2005.InventoryID
			    LEFT JOIN AT1011 OT1002_1 ON OT1002_1.AnaID = MT2005.Ana01ID AND  OT1002_1.AnaTypeID = ''A01''  AND OT1002_1.DivisionID = MT2005.DivisionID
	LEFT JOIN AT1011 OT1002_2 ON OT1002_2.AnaID = MT2005.Ana02ID AND  OT1002_2.AnaTypeID = ''A02''  AND OT1002_2.DivisionID = MT2005.DivisionID
	LEFT JOIN AT1011 OT1002_3 ON OT1002_3.AnaID = MT2005.Ana03ID AND  OT1002_3.AnaTypeID = ''A03''  AND OT1002_3.DivisionID = MT2005.DivisionID
	LEFT JOIN AT1011 OT1002_4 ON OT1002_4.AnaID = MT2005.Ana04ID AND  OT1002_4.AnaTypeID = ''A04''  AND OT1002_4.DivisionID = MT2005.DivisionID
	LEFT JOIN AT1011 OT1002_5 ON OT1002_5.AnaID = MT2005.Ana05ID AND  OT1002_5.AnaTypeID = ''A05''  AND OT1002_5.DivisionID = MT2005.DivisionID
		WHERE MT2004.DivisionID = ''' + @DivisionID + ''' 
			AND MT2004.VoucherID = ''' + @VoucherID + ''''

	END
--PRINT @sSQL
--PRINT @sSQL1
--PRINT @sSQL2
IF EXISTS(SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV2208')
    DROP VIEW MV2208
EXEC('CREATE VIEW MV2208 ---tao boi MP2005 
    AS ' + @sSQL + @sSQL1 + @sSQL2)