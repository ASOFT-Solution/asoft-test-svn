IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0137]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0137]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>  
---- Kiểm tra xóa phiếu quyết toán
-- <Param>  
----   
-- <Return>  
----   
-- <Reference>  
----   
-- <History>  
---- Create on 27/10/2014 Mai Trí Thiện
-- <Example>  
----  
/*
	EXEC OP0137	'BBL', 'ASOFTADMIN', 10, 2014, '8CC5C652-F4FD-4347-B8E0-9BB31403D72A'
*/


CREATE PROCEDURE [dbo].[OP0137] 	
	@DivisionID nvarchar(50),
	@UserID nvarchar(50),
	@TranMonth int,
	@TranYear int,
	@OrderID nvarchar(250)

AS

Declare @Status as tinyint, --- 1: Khong cho xoa, 0: cho phép xóa
	@VieMessage as nvarchar(250)

Select @Status = 0, @VieMessage = ''
	
IF EXISTS (Select top 1 1 from AT9000 Where InheritTableID = 'OT3004' AND InheritVoucherID = @OrderID AND DivisionID = @DivisionID)
	Begin
		Select @Status = 1, 
		@VieMessage = 'OFML000224'
	End 
	
	
-------------------------------------------------------------------
EndMess:
	Select @Status as Status, @VieMessage as VieMessage

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

