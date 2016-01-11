
/****** Object:  StoredProcedure [dbo].[MP0404]    Script Date: 07/30/2010 09:30:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

----Created by: Vo Thanh Huong, date: 8/4/2006
-----Purpose: Kiem tra truoc khi thuc hien ke thua
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0404]  @DivisionID nvarchar(50),
				@PeriodID nvarchar(50)

AS 
DECLARE 	@Status int, 
		@VieMess nvarchar(4000), 
		@EngMess nvarchar(4000)

Set nocount off

Select @Status = 0, @VieMess = 0, @EngMess = ''

If not exists(Select Top  1 1 From MT0400 Where PeriodID = @PeriodID and DivisionID = @DivisionID and ResultTypeID = 'R03')
	BEGIN
	Select @Status = 1, @VieMess ='ÑTTHCP naøy khoâng coù DDCK neân khoâng theå thöïc hieän keá thöøa.', 
		@EngMess = 'Do not exists result, can not do.'	
	GOTO RETURN_VALUES
	END		
ELSE
	If not exists(Select Top 1 1 From MT1601 Where FromPeriodID = @PeriodID AND DivisionID = @DivisionID)
		BEGIN
		Select @Status = 1, @VieMess ='Khoâng coù ÑTTHCP naøo choïn keá thöøa töø DDCK cuûa ñoái töôïng naøy.', 
					@EngMess = 'Do not exists any period choose it.'	
		GOTO RETURN_VALUES
		END	
	ELSE	
		If not exists(Select Top 1 1 From MT1601 Where FromPeriodID = @PeriodID AND DivisionID = @DivisionID and 	
			PeriodID not in(Select Distinct PeriodID From MT1612 
			Where Type = 'B' and FromPeriodID = @PeriodID AND MT1601.DivisionID = @DivisionID))
			BEGIN
				Select @Status = 1, @VieMess ='Ñaõ thöïc hieän keá thöøa. Baïn khoâng theå thöïc hieän nöõa.', 
					@EngMess = 'It was do. You can not do again.'	
				GOTO RETURN_VALUES
			END


RETURN_VALUES:
Set Nocount on	
	Select @Status as Status, @VieMess as VieMess, @EngMess as EngMess
