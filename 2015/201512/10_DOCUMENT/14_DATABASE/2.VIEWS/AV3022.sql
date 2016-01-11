IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV3022]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV3022]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--- View chet
--- Created by: Nguyen Van Nhan
--- Created Date: 16/2/2004
--- Purpose: Loc ra cac phieu thu - chi - doi tien 
--- Edit by : Nguyen Quoc Huy, Date: 28/03/2007
--- Edit by Trung Dung, date 05/10/2011	Them field ReVoucherID,ReTransactionID (thong tin phieu tam ung ben HRM)
--- Edit by Thiên Huỳnh, date 06/06/2012: Thêm field OldOriginalAmount
--- Edit by Bảo Anh, date 04/12/2012: Thêm field TVoucherID
--- Edit by Khánh Vân, date 21/06/2013: Thêm field TBatchID

CREATE View AV3022 as 

Select 	VoucherTypeID, TransactionTypeID,
	VoucherNo,VoucherDate, 
	DebitAccountID,
	VoucherID,
	TransactionID,
	BatchID,
	CreditAccountID,      ExchangeRate,          OriginalAmount , OriginalAmount As OldOriginalAmount, 
	ConvertedAmount,  InvoiceDate, DueDate,
	
	(Case when AT9000.TransactionTypeID ='T11' and AT9000.CurrencyIDCN<>'VND'  then AT9000.CurrencyIDCN else   AT9000.CurrencyID end)  as CurrencyID,

	VATTypeID,           AT9000.VATGroupID,           
	Serial,               InvoiceNo,            Orders, AT9000.EmployeeID,
	AT9000.ObjectID, 
	(Case when  isnull(AT1202.IsUpdateName,0) <>0 then   VATObjectName else  AT1202.ObjectName end) as ObjectName,
	RefNo01, RefNo02,VDescription, 
	BDescription,TDescription,Quantity,
	AT9000.InventoryID ,         AT9000.UnitID,               Status ,              IsAudit,
	AT9000.CreateDate,                  AT9000.CreateUserID ,        
	AT9000.LastModifyDate ,             AT9000.LastModifyUserID,
	AT9000.DivisionID, TranMonth, TranYear,
	SenderReceiver, SRAddress,  SRDivisionName,
	C.IsObject as CIsObject, D.IsObject as DIsObject,
	isnull(AT1202.IsUpdateName,0) as IsUpdateName,
	AT9000.VATObjectName,
	AT9000.VATObjectAddress,
	(Case when  isnull(AT1202.IsUpdateName,0) <>0 then   AT9000.VATNo  else  AT1202.VATNo  end) as VATNo,
	AT9000.CurrencyIDCN,
	AT9000.ExchangeRateCN,
	AT9000.OriginalAmountCN,
	AT9000.Ana01ID,
	AT9000.Ana02ID,
	AT9000.Ana03ID,
	AT9000.Ana04ID,
	AT9000.Ana05ID,
	AT9000.Ana06ID,
	AT9000.Ana07ID,
	AT9000.Ana08ID,
	AT9000.Ana09ID,
	AT9000.Ana10ID,
	AT9000.OrderID,
	AT9000.PeriodID,
	M01.Description as PeriodName,
        AT9000.ProductID,
	AT02.InventoryName as ProductName,
	AT9000.ReVoucherID,AT9000.ReTransactionID, AT9000.TVoucherID, AT9000.TBatchID

From  AT9000 	Left Join AT1202 on AT9000.ObjectID =  AT1202.ObjectID and AT1202.DivisionID = AT9000.DivisionID
		Inner Join AT1005 D on D.AccountID =  AT9000.DebitAccountID and d.DivisionID = AT9000.DivisionID
		Inner Join AT1005 C on C.AccountID =  AT9000.CreditAccountID and C.DivisionID = AT9000.DivisionID
		Left Join MT1601 M01 on M01.PeriodID = AT9000.PeriodID and M01.DivisionID = AT9000.DivisionID
		Left Join AT1302 as AT02 on  AT02.InventoryID = AT9000.ProductID and AT02.DivisionID = AT9000.DivisionID

Where TransactionTypeID in ('T01','T02','T11') or (TransactionTypeID in ('T04', 'T14') and DebitAccountID like '111%')  
					        or (TransactionTypeID in ('T03', 'T13', 'T23') and CreditAccountID like '111%') 
					        or ( TransactionTypeID ='T21' and CreditAccountID like '111%') 	---- Thu qua ngan hang
					        or ( TransactionTypeID ='T22' and DebitAccountID like '111%') 	---- Chi qua ngan hang					        










GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

