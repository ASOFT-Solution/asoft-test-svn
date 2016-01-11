IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0259]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0259]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- In Phiếu Kế toán (Phiếu tạm thu qua ngân hàng)
-- Created by Trần Lê Thiên Huỳnh on 17/08/2012
-- EXEC AP0259 'AS', 7, 2012, 'AV20120000000018'

CREATE PROCEDURE [dbo].[AP0259] @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50)
	
 AS
Declare @sSQL as nvarchar(4000),
	@AT9010Cursor as cursor,
	@InvoiceNo as nvarchar(50),
	@Serial as nvarchar(50),
	@InvoiceNoList as nvarchar(500),
	@DebitAccountList as nvarchar(500),
	@DebitAccountID  as nvarchar(50),
	@CreditAccountList as nvarchar(500),
	@CreditAccountID  as nvarchar(50),
	@InvoiceDate nvarchar(10)

Set @sSQL ='
Select 	VoucherID, AT9010.DivisionID, TranMonth, TranYear, 
	Orders,
	VoucherTypeID, VoucherNo, VoucherDate,
	VDescription,
	TDescription,
	BDescription,
	CreditAccountID,
	DebitAccountID, 
	AT9010.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress,
	RefNo01, RefNo02, 
	ConvertedAmount,
	OriginalAmount
	
From AT9010 
Where TransactionTypeID = ''T21'' and
	AT9010.DivisionID = '''+@DivisionID+''' and
	VoucherID ='''+@VoucherID+''' 
'

Print (@sSQL)
EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

