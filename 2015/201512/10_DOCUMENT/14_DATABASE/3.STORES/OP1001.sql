
/****** Object:  StoredProcedure [dbo].[OP1001]    Script Date: 08/03/2010 15:03:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoang Thi Lan
--Date  Created date  04/12/2003
--Purpose : Kiem tra khoa ngoai  cac bang danh muc


/********************************************
'* Edited by: [GS] [Thanh Trẫm] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP1001]		@DivisionID as nvarchar(50),					
					@TableID as nvarchar(50),
					@KeyValue as nvarchar(50),
					@Language as nvarchar(50)
		
 AS
Declare  
	 @Status as tinyint ,
	 @Message as nvarchar(250)	

Set nocount on
Set @Status = 0 
If @TableID = 'OT2001'
  If exists ( Select top 1 1  From MT1601  Where PeriodID = @KeyValue )
	Begin
		
		 If exists (Select top 1 1  From MT1601  Where PeriodID = @KeyValue and IsDistribute =1 )
			Begin
			 Set @Status =2
			if @Language = '84' 
				 Set @Message = 'B¹n kh«ng thÓ söa hoÆc xãa nµy ! B¹n cã muèn xem kh«ng? ' 
			Else 
				 Set @Message = 'You can not delete this PeriodID.Do you want to view it ?' 
		
			End 
		Else 
		 If exists (Select top 1 1  From MT1601  Where PeriodID = @KeyValue and IsCost  =1 )
			Begin
			 Set @Status =2
			if @Language = '84' 
				 Set @Message = 'B¹n kh«ng thÓ söa hoÆc xãa ®èi t­îng THCP nµy ! B¹n cã muèn xem kh«ng? ' 
			Else 
				 Set @Message = 'You can not delete this PeriodID.Do you want to view it ?' 
		
			End 
		
End
