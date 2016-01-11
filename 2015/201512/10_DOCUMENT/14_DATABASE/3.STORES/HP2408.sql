/****** Object:  StoredProcedure [dbo].[HP2408]    Script Date: 07/30/2010 16:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----- Kiem tra dieu kien khi quet the
---- Created by Vo Thanh Huong, Date 15/10/2004

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

ALTER PROCEDURE 	[dbo].[HP2408]	 @DivisionID as nvarchar(50), 				
				@TranMonth as int,
				@TranYear as int,
				@Fromdate datetime,
				@ToDate datetime
 AS

Declare @Status as tinyint,
		@VietMess as nvarchar(1000),
		@EngMess as nvarchar(1000)
Select @Status	 = 0, @VietMess = '', @EngMess = '' 
If Exists (Select Top 1 1 
		From HT2407 
		Where DivisionID = @DivisionID and 
			TranMonth = @TranMonth and
			TranYear = @TranYear and
			(AbsentDate between @FromDate and @ToDate))
  Begin
	Select @Status = 1, 
		@VietMess = 'B¹n kh«ng thÎ quÐt file  v× ®· cã d÷ liÖu, h·y kiÓm tra l¹i !',
		@EngMess = 'You cab not scan this file because data is exists. Please check again !'   
  End
Goto EndMess

EndMess:
	Select @Status as Status, @VietMess as Vietmess, @EngMess as EngMess













