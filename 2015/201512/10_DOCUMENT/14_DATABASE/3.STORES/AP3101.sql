/****** Object:  StoredProcedure [dbo].[AP3101]    Script Date: 07/29/2010 10:51:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----- In phieu tam thu
----- Edit by B.Anh, Date 20/07/2009
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3101] @DivisionID as nvarchar(50),
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
	
SET @AT9010Cursor = CURSOR SCROLL KEYSET FOR
Select Distinct isnull(Serial,'') , isnull(InvoiceNo,''),  ISNULL(convert(nvarchar(10), InvoiceDate, 103),'') as InvoiceDate
		 From AT9010 Where VoucherID = @VoucherID 
				--and TransactionTypeID ='T01'
				and TransactionTypeID in ('T01','T04','T14','T22') AND DivisionID = @DivisionID
		
SET @InvoiceNoList =''

OPEN @AT9010Cursor
FETCH NEXT FROM @AT9010Cursor INTO @Serial , @InvoiceNo,  @InvoiceDate			
WHILE @@FETCH_STATUS = 0
	BEGIN	
	    SET @InvoiceNoList = @InvoiceNoList + @Serial + ', ' + @InvoiceNo + ', ' + @InvoiceDate + '; '
		SET @InvoiceNoList = REPLACE(@InvoiceNoList, ', , ', ', ')
		SET @InvoiceNoList = REPLACE(@InvoiceNoList, ', ; ', '; ')
		SET @InvoiceNoList = REPLACE(@InvoiceNoList, '; , ', '; ')
		
	    FETCH NEXT FROM @AT9010Cursor INTO @Serial , @InvoiceNo,  @InvoiceDate	
    END		
CLOSE @AT9010Cursor

IF((LEFT(@InvoiceNoList, 2) = ', ') OR (LEFT(@InvoiceNoList, 2) = '; '))
    SET @InvoiceNoList = SUBSTRING(@InvoiceNoList, 3, LEN(@InvoiceNoList))  
  
IF((RIGHT(@InvoiceNoList, 2) = ', ') OR (RIGHT(@InvoiceNoList, 2) = '; '))
    SET @InvoiceNoList = SUBSTRING(@InvoiceNoList, 1, LEN(@InvoiceNoList) - 1)    

SET @CreditAccountList =''
SET @AT9010Cursor = CURSOR SCROLL KEYSET FOR
Select Distinct CreditAccountID From AT9010 Where VoucherID =@VoucherID and TransactionTypeID in ('T01','T04','T14', 'T22') AND DivisionID = @DivisionID
OPEN @AT9010Cursor
		FETCH NEXT FROM @AT9010Cursor INTO @CreditAccountID
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @CreditAccountList <>''
				SET @CreditAccountList = @CreditAccountList+'; '+@CreditAccountID
			ELSE
				SET @CreditAccountList  = @CreditAccountID

			FETCH NEXT FROM @AT9010Cursor INTO @CreditAccountID
		END

CLOSE @AT9010Cursor

--print @InvoiceNoList

SET @sSQL ='
Select 	VoucherID, AT9010.DivisionID, TranMonth, TranYear, 
	VoucherTypeID, VoucherNo, VoucherDate,
	VDescription,
	'''+isnull(@InvoiceNoList,'')+''' as InvoiceNoList,
	'''+isnull(@CreditAccountList,'') +''' as CreditAccountID,
	DebitAccountID as AccountID,  
	--ObjectID,
	AT9010.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress,
	RefNo01, RefNo02, 
	FullName,
	ChiefAccountant,
	Sum(ConvertedAmount) as ConvertedAmount,
	Sum(OriginalAmount) as OriginalAmount
	
From AT9010 
Left join AT1103 On AT1103.EmployeeID = AT9010.EmployeeID and AT1103.DivisionID =AT9010.DivisionID
Left join AT0001 On AT0001.DivisionID = AT9010.DivisionID
Where --TransactionTypeID =''T01'' and
	TransactionTypeID in (''T01'',''T04'',''T14'',''T22'') and
	AT9010.DivisionID = '''+@DivisionID+''' and
	VoucherID ='''+@VoucherID+''' 
Group by VoucherID, AT9010.DivisionID, TranMonth, TranYear, 
	VoucherTypeID, VoucherNo, VoucherDate,
	VDescription, DebitAccountID, 
	--ObjectID,
	AT9010.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress, RefNo01, RefNo02,FullName,ChiefAccountant'


--print @sSQL

If Not Exists (Select 1 From sysObjects Where Name ='AV3101')
	Exec ('Create view AV3101 as '+@sSQL)
ELSE
	Exec( 'Alter view AV3101 as '+@sSQL)