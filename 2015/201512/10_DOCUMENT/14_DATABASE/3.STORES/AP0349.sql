/****** Object:  StoredProcedure [dbo].[AP0349]    Script Date: 07/29/2010 08:34:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



---- Created by Nguyen Thi Ngoc Minh
--- Date 15/09/2004.
---- purpose: In bao cao tong hop  doi chieu cong no phai thu va phai tra cho cung mot doi tuong
---Last Edit 27/03/2007 :ThuyTuyen Lay them truong MPT
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/

---- Modify on 20/06/2012 by Bao Anh : Cai thien toc do
---- Modified on 14/06/2013 by Thiên Huỳnh: Bổ sung Mã phân tích
---- Modified on 15/09/2014 by Thanh Sơn: Bỏ biến 

ALTER PROCEDURE [dbo].[AP0349] @DivisionID as nvarchar(50), 
				@FromObjectID  as nvarchar(50),  
				@ToObjectID  as nvarchar(50),  
				@FromRecAccountID  as nvarchar(50),  
				@ToRecAccountID  as nvarchar(50), 
				@FromPayAccountID  as nvarchar(50),  
				@ToPayAccountID  as nvarchar(50), 
				@CurrencyID  as nvarchar(50),  
				@FromInventoryID as nvarchar(50),
				@ToInventoryID as nvarchar(50),
				@IsDate as tinyint, 
				@FromMonth as int, 
				@FromYear  as int,  
				@ToMonth as int,
				@ToYear as int,
				@FromDate as Datetime, 
				@ToDate as Datetime,
				@IsPayable as TINYINT
				--@Orderby NVARCHAR(4000)

AS

Declare 	@sSQL as nvarchar(4000),
		@CurrencyName as nvarchar(250)


Set @CurrencyName = (Case When  Isnull(@CurrencyID,'') ='%' then 'Taát caû' else Isnull(@CurrencyID,'') End) 

----- Xac dinh so du

	Exec AP0368 @DivisionID, @FromObjectID, @ToObjectID, @FromRecAccountID, @ToRecAccountID,
			@FromPayAccountID, @ToPayAccountID, @CurrencyID, @FromInventoryID, 
			@ToInventoryID, @IsDate, @FromMonth, @FromYear, @FromDate, @IsPayable
-- print 'vao' 
----- Xac dinh so phat sinh 
	Exec AP0359 @DivisionID, @FromObjectID, @ToObjectID, @FromRecAccountID, @ToRecAccountID, 
			@FromPayAccountID, @ToPayAccountID, @CurrencyID, @FromInventoryID,
			@ToInventoryID, @IsDate, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate, @IsPayable


Set @sSQL='
Select 	Isnull(AV0359.TransactionTypeID, '''') as TransactionTypeID,
	Isnull(AV0359.ObjectID,AT0368.ObjectID) as GroupID, 
	isnull(AV0359.R_P, Case when isnull(ReBeConvertedAmount,0)=0 then ''P'' else ''R'' end) as R_P,
	Isnull(AV0359.ObjectName, AT0368.ObjectName) as GroupName,
	AT0368.ObjectAddress,
	AT0368.Tel,
	AT0368.Fax,
	AT0368.Email, 
	AT0368.VATNo,
	AT0368.S1, 
	AT0368.S2, 
	AT0368.S3, 
	AT0368.O01ID, 
	AT0368.O02ID, 
	AT0368.O03ID, 
	AT0368.O04ID, 
	AT0368.O05ID, 

	'''+@CurrencyName+''' as CurrencyID,
	VoucherDate,VoucherNo,
	AV0359.InventoryID, AV0359.InventoryName, UnitID,
	isnull(DebitOriginalAmount,0) as DebitOriginalAmount,
	isnull(DebitConvertedAmount,0) as DebitConvertedAmount,
	isnull(DebitQuantity,0) as DebitQuantity,
	isnull(DebitDiscountRate,0) as DebitDiscountRate,
	isnull(CreditOriginalAmount,0) as CreditOriginalAmount,
	isnull(CreditConvertedAmount,0) as CreditConvertedAmount,
	isnull(CreditQuantity,0) as CreditQuantity,
	isnull(ReBeConvertedAmount,0) as OpeningRecConvertedAmount,
	isnull(ReBeOriginalAmount,0) as OpeningRecOriginalAmount,
	isnull(PaBeConvertedAmount,0) as OpeningPayConvertedAmount,
	isnull(PaBeOriginalAmount,0) as OpeningPayOriginalAmount,
	Ana01ID, AnaName01, Ana02ID, AnaName02, Ana03ID, AnaName03, Ana04ID, AnaName04, Ana05ID, AnaName05,
	Ana06ID, AnaName06, Ana07ID, AnaName07, Ana08ID, AnaName08, Ana09ID, AnaName09, Ana10ID, AnaName10,
	InvoiceNo,
	AV0359.DivisionID
From AV0359 Full join (Select DivisionID, ObjectID, ObjectName, ObjectAddress, Tel, Fax, Email, VATNo, S1, S2, S3, O01ID, O02ID, O03ID, O04ID, O05ID,
		Sum(ReBeConvertedAmount) as ReBeConvertedAmount, Sum(ReBeOriginalAmount) as ReBeOriginalAmount, Sum(PaBeConvertedAmount) as PaBeConvertedAmount, 
		Sum(PaBeOriginalAmount) as PaBeOriginalAmount FROM AT0368 
         	GROUP BY DivisionID, ObjectID, ObjectName, ObjectAddress, Tel, Fax, Email, VATNo, S1, S2, S3, O01ID, O02ID, O03ID, O04ID, O05ID) AT0368 
on 	AT0368.ObjectID = AV0359.ObjectID and AT0368.DivisionID = AV0359.DivisionID
'
--print @sSQL
EXEC (@sSQL)