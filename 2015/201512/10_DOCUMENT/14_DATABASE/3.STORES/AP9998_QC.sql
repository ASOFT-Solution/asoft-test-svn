/****** Object:  StoredProcedure [dbo].[AP9998_QC]    Script Date: 04/11/2015 ******/
IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP9998_QC]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP9998_QC]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by Tiểu Mai, on 04/11/2015
---- Xử lý tồn kho khi khóa sổ khi quản lý theo quy cách hàng hóa.


CREATE PROCEDURE [dbo].[AP9998_QC] @DivisionID nvarchar(50), 	
				@TranMonth as int, 
				@TranYear as int,
				@NextMonth as int, 
				@NextYear int
 AS

--DECLARE @TEMP TABLE (DivisionID nvarchar(50),TranMonth INT, TranYear INT,WareHouseID nvarchar(50),InventoryID nvarchar(50),InventoryAccountID nvarchar(50),
--	Quantity decimal(28, 8), 
--	Amount decimal(28, 8),
--	InQuantity decimal(28, 8), 
--	InAmount decimal(28, 8),
--	S01ID nvarchar(50), S02ID nvarchar(50),S03ID nvarchar(50),S04ID nvarchar(50),S05ID nvarchar(50), S06ID nvarchar(50), S07ID nvarchar(50), S08ID nvarchar(50), S09ID nvarchar(50),S10ID nvarchar(50),
--	S11ID nvarchar(50), S12ID nvarchar(50), S13ID nvarchar(50), S14ID nvarchar(50), S15ID nvarchar(50), S16ID nvarchar(50), S17ID nvarchar(50),S18ID nvarchar(50),S19ID nvarchar(50),S20ID nvarchar(50))

	/* 
	--Số dư đầu
	INSERT INTO @TEMP (DivisionID, TranMonth,TranYear,WareHouseID,InventoryID,InventoryAccountID,
	Quantity, 
	Amount,
	InQuantity, 
	InAmount,
	S01ID, S02ID,S03ID,S04ID,S05ID, S06ID, S07ID, S08ID, S09ID,S10ID,
	S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID,S18ID,S19ID,S20ID)
	Select T16.DivisionID,T16.TranMonth
	,T16.TranYear,T16.WareHouseID,T17.InventoryID,T17.DebitAccountID As InventoryAccountID,
	isnull(Sum(isnull(T17.ActualQuantity,0)),0) As Quantity, 
	isnull(Sum(isnull(T17.ConvertedAmount,0)),0) As Amount,
	0, 0,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
	From AT2016 T16 Inner join AT2017 T17 On T16.VoucherID = T17.VoucherID and T16.DivisionID = T17.DivisionID
	LEFT JOIN WT8899 O99 ON O99.DivisionID = T17.DivisionID AND O99.VoucherID = T17.VoucherID AND O99.TransactionID = T17.TransactionID
	Group by T16.DivisionID,T16.TranMonth
	,T16.TranYear,WareHouseID,InventoryID,DebitAccountID,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID

	--Nhập kho
	INSERT INTO @TEMP (DivisionID, TranMonth,TranYear,WareHouseID,InventoryID,InventoryAccountID,
	Quantity, 
	Amount,
	InQuantity, 
	InAmount,
	S01ID, S02ID,S03ID,S04ID,S05ID, S06ID, S07ID, S08ID, S09ID,S10ID,
	S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID,S18ID,S19ID,S20ID)
	Select T16.DivisionID,T16.TranMonth,T16.TranYear,T16.WareHouseID,T17.InventoryID,T17.DebitAccountID As InventoryAccountID,
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
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
	
	-- Xuất kho
	INSERT INTO @TEMP (DivisionID, TranMonth,TranYear,WareHouseID,InventoryID,InventoryAccountID,
	Quantity, 
	Amount,
	InQuantity, 
	InAmount,
	S01ID, S02ID,S03ID,S04ID,S05ID, S06ID, S07ID, S08ID, S09ID,S10ID,
	S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID,S18ID,S19ID,S20ID)
	Select T16.DivisionID,T16.TranMonth,T16.TranYear,(Case When KindVoucherID = 3 Then T16.WareHouseID2 Else T16.WareHouseID End) As WareHouseID,T17.InventoryID,T17.CreditAccountID As InventoryAccountID,
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
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
	
	*/	
--Insert du lieu co phat sinh nhung khong ghi nhan vao bang AT2008

Insert Into AT2008_QC (DivisionID, TranMonth, TranYear, WareHouseID, InventoryID, InventoryAccountID, 
			BeginQuantity, BeginAmount, 
			DebitQuantity, DebitAmount,
			InDebitQuantity, InDebitAmount,
			CreditQuantity, CreditAmount,
			InCreditQuantity, InCreditAmount,
			EndQuantity, EndAmount, S01ID, S02ID,S03ID,S04ID,S05ID, S06ID, S07ID, S08ID, S09ID,S10ID,
			S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID,S18ID,S19ID,S20ID)
Select 	V.DivisionID, V.TranMonth, V.TranYear, V.WareHouseID, V.InventoryID, V.InventoryAccountID,
	isnull(V.BeginQuantity,0), isnull(V.BeginAmount,0), 
	isnull(V.DebitQuantity,0), isnull(V.DebitAmount,0),
	isnull(V.InDebitQuantity,0), isnull(V.InDebitAmount,0),
	isnull(V.CreditQuantity,0), isnull(V.CreditAmount,0),
	isnull(V.InCreditQuantity,0), isnull(V.InCreditAmount,0),
	isnull(V.BeginQuantity,0) + isnull(V.DebitQuantity,0) - isnull(V.CreditQuantity,0),
	isnull(V.BeginAmount,0) + isnull(V.DebitAmount,0) - isnull(V.CreditAmount,0), A.S01ID, A.S02ID,A.S03ID,A.S04ID,A.S05ID, A.S06ID, A.S07ID, A.S08ID, A.S09ID, A.S10ID,
			A.S11ID, A.S12ID, A.S13ID, A.S14ID, A.S15ID, A.S16ID, A.S17ID, A.S18ID, A.S19ID, A.S20ID
From AT2008_QC  A  Right Join  AV2224 V
On 	A.DivisionID = V.DivisionID And
	A.WareHouseID = V.WareHouseID And
	A.InventoryID = V.InventoryID And
	A.InventoryAccountID = V.InventoryAccountID And
	A.TranMonth = V.TranMonth And
	A.TranYear = V.TranYear AND 
	ISNULL(A.S01ID,'') = ISNULL(V.S01ID,'') AND 
	ISNULL(A.S02ID,'') = ISNULL(V.S02ID,'') AND
	ISNULL(A.S03ID,'') = ISNULL(V.S03ID,'') AND
	ISNULL(A.S04ID,'') = ISNULL(V.S04ID,'') AND
	ISNULL(A.S05ID,'') = ISNULL(V.S05ID,'') AND 
	ISNULL(A.S06ID,'') = ISNULL(V.S06ID,'') AND
	ISNULL(A.S07ID,'') = ISNULL(V.S07ID,'') AND
	ISNULL(A.S08ID,'') = ISNULL(V.S08ID,'') AND
	ISNULL(A.S09ID,'') = ISNULL(V.S09ID,'') AND
	ISNULL(A.S10ID,'') = ISNULL(V.S10ID,'') AND
	ISNULL(A.S11ID,'') = ISNULL(V.S11ID,'') AND 
	ISNULL(A.S12ID,'') = ISNULL(V.S12ID,'') AND
	ISNULL(A.S13ID,'') = ISNULL(V.S13ID,'') AND
	ISNULL(A.S14ID,'') = ISNULL(V.S14ID,'') AND
	ISNULL(A.S15ID,'') = ISNULL(V.S15ID,'') AND
	ISNULL(A.S16ID,'') = ISNULL(V.S16ID,'') AND
	ISNULL(A.S17ID,'') = ISNULL(V.S17ID,'') AND
	ISNULL(A.S18ID,'') = ISNULL(V.S18ID,'') AND
	ISNULL(A.S19ID,'') = ISNULL(V.S19ID,'') AND
	ISNULL(A.S20ID,'') = ISNULL(V.S20ID,'')
Where 	A.DivisionID is null And
	A.WareHouseID is null And
	A.InventoryID is null And
	A.InventoryAccountID is null And
	A.TranMonth is null And
	A.TranYear is null And
	V.DivisionID = @DivisionID And
	V.TranMonth = @TranMonth And
	V.TranYear = @TranYear

--Xoa Du lieu rac
Delete AT2008_QC
From AT2008_QC A Left Join AV2224 V
On 	A.DivisionID = V.DivisionID And
	A.WareHouseID = V.WareHouseID And
	A.InventoryID = V.InventoryID And
	A.InventoryAccountID = V.InventoryAccountID AND 
	ISNULL(A.S01ID,'') = ISNULL(V.S01ID,'') AND 
	ISNULL(A.S02ID,'') = ISNULL(V.S02ID,'') AND
	ISNULL(A.S03ID,'') = ISNULL(V.S03ID,'') AND
	ISNULL(A.S04ID,'') = ISNULL(V.S04ID,'') AND
	ISNULL(A.S05ID,'') = ISNULL(V.S05ID,'') AND 
	ISNULL(A.S06ID,'') = ISNULL(V.S06ID,'') AND
	ISNULL(A.S07ID,'') = ISNULL(V.S07ID,'') AND
	ISNULL(A.S08ID,'') = ISNULL(V.S08ID,'') AND
	ISNULL(A.S09ID,'') = ISNULL(V.S09ID,'') AND
	ISNULL(A.S10ID,'') = ISNULL(V.S10ID,'') AND
	ISNULL(A.S11ID,'') = ISNULL(V.S11ID,'') AND 
	ISNULL(A.S12ID,'') = ISNULL(V.S12ID,'') AND
	ISNULL(A.S13ID,'') = ISNULL(V.S13ID,'') AND
	ISNULL(A.S14ID,'') = ISNULL(V.S14ID,'') AND
	ISNULL(A.S15ID,'') = ISNULL(V.S15ID,'') AND
	ISNULL(A.S16ID,'') = ISNULL(V.S16ID,'') AND
	ISNULL(A.S17ID,'') = ISNULL(V.S17ID,'') AND
	ISNULL(A.S18ID,'') = ISNULL(V.S18ID,'') AND
	ISNULL(A.S19ID,'') = ISNULL(V.S19ID,'') AND
	ISNULL(A.S20ID,'') = ISNULL(V.S20ID,'')
Where 	V.DivisionID is null And
	V.WareHouseID is null And
	V.InventoryID is null And
	V.InventoryAccountID is null And
	V.TranMonth + V.TranYear*12 <= @TranMonth + @TranYear*12 And
	A.TranMonth + A.TranYear*12 <= @TranMonth + @TranYear*12

--Cap Nhat Ton Kho Tong Hop
Update A Set 
A.DebitQuantity = isnull(V.DebitQuantity,0),
A.DebitAmount = isnull(V.DebitAmount,0),
A.InDebitQuantity = isnull(V.InDebitQuantity,0),
A.InDebitAmount = isnull(V.InDebitAmount,0),
A.CreditQuantity = isnull(V.CreditQuantity,0),
A.CreditAmount = isnull(V.CreditAmount,0),
A.InCreditQuantity = isnull(V.InCreditQuantity,0),
A.InCreditAmount = isnull(V.InCreditAmount,0),
A.EndQuantity = isnull(A.BeginQuantity,0) + isnull(V.DebitQuantity,0) - isnull(V.CreditQuantity,0),
A.EndAmount = isnull(A.BeginAmount,0) + isnull(V.DebitAmount,0) - isnull(V.CreditAmount,0)
From AT2008_QC A Left Join AV2224 V
On 	A.DivisionID = V.DivisionID And
	A.WareHouseID = V.WareHouseID And
	A.InventoryID = V.InventoryID And
	A.InventoryAccountID = V.InventoryAccountID And
	A.TranMonth = V.TranMonth And
	A.TranYear = V.TranYear AND 
	ISNULL(A.S01ID,'') = ISNULL(V.S01ID,'') AND 
	ISNULL(A.S02ID,'') = ISNULL(V.S02ID,'') AND
	ISNULL(A.S03ID,'') = ISNULL(V.S03ID,'') AND
	ISNULL(A.S04ID,'') = ISNULL(V.S04ID,'') AND
	ISNULL(A.S05ID,'') = ISNULL(V.S05ID,'') AND 
	ISNULL(A.S06ID,'') = ISNULL(V.S06ID,'') AND
	ISNULL(A.S07ID,'') = ISNULL(V.S07ID,'') AND
	ISNULL(A.S08ID,'') = ISNULL(V.S08ID,'') AND
	ISNULL(A.S09ID,'') = ISNULL(V.S09ID,'') AND
	ISNULL(A.S10ID,'') = ISNULL(V.S10ID,'') AND
	ISNULL(A.S11ID,'') = ISNULL(V.S11ID,'') AND 
	ISNULL(A.S12ID,'') = ISNULL(V.S12ID,'') AND
	ISNULL(A.S13ID,'') = ISNULL(V.S13ID,'') AND
	ISNULL(A.S14ID,'') = ISNULL(V.S14ID,'') AND
	ISNULL(A.S15ID,'') = ISNULL(V.S15ID,'') AND
	ISNULL(A.S16ID,'') = ISNULL(V.S16ID,'') AND
	ISNULL(A.S17ID,'') = ISNULL(V.S17ID,'') AND
	ISNULL(A.S18ID,'') = ISNULL(V.S18ID,'') AND
	ISNULL(A.S19ID,'') = ISNULL(V.S19ID,'') AND
	ISNULL(A.S20ID,'') = ISNULL(V.S20ID,'')
Where 
	A.DivisionID = @DivisionID And
	A.TranMonth = @TranMonth And
	A.TranYear = @TranYear

 Update  AT2008_QC
Set  BeginQuantity = T08.EndQuantity,
 BeginAmount = T08.EndAmount,
 EndQuantity =T08.EndQuantity + AT2008_QC.DebitQuantity - AT2008_QC.CreditQuantity,
 EndAmount = T08.EndAmount + AT2008_QC.DebitAmount - AT2008_QC.CreditAmount     
From  AT2008_QC
Inner Join (Select InventoryID, WareHouseID,   InventoryAccountID, EndQuantity, EndAmount, S01ID, S02ID,S03ID,S04ID,S05ID, S06ID, S07ID, S08ID, S09ID,S10ID,
			S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID,S18ID,S19ID,S20ID  From AT2008_QC Where DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear) T08
On AT2008_QC.InventoryID = T08.InventoryID And AT2008_QC.WareHouseID = T08.WareHouseID And AT2008_QC.InventoryAccountID = T08.InventoryAccountID AND 
ISNULL(AT2008_QC.S01ID,'') = ISNULL(T08.S01ID,'') AND 
ISNULL(AT2008_QC.S02ID,'') = ISNULL(T08.S02ID,'') AND
ISNULL(AT2008_QC.S03ID,'') = ISNULL(T08.S03ID,'') AND
ISNULL(AT2008_QC.S04ID,'') = ISNULL(T08.S04ID,'') AND
ISNULL(AT2008_QC.S05ID,'') = ISNULL(T08.S05ID,'') AND 
ISNULL(AT2008_QC.S06ID,'') = ISNULL(T08.S06ID,'') AND
ISNULL(AT2008_QC.S07ID,'') = ISNULL(T08.S07ID,'') AND
ISNULL(AT2008_QC.S08ID,'') = ISNULL(T08.S08ID,'') AND
ISNULL(AT2008_QC.S09ID,'') = ISNULL(T08.S09ID,'') AND
ISNULL(AT2008_QC.S10ID,'') = ISNULL(T08.S10ID,'') AND
ISNULL(AT2008_QC.S11ID,'') = ISNULL(T08.S11ID,'') AND 
ISNULL(AT2008_QC.S12ID,'') = ISNULL(T08.S12ID,'') AND
ISNULL(AT2008_QC.S13ID,'') = ISNULL(T08.S13ID,'') AND
ISNULL(AT2008_QC.S14ID,'') = ISNULL(T08.S14ID,'') AND
ISNULL(AT2008_QC.S15ID,'') = ISNULL(T08.S15ID,'') AND
ISNULL(AT2008_QC.S16ID,'') = ISNULL(T08.S16ID,'') AND
ISNULL(AT2008_QC.S17ID,'') = ISNULL(T08.S17ID,'') AND
ISNULL(AT2008_QC.S18ID,'') = ISNULL(T08.S18ID,'') AND
ISNULL(AT2008_QC.S19ID,'') = ISNULL(T08.S19ID,'') AND
ISNULL(AT2008_QC.S20ID,'') = ISNULL(T08.S20ID,'')
Where AT2008_QC.TranMonth = @NextMonth and
 AT2008_QC.TranYear = @NextYear and
 AT2008_QC.DivisionID = @DivisionID
 
 Insert  AT2008_QC  (InventoryID,WarehouseID,TranMonth,TranYear,DivisionID, 
     BeginQuantity, BeginAmount, EndQuantity, EndAmount, 
     DebitQuantity, DebitAmount, CreditQuantity, CreditAmount,InDebitQuantity, InDebitAmount, InCreditQuantity,InCreditAmount,
      InventoryAccountID, S01ID, S02ID,S03ID,S04ID,S05ID, S06ID, S07ID, S08ID, S09ID,S10ID,
							S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID,S18ID,S19ID,S20ID)
Select T08.InventoryID,T08.WareHouseID,@NextMonth,@NextYear,@DivisionID, 
   T08.EndQuantity, T08.EndAmount, T08.EndQuantity, T08.EndAmount,  
   0,0,0,0,0,0,0,0,   
   T08.InventoryAccountID,T08.S01ID, T08.S02ID, T08.S03ID, T08.S04ID, T08.S05ID, T08.S06ID, T08.S07ID, T08.S08ID, T08.S09ID, T08.S10ID,
   T08.S11ID, T08.S12ID, T08.S13ID, T08.S14ID, T08.S15ID, T08.S16ID, T08.S17ID, T08.S18ID, T08.S19ID, T08.S20ID 
From AT2008_QC T08
Where T08.DivisionID = @DivisionID And T08.TranMonth = @TranMonth And T08.TranYear = @TranYear
And 
	Isnull((Select top 1 1 From AT2008_QC Where DivisionID = @DivisionID And TranMonth = @NextMonth And TranYear = @NextYear
	And InventoryID = T08.InventoryID And WareHouseID = T08.WareHouseID And InventoryAccountID = T08.InventoryAccountID AND
	ISNULL(AT2008_QC.S01ID,'') = ISNULL(T08.S01ID,'') AND 
	ISNULL(AT2008_QC.S02ID,'') = ISNULL(T08.S02ID,'') AND
	ISNULL(AT2008_QC.S03ID,'') = ISNULL(T08.S03ID,'') AND
	ISNULL(AT2008_QC.S04ID,'') = ISNULL(T08.S04ID,'') AND
	ISNULL(AT2008_QC.S05ID,'') = ISNULL(T08.S05ID,'') AND 
	ISNULL(AT2008_QC.S06ID,'') = ISNULL(T08.S06ID,'') AND
	ISNULL(AT2008_QC.S07ID,'') = ISNULL(T08.S07ID,'') AND
	ISNULL(AT2008_QC.S08ID,'') = ISNULL(T08.S08ID,'') AND
	ISNULL(AT2008_QC.S09ID,'') = ISNULL(T08.S09ID,'') AND
	ISNULL(AT2008_QC.S10ID,'') = ISNULL(T08.S10ID,'') AND
	ISNULL(AT2008_QC.S11ID,'') = ISNULL(T08.S11ID,'') AND 
	ISNULL(AT2008_QC.S12ID,'') = ISNULL(T08.S12ID,'') AND
	ISNULL(AT2008_QC.S13ID,'') = ISNULL(T08.S13ID,'') AND
	ISNULL(AT2008_QC.S14ID,'') = ISNULL(T08.S14ID,'') AND
	ISNULL(AT2008_QC.S15ID,'') = ISNULL(T08.S15ID,'') AND
	ISNULL(AT2008_QC.S16ID,'') = ISNULL(T08.S16ID,'') AND
	ISNULL(AT2008_QC.S17ID,'') = ISNULL(T08.S17ID,'') AND
	ISNULL(AT2008_QC.S18ID,'') = ISNULL(T08.S18ID,'') AND
	ISNULL(AT2008_QC.S19ID,'') = ISNULL(T08.S19ID,'') AND
	ISNULL(AT2008_QC.S20ID,'') = ISNULL(T08.S20ID,'')
 ),0) = 0


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON