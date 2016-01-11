IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AV2006]'))
DROP VIEW [dbo].[AV2006]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Van Nhan, Date 07/01/2004
---- Purpose: Dung de truy van so chung tu
---- Edit by Nguyen Quoc Huy, Date 12/05/2005

CREATE VIEW [dbo].[AV2006] as

SELECT 	
AT2017.DivisionID,
AT2016.VoucherID, 
AT2016.VoucherDate,
AT2016.VoucherNo,
AT2017.TransactionID,
AT2017.InventoryID
FROM AT2017 
INNER JOIN AT2016 ON AT2016.VoucherID = AT2017.VoucherID AND AT2016.DivisionID = AT2017.DivisionID
INNER JOIN AT1302 ON AT1302.InventoryID = AT2017.InventoryID AND AT1302.DivisionID = AT2017.DivisionID
WHERE (AT1302.IsSource = 1 OR AT1302.IsLimitDate = 1 OR AT1302.MethodID = 3)

UNION ALL

SELECT 	
AT2007.DivisionID,
AT2006.VoucherID, 
AT2006.VoucherDate,
AT2006.VoucherNo,
AT2007.TransactionID,
AT2007.InventoryID
FROM AT2007 
INNER JOIN AT2006 ON AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
INNER JOIN AT1302 ON AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
WHERE (AT1302.IsSource = 1 OR AT1302.IsLimitDate = 1 OR AT1302.MethodID = 3) 
AND AT2006.KindVoucherID in (1, 3, 5, 7, 9)

GO


