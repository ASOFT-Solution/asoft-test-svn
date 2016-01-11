IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AQ0393]'))
DROP VIEW [dbo].[AQ0393]
GO

/****** Object:  View [dbo].[AQ0393]    Script Date: 12/16/2010 14:42:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-----View chet


CREATE VIEW  [dbo].[AQ0393]  as 
Select AT0393.DivisionID, 
	AT0393.ObjectID, 
	ObjectName,
	Address,
	CityID ,Tel ,Fax ,Email ,Website ,
	GroupID, 
	isnull(BeginDebitAmount,0) as BeginDebitAmount,
	 isnull(BeginCreditAmount,0) as  BeginCreditAmount,
	isnull(DebitAmount, 0) as DebitAmount,
	isnull(CreditAmount,0) as CreditAmount,
	isnull(EndDebitAmount,0) as EndDebitAmount,
	isnull( EndCreditAmount,0) as  EndCreditAmount,
	
	isnull(BeginDebitConAmount,0) as BeginDebitConAmount,
	 isnull(BeginCreditConAmount,0) as  BeginCreditConAmount,
	isnull(DebitConAmount, 0) as DebitConAmount,
	isnull(CreditConAmount,0) as CreditConAmount,
	isnull(EndDebitConAmount,0) as EndDebitConAmount,
	isnull( EndCreditConAmount,0) as  EndCreditConAmount,

	isnull(Col00,0) as Col00,
	isnull( Col01,0) as col01,
	isnull( Col02,0) as Col02,
	isnull(Col03,0) as Col03, 
	isnull(Col04,0) as col04, 
	isnull(Col05,0) as Col05,
	isnull(Col06, 0) as col06,
	
	isnull(ColCon00,0) as ColCon00,
	isnull( ColCon01,0) as ColCon01,
	isnull( ColCon02,0) as ColCon02,
	isnull(ColCon03,0) as ColCon03, 
	isnull(ColCon04,0) as colCon04, 
	isnull(ColCon05,0) as ColCon05,
	isnull(ColCon06, 0) as ColCon06,

	isnull(OldCol00, 0) as OldCol00,
	isnull(OldCol01, 0) as OldCol01,
	isnull(OldCol02, 0) as OldCol02,
	isnull(OldCol03,0) as OldCol03,
	isnull(OldCol04,0) as OldCol04,
	isnull(OldCol05,0) as OldCol05,
	isnull(OldCol06,0) as OldCol06,


	isnull(OldColCon00, 0) as OldColCon00,
	isnull(OldColCon01, 0) as OldColCon01,
	isnull(OldColCon02, 0) as OldColCon02,
	isnull(OldColCon03,0) as OldColCon03,
	isnull(OldColCon04,0) as OldColCon04,
	isnull(OldColCon05,0) as OldColCon05,
	isnull(OldColCon06,0) as OldColCon06,
	isnull(Days,0) as Days,
	O01ID,O02ID,O03ID,O04ID,O05ID
	
From AT0393 inner join AT1202 on AT1202.ObjectID = AT0393.ObjectID And AT1202.DivisionID = AT0393.DivisionID

GO


