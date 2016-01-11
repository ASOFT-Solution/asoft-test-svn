/****** Object:  StoredProcedure [dbo].[AP1700]    Script Date: 07/28/2010 16:00:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1700]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1700]
GO

/****** Object:  StoredProcedure [dbo].[AP1700]    Script Date: 07/28/2010 16:00:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


---- Created by Nguyen Van Nhan.
---- Date SaturDay, 31/05/2003.
---- Purpose: Kiem tra trang thai phieu nhập số dư có được phép Sửa - Xoá hay không.

/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP1700] 	@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50)

 AS
Declare @Status as tinyint
If Exists (Select 1 From  AT0114 Where 	DivisionID =@DivisionID and	
					ReVoucherID =@VoucherID and
					DeQuantity<>0 )
	Set @Status =1
Else
	Set @Status = 0

Select  @Status as Status, ' Phiếu nhập số dư này được xuất đích danh từ lô nhập, bạn không được phép sửa hoặc xoá. Nếu muốn sửa phiếu nhập này bạn phải xoá các phiếu xuất liên quan.' as Message  





GO

