/****** Object:  View [dbo].[AV7602]    Script Date: 12/16/2010 14:55:24 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

--View chet???
  
ALTER VIEW [dbo].[AV7602]  As  Select AT7611.DivisionID, AT7611.ReportCode, BookNo, FromDate, ToDate, Description, 
		BookDate, ByAccountID, Debit,TransactionTypeID 
	From AT7611 inner join AT7612 on AT7612.ReportCode = AT7611.ReportCode 
	Where (TranMonth + 100*TranYear between          8+      2006*100 and          8+100*      2006)  and 
	AT7611.DivisionID ='NHT'

GO


