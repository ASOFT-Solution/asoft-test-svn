
/****** Object:  StoredProcedure [dbo].[OP1320]    Script Date: 08/03/2010 15:19:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Vo Thanh Huong  , Date 	25/4/2006      
--Purpose: Lay so du cong no len bao man hinh don hang ban.
----Last Edit  Thuy Tuyen  5/03/2007 Lay them no phai thu  qua han

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP1320] 	@DivisionID nvarchar(50), 
					@ObjectID as nvarchar(50),	
					@VoucherDate as Datetime,
					@CurrencyID as  nvarchar(50),
					@Type  nvarchar(50) ---- S0:  don hang ban, PO: Don hang mua


AS
Set NoCount on
Declare 	
		@ReAccountID as nvarchar(50),
		@PaAccountID as  nvarchar(50),
		@ReceivedAmount as Money,
		@PaymentAmount as Money,
		@OverDueAmount as money


Select @ReAccountID = ReAccountID, @PaAccountID = PaAccountID
From AT1202 Where ObjectID = @ObjectID

SET @VoucherDate = DATEADD(d, DATEDIFF(d, 0, @VoucherDate) + 1, 0)

--Step1: Lay no phai thu
Select @ReceivedAmount = sum(OriginalAmount) 
From AV4202
Where 	AccountID like @ReAccountID and ObjectID = @ObjectID and DivisionID =@DivisionID and 
	VoucherDate <= @VoucherDate and CurrencyIDCN =@CurrencyID


---Step2: Lay no phai tra
Select @PaymentAmount = - sum(OriginalAmount) 
From AV4202
Where 	AccountID like @PaAccountID and ObjectID = @ObjectID and DivisionID =@DivisionID and 
	VoucherDate <= @VoucherDate and CurrencyIDCN =@CurrencyID

---Step3:Lay no  phai thu qua han
Select  @OverDueAmount  =   sum(isnull( OriginalAmount,0)- isnull (GivedOriginalAmount,0))  
From AV0301
Where 	DebitAccountID like @ReAccountID and ObjectID = @ObjectID and DivisionID =@DivisionID and 
(DueDate < = case when DueDate <> '01/01/1900' then @VoucherDate end ) 
	 and CurrencyIDCN =@CurrencyID
				
				
Set NoCount Off

IF  @Type = 'SO'--- Phai thu
Select 	ReCreditLimit,RePaymentTermID,PaymentTermName, ReDueDays,
	isnull(@ReceivedAmount,0)  as ReceivedAmount, 
	isnull(@PaymentAmount,0)  as PaymentAmount,
	isnull(@OverDueAmount,0) as  OverDueAmount,
	AT1202.ReDays
From AT1202 left join AT1208 on AT1208.PaymentTermID = AT1202.RePaymentTermID 
Where ObjectID = @ObjectID

ELSE   ---'PO' Phai tra
Select 	PaCreditLimit as ReCreditLimit, RePaymentTermID, PaymentTermName, PaDueDays as ReDueDays,
	isnull(@ReceivedAmount,0)  as ReceivedAmount, 
	isnull(@PaymentAmount,0)  as PaymentAmount,
	AT1202.ReDays
From AT1202 left join AT1208 on AT1208.PaymentTermID = AT1202.PaPaymentTermID 
Where ObjectID = @ObjectID
----Print str(@OverDueAmount)