IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV1504]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV1504]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-------  Created by Nguyen Van Nhan, Date 06/10/2003.
----- Purpose: La mot view chet, Dung de hien thi cac but toan khau hao
---- Edited by Nguyen Quoc Huy, Data: 28/03/2007
---- Last Edit : Thuy Tuyen 14/07/2008
---- Edit by B.Anh, date 26/05/2010	Sua loi gia tri con lai len sai
---- Modifile on 03/10/2013 by Le Thi Thu Hien : Tinh lai gia tri nguyen gia ban dau theo gia tri phan bo roi (0021535 )
---- Edit - 29/09/2014 [Tấn Phú]: Bổ sung điều kiện Join AT1503 và AT1504 DebitAccountID

CREATE VIEW [dbo].[AV1504] as 
Select 	AT1503.AssetID, AT1503.AssetName,
        	--AT1503.ConvertedAmount,
	(Case when exists (Select top 1 AssetID From AT1506 Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
					 and AT1506.TranMonth + 100*AT1506.TranYear <= AT1504.TranMOnth + 100*AT1504.TranYear)
					Then (select top 1 AT1506.ConvertedNewAmount From AT1506 
						Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
						and AT1506.TranMonth + 100*AT1506.TranYear <=  AT1504.TranMOnth + 100*AT1504.TranYear  Order by AT1506.TranYear Desc,AT1506.TranMonth Desc )
				Else AT1503.DepAmount end) as ConvertedAmount, 

	--AT1503.DepPercent,
	(Case when exists (Select top 1 AssetID From AT1506 Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
					 and AT1506.TranMonth + 100*AT1506.TranYear <= AT1504.TranMOnth + 100*AT1504.TranYear)
					Then (select top 1 AT1506.DepNewPercent From AT1506 
						Where AT1506.AssetID = AT1503.AssetID and AT1506.DivisionID = AT1503.DivisionID
						and AT1506.TranMonth + 100*AT1506.TranYear <=  AT1504.TranMOnth + 100*AT1504.TranYear  Order by AT1506.TranYear Desc,AT1506.TranMonth Desc )
				Else AT1503.DepPercent end) as DepPercent, 

	DepartmentName,
    AT1504.DepreciationID,
    AT1504.VoucherDate,
	AT1504.VoucherTypeID,
	AT1504.VoucherNo,
	AT1504.DebitAccountID,
	T01.AccountName as DebitAccountName,
	AT1504.CreditAccountID,
	T02.AccountName as CreditAccountName,
	AT1504.DepAmount,
	AT1504.ObjectID,
	AT1504.BDescription,
	(Case when AT1503.BeginMonth <10 then '0' Else '' end)+	Ltrim(Rtrim(str(AT1503.BeginMonth))) + '/' + LTrim(Rtrim(str((AT1503.BeginYear)))) as BeginMonthYear, 
	AT1504.Ana01ID,
	AT1504.Ana02ID,
	AT1504.Ana03ID,
	AT1504.Ana04ID,
	AT1504.Ana05ID,
	AT1504.Status,             
	AT1504.TranMonth,
	AT1504.TranYear,
	AT1504.DivisionID,
	AT1504.CreateUserID,
    AT1504.CreateDate,
	AT1504.LastModifyUserID,
	AT1504.LastModifyDate, 
/*
	RemainAmount = ResidualValue - isnull((Select Sum(DepAmount) From AT1504  as BT1504 
					Where 	BT1504.AssetID =AT1504.AssetID and
						DivisionID =AT1504.DivisionID and
						TranMonth + TranYear*100<  AT1504.TranMOnth + 100*AT1504.TranYear
					),0)
*/

	RemainAmount = 
			(Case when exists (Select top 1 AssetID From AT1506 Where AT1506.AssetID = AT1504.AssetID and AT1506.DivisionID = AT1503.DivisionID
					 and AT1506.TranMonth + 100*AT1506.TranYear <=  AT1504.TranMonth +AT1504.TranYear*100)
					Then  (select top 1 AT1506.ConvertedNewAmount  From AT1506 
						Where AT1506.AssetID = AT1504.AssetID and AT1506.DivisionID = AT1503.DivisionID
						and AT1506.TranMonth + 100*AT1506.TranYear <=         AT1504.TranMonth +AT1504.TranYear*100 Order by AT1506.TranYear Desc,AT1506.TranMonth Desc )
				Else AT1503.ResidualValue*CoValue/100 end)

	+ (Case when exists (Select top 1 AssetID From AT1506 Where AT1506.AssetID = AT1504.AssetID and AT1506.DivisionID = AT1503.DivisionID
					 and AT1506.TranMonth + 100*AT1506.TranYear <=          AT1504.TranMonth +AT1504.TranYear*100)
					Then  (select top 1 AT1506.AccuDepAmount    - (Isnull(T03.ConvertedAmount,0)- isnull(T03.ResidualValue,0))  From AT1506 Inner Join AT1503 T03 on T03.AssetID = AT1506.AssetID
						Where AT1506.AssetID = AT1504.AssetID and AT1506.DivisionID = AT1503.DivisionID
						and AT1506.TranMonth + 100*AT1506.TranYear <=   AT1504.TranMonth +AT1504.TranYear*100  Order by AT1506.TranYear Desc,AT1506.TranMonth Desc )
				Else 0 end)

	- (Select sum(DepAmount) From AT1504   BT1504 
		Where AssetID = AT1504.AssetID and DivisionID = AT1504.DivisionID 
			AND ISNULL(BT1504.Ana01ID,'') = ISNULL(AT1504.Ana01ID,'')
			AND ISNULL(BT1504.Ana02ID,'') = ISNULL(AT1504.Ana02ID,'')
			AND ISNULL(BT1504.Ana03ID,'') = ISNULL(AT1504.Ana03ID,'')
			AND ISNULL(BT1504.Ana04ID,'') = ISNULL(AT1504.Ana04ID,'')
			AND ISNULL(BT1504.Ana05ID,'') = ISNULL(AT1504.Ana05ID,'')
			AND ISNULL(BT1504.Ana06ID,'') = ISNULL(AT1504.Ana06ID,'')
			AND ISNULL(BT1504.Ana07ID,'') = ISNULL(AT1504.Ana07ID,'')
			AND ISNULL(BT1504.Ana08ID,'') = ISNULL(AT1504.Ana08ID,'')
			AND ISNULL(BT1504.Ana09ID,'') = ISNULL(AT1504.Ana09ID,'')
			AND ISNULL(BT1504.Ana10ID,'') = ISNULL(AT1504.Ana10ID,'')
		and tranMonth+ 100*TranYear < = AT1504.tranMonth+ 100*AT1504.TranYear)

FROM 	AT1504 	
left join (SELECT	1 AS Orders, DivisionID, AssetID, AssetName, 
			A.DebitDepAccountID1 AS AccountID, DepartmentID, DepPercent,BeginMonth,BeginYear,ResidualValue,
			DepPercent1 AS CoValue,
			ConvertedAmount*[DepPercent1]/100 AS DepAmount,
			A.Ana01ID1 AS Ana01ID, A.Ana02ID1 AS Ana02ID, A.Ana03ID1 AS Ana03ID, A.Ana04ID1 AS Ana04ID, A.Ana05ID1 AS Ana05ID,
			A.Ana06ID1 AS Ana06ID, A.Ana07ID1 AS Ana07ID, A.Ana08ID1 AS Ana08ID, A.Ana09ID1 AS Ana09ID, A.Ana10ID1 AS Ana10ID
	FROM	AT1503 A
	WHERE	UseCofficientID <> 1
			AND ISNULL(DepPercent1,0) <> 0
			AND ISNULL(AssetID,'') <> ''
	UNION ALL
	SELECT	2 AS Orders, DivisionID, AssetID, AssetName, 
			A.DebitDepAccountID2 AS AccountID, DepartmentID, DepPercent,BeginMonth,BeginYear,ResidualValue,
			DepPercent2 AS CoValue,
			ConvertedAmount*[DepPercent2]/100 AS DepAmount,
			A.Ana01ID2 AS Ana01ID, A.Ana02ID2 AS Ana02ID, A.Ana03ID2 AS Ana03ID, A.Ana04ID2 AS Ana04ID, A.Ana05ID2 AS Ana05ID,
			A.Ana06ID2 AS Ana06ID, A.Ana07ID2 AS Ana07ID, A.Ana08ID2 AS Ana08ID, A.Ana09ID2 AS Ana09ID, A.Ana10ID2 AS Ana10ID
	FROM	AT1503 A
	WHERE	UseCofficientID <> 1
			AND ISNULL(DepPercent2,0) <> 0
			AND ISNULL(AssetID,'') <> ''

	UNION ALL
	SELECT	3 AS Orders, DivisionID, AssetID, AssetName, 
			A.DebitDepAccountID3 AS AccountID, DepartmentID, DepPercent,BeginMonth,BeginYear,ResidualValue,
			DepPercent3 AS CoValue,
			ConvertedAmount*[DepPercent3]/100 AS DepAmount,
			A.Ana01ID3 AS Ana01ID, A.Ana02ID3 AS Ana02ID, A.Ana03ID1 AS Ana03ID, A.Ana04ID3 AS Ana04ID, A.Ana05ID3 AS Ana05ID,
			A.Ana06ID3 AS Ana06ID, A.Ana07ID3 AS Ana07ID, A.Ana08ID3 AS Ana08ID, A.Ana09ID3 AS Ana09ID, A.Ana10ID3 AS Ana10ID
	FROM	AT1503 A
	WHERE	UseCofficientID <> 1
			AND ISNULL(DepPercent3,0) <> 0
			AND ISNULL(AssetID,'') <> ''
	UNION ALL
	SELECT	4 AS Orders, DivisionID, AssetID, AssetName, 
			A.DebitDepAccountID4 AS AccountID, DepartmentID, DepPercent,BeginMonth,BeginYear,ResidualValue,
			DepPercent4 AS CoValue,
			ConvertedAmount*[DepPercent4]/100 AS DepAmount,
			A.Ana01ID4 AS Ana01ID, A.Ana02ID4 AS Ana02ID, A.Ana03ID1 AS Ana03ID, A.Ana04ID4 AS Ana04ID, A.Ana05ID4 AS Ana05ID,
			A.Ana06ID4 AS Ana06ID, A.Ana07ID4 AS Ana07ID, A.Ana08ID4 AS Ana08ID, A.Ana09ID4 AS Ana09ID, A.Ana10ID4 AS Ana10ID
	FROM	AT1503 A
	WHERE	UseCofficientID <> 1
			AND ISNULL(DepPercent4,0) <> 0
			AND ISNULL(AssetID,'') <> ''
	UNION ALL
	SELECT	5 AS Orders, DivisionID, AssetID, AssetName, 
			A.DebitDepAccountID5 AS AccountID, DepartmentID, DepPercent,BeginMonth,BeginYear,ResidualValue,
			DepPercent5 AS CoValue,
			ConvertedAmount*[DepPercent5]/100 AS DepAmount,
			A.Ana01ID5 AS Ana01ID, A.Ana02ID5 AS Ana02ID, A.Ana03ID1 AS Ana03ID, A.Ana04ID5 AS Ana04ID, A.Ana05ID5 AS Ana05ID,
			A.Ana06ID5 AS Ana06ID, A.Ana07ID5 AS Ana07ID, A.Ana08ID5 AS Ana08ID, A.Ana09ID5 AS Ana09ID, A.Ana10ID5 AS Ana10ID
	FROM	AT1503 A
	WHERE	UseCofficientID <> 1
			AND ISNULL(DepPercent5,0) <> 0
			AND ISNULL(AssetID,'') <> ''
	UNION ALL		
	SELECT	A.Orders, A.DivisionID, AssetID, AssetName,
			A.AccountID, DepartmentID, DepPercent,BeginMonth,BeginYear,ResidualValue,
			A.CoValue AS CoValue,
			ConvertedAmount*A.CoValue/100 AS DepAmount,
			A.Ana01ID, A.Ana02ID, A.Ana03ID, A.Ana04ID, A.Ana05ID,
			A.Ana06ID, A.Ana07ID, A.Ana08ID, A.Ana09ID, A.Ana10ID
	FROM	AT1511 A
	LEFT JOIN AT1503 A1 ON A1.DivisionID = A.DivisionID AND A1.CoefficientID = A.CoefficientID
	WHERE	UseCofficientID = 1	
			AND ISNULL(AssetID,'') <> '')AT1503 
	on	 AT1503.AssetID = AT1504.AssetID AND AT1503.DivisionID = AT1504.DivisionID   
	-- Bổ sung điều kiện left join 29/09/2014 [Tấn Phú] AccountID và DebitAccountID
	AND ISNULL(AT1503.AccountID,'') = ISNULL(AT1504.DebitAccountID,'') 
	AND ISNULL(AT1503.Ana01ID,'') = ISNULL(AT1504.Ana01ID,'')
	AND ISNULL(AT1503.Ana02ID,'') = ISNULL(AT1504.Ana02ID,'')
	AND ISNULL(AT1503.Ana03ID,'') = ISNULL(AT1504.Ana03ID,'')
	AND ISNULL(AT1503.Ana04ID,'') = ISNULL(AT1504.Ana04ID,'')
	AND ISNULL(AT1503.Ana05ID,'') = ISNULL(AT1504.Ana05ID,'')
	AND ISNULL(AT1503.Ana06ID,'') = ISNULL(AT1504.Ana06ID,'')
	AND ISNULL(AT1503.Ana07ID,'') = ISNULL(AT1504.Ana07ID,'')
	AND ISNULL(AT1503.Ana08ID,'') = ISNULL(AT1504.Ana08ID,'')
	AND ISNULL(AT1503.Ana09ID,'') = ISNULL(AT1504.Ana09ID,'')
	AND ISNULL(AT1503.Ana10ID,'') = ISNULL(AT1504.Ana10ID,'')
LEFT JOIN AT1102 on AT1503.DepartmentID = AT1102.DepartmentID AND AT1503.DivisionID = AT1102.DivisionID
Left join AT1005 T01  on T01.AccountID = AT1504.DebitAccountID And T01.DivisionID = AT1504.DivisionID
Left join AT1005 T02  on T02.AccountID = AT1504.CreditAccountID And T02.DivisionID = AT1504.DivisionID
Left JOIN AT1506 ON AT1506.AssetID = AT1504.AssetID	and AT1506.Tranmonth = AT1504.TranMonth
					and AT1506.TranYear = AT1504.TranYear And AT1506.DivisionID = AT1504.DivisionID
WHERE	ISNULL(AT1504.AssetID,'') <> ''
		


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

