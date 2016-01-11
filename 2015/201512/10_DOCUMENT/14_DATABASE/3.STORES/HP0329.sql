IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0329]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0329]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiểm tra sửa xóa grid danh sách nhân viên nghỉ phép HF0325
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create by Nguyễn Thanh Sơn on 19/11/2013
---- 
---- Modified on 02/05/2013 by 
-- <Example>
---- 
CREATE PROCEDURE HP0329
( 
		@DivisionID VARCHAR(50),
		@UserID VARCHAR(50),
		@TranMonth INT,
		@TranYear INT,
		@VoucherID VARCHAR(50)
) 
AS 

SET NOCOUNT ON 
DECLARE @Status AS TINYINT,
		@Message AS NVARCHAR(100)
		
SET @Status = 0
SET @Message = ''

--IF EXISTS ()
--	BEGIN
--		SET @Status = 1
--		SET @Message = 'HFML000210'
--		GOTO ENDMESS
--	END

ENDMESS:

SELECT @Status AS Status, @Message AS Message 
SET NOCOUNT OFF


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

