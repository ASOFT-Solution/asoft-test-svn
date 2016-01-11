IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3012]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3012]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- <Summary>
---- In don hang san xuat
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 07/09/2004 by Vo Thanh Huong
---- 
---- Last Edit Thuy Tuyen, date 03/10/2009
---- Edit Thuy Tuyen, date 20/11/2009  them cac truong ma phan tich nghiep vu.
---- Modified on 10/10/2011 by Le Thi Thu Hien : Bo sung them 1 so truong
---- Modified on 10/10/2011 by Le Thi Thu Hien : Bo sung Phonenumber, ObjectName
---- Modified on 11/11/2011 by Le Thi Thu Hien : Bo sung 20 tham so varchar01->varchar20
---- Modified on 19/11/2011 by Le Thi Thu Hien : Chuoi dai hon 4000 ky tu
---- Modified on 19/11/2011 by Le Thi Thu Hien : Bổ sung Decription
---- Modified on 25/12/2015 by Tieu Mai: Bo sung thong tin quy cach khi co thiet lap quan ly hang theo quy cach
---- Modified by Tiểu Mai on 05/01/2016: Lấy thông tin bộ định mức đính kèm đơn hàng sản xuất
-- <Example> SELECT * FROM OT2002
---- EXEC OP3012 'AS', 'SO/01/2011/0001'
---- SELECT * FROM OV3014

CREATE PROCEDURE [dbo].[OP3012] 	
				@DivisionID AS nvarchar(50),			
				@SOrderID AS nvarchar(50)

AS
DECLARE @sSQL AS nvarchar(4000)
DECLARE @sSQL1 AS nvarchar(4000), @sSQL2 AS NVARCHAR(MAX), @sSQL3 NVARCHAR(MAX)
DECLARE @CustomizeName INT
SET @CustomizeName  = (SELECT CustomerName FROM CustomerIndex)

SET @sSQL2 = ''
SET @sSQL = N'
	SELECT	OT2002.DivisionID, OT2001.SOrderID, OT2002.TransactionID, OT2001.VoucherTypeID, OT2001.VoucherNo, OT2001.OrderDate, 
			OT2001.ObjectID, 
			CASE WHEN ISNULL(OT2001.ObjectName,'''') = ''''  THEN AT1202.ObjectName ELSE OT2001.ObjectName end AS ObjectName,
			CASE WHEN ISNULL(OT2001.Address, '''') = '''' THEN AT1202.Address ELSE OT2001.Address end AS ObjectAddress, 
			OT2001.EmployeeID, AT1103.FullName, AT1103.Address AS EmployeeAddress,
			OT2002.InventoryID, AT1302.InventoryName, AT1302.UnitID, UnitName, 
			OT2002.MethodID, MethodName, OrderQuantity, OT2001.DepartmentID, 
			isnull(AT1102.DepartmentName, '''') AS DepartmentName, LinkNo, OT2002.EndDate, OT2002.Orders 	, OT2002.RefInfor, OT2001.Notes	,
			InheritedQuantity,OT2001.PeriodID, 
			OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID, 
			OT1002_1.AnaName AS AnaName1,
			OT1002_2.AnaName AS AnaName2,
			OT1002_3.AnaName AS AnaName3,
			OT1002_4.AnaName AS AnaName4,
			OT1002_5.AnaName AS AnaName5,
			OT2002.nvarchar01,	OT2002.nvarchar02,	OT2002.nvarchar03,	OT2002.nvarchar04,	OT2002.nvarchar05,	
			OT2002.nvarchar06,	OT2002.nvarchar07,	OT2002.nvarchar08,	OT2002.nvarchar09,	OT2002.nvarchar10,
			OT2001.InheritSOrderID,
			AT1202.Contactor AS ObjectContactor,
			AT1103_2.FullName as SalesManName,
			AT1302.InventoryTypeID,
			AT1202.Phonenumber,
			OT2001.Varchar01,OT2001.Varchar02,OT2001.Varchar03,OT2001.Varchar04,OT2001.Varchar05,
			OT2001.Varchar06,OT2001.Varchar07,OT2001.Varchar08,OT2001.Varchar09,OT2001.Varchar10,
			OT2001.Varchar11,OT2001.Varchar12,OT2001.Varchar13,OT2001.Varchar14,OT2001.Varchar15,
			OT2001.Varchar16,OT2001.Varchar17,OT2001.Varchar18,OT2001.Varchar19,OT2001.Varchar20,
			OT2002.Description'
SET @sSQL1 = N'			
	FROM	OT2002 
	LEFT JOIN AT1302 ON AT1302.InventoryID = OT2002.InventoryID AND AT1302.DivisionID = OT2002.DivisionID
	LEFT JOIN OT1003 ON OT1003.MethodID = OT2002.MethodID  AND OT1003.DivisionID = OT2002.DivisionID
	INNER JOIN OT2001 ON OT2001.SOrderID = OT2002.SOrderID AND OT2001.DivisionID = OT2002.DivisionID
	LEFT JOIN OT2001 Inherit_OT2001 ON Inherit_OT2001.InheritSOrderID = OT2002.SOrderID AND Inherit_OT2001.DivisionID = OT2002.DivisionID	
	LEFT JOIN AT1303 ON AT1303.WareHouseID = OT2002.WareHouseID AND AT1303.DivisionID = OT2001.DivisionID 
	LEFT JOIN AT1102 ON AT1102.DepartmentID = OT2001.DepartmentID  AND AT1102.DivisionID = OT2001.DivisionID
	LEFT JOIN AT1301 ON AT1301.InventoryTypeID = OT2001.InventoryTypeID AND AT1301.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1103 ON AT1103.EmployeeID = OT2001.EmployeeID AND AT1103.DivisionID = OT2001.DivisionID 
	LEFT JOIN AT1103 AT1103_2 on AT1103_2.EmployeeID = OT2001.SalesManID AND AT1103_2.DivisionID = OT2001.DivisionID
	LEFT JOIN AT1202 ON AT1202.ObjectID = OT2001.ObjectID AND AT1202.DivisionID = OT2002.DivisionID
	LEFT JOIN (	SELECT  DivisionID, TransactionID, SOrderID, 
						SUM(ISNULL(InheritedQuantity,0)) AS InheritedQuantity  
				FROM	MQ2221
				GROUP BY DivisionID, TransactionID,SOrderID)  AS G 
			ON G.TransactionID = OT2002.TransactionID AND G.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011 OT1002_1 ON OT1002_1.AnaID = OT2002.Ana01ID AND  OT1002_1.AnaTypeID = ''A01''  AND OT1002_1.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011 OT1002_2 ON OT1002_2.AnaID = OT2002.Ana02ID AND  OT1002_2.AnaTypeID = ''A02''  AND OT1002_2.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011 OT1002_3 ON OT1002_3.AnaID = OT2002.Ana03ID AND  OT1002_3.AnaTypeID = ''A03''  AND OT1002_3.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011 OT1002_4 ON OT1002_4.AnaID = OT2002.Ana04ID AND  OT1002_4.AnaTypeID = ''A04''  AND OT1002_4.DivisionID = OT2002.DivisionID
	LEFT JOIN AT1011 OT1002_5 ON OT1002_5.AnaID = OT2002.Ana05ID AND  OT1002_5.AnaTypeID = ''A05''  AND OT1002_5.DivisionID = OT2002.DivisionID
	'
	
IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN 
	SET @sSQL = @sSQL + ',
			O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID, 
			O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
			A01.StandardName AS S01Name, A02.StandardName AS S02Name, A03.StandardName AS S03Name, A04.StandardName AS S04Name, A05.StandardName AS S05Name,
			A06.StandardName AS S06Name, A07.StandardName AS S07Name, A08.StandardName AS S08Name, A09.StandardName AS S09Name, A10.StandardName AS S10Name,
			A11.StandardName AS S11Name, A12.StandardName AS S12Name, A13.StandardName AS S13Name, A14.StandardName AS S14Name, A15.StandardName AS S15Name,
			A16.StandardName AS S16Name, A17.StandardName AS S17Name, A18.StandardName AS SName18, A19.StandardName AS S19Name, A20.StandardName AS S20Name'
	SET @sSQL2 = '
			LEFT JOIN OT8899 O99 ON O99.DivisionID = OT2002.DivisionID AND O99.VoucherID = OT2002.SOrderID AND O99.TransactionID  = OT2002.TransactionID and O99.TableID  = ''OT2002''
			LEFT JOIN AT0128 A01 ON A01.DivisionID = O99.DivisionID AND A01.StandardID = O99.S01ID AND A01.StandardTypeID = ''S01''
			LEFT JOIN AT0128 A02 ON A02.DivisionID = O99.DivisionID AND A02.StandardID = O99.S02ID AND A02.StandardTypeID = ''S02''
			LEFT JOIN AT0128 A03 ON A03.DivisionID = O99.DivisionID AND A03.StandardID = O99.S03ID AND A03.StandardTypeID = ''S03''
			LEFT JOIN AT0128 A04 ON A04.DivisionID = O99.DivisionID AND A04.StandardID = O99.S04ID AND A04.StandardTypeID = ''S04''
			LEFT JOIN AT0128 A05 ON A05.DivisionID = O99.DivisionID AND A05.StandardID = O99.S05ID AND A05.StandardTypeID = ''S05''
			LEFT JOIN AT0128 A06 ON A06.DivisionID = O99.DivisionID AND A06.StandardID = O99.S06ID AND A06.StandardTypeID = ''S06''
			LEFT JOIN AT0128 A07 ON A07.DivisionID = O99.DivisionID AND A07.StandardID = O99.S07ID AND A07.StandardTypeID = ''S07''
			LEFT JOIN AT0128 A08 ON A08.DivisionID = O99.DivisionID AND A08.StandardID = O99.S08ID AND A08.StandardTypeID = ''S08''
			LEFT JOIN AT0128 A09 ON A09.DivisionID = O99.DivisionID AND A09.StandardID = O99.S09ID AND A09.StandardTypeID = ''S09''
			LEFT JOIN AT0128 A10 ON A10.DivisionID = O99.DivisionID AND A10.StandardID = O99.S10ID AND A10.StandardTypeID = ''S10''
			LEFT JOIN AT0128 A11 ON A11.DivisionID = O99.DivisionID AND A11.StandardID = O99.S11ID AND A11.StandardTypeID = ''S11''
			LEFT JOIN AT0128 A12 ON A12.DivisionID = O99.DivisionID AND A12.StandardID = O99.S12ID AND A12.StandardTypeID = ''S12''
			LEFT JOIN AT0128 A13 ON A13.DivisionID = O99.DivisionID AND A13.StandardID = O99.S13ID AND A13.StandardTypeID = ''S13''
			LEFT JOIN AT0128 A14 ON A14.DivisionID = O99.DivisionID AND A14.StandardID = O99.S14ID AND A14.StandardTypeID = ''S14''
			LEFT JOIN AT0128 A15 ON A15.DivisionID = O99.DivisionID AND A15.StandardID = O99.S15ID AND A15.StandardTypeID = ''S15''
			LEFT JOIN AT0128 A16 ON A16.DivisionID = O99.DivisionID AND A16.StandardID = O99.S16ID AND A16.StandardTypeID = ''S16''
			LEFT JOIN AT0128 A17 ON A17.DivisionID = O99.DivisionID AND A17.StandardID = O99.S17ID AND A17.StandardTypeID = ''S17''
			LEFT JOIN AT0128 A18 ON A18.DivisionID = O99.DivisionID AND A18.StandardID = O99.S18ID AND A18.StandardTypeID = ''S18''
			LEFT JOIN AT0128 A19 ON A19.DivisionID = O99.DivisionID AND A19.StandardID = O99.S19ID AND A19.StandardTypeID = ''S19''
			LEFT JOIN AT0128 A20 ON A20.DivisionID = O99.DivisionID AND A20.StandardID = O99.S20ID AND A20.StandardTypeID = ''S20''
	 '
	
	IF @CustomizeName = 54 --- An Phát
	BEGIN
		SET @sSQL = @sSQL + ',
		M37.MaterialID, AT02.InventoryName as MaterialName, M37.MaterialUnitID, M37.MaterialTypeID, M37.MaterialQuantity, M37.Rate, M37.RateDecimalApp, M37.RateWastage, M37.MaterialPrice, M37.MaterialAmount, M37.MaterialGroupID, 
		M37.DS01ID, M37.DS02ID, M37.DS03ID, M37.DS04ID, M37.DS05ID, M37.DS06ID, M37.DS07ID, M37.DS08ID, M37.DS09ID, M37.DS10ID, 
		M37.DS11ID, M37.DS12ID, M37.DS13ID, M37.DS14ID, M37.DS15ID, M37.DS16ID, M37.DS17ID, M37.DS18ID, M37.DS19ID, M37.DS20ID	
		'
		
		SET @sSQL3 = '
			LEFT JOIN MT0136 M36 ON M36.DivisionID = OT2001.DivisionID AND M36.ApportionID = OT2001.InheritApportionID  AND M36.ProductID = OT2002.InventoryID AND
							ISNULL(O99.S01ID,'''') = ISNULL(M36.S01ID,'''') AND 
							ISNULL(O99.S02ID,'''') = ISNULL(M36.S02ID,'''') AND 
							ISNULL(O99.S03ID,'''') = ISNULL(M36.S03ID,'''') AND 
							ISNULL(O99.S04ID,'''') = ISNULL(M36.S04ID,'''') AND 
							ISNULL(O99.S05ID,'''') = ISNULL(M36.S05ID,'''') AND 
							ISNULL(O99.S06ID,'''') = ISNULL(M36.S06ID,'''') AND 
							ISNULL(O99.S07ID,'''') = ISNULL(M36.S07ID,'''') AND 
							ISNULL(O99.S08ID,'''') = ISNULL(M36.S08ID,'''') AND 
							ISNULL(O99.S09ID,'''') = ISNULL(M36.S09ID,'''') AND 
							ISNULL(O99.S10ID,'''') = ISNULL(M36.S10ID,'''') AND 
							ISNULL(O99.S11ID,'''') = ISNULL(M36.S11ID,'''') AND 
							ISNULL(O99.S12ID,'''') = ISNULL(M36.S12ID,'''') AND 
							ISNULL(O99.S13ID,'''') = ISNULL(M36.S13ID,'''') AND 
							ISNULL(O99.S14ID,'''') = ISNULL(M36.S14ID,'''') AND 
							ISNULL(O99.S15ID,'''') = ISNULL(M36.S15ID,'''') AND 
							ISNULL(O99.S16ID,'''') = ISNULL(M36.S16ID,'''') AND 
							ISNULL(O99.S17ID,'''') = ISNULL(M36.S17ID,'''') AND 
							ISNULL(O99.S18ID,'''') = ISNULL(M36.S18ID,'''') AND 
							ISNULL(O99.S19ID,'''') = ISNULL(M36.S19ID,'''') AND 
							ISNULL(O99.S20ID,'''') = ISNULL(M36.S20ID,'''') 
			LEFT JOIN MT0137 M37 ON M37.DivisionID = M36.DivisionID AND M37.ProductID = M36.ProductID AND M37.ReTransactionID = M36.TransactionID
			LEFT JOIN AT1302 AT02 ON AT02.InventoryID = M37.MaterialID AND AT02.DivisionID = M37.DivisionID
			' + '
	WHERE	OT2001.DivisionID = N''' + @DivisionID + ''' AND 
			OT2001.SOrderID = N''' + @SOrderID + ''''
	END
	ELSE
		SET @sSQL2 = @sSQL2 + '
	WHERE	OT2001.DivisionID = N''' + @DivisionID + ''' AND 
			OT2001.SOrderID = N''' + @SOrderID + ''''

	 
END
ELSE
	SET @sSQL1 = @sSQL1 + '
	WHERE	OT2001.DivisionID = N''' + @DivisionID + ''' AND 
			OT2001.SOrderID = N''' + @SOrderID + ''''
			

--PRINT	@sSQL
--PRINT	@sSQL1
--PRINT	@sSQL2
--PRINT	@sSQL3
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='OV3014')
	EXEC ('CREATE VIEW OV3014  ---TAO BOI OP3012
		AS '+@sSQL+@sSQL1 + @sSQL2 + @sSQL3)
ELSE
	EXEC( 'ALTER VIEW OV3014  ---TAO BOI OP3012
		AS '+@sSQL+@sSQL1 + @sSQL2 + @sSQL3)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

