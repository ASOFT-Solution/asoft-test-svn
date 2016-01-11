/****** Object: StoredProcedure [dbo].[MP2013] Script Date: 08/02/2010 09:56:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Van Nhan.
---- Purpose : In lenh san xuat
---- Modify by: Lê Thị Hạnh on 19/09/2014: Bổ sung Báo cáo Lệnh sản xuất cho Sài Gòn Petro (Customize Index: 36)
---- Modify by: Lê Thị Hạnh on 19/01/2015: Cập nhật Lệnh sản xuất cho Sài Gòn Petro (Customize Index: 36)
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
---- Modified by Tiểu Mai on 09/09/2015: Bổ sung tên và mã của 10 MPT, 10 tham số ở đơn hàng sản xuất.
---- Modified by Tieu Mai on 04/12/2015: Bo sung 20 cot quy cach khi quan ly mat hang theo quy cach.
'********************************************/
-- <Example>
-- exec MP2013 @DivisionID=N'VG',@PlanID=N'KH/01/15/001'


ALTER PROCEDURE [dbo].[MP2013] 
    @DivisionID AS NVARCHAR(50), 
    @PlanID AS NVARCHAR(50)
AS

DECLARE @CustomerName INT
--Tạo bảng tạm để kiểm tra đây có phải là khách hàng Sài Gòn Petro không (CustomerName = 36)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName) 

DECLARE @sSQL AS NVARCHAR(4000), @sSQL3 AS NVARCHAR(4000), @sSQL4 AS NVARCHAR(4000),@sSQL5 AS NVARCHAR(4000)
SET @sSQL4 = ''
SET @sSQL5 = ''
SET @sSQL = '
SELECT 
    MT2001.PlanID, 
    MT2001.VoucherNo, 
    MT2002.DepartmentID, 
    DepartmentName,
    MT2001.VoucherDate, 
    MT2002.InventoryID, 
    A02.InventoryName,
    A02.UnitID,
    MT2002.PlanQuantity,
    MT2001.SOderID,
    MT2002.LinkNo, 
    MT2002.Notes, 
    MT2002.RefInfor, 
    MT2002.DivisionID,
    MT2002.Finish,
    MT2002.WorkID, 
    MT2002.LevelID, 
    MT1702.LevelName,
    MT2002.Quantity01, MT2002.Quantity02, MT2002.Quantity03, MT2002.Quantity04, MT2002.Quantity05, MT2002.Quantity06, MT2002.Quantity07, MT2002.Quantity08, MT2002.Quantity09, MT2002.Quantity10,
    MT2002.Quantity11, MT2002.Quantity12, MT2002.Quantity13, MT2002.Quantity14, MT2002.Quantity15, MT2002.Quantity16, MT2002.Quantity17, MT2002.Quantity18, MT2002.Quantity19, MT2002.Quantity20,
    MT2002.Quantity21, MT2002.Quantity22, MT2002.Quantity23, MT2002.Quantity24, MT2002.Quantity25, MT2002.Quantity26, MT2002.Quantity27, MT2002.Quantity28, MT2002.Quantity29, MT2002.Quantity30,
    MT2002.Quantity31, MT2002.Quantity32, MT2002.Quantity33, MT2002.Quantity34, MT2002.Quantity35, MT2002.Quantity36, MT2002.Quantity37, MT2002.Quantity38, MT2002.Quantity39, MT2002.Quantity40,
    Date01, Date02, Date03, Date04, Date05, Date06, Date07, Date08, Date09, Date10, 
    Date11, Date12, Date13, Date14, Date15, Date16, Date17, Date18, Date19, Date20, 
    Date21, Date22, Date23, Date24, Date25, Date26, Date27, Date28, Date29, Date30, 
    Date31, Date32, Date33, Date34, Date35, Date36, Date37, Date38, Date39, Date40,
    C02.InventoryName AS ProductName, MT2002.Orders, A02.Varchar01,
    MT2002.Ana01ID, MT2002.Ana02ID, MT2002.Ana03ID, MT2002.Ana04ID, MT2002.Ana05ID,
    MT2002.Ana06ID, MT2002.Ana07ID, MT2002.Ana08ID, MT2002.Ana09ID, MT2002.Ana10ID,
    A01.AnaName as Ana01Name,
	A00.AnaName as Ana02Name,
	A03.AnaName as Ana03Name,
	A04.AnaName as Ana04Name,
	A05.AnaName as Ana05Name,
	A06.AnaName as Ana06Name,
	A07.AnaName as Ana07Name,
	A08.AnaName as Ana08Name,
	A09.AnaName as Ana09Name,
	A10.AnaName as Ana10Name
'

SET @sSQL3 = '
	FROM MT2002 
		INNER JOIN MT2001     ON MT2001.DivisionID = MT2002.DivisionID AND MT2001.PlanID = MT2002.PlanID
		INNER JOIN AT1302 A02 ON A02.DivisionID    = MT2002.DivisionID AND A02.InventoryID = MT2002.InventoryID
		LEFT JOIN MT2003      ON MT2003.DivisionID = MT2002.DivisionID AND MT2003.PlanID = MT2002.PlanID
		LEFT JOIN AT1102      ON AT1102.DivisionID = MT2002.DivisionID AND AT1102.DepartmentID = MT2002.DepartmentID
		LEFT JOIN OT2002 O02  ON O02.DivisionID    = MT2002.DivisionID AND O02.LinkNo = MT2002.LinkNo AND MT2001.SOderID = O02.SOrderID  AND MT2002.InventoryID = O02.InventoryID
		LEFT JOIN AT1302 C02  ON C02.DivisionID    = MT2002.DivisionID AND C02.InventoryID = O02.InventoryID 
		LEFT JOIN MT1701      ON MT1701.DivisionID = MT2002.DivisionID AND MT1701.WorkID = MT2002.WorkID 
		LEFT JOIN MT1702      ON MT1702.DivisionID = MT2002.DivisionID AND MT1702.WorkID = MT2002.WorkID AND MT1702.LevelID = MT2002.LevelID
		left join AT1011 A01 on A01.AnaTypeID = ''A01'' and A01.AnaID = O02.Ana01ID  and A01.DivisionID= O02.DivisionID
		left join AT1011 A00 on A00.AnaTypeID = ''A02'' and A00.AnaID = O02.Ana02ID  and A00.DivisionID= O02.DivisionID
		left join AT1011 A03 on A03.AnaTypeID = ''A03'' and A03.AnaID = O02.Ana03ID  and A03.DivisionID= O02.DivisionID
		left join AT1011 A04 on A04.AnaTypeID = ''A04'' and A04.AnaID = O02.Ana04ID  and A04.DivisionID= O02.DivisionID
		left join AT1011 A05 on A05.AnaTypeID = ''A05'' and A05.AnaID = O02.Ana05ID  and A05.DivisionID= O02.DivisionID
		left join AT1011 A06 on A06.AnaTypeID = ''A06'' and A06.AnaID = O02.Ana06ID  and A06.DivisionID= O02.DivisionID
		left join AT1011 A07 on A07.AnaTypeID = ''A07'' and A07.AnaID = O02.Ana07ID  and A07.DivisionID= O02.DivisionID
		left join AT1011 A08 on A08.AnaTypeID = ''A08'' and A08.AnaID = O02.Ana08ID  and A08.DivisionID= O02.DivisionID
		left join AT1011 A09 on A09.AnaTypeID = ''A09'' and A09.AnaID = O02.Ana09ID  and A09.DivisionID= O02.DivisionID
		left join AT1011 A10 on A10.AnaTypeID = ''A10'' and A10.AnaID = O02.Ana10ID  and A10.DivisionID= O02.DivisionID
	'
	SET @sSQL5 = 'WHERE MT2002.PlanID = ''' + @PlanID + ''' AND MT2002.DivisionID = ''' + @DivisionID + ''''

	
	IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
	BEGIN
		SET @sSQL = @sSQL + ' ,M89.S01ID, M89.S02ID, M89.S03ID, M89.S04ID, M89.S05ID, M89.S06ID, M89.S07ID, M89.S08ID, M89.S09ID, M89.S10ID,
							M89.S11ID, M89.S12ID, M89.S13ID, M89.S14ID, M89.S15ID, M89.S16ID, M89.S17ID, M89.S18ID, M89.S19ID, M89.S20ID,
							B01.StandardName as StandardName01, B02.StandardName as StandardName02, B03.StandardName as StandardName03, B04.StandardName as StandardName04,
							B05.StandardName as StandardName05, B06.StandardName as StandardName06, B07.StandardName as StandardName07, B08.StandardName as StandardName08,
							B09.StandardName as StandardName09, B10.StandardName as StandardName10 , B11.StandardName as StandardName11, B12.StandardName as StandardName12,
							B13.StandardName as StandardName13, B14.StandardName as StandardName14, B15.StandardName as StandardName15, B16.StandardName as StandardName16,
							B17.StandardName as StandardName17, B18.StandardName as StandardName18, B19.StandardName as StandardName19, B20.StandardName as StandardName20'
		
		SET @sSQL4 = '
    LEFT JOIN MT8899 M89 ON M89.DivisionID = MT2002.DivisionID AND M89.VoucherID = MT2002.PlanID and M89.TransactionID = MT2002.PlanDetailID and M89.TableID = ''MT2002''
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
'
	END




IF EXISTS (SELECT 1 FROM sysObjects WHERE Name = 'MV2013' AND XType = 'V')
    DROP VIEW MV2013
EXEC( 'CREATE VIEW MV2013 ---tao boi MP2013
    AS '+@sSQL+@sSQL3 + @sSQL4 + @sSQL5)

----- Báo cáo Lệnh sản xuất cho Sài Gòn Petro (Customize Index: 36)
IF @CustomerName = 36 
BEGIN
	DECLARE @sSQL1 NVARCHAR(MAX), @sSQL2 NVARCHAR(MAX)
	SET @sSQL1 = '
SELECT MT21.VoucherDate, OT21.VoucherNo MOVoucherNo, MT21.VoucherNo, OT21.ObjectID, AT12.ObjectName,
       MT21.ProductID, AT132.InventoryName AS ProductName, MT03.Date01, MT04.InventoryID, AT02.InventoryName,
       AT02.UnitID, AT04.UnitName, ISNULL(MT04.Quantity,0) AS Quantity, MT21.[Description]
FROM MT2001 MT21
INNER JOIN MT2003 MT03 ON MT03.DivisionID = MT21.DivisionID AND MT03.PlanID = MT21.PlanID
LEFT JOIN MT0164 MT04 ON MT04.DivisionID = MT21.DivisionID AND MT04.PlanID = MT21.PlanID
LEFT JOIN AT1302 AT02 ON AT02.DivisionID = MT04.DivisionID AND AT02.InventoryID = MT04.InventoryID
LEFT JOIN AT1304 AT04 ON AT04.DivisionID = AT02.DivisionID AND AT04.UnitID = AT02.UnitID
LEFT JOIN OT2001 OT21 ON OT21.DivisionID = MT21.DivisionID AND OT21.SOrderID = MT21.SOderID
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT21.DivisionID AND AT12.ObjectID = OT21.ObjectID
LEFT JOIN AT1302 AT132 ON AT132.DivisionID = MT21.DivisionID AND AT132.InventoryID = MT21.ProductID
LEFT JOIN MT0107 MT07 ON MT07.DivisionID = MT21.DivisionID AND MT07.VoucherID = MT21.MixVoucherID
WHERE MT21.DivisionID = '''+@DivisionID+''' AND MT21.PlanID = '''+@PlanID+'''
ORDER BY MT04.InventoryID
	'
	SET @sSQL2 = '
SELECT MT21.PlanID, MT08.TypeID, MT08.MaterialID, AT12.InventoryName AS MaterialName, MT08.Notes01,
	   AT12.UnitID, AT04.UnitName, MT07.BatchNo, 
	   ISNULL(MT08.VolumeTotal,0) AS VolumeTotal, ISNULL(MT08.WeightTotal,0) AS WeightTotal, ISNULL(MT05.Rate01,0) AS Rate01, 
	   CASE WHEN ISNULL(MT05.Rate01,0) = 0 THEN 0.0
	   ELSE SUM(ISNULL(AT27.ActualQuantity,0))/ISNULL(MT05.Rate01,0) END AS StockVolume, 
	   SUM(ISNULL(AT27.ActualQuantity,0)) AS StockWeight  
FROM MT2001 MT21
LEFT JOIN MT0107 MT07 ON MT07.DivisionID = MT21.DivisionID AND MT07.VoucherID = MT21.MixVoucherID
INNER JOIN MT0108 MT08 ON MT08.DivisionID = MT07.DivisionID AND MT08.VoucherID = MT07.VoucherID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT08.DivisionID AND AT12.InventoryID = MT08.MaterialID
LEFT JOIN AT1304 AT04 ON AT04.DivisionID = AT12.DivisionID AND AT04.UnitID = AT12.UnitID
LEFT JOIN AT2007 AT27 ON AT27.DivisionID = MT21.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT21.PlanID AND AT27.InheritTransactionID = MT08.TransactionID
LEFT JOIN MT0105 MT05 ON MT05.DivisionID = MT07.DivisionID AND MT05.FormulaID = MT07.FormulaID AND MT05.MaterialID = MT08.MaterialID
WHERE MT21.DivisionID = '''+@DivisionID+''' AND MT21.PlanID = '''+@PlanID+'''
GROUP BY MT21.PlanID, MT08.TypeID, MT08.MaterialID, AT12.InventoryName, MT08.Notes01, AT12.UnitID, AT04.UnitName,
	     MT07.BatchNo, MT05.Rate01, MT08.VolumeTotal, MT08.WeightTotal
ORDER BY MT08.TypeID, MT08.MaterialID
	'
END
EXEC (@sSQL1)
EXEC (@sSQL2)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON