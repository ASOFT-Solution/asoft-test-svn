IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0047]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0047]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiểm tra ràng buộc dữ liệu cho phép Sửa/Xóa [Customize Index: 45 - ABA]
-- <History>
---- Create on 24/04/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
-- OP0047 @DivisionID = 'AP', @KeyID = '001', @TableID = 'OT0140', @IsEdit = 1

CREATE PROCEDURE [dbo].[OP0047] 	
	@DivisionID NVARCHAR(50),
	@KeyID NVARCHAR(50),
	@TableID NVARCHAR(50),
	@IsEdit TINYINT  ----  =0  la Xoa,  = 1 la Sua

AS

Declare @Status as tinyint,
	@Message as nvarchar(250)
--@Status = 1: Khong cho xoa, sua
--@Status = 2: co canh bao nhung  cho xoa cho sua
--@Status = 3: Cho sua mot phan thoi
Select @Status =0, 	@Message =''
--If @IsEdit = 0
IF @TableID = 'OT0140' -- Quyết toán đơn hàng bán/mua: kiểm tra sửa và xoá
BEGIN
	--- Đã được sử dụng trong phiếu pha trộn hay chưa? - MT0109
	IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE DivisionID = @DivisionID AND InheritVoucherID = @KeyID AND InheritTableID = 'OT0140' )
	BEGIN
			SET @Status = 1
			SET @Message ='OFML000229'
			GOTO EndMess
	END 	
END
--If @IsEdit = 1

-------------------------------------------------------------------

EndMess:
	Select @Status as Status, @Message as Message

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

