IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AQ0393]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AQ0393]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- View chet
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 10/11/2011 by 
---- 
---- Modified on 10/11/2011 by Le Thi Thu Hien : Bo sung 5 ten ma phan tich
-- <Example>
---- 

CREATE VIEW  [dbo].[AQ0393]  AS 
SELECT	AT0393.DivisionID, 
		AT0393.ObjectID, 
		ObjectName,
		Address,
		CityID ,Tel ,Fax ,Email ,Website ,
		GroupID, 
		ISNULL(BeginDebitAmount,0) AS BeginDebitAmount,
		ISNULL(BeginCreditAmount,0) AS  BeginCreditAmount,
		ISNULL(DebitAmount, 0) AS DebitAmount,
		ISNULL(CreditAmount,0) AS CreditAmount,
		ISNULL(EndDebitAmount,0) AS EndDebitAmount,
		ISNULL( EndCreditAmount,0) AS  EndCreditAmount,
		
		ISNULL(BeginDebitConAmount,0) AS BeginDebitConAmount,
		ISNULL(BeginCreditConAmount,0) AS  BeginCreditConAmount,
		ISNULL(DebitConAmount, 0) AS DebitConAmount,
		ISNULL(CreditConAmount,0) AS CreditConAmount,
		ISNULL(EndDebitConAmount,0) AS EndDebitConAmount,
		ISNULL( EndCreditConAmount,0) AS  EndCreditConAmount,

		ISNULL(Col00,0) AS Col00,
		ISNULL(Col01,0) AS col01,
		ISNULL(Col02,0) AS Col02,
		ISNULL(Col03,0) AS Col03, 
		ISNULL(Col04,0) AS col04, 
		ISNULL(Col05,0) AS Col05,
		ISNULL(Col06, 0) AS col06,
		
		ISNULL(ColCon00,0) AS ColCon00,
		ISNULL(ColCon01,0) AS ColCon01,
		ISNULL(ColCon02,0) AS ColCon02,
		ISNULL(ColCon03,0) AS ColCon03, 
		ISNULL(ColCon04,0) AS colCon04, 
		ISNULL(ColCon05,0) AS ColCon05,
		ISNULL(ColCon06, 0) AS ColCon06,

		ISNULL(OldCol00, 0) AS OldCol00,
		ISNULL(OldCol01, 0) AS OldCol01,
		ISNULL(OldCol02, 0) AS OldCol02,
		ISNULL(OldCol03,0) AS OldCol03,
		ISNULL(OldCol04,0) AS OldCol04,
		ISNULL(OldCol05,0) AS OldCol05,
		ISNULL(OldCol06,0) AS OldCol06,


		ISNULL(OldColCon00, 0) AS OldColCon00,
		ISNULL(OldColCon01, 0) AS OldColCon01,
		ISNULL(OldColCon02, 0) AS OldColCon02,
		ISNULL(OldColCon03,0) AS OldColCon03,
		ISNULL(OldColCon04,0) AS OldColCon04,
		ISNULL(OldColCon05,0) AS OldColCon05,
		ISNULL(OldColCon06,0) AS OldColCon06,
		ISNULL(Days,0) AS Days,
		O01ID,O02ID,O03ID,O04ID,O05ID,
		O01.AnaName AS O01Name,
		O02.AnaName AS O02Name,
		O03.AnaName AS O03Name,
		O04.AnaName AS O04Name,
		O05.AnaName AS O05Name
	
FROM		AT0393 
INNER JOIN	AT1202 
	ON		AT1202.ObjectID = AT0393.ObjectID 
			AND AT1202.DivisionID = AT0393.DivisionID
LEFT JOIN	AT1015 O01
	ON		O01.AnaID = O01ID
			AND O01.AnaTypeID = 'O01'
			AND O01.DivisionID = AT0393.DivisionID
LEFT JOIN	AT1015 O02
	ON		O02.AnaID = O01ID
			AND O02.AnaTypeID = 'O02'
			AND O02.DivisionID = AT0393.DivisionID
LEFT JOIN	AT1015 O03
	ON		O03.AnaID = O01ID
			AND O03.AnaTypeID = 'O03'
			AND O03.DivisionID = AT0393.DivisionID
LEFT JOIN	AT1015 O04
	ON		O04.AnaID = O01ID
			AND O04.AnaTypeID = 'O04'
			AND O04.DivisionID = AT0393.DivisionID
LEFT JOIN	AT1015 O05
	ON		O05.AnaID = O01ID
			AND O05.AnaTypeID = 'O05'
			AND O05.DivisionID = AT0393.DivisionID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

