IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0069]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0069]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Kiểm tra sửa /xóa xác nhận hoàn thành của BOURBON
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 29/09/2014 by Le Thi Thu Hien
---- 
---- Modified on 29/09/2014 by 
-- <Example>
---- 
CREATE PROCEDURE OP0069
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@TranMonth AS TINYINT,
	@TranYear AS INT,
	@VoucherID AS NVARCHAR(50)
) 
AS 
DECLARE @Status AS tinyint, 
		@EngMessage as NVARCHAR(2000), 
		@VieMessage as NVARCHAR(2000)

SELECT 	@Status = 0, 
		@EngMessage = '',
		@VieMessage = ''

--IF EXISTS(	SELECT TOP 1 1 FROM OT2001 D 
--			WHERE	)
--BEGIN
      
--     SELECT	@Status = 1, 
--			@Message =N'˜Nghiệp vụ này đã được sử dụng ở màn hình hợp đồng. Bạn không được xoá.'
                           
                       
--    GOTO LB_RESULT
--END



LB_RESULT:
SELECT @Status AS Status, @EngMessage AS EngMessage, @VieMessage as VieMessage


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

