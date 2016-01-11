/****** Object:  StoredProcedure [dbo].[AP7922]    Script Date: 07/29/2010 12:06:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





----------- Phan cong No.
-----------Lay chi tiet theo doi tuong va theo tai khoan
---------- Phuc vu viec In bang can doi ke toan theo ma phan tich (thang, quy, nam)
---------- Created by Nguyen Minh Thuy, Date 11.10.2006

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7922]
	@DivisionID AS nvarchar(50),
	@AccountIDFrom AS nvarchar(50),
	@AccountIDTo AS nvarchar(50),
	@TranMonth AS INT,
	@TranYear AS INT,
	@Mode AS INT,	
	@OutputAmount AS decimal(28,8) OUTPUT

AS

DECLARE 	@Period INT
DECLARE	@Amount AS decimal(28,8)

SET @Period = @TranYear*100+@TranMonth


SET @Amount = 0
  --- Print ' Hello Thuy'+@AccountIDFrom
--If @AccountIDFrom ='334' 
--   Print ' Van Nhan test'

IF @Mode = 5 	------- Lay so cuoi ky (chi tiet theo doi tuong), So du ben No, So cuoi ky	
	SELECT @Amount = SUM(isnull(ConvertedSum,0))
	FROM 	
		(Select  	V02.AccountID,
			V02.ObjectID,
			Sum(isnull(ConvertedAmount,0)) as ConvertedSum	
		From AV4202 V02
		WHERE 	(V02.DivisionID like @DivisionID) AND
				(V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo) AND
				(V02.TranYear*100+V02.TranMonth <= @Period) 
		Group by V02.AccountID, V02.ObjectID) AS E
		---Having sum(ConvertedAmount)>=0) as E
	WHERE E.ConvertedSum>=0
	
IF @Mode = 6 		------------- lay so du cuoi ky ( chi tiet theo doi tuong va theo tai khoan), So du ben Co
BEGIN
	SELECT @Amount = SUM(isnull(ConvertedSum,0))
	FROM 	
		(Select  	V02.AccountID,
			V02.ObjectID,
			Sum(isnull(ConvertedAmount,0)) as ConvertedSum
		From AV4202 V02
		WHERE 	(V02.DivisionID like @DivisionID) AND
				(V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo) AND
				(V02.TranYear*100+V02.TranMonth <= @Period) 
		Group by V02.AccountID, V02.ObjectID) AS E
		---Having sum(ConvertedAmount)>=0) as E
	WHERE E.ConvertedSum <0  --- So du co
	Set @Amount = @Amount* (-1)
END



IF @Amount IS NULL
	SET @Amount = 0





SET @OutputAmount = @Amount
RETURN