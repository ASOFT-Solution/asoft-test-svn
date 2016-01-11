IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV9090]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV9090]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by Nguyen Van Nhan.
--- Created Date 06.06.06
---- Purpose: In bao cao tai chinh cua bao cao quan tri
---- Edit by Nguyen Quoc Huy, Date: 28/12/2008
---- Modify on 27/01/2013 by Bao Anh: Bo sung Quarter, Year	
---- Modified on 05/03/2014 by Le Thi Thu Hien : Bo sung phan quyen xem du lieu cua nguoi khac, Bo sung CreateUserID
-- <Example>
---- 
-- <Summary>
CREATE VIEW [dbo].[AV9090] as 
--===================================== 	SO LIEU PHAT SINH THUC TE==================----------------------------------------------------
-----1..... Phat sinh No. 	Du lieu phat sinh 
SELECT 	Ana01ID ,	Ana02ID ,	Ana03ID ,	Ana04ID ,	Ana05ID ,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID, 
		ObjectID,
		REPLICATE('0', 2- len(ltrim(rtrim(str(AT9000.TranMonth)))))+ltrim(rtrim(str(AT9000.TranMonth)))+'/'+ltrim(rtrim(str(AT9000.TranYear))) as PeriodID, 
		REPLICATE('0', 2- len(ltrim(rtrim(str(AT9000.TranMonth)))))+ltrim(rtrim(str(AT9000.TranMonth)))+'/'+ltrim(rtrim(str(AT9000.TranYear))) as MonthYear, 
		AT9000.TranMonth,
		AT9000.TranYear,
		AT9000.DivisionID,
		DebitAccountID as AccountID,
		CreditAccountID as CorAccountID,
		'D' as D_C,
		sum(ISNULL(ConvertedAmount,0)) as SignAmount,
		sum(ISNULL(Quantity,0)) as SignQuantity,
		'AA' as BudgetID,
		TransactionTypeID,
		AV9999.Quarter, AT9000.TranYear as YEAR,
		MAX(AT9000.CreateUserID) AS CreateUserID
FROM	AT9000
INNER JOIN	AV9999 
	ON		AT9000.DivisionID = AV9999.DivisionID 
			AND AT9000.TranMonth = AV9999.TranMonth 
			AND AT9000.TranYear = AV9999.TranYear
WHERE	ISNULL(DebitAccountID,'')<>'' --and ISNULL(Ana01ID,'')<>''
GROUP BY ObjectID, 
		Ana01ID ,	Ana02ID ,	Ana03ID ,	Ana04ID ,	Ana05ID ,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID, 
		AT9000.TranMonth, AT9000.TranYear,	AT9000.DivisionID,
		DebitAccountID,	CreditAccountID,TransactionTypeID, AV9999.Quarter, AT9000.TranYear
		
UNION ALL
----- 2. Phat sinh Co.	Du lieu phat sinh 
SELECT 	Ana01ID ,	Ana02ID ,	Ana03ID ,	Ana04ID ,	Ana05ID ,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID, 
		Case when TransactionTypeID ='T99' then CreditObjectID else ObjectID end as ObjectID,
		REPLICATE('0', 2- len(ltrim(rtrim(str(AT9000.TranMonth)))))+ltrim(rtrim(str(AT9000.TranMonth)))+'/'+ltrim(rtrim(str(AT9000.TranYear))) as PeriodID, 
		REPLICATE('0', 2- len(ltrim(rtrim(str(AT9000.TranMonth)))))+ltrim(rtrim(str(AT9000.TranMonth)))+'/'+ltrim(rtrim(str(AT9000.TranYear))) as MonthYear, 
		AT9000.TranMonth,
		AT9000.TranYear,
		AT9000.DivisionID,
		CreditAccountID as AccountID,
		DebitAccountID as CorAccountID,
		'C' as D_C,
		-sum(ISNULL(ConvertedAmount,0)) as SignAmount,
		-sum(ISNULL(Quantity,0)) as SignQuantity,
		'AA' as BudgetID,
		TransactionTypeID, AV9999.Quarter, AT9000.TranYear as YEAR,
		MAX(AT9000.CreateUserID) AS CreateUserID
FROM AT9000
INNER JOIN AV9999 On AT9000.DivisionID = AV9999.DivisionID And AT9000.TranMonth = AV9999.TranMonth And AT9000.TranYear = AV9999.TranYear
WHERE ISNULL(CreditAccountID,'')<>'' --and ISNULL(Ana01ID,'')<>''
GROUP BY ObjectID, 
		Ana01ID ,	Ana02ID ,	Ana03ID ,	Ana04ID ,	Ana05ID ,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID, 
		AT9000.TranMonth, AT9000.TranYear,	AT9000.DivisionID, CreditObjectID,
		DebitAccountID,	CreditAccountID,TransactionTypeID, AV9999.Quarter, AT9000.TranYear
 
--===================================== 	SO LIEU PHAN BO ============----------------------------------------------------
UNION ALL
SELECT 	Ana01ID ,	Ana02ID ,	Ana03ID ,	Ana04ID ,	Ana05ID ,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
		ObjectID,
		REPLICATE('0', 2- len(ltrim(rtrim(str(AT9001.TranMonth)))))+ltrim(rtrim(str(AT9001.TranMonth)))+'/'+ltrim(rtrim(str(AT9001.TranYear))) as PeriodID, 
		REPLICATE('0', 2- len(ltrim(rtrim(str(AT9001.TranMonth)))))+ltrim(rtrim(str(AT9001.TranMonth)))+'/'+ltrim(rtrim(str(AT9001.TranYear))) as MonthYear, 
		AT9001.TranMonth,
		AT9001.TranYear,
		AT9001.DivisionID,
		DebitAccountID as AccountID,
		CreditAccountID as CorAccountID,
		'D' as D_C,
		sum(ISNULL(ConvertedAmount,0)) as SignAmount,
		sum(ISNULL(Quantity,0)) as SignQuantity,
		'AA' as BudgetID,
		ISNULL(TransactionTypeID,''), AV9999.Quarter, AT9001.TranYear as Year ,
		MAX(AT9001.CreateUserID) AS CreateUserID
FROM AT9001
INNER JOIN AV9999 On AT9001.DivisionID = AV9999.DivisionID And AT9001.TranMonth = AV9999.TranMonth And AT9001.TranYear = AV9999.TranYear
WHERE ISNULL(DebitAccountID,'')<>'' --and ISNULL(Ana01ID,'')<>''
GROUP BY ObjectID, 
		Ana01ID ,	Ana02ID ,	Ana03ID ,	Ana04ID ,	Ana05ID ,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID, 
		AT9001.TranMonth, AT9001.TranYear,	AT9001.DivisionID,
		DebitAccountID,	CreditAccountID,TransactionTypeID, AV9999.Quarter, AT9001.TranYear

UNION ALL

SELECT 	Ana01ID ,	Ana02ID ,	Ana03ID ,	Ana04ID ,	Ana05ID ,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
		ObjectID,
		REPLICATE('0', 2- len(ltrim(rtrim(str(AT9001.TranMonth)))))+ltrim(rtrim(str(AT9001.TranMonth)))+'/'+ltrim(rtrim(str(AT9001.TranYear))) as PeriodID, 
		REPLICATE('0', 2- len(ltrim(rtrim(str(AT9001.TranMonth)))))+ltrim(rtrim(str(AT9001.TranMonth)))+'/'+ltrim(rtrim(str(AT9001.TranYear))) as MonthYear, 
		AT9001.TranMonth,
		AT9001.TranYear,
		AT9001.DivisionID,
		CreditAccountID as AccountID,
		DebitAccountID as CorAccountID,
		'C' as D_C,
		-sum(ISNULL(ConvertedAmount,0)) as SignAmount,
		-sum(ISNULL(Quantity,0)) as SignQuantity,
		'AA' as BudgetID,
		ISNULL(TransactionTypeID,''), AV9999.Quarter, AT9001.TranYear as YEAR,
		MAX(AT9001.CreateUserID) AS CreateUserID
FROM AT9001
INNER JOIN AV9999 On AT9001.DivisionID = AV9999.DivisionID And AT9001.TranMonth = AV9999.TranMonth And AT9001.TranYear = AV9999.TranYear
WHERE ISNULL(CreditAccountID,'')<>'' --and ISNULL(Ana01ID,'')<>''
GROUP BY ObjectID, 
		Ana01ID ,	Ana02ID ,	Ana03ID ,	Ana04ID ,	Ana05ID ,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID, 
		AT9001.TranMonth, AT9001.TranYear,	AT9001.DivisionID,DebitAccountID,	
		CreditAccountID,TransactionTypeID, AV9999.Quarter, AT9001.TranYear

--===================================== 	SO LIEU NGAN SACH ============----------------------------------------------------
UNION ALL
SELECT 	Ana01ID ,	Ana02ID ,	Ana03ID ,	Ana04ID ,	Ana05ID ,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
		ObjectID,
		REPLICATE('0', 2- len(ltrim(rtrim(str(AT9090.TranMonth)))))+ltrim(rtrim(str(AT9090.TranMonth)))+'/'+ltrim(rtrim(str(AT9090.TranYear))) as PeriodID, 
		REPLICATE('0', 2- len(ltrim(rtrim(str(AT9090.TranMonth)))))+ltrim(rtrim(str(AT9090.TranMonth)))+'/'+ltrim(rtrim(str(AT9090.TranYear))) as MonthYear, 
		AT9090.TranMonth,
		AT9090.TranYear,
		AT9090.DivisionID,
		DebitAccountID as AccountID,
		CreditAccountID as CorAccountID,
		'D' as D_C,
		sum(ISNULL(ConvertedAmount,0)) as SignAmount,
		sum(ISNULL(Quantity,0)) as SignQuantity,
		Case  BudgetType  When 'M' then 'B1' 
					When 'Y' then 'B2'
					Else BudgetType
		End   as BudgetID,
		ISNULL(TransactionTypeID,''), AV9999.Quarter, AT9090.TranYear as YEAR,
		MAX(AT9090.CreateUserID) AS CreateUserID
FROM	AT9090
INNER JOIN AV9999 On AT9090.DivisionID = AV9999.DivisionID And AT9090.TranMonth = AV9999.TranMonth And AT9090.TranYear = AV9999.TranYear
WHERE	ISNULL(DebitAccountID,'')<>'' --and ISNULL(Ana01ID,'')<>''
GROUP BY ObjectID, 
		Ana01ID ,	Ana02ID ,	Ana03ID ,	Ana04ID ,	Ana05ID ,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,  
		AT9090.TranMonth, AT9090.TranYear,	AT9090.DivisionID, DebitAccountID,	
		CreditAccountID,TransactionTypeID, BudgetType, AV9999.Quarter, AT9090.TranYear
UNION ALL
SELECT 	Ana01ID ,	Ana02ID ,	Ana03ID ,	Ana04ID ,	Ana05ID ,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
		ObjectID,
		REPLICATE('0', 2- len(ltrim(rtrim(str(AT9090.TranMonth)))))+ltrim(rtrim(str(AT9090.TranMonth)))+'/'+ltrim(rtrim(str(AT9090.TranYear))) as PeriodID, 
		REPLICATE('0', 2- len(ltrim(rtrim(str(AT9090.TranMonth)))))+ltrim(rtrim(str(AT9090.TranMonth)))+'/'+ltrim(rtrim(str(AT9090.TranYear))) as MonthYear, 
		AT9090.TranMonth,
		AT9090.TranYear,
		AT9090.DivisionID,
		CreditAccountID as AccountID,
		DebitAccountID as CorAccountID,
		'C' as D_C,
		-sum(ISNULL(ConvertedAmount,0)) as SignAmount,
		-sum(ISNULL(Quantity,0)) as SignQuantity,
		Case  BudgetType  When 'M' then 'B1' 
					When 'Y' then 'B2'
					Else BudgetType
		End   as BudgetID,
		ISNULL(TransactionTypeID,''), AV9999.Quarter, AT9090.TranYear as YEAR,
		MAX(AT9090.CreateUserID) AS CreateUserID
FROM	AT9090
INNER JOIN AV9999 On AT9090.DivisionID = AV9999.DivisionID And AT9090.TranMonth = AV9999.TranMonth And AT9090.TranYear = AV9999.TranYear
WHERE ISNULL(CreditAccountID,'')<>'' --and ISNULL(Ana01ID,'')<>''
GROUP BY ObjectID, 
		Ana01ID ,	Ana02ID ,	Ana03ID ,	Ana04ID ,	Ana05ID ,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,  
		AT9090.TranMonth, AT9090.TranYear,	AT9090.DivisionID, DebitAccountID,	
		CreditAccountID,TransactionTypeID,BudgetType, AV9999.Quarter, AT9090.TranYear

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON