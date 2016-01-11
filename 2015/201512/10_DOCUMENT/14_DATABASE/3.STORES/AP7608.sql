IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7608]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7608]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




----- In phÃ‡n II Khau tru: mien giam thue cÃ±a BÂ¸o cÂ¸o kÃ•t quÂ¶ kinh doanh.
---- Created by Nguyen Van Nhan, Dat 12.09.2003
---- Edit Nguyen Quoc Huy, Date 28/11/2006

/**********************************************
** Edited by: [GS] [Cáº©m Loan] [30/07/2010]
					[HoÃ ng PhÆ°á»›c] [08/10/2010] sá»­a INSERT INTO AT7604 ( DivisionID
***********************************************/
--Last Edit by ThiÃªn Huá»³nh  on 21/06/2012: GÃ¡n láº¡i theo @AmountUnit
---- Modified on 22/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị
---- Modified on 27/11/2012 by Lê Thị Thu Hiền : In nhiều đơn vị bị trùng

CREATE PROCEDURE [dbo].[AP7608]
	@DivisionID AS nvarchar(50),
	@TranMonthFrom AS INT,
	@TranYearFrom AS INT,
	@TranMonthTo AS INT,
	@TranYearTo AS INT,
	@ReportCode AS nvarchar(50),
	@AmountUnit AS TINYINT,
	@StrDivisionID AS NVARCHAR(4000) = ''

AS


DECLARE @LastTranMonthTo AS INT,
		@LastTranYearTo AS INT,
		@NumMonths AS INT


DECLARE	@ConvertAmountUnit AS decimal(28,8)


DECLARE @D90T4222Cursor AS CURSOR,
		@LineCode AS nvarchar(50),
		@LineDescription AS nvarchar(250),
		@LineDescriptionE AS nvarchar(250),
		@AccountIDFrom AS nvarchar(50),
		@AccountIDTo AS nvarchar(50),
		@CorAccountIDFrom AS nvarchar(50),
		@CorAccountIDTo AS nvarchar(50),
		@AmountSign AS TINYINT,
		@D_C AS TINYINT,
		@PeriodAmount AS TINYINT,
		@AccuSign AS nvarchar(5),
		@Accumulator AS nvarchar(100),
		@PrintStatus AS TINYINT,
		@PrintCode AS nvarchar(50),
		@Level as tinyint,
		@IsLastPeriod as tinyint,
		@Notes AS nvarchar(250) 


DELETE AT7608
--Where DivisionID = @DivisionID


SET @NumMonths = @TranYearTo*12+@TranMonthTo - @TranYearFrom*12+@TranMonthFrom +1
IF @TranMonthFrom > 1
    BEGIN
	SET @LastTranMonthTo = @TranMonthFrom -1
	SET @LastTranYearTo = @TranYearFrom
    END
ELSE
    BEGIN
	SET @LastTranMonthTo = 12
	SET @LastTranYearTo = @TranYearFrom -1
    END

IF @AmountUnit = 1 SET @ConvertAmountUnit = 1
IF @AmountUnit = 2 SET @ConvertAmountUnit = 10
IF @AmountUnit = 3 SET @ConvertAmountUnit = 100
IF @AmountUnit = 4 SET @ConvertAmountUnit = 1000
IF @AmountUnit = 5 SET @ConvertAmountUnit = 10000
IF @AmountUnit = 6 SET @ConvertAmountUnit = 100000
IF @AmountUnit = 7 SET @ConvertAmountUnit = 1000000

SET @D90T4222Cursor = CURSOR SCROLL KEYSET FOR
	SELECT	T22.LineCode , 		T22.LineDescription,	T22.LineDescriptionE,	T22.PrintStatus,		T22.AccuSign,	
			T22.Accumulator,	T22.PrintCode, Level1, T22.Notes
	FROM AT7602 AS T22
	WHERE	T22.ReportCode = @ReportCode AND T22.PrintStatus =0 and
			T22.Type = '03'		-- Part II of the report
			and DivisionID = @DivisionID
OPEN @D90T4222Cursor
FETCH NEXT FROM @D90T4222Cursor INTO
			@LineCode,		@LineDescription, 	@LineDescriptionE, 	@PrintStatus,		@AccuSign,	
			@Accumulator,		@PrintCode, @Level, @Notes
WHILE @@FETCH_STATUS = 0
    BEGIN
	
	INSERT INTO AT7608  (
		DivisionID, LineCode,		LineDescription,		LineDescriptionE,		PrintStatus, 		Amount1,	Amount2,  	
		AccuSign,		Accumulator,		PrintCode, Level1, 		Notes
		)
	    VALUES (
		@DivisionID, @LineCode,		@LineDescription,	@LineDescriptionE,	@PrintStatus ,		0,		0,
		@AccuSign,		@Accumulator,		@PrintCode, @Level ,	@Notes		
		)     	

	FETCH NEXT FROM @D90T4222Cursor INTO
			@LineCode,		@LineDescription, 	@LineDescriptionE, 	@PrintStatus,		@AccuSign,	@Accumulator,
			@PrintCode, @Level, @Notes
    END
CLOSE @D90T4222Cursor
DEALLOCATE @D90T4222Cursor


	DECLARE 	@Amount1 AS decimal(28,8),		
			@Amount2 AS decimal(28,8)		

SET @D90T4222Cursor = CURSOR SCROLL KEYSET FOR
	SELECT	T22.LineCode, 		T22.AccountIDFrom,	T22.AccountIDTo,	T22.CorAccountIDFrom,
			T22.CorAccountIDTo,	T22.D_C,		T22.AmountSign,	T22.AccuSign,
			T22.Accumulator,	T22.PeriodAmount, isnull(IsLastPeriod,0)
	FROM AT7602 AS T22
	WHERE	T22.ReportCode = @ReportCode AND
			T22.Type = '03'		-- Part III of the report
			and DivisionID = @DivisionID
OPEN @D90T4222Cursor
FETCH NEXT FROM @D90T4222Cursor INTO
			@LineCode,		@AccountIDFrom,	@AccountIDTo,		@CorAccountIDFrom,	
			@CorAccountIDTo,	@D_C,			@AmountSign,		@AccuSign,
			@Accumulator,		@PeriodAmount , @IsLastPeriod
WHILE @@FETCH_STATUS = 0
    BEGIN
	SET @Amount1 = 0
	SET @Amount2 = 0
	
	IF @PeriodAmount = 0   --- Lay so du dau ky, cac chi tieu 10, 20, 30, 40, 50
	    BEGIN
		--Print str(@LastTranMonthTo) +' Code :'+ @LineCode+ ' @LastTranYearTo '+str(@LastTranYearTo)
		EXEC AP7603 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
						1, 1900, @LastTranMonthTo, @LastTranYearTo , 3, @D_C , @OutputAmount = @Amount1 OUTPUT,@StrDivisionID = @StrDivisionID
		SET @Amount2 = 0
	    END
	ELSE		
	    BEGIN
		---If @LineCode ='11'
			---Print ' @AmountSign ' +str(@AmountSign)+ '  @AccountIDFrom ' +@AccountIDFrom +' @AccountIDTo '+@AccountIDTo+' @CorAccountIDFrom '+@CorAccountIDFrom+'@D_C'+str(@D_C)
		IF @AmountSign = 0
		    BEGIN
			EXEC AP7603 @DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
				@TranMonthFrom, @TranYearFrom, @TranMonthTo, @TranYearTo, 5, @D_C, @OutputAmount = @Amount1 OUTPUT,@StrDivisionID = @StrDivisionID
			EXEC AP7603 @DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
				'1', @TranYearFrom, @TranMonthTo, @TranYearTo, 5, @D_C, @OutputAmount = @Amount2 OUTPUT,@StrDivisionID = @StrDivisionID
		    END
		IF @AmountSign = 1
		    BEGIN
			EXEC AP7603 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
					@TranMonthFrom , @TranYearFrom, @TranMonthTo, @TranYearTo, 4, @D_C , @OutputAmount = @Amount1 OUTPUT,@StrDivisionID = @StrDivisionID
			EXEC AP7603 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
					'1', @TranYearFrom, @TranMonthTo, @TranYearTo, 4, @D_C, @OutputAmount = @Amount2 OUTPUT,@StrDivisionID = @StrDivisionID
		    END
		IF @AmountSign = 2
		    BEGIN
			EXEC AP7603 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
					@TranMonthFrom, @TranYearFrom, @TranMonthTo, @TranYearTo, 3, @D_C, @OutputAmount = @Amount1 OUTPUT,@StrDivisionID = @StrDivisionID
			EXEC AP7603 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
					'1', @TranYearFrom, @TranMonthTo, @TranYearTo, 3, @D_C, @OutputAmount = @Amount2 OUTPUT,@StrDivisionID = @StrDivisionID
		    END
	    END
	
	
	SET @Amount1 = @Amount1/@ConvertAmountUnit
	SET @Amount2 = @Amount2/@ConvertAmountUnit

	IF (@Amount1<>0 OR @Amount2<>0)
		EXEC AP7607  @DivisionID,@ReportCode, @LineCode, @Amount1, @Amount2, '+', @LineCode	

	FETCH NEXT FROM @D90T4222Cursor INTO
			@LineCode,		@AccountIDFrom,	@AccountIDTo,		@CorAccountIDFrom,	
			@CorAccountIDTo,	@D_C,			@AmountSign,		@AccuSign,
			@Accumulator,		@PeriodAmount,@IsLastPeriod
    END
CLOSE @D90T4222Cursor
DEALLOCATE @D90T4222Cursor


UPDATE 	AT7608
SET		Amount2 = 0
WHERE	LineCode in ('10', '17', '20', '23', '30', '33', '40', '46')
		and DivisionID = @DivisionID


If  @LastTranYearTo <>@TranYearFrom
	Update AT7604 set Amount1  = 0
	Where DivisionID = @DivisionID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

