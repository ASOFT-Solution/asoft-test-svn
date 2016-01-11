/****** Object:  View [dbo].[AV1690]    Script Date: 12/16/2010 14:48:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Quoc Huy, Date 06/07/2009
---- Purpose: Dung de truy van but toan thay doi nguyen gia CCDC
---- Edited by Bao Anh	Date: 08/07/2012
---- Purpose: Lay truong ReVoucherID

ALTER VIEW [dbo].[AV1690] AS

SELECT   
-- Thông tin chung
AT1690.DivisionID, 
AT1690.VoucherID, 
AT1690.Orders,
AT1690.BatchID, 
AT1606.ToolID,
AT1606.ToolName,
AT1606.AccuDepAmount,
AT1606.DepreciatedPeriods,
AT1690.VoucherTypeID,
AT1690.VoucherDate,
AT1690.VoucherNo, 
AT1606.RevaluateID,
AT1606.IsRevaluate,
AT1606.ReValuateNo,
AT1606.Ischange,
AT1606.OldDepartmentID,
AT1606.DepOldAmount,
AT1606.ConvertedOldAmount,
AT1606.ResidualOldValue,
AT1606.DepOldPeriods,
AT1606.DepNewAmount,
AT1606.ConvertedNewAmount,
AT1606.ResidualNewValue,
AT1606.DepNewPeriods,
AT1606.DepNewPercent,

-- Thông tin chứng từ 
AT1690.TransactionID,
AT1690.Serial, 
AT1690.InvoiceNo, 	
AT1690.InvoiceDate,
AT1690.DueDate,
AT1690.OriginalAmount,
AT1690.ConvertedAmount,
AT1690.DebitAccountID,
AT1690.CreditAccountID,
AT1690.VATTypeID,
AT1690.VATGroupID,
AT1690.BDescription,
AT1690.TDescription,
AT1690.VDescription,
AT1690.OrderID,

-- Mã phân tích
AT1690.Ana01ID,
AT1690.Ana02ID,
AT1690.Ana03ID,
AT1690.Ana04ID,
AT1690.Ana05ID,
AT1690.Ana06ID,
AT1690.Ana07ID,
AT1690.Ana08ID,
AT1690.Ana09ID,
AT1690.Ana10ID,

-- Thông tin tiền tệ
AT1690.CurrencyID,
AT1690.ExchangeRate,
AT1004.Operator,
AT1004.ExchangeRateDecimal,

-- Thông tin đối tượng tập hợp chi phí
AT1690.PeriodID,
MT1601.Description AS PeriodName,

-- Thông tin đối tượng nợ
AT1690.ObjectID,
AT120201.ObjectName,
AT100501.IsObject,
AT120201.IsUpdateName,
AT120201.VATNo,

-- Thông tin đối tượng có
AT1690.CreditObjectID,
AT120202.ObjectName AS CreditObjectName,
AT100502.IsObject AS IsCreditObject,
AT120202.IsUpdateName AS IsCreditUpdateName,

-- Thông tin sản phẩm
AT1690.ProductID,
AT1302.InventoryName AS ProductName,

--- ReVoucherID
AT1606.ReVoucherID

FROM AT1690 
INNER JOIN AT1606            ON AT1606.DivisionID = AT1690.DivisionID AND AT1606.RevaluateID = AT1690.VoucherID

LEFT JOIN AT1004             ON AT1004.DivisionID = AT1690.DivisionID AND AT1004.CurrencyID = AT1690.CurrencyID
LEFT JOIN MT1601             ON MT1601.DivisionID = AT1690.DivisionID AND MT1601.PeriodID = AT1690.PeriodID
LEFT JOIN AT1302             ON AT1302.DivisionID = AT1690.DivisionID AND AT1302.InventoryID = AT1690.ProductID
LEFT JOIN AT1202 AS AT120201 ON AT120201.DivisionID = AT1690.DivisionID AND AT120201.ObjectID = AT1690.ObjectID
LEFT JOIN AT1202 AS AT120202 ON AT120202.DivisionID = AT1690.DivisionID AND AT120202.ObjectID = AT1690.CreditObjectID
LEFT JOIN AT1005 AS AT100501 ON AT100501.DivisionID = AT1690.DivisionID AND AT100501.AccountID = AT1690.ObjectID
LEFT JOIN AT1005 AS AT100502 ON AT100502.DivisionID = AT1690.DivisionID AND AT100502.AccountID = AT1690.CreditObjectID

GO

