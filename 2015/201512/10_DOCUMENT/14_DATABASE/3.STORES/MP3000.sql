
/****** Object:  StoredProcedure [dbo].[MP3000]    Script Date: 08/02/2010 10:44:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoµng ThÞ Lan
--Date 16/12/2003
--Purpose: KiÓm tra bé hÖ sè  'Ph©n bæ cho ®èi t­îng'

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP3000] 	@DivisionID as nvarchar(50),
					@PeriodID as nvarchar(50)

 AS
Declare @sSQL as nvarchar(4000),
		@CoefficientID as nvarchar(50),
		@ChildPeriodID as nvarchar(50),
		@PeriodID1 as nvarchar(50),
		@Coef_List_Cur as cursor,
		@Child_List_Cur as cursor ,
		@Status as tinyint,
		@Message as nvarchar(250)

Set NoCount off
Set @Status=0
--So s¸nh 2 tËp hîp §èi t­îng THCP chung vµ HÖ sè chung
If Exists (Select Top 1 1 From MT1609
		Where  PeriodID =  @PeriodID  and  MT1609.ChildPeriodID
	 not in (Select MT1607.PeriodID 
		From MT1606  inner join MT1601 on MT1606.CoefficientID = MT1601.CoefficientID and 
			 PeriodID = @PeriodID and IsForPeriodID = 1
			inner join MT1607 on MT1606.CoefficientID =MT1607.CoefficientID))
Begin
	
	If Exists (Select Top 1 1 
		From MT1606  inner join MT1601 on MT1606.CoefficientID = MT1601.CoefficientID and 
			 PeriodID =  @PeriodID and IsForPeriodID = 1
			inner join MT1607 on MT1606.CoefficientID =MT1607.CoefficientID
		Where MT1607.PeriodID not in (Select ChildPeriodID From MT1609
						 Where  PeriodID =  @PeriodID    ))
		Begin 
			Set @Status =2  --Tho¸t ra lu«n
			Set @Message=  'Bé hÖ sè kh«ng ®óng.B¹n h·y nhËp l¹i bé hÖ sè cho ®èi t­îng. '
		End 

	Else
		Begin 
			Set @Status =1
			Set @Message=  'Bé hÖ sè cã Ýt ®èi t­îng h¬n §TTHCP con.B¹n cã muèn tiÕp tôc ph©n bæ ?'
		End 
End

Else
Begin

	If Exists (Select Top 1 1 
		From MT1606  inner join MT1601 on MT1606.CoefficientID = MT1601.CoefficientID and 
			 PeriodID = @PeriodID and IsForPeriodID = 1
			inner join MT1607 on MT1606.CoefficientID =MT1607.CoefficientID
		Where MT1607.PeriodID not in (Select ChildPeriodID From MT1609
						 Where  PeriodID = @PeriodID))
		Begin 
		Set @Status =1 
		Set @Message=  'Bé hÖ sè kh«ng ®óng.B¹n cã muèn tiÕp tôc ph©n bæ chi phÝ kh«ng ? '
		End 

	Else
		Begin 
		Set @Status =0
		Set @Message=  'Tèt.TÝnh tiÕp. '
		End 
End

RETURN_VALUES:
Set Nocount on	
	Select @Status as Status, @Message as Message
