/****** Object:  StoredProcedure [dbo].[AP9998]    Script Date: 07/30/2010 10:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Van Nhan, 09/08/2003
---- Xu ly ton kho khi khoa so
---- Edit by: Dang Le Bao Quynh; Date 30/07/2008
---- Purpose: Dong bo hoa du lieu tai bang AT2008
---- Modify on 24/06/2015 by Bảo Anh: Fix lỗi khóa sổ chậm (bỏ cursor khi update AT2008)
/********************************************
'* Edited by: [GS] [Thanh Trẫm] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP9998] @DivisionID nvarchar(50), 	
				@TranMonth as int, 
				@TranYear as int,
				@NextMonth as int, 
				@NextYear int
 AS


Declare @Balance_Cursor as Cursor,
	@InventoryID as nvarchar(50), 
	@WareHouseID as nvarchar(50),   
	@InventoryAccountID as nvarchar(50),  
	@ActBegQty as decimal(28, 8),   
	@ActBegTotal as decimal(28, 8) ,         
	@BookBegQty as decimal(28, 8),
	@BookBegTotal   as decimal(28, 8),
	@sSQL nvarchar(4000),
	@sSQL1 nvarchar(4000),
	@sSQL2 nvarchar(4000)
		
--Insert du lieu co phat sinh nhung khong ghi nhan vao bang AT2008
Insert Into AT2008 (DivisionID, TranMonth, TranYear, WareHouseID, InventoryID, InventoryAccountID, 
			BeginQuantity, BeginAmount, 
			DebitQuantity, DebitAmount,
			InDebitQuantity, InDebitAmount,
			CreditQuantity, CreditAmount,
			InCreditQuantity, InCreditAmount,
			EndQuantity, EndAmount
			 )
Select 	V.DivisionID, V.TranMonth, V.TranYear, V.WareHouseID, V.InventoryID, V.InventoryAccountID,
	isnull(V.BeginQuantity,0), isnull(V.BeginAmount,0), 
	isnull(V.DebitQuantity,0), isnull(V.DebitAmount,0),
	isnull(V.InDebitQuantity,0), isnull(V.InDebitAmount,0),
	isnull(V.CreditQuantity,0), isnull(V.CreditAmount,0),
	isnull(V.InCreditQuantity,0), isnull(V.InCreditAmount,0),
	isnull(V.BeginQuantity,0) + isnull(V.DebitQuantity,0) - isnull(V.CreditQuantity,0),
	isnull(V.BeginAmount,0) + isnull(V.DebitAmount,0) - isnull(V.CreditAmount,0)
From AT2008  A  Right Join  AV2222  V
On 	A.DivisionID = V.DivisionID And
	A.WareHouseID = V.WareHouseID And
	A.InventoryID = V.InventoryID And
	A.InventoryAccountID = V.InventoryAccountID And
	A.TranMonth = V.TranMonth And
	A.TranYear = V.TranYear
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
Delete AT2008
From AT2008 A Left Join AV2222 V
On 	A.DivisionID = V.DivisionID And
	A.WareHouseID = V.WareHouseID And
	A.InventoryID = V.InventoryID And
	A.InventoryAccountID = V.InventoryAccountID 
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
From AT2008 A Left Join AV2222 V
On 	A.DivisionID = V.DivisionID And
	A.WareHouseID = V.WareHouseID And
	A.InventoryID = V.InventoryID And
	A.InventoryAccountID = V.InventoryAccountID And
	A.TranMonth = V.TranMonth And
	A.TranYear = V.TranYear
Where 
	A.DivisionID = @DivisionID And
	A.TranMonth = @TranMonth And
	A.TranYear = @TranYear

/*
Set @Balance_Cursor = Cursor Scroll KeySet  FOR 


	Select	 InventoryID, WareHouseID,   InventoryAccountID, 
		EndQuantity,   EndAmount 
	From	AT2008 
	Where 		TranMonth = @TranMonth And 
			 TranYear = @TranYear And  
			DivisionID = @DivisionID

	Open	@Balance_Cursor

	Fetch Next From @Balance_Cursor Into @InventoryID, @WareHouseID,    @InventoryAccountID, 
		@ActBegQty,   @ActBegTotal 
	While @@Fetch_Status = 0
	Begin
	
		IF  exists (Select 1 From AT2008  Where TranMonth = @NextMonth and
							TranYear = @NextYear and
							DivisionID = @DivisionID and
							InventoryID = @InventoryID and
							WareHouseID =@WareHouseID and
							InventoryAccountID =  @InventoryAccountID)
		   
			   Update  AT2008 
				Set 	BeginQuantity = @ActBegQty,
					BeginAmount = @ActBegTotal,
					EndQuantity =@ActBegQty + DebitQuantity - CreditQuantity,
					EndAmount = @ActBegTotal + DebitAmount - CreditAmount 				
				 Where TranMonth = @NextMonth and
					TranYear = @NextYear and
					DivisionID = @DivisionID and
					InventoryID = @InventoryID and
					WareHouseID =@WareHouseID and
					InventoryAccountID =  @InventoryAccountID
		
		else
		
		
			Insert 	AT2008 	(InventoryID,WarehouseID,TranMonth,TranYear,DivisionID, 
						BeginQuantity, BeginAmount, EndQuantity, EndAmount, 
						DebitQuantity, DebitAmount, CreditQuantity, CreditAmount,InDebitQuantity, InDebitAmount, InCreditQuantity,InCreditAmount,
						 InventoryAccountID)
			Values (@InventoryID,@WareHouseID,@NextMonth,@NextYear,@DivisionID, 
				@ActBegQty, @ActBegTotal, @ActBegQty, @ActBegTotal,  
				0,0,0,0,0,0,0,0,	  
				@InventoryAccountID)	
		Fetch Next From @Balance_Cursor Into @InventoryID, @WareHouseID,    @InventoryAccountID, 
		@ActBegQty,   @ActBegTotal 
	End
	
	Close @Balance_Cursor
	DEALLOCATE @Balance_Cursor
*/
------------------------------------------------------------------------------------
 Update  AT2008 
Set  BeginQuantity = T08.EndQuantity,
 BeginAmount = T08.EndAmount,
 EndQuantity =T08.EndQuantity + AT2008.DebitQuantity - AT2008.CreditQuantity,
 EndAmount = T08.EndAmount + AT2008.DebitAmount - AT2008.CreditAmount     
From  AT2008 
Inner Join (Select InventoryID, WareHouseID,   InventoryAccountID, EndQuantity, EndAmount  From AT2008 Where DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear) T08
On AT2008.InventoryID = T08.InventoryID And AT2008.WareHouseID = T08.WareHouseID And AT2008.InventoryAccountID = T08.InventoryAccountID
Where AT2008.TranMonth = @NextMonth and
 AT2008.TranYear = @NextYear and
 AT2008.DivisionID = @DivisionID
 
 Insert  AT2008  (InventoryID,WarehouseID,TranMonth,TranYear,DivisionID, 
     BeginQuantity, BeginAmount, EndQuantity, EndAmount, 
     DebitQuantity, DebitAmount, CreditQuantity, CreditAmount,InDebitQuantity, InDebitAmount, InCreditQuantity,InCreditAmount,
      InventoryAccountID)
Select T08.InventoryID,T08.WareHouseID,@NextMonth,@NextYear,@DivisionID, 
   T08.EndQuantity, T08.EndAmount, T08.EndQuantity, T08.EndAmount,  
   0,0,0,0,0,0,0,0,   
   T08.InventoryAccountID
From AT2008 T08
Where T08.DivisionID = @DivisionID And T08.TranMonth = @TranMonth And T08.TranYear = @TranYear
And 
 Isnull((Select top 1 1 From AT2008 Where DivisionID = @DivisionID And TranMonth = @NextMonth And TranYear = @NextYear
 And InventoryID = T08.InventoryID And WareHouseID = T08.WareHouseID And InventoryAccountID = T08.InventoryAccountID
 ),0) = 0


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON