IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AV2223]'))
DROP VIEW [dbo].AV2223
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--- Created by Bao Anh	Date: 16/09/2012	
--- Purpose: Tao view giong AV2222, bo sung them cac tham so dung cho ton kho theo quy cach (2T)

CREATE VIEW [dbo].[AV2223] as
Select  (Case When DE.DivisionID is Null Then CE.DivisionID Else DE.DivisionID End) As DivisionID,
	 (Case When DE.TranMonth is Null Then CE.TranMonth Else DE.TranMonth End) As TranMonth,
	 (Case When DE.TranYear is Null Then CE.TranYear Else DE.TranYear End) As TranYear,
	 (Case When DE.WareHouseID is Null Then CE.WareHouseID Else DE.WareHouseID End) As WareHouseID,
	 (Case When DE.InventoryID is Null Then CE.InventoryID Else DE.InventoryID End) As InventoryID,
	 (Case When DE.InventoryAccountID is Null Then CE.InventoryAccountID Else DE.InventoryAccountID End) As InventoryAccountID,
	 (Case When DE.Parameter01 is Null Then CE.Parameter01 Else DE.Parameter01 End) As Parameter01,
	 (Case When DE.Parameter02 is Null Then CE.Parameter02 Else DE.Parameter02 End) As Parameter02,
	 (Case When DE.Parameter03 is Null Then CE.Parameter03 Else DE.Parameter03 End) As Parameter03,
	 (Case When DE.Parameter04 is Null Then CE.Parameter04 Else DE.Parameter04 End) As Parameter04,
	 (Case When DE.Parameter05 is Null Then CE.Parameter05 Else DE.Parameter05 End) As Parameter05,
	 BeginQuantity, 
	 BeginAmount, 
	 DebitQuantity, 
	 DebitAmount,
	 InDebitQuantity,
	 InDebitAmount,	
	 CE.Quantity As CreditQuantity,
	 CE.Amount As CreditAmount,
	 CE.InQuantity As InCreditQuantity,
	 CE.InAmount As InCreditAmount	
	
From
--Nhap + So du
(Select  (Case When BE.DivisionID is Null Then DE.DivisionID Else BE.DivisionID End) As DivisionID,
	(Case When BE.TranMonth is Null Then DE.TranMonth Else BE.TranMonth End) As TranMonth,
	(Case When BE.TranYear is Null Then DE.TranYear Else BE.TranYear End) As TranYear,
	(Case When BE.WareHouseID is Null Then DE.WareHouseID Else BE.WareHouseID End) As WareHouseID,
	(Case When BE.InventoryID is Null Then DE.InventoryID Else BE.InventoryID End) As InventoryID,
	(Case When BE.InventoryAccountID is Null Then DE.InventoryAccountID Else BE.InventoryAccountID End) As InventoryAccountID,
	(Case When BE.Parameter01 is Null Then DE.Parameter01 Else BE.Parameter01 End) As Parameter01,
	(Case When BE.Parameter02 is Null Then DE.Parameter02 Else BE.Parameter02 End) As Parameter02,
	(Case When BE.Parameter03 is Null Then DE.Parameter03 Else BE.Parameter03 End) As Parameter03,
	(Case When BE.Parameter04 is Null Then DE.Parameter04 Else BE.Parameter04 End) As Parameter04,
	(Case When BE.Parameter05 is Null Then DE.Parameter05 Else BE.Parameter05 End) As Parameter05,
	BE.Quantity As BeginQuantity, 
	BE.Amount As BeginAmount, 
	DE.Quantity As DebitQuantity, 
	DE.Amount As DebitAmount,
	DE.InQuantity As InDebitQuantity,
	DE.InAmount As InDebitAmount
From
--So du dau
(Select T16.DivisionID,T16.TranMonth,T16.TranYear,T16.WareHouseID,T17.InventoryID,T17.DebitAccountID As InventoryAccountID,
 T17.Parameter01, T17.Parameter02, T17.Parameter03, T17.Parameter04, T17.Parameter05,
isnull(Sum(isnull(T17.ActualQuantity,0)),0) As Quantity, 
isnull(Sum(isnull(T17.ConvertedAmount,0)),0) As Amount 
From AT2016 T16 Inner join AT2017 T17 On T16.VoucherID = T17.VoucherID
Group by T16.DivisionID,T16.TranMonth,T16.TranYear,WareHouseID,InventoryID,DebitAccountID,
			T17.Parameter01, T17.Parameter02, T17.Parameter03, T17.Parameter04, T17.Parameter05) As BE
Full Join
--Nhap kho
(Select T16.DivisionID,T16.TranMonth,T16.TranYear,T16.WareHouseID,T17.InventoryID,T17.DebitAccountID As InventoryAccountID,
T17.Parameter01, T17.Parameter02, T17.Parameter03, T17.Parameter04, T17.Parameter05, 
isnull(Sum(isnull(T17.ActualQuantity,0)),0) As Quantity, 
isnull(Sum(isnull(T17.ConvertedAmount,0)),0) As Amount,
isnull(Sum(Case When T16.KindVoucherID = 3 Then isnull(T17.ActualQuantity,0) Else 0 End),0) As InQuantity, 
isnull(Sum(Case When T16.KindVoucherID = 3 Then isnull(T17.ConvertedAmount,0) Else 0 End),0) As InAmount  
From AT2006 T16 Inner join AT2007 T17 On T16.VoucherID = T17.VoucherID
Where KindVoucherID in (1,3,5,7,9,15,17)
Group by T16.DivisionID,T16.TranMonth,T16.TranYear,WareHouseID,InventoryID,DebitAccountID,
			T17.Parameter01, T17.Parameter02, T17.Parameter03, T17.Parameter04, T17.Parameter05) AS DE

On 
BE.DivisionID = DE.DivisionID 
And BE.TranMonth = DE.TranMonth 
And BE.TranYear = DE.TranYear
And BE.WareHouseID = DE.WareHouseID
And BE.InventoryID = DE.InventoryID
And BE.InventoryAccountID = DE.InventoryAccountID
And ISNULL(BE.Parameter01,0) = Isnull(DE.Parameter01,0)
And ISNULL(BE.Parameter02,0) = Isnull(DE.Parameter02,0)
And ISNULL(BE.Parameter03,0) = Isnull(DE.Parameter03,0)
And ISNULL(BE.Parameter04,0) = Isnull(DE.Parameter04,0)
And ISNULL(BE.Parameter05,0) = Isnull(DE.Parameter05,0)
) As DE

Full Join
--Xuat kho
(Select T16.DivisionID,T16.TranMonth,T16.TranYear,(Case When KindVoucherID = 3 Then T16.WareHouseID2 Else T16.WareHouseID End) As WareHouseID,T17.InventoryID,T17.CreditAccountID As InventoryAccountID,
T17.Parameter01, T17.Parameter02, T17.Parameter03, T17.Parameter04, T17.Parameter05,
isnull(Sum(isnull(T17.ActualQuantity,0)),0) As Quantity, 
isnull(Sum(isnull(T17.ConvertedAmount,0)),0) As Amount,
isnull(Sum(Case When T16.KindVoucherID = 3 Then isnull(T17.ActualQuantity,0) Else 0 End),0) As InQuantity, 
isnull(Sum(Case When T16.KindVoucherID = 3 Then isnull(T17.ConvertedAmount,0) Else 0 End),0) As InAmount   
From AT2006 T16 Inner join AT2007 T17 On T16.VoucherID = T17.VoucherID
Where KindVoucherID in (2,3,4,6,8,10,14,20)
Group by T16.DivisionID,T16.TranMonth,T16.TranYear,(Case When KindVoucherID = 3 Then T16.WareHouseID2 Else T16.WareHouseID End),InventoryID,CreditAccountID,
			T17.Parameter01, T17.Parameter02, T17.Parameter03, T17.Parameter04, T17.Parameter05) As CE
On
DE.DivisionID = CE.DivisionID 
And DE.TranMonth = CE.TranMonth 
And DE.TranYear = CE.TranYear
And DE.WareHouseID = CE.WareHouseID
And DE.InventoryID = CE.InventoryID
And DE.InventoryAccountID = CE.InventoryAccountID
And ISNULL(DE.Parameter01,0) = Isnull(CE.Parameter01,0)
And ISNULL(DE.Parameter02,0) = Isnull(CE.Parameter02,0)
And ISNULL(DE.Parameter03,0) = Isnull(CE.Parameter03,0)
And ISNULL(DE.Parameter04,0) = Isnull(CE.Parameter04,0)
And ISNULL(DE.Parameter05,0) = Isnull(CE.Parameter05,0)

GO


