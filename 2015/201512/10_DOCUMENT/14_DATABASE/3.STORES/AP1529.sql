
/****** Object:  StoredProcedure [dbo].[AP1529]    Script Date: 07/29/2010 13:12:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



------ Created by Nguyen Quoc Huy, Date 26/03/2007
------ Purpose bo Chuyen but toan tang nguyen gia o AT9000

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1529] 
				@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@RevaluateIDList as nvarchar(800) 

AS

	Delete	AT9000
	Where DivisionID = @DivisionID 
		and	TranMonth = @TranMonth 
		and	TranYear = @TranYear 
		and	TableID = 'AT1590'  
		and	VoucherID =  @RevaluateIDList 



Update AT1590 Set  Status =0
Where TranMonth = @TranMonth 
	and	TranYear = @TranYear 
	and	DivisionID = @DivisionID 
	and	VoucherID = @RevaluateIDList

Update AT1506 Set Status = 0
Where RevaluateID = @RevaluateIDList
and DivisionID = @DivisionID 