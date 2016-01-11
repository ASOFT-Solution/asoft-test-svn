/****** Object:  StoredProcedure [dbo].[CP1207]    Script Date: 07/30/2010 10:07:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--- Ngay tao 31/01/2007
---Nguoi Tao: Thuy Tuyen
---Kiem tra  xoa   ma tang tu dong ho so 

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[CP1207] @TableID nvarchar(50), 
				@KeyValues as nvarchar(50),
				@STypeID as nvarchar(50) 

  AS
Declare @Status as tinyint
if @TableID ='CT1207' --- ma phan loai ho so
Begin
 If @STypeID ='F01'	
  If exists (Select top 1 1  From CT4000 Where S1 = @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
 If @STypeID ='F02'	
  If exists (Select top 1 1  From  CT4000  Where S2 = @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
If @STypeID ='F03'	
  If exists (Select top 1 1  From  CT4000  Where S3 = @KeyValues)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
End

----

---- Tra ra gia tri
RETURN_VALUES:
Select @Status as Status