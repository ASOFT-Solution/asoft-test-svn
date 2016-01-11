IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0085]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0085]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Store in hàng hoạt phiếu thu chi ngân hàng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 16/03/2012 by Lê Thị Thu Hiền 
---- 
---- Modified on 16/03/2012 by 
-- <Example>
---- 
CREATE PROCEDURE AP0085
( 
		@DivisionID AS nvarchar(50),
		@UserID AS NVARCHAR(50),
		@TranMonth AS int,
		@TranYear AS int,
		@VoucherID AS nvarchar(50),
		@TransactionTypeID AS nvarchar(50)
) 
AS 
Declare @sSQL AS nvarchar(4000),
		@sSQL1 AS nvarchar(4000),
		@sSQL2 AS nvarchar(4000),
		@AT9000Cursor AS cursor,
		@VoucherIDCursor AS CURSOR,
		@InvoiceCursor AS CURSOR,
		@AccountCursor AS CURSOR,
		@InvoiceNo AS nvarchar(50),
		@Serial AS nvarchar(50),
		@InvoiceDate nvarchar(10),
		@InvoiceNoList AS nvarchar(500),
		@CorAccountID AS NVARCHAR(50),
		@CorAccountList AS NVARCHAR(4000),
		@CorOriginalAmount AS decimal(28,8),
		@CorConvertedAmount AS decimal(28,8),
		@CorOriginalAmount1 AS decimal(28,8),
		@CorOriginalAmount2 AS decimal(28,8),
		@CorOriginalAmount3 AS decimal(28,8),
		@CorConvertedAmount1 AS decimal(28,8),
		@CorConvertedAmount2 AS decimal(28,8),
		@CorConvertedAmount3 AS decimal(28,8),		
		@i AS int




CREATE TABLE #Invoice
(	InvoiceNoList  NVARCHAR(4000)COLLATE SQL_Latin1_General_CP1_CI_AS  NULL CONSTRAINT [DF_#Invoice_InvoiceNoList] DEFAULT (''), 
	VoucherID  NVARCHAR(50)COLLATE SQL_Latin1_General_CP1_CI_AS  NULL CONSTRAINT [DF_#Invoice_VoucherID] DEFAULT ('')
)

CREATE TABLE #CorAccount
(	CorAccountList  NVARCHAR(4000)COLLATE SQL_Latin1_General_CP1_CI_AS  NULL CONSTRAINT [DF_#CorAccountVoucherID] DEFAULT (''),
	VoucherID  NVARCHAR(50)COLLATE SQL_Latin1_General_CP1_CI_AS  NULL CONSTRAINT [DF_#CorAccount_VoucherID] DEFAULT (''),
	CorOriginalAmount1 decimal(28,8) CONSTRAINT [DF_#CorAccount_CorOriginalAmount1] DEFAULT 0,
	CorOriginalAmount2 decimal(28,8) CONSTRAINT [DF_#CorAccount_CorOriginalAmount2] DEFAULT 0,
	CorOriginalAmount3 decimal(28,8) CONSTRAINT [DF_#CorAccount_CorOriginalAmount3] DEFAULT 0,
	CorConvertedAmount1 decimal(28,8) CONSTRAINT [DF_#CorAccount_CorConvertedAmount1] DEFAULT 0,
	CorConvertedAmount2 decimal(28,8) CONSTRAINT [DF_#CorAccount_CorConvertedAmount2] DEFAULT 0,
	CorConvertedAmount3 decimal(28,8) CONSTRAINT [DF_#CorAccount_CorConvertedAmount3] DEFAULT 0
)

SET @VoucherIDCursor = CURSOR SCROLL KEYSET FOR
SELECT DISTINCT KeyID AS VoucherID
FROM	AT0999 
WHERE	TransTypeID = 'AF0085'
		AND UserID = @UserID
		AND Str02 = @DivisionID
		
OPEN @VoucherIDCursor
FETCH NEXT FROM @VoucherIDCursor INTO @VoucherID
	
WHILE @@FETCH_STATUS = 0
BEGIN

	SET	@CorConvertedAmount = 0
	SET	@CorOriginalAmount1 = 0
	SET	@CorOriginalAmount2 = 0
	SET	@CorOriginalAmount3 = 0
	SET	@CorConvertedAmount1 = 0
	SET	@CorConvertedAmount2 = 0
	SET	@CorConvertedAmount3 = 0
	SET @CorOriginalAmount = 0
	SET @CorConvertedAmount = 0
	SET @InvoiceNoList = ''
	SET @CorAccountList = ''
	SET @i = 1
	
	SET @InvoiceCursor = CURSOR SCROLL KEYSET FOR

	SELECT	DISTINCT ISNULL(Serial,'') , 
			ISNULL(InvoiceNo,'') ,
			ISNULL(CONVERT(NVARCHAR(10), InvoiceDate, 103),'') AS InvoiceDate
	FROM	AT9000 
	WHERE	VoucherID = @VoucherID
			AND TransactionTypeID = @TransactionTypeID

			
	OPEN @InvoiceCursor
			FETCH NEXT FROM @InvoiceCursor INTO @Serial , @InvoiceNo,  @InvoiceDate
				
			WHILE @@FETCH_STATUS = 0
			BEGIN
				If @InvoiceNoList<>''
					Set @InvoiceNoList = @InvoiceNoList + @Serial + @InvoiceNo + @InvoiceDate
				Else
					Set @InvoiceNoList =@Serial + @InvoiceNo + @InvoiceDate

				FETCH NEXT FROM @InvoiceCursor INTO @Serial, @InvoiceNo, @InvoiceDate
			END

	CLOSE @InvoiceCursor
	
	INSERT INTO #Invoice
	VALUES (REPLACE(@InvoiceNoList,'',''''), @VoucherID)

	SET @CorAccountList =''
	SET @AccountCursor = CURSOR SCROLL KEYSET FOR
	SELECT	DISTINCT CASE WHEN @TransactionTypeID = 'T21' THEN CreditAccountID ELSE DebitAccountID END AS CorAccountID,
			SUM(OriginalAmount) AS OriginalAmount, 
			SUM(ConvertedAmount) AS ConvertedAmount 
	FROM	AT9000 
	WHERE	VoucherID = @VoucherID
			AND TransactionTypeID = @TransactionTypeID
	GROUP BY	CASE WHEN @TransactionTypeID = 'T21' THEN CreditAccountID ELSE DebitAccountID END
			
	OPEN @AccountCursor
		FETCH NEXT FROM @AccountCursor INTO @CorAccountID, @CorOriginalAmount, @CorConvertedAmount  
		WHILE @@FETCH_STATUS = 0
		BEGIN

			If @CorAccountList <>''
				SET @CorAccountList = @CorAccountList+'; '+@CorAccountID
			Else
				SET @CorAccountList  = @CorAccountID
			If @i = 1
				Begin
					SET @CorOriginalAmount1 = @CorOriginalAmount 
					SET @CorConvertedAmount1 = @CorConvertedAmount 
				End	
			Else
				If @i = 2
					Begin
						SET @CorOriginalAmount2 = @CorOriginalAmount 
						SET @CorConvertedAmount2 = @CorConvertedAmount 
					End	
				Else
					If @i =3
						Begin
							SET @CorOriginalAmount3 = @CorOriginalAmount 
							SET @CorConvertedAmount3 = @CorConvertedAmount 
						End
						
			SET @i = @i + 1
			FETCH NEXT FROM @AccountCursor INTO @CorAccountID, @CorOriginalAmount, @CorConvertedAmount
			END

		CLOSE @AccountCursor

	INSERT INTO #CorAccount
	VALUES (@CorAccountList, @VoucherID, 
			@CorOriginalAmount1, @CorOriginalAmount2, @CorOriginalAmount3,
			@CorConvertedAmount1, @CorConvertedAmount2, @CorConvertedAmount3)
	
FETCH NEXT FROM @VoucherIDCursor INTO @VoucherID
			END

	CLOSE @VoucherIDCursor
	
	--SELECT * FROM #Invoice
	--SELECT * FROM #CorAccount
			
	SELECT 	AT9000.VoucherID, AT9000.DivisionID, TranMonth, TranYear, 
			VoucherTypeID, VoucherNo, VoucherDate,
			VDescription,
			InvoiceNoList ,
			CorAccountList , 
			CorOriginalAmount1 , CorOriginalAmount2 , 	CorOriginalAmount3 , 
			CorConvertedAmount1 , CorConvertedAmount2 , CorConvertedAmount3 , 
			CASE WHEN @TransactionTypeID = 'T21' THEN DebitAccountID ELSE CreditAccountID END AS AccountID,  
			Max(AT9000.ObjectID) AS ObjectID,
			AT9000.CurrencyID, ExchangeRate,
			SenderReceiver, SRDivisionName, SRAddress,
			RefNo01, RefNo02, 
			CASE WHEN @TransactionTypeID = 'T21' THEN DebitBankAccountID ELSE CreditBankAccountID END BankAccountID, 
			AT1016.BankName, AT1016.BankAccountNo,
			AT1101.Address as DivisionAddress,
			Sum(ConvertedAmount) AS ConvertedAmount,
			Sum(OriginalAmount) AS OriginalAmount,
			Case When AT1202.IsUpdateName = 1 Then VATObjectAddress Else AT1202.Address End As ObjectAddress
	FROM	AT9000 
	LEFT JOIN #Invoice I ON I.VoucherID = AT9000.VoucherID
	LEFT JOIN #CorAccount C ON C.VoucherID = AT9000.VoucherID
	LEFT JOIN AT1202 on AT1202.DivisionID = AT9000.DivisionID AND AT9000.ObjectID = AT1202.ObjectID
	LEFT JOIN AT1016 on AT1016.DivisionID = AT9000.DivisionID AND AT1016.BankAccountID = CASE WHEN @TransactionTypeID = 'T21' THEN AT9000.DebitBankAccountID ELSE AT9000.CreditBankAccountID END
	LEFT JOIN AT1101 on AT1101.DivisionID = AT9000.DivisionID AND AT1101.DivisionID = AT9000.DivisionID
		
	WHERE 	TransactionTypeID = @TransactionTypeID and
			AT9000.DivisionID = @DivisionID and
			AT9000.VoucherID IN (	SELECT DISTINCT KeyID AS VoucherID
									FROM	AT0999 
									WHERE	TransTypeID = 'AF0085'
											AND UserID = @UserID
											AND Str02 = @DivisionID
								)
	GROUP BY AT9000.VoucherID, AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear, 
			VoucherTypeID, VoucherNo, VoucherDate, 
			CASE WHEN @TransactionTypeID = 'T21' THEN DebitAccountID ELSE CreditAccountID END,
			CASE WHEN @TransactionTypeID = 'T21' THEN DebitBankAccountID ELSE CreditBankAccountID END,
			AT1016.BankName, AT1016.BankAccountNo, VDescription, DebitAccountID, 
			AT9000.CurrencyID, ExchangeRate,
			SenderReceiver, SRDivisionName, SRAddress, RefNo01, RefNo02,
			AT1101.Address,
			CASE WHEN AT1202.IsUpdateName = 1 THEN VATObjectAddress ELSE AT1202.Address END,
			InvoiceNoList, CorAccountList , 
			CorOriginalAmount1 , 		CorOriginalAmount2 , 			CorOriginalAmount3 , 
			CorConvertedAmount1 , 		CorConvertedAmount2 , 			CorConvertedAmount3 



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

