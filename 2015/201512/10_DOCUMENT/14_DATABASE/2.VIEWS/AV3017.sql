IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV3017]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV3017]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---- Created by Nguyen Quoc Huy, Date 21/08/2003
---- Purpose: Dung de truy van but toan tong hop
---- Edited by: Nguyen Quoc Huy, Date 28/03/2007
---- Edited by: Thiên Huỳnh, Date 18/06/2013: Bổ sung Status
---- Edited by: Quốc Tuấn, Date 19/08/2015: Bổ sung thêm cách lấy CreditObjectName
 
CREATE VIEW [dbo].[AV3017] as
Select  AT9000.DivisionID, TranMonth, TranYear,
	VoucherID, BatchID, TransactionID,	AT9000.TableID,
	VoucherDate,VoucherNo, Serial, 
	InvoiceNo, InvoiceDate,
	VoucherTypeID,
	VDescription,
	BDescription,
	TDescription,
	AT9000.CurrencyID,
	ExchangeRate,
	Sum(OriginalAmount) as OriginalAmount,
	Sum(ConvertedAmount) as ConvertedAmount,
	AT9000.ObjectID,
	IsNull(AT9000.VATObjectName, AT1202.ObjectName) AS ObjectName,
	AT1202.Address,AT1202.CityID,AT1002.CityNAme,
	AT9000.CreditObjectID,
	ISNULL(CreditObjectName,T02.ObjectName) as CreditObjectName,
	VATTypeID,
	VATGroupID,
	DebitAccountID,
	CreditAccountID,
	Orders,
	Ana01ID,
	Ana02ID,
	Ana03ID,
	Ana04ID,
	Ana05ID,
	Ana06ID,
	Ana07ID,
	Ana08ID,
	Ana09ID,
	Ana10ID,AT9000.CreateUserID,
	AT9000.Status

	
From AT9000 Left join AT1202 on AT1202.ObjectID = AT9000.ObjectID And AT1202.DivisionID = AT9000.DivisionID
		Left join AT1202 as T02 on T02.ObjectID = AT9000.CreditObjectID And T02.DivisionID = AT9000.DivisionID
		left join AT1002 on AT1002.CityID = AT1202.CityID And AT1002.DivisionID = AT1202.DivisionID
Where TransactionTypeID in ('T99')

Group by  AT9000.DivisionID, TranMonth, TranYear,
	VoucherID, BatchID,TransactionID,AT9000.TableID,
	VoucherDate,VoucherNo, Serial, 
	InvoiceNo,InvoiceDate,
	VoucherTypeID,
	VDescription,
	BDescription,
	TDescription,
	AT9000.CurrencyID,
	ExchangeRate,	
	AT9000.ObjectID,
	AT1202.ObjectName,AT1202.Address,AT1202.CityID,AT1002.CityNAme,
	AT9000.CreditObjectID,
	T02.ObjectName,
	CreditObjectName,
	IsNull(AT9000.VATObjectName, AT1202.ObjectName),
	VATTypeID,
	VATGroupID,
	DebitAccountID,
	CreditAccountID,
	Orders,
	Ana01ID,
	Ana02ID,
	Ana03ID,
	Ana04ID,
	Ana05ID,
	Ana06ID,
	Ana07ID,
	Ana08ID,
	Ana09ID,
	Ana10ID,AT9000.CreateUserID,
	AT9000.Status



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

