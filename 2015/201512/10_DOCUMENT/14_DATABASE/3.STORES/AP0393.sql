
/****** Object:  StoredProcedure [dbo].[AP0393]    Script Date: 07/29/2010 10:06:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---- Created by Van Nhan, Date 19/06/2009
----- purpose: In bao cao pharn tich cong no, qua khu va tuong lai
----Last edit: Thuy Tuyen, date 03/09/2008
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[AP0393] 	@DivisionID as nvarchar(50),
					@ReportDate as Datetime,
					@FromAccountID as nvarchar(50),
					@ToAccountID as nvarchar(50),
					@FromObjectID as nvarchar(50),
					@ToObjectID as nvarchar(50),
					@CurrencyID as nvarchar(50),
					@IsGroup as tinyint,
					@GroupID as nvarchar(50)
					
 AS
Declare @sSQL as nvarchar(4000),
	@Month as int,
	@Year as int,
	@Period01 as int

/*
update AT0303 set 	---DebitAna01ID =Ana01ID,
			----DebitAna02ID= Ana02ID,
			DebitVoucherDate=VoucherDate
From AT0303 inner join AV0311 on 	AV0311.ObjectID = AT0303.ObjectID and
					AV0311.VoucherID = AT0303.DebitVoucherID and
					AV0311.BatchID = AT0303.DebitBatchID and
					AV0311.TableID = AT0303.DebitTableID
Where DebitVoucherDate is null

update AT0303 set 	CreditVoucherDate=VoucherDate
From AT0303 inner join AV0312 on 	AV0312.ObjectID = AT0303.ObjectID and
					AV0312.VoucherID = AT0303.CreditVoucherID and
					AV0312.BatchID = AT0303.CreditBatchID and
					AV0312.TableID = AT0303.CreditTableID
	
Where CreditVoucherDate is null
*/
Set nocount off
Delete AT0393
set @Month = month(@ReportDate)
set @Year = year(@ReportDate)
--------------------------------------- So du No dau ky-----------------------------------------------------------------
Exec AP0391 	@DivisionID, @ReportDate, @FromAccountID, @ToAccountID,@FromObjectID, @ToObjectID, @CurrencyID,@IsGroup,@GroupID 
------------------------------- Phat sinh -------------------------------------------------------------------------------------
Exec AP0392 	@DivisionID, @ReportDate, @FromAccountID, @ToAccountID,@FromObjectID, @ToObjectID, @CurrencyID,@IsGroup,  @GroupID 				
----------------- No qua han  ---------------------------------------
Exec AP0394 	@DivisionID, @ReportDate, @FromAccountID, @ToAccountID,@FromObjectID, @ToObjectID, @CurrencyID,@IsGroup, @GroupID 				
----------------- Du thu trong tuong lai ---------------------------------------
Exec AP0395 	@DivisionID, @ReportDate, @FromAccountID, @ToAccountID,@FromObjectID, @ToObjectID, @CurrencyID, @IsGroup, @GroupID 						
----- update so du cuoi
Update AT0393 set 	EndDebitAmount =Case when isnull(BeginDebitAmount,0)-isnull(BeginCreditAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0)>0 then  isnull(BeginDebitAmount,0)-isnull(BeginCreditAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) else 0 End,
			EndDebitConAmount =Case when isnull(BeginDebitConAmount,0)-isnull(BeginCreditConAmount,0) + isnull(DebitConAmount,0) - isnull(CreditConAmount,0)>0 then  isnull(BeginDebitConAmount,0)-isnull(BeginCreditConAmount,0) + isnull(DebitConAmount,0) - isnull(CreditConAmount,0) else 0 End,
			EndCreditAmount =- Case when isnull(BeginDebitAmount,0)-isnull(BeginCreditAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0)<0  then isnull(BeginDebitAmount,0)-isnull(BeginCreditAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) else  0 end,
			EndCreditConAmount =- Case when isnull(BeginDebitConAmount,0)-isnull(BeginCreditConAmount,0) + isnull(DebitConAmount,0) - isnull(CreditConAmount,0)<0  then isnull(BeginDebitConAmount,0)-isnull(BeginCreditConAmount,0) + isnull(DebitConAmount,0) - isnull(CreditConAmount,0) else  0 end
where AT0393.DivisionID = @DivisionID

Set nocount on