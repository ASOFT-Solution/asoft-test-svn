IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP9990]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP9990]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bao Anh	Date: 16/09/2012
--- Purpose: Cap nhat so du ton kho theo quy cach khi khoa so (2T)
--- Modify on 17/04/2013 by Bao Anh: Bo sung xet Isnull cho Parameter01 -> 05 trong cac cau join

CREATE PROCEDURE [dbo].[AP9990] @DivisionID nvarchar(50), 	
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
	@Parameter01 as decimal(28,8),
	@Parameter02 as decimal(28,8),
	@Parameter03 as decimal(28,8),
	@Parameter04 as decimal(28,8),
	@Parameter05 as decimal(28,8)

--Insert du lieu co phat sinh nhung khong ghi nhan vao bang AT2888
Insert Into AT2888 (DivisionID, TranMonth, TranYear, WareHouseID, InventoryID, InventoryAccountID,
			Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
			BeginQuantity, BeginAmount, 
			DebitQuantity, DebitAmount,
			InDebitQuantity, InDebitAmount,
			CreditQuantity, CreditAmount,
			InCreditQuantity, InCreditAmount,
			EndQuantity, EndAmount
			 )
Select 	V.DivisionID, V.TranMonth, V.TranYear, V.WareHouseID, V.InventoryID, V.InventoryAccountID,
	V.Parameter01, V.Parameter02, V.Parameter03, V.Parameter04, V.Parameter05,
	isnull(V.BeginQuantity,0), isnull(V.BeginAmount,0),
	isnull(V.DebitQuantity,0), isnull(V.DebitAmount,0),
	isnull(V.InDebitQuantity,0), isnull(V.InDebitAmount,0),
	isnull(V.CreditQuantity,0), isnull(V.CreditAmount,0),
	isnull(V.InCreditQuantity,0), isnull(V.InCreditAmount,0),
	isnull(V.BeginQuantity,0) + isnull(V.DebitQuantity,0) - isnull(V.CreditQuantity,0),
	isnull(V.BeginAmount,0) + isnull(V.DebitAmount,0) - isnull(V.CreditAmount,0)
From AT2888 A Right Join AV2223 V
On 	A.DivisionID = V.DivisionID And
	A.WareHouseID = V.WareHouseID And
	A.InventoryID = V.InventoryID And
	A.InventoryAccountID = V.InventoryAccountID And
	Isnull(A.Parameter01,0) = Isnull(V.Parameter01,0) And
	Isnull(A.Parameter02,0) = Isnull(V.Parameter02,0) And
	Isnull(A.Parameter03,0) = Isnull(V.Parameter03,0) And
	Isnull(A.Parameter04,0) = Isnull(V.Parameter04,0) And
	Isnull(A.Parameter05,0) = Isnull(V.Parameter05,0) And
	A.TranMonth = V.TranMonth And
	A.TranYear = V.TranYear
Where 	A.DivisionID is null And
	A.WareHouseID is null And
	A.InventoryID is null And
	A.InventoryAccountID is null And
	A.Parameter01 is null and
	A.Parameter02 is null and
	A.Parameter03 is null and
	A.Parameter04 is null and
	A.Parameter05 is null and
	A.TranMonth is null And
	A.TranYear is null And
	V.DivisionID = @DivisionID And
	V.TranMonth = @TranMonth And
	V.TranYear = @TranYear

--Xoa Du lieu rac
Delete AT2888
From AT2888 A Left Join AV2223 V
On 	A.DivisionID = V.DivisionID And
	A.WareHouseID = V.WareHouseID And
	A.InventoryID = V.InventoryID And
	A.InventoryAccountID = V.InventoryAccountID And
	Isnull(A.Parameter01,0) = Isnull(V.Parameter01,0) And
	Isnull(A.Parameter02,0) = Isnull(V.Parameter02,0) And
	Isnull(A.Parameter03,0) = Isnull(V.Parameter03,0) And
	Isnull(A.Parameter04,0) = Isnull(V.Parameter04,0) And
	Isnull(A.Parameter05,0) = Isnull(V.Parameter05,0)
Where 	V.DivisionID is null And
	V.WareHouseID is null And
	V.InventoryID is null And
	V.InventoryAccountID is null And
	V.Parameter01 is null and
	V.Parameter02 is null and
	V.Parameter03 is null and
	V.Parameter04 is null and
	V.Parameter05 is null and
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
From AT2888 A Left Join AV2223 V
On 	A.DivisionID = V.DivisionID And
	A.WareHouseID = V.WareHouseID And
	A.InventoryID = V.InventoryID And
	A.InventoryAccountID = V.InventoryAccountID And
	Isnull(A.Parameter01,0) = Isnull(V.Parameter01,0) And
	Isnull(A.Parameter02,0) = Isnull(V.Parameter02,0) And
	Isnull(A.Parameter03,0) = Isnull(V.Parameter03,0) And
	Isnull(A.Parameter04,0) = Isnull(V.Parameter04,0) And
	Isnull(A.Parameter05,0) = Isnull(V.Parameter05,0) And
	A.TranMonth = V.TranMonth And
	A.TranYear = V.TranYear
Where 
	A.DivisionID = @DivisionID And
	A.TranMonth = @TranMonth And
	A.TranYear = @TranYear



Set @Balance_Cursor = Cursor Scroll KeySet FOR 
	Select	 InventoryID, WareHouseID, InventoryAccountID, Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
		EndQuantity,   EndAmount
	From	AT2888
	Where 		TranMonth = @TranMonth And 
			 TranYear = @TranYear And  
			DivisionID = @DivisionID

	Open	@Balance_Cursor

	Fetch Next From @Balance_Cursor Into @InventoryID, @WareHouseID, @InventoryAccountID, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05,
		@ActBegQty,   @ActBegTotal
	While @@Fetch_Status = 0
	Begin
		IF  exists (Select 1 From AT2888 Where TranMonth = @NextMonth and
							TranYear = @NextYear and
							DivisionID = @DivisionID and
							InventoryID = @InventoryID and
							WareHouseID =@WareHouseID and
							InventoryAccountID =  @InventoryAccountID and
							Isnull(Parameter01,0) = Isnull(@Parameter01,0) and
							Isnull(Parameter02,0) = Isnull(@Parameter02,0) and
							Isnull(Parameter03,0) = Isnull(@Parameter03,0) and
							Isnull(Parameter04,0) = Isnull(@Parameter04,0) and
							Isnull(Parameter05,0) = Isnull(@Parameter05,0))
		   Update  AT2888 
			Set 	BeginQuantity = @ActBegQty,
				BeginAmount = @ActBegTotal,
				EndQuantity =@ActBegQty + DebitQuantity - CreditQuantity,
				EndAmount = @ActBegTotal + DebitAmount - CreditAmount 				
			 Where TranMonth = @NextMonth and
				TranYear = @NextYear and
				DivisionID = @DivisionID and
				InventoryID = @InventoryID and
				WareHouseID =@WareHouseID and
				InventoryAccountID =  @InventoryAccountID and
				Isnull(Parameter01,0) = Isnull(@Parameter01,0) and
				Isnull(Parameter02,0) = Isnull(@Parameter02,0) and
				Isnull(Parameter03,0) = Isnull(@Parameter03,0) and
				Isnull(Parameter04,0) = Isnull(@Parameter04,0) and
				Isnull(Parameter05,0) = Isnull(@Parameter05,0)
		else
		Insert 	AT2888 	(InventoryID,WarehouseID,TranMonth,TranYear,DivisionID, 
					BeginQuantity, BeginAmount, EndQuantity, EndAmount, 
					DebitQuantity, DebitAmount, CreditQuantity, CreditAmount,InDebitQuantity, InDebitAmount, InCreditQuantity,InCreditAmount,
					 InventoryAccountID, Parameter01, Parameter02, Parameter03, Parameter04, Parameter05)
		Values (@InventoryID,@WareHouseID,@NextMonth,@NextYear,@DivisionID, 
			@ActBegQty, @ActBegTotal, @ActBegQty, @ActBegTotal,  
			0,0,0,0,0,0,0,0,	  
			@InventoryAccountID, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05)	
					
						
		Fetch Next From @Balance_Cursor Into @InventoryID, @WareHouseID, @InventoryAccountID, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05,
		@ActBegQty,   @ActBegTotal 
	End
	
	Close @Balance_Cursor