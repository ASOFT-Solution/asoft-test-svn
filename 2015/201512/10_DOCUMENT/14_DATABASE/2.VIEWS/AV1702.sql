/****** Object: View [dbo].[AV1702] Script Date: 12/16/2010 14:52:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created BY Thuy Tuyen and Van Nhan, Date 13/12/2006
---- Purpose: View Chet nham xac dinh nhung khoan Doanh thu ung truoc va chi phi tra truoc chua duoc xac dinh (khai bao )de phan bo
---- Edit BY: Dang Le Bao Quynh; Date: 23/04/2007
---- Purpose: Xac dinh lai cach thuc loc cac chung tu khai bao phan bo

ALTER VIEW [dbo].[AV1702] AS 

SELECT 
VoucherID,
VoucherNo,
VoucherDate,
VDescription, 
DebitAccountID AS AccountID,
TranMonth, 
TranYear, 
DivisionID,
SUM(ConvertedAmount) AS ConvertedAmount,
'D' AS D_C
FROM AT9000
WHERE DebitAccountID IN (SELECT AccountID FROM AT0006 WHERE D_C = 'D' AND DivisionID = AT9000.DivisionID)
GROUP BY VoucherID, VoucherNo, VoucherDate, VDescription, TranMonth, TranYear, DivisionID, DebitAccountID

UNION ALL

SELECT 
VoucherID,
VoucherNo,
VoucherDate,
VDescription, 
CreditAccountID AS AccountID,
TranMonth, 
TranYear, 
DivisionID,
SUM(ConvertedAmount) AS ConvertedAmount,
'C' AS D_C
FROM AT9000
WHERE CreditAccountID IN (SELECT AccountID FROM AT0006 WHERE D_C = 'C' AND DivisionID = AT9000.DivisionID)
GROUP BY VoucherID, VoucherNo, VoucherDate, VDescription, TranMonth, TranYear, DivisionID, CreditAccountID

GO


