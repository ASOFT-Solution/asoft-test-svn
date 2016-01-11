/****** Object:  StoredProcedure [dbo].[CP1000]    Script Date: 07/30/2010 10:06:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--- Ngay tao 31/01/2007
---Nguoi Tao: Thuy Tuyen
---Kiem tra xoa  danh muc

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[CP1000] @TableID nvarchar(50), 
			@KeyValues as nvarchar(50)
			----@TypeID as nvarchar(20) 

  AS

Declare @Status as tinyint
Set @Status =0

If @TableID ='CT1001' ---  Loai Dich vu
Begin
  If exists (Select top 1 1  From CT4000 Where ServiceTypeID = @KeyValues)  
	Begin
		Set @Status =1
		GOTO RETURN_VALUES
	End

End

If @TableID ='CT1002' ---  Cap do dich vu
Begin
  If exists (Select top 1 1  From CT4000 Where ServiceLevelID  = @KeyValues)  
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

End
----
If @TableID ='CT2001' ---  Cap do dich vu
Begin
  If exists (Select top 1 1  From CT4002 Where ErrorStatusID  = @KeyValues)  
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
End

If @TableID ='CT2002' ---  lloai dich vu
Begin
  If exists (Select top 1 1  From CT4002 Where ErrorLevelID  = @KeyValues)  
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
End	

If @TableID ='CT2003' 
Begin
  If exists (Select top 1 1  From CT4002 Where ErrorTypeID  = @KeyValues)  
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
End	

If @TableID ='CT2004' 
Begin
   If exists (Select top 1 1  From CT4002 Where ErrorIssueID  = @KeyValues)  
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End				
End 
---- Tra ra gia tri
RETURN_VALUES:
Select @Status as Status