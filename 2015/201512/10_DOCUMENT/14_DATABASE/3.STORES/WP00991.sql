IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP00991]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP00991]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Store UPDATE các phiếu chuyển từ POS
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 10/06/2014 by Lê Thị Thu Hiền
---- 
---- Modified on 10/06/2014 by 
-- <Example>
---- 
CREATE PROCEDURE WP00991
( 
		@DivisionID AS NVARCHAR(50),
		@TranMonth AS INT, 
		@TranYear AS INT,
		@UserID AS NVARCHAR(50),
		@VoucherID AS NVARCHAR(50),
		@Mode AS TINYINT -- 0-Bỏ duyệt 1-Duyệt
) 
AS 
IF @Mode = 1
UPDATE POST0022
SET Status = 1
WHERE	DivisionID = @DivisionID
		AND APK = (SELECT TOP 1 InheritVoucherID FROM WT0096 WHERE WT0096.DivisionID = @DivisionID AND  WT0096.VoucherID = @VoucherID)

IF @Mode = 0
UPDATE POST0022
SET Status = 0
WHERE APK = (SELECT TOP 1 InheritVoucherID FROM WT0096 WHERE WT0096.DivisionID = @DivisionID AND  WT0096.VoucherID = @VoucherID)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

