IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP2048]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP2048]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-----Create by Tiểu Mai, on 06/11/2015
-----Purpose: Nhat ky kiem ke hang hoa.


CREATE PROCEDURE [dbo].[WP2048] 
    @DivisionID NVARCHAR(50), 
    @FromWareHouseID NVARCHAR(50), 
    @ToWareHouseID NVARCHAR(50), 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @FromDate DATETIME, 
    @ToDate DATETIME, 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @IsDate TINYINT
AS

SET NOCOUNT ON
DECLARE @sSQL NVARCHAR(MAX),
	@sSQL1 NVARCHAR(MAX), 
	@sSQL2 NVARCHAR(MAX),
	@sSQL3 NVARCHAR(MAX),
	@sSQL4 NVARCHAR(MAX),
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)

		SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
		SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
		SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
		SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'
	
SET @sSQL = '
        SELECT 
			AT2037.DivisionID,
			AT2036.WareHouseID, 
            AT1303.WareHouseName, 
            AT2036.VoucherID, 
            AT2037.TransactionID, 
            CAST(DAY(AT2036.VoucherDate) + MONTH(AT2036.VoucherDate)* 100 + YEAR(AT2036.VoucherDate)*10000 AS NCHAR(8)) + CAST(AT2036.VoucherNo AS NCHAR(50)) + CAST(AT2037.TransactionID AS NCHAR(50)) + CAST(AT2037.InventoryID AS NCHAR(50)) AS Orders, 
            AT2036.VoucherDate, 
            AT2036.VoucherNo, 
            AT2037.SourceNo, 
            AT2037.Quantity, 
            AT2037.UnitPrice, 
            AT2037.OriginalAmount, 
            AT2037.AdjustQuantity, 
            AT2037.AdjustUnitPrice, 
            AT2037.AdjutsOriginalAmount, 
            AT2036.VoucherTypeID, 
            AT2036.Description, 
            AT2037.InventoryID, 
            AT1302.InventoryName, 
            AT2037.UnitID, 
            T07.ACCQuantity, 
            T07.ACCOriginalAmount, 
            T07.ACCConvertedAmount, 
            T08.DesQuantity, 
            T08.DesOriginalAmount, 
            T08.DesConvertedAmount,
            O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
			O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
			A10.StandardName AS StandardName01, A11.StandardName AS StandardName02, A12.StandardName AS StandardName03, A13.StandardName AS StandardName04, A14.StandardName AS StandardName05,
			A15.StandardName AS StandardName06, A16.StandardName AS StandardName07, A17.StandardName AS StandardName08, A18.StandardName AS StandardName09, A19.StandardName AS StandardName10,
			A20.StandardName AS StandardName11, A21.StandardName AS StandardName12, A22.StandardName AS StandardName13, A23.StandardName AS StandardName14, A24.StandardName AS StandardName15, 
			A25.StandardName AS StandardName16, A26.StandardName AS StandardName17, A27.StandardName AS StandardName18, A28.StandardName AS StandardName19, A29.StandardName AS StandardName20
			'
			
	SET @sSQL1 = N'
		FROM AT2037 INNER JOIN AT1302 ON AT1302.InventoryID = AT2037.InventoryID and AT1302.DivisionID = AT2037.DivisionID
			LEFT JOIN WT8899 O99 ON O99.DivisionID = AT2037.DivisionID AND O99.VoucherID = AT2037.VoucherID AND O99.TransactionID = AT2037.TransactionID
            INNER JOIN AT2036 ON AT2036.VoucherID = AT2037.VoucherID and AT2036.DivisionID = AT2037.DivisionID
            INNER JOIN AT1303 ON AT1303.WarehouseID = AT2036.WarehouseID and AT1303.DivisionID = AT2037.DivisionID
            LEFT JOIN (SELECT AT2007.DivisionID,InventoryID, SUM(ISNULL(ActualQuantity, 0)) AS ACCQuantity, UnitPrice AS ACCUnitPrice, SUM(ISNULL(OriginalAmount, 0)) AS ACCOriginalAmount, SUM(ISNULL(ConvertedAmount, 0)) AS ACCConvertedAmount,
						S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
						S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID
                       FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID and AT2007.DivisionID = AT2006.DivisionID
                       Left join WT8899 on WT8899.DivisionID = AT2007.DivisionID and WT8899.VoucherID = AT2007.VoucherID and WT8899.TransactionID = AT2007.TransactionID
                       WHERE KindVoucherID = 9 
                       GROUP BY AT2007.DivisionID,InventoryID, UnitPrice,S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
								S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID) AS T07 ON T07.InventoryID = AT2037.InventoryID  and T07.DivisionID = AT2037.DivisionID AND
						ISNULL(T07.S01ID,'''') = isnull(O99.S01ID,'''') AND 
						ISNULL(T07.S02ID,'''') = isnull(O99.S02ID,'''') AND
						ISNULL(T07.S03ID,'''') = isnull(O99.S03ID,'''') AND
						ISNULL(T07.S04ID,'''') = isnull(O99.S04ID,'''') AND
						ISNULL(T07.S05ID,'''') = isnull(O99.S05ID,'''') AND 
						ISNULL(T07.S06ID,'''') = isnull(O99.S06ID,'''') AND
						ISNULL(T07.S07ID,'''') = isnull(O99.S07ID,'''') AND
						ISNULL(T07.S08ID,'''') = isnull(O99.S08ID,'''') AND
						ISNULL(T07.S09ID,'''') = isnull(O99.S09ID,'''') AND
						ISNULL(T07.S10ID,'''') = isnull(O99.S10ID,'''') AND
						ISNULL(T07.S11ID,'''') = isnull(O99.S11ID,'''') AND 
						ISNULL(T07.S12ID,'''') = isnull(O99.S12ID,'''') AND
						ISNULL(T07.S13ID,'''') = isnull(O99.S13ID,'''') AND
						ISNULL(T07.S14ID,'''') = isnull(O99.S14ID,'''') AND
						ISNULL(T07.S15ID,'''') = isnull(O99.S15ID,'''') AND
						ISNULL(T07.S16ID,'''') = isnull(O99.S16ID,'''') AND
						ISNULL(T07.S17ID,'''') = isnull(O99.S17ID,'''') AND
						ISNULL(T07.S18ID,'''') = isnull(O99.S18ID,'''') AND
						ISNULL(T07.S19ID,'''') = isnull(O99.S19ID,'''') AND
						ISNULL(T07.S20ID,'''') = isnull(O99.S20ID,'''') ' 
    SET @sSQL2 = N'        
		LEFT JOIN (SELECT AT2007.DivisionID,InventoryID, SUM(ISNULL(ActualQuantity, 0)) AS DesQuantity, UnitPrice AS DesUnitPrice, SUM(ISNULL(OriginalAmount, 0)) AS DesOriginalAmount, SUM(ISNULL(ConvertedAmount, 0)) AS DesConvertedAmount,
						S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
						S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID
                       FROM AT2007 INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID and AT2007.DivisionID = AT2006.DivisionID
                       Left join WT8899 on WT8899.DivisionID = AT2007.DivisionID and WT8899.VoucherID = AT2007.VoucherID and WT8899.TransactionID = AT2007.TransactionID
                       WHERE KindVoucherID = 8  
                       GROUP BY AT2007.DivisionID,InventoryID, UnitPrice,
								S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
								S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID) AS T08 ON T08.InventoryID = AT2037.InventoryID and T08.DivisionID = AT2037.DivisionID AND 
						ISNULL(T08.S01ID,'''') = isnull(O99.S01ID,'''') AND 
						ISNULL(T08.S02ID,'''') = isnull(O99.S02ID,'''') AND
						ISNULL(T08.S03ID,'''') = isnull(O99.S03ID,'''') AND
						ISNULL(T08.S04ID,'''') = isnull(O99.S04ID,'''') AND
						ISNULL(T08.S05ID,'''') = isnull(O99.S05ID,'''') AND 
						ISNULL(T08.S06ID,'''') = isnull(O99.S06ID,'''') AND
						ISNULL(T08.S07ID,'''') = isnull(O99.S07ID,'''') AND
						ISNULL(T08.S08ID,'''') = isnull(O99.S08ID,'''') AND
						ISNULL(T08.S09ID,'''') = isnull(O99.S09ID,'''') AND
						ISNULL(T08.S10ID,'''') = isnull(O99.S10ID,'''') AND
						ISNULL(T08.S11ID,'''') = isnull(O99.S11ID,'''') AND 
						ISNULL(T08.S12ID,'''') = isnull(O99.S12ID,'''') AND
						ISNULL(T08.S13ID,'''') = isnull(O99.S13ID,'''') AND
						ISNULL(T08.S14ID,'''') = isnull(O99.S14ID,'''') AND
						ISNULL(T08.S15ID,'''') = isnull(O99.S15ID,'''') AND
						ISNULL(T08.S16ID,'''') = isnull(O99.S16ID,'''') AND
						ISNULL(T08.S17ID,'''') = isnull(O99.S17ID,'''') AND
						ISNULL(T08.S18ID,'''') = isnull(O99.S18ID,'''') AND
						ISNULL(T08.S19ID,'''') = isnull(O99.S19ID,'''') AND
						ISNULL(T08.S20ID,'''') = isnull(O99.S20ID,'''')
						'
	SET @sSQL3 = N'
		LEFT JOIN AT0128 A10 ON A10.DivisionID = O99.DivisionID AND A10.StandardID = O99.S01ID AND A10.StandardTypeID = ''S01''
		LEFT JOIN AT0128 A11 ON A11.DivisionID = O99.DivisionID AND A11.StandardID = O99.S02ID AND A11.StandardTypeID = ''S02''
		LEFT JOIN AT0128 A12 ON A12.DivisionID = O99.DivisionID AND A12.StandardID = O99.S03ID AND A12.StandardTypeID = ''S03''
		LEFT JOIN AT0128 A13 ON A13.DivisionID = O99.DivisionID AND A13.StandardID = O99.S04ID AND A13.StandardTypeID = ''S04''
		LEFT JOIN AT0128 A14 ON A14.DivisionID = O99.DivisionID AND A14.StandardID = O99.S05ID AND A14.StandardTypeID = ''S05''
		LEFT JOIN AT0128 A15 ON A15.DivisionID = O99.DivisionID AND A15.StandardID = O99.S06ID AND A15.StandardTypeID = ''S06''
		LEFT JOIN AT0128 A16 ON A16.DivisionID = O99.DivisionID AND A16.StandardID = O99.S07ID AND A16.StandardTypeID = ''S07''
		LEFT JOIN AT0128 A17 ON A17.DivisionID = O99.DivisionID AND A17.StandardID = O99.S08ID AND A17.StandardTypeID = ''S08''
		LEFT JOIN AT0128 A18 ON A18.DivisionID = O99.DivisionID AND A18.StandardID = O99.S09ID AND A18.StandardTypeID = ''S09''
		LEFT JOIN AT0128 A19 ON A19.DivisionID = O99.DivisionID AND A19.StandardID = O99.S10ID AND A19.StandardTypeID = ''S10''
		LEFT JOIN AT0128 A20 ON A20.DivisionID = O99.DivisionID AND A20.StandardID = O99.S11ID AND A20.StandardTypeID = ''S11''
		LEFT JOIN AT0128 A21 ON A21.DivisionID = O99.DivisionID AND A21.StandardID = O99.S12ID AND A21.StandardTypeID = ''S12''
		LEFT JOIN AT0128 A22 ON A22.DivisionID = O99.DivisionID AND A22.StandardID = O99.S13ID AND A22.StandardTypeID = ''S13''
		LEFT JOIN AT0128 A23 ON A23.DivisionID = O99.DivisionID AND A23.StandardID = O99.S14ID AND A23.StandardTypeID = ''S14''
		LEFT JOIN AT0128 A24 ON A24.DivisionID = O99.DivisionID AND A24.StandardID = O99.S15ID AND A24.StandardTypeID = ''S15''
		LEFT JOIN AT0128 A25 ON A25.DivisionID = O99.DivisionID AND A25.StandardID = O99.S16ID AND A25.StandardTypeID = ''S16''
		LEFT JOIN AT0128 A26 ON A26.DivisionID = O99.DivisionID AND A26.StandardID = O99.S17ID AND A26.StandardTypeID = ''S17''
		LEFT JOIN AT0128 A27 ON A27.DivisionID = O99.DivisionID AND A27.StandardID = O99.S18ID AND A27.StandardTypeID = ''S18''
		LEFT JOIN AT0128 A28 ON A28.DivisionID = O99.DivisionID AND A28.StandardID = O99.S19ID AND A28.StandardTypeID = ''S19''
		LEFT JOIN AT0128 A29 ON A29.DivisionID = O99.DivisionID AND A29.StandardID = O99.S20ID AND A29.StandardTypeID = ''S20'''					
	IF @IsDate = 1 -- Theo ngay 
	SET @sSQL4 = '	
        WHERE AT2037.DivisionID = ''' + @DivisionID + ''' 
            AND (AT2036.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''') 
            AND (AT2037.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''') 
            AND (AT2036.WareHouseID BETWEEN N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')
    '
	ELSE
		IF @IsDate = 0 -- Theo ky 
		SET @sSQL4 = N'   
            WHERE AT2037.DivisionID = ''' + @DivisionID + ''' 
                AND (AT2036.TranMonth + AT2036.TranYear*100   BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText + ') 
                AND (AT2037.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''') 
                AND (AT2036.WareHouseID BETWEEN N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')
'

	EXEC (@sSQL + @sSQL1 + @sSQL2 + @sSQL3 + @sSQL4)
	 --PRINT @sSQL
	 --PRINT @sSQL1
 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
