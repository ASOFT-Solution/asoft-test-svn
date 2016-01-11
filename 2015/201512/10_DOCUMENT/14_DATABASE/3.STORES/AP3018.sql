/****** Object:  StoredProcedure [dbo].[AP3018]    Script Date: 02/01/2012 10:25:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP3018]') AND type IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP3018]
GO
/****** Object: StoredProcedure [dbo].[AP3018] Script Date: 08/02/2010 11:02:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Create by Nguyen Van Nhan, Date 08/08/2003
---- Purpose: IN the kho (tuong tu So chi tiet vat tu)
---- Edited by Nguyen Quoc Huy, Date 24/08/2006
---- Edit by: Dang Le Bao Quynh; Date: 05/01/2009
---- Purpose: Them truong ObjectID
---- Edit by: Dang Le Bao Quynh; Date: 16/01/2009
---- Purpose: Bo sung truong hop xuat hang mua tra lai
---- Edit by: Tan Phu, date: 29/082012
---- Purpose: 0018241: [TIENTIEN] bổ sung trường tham chiếu 1, tham chiếu 2 vào view av3018 (report AR3018)
---- Modified on 08/10/2012 by Bao Anh : Customize cho 2T (the kho theo quy cách), gọi AP3088
---- Modified on 08/07/2014 by Bảo Anh: 1/ Trả trực tiếp dữ liệu, không tạo view AV3018
----									2/ Bỏ điều kiện SUM(SignAmount) <> 0 khi tạo AV7005 (in theo ngày)
---- Modified by Tiểu Mai on 11/01/2016: Bổ sung trường hợp quản lý hàng theo quy cách.
/********************************************
'* Edited BY: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/
-- AP3018 'KC','a','b','c',1,1,1,1,'','',1
CREATE PROCEDURE [dbo].[AP3018] 
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

DECLARE @CustomerName INT
--Tao bang tam de kiem tra day co phai la khach hang 2T khong (CustomerName = 15)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
	EXEC AP3018_QC @DivisionID, @WareHouseID, @FromInventoryID, @ToInventoryID, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate, @IsDate
ELSE
BEGIN

IF @CustomerName = 15 --- Customize 2T
	EXEC AP3088 @DivisionID, @WareHouseID, @FromInventoryID, @ToInventoryID, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate, @IsDate
ELSE
	BEGIN
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
		AT2008.InventoryID, 
		AT1302.InventoryName, 
		AT1302.UnitID, 
		AT1304.UnitName, 
		AT1302.Specification, 
		AT1302.Notes01, 
		AT1302.Notes02, 
		AT1302.Notes03, 
		SUM(AT2008.BeginQuantity) AS BeginQuantity, 
		SUM(AT2008.EndQuantity) AS EndQuantity, 
		SUM(AT2008.BeginAmount) AS BeginAmount, 
		SUM(AT2008.EndAmount) AS EndAmount, 
		AT2008.DivisionID

		FROM AT2008 
		INNER JOIN AT1302 ON AT1302.InventoryID = AT2008.InventoryID AND AT1302.DivisionID = AT2008.DivisionID
		INNER JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = AT2008.DivisionID

		WHERE AT2008.DivisionID LIKE ''' + @DivisionID + ''' 
		AND AT2008.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
		AND AT2008.TranMonth + AT2008.TranYear * 100 = ' + @FromMonthYearText + ' 
		AND AT2008.WareHouseID LIKE N''' + @WareHouseID + ''' 

		GROUP BY 
		AT2008.InventoryID, AT1302.InventoryName, AT1302.UnitID, AT1304.UnitName, 
		AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, AT2008.DivisionID

		HAVING SUM(AT2008.BeginQuantity) <> 0 OR SUM(AT2008.EndQuantity) <> 0 
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
		DivisionID

		FROM AV7000
		WHERE DivisionID LIKE ''' + @DivisionID + ''' 
		AND InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''' 
		AND ((D_C IN (''D'', ''C'') AND VoucherDate < ''' + @FromDateText + ''') OR D_C = ''BD'' ) 
		AND WareHouseID LIKE N''' + @WareHouseID + ''' 

		GROUP BY 
		InventoryID, InventoryName, UnitID, UnitName, Specification, Notes01, Notes02, Notes03, DivisionID

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
		AT2007.RefInfor
		FROM AT2007 
		INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
		INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1304 ON AT1304.UnitID = AT2007.UnitID AND AT1304.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1202 ON AT1202.ObjectID = AT2006.ObjectID AND AT1202.DivisionID = AT2007.DivisionID

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
		AT2007.RefInfor
		FROM AT2007 
		INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
		INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1304 ON AT1304.UnitID = AT2007.UnitID AND AT1304.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1202 ON AT1202.ObjectID = AT2006.ObjectID AND AT1202.DivisionID = AT2007.DivisionID

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
		AT2007.RefInfor
		FROM AT2007 
		INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
		INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1304 ON AT1304.UnitID = AT2007.UnitID AND AT1304.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1202 ON AT1202.ObjectID = AT2006.ObjectID AND AT1202.DivisionID = AT2007.DivisionID

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
		AT2007.RefInfor
		FROM AT2007 
		INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
		INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1304 ON AT1304.UnitID = AT2007.UnitID AND AT1304.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1202 ON AT1202.ObjectID = AT2006.ObjectID AND AT1202.DivisionID = AT2007.DivisionID

		WHERE AT2007.DivisionID = ''' + @DivisionID + ''' 
		AND AT2006.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''' 
		AND AT2007.InventoryID BETWEEN N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + '''
		AND KindVoucherID IN ' + @KindVoucherListEx1 + ' 
		AND ((KindVoucherID IN ' + @KindVoucherListEx2 + ' AND WareHouseID LIKE ''' + @WareHouseID + ''') 
			OR (KindVoucherID = 3 AND WareHouseID2 LIKE ''' + @WareHouseID + ''')) 
		'
			END

		IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV3028')
			EXEC('CREATE VIEW AV3028 -- Tạo bởi AP3018
				AS ' + @SQL1 + @SQL2)
		ELSE
			EXEC('ALTER VIEW AV3028 -- Tạo bởi AP3018
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
		AV3028.RefInfor
		FROM AV3028 
		FULL JOIN AV7005 ON AV7005.InventoryID = AV3028.InventoryID AND AV7005.DivisionID = AV3028.DivisionID

		WHERE ISNULL(AV3028.ImQuantity, 0) <> 0 
		OR ISNULL(AV3028.ImConvertedAmount, 0) <> 0 
		OR ISNULL(AV3028.ExQuantity, 0) <> 0 
		OR ISNULL(AV3028.ExConvertedAmount, 0) <> 0 
		OR ISNULL(AV7005.BeginQuantity, 0) <> 0 
		OR ISNULL(AV7005.BeginAmount, 0) <> 0
		'
		EXEC (@SQL1)
		/*
		IF NOT EXISTS (SELECT 1 FROM SysObjects WHERE Xtype='V' AND Name ='AV3018')
			EXEC('CREATE VIEW AV3018 AS -- Tạo bởi AP3018
				' + @SQL1)
		ELSE
			EXEC('ALTER VIEW AV3018 AS -- Tạo bởi AP3018
				' + @SQL1)
		*/
	END
	
END	