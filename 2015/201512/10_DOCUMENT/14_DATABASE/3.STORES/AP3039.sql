/****** Object:  StoredProcedure [dbo].[AP3039]    Script Date: 07/29/2010 10:13:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


--Created by Nguyen Quoc Huy
--Date 01/12/2005
--Purpose:Dung cho Report hang ban tra lai
-- LAst Edit, Thuy Tuyen.. date: 28/03/2009 --PP: Them truong so lo, han dung,...
--- Edit by B.Anh, date 15/10/2009	Bo sung cho truong hop thuong doanh so (TransactionTypeID = T74)
--- Edit by: Dang Le Bao Quynh; Date 26/11/2009
--- Purpose: Them truong VoucherDate

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[AP3039] 
          @VoucherID as nvarchar(50)
as
Declare @sSql as nvarchar(4000),
	@sSqlUnion as nvarchar(4000),
	@Count as int,
	@i as int

	Set @Count = ( Select Count(*) From AT9000
	Where VoucherID= @VoucherID  and TransactionTypeID in ('T24','T74') )

Set @Count = 10 - @Count
Set @I =1 
Set @sSqlUnion =''
set @sSql ='
Select  	AT9000.VoucherNo,
	AT9000.VoucherDate,
	 0 as TaxOrders,
	AT9000.Orders,
	AT9000.Ana01ID,AT9000.Ana02ID,AT9000.Ana03ID,AT9000.Ana04ID,AT9000.Ana05ID,
	AT1011.AnaName as AnaName1,
	T02.AnaName as AnaName2,
	T03.AnaName as AnaName3,
	T04.AnaName as AnaName4,
	T05.AnaName as AnaName5,
	AT1011.RefDate as Ana01RefDate,
	 AT9000.InventoryID, 
	AT9000.UnitID,
	AT1304.UnitName,
	(AT9000.OriginalAmount/AT9000.Quantity) as UnitPrice, AT9000.Quantity, AT9000.OriginalAmount, 
	Cast(isnull(DiscountRate,0) as Decimal(28,8)) as DiscountRate,
	AT9000.ConvertedAmount,Serial,InvoiceNo,
	Case when isnull(AT9000.InventoryName1,'''') ='''' then AT1302.InventoryName else AT9000.InventoryName1 end as InventoryName ,
	AT9000.ObjectID,
	(Case when isnull(AT9000.VATObjectID,'''') ='''' then  A.Address else B.Address end ) as ObAddress,
	A.PaymentID,
	AT9000.InvoiceDate,
	AT9000.DivisionID,
	AT1101.DivisionName,	AT1101.Address,	AT1101.Tel, AT1101.Fax, 
	AT1101.VATNO as DivisionVATNO,
	AT9000.CurrencyID,	
	AT1010.VATRate, 
	AT1302.Varchar01,AT1302.Varchar02,AT1302.Varchar03,AT1302.Varchar04,AT1302.Varchar05,
	OriginalAmountTax = (Case when (Select Sum(isnull(OriginalAmount,0)) 
			From AT9000 T9  
			Where TransactiontypeID =''T34''  and VoucherID = AT9000.VoucherID and DivisionID = AT9000.DivisionID ) is null
			then 0 else (Select Sum(isnull(OriginalAmount,0)) 
			From AT9000 T9  
			Where TransactiontypeID =''T34''  and VoucherID = AT9000.VoucherID and DivisionID = AT9000.DivisionID ) end),'
Set @sSqlUnion = ' 			
	ConvertedAmountTax = (Case when (Select Sum(isnull(ConvertedAmount,0)) 
			From AT9000 T9  
			Where TransactiontypeID =''T34''  and VoucherID = AT9000.VoucherID and DivisionID = AT9000.DivisionID ) is null
			then 0 else (Select Sum(isnull(ConvertedAmount,0)) 
			From AT9000 T9  
			Where TransactiontypeID =''T34''  and VoucherID = AT9000.VoucherID and DivisionID = AT9000.DivisionID ) end),
	
	(Case when isnull(AT9000.VATObjectID,'''') ='''' then  A.ObjectName 
	  else 
	     Case When B.IsUpdateName = 1 then AT9000.VATObjectName 
		Else
			B.ObjectName End End) as ObjectName,
	(Case when isnull(AT9000.VATObjectID,'''') ='''' then  A.VATNo
	  else 
	     Case When B.IsUpdateName = 1 then AT9000.VATNo
		Else
			B.VATNo  End End) as VATNo,
	AT2007.SourceNo, AT2007.LimitDate, AT9000.DebitAccountID, AT9000.CreditAccountID,
	AT9000.DiscountAmount,
	AT9000.VDescription,
	AT9000.TDescription,
	AT9000.BDescription,
	AT1302.IsDiscount

From AT9000 	left join AT1302 on AT1302.InventoryID = AT9000.InventoryID And AT1302.DivisionID = AT9000.DivisionID
		Left join AT1304 on AT1304.UnitID = AT9000.UnitID And AT1304.DivisionID = AT9000.DivisionID
		left join AT1202 A on A.ObjectID = AT9000.ObjectID And A.DivisionID = AT9000.DivisionID
		left join AT1202 B on B.ObjectID = AT9000.VATObjectID And B.DivisionID = AT9000.DivisionID

	            left join AT1101 on AT1101.DivisionID=AT9000.DivisionID
		left join AT1010 on AT1010.VATGroupID = AT9000.VATGroupID And AT1010.DivisionID = AT9000.DivisionID
 		Left join AT1011 on AT1011.AnaID = AT9000.Ana01ID and  AT1011.AnaTypeID = ''A01'' And AT1011.DivisionID = AT9000.DivisionID
		Left join AT1011  T02 on T02.AnaID = AT9000.Ana02ID and  T02.AnaTypeID = ''A02'' and  T02.DivisionID = AT9000.DivisionID
		Left join AT1011  T03 on T03.AnaID = AT9000.Ana03ID and  T03.AnaTypeID = ''A03'' and  T03.DivisionID = AT9000.DivisionID
		Left join AT1011  T04 on T04.AnaID = AT9000.Ana04ID and  T04.AnaTypeID = ''A04'' and  T04.DivisionID = AT9000.DivisionID
		Left join AT1011  T05 on T05.AnaID = AT9000.Ana05ID and  T05.AnaTypeID = ''A05'' and  T05.DivisionID = AT9000.DivisionID
Left Join AT2007 on AT2007.VoucherID =  AT9000.VoucherID And AT2007.DivisionID =  AT9000.DivisionID
		and AT2007.TransactionID =AT9000.TransactionID
Where 	AT9000.VoucherID ='''+@VoucherID+''' and 
             TransactionTypeID in (''T24'',''T74'') '

--Set @sSql = @sSql + @sSqlUnion

--Print @sSql
If not exists (Select top 1 1 From SysObjects Where name = 'AV3039' and Xtype ='V')
	Exec ('Create view AV3039 as '+@sSQL + @sSqlUnion)
Else
	Exec ('Alter view AV3039 as '+@sSQL + @sSqlUnion)