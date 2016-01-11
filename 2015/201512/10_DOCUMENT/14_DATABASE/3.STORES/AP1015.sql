
/****** Object:  StoredProcedure [dbo].[AP1015]    Script Date: 07/29/2010 17:23:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------- Created by Le Quoc Hoai, Date 21/04/2004
------- Kiem tra ForeignKey CHO ma phan loai ma hang, ma doi tuong, ma phan tich
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1015]  @TableID nvarchar(50), @KeyValues as nvarchar(50), @AnaTypeID as nvarchar(50)
  AS
Declare @Status as tinyint
Set @Status =0

If @TableID ='AT1015' --- Danh muc ma phan tich mat hang, doi tuong
Begin
 If @AnaTypeID ='O01'	
  If exists (Select top 1 1  From AT1202 Where O01ID = @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
If @AnaTypeID ='O02'	
  If exists (Select top 1 1  From AT1202 Where O02ID = @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
If @AnaTypeID =N'O03'	
  If exists (Select top 1 1  From AT1202 Where O03ID= @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
If @AnaTypeID ='O04'	
  If exists (Select top 1 1  From AT1202 Where O04ID= @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
If @AnaTypeID ='O05'	
  If exists (Select top 1 1  From AT1202 Where O05ID= @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

---- Inventories


If @AnaTypeID ='I01'	
  If exists (Select top 1 1  From AT1302 Where I01ID= @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
If @AnaTypeID ='I02'	
  If exists (Select top 1 1  From AT1302 Where I02ID= @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
If @AnaTypeID ='I03'	
  If exists (Select top 1 1  From AT1302 Where I03ID= @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
If @AnaTypeID ='I04'	
  If exists (Select top 1 1  From AT1302 Where I04ID= @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
If @AnaTypeID ='I05'	
  If exists (Select top 1 1  From AT1302 Where I05ID= @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

End

---- Tra ra gia tri
RETURN_VALUES:
Select @Status as Status
GO
