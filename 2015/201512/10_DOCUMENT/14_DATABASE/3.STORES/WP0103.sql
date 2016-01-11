IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0103]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0103]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiểm tra sửa/xóa phiếu chênh lệch
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 05/06/2014 by Lê Thị Thu Hiền
---- 
---- Modified on 05/06/2014 by 
-- <Example>
---- 

CREATE PROCEDURE WP0103
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@VoucherID AS NVARCHAR(50) ,
	@Mode TINYINT --0: Edit, 1: Delete
) 
AS 
DECLARE @sSQL NVARCHAR(MAX)


	DECLARE @Status TINYINT,
			@Message NVARCHAR(100)
	SET @Status = 0
	SET @Message = ''
	--------Phiếu này được chuyển từ yêu cầu nhập xuất chuyển kho
	IF  EXISTS (SELECT TOP 1 1 FROM WT0101 WHERE DivisionID = @DivisionID  AND VoucherID  = @VoucherID AND TableID = 'WT0095')
		BEGIN
			SET @Status = 1
			SET @Message = 'WFML000165' 	
		END
	--------Phiếu này được chuyển từ POS
	IF  EXISTS (SELECT TOP 1 1 FROM WT0101 WHERE DivisionID = @DivisionID  AND VoucherID  = @VoucherID AND TableID LIKE 'POS%')
		BEGIN
			SET @Status = 1
			SET @Message = 'WFML000166' 	
		END

 	SELECT @Status AS Status, @Message AS Message 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

