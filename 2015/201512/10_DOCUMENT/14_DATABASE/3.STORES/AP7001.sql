/****** Object:  StoredProcedure [dbo].[AP7001]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by Nguyen Van Nhan, Date 13/06/2003
---- Purpose:  Kiem tra co duoc phep xuat kho hay khong.
---- Duoc goi khi AddNew va Edit phieu xuat kho
---- Edit by B.Anh, date 01/06/2010	Sua loi canh bao sai khi dung DVT quy doi (truoc day lay @NewQuantity * @ConversionFactor so sanh voi @EndQuantity)
---- Edit by B.Anh, date 11/06/2014	Chỉ lấy lượng tồn tính đến ngày @VoucherDate
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [01/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7001] 	@UserID as nvarchar(50),					
					@DivisionID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int,
					@WareHouseID as nvarchar(50),
					@InventoryID as  nvarchar(50),
					@UnitID as nvarchar(50),
					@ConversionFactor as Decimal(28,8),					
					@IsSource 	tinyint,
					@IsLimitDate	tinyint,
					@CreditAccountID as nvarchar(50),
					@ReOldVoucherID as nvarchar(50),
					@ReOldTransactionID as  nvarchar(50),
					@ReNewVoucherID nvarchar(50),
					@ReNewTransactionID as nvarchar(50),
					@VoucherDate as datetime,
					@OldQuantity	Decimal(28,8),
					@NewQuantity	Decimal(28,8),
					@AllowOverShip as tinyint,
					@MethodID as 	tinyint
					
 AS

Declare @EndQuantity as Decimal(28,8),
	@Message as nvarchar(250),
	@Status as tinyint,
	@IsNegativeStock as tinyint


Select  @IsNegativeStock = IsNegativeStock From WT0000  Where DefDivisionID =@DivisionID  --- Cho phep xuat kho am hay khong

Set @IsNegativeStock = isnull(@IsNegativeStock,0)

Set Nocount on
Delete AT7777 Where UserID =@UserID AND DivisionID = @DivisionID

If  @IsSource<>0 or @IsLimitDate<>0 or @MethodID = 3
	--- Xuat dich danh, theo Lo - ngay het han

		Exec AP8003 @UserID,  @DivisionID,@TranMonth,@TranYear, @WareHouseID,@InventoryID,
					@UnitID, @ConversionFactor,	@CreditAccountID,
					@ReOldVoucherID, @ReOldTransactionID, 
					@ReNewVoucherID, @ReNewTransactionID,
					@OldQuantity, @NewQuantity

Else

	Begin
	/*
		Set @EndQuantity =@OldQuantity + Isnull( (Select EndQuantity From AT2008 Where DivisionID =@DivisionID and
										TranMOnth =@TranMonth and
										TranYear =@TranYear and
										InventoryID =@InventoryID and 
										InventoryAccountID = @CreditAccountID and
										WareHouseID =@WareHouseID), 0)
	*/
		Set @EndQuantity =@OldQuantity + Isnull((Select SUM(SignQuantity) From AV7000 Where DivisionID = @DivisionID											
											and InventoryID =@InventoryID 
											and InventoryAccountID = @CreditAccountID
											and WareHouseID =@WareHouseID
											and VoucherDate <= @VoucherDate),0)
		
	If @NewQuantity > @EndQuantity and  @IsNegativeStock=0 
		Begin
			Set @Status =1
			Set @Message =N'WFML000132'
            Insert AT7777 (UserID, Status, Message, DivisionID, Value1, Value2)
			Values (@UserID, @Status, @Message, @DivisionID,@InventoryID,@WareHouseID )
		End
	else If @NewQuantity > @EndQuantity and  @IsNegativeStock=1
		Begin
			Set @Status =2
			Set @Message =N'WFML000133'
            Insert AT7777 (UserID, Status, Message, DivisionID, Value1, Value2)
			Values (@UserID, @Status, @Message, @DivisionID,@InventoryID,@WareHouseID )
		End		
	Else
		Begin
			Set @Status =0 
			Set @Message =''
            Insert AT7777 (UserID, Status, Message, DivisionID)
			Values (@UserID, @Status, @Message, @DivisionID)
		End
	
		

	End			

Set Nocount off
Select * from AT7777 Where UserID =@UserID  and DivisionID =@DivisionID
