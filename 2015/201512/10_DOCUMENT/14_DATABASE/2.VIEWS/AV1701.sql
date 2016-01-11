IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV1701]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV1701]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Created by Dang Le Bao Quynh, Date 15/05/2007
---- Purpose: View Chet nham xac dinh nhung khoan Doanh thu ung truoc va chi phi tra truoc con nhung doi tuong chua thiet lap
---- Edit by: Dang Le Bao Quynh; Date 30/07/2007
---- Purpose: Sua lai cach thuc truy van de tang toc do
---- Edit by: Dang Le Bao Quynh; Date 05/08/2009
---- Purpose: Sua lai dieu kien loai bo cac phieu da duoc khai bao
---- Modified on 30/07/2013 by Le Thi Thu Hien : Bo sung khong lay trong bang AT1603 (Tai san co dinh / Xuat dung trong ky )Mantis 0020320 

CREATE VIEW [dbo].[AV1701] AS 

SELECT 
AT9000.DivisionID, 
AT9000.VoucherID, 
AT9000.DebitAccountID AS AccountID,
AT9000.ObjectID,
AT1202.ObjectName, 
AT9000.Serial,
AT9000.InvoiceNo,
AT9000.InvoiceDate,
AT9000.ConvertedAmount,
AT9000.TransactionID,
'D' AS D_C

FROM AT9000
LEFT JOIN AT1202 ON AT1202.DivisionID = AT9000.DivisionID AND AT1202.ObjectID = AT9000.ObjectID

WHERE AT9000.DebitAccountID IN (SELECT AccountID FROM AT0006 WHERE D_C = 'D' AND DivisionID = AT9000.DivisionID)
AND AT9000.VoucherID + AT9000.TransactionID NOT IN (SELECT ISNULL(VoucherID + TransactionID,'') FROM AT1703 WHERE D_C = 'D' AND DivisionID = AT9000.DivisionID)
AND AT9000.VoucherID + AT9000.TransactionID NOT IN (SELECT ISNULL(ReVoucherID + ReTransactionID,'') FROM AT1603 WHERE DivisionID = AT9000.DivisionID)


UNION ALL

SELECT 
AT9000.DivisionID, 
AT9000.VoucherID, 
AT9000.CreditAccountID AS AccountID,
CASE WHEN AT9000.TransactionTypeID = 'T99' THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END AS ObjectID, 
AT1202.ObjectName,
AT9000.Serial,
AT9000.InvoiceNo,
AT9000.InvoiceDate,
AT9000.ConvertedAmount,
AT9000.TransactionID,
'C' AS D_C

FROM AT9000 
LEFT JOIN AT1202 ON AT1202.DivisionID = AT9000.DivisionID AND CASE WHEN AT9000.TransactionTypeID = 'T99' THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END = AT1202.ObjectID

WHERE AT9000.CreditAccountID IN (SELECT AccountID FROM AT0006 WHERE D_C = 'C' AND DivisionID = AT9000.DivisionID)
AND AT9000.VoucherID + AT9000.TransactionID NOT IN (SELECT ISNULL(VoucherID + TransactionID,'') FROM AT1703 WHERE D_C = 'C' AND DivisionID = AT9000.DivisionID)
AND AT9000.VoucherID + AT9000.TransactionID NOT IN (SELECT ISNULL(ReVoucherID + ReTransactionID,'') FROM AT1603 WHERE DivisionID = AT9000.DivisionID)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

