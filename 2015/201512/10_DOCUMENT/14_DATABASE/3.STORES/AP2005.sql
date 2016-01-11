IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2005]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP2005]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/
---- Created by Nguyen Thi Ngoc Minh, Date 02/08/2004.
---- Purpose: So chi tiet vat lieu (san pham, hang hoa) - dung cho nhat ky so cai
---- Edit by: Nguyen Quoc Huy, Date 04/07/2007
---- Edit by: Dang Le Bao Quynh; Date: 16/01/2009
---- Purpose: Bo sung truong hop xuat hang mua tra lai
---- Modified by Thanh Sơn on 16/07/2014: lấy dữ liệu trực tiếp từ store
---- Modified by Tieu Mai on 09/11/2015: Bổ sung điều kiện khi delete table AT2025
---- Modified by Bảo Anh on 26/11/2015: Bổ sung BeginQuantity, BeginAmount khi trả dữ liệu báo cáo

CREATE PROCEDURE [dbo].[AP2005]
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
    @strWhere AS NVARCHAR(4000), 
    @AT2025_Cursor AS cursor, 
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
    @ImConvertedAmount AS DECIMAL(28, 8)

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
        EXEC AP7016 @DivisionID, @WareHouseID, @WareHouseID, @FromInventoryID, @ToInventoryID, @AccountID, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate1, @ToDate1, 0, 1
    END
ELSE IF @IsDate = 1 -- theo ngay
    BEGIN
        
        SET @FromDateText = CONVERT(NVARCHAR(10), @FromDate, 101)
        SET @ToDate = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'
        SET @ToDateText = CONVERT(NVARCHAR(10), @ToDate, 101)
                
        SET @strWhere = 'AND (AT2006.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''' ) '
        EXEC AP7016 @DivisionID, @WareHouseID, @WareHouseID, @FromInventoryID, @ToInventoryID, @AccountID, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate, 1, 1
    END
ELSE -- theo nam 
    BEGIN
        SET @FromDate1 = '01/01/' + LTRIM(STR(@FromYear))
        SET @ToDate1 = DATEADD(MONTH, 1, '01/01/' + LTRIM(STR(@ToYear))) - 1
        
        SET @FromDateText = CONVERT(NVARCHAR(10), @FromDate1, 101)
        SET @ToDateText = CONVERT(NVARCHAR(10), @ToDate1, 101)
                
        SET @strWhere = 'AND (AT2006.VoucherDate BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + ''' ) '
        EXEC AP7016 @DivisionID, @WareHouseID, @WareHouseID, @FromInventoryID, @ToInventoryID, @AccountID, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate1, @ToDate1, 1, 1
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
    AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID
    
FROM AT2007 
    INNER JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
    INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
    INNER JOIN AT1303 ON AT1303.DivisionID = AT2007.DivisionID AND AT1303.WarehouseID = AT2006.WarehouseID
    INNER JOIN AV5000 ON AV5000.DivisionID = AT2007.DivisionID AND AV5000.VoucherID = AT2007.VoucherID AND AV5000.TransactionID = AT2007.TransactionID
    INNER JOIN AT1005 ON AT1005.DivisionID = AT2007.DivisionID AND AT1005.AccountID = AV5000.AccountID
    LEFT JOIN AT2008 ON AT2008.DivisionID = AT2007.DivisionID AND AT2008.InventoryID = AT2007.InventoryID AND AT2008.WareHouseID = AT2006.WareHouseID AND AT2008.InventoryAccountID = AT2007.DebitAccountID AND AT2008.TranMonth = AT2007.TranMonth AND AT2008.TranYear = AT2007.TranYear
    
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
    AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID

FROM AT2007 
    INNER JOIN AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
    INNER JOIN AT2006 ON AT2006.DivisionID = AT2007.DivisionID AND AT2006.VoucherID = AT2007.VoucherID
    INNER JOIN AV5000 ON AV5000.DivisionID = AT2007.DivisionID AND AV5000.VoucherID = AT2007.VoucherID AND AV5000.TransactionID = AT2007.TransactionID
    INNER JOIN AT1005 ON AT1005.DivisionID = AT2007.DivisionID AND AT1005.AccountID = AV5000.AccountID
    INNER JOIN AT1303 ON AT1303.DivisionID = AT2007.DivisionID AND AT1303.WareHouseID = CASE WHEN KindVoucherID = 3 THEN AT2006.WareHouseID2 ELSE AT2006.WareHouseID END
    LEFT JOIN AT2008 ON AT2008.DivisionID = AT2007.DivisionID AND AT2008.InventoryID = AT2007.InventoryID AND AT2008.WareHouseID = AT2006.WareHouseID AND AT2008.InventoryAccountID = AT2007.CreditAccountID AND AT2008.TranMonth = AT2007.TranMonth AND AT2008.TranYear = AT2007.TranYear

WHERE AT2007.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + ''')) 
    AND AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
    AND AV5000.AccountID LIKE ''' + @AccountID + ''' 
    AND AT1005.GroupID = ''G05'' 
    AND (   (AT2006.KindVoucherID IN ' + @KindVoucherListEx2 + ' AND AT2006.WareHouseID LIKE ''' + @WareHouseID + ''')
         OR (AT2006.KindVoucherID = 3 AND AT2006.WareHouseID2 LIKE ''' + @WareHouseID + ''')
        )
    AND AV5000.D_C = ''C''
    ' + @strWhere
    
IF EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Name = 'AT2025' AND Xtype = 'U')
DROP TABLE [dbo].[AT2025]

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE Name = 'AT2025' AND Xtype = 'U') 
    CREATE TABLE [dbo].[AT2025]
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
        CONSTRAINT [PK_AT2025] PRIMARY KEY NONCLUSTERED 
        (
            [APK] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
ELSE
    DELETE AT2025

--Print @sSQL1
--Print @sSQL2

EXEC ('INSERT INTO AT2025 (DivisionID, WareHouseID, WareHouseName, VoucherID, TransactionID, Orders, VoucherDate, VoucherNo, AccountID, AccountName, CorAccountID, UnitPrice, ImQuantity, ImConvertedAmount, ImOriginalAmount, ExQuantity, ExConvertedAmount, ExOriginalAmount, Description, InventoryID, InventoryName, UnitID, BeginQuantity, BeginAmount, EndQuantity, EndAmount, Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID)
        ' + @sSQL1)

EXEC ('INSERT INTO AT2025 (DivisionID, WareHouseID, WareHouseName, VoucherID, TransactionID, Orders, VoucherDate, VoucherNo, AccountID, AccountName, CorAccountID, UnitPrice, ImQuantity, ImConvertedAmount, ImOriginalAmount, ExQuantity, ExConvertedAmount, ExOriginalAmount, Description, InventoryID, InventoryName, UnitID, BeginQuantity, BeginAmount, EndQuantity, EndAmount, Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID)
        ' + @sSQL2)

DECLARE
@EndQuantity DECIMAL(28, 8),
@EndAmount DECIMAL(28, 8),
@PreviousWarehouseID NVARCHAR(50),
@PreviousInventoryID NVARCHAR(50)

set @PreviousWarehouseID = ''
set @PreviousInventoryID = ''

SET @AT2025_Cursor = CURSOR SCROLL KEYSET FOR 
    SELECT
    WareHouseID, 
    TransactionID, 
    InventoryID,
    BeginQuantity,
    BeginAmount, 
    ImQuantity, 
    ExQuantity, 
    ImConvertedAmount, 
    ExConvertedAmount
    FROM AT2025
    ORDER BY WareHouseID, InventoryID, VoucherDate

OPEN @AT2025_Cursor
FETCH NEXT FROM @AT2025_Cursor INTO @WareHouseID, @TransactionID, @InventoryID, @BeginQuantity, @BeginAmount, @ImQuantity, @ExQuantity, @ImConvertedAmount, @ExConvertedAmount

WHILE @@FETCH_STATUS = 0
    BEGIN
        IF((@PreviousWarehouseID <> @WareHouseID) OR (@PreviousInventoryID <> @InventoryID))
        BEGIN
            SET @EndQuantity = ISNULL(@BeginQuantity, 0) 
            SET @EndAmount = ISNULL(@BeginAmount, 0)
        END
        
        SET @EndQuantity = ISNULL(@EndQuantity, 0) + ISNULL(@ImQuantity, 0) - ISNULL(@ExQuantity, 0)
        SET @EndAmount = ISNULL(@EndAmount, 0) + ISNULL(@ImConvertedAmount, 0) - ISNULL(@ExConvertedAmount, 0)

        UPDATE AT2025 SET 
            EndQuantity = @EndQuantity, 
            EndAmount = @EndAmount
            WHERE TransactionID = @TransactionID 
            
        SET @PreviousWarehouseID = @WareHouseID
        SET @PreviousInventoryID = @InventoryID

FETCH NEXT FROM @AT2025_Cursor INTO @WareHouseID, @TransactionID, @InventoryID, @BeginQuantity, @BeginAmount, @ImQuantity, @ExQuantity, @ImConvertedAmount, @ExConvertedAmount
    END

CLOSE @AT2025_Cursor
DEALLOCATE @AT2025_Cursor

SET @sSQL = '
SELECT  AT1304.UnitName, AT2025.WareHouseID , AT2025.WareHouseName,
AT2025.VoucherDate , AT2025.VoucherNo, AT2025.AccountID, AT2025.AccountName,
AT2025.CorAccountID , AT2025.UnitPrice, AT2025.ImQuantity, AT2025.ImConvertedAmount,
AT2025.ExQuantity, AT2025.ExConvertedAmount, AT2025.Description, AT2025.InventoryID,
AT2025.InventoryName, AT2025.EndQuantity, AT2025.EndAmount, AT2025.BeginQuantity, AT2025.BeginAmount
From  AT2025 Left join AT1304 on AT1304.UnitID = AT2025.UnitID AND AT1304.DivisionID = AT2025.DivisionID
WHERE AT2025.DivisionID = '''+@DivisionID+'''
Order By AT2025.AccountID ASC, AT2025.WareHouseID ASC, AT2025.InventoryID ASC, AT2025.VoucherDate'

EXEC (@sSQL)

SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON