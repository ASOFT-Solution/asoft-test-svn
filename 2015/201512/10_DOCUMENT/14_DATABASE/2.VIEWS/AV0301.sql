IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AV0301]'))
DROP VIEW [dbo].[AV0301]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



------ Created By Nguyen Van Nhan, Sunday 09/11/2003.
----- Purpose Loc cac  hoa  don phat sinh No cong no phat thu
----- Cac truong nhan biet: VoucherID, BatchID,TableID,ObjectID,DebitAccountID,
----Edit By Thien Huynh (13/02/2012): Nhom cac dong cung Hoa don (BatchID) thanh 1 dong, 
----khong nhom theo cac tieu chi khac (Khoan muc)

CREATE VIEW [dbo].[AV0301] AS

SELECT GiveUpID,  K01.VoucherID, BatchID, TableID, K01.DivisionID, TranMonth, TranYear,
 ObjectID, DebitAccountID, CurrencyID, CurrencyIDCN, ObjectName, Ana01ID, Ana02ID, Ana03ID, Ana04ID,
 Ana05ID, OriginalAmount, ConvertedAmount, OriginalAmountCN, GivedOriginalAmount, GivedConvertedAmount,
 ExchangeRate, ExchangeRateCN, VoucherTypeID, VoucherNo, VoucherDate, InvoiceDate,
 InvoiceNo, Serial, VDescription, BDescription, Status, PaymentID, DueDays,
 DueDate

From
(select Isnull(Max(IsMultiTax),0) as IsMultiTax, DivisionID, VoucherID from AT9000  Group by DivisionID, VoucherID) T90
inner join
AV03011 K01

ON K01.DivisionID = T90.DivisionID and K01.VoucherID = T90.VoucherID
Where IsMultiTax =1

Union
SELECT GiveUpID,  K02.VoucherID, BatchID, TableID, K02.DivisionID, TranMonth, TranYear,
 ObjectID, DebitAccountID, CurrencyID, CurrencyIDCN, ObjectName, Ana01ID, Ana02ID, Ana03ID, Ana04ID,
 Ana05ID, OriginalAmount, ConvertedAmount, OriginalAmountCN, GivedOriginalAmount, GivedConvertedAmount,
 ExchangeRate, ExchangeRateCN, VoucherTypeID, VoucherNo, VoucherDate, InvoiceDate,
 InvoiceNo, Serial, VDescription, BDescription, Status, PaymentID, DueDays,
 DueDate

From
(select Isnull(Max(IsMultiTax),0) as IsMultiTax, DivisionID, VoucherID from AT9000  Group by DivisionID, VoucherID) T91
inner join
AV03012 K02
	
ON K02.DivisionID = T91.DivisionID and K02.VoucherID = T91.VoucherID
Where IsMultiTax =0
















