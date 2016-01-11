IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3501]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3501]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- In phieu tam chi qua ngan hang
----- Created by Bao Anh, Date: 01/08/2012

CREATE PROCEDURE [dbo].[AP3501] 
(
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@TranMonth AS INT,
	@TranYear AS INT,
	@VoucherID AS NVARCHAR(50)
)
 AS
Declare @sSQL AS nvarchar(4000),
		@AT9010Cursor AS cursor,
		@InvoiceNo AS nvarchar(50),
		@Serial AS nvarchar(50),
		@InvoiceNoList AS nvarchar(500),
		@DebitAccountList AS nvarchar(500),
		@DebitAccountID  AS nvarchar(50),
		@DebitOriginalAmount AS decimal(28,8),
		@DebitConvertedAmount AS decimal(28,8),
		@InvoiceDate nvarchar(10),
		@SumDebitOriginalAmount AS decimal(28,8),
		@SumDebitConvertedAmount AS decimal(28,8)

SET @InvoiceNoList =''
SET @DebitOriginalAmount = 0
SET @DebitConvertedAmount = 0
SET @SumDebitOriginalAmount = 0
SET @SumDebitConvertedAmount = 0

SET @AT9010Cursor = CURSOR SCROLL KEYSET FOR
SELECT	Distinct isnull(Serial,'') , 
		isnull(InvoiceNo,'') ,
		ISNULL(convert(nvarchar(10), InvoiceDate, 103),'') AS InvoiceDate
FROM	AT9010 
WHERE	VoucherID =@VoucherID AND DivisionID =@DivisionID and TransactionTypeID ='T22'
OPEN @AT9010Cursor
		FETCH NEXT FROM @AT9010Cursor INTO @Serial , @InvoiceNo, @InvoiceDate
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @InvoiceNoList<>''
				Set @InvoiceNoList = @InvoiceNoList + @Serial + @InvoiceNo + @InvoiceDate
			Else
				Set @InvoiceNoList =@Serial + @InvoiceNo +@InvoiceDate

			FETCH NEXT FROM @AT9010Cursor INTO @Serial, @InvoiceNo, @InvoiceDate
		END

CLOSE @AT9010Cursor

SET @DebitAccountList =''
SET @AT9010Cursor = CURSOR SCROLL KEYSET FOR
SELECT	DISTINCT DebitAccountID,
		SUM(OriginalAmount) AS OriginalAmount, 
		SUM(ConvertedAmount) AS ConvertedAmount  
FROM	AT9010 
WHERE	VoucherID = @VoucherID AND DivisionID =@DivisionID
		AND TransactionTypeID ='T22'
GROUP BY DebitAccountID
		
OPEN @AT9010Cursor
		FETCH NEXT FROM @AT9010Cursor INTO @DebitAccountID, @DebitOriginalAmount, @DebitConvertedAmount
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @DebitAccountList<>''
				Set @DebitAccountList = @DebitAccountList+'; '+@DebitAccountID
			Else
				Set @DebitAccountList  = @DebitAccountID
			
			SET @SumDebitOriginalAmount = @SumDebitOriginalAmount + @DebitOriginalAmount
			SET @SumDebitConvertedAmount = @SumDebitConvertedAmount + @DebitConvertedAmount
			
			FETCH NEXT FROM @AT9010Cursor INTO @DebitAccountID, @DebitOriginalAmount, @DebitConvertedAmount
		END
CLOSE @AT9010Cursor

If @InvoiceNoList<>'' 
	Set @InvoiceNoList =' Keøm theo: '+@InvoiceNoList+' laøm chöùng töø goác'

Set @sSQL =N'
SELECT * FROM 
(
Select 	VoucherID, AT9010.DivisionID, DivisionName, TranMonth, TranYear, 
		VoucherTypeID, VoucherNo, VoucherDate,
		VDescription, 
		CreditBankAccountID,  
		AT1016.BankAccountNo AS CreditBankAccountNo, 
		AT1016.BankName AS CreditBankName,
		'''+isnull(@InvoiceNoList,'')+''' AS InvoiceNoList,
		'''+isnull(@DebitAccountList,'') +''' AS DebitAccountID,'
		+ ltrim(@SumDebitOriginalAmount) + ' AS OriginalAmount, '
		+ ltrim(@SumDebitConvertedAmount) + ' AS ConvertedAmount,
		CreditAccountID AS AccountID, 
		AT9010.CurrencyID, ExchangeRate,
		SenderReceiver, SRDivisionName, SRAddress,
		RefNo01, RefNo02,
		(	SELECT TOP 1 ObjectID 
			FROM	AT9010 
		 	WHERE 	TransactionTypeID = ''T22'' 
		 			AND	VoucherID = '''+@VoucherID+''' 
		 			AND	DivisionID ='''+@DivisionID+''' 
		) AS ObjectID,
		ObjectName, AT1202.Address AS ObjectAddress, AT1202.CityID,
		AT1202.BankAccountNo AS DebitBankAccountNo, AT1202.BankName AS DebitBankName,
		---Sum(ConvertedAmount) AS ConvertedAmount,
		---Sum(OriginalAmount) AS OriginalAmount,
		AT1202.Note, AT1202.Note1
	
FROM AT9010 
LEFT JOIN AT1016 on AT1016.DivisionID = AT9010.DivisionID AND AT1016.BankAccountID = AT9010.CreditBankAccountID
LEFT JOIN AT1101 on AT1101.DivisionID = AT9010.DivisionID AND AT1101.DivisionID = AT9010.DivisionID
LEFT JOIN AT1202 on AT1202.DivisionID = AT9010.DivisionID AND AT1202.ObjectID = (SELECT TOP 1 ObjectID 
                                                                                 FROM	AT9010 
                                                                                 WHERE 	TransactionTypeID = ''T22'' 
																						AND	VoucherID = '''+@VoucherID+''' 
																						AND	AT9010.DivisionID ='''+@DivisionID+''' )
WHERE 	TransactionTypeID =''T22'' and
		VoucherID ='''+@VoucherID+''' and
		AT9010.DivisionID ='''+@DivisionID+''' 	
GROUP BY VoucherID, AT9010.DivisionID, DivisionName, TranMonth, TranYear, 
		VoucherTypeID, VoucherNo, VoucherDate,
		VDescription, CreditBankAccountID, AT1016.BankAccountNo, AT1016.BankName,
		AT1202.BankAccountNo, AT1202.BankName, AT1202.Address,
		CreditAccountID, AT9010.CurrencyID, ExchangeRate,
		SenderReceiver, SRDivisionName, SRAddress,RefNo01, RefNo02, ObjectName , AT1202.CityID, At1202.Note, AT1202.Note1) A'


EXEC(@Ssql)