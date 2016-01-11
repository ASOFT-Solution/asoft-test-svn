/****** Object:  StoredProcedure [dbo].[AP7609]    Script Date: 07/29/2010 11:32:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP7609]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP7609]
GO

/****** Object:  StoredProcedure [dbo].[AP7609]    Script Date: 07/29/2010 11:32:25 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


----- Created by Nguyen Van Nhan, Date 03/03/2006.
-----purpose: In So chung tu ghi so
----- Edit by Nguyen Quoc Huy , Date 06/06/2006
----- Edit by B.Anh, Date 20/02/2008, Purpose: Bo sung them truong OriginalAmount

/**********************************************
** Edited by: [GS] [Cẩm Loan] [30/07/2010]
***********************************************/

CREATE PROCEDURE  [dbo].[AP7609] @DivisionID nvarchar(50), 
								@FromDate Datetime, 
								@ToDate  Datetime, 
								@ReportCode nvarchar(50),
								@TDescription as nvarchar(250) = ''
AS
Declare @sSQL as nvarchar(4000),
	@BookNo as nvarchar(50),
	@AccountID as nvarchar(50),
	@ByAccountID as int,
	@Debit as int,
	@TranMonth as int,
	@TranYear as int--,
	--@TDescription as nvarchar(250)


Set @BookNo = (Select BookNo From AT7611 Where ReportCode = @ReportCode And DivisionID = @DivisionID)
Set @ByAccountID = (Select isnull(ByAccountID,0) From AT7611 Where ReportCode = @ReportCode And DivisionID = @DivisionID)
Set @Debit = (Select isnull(Debit,0) From AT7611 Where ReportCode = @ReportCode And DivisionID = @DivisionID)
Set @TranMonth = (Select TranMonth From AT7611 Where ReportCode = @ReportCode And DivisionID = @DivisionID)
Set @TranYear = (Select TranYear From AT7611 Where ReportCode = @ReportCode And DivisionID = @DivisionID)

--- Thêm @TDescription -- edit by Cẩm Loan 24/11/2010
--Set @TDescription = 'AFML000335'
if ISNULL(@TDescription,'') = ''
	Set @TDescription = 'Cộng theo phát sinh'

Delete AT7613 Where ReportCode = @ReportCode AND DivisionID = @DivisionID

if @Debit <> 0 
	set @AccountID = 'DebitAccountID'
else
	set @AccountID = 'CreditAccountID'

---Print 'TEST'
if @ByAccountID = 0   --- Theo Loai but toán
	Set @sSQL = '
	Select  '''+@ReportCode+''', 0, DivisionID,TranMonth,TranYear, VoucherDate, VoucherNo, VDescription as TDescription, DebitAccountID, CreditAccountID, Sum(OriginalAmount) as OriginalAmount, Sum(ConvertedAmount) as ConvertedAmount
	From AT9000
	Where 	(VoucherDate between '''+convert(nvarchar(10),@FromDate,101)+''' and '''+convert(nvarchar(10),@ToDate,101)+''') and
		DivisionID ='''+@DivisionID+''' and
		TransactionTypeID in (Select TransactionTypeID From AT7612 Where ReportCode ='''+@ReportCode+''')
	Group by DivisionID,TranMonth,TranYear, VoucherDate, VoucherNo,VDescription , DebitAccountID, CreditAccountID '
else
	
	Set @sSQL = '
	Select  '''+@ReportCode+''',  0, DivisionID,TranMonth,TranYear, VoucherDate, VoucherNo, VDescription as TDescription, DebitAccountID, CreditAccountID,  Sum(OriginalAmount) as OriginalAmount, Sum(ConvertedAmount) as ConvertedAmount
	From AT9000
	Where 	(VoucherDate between '''+convert(nvarchar(10),@FromDate,101)+''' and '''+convert(nvarchar(10),@ToDate,101)+''') and
			DivisionID ='''+@DivisionID+''' and ' +
			@AccountID + ' in (Select TransactionTypeID From AT7612 Where ReportCode ='''+@ReportCode+''')
	Group by DivisionID,TranMonth,TranYear, VoucherDate, VoucherNo, VDescription, DebitAccountID, CreditAccountID '

---print @sSQL
Exec ('  Insert AT7613 ( ReportCode, Orders, DivisionID,TranMonth,TranYear, VoucherDate, VoucherNo, VDescription , DebitAccountID, CreditAccountID, OriginalAmount, ConvertedAmount) ' + @sSQL)


Set @sSQL =  '  Insert AT7613 (ReportCode, Orders, DivisionID,TranMonth,TranYear, OriginalAmount, ConvertedAmount,  VDescription )
		Select '''+@ReportCode+''', 1, ''' +@DivisionID+''' ,  ' + STR(@TranMonth) + ', ' + STR(@TranYear) + ',
		Sum(OriginalAmount), Sum(ConvertedAmount) ,N'''+@TDescription+'''
		From AT7613
		Where ReportCode ='''+@ReportCode+''' AND DivisionID ='''+@DivisionID+''' '
--print @sSQL 
Exec (@sSQL) 

Set @sSQL = '  Insert AT7613 (ReportCode, Orders, DivisionID,TranMonth,TranYear, OriginalAmount, ConvertedAmount, DebitAccountID,CreditAccountID)
		Select '''+@ReportCode+''', 2, ''' +@DivisionID+''' , ' + STR(@TranMonth) + ', ' + STR(@TranYear) + ',
		Sum(OriginalAmount), Sum(ConvertedAmount) ,DebitAccountID,CreditAccountID
		From AT7613
		Where ReportCode ='''+@ReportCode+''' AND DivisionID ='''+@DivisionID+''' and Orders = 0 
		Group by DebitAccountID,CreditAccountID '

Exec (@sSQL) 


Set @sSQL ='  Select  ReportCode, Orders, DivisionID,TranMonth,TranYear, VoucherDate, VoucherNo, VDescription as TDescription , DebitAccountID, CreditAccountID, OriginalAmount, ConvertedAmount 
		From AT7613 Where ReportCode ='''+@ReportCode+''' AND DivisionID ='''+@DivisionID+''' '

If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV7610]') and OBJECTPROPERTY(id, N'IsView') = 1)
   Exec ('  Create View AV7610  -- tao boi AP7609
				as ' + @sSQL)
Else
 Exec ('  Alter View AV7610  -- tao boi AP7609
					As ' + @sSQL)
					
				
GO

