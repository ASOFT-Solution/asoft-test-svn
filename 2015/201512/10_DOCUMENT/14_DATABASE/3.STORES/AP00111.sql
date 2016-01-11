IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP00111]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP00111]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by: Khanh Van
---- Date: 23/09/2013
---- Purpose: Cai thien toc do man hinh giai tru cong no phai thu

CREATE PROCEDURE [dbo].[AP00111] 
		@DivisionID nvarchar(50),
		@ObjectID nvarchar(50),
		@AccountID nvarchar(50)

			
 AS

Declare @sqlSelect as nvarchar(4000) =N'',
		@sqlSelect1 as nvarchar(4000) =N'',
		@sqlSelect2 as nvarchar(4000) =N'',
		@sqlExec as nvarchar(4000) =N'',
		@sqlExec1 as nvarchar(4000) =N'',
		@sqlExec2 as nvarchar(4000) =N'',
		@CustomerName INT		
		
		CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

IF @CustomerName = 16 --- Customize Sieu Thanh
	EXEC AP00111_ST @DivisionID, @ObjectID, @AccountID
ELSE
Begin

Set @sqlSelect = N'
	  Delete AT0301
	  WHERE DivisionID = '''+@DivisionID+''' and DebitAccountID like('''+@AccountID+''') and ObjectID like ('''+@ObjectID+''')
	  Insert AT0301 (GiveUpID, VoucherID, BatchID,  TableID, DivisionID,TranMonth,TranYear,
      ObjectID, DebitAccountID, CurrencyID, CurrencyIDCN,
      ObjectName, OriginalAmount,ConvertedAmount,
      OriginalAmountCN, GivedOriginalAmount,  GivedConvertedAmount,   ExchangeRate, ExchangeRateCN,
      VoucherTypeID, VoucherNO, VoucherDate,  InvoiceDate,InvoiceNo, Serial,
      VDescription,BDescription,  Status,   PaymentID, DueDays, DueDate)
      SELECT GiveUpID, VoucherID, BatchID,  TableID, DivisionID,TranMonth,TranYear,
      ObjectID, DebitAccountID, CurrencyID, CurrencyIDCN,
      ObjectName , OriginalAmount, ConvertedAmount,
      OriginalAmountCN,GivedOriginalAmount,GivedConvertedAmount,  ExchangeRate, ExchangeRateCN,
      VoucherTypeID, VoucherNO, VoucherDate,  InvoiceDate,InvoiceNo, Serial,
      VDescription,BDescription,  Status, PaymentID , DueDays, DueDate
      From
      '

Set @sqlSelect1 = N'
(SELECT '''' AS GiveUpID, VoucherID, BatchID, TableID, AT9000.DivisionID, TranMonth, TranYear,
	AT9000.ObjectID, DebitAccountID, AT9000.CurrencyID, CurrencyIDCN, AT1202.ObjectName, 
	Max(Ana02ID) As Ana02ID, 
	Sum(isnull(OriginalAmount,0)) as OriginalAmount,
	Sum(isnull(ConvertedAmount,0)) as ConvertedAmount, 
	Sum(isnull(OriginalAmountCN,0)) as OriginalAmountCN,
	GivedOriginalAmount = isnull((Select Sum(isnull(OriginalAmount,0)) From AT0303 Where 	DivisionID = AT9000.DivisionID and
										ObjectID = AT9000.ObjectID and
										DebitVoucherID = AT9000.VoucherID and
										DebitBatchID = AT9000.BatchID and
										DebitTableID = At9000.TableID and
										AccountID = AT9000.DebitAccountID and
										CurrencyID = AT9000.CurrencyIDCN),0),
	GivedConvertedAmount =isnull( (Select Sum(isnull(ConvertedAmount,0)) From AT0303 Where 	DivisionID = AT9000.DivisionID and
										ObjectID = AT9000.ObjectID and
										DebitVoucherID = AT9000.VoucherID and
										DebitBatchID = AT9000.BatchID and
										DebitTableID = At9000.TableID and
										AccountID = AT9000.DebitAccountID and
										CurrencyID = AT9000.CurrencyIDCN),0),
	ExchangeRate, ExchangeRateCN,
	VoucherTypeID, VoucherNo, VoucherDate, InvoiceDate, InvoiceNo, Serial,
	VDescription, VDescription AS BDescription, 0 AS Status,
	AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate
FROM AT9000 Left join AT1202 on AT1202.ObjectID = AT9000.ObjectID and AT1202.DivisionID = AT9000.DivisionID
WHERE DebitAccountID like('''+@AccountID+''') and AT9000.ObjectID like ('''+@ObjectID+''')
	and AT9000.DivisionID = '''+@DivisionID+'''
Group by VoucherID, BatchID, TableID, AT9000.DivisionID, TranMonth, TranYear,
	AT9000.ObjectID, DebitAccountID, AT9000.CurrencyID, CurrencyIDCN, AT1202.ObjectName, 
	ExchangeRate, ExchangeRateCN,
	VoucherTypeID, VoucherNo, VoucherDate, InvoiceDate, InvoiceNo, Serial,
	VDescription, AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate)B'
	
Exec(@sqlSelect +  @sqlSelect1)

End

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON