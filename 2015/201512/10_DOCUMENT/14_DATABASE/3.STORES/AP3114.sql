/****** Object:  StoredProcedure [dbo].[AP3114]    Script Date: 07/29/2010 11:47:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-----  In hoa don  (nhieu phieu mot luc)
----- Created by Nguyen Van Nhan, Date 04.10.2004
----- Edit by B.Anh, date 05/08/2009, bo sung cho xuat kho ban' hang
----- Edit by B.Anh, date 03/12/2009	Lay them truong
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3114] @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50)

	
 AS
Declare @sSQL as nvarchar(4000),
	@Count as int,
	@i as int,
	@Serial as nvarchar(50), 
	@InvoiceNo as nvarchar(50),   
	@ObjectID as nvarchar(50),  
	@PaymentID as nvarchar(50),  
	@InvoiceDate as Datetime, 	
	@Address as nvarchar(250),  
	@Tel as nvarchar(100),  
	@CurrencyID as nvarchar(50),  
	@ObjectName as nvarchar(250),  
	@VATNo as nvarchar(50),  
	@Fax as nvarchar(100),  
	@DivisionVATNO as nvarchar(50),  
	@OriginalAmountTax as decimal (28,8) , 
	@ConvertedAmountTax  decimal (28,8), 
	@Ana01ID  as nvarchar(50),   
	@Ana02ID as nvarchar(50),   
	@Ana03ID  as nvarchar(50),   
	@AnaName1  as nvarchar(250),  
	@Ana01RefDate Datetime, 
	@Quantity  decimal(28,8), 
	@DiscountRate decimal (28,8), 
	@ObAddress  as nvarchar(250),   
	@DivisionName  as nvarchar(250),   
	@VATRate  as decimal (28,8)  
	

set @sSql ='
Insert AT3014 ( Orders, VoucherID,TaxOrders, Ana01ID,Ana02ID,Ana03ID,AnaName1,	Ana01RefDate,
	InventoryID, UnitID,UnitName, UnitPrice, Quantity, OriginalAmount,  DiscountRate, ConvertedAmount, Serial, InvoiceNo,
	InventoryName,	ObjectID,	ObAddress,	PaymentID,	InvoiceDate,	DivisionID,	DivisionName,	Address, Tel, Fax, 
	 DivisionVATNO,	CurrencyID,		VATRate, 	OriginalAmountTax,
	ConvertedAmountTax, ObjectName, VATNO, ObjectTel, ObjectFax, OrderID, VoucherNo, VDescription, BDescription, TDescription)

Select  AT9000.Orders, VoucherID, 0 as TaxOrders,
	Ana01ID,Ana02ID,Ana03ID,
	AT1011.AnaName as AnaName1,
	AT1011.RefDate as Ana01RefDate,
	 AT9000.InventoryID, 
	AT9000.UnitID,
	AT1304.UnitName,
	UnitPrice, Quantity, OriginalAmount, 
	Cast(isnull(DiscountRate,0) as Decimal(28,8)) as DiscountRate,
	ConvertedAmount,Serial,InvoiceNo,
	Case when isnull(AT9000.InventoryName1,'''') ='''' then AT1302.InventoryName else AT9000.InventoryName1 end as InventoryName,
	AT9000.ObjectID,
	AT1202.Address as ObAddress,
	AT1202.PaymentID,
	AT9000.InvoiceDate,
	AT9000.DivisionID,
	AT1101.DivisionName,	AT1101.Address,	AT1101.Tel, AT1101.Fax, 
	AT1101.VATNO as DivisionVATNO,
	AT9000.CurrencyID,	
	AT1010.VATRate, 
	OriginalAmountTax = (Case when (Select Sum(isnull(OriginalAmount,0)) 
			From AT9000 T9  
			Where TransactiontypeID in (''T14'',''T40'')  and VoucherID = AT9000.VoucherID ) is null
			then 0 else (Select Sum(isnull(OriginalAmount,0)) 
			From AT9000 T9  
			Where TransactiontypeID in (''T14'',''T40'')  and VoucherID = AT9000.VoucherID ) end),
	ConvertedAmountTax = (Case when (Select Sum(isnull(ConvertedAmount,0)) 
			From AT9000 T9  
			Where TransactiontypeID in (''T14'',''T40'')  and VoucherID = AT9000.VoucherID ) is null
			then 0 else (Select Sum(isnull(ConvertedAmount,0)) 
			From AT9000 T9  
			Where TransactiontypeID in (''T14'',''T40'')  and VoucherID = AT9000.VoucherID ) end),
	(Case when IsUpdateName =1 then AT9000.VATObjectName else 
	AT1202.ObjectName end) as ObjectName,
	(Case when IsUpdateName =1 then AT9000.VATNo else AT1202.VATNo end) as VATNo, 
	AT1202.Tel, AT1202.Fax,
	OrderID, VoucherNo,
	VDescription, BDescription, TDescription
	
From AT9000 	left join AT1302 on At1302.InventoryID = AT9000.InventoryID and At1302.DivisionID = AT9000.DivisionID
		Left join AT1304 on AT1304.UnitID = AT9000.UnitID and AT1304.DivisionID = AT9000.DivisionID
		left join AT1202 on At1202.ObjectID = AT9000.ObjectID and At1202.DivisionID = AT9000.DivisionID
	             left join AT1101 on AT1101.DivisionID=AT9000.DivisionID
		left join AT1010 on AT1010.VATGroupID = AT9000.VATGroupID and AT1010.DivisionID = AT9000.DivisionID
 		Left join AT1011 on	 AT1011.AnaID = AT9000.Ana01ID and AT1011.DivisionID = AT9000.DivisionID and
					 AT1011.AnaTypeID = ''A01''
Where 	AT9000.VoucherID ='''+@VoucherID+''' and AT9000.DivisionID = '''+@DivisionID+''' and
             AT9000.TransactionTypeID in (''T04'',''T40'') '

--PRINT @sSQL

Exec (@sSQL)

Select  @Count = Count(*) ,  @InvoiceNo = InvoiceNo, @ObjectID = ObjectID, @PaymentID = PaymentID, @InvoiceDate = InvoiceDate, 
	@Address =Address  , @Tel = Tel, @CurrencyID = CurrencyID, @ObjectName = ObjectName, 
	@VATNo = VATNo, @Fax = Fax, @DivisionVATNO = DivisionVATNO, @OriginalAmountTax = OriginalAmountTax, 
	@ConvertedAmountTax = ConvertedAmountTax, 
	 @Ana01ID = Ana01ID, @Ana02ID = Ana02ID,@Ana03ID = Ana03ID, @AnaName1 = AnaName1,
	@Ana01RefDate = Ana01RefDate, @Quantity = Quantity,
	@DiscountRate = DiscountRate, 
	@ObAddress = ObAddress, 
	@DivisionName = DivisionName,
	@VATRate  = VATRate

From AT3014
Where VoucherID = @VoucherID AND DivisionID = @DivisionID
Group by VoucherID, Serial, InvoiceNo,  ObjectID, PaymentID, InvoiceDate, DivisionID, 
					Address, Tel, CurrencyID, ObjectName, VATNo, Fax, DivisionVATNO, OriginalAmountTax, 
					ConvertedAmountTax, SayVN, Ana01ID, Ana02ID, Ana03ID, AnaName1 ,Ana01RefDate, Quantity, 
					DiscountRate, ObAddress, DivisionName, VATRate 

if @Count<10
  Begin	
	Set @i =@Count
	While @i < 10
  		Begin
			Insert AT3014 ( Orders, VoucherID, Serial, InvoiceNo,  ObjectID, PaymentID, InvoiceDate, DivisionID, 
					Address, Tel, CurrencyID, ObjectName, VATNo, Fax, DivisionVATNO, OriginalAmountTax, 
					ConvertedAmountTax,  Ana01ID, Ana02ID, Ana03ID, AnaName1 ,Ana01RefDate, Quantity, 
					DiscountRate, ObAddress, DivisionName, VATRate )
			Values ( 11,  @VoucherID, @Serial, @InvoiceNo,  @ObjectID, @PaymentID, @InvoiceDate, @DivisionID, 
					@Address, @Tel, @CurrencyID, @ObjectName, @VATNo, @Fax, @DivisionVATNO, @OriginalAmountTax, 
					@ConvertedAmountTax,  @Ana01ID, @Ana02ID, @Ana03ID, @AnaName1 ,@Ana01RefDate, @Quantity, 
					@DiscountRate, @ObAddress, @DivisionName, @VATRate )
			Set @i = @i+1
		End


  End