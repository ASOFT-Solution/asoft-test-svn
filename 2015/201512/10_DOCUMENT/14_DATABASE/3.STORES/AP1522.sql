/****** Object:  StoredProcedure [dbo].[AP1522]    Script Date: 07/29/2010 11:33:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Creater :Nguyen Thi Thuy Tuyen.
---Creadate:21/07/2006
-- Puppose :Lay du lieu in bao cao but toan ket chuyen   !
----- Edit by B.Anh, Date 21/04/2008, Purpose: Lay them truong ObjectID

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1522]  
				@DivisionID nvarchar(50),
				@TranMonth int,
				@TranYear int
				
				
AS
Declare @sSQL nvarchar(4000)
Set @sSQL = ' 
SELECT  VoucherTypeID,
	VoucherNo,
	VoucherDate,
	DebitAccountID,
	T01.AccountName as DebitAccountName,
	CreditAccountID,
	T02.AccountName as CreditAccountName,
	ObjectID,
	CurrencyID,
	ExchangeRate,
	OriginalAmount,
	ConvertedAmount,
	VDescription,
	AT9000.DivisionID
From AT9000 
	Inner Join AT1005 T01 on T01.AccountID = AT9000.DebitAccountID and T01.DivisionID = AT9000.DivisionID
	Inner Join AT1005 T02 on T02.AccountID = AT9000.CreditAccountID and T02.DivisionID = AT9000.DivisionID
Where   TransactionTypeID =''T98'' 
	and AT9000.DivisionID = ''' + @DivisionID + ''' 
	and TranMonth = '+str(@TranMonth)+' 
	and	TranYear = '+str(@TranYear)+' 
'
--Print @sSQL
If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='AV1522')
	Exec(' Create view AV1522 as '+ @sSQL )
Else
	Exec(' Alter view AV1522 as '+@sSQL)