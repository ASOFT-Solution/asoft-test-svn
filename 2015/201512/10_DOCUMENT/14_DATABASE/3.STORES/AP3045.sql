IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3045]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP3045]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




----- In phieu Chi qua ngan hang
----- Created by Nguyen Thi Ngoc Minh, Date 24/09/2004
---- Modified on 16/03/2012 by Lê Thị Thu Hiền : Bổ sung trường DebitOriginalAmount1, 2, 3 và DebitConvertedAmount1, 2, 3
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'* Edited by: [GS] [Tố Oanh] [24/01/2014]: bổ sung AT1002.CityName
---- Modified by Thanh Sơn on 30/03/2015: Bổ sung thêm 10 mã phân tích (ID + Name)
'********************************************/

CREATE PROCEDURE [dbo].[AP3045] 
				@DivisionID AS nvarchar(50),
				@TranMonth AS int,
				@TranYear AS int,
				@VoucherID AS nvarchar(50)
	
 AS
Declare @sSQL nvarchar(MAX), @sSQL1 NVARCHAR(MAX),
		@AT9000Cursor AS cursor,
		@InvoiceNo AS nvarchar(50),
		@Serial AS nvarchar(50),
		@InvoiceNoList AS nvarchar(500),
		@DebitAccountList AS nvarchar(500),
		@DebitAccountID  AS nvarchar(50),
		@CreditAccountList AS varchar(500),
		@CreditAccountID  AS nvarchar(50),
		@CreditBankAccountID AS nvarchar(50),
		@DebitOriginalAmount AS decimal(28,8),
		@DebitOriginalAmount1 AS decimal(28,8),
		@DebitOriginalAmount2 AS decimal(28,8),
		@DebitOriginalAmount3 AS decimal(28,8),
		@DebitConvertedAmount AS decimal(28,8),
		@DebitConvertedAmount1 AS decimal(28,8),
		@DebitConvertedAmount2 AS decimal(28,8),
		@DebitConvertedAmount3 AS decimal(28,8),	
		@InvoiceDate nvarchar(10),
		@i AS int

SET @InvoiceNoList =''
SET @CreditAccountList = ''
SET @i = 1
SET @DebitOriginalAmount = 0
SET @DebitOriginalAmount1 = 0
SET @DebitOriginalAmount2 = 0
SET @DebitOriginalAmount3 = 0
SET @DebitConvertedAmount = 0
SET @DebitConvertedAmount1 = 0
SET @DebitConvertedAmount2 = 0
SET @DebitConvertedAmount3 = 0

SET @AT9000Cursor = CURSOR SCROLL KEYSET FOR
SELECT	Distinct isnull(Serial,'') , 
		isnull(InvoiceNo,'') ,
		ISNULL(convert(nvarchar(10), InvoiceDate, 103),'') AS InvoiceDate
FROM	AT9000 
WHERE	VoucherID =@VoucherID AND DivisionID =@DivisionID and TransactionTypeID ='T22'
OPEN @AT9000Cursor
		FETCH NEXT FROM @AT9000Cursor INTO @Serial , @InvoiceNo, @InvoiceDate
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @InvoiceNoList<>''
				Set @InvoiceNoList = @InvoiceNoList + @Serial + @InvoiceNo + @InvoiceDate
			Else
				Set @InvoiceNoList =@Serial + @InvoiceNo +@InvoiceDate

			FETCH NEXT FROM @AT9000Cursor INTO @Serial, @InvoiceNo, @InvoiceDate
		END

CLOSE @AT9000Cursor

SET @DebitAccountList =''
SET @AT9000Cursor = CURSOR SCROLL KEYSET FOR
SELECT	DISTINCT DebitAccountID,
		SUM(OriginalAmount) AS OriginalAmount, 
		SUM(ConvertedAmount) AS ConvertedAmount  
FROM	AT9000 
WHERE	VoucherID = @VoucherID AND DivisionID =@DivisionID
		AND TransactionTypeID ='T22'
GROUP BY DebitAccountID
		
OPEN @AT9000Cursor
		FETCH NEXT FROM @AT9000Cursor INTO @DebitAccountID, @DebitOriginalAmount, @DebitConvertedAmount
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @DebitAccountList<>''
				Set @DebitAccountList = @DebitAccountList+'; '+@DebitAccountID
			Else
				Set @DebitAccountList  = @DebitAccountID

			If @i = 1
				Begin
					SET @DebitOriginalAmount1 = @DebitOriginalAmount 
					SET @DebitConvertedAmount1 = @DebitConvertedAmount 
				End	
			Else
				If @i = 2
					Begin
						SET @DebitOriginalAmount2 = @DebitOriginalAmount 
						SET @DebitConvertedAmount2 = @DebitConvertedAmount 
					End	
				Else
					If @i =3
						Begin
							SET @DebitOriginalAmount3 = @DebitOriginalAmount 
							SET @DebitConvertedAmount3 = @DebitConvertedAmount 
						End
						
			SET @i = @i + 1
			
			FETCH NEXT FROM @AT9000Cursor INTO @DebitAccountID, @DebitOriginalAmount, @DebitConvertedAmount
		END
CLOSE @AT9000Cursor

If @InvoiceNoList<>'' 
	Set @InvoiceNoList =' Keøm theo: '+@InvoiceNoList+' laøm chöùng töø goác'

Set @sSQL ='
Select 	VoucherID, AT9000.DivisionID, DivisionName, TranMonth, TranYear, 
		VoucherTypeID, VoucherNo, VoucherDate,
		VDescription, 
		CreditBankAccountID,  
		AT1016.BankAccountNo AS CreditBankAccountNo, 
		AT1016.BankName AS CreditBankName,
		'''+isnull(@InvoiceNoList,'')+''' AS InvoiceNoList,
		'''+isnull(@DebitAccountList,'') +''' AS DebitAccountID,'
		+ ltrim(@DebitOriginalAmount1) + ' AS DebitOriginalAmount1, '
		+ ltrim(@DebitOriginalAmount2) + ' AS DebitOriginalAmount2, '
		+ ltrim(@DebitOriginalAmount3) + ' AS DebitOriginalAmount3, '
		+ ltrim(@DebitConvertedAmount1) + ' AS DebitConvertedAmount1, '
		+ ltrim(@DebitConvertedAmount2) + ' AS DebitConvertedAmount2, '
		+ ltrim(@DebitConvertedAmount3) + ' AS DebitConvertedAmount3, 
		CreditAccountID AS AccountID, 
		AT9000.CurrencyID, ExchangeRate,
		SenderReceiver, SRDivisionName, SRAddress,
		RefNo01, RefNo02,
		(	SELECT TOP 1 ObjectID 
			FROM	AT9000 
		 	WHERE 	TransactionTypeID = ''T22'' 
		 			AND	VoucherID = '''+@VoucherID+''' 
		 			AND	DivisionID ='''+@DivisionID+''' 
		) AS ObjectID,
		ObjectName, AT1202.Address AS ObjectAddress, AT1202.CityID, AT1002.CityName,
		AT1202.BankAccountNo AS DebitBankAccountNo, AT1202.BankName AS DebitBankName,
		Sum(ConvertedAmount) AS ConvertedAmount,
		Sum(OriginalAmount) AS OriginalAmount,
		AT1202.Note, AT1202.Note1,
		AT9000.Ana01ID, AT9000.Ana02ID, AT9000.Ana03ID, AT9000.Ana04ID, AT9000.Ana05ID, AT9000.Ana06ID, AT9000.Ana07ID, AT9000.Ana08ID, AT9000.Ana09ID, AT9000.Ana10ID,
		A01.AnaName Ana01Name, A02.AnaName Ana02Name, A03.AnaName Ana03Name, A04.AnaName Ana04Name, A05.AnaName Ana05Name,
		A06.AnaName Ana06Name, A07.AnaName Ana07Name, A08.AnaName Ana08Name, A09.AnaName Ana09Name, A10.AnaName Ana10Name
	
FROM AT9000 
LEFT JOIN AT1016 on AT1016.DivisionID = AT9000.DivisionID AND AT1016.BankAccountID = AT9000.CreditBankAccountID
LEFT JOIN AT1101 on AT1101.DivisionID = AT9000.DivisionID AND AT1101.DivisionID = AT9000.DivisionID
LEFT JOIN AT1202 on AT1202.DivisionID = AT9000.DivisionID AND AT1202.ObjectID = (SELECT TOP 1 ObjectID FROM	AT9000 WHERE TransactionTypeID = ''T22'' 
																						AND	VoucherID = '''+@VoucherID+''' 
																						AND	AT9000.DivisionID ='''+@DivisionID+''' )'
SET @sSQL1 = '																																							
LEFT JOIN AT1011 A01 ON A01.DivisionID = AT9000.DivisionID AND A01.AnaID = AT9000.Ana01ID
LEFT JOIN AT1011 A02 ON A02.DivisionID = AT9000.DivisionID AND A02.AnaID = AT9000.Ana02ID
LEFT JOIN AT1011 A03 ON A03.DivisionID = AT9000.DivisionID AND A03.AnaID = AT9000.Ana03ID
LEFT JOIN AT1011 A04 ON A04.DivisionID = AT9000.DivisionID AND A04.AnaID = AT9000.Ana04ID
LEFT JOIN AT1011 A05 ON A05.DivisionID = AT9000.DivisionID AND A05.AnaID = AT9000.Ana05ID
LEFT JOIN AT1011 A06 ON A06.DivisionID = AT9000.DivisionID AND A06.AnaID = AT9000.Ana06ID
LEFT JOIN AT1011 A07 ON A07.DivisionID = AT9000.DivisionID AND A07.AnaID = AT9000.Ana07ID
LEFT JOIN AT1011 A08 ON A08.DivisionID = AT9000.DivisionID AND A08.AnaID = AT9000.Ana08ID
LEFT JOIN AT1011 A09 ON A09.DivisionID = AT9000.DivisionID AND A09.AnaID = AT9000.Ana09ID
LEFT JOIN AT1011 A10 ON A10.DivisionID = AT9000.DivisionID AND A10.AnaID = AT9000.Ana10ID
LEFT JOIN AT1002 on AT1202.CityID = AT1002.CityID and AT1202.DivisionID = AT1002.DivisionID									
WHERE 	TransactionTypeID =''T22'' and
		VoucherID ='''+@VoucherID+''' and
		AT9000.DivisionID ='''+@DivisionID+''' 	
GROUP BY VoucherID, AT9000.DivisionID, DivisionName, TranMonth, TranYear, 
		VoucherTypeID, VoucherNo, VoucherDate,
		VDescription, CreditBankAccountID, AT1016.BankAccountNo, AT1016.BankName,
		AT1202.BankAccountNo, AT1202.BankName, AT1202.Address,
		CreditAccountID, AT9000.CurrencyID, ExchangeRate,
		SenderReceiver, SRDivisionName, SRAddress,RefNo01, RefNo02, ObjectName , AT1202.CityID, AT1002.CityName, At1202.Note, AT1202.Note1,
		AT9000.Ana01ID, AT9000.Ana02ID, AT9000.Ana03ID, AT9000.Ana04ID, AT9000.Ana05ID, AT9000.Ana06ID, AT9000.Ana07ID, AT9000.Ana08ID, AT9000.Ana09ID, AT9000.Ana10ID,
		A01.AnaName, A02.AnaName, A03.AnaName, A04.AnaName, A05.AnaName, A06.AnaName, A07.AnaName, A08.AnaName, A09.AnaName, A10.AnaName'
PRINT (@sSQL)
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV3045')
	EXEC ('CREATE VIEW AV3045 AS '+@sSQL + @sSQL1)
ELSE
	EXEC( 'ALTER VIEW AV3045 AS '+@sSQL + @sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
