
/****** Object:  StoredProcedure [dbo].[OP1000]    Script Date: 08/03/2010 15:02:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------- Created by Nguyen Van Nhan and Vo Thanh Huong, Date 28/08/2004
------- Kiem tra ForeignKey --- Thong tin danh muc


/********************************************
'* Edited by: [GS] [Thanh Trẫm] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP1000]  @TableID nvarchar(50), 	@KeyValues as nvarchar(50), @TypeID as nvarchar(50) 

  AS

Declare @Status as tinyint
Set @Status =0

If @TableID ='OT1001' ---  Phan loai don hang
Begin
  If exists (Select top 1 1  From OT2001 Where ClassifyID = @KeyValues)  and @TypeID ='SO'
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If exists (Select top 1 1  From OT3001 Where ClassifyID = @KeyValues)  and @TypeID ='PO'
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

End

If @TableID ='OT1002' ---  Ma Phan tich
Begin
  If exists (Select top 1 1  From OT2001 Where Ana01ID  = @KeyValues)  and @TypeID ='S01'
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If exists (Select top 1 1  From OT2001 Where Ana02ID  = @KeyValues)  and @TypeID ='S02'
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If exists (Select top 1 1  From OT2001 Where Ana03ID  = @KeyValues)  and @TypeID ='S03'
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If exists (Select top 1 1  From OT2001 Where Ana04ID  = @KeyValues)  and @TypeID ='S04'
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If exists (Select top 1 1  From OT2001 Where Ana05ID  = @KeyValues)  and @TypeID ='S05'
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

---- Ma phan tich don hang mua
  If exists (Select top 1 1  From OT3001 Where Ana01ID  = @KeyValues)  and @TypeID ='P01'
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If exists (Select top 1 1  From OT3001 Where Ana02ID  = @KeyValues)  and @TypeID ='P02'
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If exists (Select top 1 1  From OT3001 Where Ana03ID  = @KeyValues)  and @TypeID ='P03'
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If exists (Select top 1 1  From OT3001 Where Ana04ID  = @KeyValues)  and @TypeID ='P04'
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

  If exists (Select top 1 1  From OT3001 Where Ana05ID  = @KeyValues)  and @TypeID ='P05'
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End



End
---- 
---- Tra ra gia tri
RETURN_VALUES:
Select @Status as Status

