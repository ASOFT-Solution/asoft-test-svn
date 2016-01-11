IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0003]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0003]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- 
-- <Param>
---- Automatic create New ID keys hang loat
-- <Return>
---- 
-- <Reference>
---- AP0000
-- <History>
---- Create on 28/02/2012 by Nguyen Binh Minh
-- <Example>
---- 
CREATE PROCEDURE [DBO].[AP0003]
(
	@DivisionID   NVARCHAR(50),
	@IGEID AS VARCHAR(20), -- Gia tri chuoi cong vao. VD: IT...
	@TableName AS VARCHAR(20), -- AT9000
	@TotalKeys AS INT, -- Tong so khoa muon danh rieng
	@KeyString AS VARCHAR(20) OUTPUT,
	@KeyFrom AS INT OUTPUT,
	@KeyTo AS INT OUTPUT	
)
AS

SET NOCOUNT ON
SET @KeyString = @IGEID + @DivisionID

INSERT INTO AT4444 (DivisionID, TableName, KeyString, LastKey)
	SELECT @DivisionID, @TableName, @KeyString, 0
	WHERE NOT EXISTS(SELECT TOP 1 1 FROM AT4444 WHERE DivisionID = @DivisionID AND TableName = @TableName AND KeyString = @KeyString)

UPDATE	AT4444
SET		@KeyFrom = LastKey + 1,
		@KeyTo = LastKey + @TotalKeys,
		LastKey = LastKey + @TotalKeys
WHERE	DivisionID = @DivisionID AND TableName = @TableName AND KeyString = @KeyString

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

