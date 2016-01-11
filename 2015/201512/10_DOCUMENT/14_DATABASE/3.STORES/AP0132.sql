IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0132]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0132]
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
	AP0132 'AS', 'ADMIN', '', ''
*/
CREATE PROCEDURE AP0132
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@CheckID VARCHAR(50),
	@DataType VARCHAR(50)
)
AS
DECLARE @Status TINYINT = 0
IF @DataType = 'StandardTypeID'
BEGIN
	SET @Status = 0
END
IF @DataType = 'StandardID'
BEGIN
	IF EXISTS (SELECT TOP 1 1 FROM AT0128 WHERE DivisionID = @DivisionID AND StandardTypeID = @CheckID)
	SET @Status = 1
END

SELECT @Status

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
