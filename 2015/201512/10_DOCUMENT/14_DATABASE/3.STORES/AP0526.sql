/****** Object:  StoredProcedure [dbo].[AP0526]    Script Date: 07/29/2010 17:23:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--Created by Nguyen Thi Ngoc Minh
--Date 22/11/2004
--Purpose: Tao view kiem tra ton cuoi khi luu, sua phieu xuat theo bo
--Edit by : Nguyen Quoc Huy
-- Last Edit : Thuy Tuyen , date 7/07/2009
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP0526]		@UserID as nvarchar(50),
					@DivisionID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int,

					@VoucherDate datetime,

					@InventoryTypeID nvarchar(50),
					@InventoryID nvarchar(50),
					@WareHouseID as nvarchar(50),
					@ApportionTable nvarchar(50),	
					@ApportionID nvarchar(50),	
					@ConversionFactor as decimal(28, 8),		

					@ReOldVoucherID as nvarchar(50),
					@ReOldTransactionID as nvarchar(50),
					@ReNewVoucherID as nvarchar(50),
					@ReNewTransactionID as nvarchar(50),

					@OldQuantity	decimal(28, 8),
					@NewQuantity	decimal(28, 8)				
AS
Declare @ApportionTable_Cur cursor,
	@ItemID as nvarchar(50),	
	@Status as int,
	@UnitID nvarchar(50),	
	@IsSource tinyint,
	@IsLimitDate tinyint,
	@CreditAccountID as nvarchar(50),

	@ItemQuantity	decimal(28, 8),
	@InventoryQuantity	decimal(28, 8),				

	@ItemOldQuantity	decimal(28, 8),
	@ItemNewQuantity	decimal(28, 8),				

	@MethodID as 	tinyint,
	@Message varchar(8000),
	@Ok as tinyint		
Set Nocount on
Set @Ok =0 
Delete AT7777 Where UserID = @UserID

---Print 'HELO' +@ApportionTable
If @ApportionTable like 'AT1326'  
Begin
	If  Isnull (@ApportionID,'') =  '' 
	Begin
	Set @ApportionTable_Cur = CURSOR SCROLL KEYSET FOR
		----Loc ra cac SP khong thuoc bo dinh muc
					
		Select AT02 .InventoryID , 0,0,  AT02.UnitID, AT02.IsSource , 
			AT02.IsLimitDate, AT02.AccountID, AT02.MethodID
		From  AT1302 AT02 
		Where AT02.InventoryID = @InventoryID and DivisionID = @DivisionID
	End
	else
	Begin

	Set @ApportionTable_Cur = CURSOR SCROLL KEYSET FOR
		--Loc ra cac NVL thuoc SP trong BDM
					
		Select AT26.ItemID, Isnull(AT26.ItemQuantity,0),Isnull(AT26.InventoryQuantity,0) , AT02.UnitID, AT02.IsSource , 
			AT02.IsLimitDate, AT02.AccountID, AT02.MethodID
		From AT1326 AT26 Left Join AT1302 AT02 on AT26.ItemID = AT02.InventoryID and AT26.DivisionID = AT02.DivisionID
		Where AT26.InventoryID = @InventoryID and AT26.KITID = @ApportionID and AT26.DivisionID = @DivisionID
	end
		Open @ApportionTable_Cur
		FETCH NEXT FROM @ApportionTable_Cur INTO @ItemID, @ItemQuantity, @InventoryQuantity,@UnitID,@IsSource ,@IsLimitDate,@CreditAccountID,@MethodID
		WHILE @@FETCH_STATUS = 0 and @OK = 0
		  Begin
			If  Isnull (@ApportionID,'') =  ''
			Begin
				set   @ItemOldQuantity =@OldQuantity
				set @ItemNewQuantity = @NewQuantity	
			End
			else
			Begin
				set @ItemOldQuantity = @ItemQuantity/@InventoryQuantity*@OldQuantity
				set @ItemNewQuantity = @ItemQuantity/@InventoryQuantity*@NewQuantity	
			End

					
			Exec AP7011 	@UserID,@DivisionID,@TranMonth, @TranYear,	@WareHouseID, @ItemID,@UnitID,@ConversionFactor,
				@IsSource ,@IsLimitDate ,@CreditAccountID ,@ReOldVoucherID ,@ReOldTransactionID,@ReNewVoucherID,
				@ReNewTransactionID,@VoucherDate , @ItemOldQuantity, @ItemNewQuantity,0,@MethodID, @OK output 

			FETCH NEXT FROM @ApportionTable_Cur INTO  @ItemID,@ItemQuantity, @InventoryQuantity,@UnitID,@IsSource ,@IsLimitDate,@CreditAccountID,@MethodID
		  End
	Close @ApportionTable_Cur
End


--Bo dinh muc AsoftM
If @ApportionTable like 'MT1603' 
Begin	
	If  Isnull (@ApportionID,'') =  '' 
	Begin
	Set @ApportionTable_Cur = CURSOR SCROLL KEYSET FOR
		--Loc ra cac SP khong thuoc bo dinh muc
					
		Select AT02 .InventoryID , 0, 0, AT02.UnitID, AT02.IsSource , 
			AT02.IsLimitDate, AT02.AccountID, AT02.MethodID
		From  AT1302 AT02 
		Where AT02.InventoryID = @InventoryID and DivisionID = @DivisionID
	End
	else
	Begin
	Set @ApportionTable_Cur = CURSOR SCROLL KEYSET FOR
		Select MaterialID, isnull(MaterialQuantity,0), isnull(ProductQuantity,0), AT02.UnitID, AT02.IsSource , 
			AT02.IsLimitDate, AT02.AccountID, AT02.MethodID
		From MT1603 MT03 Left Join AT1302 AT02 on MT03.MaterialID = AT02.InventoryID and MT03.DivisionID = AT02.DivisionID
		Where ProductID = @InventoryID and ApportionID = @ApportionID and ExpenseID = 'COST001' and MT03.DivisionID = @DivisionID
	End

		Open @ApportionTable_Cur
		FETCH NEXT FROM @ApportionTable_Cur INTO @ItemID, @ItemQuantity, @InventoryQuantity,@UnitID,@IsSource ,@IsLimitDate,@CreditAccountID,@MethodID
		WHILE @@FETCH_STATUS = 0 and @OK =0
		  Begin
			If  Isnull (@ApportionID,'') =  ''
			Begin
				set   @ItemOldQuantity =@OldQuantity
				set @ItemNewQuantity = @NewQuantity	
			End
			else
			Begin
				set @ItemOldQuantity = @ItemQuantity/@InventoryQuantity*@OldQuantity
				set @ItemNewQuantity = @ItemQuantity/@InventoryQuantity*@NewQuantity
			end
			Exec AP7011 	@UserID,@DivisionID,@TranMonth, @TranYear,	@WareHouseID, @ItemID,@UnitID,@ConversionFactor,
				@IsSource ,@IsLimitDate ,@CreditAccountID ,@ReOldVoucherID ,@ReOldTransactionID,@ReNewVoucherID,
				@ReNewTransactionID,@VoucherDate , @ItemOldQuantity, @ItemNewQuantity,0,@MethodID, @OK output  
			
		  	

			FETCH NEXT FROM @ApportionTable_Cur INTO  @ItemID,@ItemQuantity, @InventoryQuantity,@UnitID,@IsSource ,@IsLimitDate,@CreditAccountID,@MethodID
		  End

	Close @ApportionTable_Cur
End


					
ENDCHECK:

Select * from AT7777 Where UserID =@UserID and DivisionID = @DivisionID
GO
