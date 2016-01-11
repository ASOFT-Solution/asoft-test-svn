/****** Object:  StoredProcedure [dbo].[AP4721]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------- 	Created by Nguyen Van Nhan
-------- 	Created date 09/06/2004
-------- 	Purpose: Truy van chi tiet but toan quan tri
--------     Edit by: Nguyen Quoc Huy

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [29/07/2010]
'********************************************/
 
ALTER PROCEDURE 	[dbo].[AP4721]
			@DivisionID nvarchar(50), 
			@FromMonth int, 
			@FromYear as int, 
			@ToMonth as int, 
			@ToYear as int,
			@FromAccountID nvarchar(50), 
			@ToAccountID as nvarchar(50),
			@FromCorAccountID nvarchar(50), 
			@ToCorAccountID nvarchar(50),
			@D_C as tinyint, ---0 Phat sinh No, 1 Phat sinh Co, 2 So du
			@ColumnTypeID as nvarchar(50), ---- Loai tieu thuc du lieu lay o cot
			@Col1ID nvarchar(50),
			@RowTypeID as nvarchar(50),
			@RowID  as nvarchar(50)
 AS



Declare 	@sSQL as nvarchar(4000),
			@ListOfColumn as nvarchar(2000),   --- Max = 30 Column
			@RowField as nvarchar(30),
			@ColField as nvarchar(20),
			@AmountField as nvarchar(30)

EXEC AP4700 @RowTypeID,  @RowField  OUTPUT
EXEC AP4700 @ColumnTypeID,  @ColField  OUTPUT

If @D_C =0
	Set @AmountField ='ConvertedAmount'
Else
	If @D_C =1  
		Set  @AmountField ='(-1)*ConvertedAmount'
		Else
			If @D_C =2
				Set   @AmountField ='SignAmount'



Set @sSQL ='
Select 	VoucherDate,VoucherTypeID,VoucherNo,InvoiceDate, InvoiceNo,
	SignAmount,
	ConvertedAmount,
	(Case when V43.D_C  = ''D''  then AccountID else CorAccountID end) as DebitAccountID,
	(Case when V43.D_C  = ''C''  then AccountID else CorAccountID end) as CreditAccountID,
	Description, V43.DivisionID
 From AV4301 V43 

Where 		V43.DivisionID ='''+@DivisionID+''' and
		(V43.TranMonth + 100*V43.TranYear between '+str(@FromMonth)+' + 100*'+str(@FromYear)+' and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+' ) And
		V43.'+@ColField+'  = '''+@Col1ID+'''  and
		V43.'+@RowField+'  = '''+@RowID+'''  and
		( (V43.D_C  = ''D'' and '+str(@D_C)+' =0 ) or 
		(V43.D_C  = ''C'' and '+str(@D_C)+' =1 ) or 
		( '+str(@D_C)+' =2 ) ) and
		(V43.AccountID Between '''+@FromAccountID+''' and '''+@ToAccountID+''')  '


If isnull(@FromCorAccountID,'') <>'' and @FromCorAccountID <>'%'
	Set @sSQL =@sSQL + ' and (V43.CorAccountID Between '''+@FromCorAccountID+''' and '''+@ToCorAccountID+''') '

If @D_C <> 2 ---- Chi lay so phat sinh
	Set @sSQL = @sSQL + ' and ( V43.TransactionTypeID <>''T00'' ) '


	





--Print @sSQL

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV4721' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV4721 AS ' + @sSQL)
ELSE
	EXEC ('ALTER VIEW AV4721 AS ' + @sSQL)
GO
