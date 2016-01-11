
/****** Object:  StoredProcedure [dbo].[OP2000]    Script Date: 07/30/2010 13:50:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------- Created by:  Vo Thanh Huong, Date 28/08/2004
------- Kiem tra ForeignKey --- Thong tin danh muc
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP2000]  @TableID nvarchar(50), 	@KeyValues as nvarchar(50)

  AS
Declare @Status as tinyint
Set @Status =0

If @TableID ='OT1003' ---  Phuong thuc
Begin
  If exists (Select top 1 1  From OT2002 Where MethodID = @KeyValues) or  exists (Select top 1 1  From OT3002 Where MethodID = @KeyValues)    
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
End
If @TableID ='OT1004' --- Khoan muc phi
Begin
If exists (Select top 1 1  From OT2004 Where CostID = @KeyValues) 
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
End
If @TableID ='OT1305' --- Ho so bao bi
Begin
--If exists (Select top 1 1  From OT1305 Where FileID = @KeyValues) 
	--Begin
		-- Set @Status =1
		GOTO RETURN_VALUES
--	End
End

---Danh muc dong goi
---- dong goi
If @TableID ='OT1307' ---  Danh muc dong goi
Begin
  If exists (Select top 1 1  From OT5002 Where PackageID = @KeyValues)  
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

End

---- Tra ra gia tri
RETURN_VALUES:
Select @Status as Status