IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0348]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0348]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Created by Nguyen Thi Ngoc Minh.
--- Date 15/09/2004
---- purpose: In bao cao chi tiet doi chieu cong no phai thu va phai tra cho cung 1 doi tuong
--- Edit by Nguyen Quoc Huy, Data 27.04/2007
---Last Edt : Thuy Tuyen 25/01/2007 Lay ten Ma phan tich 
---Edit by: Dang Le Bao Quynh; Date 08/11/2008
---Purpose: Bo sung truong TDescription cho view AV0348
---- Modified on 28/09/2011 by Le Thi Thu Hien : Chinh sua Division
---- Modify on 20/06/2012 by Bao Anh : Cai thien toc do
---- Modify on 18/03/2013 by bao Anh: Bo sung truong
---- Modified on 14/06/2013 by Thiên Huỳnh: Bổ sung Mã phân tích
---- Modified on 07/07/2014 by Thanh Sơn: Chuyển create view thành exec store
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
					[Hoang Phuoc] [16/11/2010] 
'**************************************************************/

CREATE PROCEDURE [dbo].[AP0348] 
				@DivisionID as nvarchar(50), 
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
				@IsPayable TINYINT
				--@Orderby NVARCHAR(4000)

AS

Declare @sSQL as nvarchar(4000)
Declare @AccountName as nvarchar(250),
		@CurrencyName as nvarchar(250)


Set @CurrencyName = (Case When  Isnull(@CurrencyID,'') ='%' then 'Tất cả' else Isnull(@CurrencyID,'') End) 

	EXEC AP0368 @DivisionID, @FromObjectID, @ToObjectID, @FromRecAccountID, @ToRecAccountID,
				@FromPayAccountID, @ToPayAccountID, @CurrencyID, @FromInventoryID, 
				@ToInventoryID, @IsDate, @FromMonth, @FromYear, @FromDate, @IsPayable



	EXEC AP0358 @DivisionID, @FromObjectID, @ToObjectID, @FromRecAccountID, @ToRecAccountID,
				@FromPayAccountID, @ToPayAccountID, @CurrencyID,  @FromInventoryID, 
				@ToInventoryID, @IsDate, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate, @IsPayable


Set @sSQL='
SELECT 	Isnull(AV0358.ObjectID, AT0368.ObjectID) as GroupID,
		Isnull(AV0358.ObjectName, AT0368.ObjectName) as GroupName, 
		---AT0368.InvoiceList, 
		---AT0368.InvoiceDateList, 

		case when isnull(AT0368.ObjectAddress,'''')='''' then AV0358.Address else AT0368.ObjectAddress end as ObjectAddress,
		
		isnull(AT0368.Tel, AV0358.Tel) as TEL,
		isnull(AT0368.Fax, AV0358.Fax) as FAX,
		isnull(AT0368.Email, AV0358.Email) as  EMAIL,
		isnull(AT0368.VATNo, AV0358.VATNo) as VATNo,

		isnull(At0368.S1,AV0358.S1) as  S1,
		isnull(At0368.S2, AV0358.S2) as  S2,
		isnull( At0368.S3, AV0358.S3) as  S3,
		isnull( At0368.O01ID,AV0358.O01ID) as  O01ID,
		isnull(At0368.O02ID, AV0358.O02ID) as  O02ID,
		isnull(At0368.O03ID, AV0358.O03ID) as  O03ID,
		isnull( At0368.O04ID, AV0358.O04ID) as  O04ID,
		isnull( At0368.O05ID,AV0358.O05ID) as  O05ID,

		
		isnull(AV0358.R_P, Case when isnull(ReBeConvertedAmount,0)=0 then ''P'' else ''R'' end) as R_P,
		'''+@CurrencyName+''' as CurrencyID, TransactionTypeID,
		VoucherDate,
		VoucherNo,
		VoucherTypeID,
		InvoiceDate,
		InvoiceNo,
		Serial,
		DebitAccountID, CreditAccountID,
		Ana01ID, AnaName01, Ana02ID, AnaName02, Ana03ID, AnaName03, Ana04ID, AnaName04, Ana05ID, AnaName05,
		Ana06ID, AnaName06, Ana07ID, AnaName07, Ana08ID, AnaName08, Ana09ID, AnaName09, Ana10ID, AnaName10,
		AV0358.InventoryID,
		AV0358.InventoryName,
		AV0358.TDescription,
		AV0358.VDescription,
		AV0358.BDescription,
		isnull(DebitOriginalAmount,0) as DebitOriginalAmount, 
		isnull(DebitConvertedAmount,0) as DebitConvertedAmount, 
		isnull(DebitQuantity,0) as DebitQuantity, 
		isnull(DebitUnitPrice,0) as DebitUnitPrice,
		isnull(DebitDiscountRate,0) as DebitDiscountRate,
		isnull(CreditOriginalAmount,0) as CreditOriginalAmount,
		isnull(CreditConvertedAmount,0) as CreditConvertedAmount,
		isnull(CreditQuantity,0) as CreditQuantity,
		isnull(ReBeConvertedAmount,0) as OpeningRecConvertedAmount,
		isnull(ReBeOriginalAmount,0) as OpeningRecOriginalAmount,
		isnull(PaBeConvertedAmount,0) as OpeningPayConvertedAmount,
		isnull(PaBeOriginalAmount,0) as OpeningPayOriginalAmount,
		(Select Sum(ConvertedAmount) From AV4202  Where ObjectID = AT0368.ObjectID And Ana03ID = AV0358.Ana03ID) as OpeningAna03ID,
		ISNULL(AV0358.DivisionID, AT0368.DivisionID) AS DivisionID,
		AV0358.Parameter01, AV0358.Parameter02, AV0358.Parameter03, AV0358.Parameter04, AV0358.Parameter05,
		AV0358.ConvertedUnitID, AV0358.ConvertedUnitName, AV0358.DebitConvertedQuantity, AV0358.CreditConvertedQuantity,
		isnull(MarkQuantity,0) as MarkQuantity
		
FROM		AV0358
FULL JOIN	(Select DivisionID, ObjectID, ObjectName, ObjectAddress, Tel, Fax, Email, VATNo, S1, S2, S3, O01ID, O02ID, O03ID, O04ID, O05ID,
		Sum(ReBeConvertedAmount) as ReBeConvertedAmount, Sum(ReBeOriginalAmount) as ReBeOriginalAmount, Sum(PaBeConvertedAmount) as PaBeConvertedAmount, 
		Sum(PaBeOriginalAmount) as PaBeOriginalAmount FROM AT0368 
         	GROUP BY DivisionID, ObjectID, ObjectName, ObjectAddress, Tel, Fax, Email, VATNo, S1, S2, S3, O01ID, O02ID, O03ID, O04ID, O05ID) AT0368  
	ON 		AT0368.ObjectID = AV0358.ObjectID 
			AND AT0368.DivisionID = AV0358.DivisionID'

--print @sSQL
EXEC (@sSQL)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

