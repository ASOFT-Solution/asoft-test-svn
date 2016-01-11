IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP3018_QC]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP3018_QC]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Tiểu Mai on 11/01/2016
---- Purpose: IN the kho (tuong tu So chi tiet vat tu)


CREATE PROCEDURE [dbo].[AP3018_QC] 
    @DivisionID NVARCHAR(50), 
    @WareHouseID NVARCHAR(50), 
    @FromInventoryID NVARCHAR(50), 
    @ToInventoryID NVARCHAR(50), 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @FromDate DATETIME, 
    @ToDate DATETIME,
    @IsDate TINYINT
 
AS
DECLARE 
	@SQL1 NVARCHAR(MAX), 
	@SQL2 NVARCHAR(MAX), 
	@WareHouseName NVARCHAR(250), 
	@KindVoucherListIm NVARCHAR(200), 
	@KindVoucherListEx1 NVARCHAR(200), 
	@KindVoucherListEx2 NVARCHAR(200),
	@FromMonthYearText NVARCHAR(20), 
	@ToMonthYearText NVARCHAR(20), 
	@FromDateText NVARCHAR(20), 
	@ToDateText NVARCHAR(20)

	SELECT @WareHouseName = WareHouseName FROM AT1303 WHERE WareHouseID = @WareHouseID AND DivisionID = @DivisionID
		    
	SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
	SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
	SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
	SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

	SET @KindVoucherListEx1 = ' (2, 4, 3, 6, 8, 10, 14, 20) '
	SET @KindVoucherListEx2 = ' (2, 4, 6, 8, 10, 14, 20) '
	SET @KindVoucherListIm = ' (1, 3, 5, 7, 9, 15, 17) '

	-- Lấy số dư đầu
	IF @isDate = 0 
		SET @SQL1 = N'
	SELECT 
	AT2008_QC.InventoryID, 
	AT1302.InventoryName, 
	AT1302.UnitID, 
	AT1304.UnitName, 
	AT1302.Specification, 
	AT1302.Notes01, 
	AT1302.Notes02, 
	AT1302.Notes03, 
	SUM(AT2008_QC.BeginQuantity) AS BeginQuantity, 
	SUM(AT2008_QC.EndQuantity) AS EndQuantity, 
	SUM(AT2008_QC.BeginAmount) AS BeginAmount, 
	SUM(AT2008_QC.EndAmount) AS EndAmount, 
	AT2008_QC.DivisionID,
	S01ID,S02ID,S03ID,S04ID,S05ID,S06ID,S07ID,S08ID,S09ID,S10ID,
	S11ID,S12ID,S13ID,S14ID,S15ID,S16ID,S17ID,S18ID,S19ID,S20ID

	FROM AT2008_QC 
	INNER JOIN AT1302 ON AT1302.InventoryID = AT2008_QC.InventoryID AND AT1302.DivisionID = AT2008_QC.DivisionID
	INNER JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = AT2008_QC.DivisionID

	WHERE AT2008_QC.DivisionID LIKE ''' + @DivisionID + ''' 
	AND AT2008_QC.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
	AND AT2008_QC.TranMonth + AT2008_QC.TranYear * 100 = ' + @FromMonthYearText + ' 
	AND AT2008_QC.WareHouseID LIKE N''' + @WareHouseID + ''' 

	GROUP BY 
	AT2008_QC.InventoryID, AT1302.InventoryName, AT1302.UnitID, AT1304.UnitName, 
	AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, AT2008_QC.DivisionID,
	S01ID,S02ID,S03ID,S04ID,S05ID,S06ID,S07ID,S08ID,S09ID,S10ID,
	S11ID,S12ID,S13ID,S14ID,S15ID,S16ID,S17ID,S18ID,S19ID,S20ID

	HAVING SUM(AT2008_QC.BeginQuantity) <> 0 OR SUM(AT2008_QC.EndQuantity) <> 0 
	'
	ELSE
		SET @SQL1 = N' 
	SELECT 
	InventoryID, 
	InventoryName, 
	UnitID, 
	UnitName, 
	Specification, 
	Notes01, 
	Notes02, 
	Notes03, 
	SUM(SignQuantity) AS BeginQuantity, 
	SUM(SignAmount) AS BeginAmount, 
	0 AS EndQuantity, 
	0 AS EndAmount, 
	DivisionID,
	S01ID,S02ID,S03ID,S04ID,S05ID,S06ID,S07ID,S08ID,S09ID,S10ID,
	S11ID,S12ID,S13ID,S14ID,S15ID,S16ID,S17ID,S18ID,S19ID,S20ID
	FROM AV7002
	WHERE DivisionID LIKE ''' + @DivisionID + ''' 
	AND InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
	AND ((D_C IN (''D'', ''C'') AND VoucherDate < ''' + @FromDateText + ''') OR D_C = ''BD'' ) 
	AND WareHouseID LIKE N''' + @WareHouseID + ''' 

	GROUP BY 
	InventoryID, InventoryName, UnitID, UnitName, Specification, Notes01, Notes02, Notes03, DivisionID,
	S01ID,S02ID,S03ID,S04ID,S05ID,S06ID,S07ID,S08ID,S09ID,S10ID,
	S11ID,S12ID,S13ID,S14ID,S15ID,S16ID,S17ID,S18ID,S19ID,S20ID

	HAVING SUM(SignQuantity) <> 0 ---OR SUM(SignAmount) <> 0
	'

	IF NOT EXISTS(SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV7005')
		EXEC('CREATE VIEW AV7005 AS -- Tạo bởi AP3018
			' + @SQL1)
	ELSE
		EXEC('ALTER VIEW AV7005 AS -- Tạo bởi AP3018
			' + @SQL1)
		        
	---- Lay so phat sinh 
	IF @IsDate = 0 
		BEGIN
			SET @SQL1 = N'
	-- Phần nhập kho
	SELECT 
	AT2007.VoucherID, 
	''T05'' AS TransactionTypeID, 
	AT2007.TransactionID, 
	AT2007.Orders, 
	AT2006.VoucherDate, 
	AT2006.VoucherNo, 
	AT2006.VoucherDate AS ImVoucherDate, 
	AT2006.VoucherNo AS ImVoucherNo, 
	AT2007.SourceNo AS ImSourceNo, 
	AT2007.LimitDate AS ImLimitDate, 
	AT2006.WareHouseID AS ImWareHouseID, 
	AT2007.ActualQuantity AS ImQuantity, 
	AT2007.UnitPrice AS ImUnitPrice, 
	AT2007.ConvertedAmount AS ImConvertedAmount, 
	AT2007.OriginalAmount AS ImOriginalAmount, 
	ISNULL(AT2007.ConversionFactor, 1) * AT2007.ActualQuantity AS ImConvertedQuantity, 
	NULL AS ExVoucherDate, 
	NULL AS ExVoucherNo, 
	NULL AS ExSourceNo, 
	NULL AS ExLimitDate, 
	NULL AS ExWareHouseID, 
	NULL AS ExQuantity, 
	NULL AS ExUnitPrice, 
	NULL AS ExConvertedAmount, 
	NULL AS ExOriginalAmount, 
	NULL AS ExConvertedQuantity, 
	AT2006.VoucherTypeID, 
	AT2006.Description, 
	AT2007.Notes, 
	AT2007.InventoryID, 
	AT1302.InventoryName, 
	AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, 
	AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, 
	AT2007.UnitID, AT1304.UnitName, 
	ISNULL(AT2007.ConversionFactor, 1) AS ConversionFactor, AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID 
	,AT2006.RefNo01,
	AT2006.RefNo02,
	AT2007.RefInfor,
	O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
	O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
	FROM AT2007 
	INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
	INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
	LEFT JOIN AT1304 ON AT1304.UnitID = AT2007.UnitID AND AT1304.DivisionID = AT2007.DivisionID
	LEFT JOIN AT1202 ON AT1202.ObjectID = AT2006.ObjectID AND AT1202.DivisionID = AT2007.DivisionID
	LEFT JOIN WT8899 O99 ON O99.DivisionID = AT2007.DivisionID AND O99.VoucherID = AT2007.VoucherID AND O99.TransactionID = AT2007.TransactionID
	WHERE AT2007.DivisionID = ''' + @DivisionID + ''' 
	AND AT2007.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + '''
	AND AT2007.TranMonth + AT2007.TranYear * 100 BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText + ' 
	AND AT2006.WareHouseID LIKE N''' + @WareHouseID + '''
	AND AT2006.KindVoucherID IN ' + @KindVoucherListIm + ' 

	UNION ALL
	'
			SET @SQL2 = N'
	-- Phần xuất kho
	SELECT 
	AT2007.VoucherID, 
	''T06'' AS TransactionTypeID, 
	AT2007.TransactionID, 
	AT2007.Orders, 
	AT2006.VoucherDate, 
	AT2006.VoucherNo, 
	Null AS ImVoucherDate, 
	Null AS ImVoucherNo, 
	Null AS ImSourceNo, 
	Null AS ImLimitDate, 
	Null AS ExWareHouseID, 
	Null AS ImQuantity, 
	Null AS ImUnitPrice, 
	Null AS ImConvertedAmount, 
	Null AS ImOriginalAmount, 
	Null AS ImConvertedQuantity, 
	AT2006.VoucherDate AS ExVoucherDate, 
	AT2006.VoucherNo AS ExVoucherNo, 
	AT2007.SourceNo AS ExSourceNo, 
	AT2007.LimitDate AS ExLimitDate, 
	(CASE WHEN AT2006.KindVoucherID = 3 THEN AT2006.WareHouseID2 ELSE AT2006.WareHouseID END) AS ExWareHouseID, 
	AT2007.ActualQuantity AS ExQuantity, 
	AT2007.UnitPrice AS ExUnitPrice, 
	AT2007.ConvertedAmount AS ExConvertedAmount, 
	AT2007.OriginalAmount AS ExOriginalAmount, 
	ISNULL(AT2007.ConversionFactor, 1) * AT2007.ActualQuantity AS ExConvertedQuantity, 
	AT2006.VoucherTypeID, 
	AT2006.Description, 
	AT2007.Notes, 
	AT2007.InventoryID, 
	AT1302.InventoryName, 
	AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, 
	AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, 
	AT2007.UnitID, AT1304.UnitName, 
	ISNULL(AT2007.ConversionFactor, 1) AS ConversionFactor, AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID 
	,AT2006.RefNo01,
	AT2006.RefNo02,
	AT2007.RefInfor,
	O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
	O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
	FROM AT2007 
	INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
	INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
	LEFT JOIN AT1304 ON AT1304.UnitID = AT2007.UnitID AND AT1304.DivisionID = AT2007.DivisionID
	LEFT JOIN AT1202 ON AT1202.ObjectID = AT2006.ObjectID AND AT1202.DivisionID = AT2007.DivisionID
	LEFT JOIN WT8899 O99 ON O99.DivisionID = AT2007.DivisionID AND O99.VoucherID = AT2007.VoucherID AND O99.TransactionID = AT2007.TransactionID
	WHERE AT2007.DivisionID = ''' + @DivisionID + ''' 
	AND AT2007.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + '''
	AND AT2007.TranMonth + AT2007.TranYear * 100 BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText + ' 
	AND AT2006.KindVoucherID IN ' + @KindVoucherListEx1 + '  
	AND ((AT2006.KindVoucherID IN ' + @KindVoucherListEx2 + ' AND WareHouseID LIKE ''' + @WareHouseID + ''') 
		OR (KindVoucherID = 3 AND WareHouseID2 LIKE ''' + @WareHouseID + ''')) 
	'
		END
	ELSE
		BEGIN
		SET @SQL1 = N'
	-- Phần nhập kho
	SELECT 
	AT2007.VoucherID, 
	''T05'' AS TransactionTypeID, 
	AT2007.TransactionID, 
	AT2007.Orders, 
	AT2006.VoucherDate, 
	AT2006.VoucherNo, 
	AT2006.VoucherDate AS ImVoucherDate, 
	AT2006.VoucherNo AS ImVoucherNo, 
	AT2007.SourceNo AS ImSourceNo, 
	AT2007.LimitDate AS ImLimitDate, 
	AT2006.WareHouseID AS ImWareHouseID, 
	AT2007.ActualQuantity AS ImQuantity, 
	AT2007.UnitPrice AS ImUnitPrice, 
	AT2007.ConvertedAmount AS ImConvertedAmount, 
	AT2007.OriginalAmount AS ImOriginalAmount, 
	ISNULL(AT2007.ConversionFactor, 1) * AT2007.ActualQuantity AS ImConvertedQuantity, 
	Null AS ExVoucherDate, 
	Null AS ExVoucherNo, 
	Null AS ExSourceNo, 
	Null AS ExLimitDate, 
	Null AS ExWareHouseID, 
	Null AS ExQuantity, 
	Null AS ExUnitPrice, 
	Null AS ExConvertedAmount, 
	Null AS ExOriginalAmount, 
	Null AS ExConvertedQuantity, 
	AT2006.VoucherTypeID, 
	AT2006.Description, 
	AT2007.Notes, 
	AT2007.InventoryID, 
	AT1302.InventoryName, 
	AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, 
	AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, 
	AT2007.UnitID, AT1304.UnitName, 
	ISNULL(AT2007.ConversionFactor, 1) AS ConversionFactor, AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID 
	,AT2006.RefNo01,
	AT2006.RefNo02,
	AT2007.RefInfor,
	O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
	O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
	FROM AT2007 
	INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
	INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
	LEFT JOIN AT1304 ON AT1304.UnitID = AT2007.UnitID AND AT1304.DivisionID = AT2007.DivisionID
	LEFT JOIN AT1202 ON AT1202.ObjectID = AT2006.ObjectID AND AT1202.DivisionID = AT2007.DivisionID
	LEFT JOIN WT8899 O99 ON O99.DivisionID = AT2007.DivisionID AND O99.VoucherID = AT2007.VoucherID AND O99.TransactionID = AT2007.TransactionID
	WHERE AT2007.DivisionID = ''' + @DivisionID + ''' 
	AND AT2006.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''' 
	AND AT2007.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
	AND AT2006.WareHouseID LIKE N''' + @WareHouseID + '''
	AND AT2006.KindVoucherID IN ' + @KindVoucherListIm + ' 

	UNION ALL
	'
		SET @SQL2 = N'
	-- Phần xuất kho
	SELECT
	AT2007.VoucherID, 
	''T06'' AS TransactionTypeID, 
	AT2007.TransactionID, 
	AT2007.Orders, 
	AT2006.VoucherDate, 
	AT2006.VoucherNo, 
	Null AS ImVoucherDate, 
	Null AS ImVoucherNo, 
	Null AS ImSourceNo, 
	Null AS ImLimitDate, 
	Null AS ExWareHouseID, 
	Null AS ImQuantity, 
	Null AS ImUnitPrice, 
	Null AS ImConvertedAmount, 
	Null AS ImOriginalAmount, 
	Null AS ImConvertedQuantity, 
	AT2006.VoucherDate AS ExVoucherDate, 
	AT2006.VoucherNo AS ExVoucherNo, 
	AT2007.SourceNo AS ExSourceNo, 
	AT2007.LimitDate AS ExLimitDate, 
	(CASE WHEN AT2006.KindVoucherID = 3 THEN AT2006.WareHouseID2 ELSE AT2006.WareHouseID END) AS ExWareHouseID, 
	AT2007.ActualQuantity AS ExQuantity, 
	AT2007.UnitPrice AS ExUnitPrice, 
	AT2007.ConvertedAmount AS ExConvertedAmount, 
	AT2007.OriginalAmount AS ExOriginalAmount, 
	ISNULL(AT2007.ConversionFactor, 1) * AT2007.ActualQuantity AS ExConvertedQuantity, 
	AT2006.VoucherTypeID, 
	AT2006.Description, 
	AT2007.Notes, 
	AT2007.InventoryID, 
	AT1302.InventoryName, 
	AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, 
	AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, 
	AT2007.UnitID, AT1304.UnitName, 
	ISNULL(AT2007.ConversionFactor, 1) AS ConversionFactor, AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID
	,AT2006.RefNo01,
	AT2006.RefNo02,
	AT2007.RefInfor,
	O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
	O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
	FROM AT2007 
	INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
	INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
	LEFT JOIN AT1304 ON AT1304.UnitID = AT2007.UnitID AND AT1304.DivisionID = AT2007.DivisionID
	LEFT JOIN AT1202 ON AT1202.ObjectID = AT2006.ObjectID AND AT1202.DivisionID = AT2007.DivisionID
	LEFT JOIN WT8899 O99 ON O99.DivisionID = AT2007.DivisionID AND O99.VoucherID = AT2007.VoucherID AND O99.TransactionID = AT2007.TransactionID
	WHERE AT2007.DivisionID = ''' + @DivisionID + ''' 
	AND AT2006.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''' 
	AND AT2007.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + '''
	AND KindVoucherID IN ' + @KindVoucherListEx1 + ' 
	AND ((KindVoucherID IN ' + @KindVoucherListEx2 + ' AND WareHouseID LIKE ''' + @WareHouseID + ''') 
		OR (KindVoucherID = 3 AND WareHouseID2 LIKE ''' + @WareHouseID + ''')) 
	'
		END

--PRINT @SQL1
--PRINT @SQL2
	IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV3028_QC')
		EXEC('CREATE VIEW AV3028_QC -- Tạo bởi AP3018_QC
			AS ' + @SQL1 + @SQL2)
	ELSE
		EXEC('ALTER VIEW AV3028_QC -- Tạo bởi AP3018_QC
		AS ' + @SQL1 + @SQL2)

	--- Lay du su va phat sinh
	SET @SQL1 = N'
	SELECT 
	''' + @WareHouseID + ''' AS WareHouseID, 
	N''' + @WareHouseName + ''' AS WareHouseName, 
	AV3028.VoucherID, 
	AV3028.TransactionTypeID, 
	AV3028.TransactionID, 
	AV3028.Orders, 
	AV3028.VoucherDate, 
	AV3028.VoucherNo, 
	AV3028.ImVoucherDate, 
	AV3028.ImVoucherNo, 
	AV3028.ImSourceNo, 
	AV3028.ImLimitDate, 
	ISNULL(AV3028.ImQuantity, 0) AS ImQuantity, 
	AV3028.ImUnitPrice, 
	ISNULL(AV3028.ImConvertedAmount, 0) AS ImConvertedAmount, 
	ISNULL(AV3028.ImOriginalAmount, 0) AS ImOriginalAmount, 
	ISNULL(AV3028.ImConvertedQuantity, 0) AS ImConvertedQuantity, 
	AV3028.ExVoucherDate, 
	AV3028.ExVoucherNo, 
	AV3028.ExSourceNo, 
	AV3028.ExLimitDate, 
	ISNULL(AV3028.ExQuantity, 0) AS ExQuantity, 
	AV3028.ExUnitPrice, 
	ISNULL(AV3028.ExConvertedAmount, 0) AS ExConvertedAmount, 
	AV3028.ExOriginalAmount, 
	AV3028.ExConvertedQuantity, 
	AV3028.VoucherTypeID, 
	AV3028.Description, 
	AV3028.Notes, 
	ISNULL(AV3028.InventoryID, AV7005.InventoryID) AS InventoryID, 
	ISNULL(AV3028.InventoryName, AV7005.InventoryName) AS InventoryName, 
	ISNULL(AV3028.Specification, AV7005.Specification) AS Specification, 
	ISNULL(AV3028.Notes01, AV7005.Notes01) AS Notes01, 
	ISNULL(AV3028.Notes02, AV7005.Notes02) AS Notes02, 
	ISNULL(AV3028.Notes03, AV7005.Notes03) AS Notes03, 
	AV3028.Ana01ID, AV3028.Ana02ID, AV3028.Ana03ID, AV3028.Ana04ID, AV3028.Ana05ID, 
	ISNULL(AV3028.UnitID, AV7005.UnitID) AS UnitID, 
	ISNULL(AV3028.UnitName, AV7005.UnitName) AS UnitName, 
	ISNULL(AV7005.BeginQuantity, 0) AS BeginQuantity, 
	AV3028. ConversionFactor, AV3028.ObjectID, AV3028.ObjectName, ''' + @DivisionID + ''' AS DivisionID
	,AV3028.RefNo01,
	AV3028.RefNo02,
	AV3028.RefInfor,
	AV3028.S01ID,AV3028.S02ID,AV3028.S03ID,AV3028.S04ID,AV3028.S05ID,AV3028.S06ID,AV3028.S07ID,AV3028.S08ID,AV3028.S09ID,AV3028.S10ID,
	AV3028.S11ID,AV3028.S12ID,AV3028.S13ID,AV3028.S14ID,AV3028.S15ID,AV3028.S16ID,AV3028.S17ID,AV3028.S18ID,AV3028.S19ID,AV3028.S20ID
	'
	SET @SQL2 = '	
	FROM AV3028_QC AV3028
	FULL JOIN AV7005 ON AV7005.InventoryID = AV3028.InventoryID AND AV7005.DivisionID = AV3028.DivisionID AND
						Isnull(AV3028.S01ID,'''') = Isnull(AV7005.S01ID,'''') AND
						Isnull(AV3028.S02ID,'''') = Isnull(AV7005.S02ID,'''') AND
						Isnull(AV3028.S03ID,'''') = Isnull(AV7005.S03ID,'''') AND
						Isnull(AV3028.S04ID,'''') = Isnull(AV7005.S04ID,'''') AND
						Isnull(AV3028.S05ID,'''') = Isnull(AV7005.S05ID,'''') AND
						Isnull(AV3028.S06ID,'''') = Isnull(AV7005.S06ID,'''') AND
						Isnull(AV3028.S07ID,'''') = Isnull(AV7005.S07ID,'''') AND
						Isnull(AV3028.S08ID,'''') = Isnull(AV7005.S08ID,'''') AND
						Isnull(AV3028.S09ID,'''') = Isnull(AV7005.S09ID,'''') AND
						Isnull(AV3028.S10ID,'''') = Isnull(AV7005.S10ID,'''') AND
						Isnull(AV3028.S11ID,'''') = Isnull(AV7005.S11ID,'''') AND
						Isnull(AV3028.S12ID,'''') = Isnull(AV7005.S12ID,'''') AND
						Isnull(AV3028.S13ID,'''') = Isnull(AV7005.S13ID,'''') AND
						Isnull(AV3028.S14ID,'''') = Isnull(AV7005.S14ID,'''') AND
						Isnull(AV3028.S15ID,'''') = Isnull(AV7005.S15ID,'''') AND
						Isnull(AV3028.S16ID,'''') = Isnull(AV7005.S16ID,'''') AND
						Isnull(AV3028.S17ID,'''') = Isnull(AV7005.S17ID,'''') AND
						Isnull(AV3028.S18ID,'''') = Isnull(AV7005.S18ID,'''') AND
						Isnull(AV3028.S19ID,'''') = Isnull(AV7005.S19ID,'''') AND
						Isnull(AV3028.S20ID,'''') = Isnull(AV7005.S20ID,'''')

	WHERE ISNULL(AV3028.ImQuantity, 0) <> 0 
	OR ISNULL(AV3028.ImConvertedAmount, 0) <> 0 
	OR ISNULL(AV3028.ExQuantity, 0) <> 0 
	OR ISNULL(AV3028.ExConvertedAmount, 0) <> 0 
	OR ISNULL(AV7005.BeginQuantity, 0) <> 0 
	OR ISNULL(AV7005.BeginAmount, 0) <> 0
	'
	EXEC (@SQL1 + @SQL2)
--PRINT @SQL1
--PRINT @SQL2