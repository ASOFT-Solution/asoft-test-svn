IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0267]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0267]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Kiểm tra sửa / Xóa Công việc
---- Kiểm tra những bảng dữ liệu khác có sử dụng Công việc cho trường hợp xóa
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 27/02/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 27/02/2013 by 
-- <Example>
---- EXEC HP0267 'AS', 'ADMIN', 'ADSG', 1
CREATE PROCEDURE HP0267
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@WorkID AS NVARCHAR(50),
		@IsDelete AS TINYINT	-- 0 : Sửa
								-- 1 : Xóa
) 
AS 
SET NOCOUNT ON 
DECLARE @Status AS TINYINT,
		@Message AS NVARCHAR(100)
		
SET @Status = 0
SET @Message = ''



ENDMESS:

SELECT @Status AS Status, @Message AS Message 
SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

