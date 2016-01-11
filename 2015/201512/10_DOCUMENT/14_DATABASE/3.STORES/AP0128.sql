IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0128]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0128]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Kiểm tra tồn tại danh mục CI
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by:Thanh Sơn on: 23/04/2015
---- Modified on 
-- <Example>
/*
	AP0128 'AS', 'ADMIN', '', 'StandardID'
*/
CREATE PROCEDURE AP0128
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@CheckTypeID VARCHAR(50),
	@CheckID VARCHAR(50),
	@DataType VARCHAR(50)
)
AS
DECLARE @Status TINYINT = 0,
		@Message varchar(50)

IF @DataType = 'StandardID'
BEGIN
	IF EXISTS (SELECT TOP 1 1 FROM AT1323 WHERE DivisionID = @DivisionID AND StandardTypeID = @CheckTypeID AND StandardID = @CheckID)
	BEGIN
		SET @Status = 1
		SET @Message = 'CFML000183'
	END	
END

SELECT @Status [Status], @Message [Message]

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
