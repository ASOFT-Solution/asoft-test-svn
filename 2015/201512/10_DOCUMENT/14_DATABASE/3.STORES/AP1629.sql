
/****** Object:  StoredProcedure [dbo].[AP1629]    Script Date: 07/28/2010 15:20:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1629]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1629]
GO

/****** Object:  StoredProcedure [dbo].[AP1629]    Script Date: 07/28/2010 15:20:14 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

------ Created by Nguyen Quoc Huy, Date 06/07/2009
------ Purpose bo Chuyen but toan tang nguyen gia o AT9000

/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP1629] @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@RevaluateIDList as nvarchar(50) 

AS

	Delete	AT9000
	Where DivisionID =@DivisionID and
		TranMonth = @TranMonth and
		TranYear =@TranYear and
		TableID ='AT1690'  and
		VoucherID =  @RevaluateIDList 



Update AT1690 Set  Status =0
Where TranMonth = @TranMonth and
	TranYear = @TranYear and
	DivisionID =@DivisionID and
	VoucherID= @RevaluateIDList



Update AT1606 Set Status = 0
Where RevaluateID= @RevaluateIDList
and DivisionID = @DivisionID 
GO

