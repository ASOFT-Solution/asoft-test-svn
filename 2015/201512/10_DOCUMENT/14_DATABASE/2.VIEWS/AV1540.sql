
/****** Object:  View [dbo].[AV1540]    Script Date: 12/16/2010 14:42:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created by Huynh Trung Dung, Date 30/03/2007
---- Purpose: Dung de truy van but toan ghi giam TSCD

ALTER VIEW [dbo].[AV1540] as
Select  
	AT1507.ReduceID,AT1507.AssetID,AT1507.AssetName,AT1507.ConvertedReduceFee,
	AT1507.ConvertedReduceAmount,AT1507.AccruedDepAmount,AT1507.ResidualValue,At1507.ReduceNo,At1507.ReduceDate,AT1507.Status,
	AT1507.DepartmentID,AT1507.AssetUser,AT1507.EmployeeID,AT1507.OldAssetStatusID,AT1507.AssetStatusID,AT1507.Description,AT1590.DivisionID, AT1590.TranMonth,
	AT1590.TranYear,VoucherID,BatchID,TransactionID,VoucherDate,VoucherNo,Serial,InvoiceNo,InvoiceDate,VoucherTypeID,
	VDescription,BDescription,TDescription,AT1590.CurrencyID,ExchangeRate,
	Sum(AT1590.OriginalAmount) as OriginalAmount,
	Sum(AT1590.ConvertedAmount) as ConvertedAmount,
	AT1590.ObjectID,AT1202.ObjectName,AT1590.CreditObjectID,T02.ObjectName as CreditObjectName,
	VATTypeID,VATGroupID,DebitAccountID,CreditAccountID,Orders,Ana01ID,Ana02ID,Ana03ID,Ana04ID,
	Ana05ID,DueDate,OrderID,PeriodID,AT1202.VATNo		
From AT1590 Left join AT1202 on AT1202.ObjectID = AT1590.ObjectID
		Left join AT1202 as T02 on T02.ObjectID = AT1590.CreditObjectID
		inner join AT1507 on AT1507.ReduceID=AT1590.VoucherID
--Where TransactionTypeID in ('T99')

Group by  
	At1507.ReduceID,AT1507.AssetID,AT1507.AssetName,AT1507.ConvertedReduceAmount,
	AT1507.ConvertedReduceFee,AT1507.AccruedDepAmount,AT1507.ResidualValue,AT1507.DepartmentID,AT1507.AssetUser,At1507.ReduceNo,
	At1507.ReduceDate,AT1507.Status,AT1507.EmployeeID,At1507.OldAssetStatusID,At1507.AssetStatusID,AT1507.Description,
	AT1590.DivisionID, AT1590.TranMonth, AT1590.TranYear,VoucherID, BatchID,TransactionID,VoucherDate,VoucherNo,
	Serial,InvoiceNo,InvoiceDate,VoucherTypeID,VDescription,BDescription,TDescription,AT1590.CurrencyID,
	ExchangeRate,AT1590.ObjectID,AT1202.ObjectName,AT1590.CreditObjectID,T02.ObjectName,VATTypeID,VATGroupID,
	DebitAccountID,CreditAccountID,Orders,Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,DueDate,OrderID,PeriodID,AT1202.VATNO

GO


