IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1020]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1020]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <SUMmary>
---- Cập nhật tình trạng hợp đồng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Modified ON 17/02/2012 by Nguyễn Bình Minh (TT1967): Sửa đổi lấy theo mã phân tích thiết lập động
---- Modified on 12/03/2012 by Nguyễn Bình Minh (TT2125): 
----    Sửa tương ứng với thiết lập cập nhật hợp đồng mua tương ứng với thiết lập mã phân tích mua, hợp đồng bán tương ứng với thiết lập mã phân tích bán
-- <Example>
---- 
CREATE PROCEDURE AP1020
( 
	@DivisionID NVARCHAR(50), 
	@AnaID NVARCHAR(50)
)	
AS	

DECLARE @CurrencyID AS NVARCHAR(50),
		@ContractType AS tinyint, --0:mua, 1:bán
		@ContractDetailID AS NVARCHAR(50),
		@PaymentAmount AS decimal(28,8),
		@TotalAmount AS decimal(28,8),
		@RemainAmount AS decimal(28,8),
		@Cur AS CURSOR
		
DECLARE @ContractAnaTypeID AS NVARCHAR(50)
		
SELECT TOP 1 @CurrencyID = CurrencyID, @ContractType = ContractType FROM AT1020
WHERE DivisionID = @DivisionID AND ContractNo = @AnaID

SET @ContractAnaTypeID = ISNULL((SELECT TOP 1 (CASE WHEN @ContractType = 0 THEN ContractAnaTypeID ELSE SalesContractAnaTypeID END) FROM AT0000 WHERE DefDivisionID = @DivisionID), 'A03')

IF @ContractType = 0 --HD mua
BEGIN
	SET @TotalAmount = 
		ISNULL((SELECT SUM(ISNULL(OriginalAmountCN,0)) FROM AT9000 
		WHERE	CASE	WHEN @ContractAnaTypeID = 'A01' THEN Ana01ID
						WHEN @ContractAnaTypeID = 'A02' THEN Ana02ID
						WHEN @ContractAnaTypeID = 'A03' THEN Ana03ID
						WHEN @ContractAnaTypeID = 'A04' THEN Ana04ID
						WHEN @ContractAnaTypeID = 'A05' THEN Ana05ID
				END = @AnaID 
				AND	CurrencyIDCN = @CurrencyID AND 
				CreditAccountID LIKE '11%'),0) 
		-		
		ISNULL((SELECT SUM(ISNULL(OriginalAmountCN,0)) FROM AT9000 
		WHERE	CASE	WHEN @ContractAnaTypeID = 'A01' THEN Ana01ID
						WHEN @ContractAnaTypeID = 'A02' THEN Ana02ID
						WHEN @ContractAnaTypeID = 'A03' THEN Ana03ID
						WHEN @ContractAnaTypeID = 'A04' THEN Ana04ID
						WHEN @ContractAnaTypeID = 'A05' THEN Ana05ID
				END = @AnaID 
				AND CurrencyIDCN = @CurrencyID AND 
				DebitAccountID LIKE '11%'),0) 
END

IF @ContractType = 1 --HD ban
BEGIN
	SET @TotalAmount = 
		ISNULL((SELECT SUM(ISNULL(OriginalAmountCN,0)) FROM AT9000 
		WHERE	CASE	WHEN @ContractAnaTypeID = 'A01' THEN Ana01ID
						WHEN @ContractAnaTypeID = 'A02' THEN Ana02ID
						WHEN @ContractAnaTypeID = 'A03' THEN Ana03ID
						WHEN @ContractAnaTypeID = 'A04' THEN Ana04ID
						WHEN @ContractAnaTypeID = 'A05' THEN Ana05ID
				END = @AnaID 
				AND CurrencyIDCN = @CurrencyID AND 
				DebitAccountID LIKE '11%'),0) 
		-		
		ISNULL((SELECT SUM(ISNULL(OriginalAmountCN,0)) FROM AT9000 
		WHERE	CASE	WHEN @ContractAnaTypeID = 'A01' THEN Ana01ID
						WHEN @ContractAnaTypeID = 'A02' THEN Ana02ID
						WHEN @ContractAnaTypeID = 'A03' THEN Ana03ID
						WHEN @ContractAnaTypeID = 'A04' THEN Ana04ID
						WHEN @ContractAnaTypeID = 'A05' THEN Ana05ID
				END = @AnaID 
				AND CurrencyIDCN = @CurrencyID AND 
				CreditAccountID LIKE '11%'),0) 
END
SET @RemainAmount = @TotalAmount	
SET @Cur = Cursor Static For	
SELECT AT1021.ContractDetailID, AT1021.PaymentAmount
FROM AT1020 
INNER JOIN AT1021 
		ON AT1020.ContractID = AT1021.ContractID AND AT1020.DivisionID = AT1021.DivisionID
WHERE 	AT1020.DivisionID = @DivisionID AND
		AT1020.ContractNo = @AnaID			
ORDER BY StepID
OPEN @Cur
FETCH NEXT FROM @Cur INTO @ContractDetailID, @PaymentAmount
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @RemainAmount<@PaymentAmount
	BEGIN
		UPDATE AT1021 SET Paymented = @RemainAmount, PaymentStatus = 0
		WHERE DivisionID = @DivisionID AND ContractDetailID = @ContractDetailID
		SET @RemainAmount = 0
	END
	Else
	BEGIN
		UPDATE AT1021 SET Paymented = @PaymentAmount, PaymentStatus = 1
		WHERE DivisionID = @DivisionID AND ContractDetailID = @ContractDetailID
		SET @RemainAmount = @RemainAmount - @PaymentAmount
	END	
	FETCH NEXT FROM @Cur INTO @ContractDetailID, @PaymentAmount
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

