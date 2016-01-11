if exists (select * from dbo.sysobjects where id = object_id(N'MP6000') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [MP6000]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

--Created by Hoang Thi Lan
--Date 8/12/2003
--Purpose: Ph©n bæ chi phÝ cho  ®èi t­îng
--Edit by: Dang Le Bao Quynh; Date 17/06/2011
--Purpose: Bo sung phan bo theo he so don hang san xuat

CREATE PROCEDURE MP6000 	@DivisionID nvarchar(50),
					@PeriodID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int 
					
 
As 
Declare @CoefficientID as nvarchar(50),
	@IsFromCost  as tinyint,
	@VoucherID as nvarchar(50),
	@CYear as int,	@CMonth as int,@BatchID as nvarchar(50)
	

Delete From MT9000  
Where 	MT9000.DivisionID = @DivisionID  and  
	MT9000.ParentPeriodID = @PeriodID
	
-----and IsFromPeriodID = 1
If @TranMonth >9
	Set @CMonth = ltrim(rtrim(str(@TranMonth)))
Else
	Set @CMonth = '0'+ltrim(rtrim(str(@TranMonth)))

Set @CYear =right(Ltrim(rtrim(str(@TranYear))),2)

Exec AP0000  @DivisionID, @VoucherID  OUTPUT, 'MT9000', 'IV', @CMonth,  @CYear ,16, 3, 0, '-'	
Exec AP0000  @DivisionID, @BatchID  OUTPUT, 'MT9000', 'IB', @CMonth,  @CYear ,16, 3, 0, '-'	

Select  @CoefficientID = CoefficientID,
	@IsFromCost = IsFromCost
	From MT1601
	Where PeriodID = @PeriodID

If @IsFromCost = 0 	--Theo hÖ sè
	Exec MP6001 @DivisionID,@PeriodID,@CoefficientID,@CMonth,  @CYear,@VoucherID,@BatchID, @TranMonth, @TranYear 

If @IsFromCost = 1 	--Theo chi phí cấu thành
	Exec MP6002 @DivisionID,@PeriodID,@CMonth,  @CYear,@VoucherID,@BatchID, @TranMonth, @TranYear 

If @IsFromCost = 2 	--Theo hệ số đơn hàng sản xuất
	Exec MP6005 @DivisionID,@PeriodID,@CMonth,  @CYear,@VoucherID,@BatchID, @TranMonth, @TranYear 


GO
SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
