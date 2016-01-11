IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7606]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7606]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



----- Bang xac dinh ket qua kinh doanh
------ Thuc hien nghia vu voi nha nuoc
------ Created by Nguyen Van Nhan, Date 12.09.2003
----- Edit by Nguyen Quoc Huy, Date 28/11/2006

/**********************************************
** Edited by: [GS] [Cáº©m Loan] [30/07/2010]
					[HoÃ ng PhÆ°á»›c] [08/10/2010] sá»­a INSERT INTO AT7604 ( DivisionID
***********************************************/
--Last Edit by ThiÃªn Huá»³nh  on 21/06/2012: GÃ¡n láº¡i theo @AmountUnit
---- Modified on 22/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị
---- Modified on 27/11/2012 by Lê Thị Thu Hiền : In nhiều DivisionID bị trùng

CREATE PROCEDURE [dbo].[AP7606]
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
		@AccuSign AS nvarchar(50),
		@Accumulator AS nvarchar(50),
		@PrintStatus AS TINYINT,
		@PrintCode AS nvarchar(50),
		@ColStatus01 AS TINYINT, 	
		@ColStatus02 AS TINYINT,	
		@ColStatus03 AS TINYINT,	
		@ColStatus04 AS TINYINT, 	
		@ColStatus05 AS TINYINT,	
		@ColStatus06 AS TINYINT,
		@Notes	 AS nvarchar(50)


DELETE AT7606
--WHERE DivisionID = @DivisionID   --- Bang tam


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
	SELECT  LineCode,  LineDescription,  LineDescriptionE,   PrintStatus, AccuSign, Accumulator, PrintCode, Notes
	FROM AT7602  WHERE	 ReportCode = @ReportCode AND Type = '02' and DivisionID = @DivisionID		

OPEN @D90T4222Cursor
FETCH NEXT FROM @D90T4222Cursor INTO
			@LineCode,		@LineDescription, 	@LineDescriptionE, 	@PrintStatus,		@AccuSign,	
			@Accumulator,		@PrintCode, @Notes
WHILE @@FETCH_STATUS = 0
    BEGIN
	
	INSERT INTO AT7606	 (
		DivisionID, LineCode,		LineDescription,		LineDescriptionE,		PrintStatus, 		Amount1,	
		Amount2,  	Amount3,	AccuSign,		Accumulator,		PrintCode,		Amount4,	Amount5,	Amount6, Notes
		)
	    VALUES (
		@DivisionID, @LineCode,		@LineDescription,	@LineDescriptionE,	@PrintStatus,		0,		0,		0,
		@AccuSign,		@Accumulator,		@PrintCode, 		0,		0, 		0, @Notes
		)     	

	FETCH NEXT FROM @D90T4222Cursor INTO
			@LineCode,		@LineDescription, 	@LineDescriptionE, 	@PrintStatus,		@AccuSign,	@Accumulator,
			@PrintCode, @Notes
    END
CLOSE @D90T4222Cursor
DEALLOCATE @D90T4222Cursor


DECLARE @Amount1 AS decimal(28,8),		
		@Amount2 AS decimal(28,8),		
		@Amount3 AS decimal(28,8),		
		@Amount4 AS decimal(28,8),		
		@Amount5 AS decimal(28,8),		
		@Amount6 AS decimal(28,8),		
		@TypeID  AS nvarchar(50)

SET @D90T4222Cursor = CURSOR SCROLL KEYSET FOR
	SELECT	LineCode, AccountIDFrom, AccountIDTo,	CorAccountIDFrom,
			CorAccountIDTo, D_C, AmountSign,  AccuSign,
			Accumulator, ColStatus01, ColStatus02, ColStatus03, ColStatus04,	ColStatus05, ColStatus06	
	FROM AT7602  WHERE	ReportCode = @ReportCode  AND Type = '02' and DivisionID = @DivisionID


OPEN @D90T4222Cursor
FETCH NEXT FROM @D90T4222Cursor INTO
			@LineCode,		@AccountIDFrom,	@AccountIDTo,		@CorAccountIDFrom,	
			@CorAccountIDTo,	@D_C,			@AmountSign ,		@AccuSign ,
			@Accumulator,		@ColStatus01, 		@ColStatus02, 		@ColStatus03, 		@ColStatus04, 		@ColStatus05, 		@ColStatus06 

---	Note 	@AmountSign la phat sinh No (1) hay Co (0),  So du (2)
--- 	Note 	@D_C de xac dinh so du No hay co

WHILE @@FETCH_STATUS = 0
    BEGIN
	
	SET @Amount1 = 0
	SET @Amount2 = 0
	SET @Amount3 = 0
	SET @Amount4 = 0
	SET @Amount5 = 0
	SET @Amount6 = 0

	If   @AmountSign = 2  and @D_C = 1  --- So du Co
		Set @TypeID = 'BC'
	If   @AmountSign = 2  and @D_C = 0  --- So du No
		Set @TypeID ='BD'
	If  @AmountSign = 1 set @TypeID ='PD'
	If  @AmountSign = 0 set @TypeID ='PC'

	IF @ColStatus01 = 1		---- Cot so 1
		EXEC AP7600 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo,
					1, 1900, @LastTranMonthTo, @LastTranYearTo, @TypeID, @OutputAmount = @Amount1 OUTPUT, @StrDivisionID = @StrDivisionID
	IF @ColStatus02 = 1
		EXEC AP7600 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo,
			@TranMonthFrom,@TranYearFrom, @TranMonthTo, @TranYearTo, @TypeID, @OutputAmount = @Amount2 OUTPUT, @StrDivisionID = @StrDivisionID
	
	IF @ColStatus03 = 1
		EXEC AP7600 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo,
				@TranMonthFrom,@TranYearFrom, @TranMonthTo, @TranYearTo, @TypeID, @OutputAmount = @Amount3 OUTPUT, @StrDivisionID = @StrDivisionID
	
	IF @ColStatus04 = 1
		EXEC AP7600 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo,
				1 , @TranYearFrom, @TranMonthTo, @TranYearTo, @TypeID, @OutputAmount = @Amount4 OUTPUT, @StrDivisionID = @StrDivisionID
	IF @ColStatus05 = 1
	      	EXEC AP7600 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo,
				1 , @TranYearFrom, @TranMonthTo, @TranYearTo, @TypeID, @OutputAmount = @Amount5 OUTPUT, @StrDivisionID = @StrDivisionID
	IF @ColStatus06= 1
		EXEC AP7600 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo,
				@TranMonthFrom,@TranYearFrom, @TranMonthTo, @TranYearTo, @TypeID, @OutputAmount = @Amount6 OUTPUT, @StrDivisionID = @StrDivisionID
	
	
	SET @Amount1 = @Amount1/@ConvertAmountUnit
	SET @Amount2 = @Amount2/@ConvertAmountUnit
	SET @Amount3 = @Amount3/@ConvertAmountUnit
	SET @Amount4 = @Amount4/@ConvertAmountUnit
	SET @Amount5 = @Amount5/@ConvertAmountUnit
	SET @Amount6 = @Amount6/@ConvertAmountUnit


--		print 'null'

	IF (@Amount1<>0 OR @Amount2<>0 OR @Amount3<>0 OR @Amount4<>0 OR @Amount5<>0 OR @Amount6<>0)
		EXEC AP7605 @DivisionID,@ReportCode, @LineCode, @Amount1, @Amount2, @Amount3, @Amount4, @Amount5, @Amount6, '+', @LineCode	

	FETCH NEXT FROM @D90T4222Cursor INTO
			@LineCode,		@AccountIDFrom,	@AccountIDTo,		@CorAccountIDFrom,	
			@CorAccountIDTo,	@D_C,			@AmountSign,		@AccuSign,
			@Accumulator,		@ColStatus01, 		@ColStatus02, 		@ColStatus03, 
			@ColStatus04, 		@ColStatus05, 		@ColStatus06 
    END
CLOSE @D90T4222Cursor
DEALLOCATE @D90T4222Cursor

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

