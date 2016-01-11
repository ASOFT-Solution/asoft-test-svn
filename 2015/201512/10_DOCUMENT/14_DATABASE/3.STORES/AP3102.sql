/****** Object:  StoredProcedure [dbo].[AP3102]    Script Date: 07/29/2010 10:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- In phieu tam chi
--- Created by B.Anh, date 20/07/2009
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3102] @DivisionID as nvarchar(50),
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

SET @InvoiceNoList =''
SET @AT9010Cursor = CURSOR SCROLL KEYSET FOR
Select Distinct isnull(Serial,'') , isnull(InvoiceNo,''), isnull(convert(nvarchar(10), InvoiceDate, 103), '')  as InvoiceDate
		 From AT9010 Where VoucherID =@VoucherID --and TransactionTypeID ='T02'
						and TransactionTypeID in ('T02','T03','T13','T21') AND DivisionID = @DivisionID
OPEN @AT9010Cursor
		FETCH NEXT FROM @AT9010Cursor INTO @Serial , @InvoiceNo, @InvoiceDate
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--If @InvoiceNoList<>''
				--Set @InvoiceNoList = @InvoiceNoList+'; '+@Serial+'.'+@InvoiceNo
				Set @InvoiceNoList = @InvoiceNoList + @Serial + case when @Serial <> '' then ', ' else '' end + @InvoiceNo + 
					case when @invoiceNo <> '' then ', '  else '' end + @InvoiceDate + 
					case when @Serial +  @InvoiceNo +@InvoiceDate <> '' then    '; ' else '' end
--			Else
				--Set @InvoiceNoList =@Serial+'.'+@InvoiceNo
	--			Set @InvoiceNoList = @Serial +  case when @Serial <> '' then ', ' end + @InvoiceNo + 
		--			case when @invoiceNo <> '' then ', ' end + @InvoiceDate + '; '
			

			FETCH NEXT FROM @AT9010Cursor INTO @Serial, @InvoiceNo, @InvoiceDate
		END

CLOSE @AT9010Cursor

SET @DebitAccountList =''
SET @AT9010Cursor = CURSOR SCROLL KEYSET FOR
Select Distinct DebitAccountID From AT9010 Where VoucherID =@VoucherID --and TransactionTypeID ='T02'
										and TransactionTypeID in ('T02','T03','T13','T21') AND DivisionID = @DivisionID

OPEN @AT9010Cursor
		FETCH NEXT FROM @AT9010Cursor INTO @DebitAccountID
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @DebitAccountList<>''
				Set @DebitAccountList = @DebitAccountList+'; '+@DebitAccountID
			Else
				Set @DebitAccountList  = @DebitAccountID

			FETCH NEXT FROM @AT9010Cursor INTO @DebitAccountID
		END

If @InvoiceNoList<>'' 
	Set @InvoiceNoList =replace(@InvoiceNoList,'''','''''')

Set @sSQL ='
Select 	VoucherID, AT9010.DivisionID, TranMonth, TranYear, 
	VoucherTypeID, VoucherNo, VoucherDate,
	VDescription,
	N'''+isnull(@InvoiceNoList,'')+''' as InvoiceNoList,
	N'''+isnull(@DebitAccountList,'') +''' as DebitAccountID,
	CreditAccountID as AccountID, 
	--ObjectID,
	AT9010.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress,
	RefNo01, RefNo02, 
	FullName,
	ChiefAccountant,
	Sum(ConvertedAmount) as ConvertedAmount,
	Sum(OriginalAmount) as OriginalAmount
	
From AT9010 Left join AT1103 On AT1103.EmployeeID = AT9010.EmployeeID and AT1103.DivisionID =AT9010.DivisionID
left join AT0001 on AT0001.DivisionID = AT9010.DivisionID

Where 	--TransactionTypeID =''T02'' and
	TransactionTypeID in (''T02'',''T03'',''T13'',''T21'') and
	VoucherID =N'''+@VoucherID+''' and
	AT9010.DivisionID =N'''+@DivisionID+''' 	
Group by VoucherID, AT9010.DivisionID, TranMonth, TranYear, 
	VoucherTypeID, VoucherNo, VoucherDate,
	VDescription, CreditAccountID, 
	--ObjectID,
	AT9010.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress,RefNo01, RefNo02,FullName,ChiefAccountant'

--print @sSQL

If Not Exists (Select 1 From sysObjects Where Name ='AV3102')
	Exec ('Create view AV3102 as '+@sSQL)
Else
	Exec( 'Alter view AV3102 as '+@sSQL)
