IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP00972]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP00972]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Xóa tự động phiếu chênh lệch nếu xóa phiếu YCVCNB
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 09/06/2014 by Lê Thị Thu Hiền
---- 
---- Modified on 09/06/2014 by 
-- <Example>
---- 
CREATE PROCEDURE WP00972
( 
		@DivisionID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@UserID AS NVARCHAR(50),
		@VoucherID AS NVARCHAR(50)
) 
AS 
DELETE FROM WT0101 
WHERE DivisionID = @DivisionID 
AND TranMonth = @TranMonth 
AND TranYear = @TranYear 
AND ReVoucherID = @VoucherID

DELETE FROM WT0102
WHERE DivisionID = @DivisionID 
AND TranMonth = @TranMonth 
AND TranYear = @TranYear 
AND ReVoucherID = @VoucherID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

