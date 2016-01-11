IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP00973]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP00973]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Kiểm tra Sửa/Xóa
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 10/06/2014 by Lê Thị Thu Hiền
---- 
---- Modified on 01/07/2014 by Lê Thị Thu Hiền
-- <Example>
---- 
CREATE PROCEDURE WP00973
( 
		@DivisionID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@UserID AS NVARCHAR(50),
		@VoucherID AS NVARCHAR(50),
		@Mode TINYINT --0: Edit, 1: Delete
) 
AS 


	DECLARE @Status TINYINT,
			@Message NVARCHAR(100)
	SET @Status = 0
	SET @Message = ''
	---------------Kiểm tra kế thừa

	IF EXISTS (	SELECT TOP 1 1 FROM AT2007
					WHERE DivisionID = @DivisionID 
					AND InheritTableID = 'WT0095' 
					And InheritVoucherID = @VoucherID)
		BEGIN
			SET @Status = 1
			IF @Mode = 0
			SET @Message = 'WFML000168' 
			IF @Mode = 1
			SET @Message = 'WFML000170' 
		END


	---------------Kiểm tra đã duyệt
	--- Phiếu chuyển kho
	IF EXISTS (	SELECT TOP 1 1 FROM WT0095
					WHERE DivisionID = @DivisionID 
					AND IsCheck = 1
					AND VoucherID = @VoucherID
					AND KindVoucherID = 3)
		BEGIN
			SET @Status = 3
			IF @Mode = 0
			SET @Message = 'WFML000169' 
			IF @Mode = 1
			SET @Message = 'WFML000171' 
		END
	--- Phiếu nhập xuất	
	IF EXISTS (	SELECT TOP 1 1 FROM WT0095
					WHERE DivisionID = @DivisionID 
					AND IsCheck = 1
					AND VoucherID = @VoucherID
					AND KindVoucherID <> 3)
		BEGIN
			SET @Status = 1
			IF @Mode = 0
			SET @Message = 'WFML000063' 
			IF @Mode = 1
			SET @Message = 'WFML000063' 
		END
		
		
	SELECT @Status AS Status, @Message AS Message


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

