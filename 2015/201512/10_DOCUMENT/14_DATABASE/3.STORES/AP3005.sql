IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3005]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP3005]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- Lay du lieu in bao cao nhap xuart ton FIFO  !
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: Nguyen Thi Thuy Tuyen - Creadate:16/06/2006
----Edited by Nguyen Quoc Huy, Date: 06/11/2006
----Edited by: [GS] [Hoàng Phước] [28/07/2010]
----Edited by Bao Anh	Date: 01/11/2012 -- Purpose: Bo sung customize bao cao ton kho theo quy cach cho 2T (goi AP3005_2T)
----Modified by Thanh Sơn on 15/07/2014: Chuyển lấy dữ liệu trực tiếp từ store, không sinh ra view AV3005
-- <Example>
/*
    AP3005 'AS',4,4,2012,2012,'01/01/2012','04/25/2012','K01','K99','0000000001','0000000001',0
*/


CREATE PROCEDURE AP3005
(
	@DivisionID VARCHAR(50),		
	@FromMonth INT,
	@ToMonth INT,
	@FromYear INT,
	@ToYear INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@FromWareHouseID NVARCHAR(50),
	@ToWareHouseID VARCHAR(50),
	@FromInventoryID NVARCHAR(50),
	@ToInventoryID NVARCHAR(50),		
	@IsDate TINYINT
)
AS

DECLARE @CustomerName INT 
---- Tao bang tam de kiem tra day co phai la khach hang 2T khong (CustomerName = 15)
CREATE Table #CustomerName (CustomerName INT, ImportExcel INT)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

IF @CustomerName = 15 --- Customize 2T
	EXEC AP3005_2T @DivisionID, @FromMonth, @ToMonth, @FromYear, @ToYear, @FromDate, @ToDate, @FromWareHouseID, @ToWareHouseID, @FromInventoryID, @ToInventoryID, @IsDate
ELSE
	BEGIN
		DECLARE @sSQL1 NVARCHAR(MAX),
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

		IF @IsDate = 0 --- theo ky 
			BEGIN
		--Tao veiw AV3001- So du dau ky
				SET   @sSQL1 = N'
SELECT DISTINCT	AT0114.InventoryID, AT1302.InventoryName, ReVoucherNo VoucherNo, ReVoucherDate VoucherDate, 
	ReQuantity = AT0114.ReQuantity - ISNULL((SELECT SUM(PriceQuantity) FROM AT0115 
	                                         WHERE TranMonth + TranYear*100   < '+@FromMonthYearText+'
											 AND ReTransactionID = AT0114.ReTransactionID And DivisionID = AT0115.DivisionID), 0),
	ReAmount = Av3004.ConvertedAmount  - ISNULL((SELECT SUM(ConvertedAmount) FROM AT0115 
	                                             WHERE TranMonth + TranYear*100   < '+@FromMonthYearText+'
												 AND ReTransactionID = AT0114.ReTransactionID And DivisionID = AT0114.DivisionID), 0),
	AT0114.UnitPrice ReUnitPrice, NULL DeQuantity, NULL DeUnitPice, NULL FromVoucherNo , NULL FromVoucherDate,
	AT0114.WareHouseID, AV3004.UnitID,  AV3004.CurrencyID, AV3004.ExchangeRate, AT1302.Specification, AT1302.Notes01,
	AT1302.Notes02, AT1302.Notes03, Notes, AT0114.ReTransactionID TransactionID, AT0114.DivisionID '
	
				SET @sSQL2 = N'
FROM AT0114
	LEFT JOIN AV3004 ON AV3004.VoucherID = AT0114.ReVoucherID AND AV3004.TransactionID = AT0114.ReTransactionID AND AV3004.DivisionID = AT0114.DivisionID
	INNER JOIN AT1302 ON AT1302.InventoryID = AT0114.InventoryID AND AT1302.DivisionID = AT0114.DivisionID			 		
WHERE AT0114.DivisionID ='''+@DivisionID+'''
	AND (AT0114.InventoryID BETWEEN '''+@FromInventoryID+''' AND ''' + @ToInventoryID + ''')
	AND (ReTranMonth + ReTranYear*100 < ''' + @FromMonthYearText +''' OR TransactionTypeID =''T00'')
	AND (AT0114.WareHouseID BETWEEN '''+@FromWareHouseID+''' AND ''' + @ToWareHouseID + ''')'
		
			END
		ELSE
			BEGIN
				SET @sSQL1 = N'
SELECT DISTINCT	AT0114.InventoryID, AT1302.InventoryName, ReVoucherNo VoucherNo, ReVoucherDate VoucherDate, 
	ReQuantity = ReQuantity - ISNULL((SELECT SUM(PriceQuantity) FROM AT0115 
	                                  WHERE VoucherDate  < '''+ @FromDateText +''' 
									  AND ReTransactionID = AT0114.ReTransactionID And DivisionID = AT0115.DivisionID), 0),
	ReAmount = AV3004.ConvertedAmount  - ISNULL((SELECT SUM(ConvertedAmount) FROM AT0115 
	                                             WHERE VoucherDate  < '''+ @FromDateText +''' 
												 AND ReTransactionID = AT0114.ReTransactionID AND DivisionID = AT0114.DivisionID), 0),
	AT0114.UnitPrice ReUnitPrice, NULL DeQuantity, NULL DeUnitPice, NULL FromVoucherNo, NULL FromVoucherDate,
	AT0114.WareHouseID, AV3004.UnitID, AV3004.CurrencyID, AV3004.ExchangeRate, AT1302.Specification, AT1302.Notes01,
	AT1302.Notes02, AT1302.Notes03, Notes, AT0114.ReTransactionID TransactionID, AT0114.DivisionID '
			
				SET @sSQL2 = N'
FROM AT0114
	LEFT JOIN AV3004 ON AV3004.VoucherID = AT0114.ReVoucherID AND AV3004.TransactionID = AT0114.ReTransactionID AND AV3004.DivisionID = AT0114.DivisionID
	INNER JOIN AT1302 ON AT1302.InventoryID = AT0114.InventoryID AND AT1302.DivisionID =AT0114.DivisionID
WHERE AT0114.DivisionID ='''+@DivisionID+'''
AND (AT0114.InventoryID BETWEEN '''+@FromInventoryID+''' AND ''' + @ToInventoryID + ''')
AND (AT0114.ReVoucherDate <'''+@FromDateText+''' or TransactionTypeID =''T00'' )
AND (AT0114.WareHouseID BETWEEN '''+@FromWareHouseID+''' AND ''' + @ToWareHouseID + ''')'
			END
			
IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Xtype ='V' AND Name ='AV3001') EXEC ('CREATE VIEW AV3001 AS '+ @sSQL1+  @sSQL2)----tao boi AP3005----
ELSE EXEC('ALTER VIEW AV3001 AS '+@sSQL1+  @sSQL2) ----tao boi AP3005----

-----------Tao View AV3002 -Phat sinh trong ky
		 IF @Isdate = 0    -- theo ngày
			BEGIN
				SET @sSQL1 = N'
SELECT DISTINCT	AT0114.InventoryID, AT1302.InventoryName, AT0114.ReVoucherNo VoucherNo, AT0114.ReVoucherDate VoucherDate,
	ReQuantity, AT0114.UnitPrice ReUnitPrice, PriceQuantity DeQuantity, AT0115.UnitPrice DeUnitPice, AT2007.OriginalAmount,
	AT2007.ConvertedAmount, NULL FromVoucherNo, NULL FromVoucherDate, AT0114.WareHouseID, AT2007.UnitID,CurrencyID,ExchangeRate,
	AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, Notes,  AT0114.ReTransactionID TransactionID, AT0114.DivisionID '		
		
			 SET @sSQL2= N'
FROM AT0114
	LEFT JOIN AT0115 ON AT0115.TransactionID = AT0114.ReTransactionID AND AT0115.DivisionID = AT0114.DivisionID
	INNER JOIN AT2007 ON AT2007.VoucherID = AT0114.ReVoucherID AND AT2007.DivisionID = AT0114.DivisionID AND AT2007.TransactionID = AT0114.ReTransactionID 
	INNER JOIN AT1302 on AT1302.InventoryID = AT0114.InventoryID AND AT1302.DivisionID = AT0114.DivisionID
WHERE AT0114.DivisionID = '''+@DivisionID+'''
	AND (AT0114.InventoryID BETWEEN '''+@FromInventoryID+''' AND ''' + @ToInventoryID + ''')
	AND (ReTranMonth + ReTranYear*100 BETWEEN ''' + @FromMonthYearText + ''' AND ''' +	@ToMonthYearText + ''')
	AND (AT0114.WareHouseID BETWEEN '''+@FromWareHouseID+''' AND ''' + @ToWareHouseID + ''')	
UNION ALL'
			SET @sSQL3 = N'
SELECT DISTINCT	AT0115.InventoryID, AT1302.InventoryName, VoucherNo DeVoucherNo, VoucherDate DeVoucherDate, NULL ReQuantity,
	NULL ReUnitPrice, PriceQuantity DeQuantity, AT0115.UnitPrice DeUnitPice, NULL OriginalAmount, NULL ConvertedAmount,
	AT0115.ReVoucherNo FromVoucherNo, AT0115.ReVoucherDate FromVoucherDate, AT0115.WareHouseID, AT2007. UnitID,CurrencyID,
	ExchangeRate, AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, Notes,  AT0115.TransactionID, AT0115.DivisionID '
			 SET @sSQL4 = N'
FROM AT0115
	LEFT JOIN AT2007 ON AT2007.VoucherID = AT0115.ReVoucherID AND AT2007.TransactionID = AT2007.RETransactionID AND AT2007.DivisionId = AT2007.DivisionId
	INNER JOIN AT1302 ON AT1302.InventoryID = AT0115.InventoryID And AT1302.DivisionID = AT0115.DivisionID
	WHERE AT0115.DivisionID = '''+@DivisionID+'''
	AND (AT0115.InventoryID BETWEEN '''+@FromInventoryID+''' AND ''' + @ToInventoryID + ''')
	AND (AT0115.TranMonth + AT0115.TranYear*100 BETWEEN '''+ @FromMonthYearText + ''' AND ''' + @ToMonthYearText + ''') 
	AND (AT0115.WareHouseID between '''+@FromWareHouseID+'''  AND ''' + @ToWareHouseID + ''')'
			END
		ELSE
			BEGIN
				SET @sSQL1 = N'
SELECT DISTINCT	AT0114.InventoryID, AT1302.InventoryName, AT0114.ReVoucherNo VoucherNo, AT0114.ReVoucherDate VoucherDate,
	ReQuantity, AT0114.UnitPrice ReUnitPrice, PriceQuantity DeQuantity, AT0115.UnitPrice DeUnitPice, AT2007.OriginalAmount,
	AT2007.ConvertedAmount, NULL FromVoucherNo, NULL FromVoucherDate, AT0114.WareHouseID, AT2007.UnitID, CurrencyID,ExchangeRate,
	AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, Notes, AT0114.ReTransactionID as TransactionID, AT0114.DivisionID '
				SET @sSQL2 = N'
FROM AT0114
	LEFT JOIN AT0115 ON AT0115.TransactionID = AT0114.ReTransactionID AND AT0115.DivisionID = AT0114.DivisionID
	INNER JOIN AT2007 ON AT2007.VoucherID = AT0114.ReVoucherID AND AT2007.DivisionID = AT0114.DivisionID AND AT2007.TransactionID = AT0114.ReTransactionID 
	INNER JOIN AT1302 ON AT1302.InventoryID = AT0114.InventoryID AND AT1302.DivisionID = AT0114.DivisionID
WHERE AT0114.DivisionID = '''+@DivisionID+'''
	AND (AT0114.InventoryID BETWEEN '''+@FromInventoryID+''' AND ''' + @ToInventoryID + ''')
	AND (AT0114.ReVoucherDate BETWEEN '''+@FromDateText+'''  AND '''+@ToDateText+''')
	AND (AT0114.WareHouseID between '''+@FromWareHouseID+''' AND ''' + @ToWareHouseID + ''')	 
UNION ALL'
				SET @sSQL3 = N'
SELECT AT0115.InventoryID, AT1302.InventoryName, VoucherNo DeVoucherNo, VoucherDate DeVoucherDate, NULL ReQuantity,
	NULL ReUnitPrice, PriceQuantity DeQuantity, AT0115.UnitPrice DeUnitPice, NULL OriginalAmount, NULL ConvertedAmount,
	AT0115.ReVoucherNo FromVoucherNo, AT0115.ReVoucherDate FromVoucherDate, AT0115.WareHouseID, AT2007.UnitID, CurrencyID,
	ExchangeRate, AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, Notes, AT0115.TransactionID, AT0115.DivisionID '
				SET @sSQL4 = N'
FROM AT0115
	LEFT JOIN AT2007 ON AT2007.VoucherID = AT0115.ReVoucherID AND AT2007.TransactionID = AT2007.RETransactionID AND AT2007.DivisionID = AT2007.DivisionID
	INNER JOIN AT1302 ON AT1302.InventoryID = AT0115.InventoryID AND AT1302.DivisionID =AT0115.DivisionID
WHERE AT0115.DivisionID = '''+@DivisionID+'''
	AND (AT0115.InventoryID BETWEEN '''+@FromInventoryID+''' AND ''' + @ToInventoryID + ''')
	AND (AT0115.VoucherDate Between '''+@FromDateText+'''  AND  '''+@ToDateText+''')
	AND (AT0115.WareHouseID between '''+@FromWareHouseID+'''  AND ''' + @ToWareHouseID + ''')'			
			END
--Print @sSQL1+@sSQL2+@sSQL3+@sSQL4
		
IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Xtype = 'V' and Name = 'AV3002') EXEC ('CREATE VIEW AV3002 AS '+ @sSQL1+@sSQL2+@sSQL3+@sSQL4 ) ----tao boi AP3005----
ELSE EXEC ('ALTER VIEW AV3002 AS ' + @sSQL1 + @sSQL2 + @sSQL3 + @sSQL4) ----tao boi AP3005----
-----Tao Veiw AV3003 --Ton cuoi ky
		IF @IsDate = 0
			BEGIN
				SET @sSQL1= N'
SELECT DISTINCT	AT0114.InventoryID, AT1302.InventoryName, ReVoucherNo VoucherNo, ReVoucherDate VoucherDate,
	ReQuantity = ReQuantity - ISNULL((SELECT SUM(PriceQuantity) FROM AT0115 
	                                  WHERE TranMonth + TranYear * 100 <= '+@ToMonthYearText+'
	                                  AND ReTransactionID = AT0114.ReTransactionID 
	                                  AND DivisionID = AT0115.DivisionID), 0),
	AT0114.UnitPrice ReUnitPrice, ReAmount = AV3004.ConvertedAmount  - ISNULL((SELECT SUM(ConvertedAmount) FROM AT0115
	                                                                           WHERE TranMonth + TranYear * 100 <= '+@ToMonthYearText+'
																			   AND ReTransactionID = AT0114.ReTransactionID
																			   AND DivisionID = AT0115.DivisionID), 0),			
	NULL DeQuantity, NULL DeUnitPice, NULL FromVoucherNo, NULL FromVoucherDate, AT0114.WareHouseID, AV3004.UnitID, AV3004.CurrencyID,
	AV3004.ExchangeRate, AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, Notes, AT0114.ReTransactionID as TransactionID, AT0114.DivisionID '
				SET @sSQL2 = N'
FROM AT0114
LEFT JOIN AV3004 ON AV3004.VoucherID = AT0114.ReVoucherID AND TransactionID = AT0114.ReTransactionID AND AV3004.DivisionID = AT0114.DivisionID
INNER JOIN AT1302 ON AT1302.InventoryID =AT0114.InventoryID AND AT1302.DivisionID =AT0114.DivisionID 	
WHERE AT0114.DivisionID = '''+@DivisionID+'''
AND (AT0114.InventoryID BETWEEN '''+@FromInventoryID+''' AND ''' + @ToInventoryID + ''')
AND (ReTranMonth + ReTranYear*100 <= ''' +	@ToMonthYearText + ''' OR TransactionTypeID =''T00'')
AND (AT0114.WareHouseID BETWEEN '''+@FromWareHouseID+''' AND ''' + @ToWareHouseID + ''')'		
			END
		ELSE
			BEGIN
				SET @sSQL1 = N'
SELECT DISTINCT	AT0114.InventoryID, AT1302.InventoryName, ReVoucherNo VoucherNo, ReVoucherDate VoucherDate,
	ReQuantity = ReQuantity - ISNULL((SELECT SUM(PriceQuantity) FROM AT0115
	                                  WHERE VoucherDate <= '''+ @ToDateText +'''
	                                  AND ReTransactionID = AT0114.ReTransactionID And DivisionID = AT0115.DivisionID), 0),
	AT0114.UnitPrice ReUnitPrice, ReAmount = AV3004.ConvertedAmount  - ISNULL((SELECT SUM(ConvertedAmount) FROM AT0115 
	                                                                           WHERE VoucherDate <= '''+ @ToDateText +'''
	                                                                           AND ReTransactionID = AT0114.ReTransactionID
	                                                                           AND DivisionID = AT0115.DivisionID), 0),
	NULL DeQuantity, NULL DeUnitPice, NULL FromVoucherNo, NULL FromVoucherDate, AT0114.WareHouseID, AV3004.UnitID,
	AV3004.CurrencyID, AV3004.ExchangeRate, AT1302.Specification, AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,
	Notes, AT0114.ReTransactionID TransactionID, AT0114.DivisionID '			
				 SET @sSQL2 = N'
FROM AT0114
	LEFT JOIN AV3004 ON AV3004.VoucherID = AT0114.ReVoucherID AND TransactionID = AT0114.ReTransactionID AND AV3004.DivisionID = AT0114.DivisionID
	INNER JOIN AT1302 ON AT1302.InventoryID = AT0114.InventoryID AND AT1302.DivisionID = AT0114.DivisionID
WHERE AT0114.DivisionID ='''+@DivisionID+'''
	AND (AT0114.InventoryID BETWEEN '''+@FromInventoryID+''' AND ''' + @ToInventoryID + ''')
	AND ( AT0114.ReVoucherDate <= '''+@ToDateText+''' OR TransactionTypeID = ''T00'' )
	AND (AT0114.WareHouseID BETWEEN '''+@FromWareHouseID+''' AND  ''' + @ToWareHouseID + ''')' 
			END
IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV3003') EXEC ('CREATE VIEW AV3003 AS '+ @sSQL1+@sSQL2 ) ----tao boi AP3005----
ELSE EXEC ('ALTER VIEW AV3003 AS ' + @sSQL1 + @sSQL2) ----tao boi AP3005----
---Print  @sSQL1+@sSQL2

SET @sSQL1 = N'
SELECT 1 [Type], InventoryID, InventoryName, VoucherNo, VoucherDate, ReQuantity, ReUnitPrice, NULL OriginalAmount, 
	ReAmount ConvertedAmount, DeQuantity, DeUnitPice, CAST(FromVoucherNo AS NVARCHAR(20)) AS FromVoucherNo, FromVoucherDate, 
	WareHouseID, UnitID, CurrencyID, ExchangeRate, Specification, Notes01, Notes02, Notes03, Notes, TransactionID, DivisionID'
	
SET @sSQL2 = N'
FROM AV3001
WHERE ReQuantity > 0
UNION ALL
SELECT 2 [Type], InventoryID, InventoryName, VoucherNo,VoucherDate, ReQuantity, ReUnitPrice,  OriginalAmount,ConvertedAmount, 
	DeQuantity, DeUnitPice ,FromVoucherNo , FromVoucherDate, WareHouseID, UnitID, CurrencyID, ExchangeRate, Specification,
	Notes01, Notes02, Notes03, Notes, TransactionID, DivisionIDFROM AV3002
UNION ALL'
SET @sSQL3 = N'
SELECT 3 [Type], InventoryID, InventoryName, VoucherNo, VoucherDate, ReQuantity, ReUnitPrice, NULL OriginalAmount, ReAmount ConvertedAmount,  
	DeQuantity, DeUnitPice, CAST(FromVoucherNo AS NVARCHAR(20)) AS FromVoucherNo , FromVoucherDate, WareHouseID, UnitID, CurrencyID, ExchangeRate, 
	Specification, Notes01, Notes02, Notes03, Notes ,TransactionID, DivisionID
FROM AV3003
WHERE ReQuantity > 0 '

EXEC (@sSQL1+ @sSQL2 + @sSQL3)
		--If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='AV3005')
		--	Exec(' Create view AV3005 as '+ @sSQL1+ @sSQL2 + @sSQL3 ) ----tao boi AP3005----
		--Else
		--	Exec(' Alter view AV3005 as '+@sSQL1+ @sSQL2 + @sSQL3) ----tao boi AP3005----
	END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
