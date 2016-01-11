IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0001]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0001]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- Kiểm tra cho phép xóa một phiếu thu - chi - doi tien hay hay khong.
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: Le Quoc Hoai and Nguyen Van Nhan on 07/05/2004
----Modified by To Oanh on 28/07/2010
----Modified on 10/02/2012 by Le Thi Thu Hien : JOIN
----Modified on 12/12/204 by Thanh Sơn: fortmat lại code SQL
-- <Example>
/*   
   DRP4003 
*/

CREATE PROCEDURE AP0001
(
	@DivisionID NVARCHAR(50),
	@TranMonth INT,
	@TranYear INT,
	@VoucherID NVARCHAR(50)
)
AS
DECLARE @Status TINYINT = 0,
		@EMess NVARCHAR(250) = '',
		@VMess NVARCHAR(250) = ''

---1. Kiểm tra đã được phân bổ ở ASOFT-M hay chưa
IF EXISTS (SELECT TOP 1 1 FROM AT9000 INNER JOIN MT1601 on MT1601.PeriodID = AT9000.PeriodID AND MT1601.DivisionID = AT9000.DivisionID
           WHERE AT9000.DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear 
			AND VoucherID = @VoucherID AND TableID = 'AT9000' AND IsDistribute = 1)
BEGIN
	SET @Status = 1
	SET @EMess = 'This voucher have distributed before, so you can not delete!'
	SET @VMess = N'Phiếu này đã được phân bổ, bạn không thể xóa!'
	GOTO ENDMESS
END					
---2. Kiem tra da giai tru cong no hay chua

ENDMESS:
SELECT @Status [Status], @EMess EMess, @VMess VMess

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

