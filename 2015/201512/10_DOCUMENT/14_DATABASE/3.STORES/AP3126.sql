/****** Object:  StoredProcedure [dbo].[AP3126]    Script Date: 07/29/2010 13:56:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-----  In Chung Tu (nhieu phieu mot luc)
----- Created by Nguyen Quoc Huy, Date 07.11.2005
----- Edit by B.Anh date 05/08/2009, bo sung cho in xuat kho ban' hang
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3126]  @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50)

	
 AS
Declare @sSQL as nvarchar(4000),
	@Count as int,
	@i as int,
	@ObjectID as nvarchar(50),  
	@InvoiceDate as datetime,
	@ObjectIDCursor as Cursor,
	@OrdersCursor as Cursor,
	@ConvertedAmount as decimal (28,8),
	@VoucherDate as Datetime

Select top 1 @ObjectID = ObjectID, @VoucherDate = VoucherDate  From AT9000 Where VoucherID = @VoucherID and TransactionTypeID ='T04' AND AT9000.DivisionID = @DivisionID
set @ConvertedAmount = (Select Sum (SignAmount) From AV4301 Where ObjectID = @ObjectID and AccountID ='131' and VoucherDate <= @VoucherDate AND AV4301.DivisionID = @DivisionID )

set @sSql ='
Insert AT3014 ( Orders, VoucherID, VoucherTypeID, VoucherNo, TaxOrders, Ana01ID,Ana02ID,Ana03ID,AnaName1,	Ana01RefDate,
	InventoryID, UnitID,UnitName, UnitPrice, Quantity, OriginalAmount,  DiscountRate,ConvertedAmount,Serial,InvoiceNo,
	EndAmount,
	InventoryName,	ObjectID,	ObAddress,	PaymentID,	InvoiceDate,	DivisionID,	DivisionName,	Address,Tel,Fax, 
	 DivisionVATNO,	CurrencyID,		VATRate, 	OriginalAmountTax,
	ConvertedAmountTax, ObjectName, VATNO )

Select  AT9000.Orders, VoucherID, VoucherTypeID, VoucherNo,
	0 as TaxOrders,
	Ana01ID,Ana02ID,Ana03ID,
	AT1011.AnaName as AnaName1,
	AT1011.RefDate as Ana01RefDate,
	 AT9000.InventoryID, 
	AT9000.UnitID,
	AT1304.UnitName,
	UnitPrice, Quantity, OriginalAmount, 
	Cast(isnull(DiscountRate,0) as Decimal(28,8)) as DiscountRate,
	ConvertedAmount,Serial,InvoiceNo,
	'+str(@ConvertedAmount)+' as EndAmount, 
	AT1302.InventoryName,
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
	(Case when IsUpdateName =1 then AT9000.VATNo else AT1202.VATNo end) as 
VATNo
From AT9000 	left join AT1302 on At1302.InventoryID = AT9000.InventoryID and At1302.DivisionID = AT9000.DivisionID
		Left join AT1304 on AT1304.UnitID = AT9000.UnitID and AT1304.DivisionID = AT9000.DivisionID
		left join AT1202 on At1202.ObjectID = AT9000.ObjectID and At1202.DivisionID = AT9000.DivisionID
	                left join AT1101 on 
AT1101.DivisionID=AT9000.DivisionID
		left join AT1010 on AT1010.VATGroupID = AT9000.VATGroupID and AT1010.DivisionID = AT9000.DivisionID
 		Left join AT1011 on	 AT1011.AnaID = AT9000.Ana01ID and AT1011.DivisionID = AT9000.DivisionID and
					 AT1011.AnaTypeID = ''A01''
Where 	VoucherID ='''+@VoucherID+''' and 
             TransactionTypeID in (''T04'',''T40'') and
             AT9000.DivisionID = '''+@DivisionID+''''

--PRINT @sSQL

Exec (@sSQL)

/*
SET @ObjectIDCursor = CURSOR SCROLL KEYSET FOR
Select Distinct ObjectID,InvoiceDate From AT3014 

OPEN @ObjectIDCursor
		FETCH NEXT FROM @ObjectIDCursor INTO @ObjectID , @InvoiceDate
		WHILE @@FETCH_STATUS = 0
		BEGIN
				Set @i =0
				SET @OrdersCursor = CURSOR SCROLL KEYSET FOR
				Select Distinct ObjectID,InvoiceDate From AT3014 

			--Update AT3014 Set Orders = @i +1 Where 			

			FETCH NEXT FROM  @ObjectIDCursor INTO @ObjectID , @InvoiceDate
		END

CLOSE @ObjectIDCursor
*/