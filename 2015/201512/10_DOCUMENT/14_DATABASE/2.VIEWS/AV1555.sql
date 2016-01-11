
/****** Object:  View [dbo].[AV1555]    Script Date: 12/16/2010 14:44:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

-------- Created by Van Nhan.
---------Date 26/10/2007
-------- View chet, the hien so du va so phat sinh bao cao THTG TSCD
--------Last Edit Thuy Tuyen  , date 19/11/2007

ALTER VIEW [dbo].[AV1555] as 
----------------------------------- Lay nguyen gia ------------------------------
Select 	DivisionID, AssetID, AssetStatus, ConvertedAmount, ConvertedAmount  as SignAmount, 'CA' As DataTypeID,
	AssetAccountID as AccountID,
	--BeginMonth as TranMonth,
	---BeginYear as TranYear,
	Month (EstablishDate)as TranMonth , 
	Year(EstablishDate) as TranYear ,
	'D' as D_C,  --- BL
	isnull(CauseID,'MU') as  FromStatusID,  --- Cause
	Case when AssetStatus =3 then 'DTL' Else 'DSD' End as NowStatusID,
	AssetGroupID 	--- Ung voi 
From AT1503

----------------------------------- Lay ghi giam ------------------------------
UNION ALL
Select 	At1523.DivisionID, AT1523.AssetID, At1523.AssetStatus, AT1523.ConvertedAmount, -(At1523.ConvertedAmount)  as SignAmount, 'CA' As DataTypeID,
	AssetAccountID as AccountID,
	ReduceMonth as TranMonth,
	ReduceYear as TranYear,
	'C' as D_C,  --- BL
	isnull(CauseID,'MU') as  FromStatusID,  --- Cause
	Case when At1523.AssetStatus =2 then 'NB' Else 'TL' End as NowStatusID,
	AssetGroupID 	--- Ung voi 
From AT1523
	Inner Join AT1503 on AT1503.AssetID = AT1523.AssetID




---------------------------------- Hao mon -----------------------------------------------------------
Union All
Select 	AT1504.DivisionID, AT1504.AssetID, AT1503.AssetStatus, AT1504.DepAmount as ConvertedAmount, -AT1504.DepAmount as SignAmount, 'DE' As DataTypeID,
	CreditAccountID as AccountID,

	TranMonth as TranMonth,
	TranYear as TranYear,
	'C' as D_C,
	isnull(CauseID,'MU') as  FromStatusID,
	Case when AssetStatus =3 then 'DTL' Else 'DSD' End as NowStatusID 	,
	AssetGroupID
From AT1504 inner join AT1503 on AT1503.AssetID =AT1504.AssetID
Union All
Select 	DivisionID, AssetID, AssetStatus, ConvertedAmount-isnull(ResidualValue,0) as ConvertedAmount, -ConvertedAmount+isnull(ResidualValue,0) as SignAmount, 'DE' As DataTypeID,
	DepAccountID as AccountID,
	BeginMonth as TranMonth,
	BeginYear as TranYear,
	
	'C' as D_C,
	isnull(CauseID,'MU') as  FromStatusID,
	Case when AssetStatus =3 then 'DTL' Else 'DSD' End as NowStatusID 	,
	AssetGroupID
From AT1503
Where isnull(ResidualValue,0)<>ConvertedAmount 

Union All ----- Gia tri con lai
Select 
AT1503.DivisionID, AT1503.AssetID, AT1503.AssetStatus,
isnull (Isnull (ResidualValue,0),AT1503.ConvertedAmount)  as ConvertedAmount,  
isnull (Isnull (ResidualValue,0),AT1503.ConvertedAmount)  as SignAmount, 'RE' As DataTypeID,
	DepAccountID as AccountID,
	---BeginMonth as TranMonth,
	---BeginYear as TranYear,
	Month (EstablishDate)as TranMonth , 
	Year(EstablishDate) as TranYear ,

	'C' as D_C,
	isnull(CauseID,'MU') as  FromStatusID,
	Case when AT1503.AssetStatus =3 then 'DTL' Else 'DSD' End as NowStatusID 	,
	AssetGroupID


From AT1503


Union All --giam  gia tri hao mon

Select 	AT1523.DivisionID, AT1523.AssetID, AT1503.AssetStatus, AT1523.AccuDepAmount as ConvertedAmount,  AT1523.AccuDepAmount  as SignAmount, 'DE' As DataTypeID,
	DepAccountID as AccountID,
	ReduceMonth as TranMonth,
	ReduceYear as TranYear,
	'D' as D_C,
	isnull(CauseID,'MU') as  FromStatusID,
	Case when AT1503.AssetStatus =3 then 'DTL' Else 'DSD' End as NowStatusID 	,
	AssetGroupID
From AT1523 iNNER jOIN AT1503 on AT1503.AssetID = AT1523.AssetID

GO


