IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0252]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0252]
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

-- <Summary>
---- Load các dữ liệu tương ứng lên màn hình đánh giá chênh lệch tỷ giá xuất
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 07/09/2011 by Nguyễn Bình Minh
---- 
---- Modified on 05/12/2011 by Nguyễn Bình Minh: Bổ sung trường hợp tỷ giá bình quân cuối kỳ
-- <Example>
---- EXEC AP0252 'AS', 0, 1, 2011, '2011/01/01', '2011/01/31', 'vi-VN', 1
CREATE PROCEDURE [DBO].[AP0252]
(
	@DivisionID AS NVARCHAR(50),
	@TimeMode AS TINYINT, -- 0: Theo ngày, 1: Theo kỳ
	@TranMonth AS TINYINT,	
	@TranYear AS INT,
	@FromDate AS DATETIME,
	@ToDate AS DATETIME,
	@Language AS NVARCHAR(50),
	@ActionMode AS TINYINT -- 0: Load Tài khoản, 1: Load loại tiền
) 
AS
SET NOCOUNT ON

IF @ActionMode = 0
BEGIN
	SELECT		AccountID, CASE WHEN @Language = 'vi-VN' THEN AccountName ELSE AccountNameE END AS AccountName
	FROM		AT1005
	WHERE		DivisionID = @DivisionID AND GroupID = 'G01'
	ORDER BY 	AccountID
END

IF @ActionMode = 1
BEGIN	
	DECLARE @ExpCurExchDiffAccType AS TINYINT,
			@BaseCurrencyID AS NVARCHAR(50)
			
	-- Lấy loại chênh lệch tỷ giá xuất
	SELECT	TOP 1 
			@ExpCurExchDiffAccType = ExpCurExchDiffAccType,
			@BaseCurrencyID = CurrencyID 
	FROM	AT0000 
	WHERE DefDivisionID = @DivisionID	

	IF @ExpCurExchDiffAccType = 0 -- Xuất theo tỷ giá thực tế
	BEGIN					
		SELECT		CurrencyID, CurrencyName, ExchangeRate
		FROM		AT1004
		WHERE		DivisionID = @DivisionID AND [Disabled] = 0 AND CurrencyID <> @BaseCurrencyID
		ORDER BY	CurrencyID
	END

	IF @ExpCurExchDiffAccType = 1 -- Xuất theo tỷ giá hạch toán
	BEGIN				
		SELECT		CurrencyID, MAX(TranMonth + TranYear * 100) AS Period
		INTO		#LastExchangeDate 
		FROM		AT1012
		WHERE		DivisionID = @DivisionID AND TranMonth + TranYear * 100 <= @TranMonth + @TranYear * 100 AND ExchangeDate IS NULL
		GROUP BY	CurrencyID
		         	 	
		SELECT		CUR.CurrencyID, CUR.CurrencyName, ISNULL(EX.ExchangeRate, CUR.ExchangeRate) AS ExchangeRate
		FROM		AT1004 CUR
		LEFT JOIN	(	SELECT		EX.CurrencyID, EX.ExchangeRate
		         		FROM		AT1012 EX
		         		INNER JOIN	#LastExchangeDate LEX
		         				ON	LEX.CurrencyID = EX.CurrencyID AND EX.TranMonth + EX.TranYear * 100 = LEX.Period     					
		         	 	WHERE		EX.DivisionID = @DivisionID AND EX.ExchangeDate IS NULL
					) EX
				ON	EX.CurrencyID = CUR.CurrencyID
		WHERE		CUR.DivisionID = @DivisionID AND CUR.[Disabled] = 0 AND CUR.CurrencyID <> @BaseCurrencyID AND CUR.[Disabled] = 0
		ORDER BY	CUR.CurrencyID
	END

	IF @ExpCurExchDiffAccType = 2 -- Xuất theo tỷ giá bình quân cuối kỳ
	BEGIN					
		SELECT		CurrencyID, CurrencyName, 0 AS ExchangeRate
		FROM		AT1004
		WHERE		DivisionID = @DivisionID AND [Disabled] = 0 AND CurrencyID <> @BaseCurrencyID
		ORDER BY	CurrencyID
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
