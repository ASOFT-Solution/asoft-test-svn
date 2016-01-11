IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3011]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3011]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



----- In phieu thu
----- Created by Nguyen Van Nhan, Date 08/09/2003
----- Edit by Nguyen Quoc Huy, Date 08/03/2006
----- Edit by B.Anh, Date 21/04/2008, Purpose: Lay them truong ObjectID
----- Edit by B.Quynh, Date 25/07/2008, Purpose: Bo truong ObjectID
---- Edit by B.Anh, date 27/01/2010	Sua loi thanh tien khong dung
---- Edit by Thien Huynh, date 24/10/2011 Khong Where theo @BatchID nua
---- Vi khong luu BatchID = VoucherID nua ma Sinh BatchID theo tung Hoa don tren luoi
---- Modified on 12/03/2012 by Lê Thị Thu Hiền : Chỉnh sửa SUM(OriginalAmount), SUM(ConvertedAmount)
---- Modified on 11/05/2012 by Lê Thị Thu Hiền : Bổ sung BDescription, TDescription
---- Modified on 19/12/2014 by Trần Quốc Tuấn : đổ chi tiết ra cho khách hàng Long Giang
/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/
----- Edit by B.Quynh, Date 05/10/2011, Purpose: Them 6 truong vao view
	--CreditOriginalAmount1,
	--CreditOriginalAmount2,
	--CreditOriginalAmount3,
	--CreditConvertedAmount1,
	--CreditConvertedAmount2,
	--CreditConvertedAmount3

CREATE PROCEDURE [dbo].[AP3011] 
				@DivisionID AS nvarchar(50),
				@TranMonth AS int,
				@TranYear AS int,
				@VoucherID AS nvarchar(50),
				@BatchID AS nvarchar(50) = ''
 AS
Declare @sSQL1 AS nvarchar(4000),
		@sSQL2 AS nvarchar(4000),
		@AT9000Cursor AS cursor,
		@InvoiceNo AS nvarchar(50),
		@Serial AS nvarchar(50),
		@InvoiceNoList AS nvarchar(500),
		@DebitAccountList AS nvarchar(500),
		@DebitAccountID  AS nvarchar(50),
		@CreditAccountList AS nvarchar(500),
		@CreditAccountID  AS nvarchar(50),
		@CreditOriginalAmount AS decimal(28,8),
		@CreditOriginalAmount1 AS decimal(28,8),
		@CreditOriginalAmount2 AS decimal(28,8),
		@CreditOriginalAmount3 AS decimal(28,8),
		@CreditConvertedAmount AS decimal(28,8),
		@CreditConvertedAmount1 AS decimal(28,8),
		@CreditConvertedAmount2 AS decimal(28,8),
		@CreditConvertedAmount3 AS decimal(28,8),	
		@InvoiceDate nvarchar(10),
		@i AS INT,
		@CustomerName AS INT 
		
Declare	@TempTable table(CustomerName  int,IsExcel  int)

INSERT @TempTable
EXEC	[dbo].[AP4444]
-- gán giá trị customer
SET @CustomerName = (SELECT TOP 1 CustomerName FROM @TempTable)

--print @InvoiceNoList
SET @AT9000Cursor = CURSOR SCROLL KEYSET FOR

SELECT	DISTINCT ISNULL(Serial,'') , isnull(InvoiceNo,''),  
		ISNULL(convert(nvarchar(10), InvoiceDate, 103),'') AS InvoiceDate
FROM	AT9000 
WHERE	VoucherID = @VoucherID
		-- and BatchID = @BatchID
		-- and TransactionTypeID = 'T01'
		AND TransactionTypeID in ('T01','T04','T14','T22')
		AND DivisionID = @DivisionID

SET @InvoiceNoList = ''

OPEN @AT9000Cursor
		FETCH NEXT FROM @AT9000Cursor INTO @Serial , @InvoiceNo,  @InvoiceDate			
		WHILE @@FETCH_STATUS = 0
		BEGIN
--			If @InvoiceNoList<>''
				--SET @InvoiceNoList = @InvoiceNoList+'; '+@Serial+'.'+@InvoiceNo
				SET @InvoiceNoList = @InvoiceNoList + @Serial + case when @Serial <> '' then ', ' else '' end + @InvoiceNo + 
					case when @invoiceNo <> '' then ', '  else '' end + @InvoiceDate + 
					case when @Serial +  @InvoiceNo +@InvoiceDate <> '' then    '; ' else '' end
	--		Else
				--SET @InvoiceNoList =@Serial+'.'+@InvoiceNo
		--		SET @InvoiceNoList = @Serial +  case when @Serial <> '' then ', ' end + @InvoiceNo + 
			--		case when @invoiceNo <> '' then ', ' end + @InvoiceDate + '; '
			
		FETCH NEXT FROM @AT9000Cursor INTO @Serial , @InvoiceNo,  @InvoiceDate	
		END

CLOSE @AT9000Cursor

SET @CreditAccountList = ''
SET @i = 1
SET @CreditOriginalAmount = 0
SET @CreditOriginalAmount1 = 0
SET @CreditOriginalAmount2 = 0
SET @CreditOriginalAmount3 = 0
SET @CreditConvertedAmount = 0
SET @CreditConvertedAmount1 = 0
SET @CreditConvertedAmount2 = 0
SET @CreditConvertedAmount3 = 0
	
SET @AT9000Cursor = CURSOR SCROLL KEYSET FOR

SELECT	DISTINCT CreditAccountID, 
		SUM(OriginalAmount) AS OriginalAmount, 
		SUM(ConvertedAmount) AS ConvertedAmount 
FROM	AT9000 
WHERE	VoucherID =@VoucherID 
		--and BatchID = @BatchID 
		AND TransactionTypeID in ('T01','T04','T14', 'T22')
		AND DivisionID = @DivisionID
GROUP BY	CreditAccountID
		
OPEN @AT9000Cursor
		FETCH NEXT FROM @AT9000Cursor INTO @CreditAccountID, @CreditOriginalAmount, @CreditConvertedAmount  
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @CreditAccountList <>''
				SET @CreditAccountList = @CreditAccountList+'; '+@CreditAccountID
			Else
				SET @CreditAccountList  = @CreditAccountID
			If @i = 1
				Begin
					SET @CreditOriginalAmount1 = @CreditOriginalAmount 
					SET @CreditConvertedAmount1 = @CreditConvertedAmount 
				End	
			Else
				If @i = 2
					Begin
						SET @CreditOriginalAmount2 = @CreditOriginalAmount 
						SET @CreditConvertedAmount2 = @CreditConvertedAmount 
					End	
				Else
					If @i =3
						Begin
							SET @CreditOriginalAmount3 = @CreditOriginalAmount 
							SET @CreditConvertedAmount3 = @CreditConvertedAmount 
						End
						
			SET @i = @i + 1
			FETCH NEXT FROM @AT9000Cursor INTO @CreditAccountID, @CreditOriginalAmount, @CreditConvertedAmount
		END

CLOSE @AT9000Cursor

--print @InvoiceNoList

If @InvoiceNoList<>'' 
	SET @InvoiceNoList =replace(@InvoiceNoList,'''','''''')
	
IF @CustomerName=40
BEGIN
SET @sSQL1 =N'
SELECT 	VoucherID, AT9000.DivisionID, TranMonth, TranYear, 
		VoucherTypeID, VoucherNo, VoucherDate,
		VDescription,
		CreditAccountID,
		AT9000.InvoiceNo,'
		+ ltrim(@CreditOriginalAmount1) + ' AS CreditOriginalAmount1, '
		+ ltrim(@CreditOriginalAmount2) + ' AS CreditOriginalAmount2, '
		+ ltrim(@CreditOriginalAmount3) + ' AS CreditOriginalAmount3, '
		+ ltrim(@CreditConvertedAmount1) + ' AS CreditConvertedAmount1, '
		+ ltrim(@CreditConvertedAmount2) + ' AS CreditConvertedAmount2, '
		+ ltrim(@CreditConvertedAmount3) + ' AS CreditConvertedAmount3, 
		DebitAccountID AS AccountID,  
		--ObjectID,
		AT9000.CurrencyID, ExchangeRate,
		SenderReceiver, SRDivisionName, SRAddress,
		RefNo01, RefNo02, 
		FullName,
		ChiefAccountant,
		ConvertedAmount,
		OriginalAmount,
		ISNULL(AT9000.BDescription,'''') AS BDescription,
		ISNULL(AT9000.TDescription,'''') AS TDescription,
		AT9000.Ana01ID, A01.AnaName AS Ana01Name, AT9000.Ana02ID, A02.AnaName AS Ana02Name,
		AT9000.Ana03ID, A03.AnaName AS Ana03Name, AT9000.Ana04ID, A04.AnaName AS Ana04Name,
		AT9000.Ana05ID, A05.AnaName AS Ana05Name, AT9000.Ana06ID, A06.AnaName AS Ana06Name,
		AT9000.Ana07ID, A07.AnaName AS Ana07Name, AT9000.Ana08ID, A08.AnaName AS Ana08Name,
		AT9000.Ana09ID, A09.AnaName AS Ana09Name, AT9000.Ana10ID, A10.AnaName AS Ana10Name,
		AT9000.Parameter01,AT9000.Parameter02, AT9000.Parameter03, AT9000.Parameter04, AT9000.Parameter05,
		AT9000.Parameter06, AT9000.Parameter07, AT9000.Parameter08, AT9000.Parameter09, AT9000.Parameter10,
		AT9000.DParameter01, AT9000.DParameter02, AT9000.DParameter03, AT9000.DParameter04, AT9000.DParameter05,
		AT9000.DParameter06, AT9000.DParameter07, AT9000.DParameter08, AT9000.DParameter09, AT9000.DParameter10'
	
SET @sSQL2 =N'
FROM	AT9000 
LEFT JOIN AT1103 On AT1103.EmployeeID = AT9000.EmployeeID and AT1103.DivisionID =AT9000.DivisionID
LEFT JOIN AT0001 on AT9000.DivisionID = AT0001.DivisionID
LEFT JOIN AT1011 A01 ON A01.DivisionID = AT9000.DivisionID AND A01.AnaID = AT9000.Ana01ID AND A01.AnaTypeID =''A01''
LEFT JOIN AT1011 A02 ON A02.DivisionID = AT9000.DivisionID AND A02.AnaID = AT9000.Ana02ID AND A02.AnaTypeID =''A02''
LEFT JOIN AT1011 A03 ON A03.DivisionID = AT9000.DivisionID AND A03.AnaID = AT9000.Ana03ID AND A03.AnaTypeID =''A03''
LEFT JOIN AT1011 A04 ON A04.DivisionID = AT9000.DivisionID AND A04.AnaID = AT9000.Ana04ID AND A04.AnaTypeID =''A04''
LEFT JOIN AT1011 A05 ON A05.DivisionID = AT9000.DivisionID AND A05.AnaID = AT9000.Ana05ID AND A05.AnaTypeID =''A05''
LEFT JOIN AT1011 A06 ON A06.DivisionID = AT9000.DivisionID AND A06.AnaID = AT9000.Ana06ID AND A06.AnaTypeID =''A06''
LEFT JOIN AT1011 A07 ON A07.DivisionID = AT9000.DivisionID AND A07.AnaID = AT9000.Ana07ID AND A07.AnaTypeID =''A07''
LEFT JOIN AT1011 A08 ON A08.DivisionID = AT9000.DivisionID AND A08.AnaID = AT9000.Ana08ID AND A08.AnaTypeID =''A08''
LEFT JOIN AT1011 A09 ON A09.DivisionID = AT9000.DivisionID AND A09.AnaID = AT9000.Ana09ID AND A09.AnaTypeID =''A09''
LEFT JOIN AT1011 A10 ON A10.DivisionID = AT9000.DivisionID AND A10.AnaID = AT9000.Ana10ID AND A10.AnaTypeID =''A10''
WHERE --TransactionTypeID =''T01'' and
		TransactionTypeID in (''T01'',''T04'',''T14'',''T22'') and
		AT9000.DivisionID = '''+@DivisionID+''' and
		VoucherID ='''+@VoucherID+''' ---and BatchID = ''' + @BatchID + ''''	
END
ELSE
BEGIN	
SET @sSQL1 =N'
SELECT 	VoucherID, AT9000.DivisionID, TranMonth, TranYear, 
		VoucherTypeID, VoucherNo, VoucherDate,
		VDescription,
		N'''+isnull(@InvoiceNoList,'')+''' AS InvoiceNoList,
		N'''+isnull(@CreditAccountList,'') +''' AS CreditAccountID, '
		+ ltrim(@CreditOriginalAmount1) + ' AS CreditOriginalAmount1, '
		+ ltrim(@CreditOriginalAmount2) + ' AS CreditOriginalAmount2, '
		+ ltrim(@CreditOriginalAmount3) + ' AS CreditOriginalAmount3, '
		+ ltrim(@CreditConvertedAmount1) + ' AS CreditConvertedAmount1, '
		+ ltrim(@CreditConvertedAmount2) + ' AS CreditConvertedAmount2, '
		+ ltrim(@CreditConvertedAmount3) + ' AS CreditConvertedAmount3, 
		DebitAccountID AS AccountID,  
		--ObjectID,
		AT9000.CurrencyID, ExchangeRate,
		SenderReceiver, SRDivisionName, SRAddress,
		RefNo01, RefNo02, 
		FullName,
		ChiefAccountant,
		Sum(ConvertedAmount) AS ConvertedAmount,
		Sum(OriginalAmount) AS OriginalAmount,
		Max(ISNULL(AT9000.BDescription,'''')) AS BDescription,
		Max(ISNULL(AT9000.TDescription,'''')) AS TDescription'
	
SET @sSQL2 =N'
FROM	AT9000 
LEFT JOIN AT1103 On AT1103.EmployeeID = AT9000.EmployeeID and AT1103.DivisionID =AT9000.DivisionID
LEFT JOIN AT0001 on AT9000.DivisionID = AT0001.DivisionID

WHERE --TransactionTypeID =''T01'' and
		TransactionTypeID in (''T01'',''T04'',''T14'',''T22'') and
		AT9000.DivisionID = '''+@DivisionID+''' and
		VoucherID ='''+@VoucherID+''' ---and BatchID = ''' + @BatchID + '''
GROUP BY VoucherID, AT9000.DivisionID, TranMonth, TranYear, 
		VoucherTypeID, VoucherNo, VoucherDate,
		VDescription, DebitAccountID, 
		--ObjectID,
		AT9000.CurrencyID, ExchangeRate,
		SenderReceiver, SRDivisionName, SRAddress, RefNo01, RefNo02,FullName,ChiefAccountant'

END
--print @sSQL1+@sSQL2

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='AV3011')
	EXEC ('CREATE VIEW AV3011 -- CREATED BY AP3011
	as '+@sSQL1+@sSQL2)
ELSE
	EXEC( 'ALTER VIEW AV3011 -- CREATED BY AP3011
	AS '+@sSQL1+@sSQL2)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

