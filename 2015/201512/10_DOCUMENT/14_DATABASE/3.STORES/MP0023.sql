
/****** Object:  StoredProcedure [dbo].[MP0023]    Script Date: 07/29/2010 17:17:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




---- Create by: Dang Le Bao Quynh; Date: 19/11/2008
---- Purpose: Chiet tinh gia thanh theo quy trinh
---- Edit by: Dang Le Bao Quynh; Date: 14/11/2009
---- Purpose: Cai tien chiet tinh gia thanh theo quy trinh cho phep mot cong doan SX duoc chuyen tu nhieu cong doan truoc

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER Proc [dbo].[MP0023]
	@DivisionID as nvarchar(50), 
	@PeriodID as nvarchar(50),
	@ProductID as nvarchar(50),  --- Bien co dinh san pham.
	@QuantityUnit as decimal(28,8),
	@ProductID1 as nvarchar(50)
	

	
As
Declare @NextPeriodID as nvarchar(50),
	@curNext as cursor,
	@curPeriodNext as cursor,
	@QuantityUnit1 as decimal(28,8),
	@ProductID2 as nvarchar(50)
	--,
---	@ProductID1 as nvarchar(20),
	--@QuantityUnit1 as decimal(28,8),
	---@curNext as cursor

Set @QuantityUnit = 1

	Insert MT1633 (DivisionID, PeriodID, MaterialID, ProductID, ExpenseID, MaterialTypeID, QuantityUnit, ConvertedUnit)
	Select DivisionID, PeriodID, null,  @ProductID, ExpenseID, MaterialTypeID,QuantityUnit, ConvertedUnit
	From MT4000
	Where ExpenseID in ('COST002', 'COST003')  and ProductID = @ProductID1 and PeriodID =@PeriodID and DivisionID =@DivisionID
	Order by ProductID, ExpenseID, MaterialTypeID
	
	Insert MT1633 (DivisionID, PeriodID, MaterialID, ProductID, ExpenseID,  QuantityUnit, ConvertedUnit)
	Select DivisionID, PeriodID, MaterialID, @ProductID, ExpenseID,  QuantityUnit*@QuantityUnit, ConvertedUnit*@QuantityUnit
	From MT4000 
	Where 	ExpenseID = 'COST001'   and PeriodID =@PeriodID and DivisionID =@DivisionID and ProductID =@ProductID1 and
		MaterialID  not in (Select distinct Top 100 Percent ProductID From  MT1001 inner join MT0810 on MT1001.VoucherID = MT0810.VoucherID AND MT1001.DivisionID = MT0810.DivisionID
								Where isnull(TransferPeriodID,'')=@PeriodID AND MT4000.DivisionID = @DivisionID Order by ProductID)
	

Set @curNext = cursor static for
Select ProductID, MaterialID, QuantityUnit*@QuantityUnit
From MT4000
Where 	PeriodID = @PeriodID And 
	ExpenseID = 'COST001' And 
	ProductID = @ProductID1 And 
	DivisionID = @DivisionID AND
	MaterialID in (	Select Distinct Top 100 Percent ProductID 
			From  MT1001 inner join MT0810 on MT1001.VoucherID = MT0810.VoucherID AND MT1001.DivisionID = MT0810.DivisionID
			Where isnull(TransferPeriodID,'')=@PeriodID AND MT4000.DivisionID = @DivisionID Order by ProductID)


Open @curNext

Fetch Next From @curNext Into @ProductID2, @ProductID1, @QuantityUnit1  --- Luc nay @ProductID1 mang gia tri moi
While @@Fetch_Status = 0
Begin
	Set @curPeriodNext = cursor static for
	Select distinct PeriodID From MT1001 inner join MT0810 on MT1001.VoucherID = MT0810.VoucherID AND MT1001.DivisionID = MT0810.DivisionID
				Where 	isnull(TransferPeriodID,'')=@PeriodID and 	ProductID = @ProductID1 And ProductID1 = @ProductID2 AND MT1001.DivisionID = @DivisionID
	Open @curPeriodNext
	Fetch Next From @curPeriodNext Into @NextPeriodID
	While @@Fetch_Status = 0
	Begin
		--Set @NextPeriodID = (	Select Top 1 PeriodID From MT1001 inner join MT0810 on MT1001.VoucherID = MT0810.VoucherID
		--			Where 	isnull(TransferPeriodID,'')=@PeriodID and 	ProductID = @ProductID1)
		--Print @PeriodID + '-->' + @NextPeriodID + ':' + @ProductID + '-->' + @ProductID1
		
		EXEC MP0023 @DivisionID, @NextPeriodID, @ProductID, @QuantityUnit1, @ProductID1
		Fetch Next From @curPeriodNext Into @NextPeriodID
	End
	Close @curPeriodNext
	Fetch Next From @curNext Into @ProductID2, @ProductID1, @QuantityUnit1
End

Close @curNext