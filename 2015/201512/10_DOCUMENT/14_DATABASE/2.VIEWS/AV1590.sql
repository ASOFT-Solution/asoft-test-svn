/****** Object:  View [dbo].[AV1590]    Script Date: 12/16/2010 14:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Hong Vu, Date 06/03/2007
---- Purpose: Dung de truy van but toan thay doi nguyen gia
--- Edit by Nguyen Quoc Huy, Date 22/03/2007

ALTER VIEW [dbo].[AV1590] AS

SELECT   
-- Thông tin chung
AT1590.DivisionID, 
AT1590.VoucherID, 
AT1590.Orders,
AT1590.BatchID, 
AT1506.AssetID,
AT1506.AssetName,
AT1506.AccuDepAmount,
AT1506.DepreciatedPeriods,
AT1590.VoucherTypeID,
AT1590.VoucherDate,
AT1590.VoucherNo, 
AT1506.RevaluateID,
AT1506.IsRevaluate,
AT1506.ReValuateNo,
AT1506.Ischange,
AT1506.OldDepartmentID,
AT1506.DepOldAmount,
AT1506.ConvertedOldAmount,
AT1506.ResidualOldValue,
AT1506.DepOldPeriods,
AT1506.DepNewAmount,
AT1506.ConvertedNewAmount,
AT1506.ResidualNewValue,
AT1506.DepNewPeriods,
AT1506.DepNewPercent,

-- Thông tin chứng từ 
AT1590.TransactionID,
AT1590.Serial, 
AT1590.InvoiceNo, 	
AT1590.InvoiceDate,
AT1590.DueDate,
AT1590.OriginalAmount,
AT1590.ConvertedAmount,
AT1590.DebitAccountID,
AT1590.CreditAccountID,
AT1590.VATTypeID,
AT1590.VATGroupID,
AT1590.BDescription,
AT1590.TDescription,
AT1590.VDescription,
AT1590.OrderID,

-- Mã phân tích
AT1590.Ana01ID,
AT1590.Ana02ID,
AT1590.Ana03ID,
AT1590.Ana04ID,
AT1590.Ana05ID,
AT1590.Ana06ID,
AT1590.Ana07ID,
AT1590.Ana08ID,
AT1590.Ana09ID,
AT1590.Ana10ID,

-- Thông tin tiền tệ
AT1590.CurrencyID,
AT1590.ExchangeRate,
AT1004.Operator,
AT1004.ExchangeRateDecimal,

-- Thông tin đối tượng tập hợp chi phí
AT1590.PeriodID,
MT1601.Description AS PeriodName,

-- Thông tin đối tượng nợ
AT1590.ObjectID,
AT120201.ObjectName,
AT100501.IsObject,
AT120201.IsUpdateName,
AT120201.VATNo,

-- Thông tin đối tượng có
AT1590.CreditObjectID,
AT120202.ObjectName AS CreditObjectName,
AT100502.IsObject AS IsCreditObject,
AT120202.IsUpdateName AS IsCreditUpdateName,

-- Thông tin sản phẩm
AT1590.ProductID,
AT1302.InventoryName AS ProductName

FROM AT1590 
INNER JOIN AT1506            ON AT1506.DivisionID = AT1590.DivisionID AND AT1506.RevaluateID = AT1590.VoucherID

LEFT JOIN AT1004             ON AT1004.DivisionID = AT1590.DivisionID AND AT1004.CurrencyID = AT1590.CurrencyID
LEFT JOIN MT1601             ON MT1601.DivisionID = AT1590.DivisionID AND MT1601.PeriodID = AT1590.PeriodID
LEFT JOIN AT1302             ON AT1302.DivisionID = AT1590.DivisionID AND AT1302.InventoryID = AT1590.ProductID
LEFT JOIN AT1202 AS AT120201 ON AT120201.DivisionID = AT1590.DivisionID AND AT120201.ObjectID = AT1590.ObjectID
LEFT JOIN AT1202 AS AT120202 ON AT120202.DivisionID = AT1590.DivisionID AND AT120202.ObjectID = AT1590.CreditObjectID
LEFT JOIN AT1005 AS AT100501 ON AT100501.DivisionID = AT1590.DivisionID AND AT100501.AccountID = AT1590.ObjectID
LEFT JOIN AT1005 AS AT100502 ON AT100502.DivisionID = AT1590.DivisionID AND AT100502.AccountID = AT1590.CreditObjectID

GO
