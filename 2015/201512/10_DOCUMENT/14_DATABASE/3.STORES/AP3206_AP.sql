IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3206_AP]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP3206_AP]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- <Summary>
----  Load detail cho form ke thua nhieu don hang bán o phieu nhap kho (Customize An Phát)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Created by Tieu Mai on 25/12/2015
-- <Example>
---- EXEC AP3206_AP 'AS', '', '', 1
CREATE PROCEDURE [dbo].[AP3206_AP] 
    @DivisionID NVARCHAR(50),
    @lstSOrderID NVARCHAR(MAX),
    -- Thêm mới   : ''
    -- Hiệu chỉnh : Số chứng từ đang sửa
    @VoucherID NVARCHAR(50), 
    @ConnID NVARCHAR(100)
AS

DECLARE 
    @sSQL1 NVARCHAR(MAX),
    @sSQL2 NVARCHAR(MAX),
	@sSQL3 NVARCHAR(MAX),
    @Customize AS INT,
	@sWHERE AS NVARCHAR(4000),
	@sOrderID AS NVARCHAR(Max)
SET @sWHERE = N''
DECLARE	@TempTable table(CustomerName  int,IsExcel  int)

INSERT @TempTable
EXEC	[dbo].[AP4444]

SET @Customize = (SELECT TOP 1 CustomerName FROM @TempTable)

	--SET @sOrderID = N'INNER JOIN AQ2904_AP ON AQ2904_AP.DivisionID = OT2002.DivisionID AND AQ2904_AP.SOrderID = OT2002.SOrderID AND AQ2904_AP.TransactionID = OT2002.TransactionID '



SET @DivisionID = ISNULL(@DivisionID, '')
SET @lstSOrderID = ISNULL(@lstSOrderID, '')
SET @VoucherID = ISNULL(@VoucherID, '')
SET @ConnID = ISNULL(@ConnID, '')

SET @lstSOrderID = REPLACE(@lstSOrderID, ',', ''',''')

SET @sSQL1 = '
SELECT 
	O02.SOrderID AS OrderID,
    M37.TransactionID, O02.Parameter01,
	O02.Parameter02, O02.Parameter03, O02.Parameter04,O02.Parameter05,
	O02.Ana01ID, O02.Ana02ID, O02.Ana03ID, O02.Ana04ID, O02.Ana05ID, O02.Ana06ID, O02.Ana07ID, 
	O02.Ana08ID, O02.Ana09ID, O02.Ana10ID,
	O01.DivisionID, 
	O01.TranMonth, 
	O01.TranYear, 
	O01.SOrderID, 
	O01.OrderStatus, 
	O01.Duedate, 
	O01.Shipdate,
	O01.PaymentTermID,
	AT1208.Duedays,
	O02.Orders,
	--M36.S01ID, M36.S02ID, M36.S03ID, M36.S04ID, M36.S05ID, M36.S06ID, M36.S07ID, M36.S08ID, M36.S09ID, M36.S10ID,
	--M36.S11ID, M36.S12ID, M36.S13ID, M36.S14ID, M36.S15ID, M36.S16ID, M36.S17ID, M36.S18ID, M36.S19ID, M36.S20ID,
	M37.MaterialID as InventoryID, A32.InventoryName, M37.MaterialUnitID as UnitID, M37.MaterialQuantity,
	M37.DS01ID as S01ID, M37.DS02ID as S02ID, M37.DS03ID as S03ID, M37.DS04ID as S04ID, M37.DS05ID as S05ID, 
	M37.DS06ID as S06ID, M37.DS07ID as S07ID, M37.DS08ID as S08ID, M37.DS09ID as S09ID, M37.DS10ID as S10ID,
	M37.DS11ID as S11ID, M37.DS12ID as S12ID, M37.DS13ID as S13ID, M37.DS14ID as S14ID, M37.DS15ID as S15ID, 
	M37.DS16ID as S16ID, M37.DS17ID as S17ID, M37.DS18ID as S18ID, M37.DS19ID as S19ID, M37.DS20ID as S20ID,

	CASE WHEN O02.Finish = 1 OR Isnull(M37.MaterialQuantity,0) = 0 THEN 0 ELSE ISNULL(O02.OrderQuantity, 0)*Isnull(M37.QuantityUnit,0) - ISNULL(G.ActualQuantity, 0) END AS ActualQuantity,
	CASE WHEN O02.Finish = 1 OR Isnull(M37.MaterialQuantity,0) = 0 THEN 0 ELSE ISNULL(O02.ConvertedQuantity, 0)*Isnull(M37.QuantityUnit,0) - ISNULL(G.ActualConvertedQuantity, 0) END AS ActualConvertedQuantity,
	--CASE WHEN O02.Finish = 1 OR Isnull(M37.MaterialQuantity,0) = 0 THEN 0 ELSE (ISNULL(O02.OrderQuantity, 0)*Isnull(M37.MaterialQuantity,0)/ISNULL(M36.ProductQuantity,0) - ISNULL(G.ActualQuantity, 0)) * (Isnull(M37.MaterialAmount,0)/Isnull(M37.MaterialQuantity,0)) END AS OriginalAmount,
	--CASE WHEN O02.Finish = 1 OR Isnull(M37.MaterialQuantity,0) = 0 THEN 0 ELSE (ISNULL(O02.ConvertedQuantity, 0)*Isnull(M37.MaterialQuantity,0)/ISNULL(M36.ProductQuantity,0) - ISNULL(G.ActualQuantity, 0)) * (Isnull(M37.MaterialAmount,0)/Isnull(M37.MaterialQuantity,0)) END AS ConvertedAmount,
	--CASE WHEN O02.Finish = 1 OR Isnull(O02.OrderQuantity, 0)*Isnull(M37.MaterialQuantity,0)/ISNULL(M36.ProductQuantity,0) - ISNULL(G.ActualQuantity, 0) = 0 THEN 0 ELSE (ISNULL(O02.OrderQuantity, 0)*Isnull(M37.MaterialQuantity,0)/ISNULL(M36.ProductQuantity,0) - ISNULL(G.ActualQuantity, 0)) * (Isnull(M37.MaterialAmount,0)/Isnull(M37.MaterialQuantity,0))/(ISNULL(O02.OrderQuantity, 0)*Isnull(M37.MaterialQuantity,0)/ISNULL(M36.ProductQuantity,0) - ISNULL(G.ActualQuantity, 0)) END as UnitPrice
	0 as OriginalAmount,
	0 as ConvertedAmount,
	0 as UnitPrice
'
SET @sSQL2 = '
FROM OT2002 O02
	LEFT JOIN OT2001 O01 ON O01.DivisionID = O02.DivisionID AND O01.SOrderID = O02.SOrderID
	LEFT JOIN MT0136 M36 ON M36.DivisionID = O02.DivisionID AND M36.ApportionID = O02.InheritVoucherID AND M36.TransactionID = O02.InheritTransactionID
	LEFT JOIN MT0137 M37 ON M37.DivisionID = M36.DivisionID AND M37.ProductID = M36.ProductID AND M37.ReTransactionID = M36.TransactionID
	LEFT JOIN AT1302 A31 ON A31.DivisionID = O02.DivisionID AND A31.InventoryID = O02.InventoryID
	LEFT JOIN AT1302 A32 ON A32.DivisionID = M37.DivisionID AND A32.InventoryID = M37.MaterialID
	LEFT JOIN AT1208 ON AT1208.PaymentTermID = O01.PaymentTermID AND AT1208.DivisionID = O01.DivisionID
	LEFT JOIN (SELECT 
	AT2007.DivisionID, 
	AT2007.OrderID, 
	AT2007.OTransactionID,
	AT2007.InventoryID, 
	SUM(ISNULL(AT2007.ConvertedQuantity, 0)) AS ActualConvertedQuantity, 
	SUM(ISNULL(AT2007.ActualQuantity, 0)) AS ActualQuantity, 
	SUM(ISNULL(AT2007.OriginalAmount, 0)) AS ActualOriginalAmount, 
	SUM(ISNULL(AT2007.ConvertedAmount, 0)) AS ActualConvertedAmount,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
	FROM AT2007 
	INNER JOIN AT2006 ON AT2007.VoucherID = AT2006.VoucherID AND AT2007.DivisionID = AT2006.DivisionID
	LEFT JOIN WT8899 O99 ON O99.DivisionID = AT2007.DivisionID AND O99.VoucherID = AT2007.VoucherID AND O99.TransactionID = AT2007.TransactionID AND O99.TableID = ''AT2007''
	WHERE AT2006.KindVoucherID = 1
	AND ISNULL(AT2007.OrderID, '''') <> ''''
	GROUP BY AT2007.DivisionID, AT2007.OrderID, InventoryID, OTransactionID,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID) AS G 
											ON G.OrderID = O02.SOrderID AND G.InventoryID = M37.MaterialID AND 
											Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND 
											Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND 
											Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND 
											Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND 
											Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND 
											Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND 
											Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND 
											Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND
											Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND 
											Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(M37.DS01ID,'''')

'+ '
WHERE O02.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + '''))
    AND O02.SOrderID in (''' + @lstSOrderID + ''') 
    AND (CASE WHEN A32.IsDiscount = 1 THEN ISNULL(O02.ConvertedQuantity, 0)*Isnull(M37.MaterialQuantity,0)/ISNULL(M36.ProductQuantity,0) - ISNULL(G.ActualConvertedQuantity, 0) ELSE ISNULL(O02.OrderQuantity, 0)*Isnull(M37.MaterialQuantity,0)/ISNULL(M36.ProductQuantity,0) - ISNULL(G.ActualQuantity, 0) END ) > 0
    '+@sWHERE+'
' 

--PRINT @sSQL1 
--PRINT @sSQL2

IF NOT EXISTS(SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'AV3206' + @ConnID)
    EXEC('CREATE VIEW AV3206' + @ConnID + ' -- Tạo bởi AP3206
            AS ' + @sSQL1 + @sSQL2)
ELSE 
    EXEC('ALTER VIEW AV3206' + @ConnID + ' -- Tạo bởi AP3206
            AS ' + @sSQL1 + @sSQL2)

IF NOT EXISTS(SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'AV3206')
    EXEC('CREATE VIEW AV3206 -- Tạo bởi AP3206
            AS ' + @sSQL1 + @sSQL2)
ELSE 
    EXEC('ALTER VIEW AV3206 -- Tạo bởi AP3206
            AS ' + @sSQL1 + @sSQL2)




GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
