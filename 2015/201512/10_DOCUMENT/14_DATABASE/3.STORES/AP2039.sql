IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2039]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP2039]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Created by Tieu Mai, Date 06/11/2015.
---- Purpose: So chi tiet vat lieu (san pham, hang hoa) theo quy cach - dung cho nhat ky so cai


CREATE PROCEDURE [dbo].[AP2039]
    @DivisionID AS NVARCHAR(50), 
    @FromMonth AS INT, 
    @FromYear AS INT, 
    @ToMonth AS INT, 
    @ToYear AS INT, 
    @FromDate AS DATETIME, 
    @ToDate AS DATETIME, 
    @IsDate AS TINYINT, 
    @WareHouseID AS NVARCHAR(50), 
    @AccountID AS NVARCHAR(50),		
    @FromInventoryID AS NVARCHAR(50), 
    @ToInventoryID AS NVARCHAR(50)
AS

DECLARE
	@sSQL NVARCHAR(MAX),
    @sSQL1 AS NVARCHAR(4000), 
    @sSQL2 AS NVARCHAR(4000),
    @sSQL3 NVARCHAR(MAX),
    @sSQL4 NVARCHAR(MAX), 
    @strWhere AS NVARCHAR(4000), 
    @AT2039_Cursor AS cursor, 
    @FromDate1 AS DATETIME, 
    @ToDate1 AS DATETIME, 
    @KindVoucherListIm AS NVARCHAR(250), 
    @KindVoucherListEx1 AS NVARCHAR(250), 
    @KindVoucherListEx2 AS NVARCHAR(250), 
    @WareHouseID2 AS NVARCHAR(250), 
    @WareHouseID1 AS NVARCHAR(250), @FromDateText AS NVARCHAR(250), 
    @ToDateText AS NVARCHAR(250),
    
    @TransactionID AS NVARCHAR(50), 
    @InventoryID AS NVARCHAR(50), 
    
    @BeginQuantity AS DECIMAL(28, 8), 
    @BeginAmount AS DECIMAL(28, 8), 
    @ImQuantity AS DECIMAL(28, 8), 
    @ExQuantity AS DECIMAL(28, 8), 
    @ExConvertedAmount AS DECIMAL(28, 8), 
    @ImConvertedAmount AS DECIMAL(28, 8),
	@S01ID VARCHAR(50),
	@S02ID VARCHAR(50),
	@S03ID VARCHAR(50),
	@S04ID VARCHAR(50),
	@S05ID VARCHAR(50),
	@S06ID VARCHAR(50),
	@S07ID VARCHAR(50),
	@S08ID VARCHAR(50),
	@S09ID VARCHAR(50),
	@S10ID VARCHAR(50),
	@S11ID VARCHAR(50),
	@S12ID VARCHAR(50),
	@S13ID VARCHAR(50),
	@S14ID VARCHAR(50),
	@S15ID VARCHAR(50),
	@S16ID VARCHAR(50),
	@S17ID VARCHAR(50),
	@S18ID VARCHAR(50),
	@S19ID VARCHAR(50),
	@S20ID VARCHAR(50)

SET NOCOUNT ON

SET @KindVoucherListEx1 = ' (2, 4, 3, 8, 10, 14, 20) '
SET @KindVoucherListEx2 = ' (2, 4, 6, 8, 10, 14, 20) '
SET @KindVoucherListIm = ' (1, 3, 5, 7, 9, 15, 17) '

SET @WareHouseID2 = ' AT2006.WareHouseID '
SET @WareHouseID1 = ' CASE WHEN KindVoucherID = 3 THEN AT2006.WareHouseID2 ELSE AT2006.WareHouseID END '

IF @IsDate = 0 -- theo ky
    BEGIN
        SET @FromDate1 = LTRIM(STR(@FromMonth)) + '/01/' + LTRIM(STR(@FromYear))
        SET @ToDate1 = DATEADD(MONTH, 1, LTRIM(STR(@ToMonth)) + '/01/' + LTRIM(STR(@ToYear))) - 1
        
        SET @FromDateText = STR(@FromMonth) + ' + 100 * ' + STR(@FromYear)
        SET @ToDateText = STR(@ToMonth) + ' + 100 * ' + STR(@ToYear)
        
        SET @strWhere = ' AND (AT2006.TranMonth + AT2006.TranYear * 100 BETWEEN ' + @FromDateText + ' AND ' + @ToDateText + ')'
        EXEC AP7012 @DivisionID, @WareHouseID, @WareHouseID, @FromInventoryID, @ToInventoryID, @AccountID, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate1, @ToDate1, 0, 1
    END
ELSE IF @IsDate = 1 -- theo ngay
    BEGIN
        
        SET @FromDateText = CONVERT(NVARCHAR(10), @FromDate, 101)
        SET @ToDate = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'
        SET @ToDateText = CONVERT(NVARCHAR(10), @ToDate, 101)
                
        SET @strWhere = 'AND (AT2006.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''' ) '
        EXEC AP7012 @DivisionID, @WareHouseID, @WareHouseID, @FromInventoryID, @ToInventoryID, @AccountID, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate, 1, 1
    END
ELSE -- theo nam 
    BEGIN
        SET @FromDate1 = '01/01/' + LTRIM(STR(@FromYear))
        SET @ToDate1 = DATEADD(MONTH, 1, '01/01/' + LTRIM(STR(@ToYear))) - 1
        
        SET @FromDateText = CONVERT(NVARCHAR(10), @FromDate1, 101)
        SET @ToDateText = CONVERT(NVARCHAR(10), @ToDate1, 101)
                
        SET @strWhere = 'AND (AT2006.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''' ) '
        EXEC AP7012 @DivisionID, @WareHouseID, @WareHouseID, @FromInventoryID, @ToInventoryID, @AccountID, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate1, @ToDate1, 1, 1
    END

SET @sSQL1 = '
		--- Phan Nhap kho
		SELECT
			AT2007.DivisionID, 
			' + @WareHouseID2 + ' AS WareHouseID, 
			AT1303.WareHouseName, 
			AT2006.VoucherID, 
			AT2007.TransactionID, 
    
			CONVERT(CHAR(8), AT2006.VoucherDate, 112) + 
			(CASE WHEN AT2006.KindVoucherID IN(1, 3, 5, 7) THEN ''1'' ELSE ''2'' END) 
			+ CONVERT(CHAR(20), AT2007.InventoryID) AS Orders, 
    
			AT2006.VoucherDate, 
			AT2006.VoucherNo, 
			AV5000.AccountID, 
			AT1005.AccountName, 
			AV5000.CorAccountID, 
			AT2007.UnitPrice, 
			AT2007.ActualQuantity AS ImQuantity, 
			AT2007.ConvertedAmount AS ImConvertedAmount, 
			AT2007.OriginalAmount AS ImOriginalAmount, 
			0 AS ExQuantity, 
			0 AS ExConvertedAmount, 
			0 AS ExOriginalAmount, 
			AT2006.Description, 
			AT2007.InventoryID, 
			AT1302.InventoryName, 
			AT1302.UnitID, 
			ISNULL(AT2008.BeginQuantity, 0) AS BeginQuantity, 
			ISNULL(AT2008.BeginAmount, 0) AS BeginAmount, 
			0 AS EndQuantity, 
			0 AS EndAmount, 
			AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,
			AT2008.S01ID, AT2008.S02ID, AT2008.S03ID, AT2008.S04ID, AT2008.S05ID, AT2008.S06ID, AT2008.S07ID, AT2008.S08ID, AT2008.S09ID, AT2008.S10ID,
			AT2008.S11ID, AT2008.S12ID, AT2008.S13ID, AT2008.S14ID, AT2008.S15ID, AT2008.S16ID, AT2008.S17ID, AT2008.S18ID, AT2008.S19ID, AT2008.S20ID
		FROM AT2007
			Left join WT8899 on WT8899.DivisionID = AT2007.DivisionID and WT8899.VoucherID = AT2007.VoucherID and WT8899.TransactionID = AT2007.TransactionID 
			INNER JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
			INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
			INNER JOIN AT1303 ON AT1303.DivisionID = AT2007.DivisionID AND AT1303.WarehouseID = AT2006.WarehouseID
			'
			
	SET @sSQL3 = ' 		
			LEFT JOIN AV5002 AV5000 ON AV5000.DivisionID = AT2007.DivisionID AND AV5000.VoucherID = AT2007.VoucherID AND AV5000.TransactionID = AT2007.TransactionID AND
										isnull(WT8899.S01ID,'''') = isnull(AV5000.S01ID,'''') AND 
										isnull(WT8899.S02ID,'''') = isnull(AV5000.S02ID,'''') AND
										isnull(WT8899.S03ID,'''') = isnull(AV5000.S03ID,'''') AND
										isnull(WT8899.S04ID,'''') = isnull(AV5000.S04ID,'''') AND
										isnull(WT8899.S05ID,'''') = isnull(AV5000.S05ID,'''') AND 
										isnull(WT8899.S06ID,'''') = isnull(AV5000.S06ID,'''') AND
										isnull(WT8899.S07ID,'''') = isnull(AV5000.S07ID,'''') AND
										isnull(WT8899.S08ID,'''') = isnull(AV5000.S08ID,'''') AND
										isnull(WT8899.S09ID,'''') = isnull(AV5000.S09ID,'''') AND
										isnull(WT8899.S10ID,'''') = isnull(AV5000.S10ID,'''') AND
										isnull(WT8899.S11ID,'''') = isnull(AV5000.S11ID,'''') AND 
										isnull(WT8899.S12ID,'''') = isnull(AV5000.S12ID,'''') AND
										isnull(WT8899.S13ID,'''') = isnull(AV5000.S13ID,'''') AND
										isnull(WT8899.S14ID,'''') = isnull(AV5000.S14ID,'''') AND
										isnull(WT8899.S15ID,'''') = isnull(AV5000.S15ID,'''') AND
										isnull(WT8899.S16ID,'''') = isnull(AV5000.S16ID,'''') AND
										isnull(WT8899.S17ID,'''') = isnull(AV5000.S17ID,'''') AND
										isnull(WT8899.S18ID,'''') = isnull(AV5000.S18ID,'''') AND
										isnull(WT8899.S19ID,'''') = isnull(AV5000.S19ID,'''') AND
										isnull(WT8899.S20ID,'''') = isnull(AV5000.S20ID,'''')
			LEFT JOIN AT2008_QC AT2008 ON AT2008.DivisionID = AT2007.DivisionID AND AT2008.InventoryID = AT2007.InventoryID AND AT2008.WareHouseID = AT2006.WareHouseID AND 
										AT2008.InventoryAccountID = AT2007.DebitAccountID AND AT2008.TranMonth = AT2007.TranMonth AND AT2008.TranYear = AT2007.TranYear AND
										ISNULL(AT2008.S01ID,'''') = isnull(WT8899.S01ID,'''') AND 
										ISNULL(AT2008.S02ID,'''') = isnull(WT8899.S02ID,'''') AND
										ISNULL(AT2008.S03ID,'''') = isnull(WT8899.S03ID,'''') AND
										ISNULL(AT2008.S04ID,'''') = isnull(WT8899.S04ID,'''') AND
										ISNULL(AT2008.S05ID,'''') = isnull(WT8899.S05ID,'''') AND 
										ISNULL(AT2008.S06ID,'''') = isnull(WT8899.S06ID,'''') AND
										ISNULL(AT2008.S07ID,'''') = isnull(WT8899.S07ID,'''') AND
										ISNULL(AT2008.S08ID,'''') = isnull(WT8899.S08ID,'''') AND
										ISNULL(AT2008.S09ID,'''') = isnull(WT8899.S09ID,'''') AND
										ISNULL(AT2008.S10ID,'''') = isnull(WT8899.S10ID,'''') AND
										ISNULL(AT2008.S11ID,'''') = isnull(WT8899.S11ID,'''') AND 
										ISNULL(AT2008.S12ID,'''') = isnull(WT8899.S12ID,'''') AND
										ISNULL(AT2008.S13ID,'''') = isnull(WT8899.S13ID,'''') AND
										ISNULL(AT2008.S14ID,'''') = isnull(WT8899.S14ID,'''') AND
										ISNULL(AT2008.S15ID,'''') = isnull(WT8899.S15ID,'''') AND
										ISNULL(AT2008.S16ID,'''') = isnull(WT8899.S16ID,'''') AND
										ISNULL(AT2008.S17ID,'''') = isnull(WT8899.S17ID,'''') AND
										ISNULL(AT2008.S18ID,'''') = isnull(WT8899.S18ID,'''') AND
										ISNULL(AT2008.S19ID,'''') = isnull(WT8899.S19ID,'''') AND
										ISNULL(AT2008.S20ID,'''') = isnull(WT8899.S20ID,'''')
			INNER JOIN AT1005 ON AT1005.DivisionID = AT2007.DivisionID AND AT1005.AccountID = AV5000.AccountID							
		WHERE AT2007.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + ''')) 
			AND AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + ''' 
			AND AV5000.AccountID LIKE ''' + @AccountID + ''' 
			AND AT1005.GroupID = ''G05'' 
			AND AT2006.KindVoucherID IN ' + @KindVoucherListIm + ' 
			AND AT2006.WareHouseID LIKE ''' + @WareHouseID + ''' 
			AND AV5000.D_C = ''D''
			' + @strWhere 
    
	SET @sSQL2 = '
		--- Phan Xuat kho
		SELECT 
			AT2007.DivisionID, 
			' + @WareHouseID1 + ' AS WareHouseID, 
			AT1303.WareHouseName, 
			AT2006.VoucherID, 
			AT2007.TransactionID, 
    
			CONVERT(CHAR(8), AT2006.VoucherDate, 112) + 
			(CASE WHEN AT2006.KindVoucherID IN(1, 3, 5, 7) THEN ''1'' ELSE ''2'' END) 
			+ CONVERT(CHAR(20), AT2007.InventoryID) AS Orders, 

			AT2006.VoucherDate, 
			AT2006.VoucherNo, 
			AV5000.AccountID, 
			AT1005.AccountName, 
			AV5000.CorAccountID, 
			AT2007.UnitPrice, 
			0 AS ImQuantity, 
			0 AS ImConvertedAmount, 
			0 AS ImOriginalAmount, 
			AT2007.ActualQuantity AS ExQuantity, 
			AT2007.ConvertedAmount AS ExConvertedAmount, 
			AT2007.OriginalAmount AS ExOriginalAmount, 
			AT2006.Description, 
			AT2007.InventoryID, 
			AT1302.InventoryName, 
			AT1302.UnitID, 
			ISNULL(AT2008.BeginQuantity, 0) AS BeginQuantity, 
			ISNULL(AT2008.BeginAmount, 0) AS BeginAmount, 
			0 AS EndQuantity, 
			0 AS EndAmount, 
			AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,
			AT2008.S01ID, AT2008.S02ID, AT2008.S03ID, AT2008.S04ID, AT2008.S05ID, AT2008.S06ID, AT2008.S07ID, AT2008.S08ID, AT2008.S09ID, AT2008.S10ID,
			AT2008.S11ID, AT2008.S12ID, AT2008.S13ID, AT2008.S14ID, AT2008.S15ID, AT2008.S16ID, AT2008.S17ID, AT2008.S18ID, AT2008.S19ID, AT2008.S20ID

		FROM AT2007
			Left join WT8899 on WT8899.DivisionID = AT2007.DivisionID and WT8899.VoucherID = AT2007.VoucherID and WT8899.TransactionID = AT2007.TransactionID  
			INNER JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
			INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
			INNER JOIN AT1303 ON AT1303.DivisionID = AT2007.DivisionID AND AT1303.WareHouseID = CASE WHEN KindVoucherID = 3 THEN AT2006.WareHouseID2 ELSE AT2006.WareHouseID END'
	
		SET @sSQL4 = '		
			INNER JOIN AV5002 AV5000 ON AV5000.DivisionID = AT2007.DivisionID AND AV5000.VoucherID = AT2007.VoucherID AND AV5000.TransactionID = AT2007.TransactionID AND
										isnull(WT8899.S01ID,'''') = isnull(AV5000.S01ID,'''') AND 
										isnull(WT8899.S02ID,'''') = isnull(AV5000.S02ID,'''') AND
										isnull(WT8899.S03ID,'''') = isnull(AV5000.S03ID,'''') AND
										isnull(WT8899.S04ID,'''') = isnull(AV5000.S04ID,'''') AND
										isnull(WT8899.S05ID,'''') = isnull(AV5000.S05ID,'''') AND 
										isnull(WT8899.S06ID,'''') = isnull(AV5000.S06ID,'''') AND
										isnull(WT8899.S07ID,'''') = isnull(AV5000.S07ID,'''') AND
										isnull(WT8899.S08ID,'''') = isnull(AV5000.S08ID,'''') AND
										isnull(WT8899.S09ID,'''') = isnull(AV5000.S09ID,'''') AND
										isnull(WT8899.S10ID,'''') = isnull(AV5000.S10ID,'''') AND
										isnull(WT8899.S11ID,'''') = isnull(AV5000.S11ID,'''') AND 
										isnull(WT8899.S12ID,'''') = isnull(AV5000.S12ID,'''') AND
										isnull(WT8899.S13ID,'''') = isnull(AV5000.S13ID,'''') AND
										isnull(WT8899.S14ID,'''') = isnull(AV5000.S14ID,'''') AND
										isnull(WT8899.S15ID,'''') = isnull(AV5000.S15ID,'''') AND
										isnull(WT8899.S16ID,'''') = isnull(AV5000.S16ID,'''') AND
										isnull(WT8899.S17ID,'''') = isnull(AV5000.S17ID,'''') AND
										isnull(WT8899.S18ID,'''') = isnull(AV5000.S18ID,'''') AND
										isnull(WT8899.S19ID,'''') = isnull(AV5000.S19ID,'''') AND
										isnull(WT8899.S20ID,'''') = isnull(AV5000.S20ID,'''')
			LEFT JOIN AT2008_QC AT2008 ON AT2008.DivisionID = AT2007.DivisionID AND AT2008.InventoryID = AT2007.InventoryID AND AT2008.WareHouseID = AT2006.WareHouseID AND 
								AT2008.InventoryAccountID = AT2007.CreditAccountID AND AT2008.TranMonth = AT2007.TranMonth AND AT2008.TranYear = AT2007.TranYear AND
										ISNULL(AT2008.S01ID,'''') = isnull(WT8899.S01ID,'''') AND 
										ISNULL(AT2008.S02ID,'''') = isnull(WT8899.S02ID,'''') AND
										ISNULL(AT2008.S03ID,'''') = isnull(WT8899.S03ID,'''') AND
										ISNULL(AT2008.S04ID,'''') = isnull(WT8899.S04ID,'''') AND
										ISNULL(AT2008.S05ID,'''') = isnull(WT8899.S05ID,'''') AND 
										ISNULL(AT2008.S06ID,'''') = isnull(WT8899.S06ID,'''') AND
										ISNULL(AT2008.S07ID,'''') = isnull(WT8899.S07ID,'''') AND
										ISNULL(AT2008.S08ID,'''') = isnull(WT8899.S08ID,'''') AND
										ISNULL(AT2008.S09ID,'''') = isnull(WT8899.S09ID,'''') AND
										ISNULL(AT2008.S10ID,'''') = isnull(WT8899.S10ID,'''') AND
										ISNULL(AT2008.S11ID,'''') = isnull(WT8899.S11ID,'''') AND 
										ISNULL(AT2008.S12ID,'''') = isnull(WT8899.S12ID,'''') AND
										ISNULL(AT2008.S13ID,'''') = isnull(WT8899.S13ID,'''') AND
										ISNULL(AT2008.S14ID,'''') = isnull(WT8899.S14ID,'''') AND
										ISNULL(AT2008.S15ID,'''') = isnull(WT8899.S15ID,'''') AND
										ISNULL(AT2008.S16ID,'''') = isnull(WT8899.S16ID,'''') AND
										ISNULL(AT2008.S17ID,'''') = isnull(WT8899.S17ID,'''') AND
										ISNULL(AT2008.S18ID,'''') = isnull(WT8899.S18ID,'''') AND
										ISNULL(AT2008.S19ID,'''') = isnull(WT8899.S19ID,'''') AND
										ISNULL(AT2008.S20ID,'''') = isnull(WT8899.S20ID,'''')
			INNER JOIN AT1005 ON AT1005.DivisionID = AT2007.DivisionID AND AT1005.AccountID = AV5000.AccountID							
		WHERE AT2007.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + ''')) 
			AND AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
			AND AV5000.AccountID LIKE ''' + @AccountID + ''' 
			AND AT1005.GroupID = ''G05'' 
			AND (   (AT2006.KindVoucherID IN ' + @KindVoucherListEx2 + ' AND AT2006.WareHouseID LIKE ''' + @WareHouseID + ''')
					OR (AT2006.KindVoucherID = 3 AND AT2006.WareHouseID2 LIKE ''' + @WareHouseID + ''')
				)
			AND AV5000.D_C = ''C''
			' + @strWhere

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Name = 'AT2039' AND Xtype = 'U') 
    CREATE TABLE [dbo].[AT2039]
    (
        [APK] [uniqueidentifier] DEFAULT NEWID(), 
        [DivisionID] NVARCHAR(50) NOT NULL, 
        [WareHouseID] [NVARCHAR](50) NOT NULL, 
        [WareHouseName] [NVARCHAR](250) NULL, 
        [VoucherID] [NVARCHAR](50) NOT NULL, 
        [TransactionID] [NVARCHAR](50) NOT NULL, 
        [Orders] [NVARCHAR](250) NOT NULL, 
        [VoucherDate] [DATETIME] NULL, 
        [VoucherNo] [NVARCHAR](50) NULL, 
        [AccountID] [NVARCHAR](50) NULL, 
        [AccountName] [NVARCHAR](250) NULL, 
        [CorAccountID] [NVARCHAR](50) NULL, 
        [UnitPrice] [DECIMAL](28, 8) NULL, 
        [ImQuantity] [DECIMAL](28, 8) NULL, 
        [ImConvertedAmount] [DECIMAL](28, 8) NULL, 
        [ImOriginalAmount] [DECIMAL](28, 8) NULL, 
        [ExQuantity] [DECIMAL](28, 8) NULL, 
        [ExConvertedAmount] [DECIMAL](28, 8) NULL, 
        [ExOriginalAmount] [DECIMAL](28, 8) NULL, 
        [Description] [NVARCHAR](250) NULL, 
        [InventoryID] [NVARCHAR](50) NULL, 
        [InventoryName] [NVARCHAR](250) NULL, 
        [UnitID] [NVARCHAR](50) NULL, 
        [BeginQuantity] [DECIMAL](28, 8) NULL, 
        [BeginAmount] [DECIMAL](28, 8) NULL, 
        [EndQuantity] [DECIMAL](28, 8) NULL, 
        [EndAmount] [DECIMAL](28, 8) NULL, 
        [Ana01ID] [NVARCHAR](50) NULL, 
        [Ana02ID] [NVARCHAR](50) NULL, 
        [Ana03ID] [NVARCHAR](50) NULL, 
        [Ana04ID] [NVARCHAR](50) NULL, 
        [Ana05ID] [NVARCHAR](50) NULL,
		[S01ID] [VARCHAR] (50) NULL,
		[S02ID] [VARCHAR] (50) NULL,
		[S03ID] [VARCHAR] (50) NULL,
		[S04ID] [VARCHAR] (50) NULL,
		[S05ID] [VARCHAR] (50) NULL,
		[S06ID] [VARCHAR] (50) NULL,
		[S07ID] [VARCHAR] (50) NULL,
		[S08ID] [VARCHAR] (50) NULL,
		[S09ID] [VARCHAR] (50) NULL,
		[S10ID] [VARCHAR] (50) NULL,
		[S11ID] [VARCHAR] (50) NULL,
		[S12ID] [VARCHAR] (50) NULL,
		[S13ID] [VARCHAR] (50) NULL,
		[S14ID] [VARCHAR] (50) NULL,
		[S15ID] [VARCHAR] (50) NULL,
		[S16ID] [VARCHAR] (50) NULL,
		[S17ID] [VARCHAR] (50) NULL,
		[S18ID] [VARCHAR] (50) NULL,
		[S19ID] [VARCHAR] (50) NULL,
		[S20ID] [VARCHAR] (50) NULL, 
        CONSTRAINT [PK_AT2039] PRIMARY KEY NONCLUSTERED 
        (
            [APK] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
ELSE
    DELETE AT2039

--Print @sSQL1
--Print @sSQL2

EXEC ('INSERT INTO AT2039 (DivisionID, WareHouseID, WareHouseName, VoucherID, TransactionID, Orders, VoucherDate, VoucherNo, AccountID, AccountName, CorAccountID, 
UnitPrice, ImQuantity, ImConvertedAmount, ImOriginalAmount, ExQuantity, ExConvertedAmount, ExOriginalAmount, Description, InventoryID, InventoryName, UnitID, 
BeginQuantity, BeginAmount, EndQuantity, EndAmount, Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
	S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID)
        ' + @sSQL1 + @sSQL3)

EXEC ('INSERT INTO AT2039 (DivisionID, WareHouseID, WareHouseName, VoucherID, TransactionID, Orders, VoucherDate, VoucherNo, AccountID, AccountName, CorAccountID, 
UnitPrice, ImQuantity, ImConvertedAmount, ImOriginalAmount, ExQuantity, ExConvertedAmount, ExOriginalAmount, Description, InventoryID, InventoryName, UnitID, 
BeginQuantity, BeginAmount, EndQuantity, EndAmount, Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
	S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID)
        ' + @sSQL2 + @sSQL4)

DECLARE
@EndQuantity DECIMAL(28, 8),
@EndAmount DECIMAL(28, 8),
@PreviousWarehouseID NVARCHAR(50),
@PreviousInventoryID NVARCHAR(50)

set @PreviousWarehouseID = ''
set @PreviousInventoryID = ''

SET @AT2039_Cursor = CURSOR SCROLL KEYSET FOR 
    SELECT
    WareHouseID, 
    TransactionID, 
    InventoryID,
    BeginQuantity,
    BeginAmount, 
    ImQuantity, 
    ExQuantity, 
    ImConvertedAmount, 
    ExConvertedAmount, S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
	S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID
    FROM AT2039
    ORDER BY WareHouseID, InventoryID, VoucherDate

OPEN @AT2039_Cursor
FETCH NEXT FROM @AT2039_Cursor INTO @WareHouseID, @TransactionID, @InventoryID, @BeginQuantity, @BeginAmount, @ImQuantity, @ExQuantity, @ImConvertedAmount, @ExConvertedAmount,
										@S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
										@S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID

WHILE @@FETCH_STATUS = 0
    BEGIN
        IF((@PreviousWarehouseID <> @WareHouseID) OR (@PreviousInventoryID <> @InventoryID))
        BEGIN
            SET @EndQuantity = ISNULL(@BeginQuantity, 0) 
            SET @EndAmount = ISNULL(@BeginAmount, 0)
        END
        
        SET @EndQuantity = ISNULL(@EndQuantity, 0) + ISNULL(@ImQuantity, 0) - ISNULL(@ExQuantity, 0)
        SET @EndAmount = ISNULL(@EndAmount, 0) + ISNULL(@ImConvertedAmount, 0) - ISNULL(@ExConvertedAmount, 0)

        UPDATE AT2039 SET 
            EndQuantity = @EndQuantity, 
            EndAmount = @EndAmount
            WHERE TransactionID = @TransactionID 
            
        SET @PreviousWarehouseID = @WareHouseID
        SET @PreviousInventoryID = @InventoryID

FETCH NEXT FROM @AT2039_Cursor INTO @WareHouseID, @TransactionID, @InventoryID, @BeginQuantity, @BeginAmount, @ImQuantity, @ExQuantity, @ImConvertedAmount, @ExConvertedAmount,
									@S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
									@S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID
    END

CLOSE @AT2039_Cursor
DEALLOCATE @AT2039_Cursor

		SELECT  AT1304.UnitName, AT2039.*,
		A10.StandardName AS StandardName01, A11.StandardName AS StandardName02, A12.StandardName AS StandardName03, A13.StandardName AS StandardName04, A14.StandardName AS StandardName05,
		A15.StandardName AS StandardName06, A16.StandardName AS StandardName07, A17.StandardName AS StandardName08, A18.StandardName AS StandardName09, A19.StandardName AS StandardName10,
		A20.StandardName AS StandardName11, A21.StandardName AS StandardName12, A22.StandardName AS StandardName13, A23.StandardName AS StandardName14, A24.StandardName AS StandardName15, 
		A25.StandardName AS StandardName16, A26.StandardName AS StandardName17, A27.StandardName AS StandardName18, A28.StandardName AS StandardName19, A29.StandardName AS StandardName20
				
		From  AT2039 Left join AT1304 on AT1304.UnitID = AT2039.UnitID AND AT1304.DivisionID = AT2039.DivisionID
		LEFT JOIN AT0128 A10 ON A10.DivisionID = AT2039.DivisionID AND A10.StandardID = AT2039.S01ID AND A10.StandardTypeID = 'S01'
		LEFT JOIN AT0128 A11 ON A11.DivisionID = AT2039.DivisionID AND A11.StandardID = AT2039.S02ID AND A11.StandardTypeID = 'S02'
		LEFT JOIN AT0128 A12 ON A12.DivisionID = AT2039.DivisionID AND A12.StandardID = AT2039.S03ID AND A12.StandardTypeID = 'S03'
		LEFT JOIN AT0128 A13 ON A13.DivisionID = AT2039.DivisionID AND A13.StandardID = AT2039.S04ID AND A13.StandardTypeID = 'S04'
		LEFT JOIN AT0128 A14 ON A14.DivisionID = AT2039.DivisionID AND A14.StandardID = AT2039.S05ID AND A14.StandardTypeID = 'S05'
		LEFT JOIN AT0128 A15 ON A15.DivisionID = AT2039.DivisionID AND A15.StandardID = AT2039.S06ID AND A15.StandardTypeID = 'S06'
		LEFT JOIN AT0128 A16 ON A16.DivisionID = AT2039.DivisionID AND A16.StandardID = AT2039.S07ID AND A16.StandardTypeID = 'S07'
		LEFT JOIN AT0128 A17 ON A17.DivisionID = AT2039.DivisionID AND A17.StandardID = AT2039.S08ID AND A17.StandardTypeID = 'S08'
		LEFT JOIN AT0128 A18 ON A18.DivisionID = AT2039.DivisionID AND A18.StandardID = AT2039.S09ID AND A18.StandardTypeID = 'S09'
		LEFT JOIN AT0128 A19 ON A19.DivisionID = AT2039.DivisionID AND A19.StandardID = AT2039.S10ID AND A19.StandardTypeID = 'S10'
		LEFT JOIN AT0128 A20 ON A20.DivisionID = AT2039.DivisionID AND A20.StandardID = AT2039.S11ID AND A20.StandardTypeID = 'S11'
		LEFT JOIN AT0128 A21 ON A21.DivisionID = AT2039.DivisionID AND A21.StandardID = AT2039.S12ID AND A21.StandardTypeID = 'S12'
		LEFT JOIN AT0128 A22 ON A22.DivisionID = AT2039.DivisionID AND A22.StandardID = AT2039.S13ID AND A22.StandardTypeID = 'S13'
		LEFT JOIN AT0128 A23 ON A23.DivisionID = AT2039.DivisionID AND A23.StandardID = AT2039.S14ID AND A23.StandardTypeID = 'S14'
		LEFT JOIN AT0128 A24 ON A24.DivisionID = AT2039.DivisionID AND A24.StandardID = AT2039.S15ID AND A24.StandardTypeID = 'S15'
		LEFT JOIN AT0128 A25 ON A25.DivisionID = AT2039.DivisionID AND A25.StandardID = AT2039.S16ID AND A25.StandardTypeID = 'S16'
		LEFT JOIN AT0128 A26 ON A26.DivisionID = AT2039.DivisionID AND A26.StandardID = AT2039.S17ID AND A26.StandardTypeID = 'S17'
		LEFT JOIN AT0128 A27 ON A27.DivisionID = AT2039.DivisionID AND A27.StandardID = AT2039.S18ID AND A27.StandardTypeID = 'S18'
		LEFT JOIN AT0128 A28 ON A28.DivisionID = AT2039.DivisionID AND A28.StandardID = AT2039.S19ID AND A28.StandardTypeID = 'S19'
		LEFT JOIN AT0128 A29 ON A29.DivisionID = AT2039.DivisionID AND A29.StandardID = AT2039.S20ID AND A29.StandardTypeID = 'S20'
		WHERE AT2039.DivisionID = @DivisionID
		Order By AT2039.AccountID ASC, AT2039.WareHouseID ASC, AT2039.InventoryID ASC, AT2039.VoucherDate,
		AT2039.S01ID, AT2039.S02ID, AT2039.S03ID, AT2039.S04ID, AT2039.S05ID, AT2039.S06ID, AT2039.S07ID, AT2039.S08ID, AT2039.S09ID, AT2039.S10ID,
		AT2039.S11ID, AT2039.S12ID, AT2039.S13ID, AT2039.S14ID, AT2039.S15ID, AT2039.S16ID, AT2039.S17ID, AT2039.S18ID, AT2039.S19ID, AT2039.S20ID
		
SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
