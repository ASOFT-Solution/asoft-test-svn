
/****** Object:  StoredProcedure [dbo].[MP1500]    Script Date: 07/30/2010 11:20:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---Create by: Vo Thanh Huong, date: 16/06/2005
---purpose: Kiem tra tkhoa ngoai (PK=KeyValue1+ KeyValue2) truoc khi xoa cac danh muc 
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP1500]              @DivisionID as nvarchar(50),					
					@TableID as nvarchar(50),
					@KeyValue1 as nvarchar(50),
					@KeyValue2 as nvarchar(50),
					@ComputerName as nvarchar(50),
					@Language as nvarchar(50)
		
 AS
Declare  @Status as tinyint ,
	 @Message as nvarchar(250)	



Set nocount on
Delete From MT7777 Where ComputerName = @ComputerName
Set @Status = 0 
If @TableID = 'MT1702'--§èi t­îng THCP
 If  Exists (Select Top  1 1 From MT1702  Where WorkID = @KeyValue1 and LevelID = @KeyValue2 )
		Begin
		 If exists (Select top 1 1  From MT2002  Where WorkID = @KeyValue1 and LevelID = @KeyValue2 )
			Begin
			Set @Status = 1
			If @Language = '84' 
				 Set @Message = 'C«ng ®o¹n nµy ®· ®­îc sö dông. B¹n kh«ng thÓ xo¸!'
			Else 
				 Set @Message = 'This levelID has been used. You can not delete it.?' 
		
			End 
		Else 
		 If exists (Select top 1 1  From MT2005  Where WorkID = @KeyValue1 and LevelID = @KeyValue2 )
			Begin
			 Set @Status = 1
			If @Language = '84' 
				 Set @Message = 'C«ng ®o¹n nµy ®· ®­îc sö dông. B¹n kh«ng thÓ xo¸!'
			Else 
				 Set @Message = 'This levelID has been used. You can not delete it.?' 
		
			End 
		End
RETURN_VALUES:
Select @Status as Status, @Message as Message


