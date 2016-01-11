/****** Object:  StoredProcedure [dbo].[AP1608]    Script Date: 07/28/2010 14:45:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1608]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1608]
GO

/****** Object:  StoredProcedure [dbo].[AP1608]    Script Date: 07/28/2010 14:45:46 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Van Nhan, Date 25.12.2004
--- Purpose : Xoa but toan phan bo chi phi CCDC
--- Edited by Bao Anh	Date: 08/07/2012	Where them dieu kien ReVoucherID
/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP1608] 	@DivisionID as nvarchar(50), 
				@TranMonth as int, 
				@TranYear as int, 
				@DepreciationID as nvarchar(50), 
				@ToolID as nvarchar(50),
				@ReVoucherID AS nvarchar(50)
 AS

 Delete AT1604 Where DivisionID =@DivisionID and TranMonth = @TranMonth and TranYear =@TranYear and ToolID =@ToolID AND ReVoucherID = @ReVoucherID

 If not Exists (Select 1 from AT1604 Where ToolID = @ToolID AND ReVoucherID = @ReVoucherID)
	Update AT1603 set UseStatus = 0 Where ToolID =@ToolID and DivisionID = @DivisionID AND VoucherID = @ReVoucherID
 Else 
	Update AT1603 set UseStatus = 1 Where ToolID =@ToolID and DivisionID = @DivisionID AND VoucherID = @ReVoucherID
GO

