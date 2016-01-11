/****** Object: StoredProcedure [dbo].[AP1533] Script Date: 12/14/2010 11:54:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- <Summary>
---- Tra ra man hinh khi ke thua nghiep vu tu ASOFT T sang FA
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
-- <Example>
-- Edit by: Dang Le Bao Quynh; Bo sung 3 col: Serial, InvoiceNo, InvoiceDate
ALTER PROCEDURE [dbo].[AP1533] 
    @DivisionID VARCHAR(50),
    @FromMonth INT,
    @FromYear INT,
    @ToMonth INT,
    @ToYear INT, 
    @FromDate DATETIME,
    @ToDate DATETIME,
    @IsDate TINYINT, -- 0 theo ky, 1 theo ngày
    @TransactionTypeID VARCHAR(50), -- Mua hàng: "T03", Tổng hợp: "T99", Xuất kho: "T06" 
    @AccountID VARCHAR(50), 
    @AssetID VARCHAR(50), -- Thêm mới: '', Sửa: AssetID chon edit
    @IsAsset int
AS

DECLARE 
@sSQL NVARCHAR(4000),
@Union NVARCHAR(4000)
If @IsAsset = 0
	exec AP1633 @DivisionID,@FromMonth,@FromYear,@ToMonth,@ToYear,@FromDate,@ToDate,@IsDate,@TransactionTypeID,@AccountID
Else
Begin
IF ISNULL(@AssetID, '') = ''
    SET @Union =''
ELSE
    SET @Union = '
UNION 
SELECT 
Convert(TinyInt, 0) As Choose,
AT1533.DivisionID, 
AT9000.VoucherID,
AT9000.TransactionID, 
AT9000.VoucherNo, 
AT9000.VoucherDate, 
AT9000.VDescription, 
AT9000.TDescription,
AT9000.TransactionTypeID,
AT9000.DebitAccountID,
AT9000.CreditAccountID,
AT1533.ConvertedAmount, 
'''' as InventoryID,
'''' as InventoryName,
IsEdit = 1,
Serial, InvoiceNo, InvoiceDate, AT9000.ObjectID
FROM AT1533 
LEFT JOIN AT9000 ON AT9000.TransactionID = AT1533.ReTransactionID AND AT9000.DivisionID = AT1533.DivisionID
WHERE AssetID = ''' + @AssetID + '''
'

IF @IsDate = 0
    SET @sSQL = ' 
SELECT 
Convert(TinyInt, 0) As Choose,
AT9000.DivisionID, 
AT9000.VoucherID,
AT9000.TransactionID,
AT9000.VoucherNo, 
AT9000.VoucherDate, 
AT9000.VDescription, 
AT9000.TDescription,
AT9000.TransactionTypeID,
AT9000.DebitAccountID,
AT9000.CreditAccountID,
(ISNULL(AT9000.ConvertedAmount, 0) + ISNULL(AT9000.ImTaxConvertedAmount, 0) + ISNULL(AT9000.ExpenseConvertedAmount, 0) - (ISNULL(AT9000.DiscountAmount, 0) * AT9000.Exchangerate)) - ISNULL(A.AConvertedAmount, 0) AS ConvertedAmount,
'''' as InventoryID,
'''' as InventoryName,
IsEdit = CONVERT(TINYINT, 0),
Serial, InvoiceNo, InvoiceDate, AT9000.ObjectID
FROM AT9000
LEFT JOIN 
(
    SELECT ISNULL(SUM(ISNULL(ConvertedAmount, 0)), 0) AS AConvertedAmount, ReTransactionID, DivisionID 
    FROM AT1533 GROUP BY ReTransactionID, DivisionID
) AS A ON A.ReTransactionID = AT9000.TransactionID AND A.DivisionID = AT9000.DivisionID
WHERE AT9000.DivisionID = ''' + @DivisionID + ''' 
AND AT9000.DebitAccountID LIKE ''' + @AccountID + ''' 
AND AT9000.TransactionTypeID LIKE ''' + @TransactionTypeID + '''
AND AT9000.TranMonth + AT9000.TranYear * 100 BETWEEN ' + CAST(@FromMonth + @FromYear * 100 AS VARCHAR(20)) + ' AND ' + CAST(@ToMonth + @ToYear * 100 AS VARCHAR(20)) + ' 
AND ISNULL(AT9000.ConvertedAmount, 0) + ISNULL(AT9000.ImTaxConvertedAmount, 0)+ ISNULL(AT9000.ExpenseConvertedAmount, 0) - (ISNULL(AT9000.DiscountAmount, 0) * AT9000.Exchangerate) - ISNULL(A.AConvertedAmount, 0) > 0
' 
ELSE
    SET @sSQL =' 
SELECT
Convert(TinyInt, 0) As Choose,
AT9000.DivisionID, 
AT9000.VoucherID,
AT9000.TransactionID, 
AT9000.VoucherNo, 
AT9000.VoucherDate, 
AT9000.VDescription, 
AT9000.TDescription,
AT9000.TransactionTypeID,
AT9000.DebitAccountID,
AT9000.CreditAccountID,
(ISNULL(AT9000.ConvertedAmount, 0) + ISNULL(AT9000.ImTaxConvertedAmount, 0)+ ISNULL(AT9000.ExpenseConvertedAmount, 0) - (ISNULL(AT9000.DiscountAmount, 0) * AT9000.Exchangerate)) - ISNULL(A.AConvertedAmount, 0) AS ConvertedAmount,
'''' as InventoryID,
'''' as InventoryName,
IsEdit = CONVERT(TINYINT, 0),
Serial, InvoiceNo, InvoiceDate, AT9000.ObjectID
FROM AT9000
LEFT JOIN
(
    SELECT ISNULL(SUM(ISNULL(ConvertedAmount, 0)), 0) AS AConvertedAmount, ReTransactionID, DivisionID 
    FROM AT1533 GROUP BY ReTransactionID, DivisionID
) AS A ON A.ReTransactionID = AT9000.TransactionID AND A.DivisionID = AT9000.DivisionID
WHERE AT9000.DivisionID = ''' + @DivisionID + ''' 
AND AT9000.DebitAccountID LIKE ''' + @AccountID + ''' 
AND AT9000.TransactionTypeID LIKE ''' + @TransactionTypeID + '''
AND AT9000.VoucherDate BETWEEN ''' + CONVERT(VARCHAR(10), @FromDate, 21) + ''' AND ''' + CONVERT(VARCHAR(10), @ToDate, 21) + ''' 
AND ISNULL(AT9000.ConvertedAmount, 0) + ISNULL(AT9000.ImTaxConvertedAmount, 0)+ ISNULL(AT9000.ExpenseConvertedAmount, 0) - (ISNULL(AT9000.DiscountAmount, 0) * AT9000.Exchangerate) - ISNULL(A.AConvertedAmount, 0) > 0
'

EXEC (@sSQL + @union)

End