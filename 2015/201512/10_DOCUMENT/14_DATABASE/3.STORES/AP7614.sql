IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7614]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7614]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created on 21/05/2015 by Bảo Anh
--- In báo cáo kết quả kinh doanh nhiều kỳ
--- AP7614 @DivisionID=N'BBL',@TranMonthFrom=1,@TranYearFrom=2015,@TranMonthTo=5,@TranYearTo=2015,@ReportCode=N'B01-KQKD_V',@AmountUnit=1,@StrDivisionID=N'BBL'

CREATE PROCEDURE [dbo].[AP7614]
			@DivisionID AS nvarchar(50),
			@TranMonthFrom AS INT,
			@TranYearFrom AS INT,
			@TranMonthTo AS INT,
			@TranYearTo AS INT,
			@ReportCode AS nvarchar(50),
			@AmountUnit AS TINYINT,
			@StrDivisionID AS NVARCHAR(4000) = ''

AS

DECLARE	@ConvertAmountUnit AS decimal(28,8),
		@D90T4222Cursor AS CURSOR,
		@LineCode AS nvarchar(50),
		@LineDescription AS nvarchar(250),
		@LineDescriptionE AS nvarchar(250),
		@AccountIDFrom AS nvarchar(50),
		@AccountIDTo AS nvarchar(50),
		@CorAccountIDFrom AS nvarchar(50),
		@CorAccountIDTo AS nvarchar(50),
		@AmountSign AS TINYINT,
		@D_C AS TINYINT,
		@AccuSign AS nvarchar(5),
		@Accumulator AS nvarchar(100),
		@PrintStatus AS TINYINT,
		@PrintCode AS nvarchar(50),
		@Level1 AS tinyint,
		@Notes AS nvarchar(50),
		@Space as int,
		@DisplayedMark AS TINYINT,
		@AV9999Cursor AS CURSOR,
		@MonthYear nvarchar(7),
		@TranMonth int,
		@TranYear int,
		@Amount AS decimal(28,8)		

DELETE AT7614

IF @AmountUnit = 1 SET @ConvertAmountUnit = 1
IF @AmountUnit = 2 SET @ConvertAmountUnit = 10
IF @AmountUnit = 3 SET @ConvertAmountUnit = 100
IF @AmountUnit = 4 SET @ConvertAmountUnit = 1000
IF @AmountUnit = 5 SET @ConvertAmountUnit = 10000
IF @AmountUnit = 6 SET @ConvertAmountUnit = 100000
IF @AmountUnit = 7 SET @ConvertAmountUnit = 1000000

INSERT INTO AT7614 (
			DivisionID, LineCode,		LineDescription,		LineDescriptionE,		PrintStatus, MonthYear,		
			Amount,		AccuSign,	Accumulator,	PrintCode,				Level1,					Notes, DisplayedMark, TypeID
			)
SELECT		@DivisionID, T22.LineCode,	T22.LineDescription, T22.LineDescriptionE, T22.PrintStatus,	AV9999.MonthYear,	
			0, T22.AccuSign, T22.Accumulator, T22.PrintCode, isnull(T22.Level1,3), T22.Notes, T22.DisplayedMark,
			(case when Isnull(AccountIDFrom,'') like '51%' or Isnull(AccountIDFrom,'') like '7%' then 'A'
				else case when Isnull(AccountIDFrom,'') like '6%' or Isnull(AccountIDFrom,'') like '8%' or Isnull(AccountIDFrom,'') like '333%' then 'B' else '' end
			end)
FROM	AT7602 AS T22
INNER JOIN (SELECT DivisionID, MonthYear, TranMonth, TranYear from AV9999 Where DivisionID = @DivisionID
		and (TranMonth + TranYear * 100 between @TranMonthFrom + @TranYearFrom * 100 and @TranMonthTo + @TranYearTo * 100)) AV9999			
On		T22.DivisionID = AV9999.DivisionID
WHERE	T22.ReportCode = @ReportCode AND
				T22.Type = '01'		-- Part I of the report
				and T22.DivisionID = @DivisionID

--- Update dòng lợi nhuận sau thuế với TypeID = 'C': lãi/lỗ
UPDATE AT7614 Set TypeID = 'C' WHERE DivisionID = @DivisionID
AND LineCode = (Select top 1 LineCode From AT7614 Where DivisionID = @DivisionID Order by LineCode DESC)

SET @AV9999Cursor = CURSOR SCROLL KEYSET FOR
	SELECT MonthYear, TranMonth, TranYear from AV9999 Where DivisionID = @DivisionID
		and (TranMonth + TranYear * 100 between @TranMonthFrom + @TranYearFrom * 100 and @TranMonthTo + @TranYearTo * 100)
	Order by TranYear, TranMonth
OPEN @AV9999Cursor
FETCH NEXT FROM @AV9999Cursor INTO @MonthYear, @TranMonth, @TranYear
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @D90T4222Cursor = CURSOR SCROLL KEYSET FOR
		SELECT	T22.LineCode, 	T22.LineDescription,	T22.LineDescriptionE, 	T22.PrintStatus,		
				T22.AccuSign,	T22.Accumulator,		T22.PrintCode,			T22.Level1,			T22.Notes, T22.DisplayedMark,
				T22.AccountIDFrom ,	T22.AccountIDTo,	T22.CorAccountIDFrom,
				T22.CorAccountIDTo,	T22.D_C,			T22.AmountSign
		FROM	AT7602 AS T22
		WHERE	T22.ReportCode = @ReportCode AND
				T22.Type = '01'		-- Part I of the report
				and DivisionID = @DivisionID
	OPEN @D90T4222Cursor
	FETCH NEXT FROM @D90T4222Cursor INTO
				@LineCode,		@LineDescription, 	@LineDescriptionE, 	@PrintStatus,		@AccuSign,	
				@Accumulator,		@PrintCode,  @Level1, @Notes, @DisplayedMark,
				@AccountIDFrom,	@AccountIDTo,		@CorAccountIDFrom,	
				@CorAccountIDTo,	@D_C,			@AmountSign
	WHILE @@FETCH_STATUS = 0
	BEGIN	
		SET @Amount = 0
	
		IF @AmountSign = 0
				---- Chi lay Luy ke phat sinh Co	
			EXEC AP7603	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
						@TranMonth, @TranYear, @TranMonth, @TranYear, 
						5, @D_C, @OutputAmount = @Amount OUTPUT ,@StrDivisionID = @StrDivisionID
	
		IF @AmountSign = 1 
			---- Chi lay luy  ke phat sinh No
			EXEC AP7603	 	@DivisionID, @AccountIDFrom, @AccountIDTo , @CorAccountIDFrom , @CorAccountIDTo, 
						@TranMonth, @TranYear, @TranMonth, @TranYear,
						4, @D_C , @OutputAmount = @Amount OUTPUT,@StrDivisionID = @StrDivisionID	
			
		IF @AmountSign = 2 ---- Ca hai
			------ Lay so du
			EXEC AP7603	 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
						@TranMonth, @TranYear, @TranMonth, @TranYear,
						3, @D_C, @OutputAmount = @Amount OUTPUT,@StrDivisionID = @StrDivisionID	
	
		SET @Amount = @Amount/@ConvertAmountUnit
		
			IF @Amount<>0  ---- cap nhat vao bang luu ket qua
				EXEC AP7613 @DivisionID, @ReportCode, @LineCode, @MonthYear, @Amount, '+', @LineCode
	
		FETCH NEXT FROM @D90T4222Cursor INTO
				@LineCode,		@LineDescription, 	@LineDescriptionE, 	@PrintStatus,		@AccuSign,	
				@Accumulator,		@PrintCode,  @Level1, @Notes, @DisplayedMark,
				@AccountIDFrom,	@AccountIDTo,		@CorAccountIDFrom,	
				@CorAccountIDTo,	@D_C,			@AmountSign
	END

	FETCH NEXT FROM @AV9999Cursor INTO @MonthYear, @TranMonth, @TranYear
END

CLOSE @D90T4222Cursor
CLOSE @AV9999Cursor

DEALLOCATE @D90T4222Cursor
DEALLOCATE @AV9999Cursor

SELECT * FROM AT7614
WHERE PrintStatus = 0

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON