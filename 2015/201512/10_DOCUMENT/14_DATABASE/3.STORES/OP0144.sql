IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0144]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0144]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>  
---- Kiểm tra sửa/xóa phiếu quyết toán Tàu-SL
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
	EXEC OP0144	'BBL', 'ASOFTADMIN', 10, 2014, '8CC5C652-F4FD-4347-B8E0-9BB31403D72A'
*/


CREATE PROCEDURE [dbo].[OP0144] 	
	@DivisionID NVARCHAR(50),
	@UserID NVARCHAR(50),
	@TranMonth INT,
	@TranYear INT,
	@SOrderID NVARCHAR(50)

AS

Declare @Status as tinyint, --- 1: Khong cho sua/xoa, 0: cho phép sua/xóa
	@Message as nvarchar(250)

Select @Status = 0, @Message = ''
	
IF EXISTS (Select top 1 1 from AT9000 Where InheritTableID = 'OT2010' AND InheritVoucherID = @SOrderID AND DivisionID = @DivisionID)
	Begin
		Select @Status = 1, 
		@Message = 'OFML000225'
	End 
	
	
-------------------------------------------------------------------
EndMess:
	Select @Status as Status, @Message as [Message]

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

