
/****** Object:  StoredProcedure [dbo].[MP0032]    Script Date: 08/02/2010 14:10:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




---- Created by Van Nhan, Date 09/05/2009.
---- Purporse: Update gia tri vao bang MT1614 - Gia thanh san pham
---- Edit by: Dang Le Bao Quynh; Date 03/09/2009
---- Purpose: Sua lai cach sinh IGE
---- Edit by: Dang Le Bao Quynh; Date 22/10/2009
---- Purpose: Bo sung store cap nhat gia cho ket qua san xuat

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [02/08/2010]
'********************************************/

ALTER PROCEDURE	[dbo].[MP0032] 	@DivisionID as nvarchar(50),
						@PeriodID as nvarchar(50),
						@TranMonth int,
						@TranYear int
 AS

Declare 	@VoucherID as nvarchar(50),
		@VoucherTypeID as nvarchar(50),
		@EmployeeID  as nvarchar(50),
		@Description  as nvarchar(250),		
		@voucherNo     as nvarchar(50),
		@Voucherdate Datetime, 
		@Cursor as cursor,
		@charMonth as nvarchar(50),
		@charYear as nvarchar(50),
		@CharDate as nvarchar(50)

Set @CharDate =(Case when @TranMonth in (1,3,5,7,8,10,12) then '31'
			else Case when @TranMonth in (4,6,9,11) then '30' else '28' end end)


Set @charYear = ltrim(rtrim(str(@TranYear)))
if @TranMonth <10 
	Set @charMonth='0'+ltrim(rtrim(str(@TranMonth)))
Else
	Set @charMonth=ltrim(rtrim(str(@TranMonth)))

Set @VoucherDate =@charMonth+'/'+@CharDate+'/'+@charYear

Select @VoucherTypeID= VoucherTypeID, @EmployeeID=EmployeeID, @Description=Description From MT0001 Where TableID='MT1614'

Exec AP0000  @DivisionID, @voucherNo  OUTPUT, 'AT9000', @VoucherTypeID, @CharMonth, @CharYear, 15, 3, 1, '-'
--- Update cac gia tri bang tinh gia thanh
Update MT1614 set 	VoucherDate =@VoucherDate,
			VoucherNo= @VoucherNo,
			voucherTypeID =@VoucherTypeID,
			Description=@Description,
			EmployeeID=@EmployeeID
Where PeriodID =@PeriodID AND DivisionID = @DivisionID

EXEC MP8110 @DivisionID,@PeriodID

Update MT1601 Set IsCost =1 Where PeriodID =@PeriodID