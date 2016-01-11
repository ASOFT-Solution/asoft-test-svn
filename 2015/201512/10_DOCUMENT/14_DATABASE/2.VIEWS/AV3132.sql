IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV3132]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV3132]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--View chet: lai xuat va tien thuong
--Edit by: Nguyen Quoc Huy, Date : 23/08/2006
--Edit by: Thiên Huỳnh, Date : 12/06/2012: Bổ sung các Khoản mục
CREATE VIEW [dbo].[AV3132] as 
SELECT   VoucherID, BatchID,  TableID, AT9000.DivisionID,TranMonth,TranYear,
	AT9000.ObjectID, DebitAccountID,  AT9000.CurrencyID, CurrencyIDCN,
	AT1202.ObjectName,
	Sum(isnull(OriginalAmount,0)) as OriginalAmount,Sum(isnull(ConvertedAmount,0)) as ConvertedAmount, 
	Sum(isnull(OriginalAmountCN,0)) as OriginalAmountCN,
	GiveOriginalAmount = isnull((Select Sum(isnull(OriginalAmount,0)) From AT0303 Where 	AT0303.DivisionID = AT9000.DivisionID and
										ObjectID = AT9000.ObjectID and
										DebitVoucherID = AT9000.VoucherID and
										DebitBatchID = AT9000.BatchID and
										DebitTableID = At9000.TableID and
										AccountID = AT9000.DebitAccountID and
										CurrencyID = AT9000.CurrencyIDCN),0),
	GiveConvertedAmount =isnull( (Select Sum(isnull(ConvertedAmount,0)) From AT0303 Where 	AT0303.DivisionID = AT9000.DivisionID and
										ObjectID = AT9000.ObjectID and
										DebitVoucherID = AT9000.VoucherID and
										DebitBatchID = AT9000.BatchID and
										DebitTableID = At9000.TableID and
										AccountID = AT9000.DebitAccountID and
										CurrencyID = AT9000.CurrencyIDCN),0),
	--0 as RemainOriginalAmount,
 	--0 as RemainConvertedAmount,
	(Sum(isnull(OriginalAmount,0))  -
		isnull((Select Sum(isnull(OriginalAmount,0)) From AT0303 Where 	AT0303.DivisionID = AT9000.DivisionID and
										ObjectID = AT9000.ObjectID and
										DebitVoucherID = AT9000.VoucherID and
										DebitBatchID = AT9000.BatchID and
										DebitTableID = At9000.TableID and
										AccountID = AT9000.DebitAccountID and
										CurrencyID = AT9000.CurrencyIDCN),0))
	as RemainOriginalAmount,
	0 as RemainConvertedAmount,
	ExchangeRate, ExchangeRateCN,
	VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,
	VDescription, VDescription as BDescription,	
	0  as IsGiveUp,
	AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate,
	--'' as Ana01ID, '' as Ana02ID, '' as   Ana03ID
	Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID
FROM AT9000 Left join AT1202 on AT1202.ObjectID = AT9000.ObjectID and AT1202.DivisionID = AT9000.DivisionID
WHERE DebitAccountID in (Select AccountID From AT1005 Where GroupID ='G03' and  IsObject =1 and AT1005.DivisionID = AT9000.DivisionID)
Group by VoucherID,BatchID,  TableID,AT9000.DivisionID,TranMonth,TranYear,
	AT9000.ObjectID, DebitAccountID,  AT9000.CurrencyID, CurrencyIDCN, AT1202.ObjectName, ExchangeRate,ExchangeRateCN,
	VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,
	VDescription, 
	AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate,
	Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID

GO


