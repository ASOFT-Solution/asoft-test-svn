/****** Object:  StoredProcedure [dbo].[AP7921]    Script Date: 08/02/2010 11:53:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/


ALTER PROCEDURE [dbo].[AP7921]
	@DivisionID AS nvarchar(50),			
	@AccountIDFrom AS nvarchar(50),		
	@AccountIDTo AS nvarchar(50),					
	@TranMonth AS INT,				
	@TranYear AS INT,		
	@Mode AS INT,			
	@OutputAmount AS decimal(28,8) OUTPUT

AS

DECLARE 	@Period INT
DECLARE	@Amount AS Decimal(28,8)

SET @Amount = 0


SET @Period = @TranYear*100+@TranMonth
--If @AccountIDFrom  like '111%' 
--Print ' van Nhan @AccountIDFrom :' +@AccountIDFrom+' @Mode ' +str(@Mode)
SET @Amount = 0


IF @Mode = 1 		   -------- Con so tong hop, So Cuoi ky, Lay so du No
    BEGIN	
		SELECT 	@Amount = SUM(isnull(V01.ConvertedAmount,0))
		FROM		AV4201 AS V01
		WHERE 	(V01.DivisionID like @DivisionID) AND
				(V01.AccountID >= @AccountIDFrom AND V01.AccountID <= @AccountIDTo) AND
				(V01.TranYear*100+V01.TranMonth <= @Period)

		
		--If @Amount<0 
			--Set @Amount = @Amount*(-1)	
		GOTO RETURN_VALUES
    END

IF @Mode =2 		   -------- Con so tong hop, So Cuoi ky, Lay so du Co
    BEGIN	
		SELECT 	@Amount = isnull(SUM(isnull(V01.ConvertedAmount,0)*(-1)),0)
		FROM		AV4201 AS V01
		WHERE 	(V01.DivisionID like @DivisionID) AND
				(V01.AccountID >= @AccountIDFrom AND V01.AccountID <= @AccountIDTo) AND
				(V01.TranYear*100+V01.TranMonth <= @Period)
		--If @Amount<0 
			--Set @Amount = @Amount*(-1)	
		GOTO RETURN_VALUES
    END

IF @Mode  = 3 		------- So chi tiet theo tai khoan (Du No) , so cuoi ky
    BEGIN
		---Print ' Begin ' 
		SELECT 	@Amount = isnull(SUM(isnull(X.ConvertedAmount,0)),0)
		FROM		(SELECT 	V01.AccountID, SUM(isnull(V01.ConvertedAmount,0)) AS ConvertedAmount
				FROM		AV4202 AS V01
				WHERE 	(V01.DivisionID like @DivisionID) AND
						(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
						(V01.TranYear*100+V01.TranMonth <= @Period)
				GROUP BY	V01.AccountID) AS X
		WHERE	X.ConvertedAmount >= 0   ---- Phai la du No
		Set @Amount = isnull(@Amount,0)
	--Print ' Nhan' 
	GOTO RETURN_VALUES
 END


IF @Mode = 4 		------ Chi tiet theo tai khoan ( du Co), so du cuoi  ky 
    BEGIN	--If @AccountIDFrom ='331' 
			---Print ' Nhan test '+ @AccountIDTo
		SELECT 	@Amount = - isnull(SUM(isnull(X.ConvertedAmount,0)),0)
		FROM		(SELECT 	V01.AccountID, SUM(isnull(V01.ConvertedAmount,0)) AS ConvertedAmount
				FROM		AV4202 AS V01
				WHERE 	(V01.DivisionID like @DivisionID) AND
						(V01.AccountID >= @AccountIDFrom AND V01.AccountID <= @AccountIDTo) AND
						(V01.TranYear*100+V01.TranMonth <= @Period)
				GROUP BY	V01.AccountID) AS X
		WHERE	X.ConvertedAmount < 0

	GOTO RETURN_VALUES
    END

RETURN_VALUES:
----Print ' From '+@AccountIDFrom+' @Mode'+str(@Mode)+' To : @AccountIDTo ' +@AccountIDTo
---Print ' @Amount ='+str(@Amount)
SET @OutputAmount = @Amount
RETURN