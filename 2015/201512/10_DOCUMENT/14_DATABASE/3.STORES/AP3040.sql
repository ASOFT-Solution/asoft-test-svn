/****** Object: StoredProcedure [dbo].[AP3040] Script Date: 07/29/2010 10:16:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Dang Le Bao Quynh
--Date 15/01/2009
--Purpose:Dung cho Report hang mua tra lai
--- Edit by Bao Anh, date 11/04/2010 Lay cac truong dien giai
---- Modified on 12/04/2012 by Lê Thị Thu Hiền : Bổ sung trường VoucherNo

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3040] 
    @VoucherID AS NVARCHAR(50)
AS
DECLARE 
    @sSql AS NVARCHAR(4000), 
    @sSqlUnion AS NVARCHAR(4000)

SET @sSql ='
SELECT 
    0 AS TaxOrders, 
    AT9000.Orders, 
    Ana01ID, 
    Ana02ID, 
    Ana03ID, 
    AT1011.AnaName AS AnaName1, 
    AT1011.RefDate AS Ana01RefDate, 
    AT9000.InventoryID, 
    AT9000.UnitID, 
    AT1304.UnitName, 
    (OriginalAmount / Quantity) AS UnitPrice, 
    Quantity, 
    OriginalAmount, 
    CAST(ISNULL(DiscountRate, 0) AS DECIMAL(28, 8)) AS DiscountRate, 
    ConvertedAmount, 
    Serial, 
    InvoiceNo, 
    CASE WHEN ISNULL(AT9000.InventoryName1, '''') = '''' THEN AT1302.InventoryName ELSE AT9000.InventoryName1 END AS InventoryName, 
    AT9000.ObjectID, 
    (CASE WHEN ISNULL(AT9000.VATObjectID, '''') ='''' THEN A.Address ELSE B.Address END ) AS ObAddress, 
    A.PaymentID, 
    AT9000.InvoiceDate, 
    AT9000.DivisionID, 
    AT1101.DivisionName, 
    AT1101.Address, 
    AT1101.Tel, 
    AT1101.Fax, 
    AT1101.VATNO AS DivisionVATNO, 
    AT9000.CurrencyID, 
    AT1010.VATRate, 
    AT1302.Varchar01, 
    AT1302.Varchar02, 
    AT1302.Varchar03, 
    AT1302.Varchar04, 
    AT1302.Varchar05, 
    OriginalAmountTax = (CASE WHEN (SELECT Sum(ISNULL(OriginalAmount, 0)) 
        FROM AT9000 T9 
        WHERE DivisionID = AT9000.DivisionID AND TransactiontypeID = ''T35'' AND VoucherID = AT9000.VoucherID ) IS NULL
        THEN 0 ELSE (SELECT Sum(ISNULL(OriginalAmount, 0)) 
        FROM AT9000 T9 
        WHERE DivisionID = AT9000.DivisionID AND TransactiontypeID =''T35'' AND VoucherID = AT9000.VoucherID ) END), '
SET @sSqlUnion = '
    ConvertedAmountTax = (CASE WHEN (SELECT Sum(ISNULL(ConvertedAmount, 0)) 
        FROM AT9000 T9 
        WHERE DivisionID = AT9000.DivisionID AND TransactiontypeID =''T35'' AND VoucherID = AT9000.VoucherID ) IS NULL
        THEN 0 ELSE (SELECT Sum(ISNULL(ConvertedAmount, 0)) 
        FROM AT9000 T9 
        WHERE DivisionID = AT9000.DivisionID AND TransactiontypeID =''T35'' AND VoucherID = AT9000.VoucherID ) END), 

    (CASE WHEN ISNULL(AT9000.VATObjectID, '''') ='''' THEN A.ObjectName 
    ELSE 
    CASE WHEN B.IsUpdateName = 1 THEN AT9000.VATObjectName 
    ELSE
    B.ObjectName END END) AS ObjectName, 
    (CASE WHEN ISNULL(AT9000.VATObjectID, '''') ='''' THEN A.VATNo
    ELSE 
    CASE WHEN B.IsUpdateName = 1 THEN AT9000.VATNo
    ELSE
    B.VATNo END END) AS VATNo, 
    VDescription, 
    BDescription, 
    TDescription,
    AT9000.VoucherNo

FROM AT9000 
LEFT JOIN AT1302    ON AT1302.DivisionID = AT9000.DivisionID    AND AT1302.InventoryID = AT9000.InventoryID
LEFT JOIN AT1304    ON AT1304.DivisionID = AT9000.DivisionID    AND AT1304.UnitID = AT9000.UnitID
LEFT JOIN AT1202 A  ON A.DivisionID = AT9000.DivisionID         AND A.ObjectID = AT9000.ObjectID
LEFT JOIN AT1202 B  ON B.DivisionID = AT9000.DivisionID         AND B.ObjectID = AT9000.VATObjectID
LEFT JOIN AT1101    ON AT1101.DivisionID = AT9000.DivisionID
LEFT JOIN AT1010    ON AT1010.DivisionID = AT9000.DivisionID    AND AT1010.VATGroupID = AT9000.VATGroupID
LEFT JOIN AT1011    ON AT1011.DivisionID = AT9000.DivisionID    AND AT1011.AnaID = AT9000.Ana01ID AND AT1011.AnaTypeID = ''A01''
WHERE VoucherID = ''' + @VoucherID + ''' AND TransactionTypeID = ''T25'' '

--SET @sSql = @sSql + @sSqlUnion

--Print @sSql
IF NOT EXISTS (SELECT top 1 1 FROM SysObjects WHERE name = 'AV3040' AND Xtype ='V')
    EXEC ('CREATE VIEW AV3040 -- Tao boi AP3040
        AS ' + @sSQL + @sSqlUnion)
ELSE
    EXEC ('ALTER VIEW AV3040 -- Tao boi AP3040
        AS ' + @sSQL + @sSqlUnion)