
/****** Object:  StoredProcedure [dbo].[AP7611]    Script Date: 07/29/2010 11:36:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP7611]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP7611]
GO

/****** Object:  StoredProcedure [dbo].[AP7611]    Script Date: 07/29/2010 11:36:23 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO




----- Created Date 03/03/2006
---- Nguyen Van Nhan, 
---- Purpose: In so cai tai khoan theo chung tu ghi so:

/**********************************************
** Edited by: [GS] [Cẩm Loan] [30/07/2010]
***********************************************/

CREATE PROCEDURE 	[dbo].[AP7611] @DivisionID as nvarchar(50), 
				@FromMonth as int, 
				@FromYear as int, 
				@ToMonth as int,
				@ToYear as int, 
				@FromDate as datetime, 		
				@ToDate as datetime, 
				@IsDate as tinyint 



 AS

Declare @sSQL as nvarchar(max)


 Set @sSQL ='
SELECT DISTINCT AV4301.DivisionID, AccountID,sum(SignAmount) as BeginAmount
From AV4301
Where 	BudgetID =''AA'' and DivisionID ='''+@DivisionID+'''  and
	(TranMonth + TranYear*100 < '+str(@FromMonth)+'+100*'+str(@FromYear)+' or TransactionTypeID =''T00'')
Group by AV4301.DivisionID,AccountID '

If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV7601]') and OBJECTPROPERTY(id, N'IsView') = 1)
     Exec ('  Create View AV7601 -- tao boi AP7611
					as ' + @sSQL)
Else
     Exec ('  Alter View AV7601  -- tao boi AP7611
					As ' + @sSQL)

---- Lay so du theo tai khoan
Set @sSQL ='
Select 	AT7611.DivisionID, 
		isnull(BeginAmount,0) as BeginAmount, 
		AT7611.BookNo, BookDate, AT7611.Description, DebitAccountID as AccountID , CreditAccountID as CorAccountID,
		Sum(AT7613.ConvertedAmount)  as DebitAmount, 0 as CreditAmount
From AT7613 	left join AT7611 on AT7611.ReportCode = AT7613.ReportCode and AT7611.DivisionID = AT7613.DivisionID
		Left join AV7601 on AV7601.AccountID = AT7613.DebitAccountID and AV7601.DivisionID = AT7613.DivisionID
Where Orders =2  AND ISNULL(AT7611.BookNo,'''')<>'''' AND ISNULL(BookDate,'''')<>'''' 
	and AT7613.DivisionID ='''+@DivisionID+'''  and
	(AT7613.TranMonth + AT7613.TranYear*100 Between ('+str(@FromMonth)+' + '+str(@FromYear)+'*100) and ('+str(@ToMonth)+' + '+str(@ToYear)+'*100)) 
Group by  AT7611.DivisionID,BeginAmount, AT7611.BookNo, BookDate, AT7611.Description, DebitAccountID, CreditAccountID
Union all
Select 	AT7611.DivisionID,isnull(BeginAmount,0) as BeginAmount, 
	 AT7611.BookNo, BookDate, AT7611.Description, CreditAccountID as AccountID , DebitAccountID as CorAccountID,
	0 as DebitAmount, Sum(AT7613.ConvertedAmount) as CreditAmount
From AT7613 	left join AT7611 on AT7611.ReportCode = AT7613.ReportCode and AT7611.DivisionID = AT7613.DivisionID
		Left join AV7601 on AV7601.AccountID = AT7613.CreditAccountID and AV7601.DivisionID = AT7613.DivisionID
Where Orders =2  AND ISNULL(AT7611.BookNo,'''')<>'''' AND ISNULL(BookDate,'''')<>'''' 
	and AT7613.DivisionID ='''+@DivisionID+'''  and
	(AT7613.TranMonth + AT7613.TranYear*100 Between ('+str(@FromMonth)+' + '+str(@FromYear)+'*100) and ('+str(@ToMonth)+' + '+str(@ToYear)+'*100)) 
Group by AT7611.DivisionID,BeginAmount, AT7611.BookNo, BookDate, AT7611.Description, DebitAccountID, CreditAccountID '

--PRINT @sSQL

If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV7611]') and OBJECTPROPERTY(id, N'IsView') = 1)
     Exec ('  Create View AV7611 -- tao boi AP7611
							as ' + @sSQL)
Else
     Exec ('  Alter View AV7611  -- tao boi AP7611
							As ' + @sSQL)
GO

