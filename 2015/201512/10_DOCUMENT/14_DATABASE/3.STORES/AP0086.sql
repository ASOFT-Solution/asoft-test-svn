IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0086]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0086]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- In Phiếu Kế toán (Phiếu chuyển khoản)
-- Created by Trần Lê Thiên Huỳnh on 21/08/2012
-- EXEC AP0086 'AS', 7, 2012, 'AV20120000000018'

CREATE PROCEDURE [dbo].[AP0086] @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50)
	
 AS
Declare @sSQL as nvarchar(4000),
	@AT9000Cursor as cursor,
	@InvoiceNo as nvarchar(50),
	@Serial as nvarchar(50),
	@InvoiceNoList as nvarchar(500),
	@DebitAccountList as nvarchar(500),
	@DebitAccountID  as nvarchar(50),
	@CreditAccountList as nvarchar(500),
	@CreditAccountID  as nvarchar(50),
	@InvoiceDate nvarchar(10)

Set @sSQL ='
Select 	VoucherID, AT9000.DivisionID, TranMonth, TranYear, 
	Orders,
	VoucherTypeID, VoucherNo, VoucherDate,
	VDescription,
	TDescription,
	BDescription,
	CreditAccountID,
	DebitAccountID, 
	AT9000.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress,
	RefNo01, RefNo02, 
	ConvertedAmount,
	OriginalAmount
	
From AT9000 
Where TransactionTypeID = ''T16'' and
	AT9000.DivisionID = '''+@DivisionID+''' and
	VoucherID ='''+@VoucherID+''' 
'

Print (@sSQL)
EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

