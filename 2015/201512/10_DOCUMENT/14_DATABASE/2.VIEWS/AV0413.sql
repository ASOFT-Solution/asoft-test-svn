IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0413]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV0413]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--View chet.
--- Last edit by B.Anh	Lay them 5 ma phan tich

CREATE VIEW [dbo].[AV0413] as 
select VoucherID, BatchID, TransactionID, TableID, DivisionID, TranMonth, TranYear, TransactionTypeID, CurrencyID,
		ObjectID, VATNo, VATObjectID, VATObjectName, VATObjectAddress, DebitAccountID, CreditAccountID, ExchangeRate,
        UnitPrice, OriginalAmount, ConvertedAmount, VoucherDate, InvoiceDate, VoucherTypeID, VoucherNo, Serial,
        InvoiceNo, Orders , EmployeeID, RefNo01, RefNo02, VDescription, BDescription, TDescription, Status, IsAudit, 
        CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
		Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID
 
From AT9000
Where TransactiontypeID ='T09'

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

