IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0401]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV0401]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


------ Created By Nguyen Van Nhan, Sunday 09/11/2003.
----- Purpose Loc cac  hoa  don phat sinh No cong no phat tra
----- Cac truong nhan biet: VoucherID, BatchID,TableID,ObjectID,DebitAccountID,
--Quoc Huy, Date 07/01/2009
----Edit By Thien Huynh (13/02/2012): Nhom cac dong cung Hoa don (BatchID) thanh 1 dong, 
----khong nhom theo cac tieu chi khac (Khoan muc)

CREATE VIEW [dbo].[AV0401] as 
SELECT  '' As GiveUpID, VoucherID, BatchID, TableID, AT9000.DivisionID, TranMonth, TranYear,
	AT9000.ObjectID, DebitAccountID, AT9000.CurrencyID, AT9000.CurrencyIDCN, AT1202.ObjectName,	
	Sum(isnull(OriginalAmount,0)) as OriginalAmount,
	Sum(isnull(ConvertedAmount,0)) as ConvertedAmount, 
	Sum(isnull(OriginalAmountCN,0)) as OriginalAmountCN,
	GivedOriginalAmount = isnull((Select Sum(isnull(OriginalAmount,0)) From AT0404 Where 	DivisionID = AT9000.DivisionID and
										ObjectID = AT9000.ObjectID and
										DebitVoucherID = AT9000.VoucherID and
										DebitBatchID = AT9000.BatchID and
										DebitTableID = At9000.TableID and
										AccountID = AT9000.DebitAccountID and
										CurrencyID = AT9000.CurrencyIDCN),0)-
						isnull((Select Sum(isnull(OriginalAmount,0)) From AT0404 Where 	DivisionID = AT9000.DivisionID and
										ObjectID = AT9000.ObjectID and
										CreditVoucherID = AT9000.VoucherID and
										CreditBatchID = AT9000.BatchID and
										CreditTableID = At9000.TableID and
										AccountID = AT9000.DebitAccountID and
										CurrencyID = AT9000.CurrencyIDCN),0)
										,
	GivedConvertedAmount =isnull( (Select Sum(isnull(ConvertedAmount,0)) From AT0404 Where 	DivisionID = AT9000.DivisionID and
										ObjectID = AT9000.ObjectID and
										DebitVoucherID = AT9000.VoucherID and
										DebitBatchID = AT9000.BatchID and
										DebitTableID = At9000.TableID and
										AccountID = AT9000.DebitAccountID and
										CurrencyID = AT9000.CurrencyIDCN),0)-
							isnull( (Select Sum(isnull(ConvertedAmount,0)) From AT0404 Where 	DivisionID = AT9000.DivisionID and
										ObjectID = AT9000.ObjectID and
										CreditVoucherID = AT9000.VoucherID and
										CreditBatchID = AT9000.BatchID and
										CreditTableID = At9000.TableID and
										AccountID = AT9000.DebitAccountID and
										CurrencyID = AT9000.CurrencyIDCN),0)
										,
	ExchangeRate, ExchangeRateCN, VoucherTypeID, VoucherNo, VoucherDate, InvoiceDate, InvoiceNo, Serial,
	VDescription, VDescription as BDescription, Status, AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate, 
	Max(Ana01ID) As Ana01ID
FROM AT9000 Left join AT1202 on AT1202.ObjectID = AT9000.ObjectID and AT1202.DivisionID = AT9000.DivisionID
WHERE DebitAccountID in (Select AccountID From AT1005 Where GroupID ='G04' and  IsObject =1)
Group by VoucherID, BatchID, TableID, AT9000.DivisionID, TranMonth, TranYear,
	AT9000.ObjectID, DebitAccountID, AT9000.CurrencyID, AT9000.CurrencyIDCN, AT1202.ObjectName,
	ExchangeRate, ExchangeRateCN, VoucherTypeID, VoucherNo, VoucherDate, InvoiceDate, InvoiceNo, Serial,
	VDescription, Status, AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

