/****** Object:  StoredProcedure [dbo].[AP7433]    Script Date: 12/28/2010 16:38:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------- 	Created by Nguyen Van Nhan.
------ 	Created Date 25/08/2005.
------- 	Purpose: In to khai thue GTGT

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7433] 
				@DivisionID NVARCHAR(50), 
				@ReportCodeID NVARCHAR(50), 
				@TranMonth  int, @TranYear int,
				@Amount18 as decimal (28, 8),
				@Amount19 as decimal (28, 8),
				@Amount20 as decimal (28, 8),
				@Amount21 as decimal (28, 8),
				@Amount34 as decimal (28, 8),
				@Amount35 as decimal (28, 8),
				@Amount36 as decimal (28, 8),
				@Amount37 as decimal (28, 8)
						
AS

Declare @AT7434_cur as cursor

Set nocount on
Delete AT7435 Where ReportCodeID =@ReportCodeID And DivisionID = @DivisionID

Insert AT7435 (DivisionID, ReportCodeID, LineID, Code01, Code02, Amount01, Amount02)
Select Distinct @DivisionID, ReportCodeID, LineID, '','',0,0 From AT7434  Where ReportCodeID =@ReportCodeID And DivisionID = @DivisionID


update AT7435 	Set 	Code01 =  AmountCode 
From AT7435  inner  join AT7434 on 	AT7434.LineID = AT7435.LineID and
					AT7434.ReportCodeID = AT7435.ReportCodeID and
					AT7434.DivisionID = AT7435.DivisionID and
					AT7434.Type =0	
Where AT7435.DivisionID = @DivisionID					
				
update AT7435 	Set 	Code02 =  AmountCode
From AT7435  inner  join AT7434 on 	AT7434.LineID = AT7435.LineID and
					AT7434.ReportCodeID = AT7435.ReportCodeID and
					AT7434.DivisionID = AT7435.DivisionID and
					AT7434.Type =1	
Where AT7435.DivisionID = @DivisionID					
-----------------------------------------------------------------------------------------
Set Nocount Off

Exec AP7432 @DivisionID, @ReportCodeID,  @TranMonth,@TranYear


Declare @Amount0240 as decimal (28, 8)

Set @Amount0240 = (Select Amount02 From AT7435 Where LineID ='025' And DivisionID = @DivisionID)
If @Amount0240 < 0  
	Update AT7435 set Amount02= @Amount0240
	Where LineID ='026' And DivisionID = @DivisionID



Update AT7435 set Amount02 = Case when Amount02<0 then 0 else abs(Amount02) end
Where LineID ='025'  And DivisionID = @DivisionID

Update AT7435 set Amount02=  Case when Amount02>0 then 0 else abs(Amount02) end
Where LineID ='026' And DivisionID = @DivisionID
 
Update AT7435 set Amount02 =  abs(Amount02)
Where LineID ='028' And DivisionID = @DivisionID