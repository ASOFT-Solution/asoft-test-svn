
/****** Object:  StoredProcedure [dbo].[AP1000]    Script Date: 07/29/2010 17:23:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------- Created by Nguyen Van Nhan, Date 18/09/2003
------- Kiem tra ForeignKey
---Edited by: Vo Thanh Huong, date: 01/12/2005
---purpose: Kiem tra Asoft-OP, Asoft-M 
---Edited by: Huỳnh Tấn Phú, date: 09/02/2012
-- Purpose: Thêm điều kiện division
---Edited by: hoàng vũ, date: 21/07/2015; Kiểm tra mã phụ trước khi xóa/sửa => Customzie index = 43 (Khách hàng secoin)
-- Edited by: Thanh Thịnh, date: 14/10/2015 : Thêm phần check đối với bảng giá mua Va ban
---Edited by: hoàng vũ, date: 02/12/2015; Kiểm tra Loại sản phẩm (Loại mặt hàng bên HRM) trước khi xóa/sửa => Customzie index = 43 (Khách hàng secoin)
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1000] @DivisionID nvarchar(50), @TableID nvarchar(50), @KeyValues as nvarchar(50) 
  AS
Declare @Status as tinyint, 
	@IsAsoftM as tinyint,
	@IsAsoftOP as tinyint	
	
Select @Status =0, @IsAsoftM = IsAsoftM, @IsAsoftOP = IsAsoftOP From AT0000 where DefDivisionID = @DivisionID
	

If @TableID ='AT1001' --- Quoc gia
  If exists (Select top 1 1  From AT1202 Where CountryID = @KeyValues and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

If @TableID ='AT1311' --- Mã phụ (Customzie index = 43 Khách hàng secoin)
  If exists (Select top 1 1  From AT1320 Where ExtraID = @KeyValues and DivisionID = @DivisionID
			 Union all
			 Select top 1 1  From OT2002 Where ExtraID = @KeyValues and DivisionID = @DivisionID
			 Union all
			 Select top 1 1  From MT2008 Where ExtraID = @KeyValues and DivisionID = @DivisionID
			 Union all
			 Select top 1 1  From MT1001 Where ExtraID = @KeyValues and DivisionID = @DivisionID
				)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

If @TableID ='AT1002' ---Tinh
  If exists (Select top 1 1  From AT1202 Where CityID = @KeyValues and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

--If @TableID ='AT1003' ---Tinh
  --If exists (Select top 1 1  From AT1202  Where AreaID = @KeyValues)
	-- Set @Status =1
If @TableID ='AT1004' --- Loai Nguyen te
 Begin
   If exists (Select top 1 1  From AT1202 Where CurrencyID = @KeyValues and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
  If   @Status =0
    If exists (Select top 1 1  From AT9000 Where CurrencyID = @KeyValues and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
 End 


If @TableID ='AT1005' ---Tµi kho¶n
 Begin
   If exists (Select top 1 1  From AT1302 Where (AccountID = @KeyValues or PrimeCostAccountID =@KeyValues) and DivisionID = @DivisionID  )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
  If   @Status =0
    If exists (Select top 1 1  From AT9000 Where (DebitAccountID = @KeyValues or CreditAccountID = @KeyValues) and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
  If   @Status =0
    If exists (Select top 1 1  From AT2007 where (DebitAccountID = @KeyValues or CreditAccountID = @KeyValues) and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
End

If @TableID ='AT1007' --- Lo¹i chøng tõ
BEGIN
   If exists (Select top 1 1  From AT9000  Where VoucherTypeID = @KeyValues  and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
  If  @IsAsoftM = 1
   If exists (Select top 1 1  From MT2001  Where VoucherTypeID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

   If  @IsAsoftM = 1
   If exists (Select top 1 1  From MT2004  Where VoucherTypeID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If  @IsAsoftOP = 1
   If exists (Select top 1 1  From OT2001  Where VoucherTypeID = @KeyValues  and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
  If  @IsAsoftOP = 1
   If exists (Select top 1 1  From OT3001  Where VoucherTypeID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
If  @IsAsoftOP = 1 
   If exists (Select top 1 1  From OT2201  Where VoucherTypeID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
end
If @TableID ='AT1009' --- Lo¹i hoa don
   If exists (Select top 1 1  From AT9000  Where VATTypeID = @KeyValues  and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

If @TableID ='AT1009' --- Lo¹i hoa don
   If exists (Select top 1 1  From AT9000  Where VATGroupID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

If @TableID ='AT1010' --- nhãm thuÕ
   If exists (Select top 1 1  From AT9000  Where VATGroupID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End


If @TableID ='AT1101' --- §¬n vÞ
 BEGIN
   If exists (Select top 1 1  From AT9000  Where DivisionID = @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
   If exists (Select top 1 1  From AT1102  Where DivisionID = @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

END

If @TableID ='AT1102' --- Phong ban
 BEGIN
   
   If exists (Select top 1 1  From AT1103  Where DepartmentID = @KeyValues and DivisionID = @DivisionID ) 	
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If exists (Select top 1 1  From HT1101  Where DepartmentID = @KeyValues and DivisionID = @DivisionID ) 	
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If exists (Select top 1 1  From HV1400  Where DepartmentID = @KeyValues and DivisionID = @DivisionID ) 	
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
	
   If exists (Select top 1 1  From AT1503  Where DepartmentID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If @IsAsoftM = 1	   
   If  exists(Select Top 1 1 From MT2002 Where DepartmentID = @KeyValues and DivisionID = @DivisionID ) 	
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
  If @IsAsoftM = 1	
   If exists (Select top 1 1  From MT2005  Where DepartmentID = @KeyValues and DivisionID = @DivisionID ) 	
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
 If @IsAsoftOP = 1	
   If exists (Select top 1 1  From OT2001  Where DepartmentID = @KeyValues and DivisionID = @DivisionID ) 	
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

END
If @TableID ='AT1103' --- Nhan viªn
 BEGIN
   
   If exists (Select top 1 1  From AT9000  Where EmployeeID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If @IsAsoftOP = 1	
   If exists (Select top 1 1  From OT2001  Where EmployeeID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End	

  If @IsAsoftOP = 1
   If exists (Select top 1 1  From OT2101  Where EmployeeID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If @IsAsoftOP = 1
   If exists (Select top 1 1  From OT3001  Where EmployeeID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If @IsAsoftM = 1
   If exists (Select top 1 1  From MT2001  Where EmployeeID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If @IsAsoftM = 1
   If exists (Select top 1 1  From MT2004  Where EmployeeID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End	
END

If @TableID ='AT1104' --- Lo¹i Nhan viªn
 BEGIN
   
   If exists (Select top 1 1  From AT1103  Where EmployeeTypeID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

END

If @TableID ='AT1201' --- Lo¹i ®èi t­îng
 BEGIN
   
   If exists (Select top 1 1  From AT1202  Where ObjectTypeID = @KeyValues  and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

END

If @TableID ='AT1202' ---®èi t­îng
 BEGIN
   
   If exists (Select top 1 1  From AT9000  Where ObjectID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If @IsAsoftOP = 1
  If exists (Select top 1 1  From OT2001  Where ObjectID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If @IsAsoftOP = 1
  If exists (Select top 1 1  From OT2101  Where ObjectID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If @IsAsoftOP = 1
  If exists (Select top 1 1  From OT3001  Where ObjectID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
	
--AsoftWM
If exists (Select top 1 1  From AT2006  Where ObjectID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

END

If @TableID ='AT1203' ---®èi t­îng
 BEGIN
   
   If exists (Select top 1 1  From AT1202  Where FinanceStatusID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

END

If @TableID ='AT1204' --- LÜnh vùc ho¹t ®éng
 BEGIN
   
   If exists (Select top 1 1  From AT1202  Where FieldID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

END

If @TableID ='AT1205' ---Ph­¬ng thøc thanh to¸n
 BEGIN

   
   If exists (Select top 1 1  From AT1202  Where FieldID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
  
  If @IsAsoftOP = 1
  If exists (Select top 1 1  From OT2001  Where PaymentID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If @IsAsoftOP = 1
  If exists (Select top 1 1  From OT3001  Where PaymentID = @KeyValues and DivisionID = @DivisionID )
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
END

If @TableID ='AT1301' ---Lo¹i hµng tån kho
 BEGIN
   
   If exists (Select top 1 1  From AT1302  Where InventoryTypeID = @KeyValues and DivisionID = @DivisionID 
			  Union all
			  Select top 1 1  From HT1015  Where ProductTypeID = @KeyValues and DivisionID = @DivisionID 
				)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

END

If @TableID ='AT1303' --- kho hµng
 BEGIN
   
   If exists (Select top 1 1  From AT2006  Where (WareHouseID = @KeyValues or WareHouseID2 =   @KeyValues)  and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

   If exists (Select top 1 1  From AT2016  Where (WareHouseID = @KeyValues or WareHouseID2 =   @KeyValues) and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End


   If @IsAsoftOP = 1
   If exists (Select top 1 1  From OT2002  Where WareHouseID = @KeyValues  and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

   If @IsAsoftOP = 1
   If exists (Select top 1 1  From OT3002  Where WareHouseID = @KeyValues  and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
END




If @TableID ='AT1304' --- Don vi tinh
 BEGIN
   
   If exists (Select top 1 1  From AT1302  Where UnitID = @KeyValues  and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

END


If @TableID ='AT1401' --- Nhom nguoi dung
 BEGIN
   
   If exists (Select top 1 1  From AT1402  Where GroupID = @KeyValues  and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

END


If @TableID ='AT1501'  	--- Nguon hinh thanh
 BEGIN
   
   If exists (Select top 1  1  From AT1503  Where (SourceID1 = @KeyValues or SourceID2 = @KeyValues or SourceID2 = @KeyValues)  and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

END


If @TableID ='AT1502'  	--- Nhom tai san
 BEGIN
   
   If exists (Select top 1  1  From AT1503  Where AssetGroupID = @KeyValues and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

END


IF @TableID ='AT1016'
 BEGIN
   
   If exists (Select top 1  1  From AT9000  Where (DebitBankAccountID = @KeyValues or CreditBankAccountID =  @KeyValues) and DivisionID = @DivisionID ) 
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

END

IF @TableID ='OT1301'
 BEGIN
   
   If exists (Select top 1  1  From OT3101  Where PriceListID = @KeyValues and DivisionID = @DivisionID ) 
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

	If exists (Select top 1  1  From OT3001  Where PriceListID = @KeyValues and DivisionID = @DivisionID ) 
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
	If exists (	Select top 1  1  
				From OT2101  
				Where PriceListID = @KeyValues 
					AND DivisionID = @DivisionID ) 
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

	If exists (	Select top 1  1  
				From OT2001  
				Where PriceListID = @KeyValues 					
					AND DivisionID = @DivisionID ) 
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
	
	If exists (	Select top 1  1  
				From AT9000  
				Where PriceListID = @KeyValues 
					AND TransactionTypeID in ('T03','T04') 
					AND DivisionID = @DivisionID ) 
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End


END
	
---- Tra ra gia tri
RETURN_VALUES:
Select @Status as Status
GO
