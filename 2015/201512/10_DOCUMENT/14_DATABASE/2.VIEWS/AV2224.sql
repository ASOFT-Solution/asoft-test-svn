/****** Object:  View [dbo].[AV2223]    Script Date: 04/11/2015 ******/
IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV2224]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV2224]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- View chet: Lấy danh sách phát sinh liên quan tồn kho.
--- Create by Tiểu Mai, Date: 04/11/2015

CREATE VIEW [dbo].[AV2224] as
Select  (Case When DE.DivisionID is Null Then CE.DivisionID Else DE.DivisionID End) As DivisionID,
	 (Case When DE.TranMonth is Null Then CE.TranMonth Else DE.TranMonth End) As TranMonth,
	 (Case When DE.TranYear is Null Then CE.TranYear Else DE.TranYear End) As TranYear,
	 (Case When DE.WareHouseID is Null Then CE.WareHouseID Else DE.WareHouseID End) As WareHouseID,
	 (Case When DE.InventoryID is Null Then CE.InventoryID Else DE.InventoryID End) As InventoryID,
	 (Case When DE.InventoryAccountID is Null Then CE.InventoryAccountID Else DE.InventoryAccountID End) As InventoryAccountID,
	 BeginQuantity, 
	 BeginAmount, 
	 DebitQuantity, 
	 DebitAmount,
	 InDebitQuantity,
	 InDebitAmount,	
	 CE.Quantity As CreditQuantity,
	 CE.Amount As CreditAmount,
	 CE.InQuantity As InCreditQuantity,
	 CE.InAmount As InCreditAmount,
	 CE.S01ID, CE.S02ID, CE.S03ID, CE.S04ID, CE.S05ID, CE.S06ID, CE.S07ID, CE.S08ID, CE.S09ID, CE.S10ID, CE.S11ID, CE.S12ID, CE.S13ID,
	 CE.S14ID, CE.S15ID, CE.S16ID, CE.S17ID, CE.S18ID, CE.S19ID, CE.S20ID	
	
From
--Nhap + So du
(Select  (Case When BE.DivisionID is Null Then DE.DivisionID Else BE.DivisionID End) As DivisionID,
	(Case When BE.TranMonth is Null Then DE.TranMonth Else BE.TranMonth End) As TranMonth,
	(Case When BE.TranYear is Null Then DE.TranYear Else BE.TranYear End) As TranYear,
	(Case When BE.WareHouseID is Null Then DE.WareHouseID Else BE.WareHouseID End) As WareHouseID,
	(Case When BE.InventoryID is Null Then DE.InventoryID Else BE.InventoryID End) As InventoryID,
	(Case When BE.InventoryAccountID is Null Then DE.InventoryAccountID Else BE.InventoryAccountID End) As InventoryAccountID,
	BE.Quantity As BeginQuantity, 
	BE.Amount As BeginAmount, 
	DE.Quantity As DebitQuantity, 
	DE.Amount As DebitAmount,
	DE.InQuantity As InDebitQuantity,
	DE.InAmount As InDebitAmount,
	BE.S01ID,BE.S02ID,BE.S03ID,BE.S04ID,BE.S05ID,BE.S06ID,BE.S07ID,BE.S08ID,BE.S09ID,BE.S10ID,BE.S11ID,BE.S12ID,BE.S13ID,BE.S14ID,BE.S15ID,BE.S16ID,BE.S17ID,BE.S18ID,BE.S19ID,BE.S20ID
From
--So du dau
(Select T16.DivisionID,T16.TranMonth,T16.TranYear,T16.WareHouseID,T17.InventoryID,T17.DebitAccountID As InventoryAccountID,
isnull(Sum(isnull(T17.ActualQuantity,0)),0) As Quantity, 
isnull(Sum(isnull(T17.ConvertedAmount,0)),0) As Amount,
O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID 
From AT2016 T16 Inner join AT2017 T17 On T16.VoucherID = T17.VoucherID and T16.DivisionID = T17.DivisionID
LEFT JOIN WT8899 O99 ON O99.DivisionID = T17.DivisionID AND O99.VoucherID = T17.VoucherID AND O99.TransactionID = T17.TransactionID
Group by T16.DivisionID,T16.TranMonth,T16.TranYear,WareHouseID,InventoryID,DebitAccountID,
O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID) As BE
Full Join
--Nhap kho
(Select T16.DivisionID,T16.TranMonth,T16.TranYear,T16.WareHouseID,T17.InventoryID,T17.DebitAccountID As InventoryAccountID,
isnull(Sum(isnull(T17.ActualQuantity,0)),0) As Quantity, 
isnull(Sum(isnull(T17.ConvertedAmount,0)),0) As Amount,
isnull(Sum(Case When T16.KindVoucherID = 3 Then isnull(T17.ActualQuantity,0) Else 0 End),0) As InQuantity, 
isnull(Sum(Case When T16.KindVoucherID = 3 Then isnull(T17.ConvertedAmount,0) Else 0 End),0) As InAmount,
O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID  
From AT2006 T16 Inner join AT2007 T17 On T16.VoucherID = T17.VoucherID and T16.DivisionID = T17.DivisionID
LEFT JOIN WT8899 O99 ON O99.DivisionID = T17.DivisionID AND O99.VoucherID = T17.VoucherID AND O99.TransactionID = T17.TransactionID
Where KindVoucherID in (1,3,5,7,9,15,17)
Group by T16.DivisionID,T16.TranMonth,T16.TranYear,WareHouseID,InventoryID,DebitAccountID,
O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID) AS DE

On 
BE.DivisionID = DE.DivisionID 
And BE.TranMonth = DE.TranMonth 
And BE.TranYear = DE.TranYear
And BE.WareHouseID = DE.WareHouseID
And BE.InventoryID = DE.InventoryID
And BE.InventoryAccountID = DE.InventoryAccountID AND 
ISNULL(BE.S01ID,'') = ISNULL(DE.S01ID,'') AND 
ISNULL(BE.S02ID,'') = ISNULL(DE.S02ID,'') AND
ISNULL(BE.S03ID,'') = ISNULL(DE.S03ID,'') AND
ISNULL(BE.S04ID,'') = ISNULL(DE.S04ID,'') AND
ISNULL(BE.S05ID,'') = ISNULL(DE.S05ID,'') AND 
ISNULL(BE.S06ID,'') = ISNULL(DE.S06ID,'') AND
ISNULL(BE.S07ID,'') = ISNULL(DE.S07ID,'') AND
ISNULL(BE.S08ID,'') = ISNULL(DE.S08ID,'') AND
ISNULL(BE.S09ID,'') = ISNULL(DE.S09ID,'') AND
ISNULL(BE.S10ID,'') = ISNULL(DE.S10ID,'') AND
ISNULL(BE.S11ID,'') = ISNULL(DE.S11ID,'') AND 
ISNULL(BE.S12ID,'') = ISNULL(DE.S12ID,'') AND
ISNULL(BE.S13ID,'') = ISNULL(DE.S13ID,'') AND
ISNULL(BE.S14ID,'') = ISNULL(DE.S14ID,'') AND
ISNULL(BE.S15ID,'') = ISNULL(DE.S15ID,'') AND
ISNULL(BE.S16ID,'') = ISNULL(DE.S16ID,'') AND
ISNULL(BE.S17ID,'') = ISNULL(DE.S17ID,'') AND
ISNULL(BE.S18ID,'') = ISNULL(DE.S18ID,'') AND
ISNULL(BE.S19ID,'') = ISNULL(DE.S19ID,'') AND
ISNULL(BE.S20ID,'') = ISNULL(DE.S20ID,'')
) As DE

Full Join
--Xuat kho
(Select T16.DivisionID,T16.TranMonth,T16.TranYear,(Case When KindVoucherID = 3 Then T16.WareHouseID2 Else T16.WareHouseID End) As WareHouseID,T17.InventoryID,T17.CreditAccountID As InventoryAccountID,
isnull(Sum(isnull(T17.ActualQuantity,0)),0) As Quantity, 
isnull(Sum(isnull(T17.ConvertedAmount,0)),0) As Amount,
isnull(Sum(Case When T16.KindVoucherID = 3 Then isnull(T17.ActualQuantity,0) Else 0 End),0) As InQuantity, 
isnull(Sum(Case When T16.KindVoucherID = 3 Then isnull(T17.ConvertedAmount,0) Else 0 End),0) As InAmount,
O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID   
From AT2006 T16 Inner join AT2007 T17 On T16.VoucherID = T17.VoucherID and T16.DivisionID = T17.DivisionID
LEFT JOIN WT8899 O99 ON O99.DivisionID = T17.DivisionID AND O99.VoucherID = T17.VoucherID AND O99.TransactionID = T17.TransactionID
Where KindVoucherID in (2,3,4,6,8,10,14,20)
Group by T16.DivisionID,T16.TranMonth,T16.TranYear,(Case When KindVoucherID = 3 Then T16.WareHouseID2 Else T16.WareHouseID End),InventoryID,CreditAccountID,
O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID) As CE
On
DE.DivisionID = CE.DivisionID 
And DE.TranMonth = CE.TranMonth 
And DE.TranYear = CE.TranYear
And DE.WareHouseID = CE.WareHouseID
And DE.InventoryID = CE.InventoryID
And DE.InventoryAccountID = CE.InventoryAccountID AND 
ISNULL(DE.S01ID,'') = ISNULL(CE.S01ID,'') AND 
ISNULL(DE.S02ID,'') = ISNULL(CE.S02ID,'') AND
ISNULL(DE.S03ID,'') = ISNULL(CE.S03ID,'') AND
ISNULL(DE.S04ID,'') = ISNULL(CE.S04ID,'') AND
ISNULL(DE.S05ID,'') = ISNULL(CE.S05ID,'') AND 
ISNULL(DE.S06ID,'') = ISNULL(CE.S06ID,'') AND
ISNULL(DE.S07ID,'') = ISNULL(CE.S07ID,'') AND
ISNULL(DE.S08ID,'') = ISNULL(CE.S08ID,'') AND
ISNULL(DE.S09ID,'') = ISNULL(CE.S09ID,'') AND
ISNULL(DE.S10ID,'') = ISNULL(CE.S10ID,'') AND
ISNULL(DE.S11ID,'') = ISNULL(CE.S11ID,'') AND 
ISNULL(DE.S12ID,'') = ISNULL(CE.S12ID,'') AND
ISNULL(DE.S13ID,'') = ISNULL(CE.S13ID,'') AND
ISNULL(DE.S14ID,'') = ISNULL(CE.S14ID,'') AND
ISNULL(DE.S15ID,'') = ISNULL(CE.S15ID,'') AND
ISNULL(DE.S16ID,'') = ISNULL(CE.S16ID,'') AND
ISNULL(DE.S17ID,'') = ISNULL(CE.S17ID,'') AND
ISNULL(DE.S18ID,'') = ISNULL(CE.S18ID,'') AND
ISNULL(DE.S19ID,'') = ISNULL(CE.S19ID,'') AND
ISNULL(DE.S20ID,'') = ISNULL(CE.S20ID,'')

GO


