IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0125]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0125]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- 
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: on:
---- Modified on 
-- <Example>
/*
	
*/
CREATE PROCEDURE MP0125
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@VoucherID VARCHAR(50)	
)
AS
DECLARE @Status TINYINT = 0, @Message VARCHAR(50) = ''

IF EXISTS (SELECT TOP 1 1 FROM AT2007 WHERE DivisionID = @DivisionID AND InheritVoucherID = @VoucherID AND InheritTableID = 'MT0122')
BEGIN
	SET @Status = 1
	SET @Message = 'MFML000271'
END
SELECT @Status [Status], @Message [Message]


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
