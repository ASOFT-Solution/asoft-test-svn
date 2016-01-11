
/****** Object:  View [dbo].[AV7777]    Script Date: 03/17/2011 13:25:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

------ Created by Nguyen Van Nhan.
---- Created Date 23/04/2005
----- Purpose View chet de the hien so lieu So du hang ton kho qua cac ky

ALTER VIEW [dbo].[AV7777] AS
Select 	T8.WareHouseID ,T3.WareHouseName, 
	T8.TranMonth ,T8.TranYear ,T8.DivisionID ,
	T8.InventoryID ,T8.InventoryAccountID as AccountID, 
	T2.S1 as CI1ID,
	T2.S2 as CI2ID,
	T2.S3 as CI3ID,
	T2.I01ID,T2.I02ID,T2.I03ID,T2.I04ID,T2.I05ID,
	T8.BeginQuantity ,T8.EndQuantity ,T8.DebitQuantity ,
	T8.CreditQuantity ,T8.InDebitQuantity,T8.InCreditQuantity,
	T8.BeginAmount ,T8.EndAmount, T8.DebitAmount, T8.CreditAmount, 
	T8.InDebitAmount, T8.InCreditAmount,
	isnull(T3.IsTemp,0) as IsTemp,
	(Case When   T8.TranMonth <10 then '0'+rtrim(ltrim(str( T8.TranMonth)))+'/'+ltrim(Rtrim(str( T8.TranYear))) 
	Else rtrim(ltrim(str( T8.TranMonth)))+'/'+ltrim(Rtrim(str( T8.TranYear))) End) as MonthYear,
	('0'+ ltrim(rtrim(Case when  T8.TranMonth %3 = 0 then  T8.TranMonth/3  Else  T8.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str( T8.TranYear)))
	)  as Quarter ,
	str(T8.TranYear) as Year,
	TranMonth+100*TranYear as Period

From AT2008 T8 	inner join AT1303 T3 on T3.WareHouseID = T8.WareHouseID and T3.DivisionID = T8.DivisionID
		Inner join AT1302 T2 on T2.InventoryID = T8.InventoryID and T2.DivisionID = T8.DivisionID

GO


