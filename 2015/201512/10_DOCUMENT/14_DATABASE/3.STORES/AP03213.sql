IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP03213]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP03213]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Cập nhật thông tin chi phí mua hàng và nhập kho khi thực hiện phân bổ chi phí mua hàng[Customize LAVO]
-- <History>
---- Create on 04/03/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
 AP03213 @DivisionID = 'LV', @VoucherID = 'E87C1D15-5811-49E9-8373-15524EBAD115', @TranMonth = 3, @TranYear = 2015, @Status = 0
 */

CREATE PROCEDURE [dbo].[AP03213] 	
	@DivisionID NVARCHAR(50),
	@VoucherID NVARCHAR(50), -- Của chứng từ PBCPMH
	@TranMonth INT,
	@TranYear INT,
	@Status INT -- 0: Add, 1: Edit, 3: Delete
AS

DECLARE @Cur CURSOR,
		@POVoucherID NVARCHAR(50),
		@POTransactionID NVARCHAR(50),
		@ExpenseConvertedAmount DECIMAL(28,8),
		@cCur CURSOR
SET @Status = ISNULL(@Status,0)
IF @Status IN (0,1)
BEGIN
	SET @Cur = CURSOR SCROLL KEYSET FOR
	SELECT DivisionID, POVoucherID, POTransactionID, SUM(ISNULL(ExpenseConvertedAmount,0)) AS ExpenseConvertedAmount
	FROM AT0321
	WHERE DivisionID = @DivisionID AND VoucherID = @VoucherID
	GROUP BY DivisionID, VoucherID, POVoucherID, POTransactionID
	OPEN @Cur
	FETCH NEXT FROM @Cur INTO @DivisionID, @POVoucherID, @POTransactionID, @ExpenseConvertedAmount
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Update chi phí mua hàng AT9000
	UPDATE AT9000 SET 
		ExpenseConvertedAmount = @ExpenseConvertedAmount
	WHERE DivisionID = @DivisionID AND VoucherID = @POVoucherID AND TransactionID = @POTransactionID
	FETCH NEXT FROM @Cur INTO @DivisionID, @POVoucherID, @POTransactionID, @ExpenseConvertedAmount
	END
	CLOSE @Cur
	SET @cCur = CURSOR SCROLL KEYSET FOR
	SELECT AT21.DivisionID, AT21.POVoucherID, AT21.POTransactionID,
		   SUM(ISNULL(ExpenseConvertedAmount,0)) AS ExpenseConvertedAmount, AT20.TranMonth, AT20.TranYear
	FROM AT0321 AT21
	INNER JOIN AT0320 AT20 ON AT20.DivisionID = AT21.DivisionID AND AT20.VoucherID = AT21.VoucherID
	WHERE AT21.DivisionID = @DivisionID AND AT21.VoucherID = @VoucherID
	GROUP BY AT21.DivisionID, AT21.VoucherID, AT21.POVoucherID, AT21.POTransactionID, AT20.TranMonth, AT20.TranYear
	OPEN @cCur
	FETCH NEXT FROM @cCur INTO @DivisionID, @POVoucherID, @POTransactionID, @ExpenseConvertedAmount, @TranMonth, @TranYear
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Thực hiện AP2064 - Cập nhật thông tin phiếu nhập kho
	EXEC AP2064 @DivisionID = @DivisionID, @TranMonth = @TranMonth, @TranYear = @TranYear, @VoucherID = @POVoucherID
	-- Thực hiện AP0034 - Cập nhật thông tin giá nhập kho
	EXEC AP0034 @DivisionID = @DivisionID, @VoucherID = @POVoucherID
	FETCH NEXT FROM @cCur INTO @DivisionID, @POVoucherID, @POTransactionID, @ExpenseConvertedAmount, @TranMonth, @TranYear
	END
	CLOSE @cCur
END
IF @Status = 2
BEGIN
	SET @Cur = CURSOR SCROLL KEYSET FOR
	SELECT DivisionID, POVoucherID, POTransactionID, 0
	FROM AT0321
	WHERE DivisionID = @DivisionID AND VoucherID = @VoucherID
	OPEN @Cur
	FETCH NEXT FROM @Cur INTO @DivisionID, @POVoucherID, @POTransactionID, @ExpenseConvertedAmount
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Update chi phí mua hàng AT9000
	UPDATE AT9000 SET 
		ExpenseConvertedAmount = @ExpenseConvertedAmount
	WHERE DivisionID = @DivisionID AND VoucherID = @POVoucherID AND TransactionID = @POTransactionID
	FETCH NEXT FROM @Cur INTO @DivisionID, @POVoucherID, @POTransactionID, @ExpenseConvertedAmount
	END
	CLOSE @Cur
	SET @cCur = CURSOR SCROLL KEYSET FOR
	SELECT AT21.DivisionID, AT21.POVoucherID, AT21.POTransactionID,
		   0, AT20.TranMonth, AT20.TranYear
	FROM AT0321 AT21
	INNER JOIN AT0320 AT20 ON AT20.DivisionID = AT21.DivisionID AND AT20.VoucherID = AT21.VoucherID
	WHERE AT21.DivisionID = @DivisionID AND AT21.VoucherID = @VoucherID
	OPEN @cCur
	FETCH NEXT FROM @cCur INTO @DivisionID, @POVoucherID, @POTransactionID, @ExpenseConvertedAmount, @TranMonth, @TranYear
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Thực hiện AP2064 - Cập nhật thông tin phiếu nhập kho
	EXEC AP2064 @DivisionID = @DivisionID, @TranMonth = @TranMonth, @TranYear = @TranYear, @VoucherID = @POVoucherID
	-- Thực hiện AP0034 - Cập nhật thông tin giá nhập kho
	EXEC AP0034 @DivisionID = @DivisionID, @VoucherID = @POVoucherID
	FETCH NEXT FROM @cCur INTO @DivisionID, @POVoucherID, @POTransactionID, @ExpenseConvertedAmount, @TranMonth, @TranYear
	END
	CLOSE @cCur
END




GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
