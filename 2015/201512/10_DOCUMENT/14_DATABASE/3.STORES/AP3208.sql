/****** Object: StoredProcedure [dbo].[AP3208] Script Date: 07/29/2010 11:36:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Bao Anh, date: 24/12/2009
---purpose: Load detail cho form ke thua nhieu don hang mua o phieu nhap kho
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'* Edited by : [GS] [Tan Phu] [28/06/2012] Bo sung them truong ObjectID
---Modified on 26/10/2015 by Tiểu Mai: bổ sung thêm 20 trường quy cách hàng hóa, không sinh view
'**************************************************************/
ALTER PROCEDURE [dbo].[AP3208] 
    @DivisionID NVARCHAR(50),
    @lstPOrderID NVARCHAR(4000),
    -- Thêm mới   : ''
    -- Hiệu chỉnh : Số chứng từ đang sửa
    @VoucherID NVARCHAR(50), 
    @ConnID NVARCHAR(100),
    @ConditionIV NVARCHAR(100),
    @IsUsedConditionIV NVARCHAR(100)
AS

DECLARE @sSQL NVARCHAR(MAX),
		@sSQL1 NVARCHAR(MAX)

SET @DivisionID = ISNULL(@DivisionID, '')
SET @lstPOrderID = ISNULL(@lstPOrderID, '')
SET @VoucherID = ISNULL(@VoucherID, '')
SET @ConnID = ISNULL(@ConnID, '')

SET @lstPOrderID = REPLACE(@lstPOrderID, ',', ''',''')

Set @sSQL ='
SELECT 
    AT2007.OrderID,
    AT2007.OTransactionID AS TransactionID,
    AT2007.InventoryID,
    AT1302.InventoryName, 
    AT2007.UnitID, 
    0 AS IsEditInventoryName,
    AT2007.Parameter01, 
    AT2007.Parameter02, 
    AT2007.Parameter03, 
    AT2007.Parameter04, 
    AT2007.Parameter05, 
    AT2007.ConvertedQuantity, 
    AT2007.ActualQuantity, 
    AT2007.ConvertedPrice, 
    AT2007.UnitPrice, 
    AT2007.OriginalAmount, 
    AT2007.ConvertedAmount, 
    AT1302.IsSource, 
    AT1302.IsLocation, 
    AT1302.IsLimitDate, 
    AT1302.AccountID AS DebitAccountID, 
    AT1302.MethodID, 
    AT1302.IsStocked,
    AT2007.Ana01ID, 
    AT2007.Ana02ID, 
    AT2007.Ana03ID, 
    AT2007.Ana04ID, 
    AT2007.Ana05ID, 
    AT2007.Ana06ID, 
    AT2007.Ana07ID, 
    AT2007.Ana08ID, 
    AT2007.Ana09ID, 
    AT2007.Ana10ID, 
    AT2007.Orders,
    1 AS IsCheck, 
    AT2007.Notes, 
    AT1302.IsDiscount, 
    AT2007.DivisionID,
    AT2006.ObjectID,
    AT2007.Notes AS Description,
    '''' as S01ID, '''' as S02ID, '''' as S03ID, '''' as S04ID, '''' as S05ID, '''' as S06ID, '''' as S07ID, '''' as S08ID, '''' as S09ID, '''' as S10ID, 
    '''' as S11ID, '''' as S12ID, '''' as S13ID, '''' as S14ID, '''' as S15ID, '''' as S16ID, '''' as S17ID, '''' as S18ID, '''' as S19ID, '''' as S20ID
FROM AT2007 
    INNER JOIN AT1302 AT1302 ON AT1302.DivisionID = AT2007.DivisionID AND AT2007.InventoryID = AT1302.InventoryID 
    INNER JOIN AT2006 on AT2007.VoucherID =  AT2006.VoucherID and AT2007.DivisionID =AT2006.DivisionID
    --LEFT JOIN  WT8899 W89 on W89.DivisionID = AT2007.DivisionID AND W89.TableID = ''AT2007'' and W89.VoucherID = AT2007.VoucherID and W89.TransactionID = AT2007.TransactionID
WHERE AT2007.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + '''))
	AND (ISNULL(AT2007.InventoryID, ''#'') IN ('''+@ConditionIV+''') OR '+@IsUsedConditionIV+') 
    AND AT2007.VoucherID = ''' + @VoucherID + ''' '

SET @sSQL1 = '
UNION

SELECT 
    OT3002.POrderID AS OrderID,
    OT3002.TransactionID,
    OT3002.InventoryID, 
    ISNULL(OT3002.InventoryCommonName, AT1302.InventoryName) AS InventoryName, 
    OT3002.UnitID, 
    CASE WHEN ISNULL(OT3002.InventoryCommonName, '''') = '''' THEN 0 ELSE 1 END AS IsEditInventoryName, 
    OT3002.Parameter01, 
    OT3002.Parameter02, 
    OT3002.Parameter03, 
    OT3002.Parameter04, 
    OT3002.Parameter05, 
    AQ2904.EndConvertedQuantity AS ConvertedQuantity, 
    AQ2904.EndQuantity AS ActualQuantity, 
    OT3002.ConvertedSalePrice AS ConvertedPrice,
    OT3002.PurchasePrice AS UnitPrice,
    CASE WHEN AQ2904.EndQuantity = AQ2904.OrderQuantity THEN ISNULL(OT3002.OriginalAmount,0) - ISNULL(OT3002.DiscountOriginalAmount, 0) ELSE ISNULL(AQ2904.EndQuantity, 0) * ISNULL(OT3002.PurchasePrice, 0) * (100 - ISNULL(OT3002.DiscountPercent, 0)) / 100 END AS OriginalAmount, 
    CASE WHEN AQ2904.EndQuantity= AQ2904.OrderQuantity THEN ISNULL(OT3002.ConvertedAmount,0) - ISNULL(OT3002.DiscountConvertedAmount, 0) ELSE ISNULL(AQ2904.EndQuantity, 0) * ISNULL(OT3002.PurchasePrice, 0) * (100- ISNULL(OT3002.DiscountPercent, 0)) * ISNULL(ExchangeRate, 0) / 100 END AS ConvertedAmount,
    AT1302.IsSource, 
    AT1302.IsLocation, 
    AT1302.IsLimitDate, 
    AT1302.AccountID AS DebitAccountID, 
    AT1302.MethodID, 
    AT1302.IsStocked,
    OT3002.Ana01ID, 
    OT3002.Ana02ID, 
    OT3002.Ana03ID, 
    OT3002.Ana04ID, 
    OT3002.Ana05ID, 
    OT3002.Ana06ID, 
    OT3002.Ana07ID, 
    OT3002.Ana08ID, 
    OT3002.Ana09ID, 
    OT3002.Ana10ID, 
    OT3002.Orders,
    0 AS IsCheck, 
    OT3001.Notes, 
    AT1302.IsDiscount, 
    OT3002.DivisionID,
    OT3001.ObjectID,
    OT3002.Description,
    O89.S01ID, O89.S02ID, O89.S03ID, O89.S04ID, O89.S05ID, O89.S06ID, O89.S07ID, O89.S08ID, O89.S09ID, O89.S10ID, 
    O89.S11ID, O89.S12ID, O89.S13ID, O89.S14ID, O89.S15ID, O89.S16ID, O89.S17ID, O89.S18ID, O89.S19ID, O89.S20ID
FROM OT3002 
    INNER JOIN OT3001 ON OT3001.DivisionID = OT3002.DivisionID AND OT3002.POrderID = OT3001.POrderID
    INNER JOIN AQ2904 ON AQ2904.DivisionID = OT3002.DivisionID AND AQ2904.POrderID = OT3002.POrderID and AQ2904.TransactionID = OT3002.TransactionID 
    INNER JOIN AT1302 ON AT1302.DivisionID = OT3002.DivisionID AND OT3002.InventoryID = AT1302.InventoryID 
    LEFT JOIN OT8899 O89 ON O89.DivisionID = OT3002.DivisionID AND O89.TransactionID = OT3002.TransactionID AND O89.VoucherID = OT3002.POrderID AND O89.TableID = ''OT3002''
WHERE OT3002.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + '''))
    AND OT3002.POrderID in (''' + @lstPOrderID + ''')
    AND (ISNULL(OT3002.InventoryID, ''#'') IN ('''+@ConditionIV+''') OR '+@IsUsedConditionIV+') 
    AND (CASE WHEN AT1302.IsDiscount = 1 THEN AQ2904.EndOriginalAmount ELSE AQ2904.EndQuantity END) > 0
' 
--PRINT @sSQL 
--PRINT  @sSQL1
EXEC (@sSQL + @sSQL1)
