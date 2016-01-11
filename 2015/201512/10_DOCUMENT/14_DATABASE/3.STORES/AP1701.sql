/****** Object:  StoredProcedure [dbo].[AP1701]    Script Date: 07/28/2010 16:00:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1701]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1701]
GO

/****** Object:  StoredProcedure [dbo].[AP1701]    Script Date: 07/28/2010 16:00:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Van Nhan.
---- Date SaturDay, 31/05/2003.
---- Purpose: Kiem tra trang thai phieu nhập số dư có được phép Sửa - Xoá hay không.

/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP1701] 	@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50),
				@Status as tinyint output,
				@EngMessage as nvarchar(250) output,	
				@VieMessage  as nvarchar(250) output	

 AS

Set @Status =0
Set @EngMessage=''
set @VieMessage =''
If Exists (Select 1 From  AT0114 	inner join AT1302 on AT1302.InventoryID = AT0114.InventoryID
			Where 	AT0114.DivisionID =@DivisionID and	
					ReVoucherID =@VoucherID and
					DeQuantity<>0  and MethodID =3)
	Begin
		Set @Status = 1
		Set @VieMessage = 'AFML000087' 
		Set @EngMessage = 'AFML000087'

	End
Else
	Set @Status = 0
GO

