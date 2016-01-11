/****** Object:  StoredProcedure [dbo].[AP3042]    Script Date: 07/29/2010 10:19:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----- In phieu chi: Mau so 3
----- Date 09/11/2007
----- Edit by B.Anh, Date 21/04/2008, Purpose: Lay them truong ObjectID
----- Edit by B.Anh, date 18/08/2009, Purpose: Bo sung cho truong hop thu qua ngan hang
----- Edit by B.Anh, date 26/08/2009, Porpose: Lay cac truong ma phan tich va phan kem theo
---- Edit by B.Anh, date 27/01/2010	Sua loi thanh tien khong dung
---- Edit by Thien Huynh, date 29/11/2011 Khong Where theo @BatchID nua
--- Vi khong luu BatchID = VoucherID nua ma Sinh BatchID theo tung Hoa don tren luoi

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3042] @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50),
				@BatchID as nvarchar(50)
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
	@InvoiceDate nvarchar(10),
	@IsType as int
		
Declare	@TempTable table(CustomerName  int,IsExcel  int)

INSERT @TempTable
EXEC	[dbo].[AP4444]
-- CustomerName == 2; Customize khách hàng ngọc Tề
select @IsType= case when CustomerName<>2 then 0 else 1 end  from @TempTable


SET @InvoiceNoList =''
SET @AT9000Cursor = CURSOR SCROLL KEYSET FOR
Select Distinct isnull(Serial,'') , isnull(InvoiceNo,''), isnull(convert(nvarchar(10), InvoiceDate, 103), '')  as InvoiceDate
		 From AT9000 Where VoucherID =@VoucherID and BatchID = @BatchID --and TransactionTypeID ='T02'
						and DivisionID =@DivisionID and TransactionTypeID in ('T02','T03','T13','T21','T23')
OPEN @AT9000Cursor
		FETCH NEXT FROM @AT9000Cursor INTO @Serial , @InvoiceNo, @InvoiceDate
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			if(@IsType = 0)
				begin
				Set @InvoiceNoList = @InvoiceNoList + @Serial + case when @Serial <> '' then ', ' else '' end + @InvoiceNo + 
					case when @invoiceNo <> '' then ', '  else '' end + @InvoiceDate + 
					case when @Serial +  @InvoiceNo +@InvoiceDate <> '' then    '; ' else '' end
				end
			else
				begin
					Set @InvoiceNoList = @InvoiceNoList + @InvoiceNo + 
					case when @InvoiceNo <> '' then    '; ' else '' end
				end
			FETCH NEXT FROM @AT9000Cursor INTO @Serial, @InvoiceNo, @InvoiceDate
		END
CLOSE @AT9000Cursor

If @InvoiceNoList<>'' 
	Set @InvoiceNoList =replace(@InvoiceNoList,'''','''''')

Set @sSQL ='
Select 	VoucherID, AT9000.DivisionID, TranMonth, TranYear, 
	Orders, VoucherTypeID, VoucherNo, VoucherDate,
	VDescription,
	TDescription,
	BDescription,
	N'''+isnull(@InvoiceNoList,'')+''' as InvoiceNoList,
	CreditAccountID,
	DebitAccountID, 
	ObjectID,
	AT9000.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress,
	RefNo01, RefNo02, 
	--FullName,
	---ChiefAccountant,
	ConvertedAmount,
	 OriginalAmount,
	Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID
	
From AT9000 
Where TransactionTypeID in (''T02'',''T03'',''T13'',''T21'',''T23'') and
	AT9000.DivisionID = '''+@DivisionID+''' and
	VoucherID ='''+@VoucherID+''' ---and BatchID = ''' + @BatchID + '''
'


--print @sSQL

If Not Exists (Select 1 From sysObjects Where Name ='AV3042')
	Exec ('Create view AV3042 as '+@sSQL)
Else
	Exec( 'Alter view AV3042 as '+@sSQL)