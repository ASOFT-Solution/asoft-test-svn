IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0012]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0012]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Lay ty gia theo ngay
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 03/12/2003 by Nguyen Van Nhan
---- 
---- Modified on 19/09/2011 by Nguyen Binh Minh: Sửa quy tắc lấy tỷ giá
-- <Example>
---- 
CREATE PROCEDURE [dbo].[AP0012] 
(
    @DivisionID    AS NVARCHAR(50),
    @CurrencyID    NVARCHAR(50),
    @ExchangeDate  AS DATETIME
)
AS
DECLARE @ExchangeRate AS MONEY
		
-- Nguyên tắc lấy tỷ giá :
-- 	 + Nếu trong bảng tỷ giá có tỷ giá đúng ngày đó, thì lấy đúng ngày đó, nếu không có thì lấy ngày trước đó
--     -> để nhập tỷ giá từ ngày 20/1 -> 25/1, ngày 26/1 -> 31/1 chỉ cần nhập tỷ giá ngày 20/1 và nhập tỷ giá ngày 26/1
--   + Nếu trong bảng tỷ giá không có tỷ giá nào -> lấy tại bảng loại tiền

SELECT		TOP 1 @ExchangeRate = ExchangeRate
FROM		AT1012
WHERE		CurrencyID = @CurrencyID
			AND DATEDIFF(dd, ExchangeDate, @ExchangeDate) >= 0
			AND DivisionID = @DivisionID
ORDER BY	DATEDIFF(dd, ExchangeDate, @ExchangeDate)

SET @ExchangeRate = COALESCE(@ExchangeRate, (SELECT ExchangeRate FROM AT1004 WHERE CurrencyID = @CurrencyID AND DivisionID = @DivisionID), 0)
	
SELECT @ExchangeRate AS ExchangeRate