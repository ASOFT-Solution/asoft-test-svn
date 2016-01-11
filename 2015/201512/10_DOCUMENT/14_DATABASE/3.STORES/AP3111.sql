IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3111]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3111]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- In phieu thu, chi dong loat (nhieu phieu mot luc)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on Nguyen Van Nhan, Date 20.08.2004
---- 
---- Edit by B.Anh, date 03/06/2010	Bo sung truong hop thu - chi qua ngan hang
---- Modified on 24/05/2012 by Lê Thị Thu Hiền : Bổ sung số tiền vào tài khoản
---- Modified on 17/07/2012 by Lê Thị Thu Hiền : Bổ sung 1 cột chỉ show tài khoản không show số tiền
---- Modified on 17/07/2012 by 
-- <Example>
---- EXEC AP3111 'AS', 1, 2012, '09080j', 'T23'
----- 


CREATE PROCEDURE [dbo].[AP3111] 
				@DivisionID AS nvarchar(50),
				@TranMonth AS int,
				@TranYear AS int,
				@VoucherID AS nvarchar(50),
				@TransactionTypeID AS nvarchar(50)
	
 AS
Declare @sSQL AS nvarchar(4000),
		@AT9000Cursor AS cursor,
		@InvoiceNo AS varchar(50),
		@Serial AS varchar(50),
		@InvoiceNoList AS varchar(8000),
		@DebitAccountList AS varchar(8000),
		@DebitAccountID  AS nvarchar(50),
		@DebitAmountList AS DECIMAL(28,8),
		@DebitAmount  AS DECIMAL(28,8),
		@CreditAccountList AS varchar(8000),
		@CreditAccountID  AS nvarchar(50),
		@CreditAmountList  AS varchar(8000),
		@CreditAmount  AS DECIMAL(28,8),
 		@InvoiceDate AS varchar(20),
		@IsType AS int
		
Declare	@TempTable table(CustomerName  int,IsExcel  int)

INSERT @TempTable
EXEC	[dbo].[AP4444]
-- CustomerName == 2; Customize khách hàng ngọc Tề
select @IsType= case when CustomerName<>2 then 0 else 1 end  from @TempTable


SET @InvoiceNoList =''
SET @AT9000Cursor = CURSOR SCROLL KEYSET FOR
Select Distinct isnull(Serial,'') , isnull(InvoiceNo,''), isnull(convert(varchar(10), InvoiceDate, 103),'') AS InvoiceDate
		 From AT9000 Where VoucherID =@VoucherID and TransactionTypeID in ('T01','T04','T14', 'T02','T03','T13') AND DivisionID =@DivisionID 
OPEN @AT9000Cursor
		FETCH NEXT FROM @AT9000Cursor INTO @Serial , @InvoiceNo, @InvoiceDate
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
				if(@IsType = 0)
				begin
				SET @InvoiceNoList = @InvoiceNoList + @Serial + case when @Serial <> '' then ', ' else '' end + @InvoiceNo + 
					case when @invoiceNo <> '' then ', '  else '' end + @InvoiceDate + 
					case when @Serial +  @InvoiceNo +@InvoiceDate <> '' then    '; ' else '' end
				end
			else
				begin
					SET @InvoiceNoList = @InvoiceNoList + @InvoiceNo + 
					case when @InvoiceNo <> '' then    '; ' else '' end
				end

			FETCH NEXT FROM @AT9000Cursor INTO @Serial, @InvoiceNo, @InvoiceDate
		END

CLOSE @AT9000Cursor



SET @CreditAccountList =''
SET @CreditAmountList = ''

SET @AT9000Cursor = CURSOR SCROLL KEYSET FOR
SELECT	DISTINCT  (CASE WHEN 	@TransactionTypeID in ('T01','T04','T14','T22') THEN  CreditAccountID 
		ELSE CASE WHEN @TransactionTypeID in ( 'T02','T03','T13','T21') THEN DebitAccountID END END ) AS CreditAccountID,
		SUM(OriginalAmount) AS CreditAmount
From	AT9000 
Where	VoucherID = @VoucherID 
		AND TableID = 'AT9000' 
		AND DivisionID =@DivisionID 
GROUP BY (CASE WHEN 	@TransactionTypeID in ('T01','T04','T14','T22') THEN  CreditAccountID 
		ELSE CASE WHEN @TransactionTypeID in ( 'T02','T03','T13','T21') THEN DebitAccountID END END )

OPEN @AT9000Cursor
		FETCH NEXT FROM @AT9000Cursor INTO @CreditAccountID, @CreditAmount
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			If @CreditAccountList <>''
				BEGIN
					SET @CreditAccountList = @CreditAccountList+'; '+@CreditAccountID 
					SET @CreditAmountList = @CreditAccountList+'; '+@CreditAccountID +': '+ STR(@CreditAmount)
				END
				
			ELSE
				BEGIN
					SET @CreditAccountList  = @CreditAccountID 
					SET @CreditAmountList  = @CreditAccountID +': '+  STR(@CreditAmount)
				END
				

			FETCH NEXT FROM @AT9000Cursor INTO @CreditAccountID, @CreditAmount
		END

CLOSE @AT9000Cursor

--print @InvoiceNoList
--PRINT(@CreditAmountList)
If @InvoiceNoList<>'' 
	SET @InvoiceNoList = replace(@InvoiceNoList,'''','''''')

If @CreditAccountList<>'' 
	SET @CreditAccountList = replace(@CreditAccountList,'''','''''')
	
SET @sSQL ='
INSERT AT3011 ( VoucherID, DivisionID, TranMonth, TranYear, 
		VoucherTypeID, VoucherNo, VoucherDate,
		VDescription,InvoiceNoList,'
if @TransactionTypeID in ('T01','T04','T14','T22','T02','T03','T13','T21')

SET @sSQL = @sSQL +'		
		CreditAccountID,
		CreditAmountListID,
		DebitAccountID,
		DebitAmountListID,
		AccountID, '
SET @sSQL = @sSQL +'
		CurrencyID, ExchangeRate,
		SenderReceiver, SRDivisionName, SRAddress,
		FullName,ChiefAccountant,
		ConvertedAmount,  OriginalAmount, TransactionTypeID)

SELECT 	VoucherID, AT9000.DivisionID, TranMonth, TranYear, 
		VoucherTypeID, VoucherNo, VoucherDate,
		VDescription,
		'''+isnull(@InvoiceNoList,'')+''' AS InvoiceNoList, '

--If @TransactionTypeID ='T01' 
if @TransactionTypeID in ('T01','T04','T14','T22')
  SET @sSQL =@sSQL  +'	'''+ isnull(@CreditAccountList,'') +''' AS CreditAccountID,
						'''+ isnull(@CreditAmountList,'') +''' AS CreditAmountListID,
						DebitAccountID AS DebitAccountID,
						DebitAccountID AS DebitAmountListID,
						DebitAccountID  AS AccountID, 	'
Else if @TransactionTypeID in ('T02','T03','T13','T21')
  SET @sSQL =@sSQL  +'	CreditAccountID AS CreditAccountID,	
						CreditAccountID AS CreditAmountListID,					
						'''+ isnull(@CreditAccountList,'') +''' AS  DebitAccountID, 
						'''+ isnull(@CreditAmountList,'') +''' AS  DebitAmountListID, 
						CreditAccountID  AS AccountID, 	'

SET @sSQL = @sSQL +'	
		AT9000.CurrencyID, ExchangeRate,
		SenderReceiver, SRDivisionName, SRAddress,
		FullName,ChiefAccountant,
		Sum(ConvertedAmount) AS ConvertedAmount,
		Sum(OriginalAmount) AS OriginalAmount,
		'''+@TransactionTypeID+''' 
	
FROM	AT9000 
LEFT JOIN AT1103 On AT1103.EmployeeID = AT9000.EmployeeID and AT1103.DivisionID =AT9000.DivisionID,
			AT0001

WHERE  --TransactionTypeID ='''+@TransactionTypeID+''' and
		TransactionTypeID in (''T02'',''T03'',''T13'',''T01'',''T04'',''T14'',''T21'',''T22'')  and
		AT9000.DivisionID = '''+@DivisionID+''' and
		VoucherID ='''+@VoucherID+''' 
GROUP BY VoucherID, AT9000.DivisionID, TranMonth, TranYear, 
		VoucherTypeID, VoucherNo, VoucherDate,
		VDescription,  
		AT9000.CurrencyID, ExchangeRate, 
		SenderReceiver, SRDivisionName, SRAddress, FullName,ChiefAccountant'

--IF @TransactionTypeID ='T01' 
if @TransactionTypeID in ('T01','T04','T14','T22')
SET @sSQL = @sSQL + ' , AT9000.DebitAccountID '
Else if @TransactionTypeID in ('T02','T03','T13','T21')
SET @sSQL = @sSQL + ' ,  AT9000.CreditAccountID '

PRINT @sSQL

EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

