
/****** Object:  StoredProcedure [dbo].[AP1628]    Script Date: 07/28/2010 15:18:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1628]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1628]
GO


/****** Object:  StoredProcedure [dbo].[AP1628]    Script Date: 07/28/2010 15:18:41 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



-------- Created by Nguyen Quoc Huy, Date 08/07/2009
------- Purpose Kiem tra sau khi danh gia lai CCDC nay da duoc phan bo chua?

/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP1628] @ToolID as nvarchar(50),
				@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int
 AS

Declare @Status as tinyint

If Exists (Select 1 From AT1604 Where 	ToolID =@ToolID and
					DivisionID = @DivisionID and TranMonth= @TranMonth and TranYear = @TranYear)
	Set @Status= 1
Else
	Set @Status = 0

Select 	@Status  as Status
GO

