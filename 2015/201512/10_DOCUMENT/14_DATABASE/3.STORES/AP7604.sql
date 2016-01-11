IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7604]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7604]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--------Xu ly in Bang ket qua kinh doanh: Phan I, Lo; Lai
------- Created by Nguyen Van Nhan, Date 12.09.2003
------Edit by Nguyen Quoc Huy, Date 28/11/2006

/**********************************************
** Edited by: [GS] [Cáº©m Loan] [30/07/2010]
					[HoÃ ng PhÆ°á»›c] [08/10/2010] sá»­a INSERT INTO AT7604 ( DivisionID
***********************************************/
--Last Edit by ThiÃªn Huá»³nh  on 21/06/2012: GÃ¡n láº¡i theo @AmountUnit
---- Modified on 22/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị
---- Modified on 27/11/2012 by Lê Thị Thu Hiền : In nhiều đơn vị bị trùng
---- Modified on 2015-04-15 by hoàng vũ : Bổ sung thêm dấu âm/dương hiển thị trên báo

CREATE PROCEDURE [dbo].[AP7604]
			@DivisionID AS nvarchar(50),
			@TranMonthFrom AS INT,
			@TranYearFrom AS INT,
			@TranMonthTo AS INT,
			@TranYearTo AS INT,
			@ReportCode AS nvarchar(50),
			@AmountUnit AS TINYINT,
			@StrDivisionID AS NVARCHAR(4000) = ''

AS

DECLARE @LastTranMonthFrom AS INT,
		@LastTranYearFrom AS INT,
		@LastTranMonthTo AS INT,
		@LastTranYearTo AS INT

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
		@AccuSign AS nvarchar(5),
		@Accumulator AS nvarchar(100),
		@PrintStatus AS TINYINT,
		@PrintCode AS nvarchar(50),
		@Level1 AS tinyint,
		@Notes AS nvarchar(50),
		@Space as int,
		@DisplayedMark      AS TINYINT 


	DELETE AT7604 
	--WHERE DivisionID = @DivisionID  --- XoÂ¸ bÂ¶ng tÂ¹m chÃ¸a bÂ¸o cÂ¸o phÃ‡n lÂ·i lÃ§

IF @TranMonthFrom > 1
    BEGIN	---- Thang truoc do; nam cua ky truoc do
	SET @LastTranMonthTo = @TranMonthFrom -1
	SET @LastTranYearTo = @TranYearFrom
    END
ELSE
    BEGIN
	SET @LastTranMonthTo = 12
	SET @LastTranYearTo = @TranYearFrom -1
    END
------- Xac dinh ky truoc chÂ­a chÃnh xÂ¸c
Set @Space =(@TranMonthTo+@TranYearTo*12) -  (@TranMonthFrom+@TranYearFrom*12)
--Print ' KC :'+str(@Space)
Set @Space=(@LastTranMonthTo+12*@LastTranYearTo)-@Space
---Print str(@Space)
If @Space%12 =0 
Begin
	set @LastTranYearFrom = @Space/12 -1
	Set @LastTranMonthFrom=12
End
Else
Begin
	set @LastTranYearFrom = @Space/12
	Set @LastTranMonthFrom=@Space%12
End

---Print ' Tu: '+str(@LastTranMonthFrom)+'/'+str(@LastTranYearFrom)+ 'den: '+str(@LastTranMonthTo)+'/'+str(@LastTranYearTo)

IF @AmountUnit = 1 SET @ConvertAmountUnit = 1
IF @AmountUnit = 2 SET @ConvertAmountUnit = 10
IF @AmountUnit = 3 SET @ConvertAmountUnit = 100
IF @AmountUnit = 4 SET @ConvertAmountUnit = 1000
IF @AmountUnit = 5 SET @ConvertAmountUnit = 10000
IF @AmountUnit = 6 SET @ConvertAmountUnit = 100000
IF @AmountUnit = 7 SET @ConvertAmountUnit = 1000000

DECLARE @Amount1 AS decimal(28,8),		----- SÃ¨  kÃº trÂ­Ã­c
		@Amount2 AS decimal(28,8),		------ SÃ¨ kÃº nÂµy
		@Amount3 AS decimal(28,8)		------ LuÃ¼ kÃ• Â®Ã‡u nÂ¨m
	
SET @D90T4222Cursor = CURSOR SCROLL KEYSET FOR
	SELECT	T22.LineCode, 	T22.LineDescription,	T22.LineDescriptionE, 	T22.PrintStatus,		
			T22.AccuSign,	T22.Accumulator,		T22.PrintCode,			T22.Level1,			T22.Notes, T22.DisplayedMark
	FROM	AT7602 AS T22
	WHERE	T22.ReportCode = @ReportCode AND
			T22.Type = '01'		-- Part I of the report
			and DivisionID = @DivisionID
OPEN @D90T4222Cursor
FETCH NEXT FROM @D90T4222Cursor INTO
			@LineCode,		@LineDescription, 	@LineDescriptionE, 	@PrintStatus,		@AccuSign,	
			@Accumulator,		@PrintCode,  @Level1, @Notes, @DisplayedMark
WHILE @@FETCH_STATUS = 0
    BEGIN
	
	INSERT INTO AT7604 (
		DivisionID, LineCode,		LineDescription,		LineDescriptionE,		PrintStatus, 		
		Amount1,	Amount2,  		Amount3,	
		AccuSign,	Accumulator,	PrintCode,				Level1,					Notes, DisplayedMark
		)
	    VALUES (
		@DivisionID,@LineCode,		@LineDescription,	@LineDescriptionE, 		@PrintStatus,		
		0,			0,				0,
		@AccuSign,	@Accumulator,	@PrintCode,			isnull(@Level1,3),     @Notes, @DisplayedMark
		)     	

	FETCH NEXT FROM @D90T4222Cursor INTO
			@LineCode,		@LineDescription, 	@LineDescriptionE,  @PrintStatus,		@AccuSign,	
			@Accumulator,		@PrintCode, @Level1, @Notes, @DisplayedMark
    END
CLOSE @D90T4222Cursor
DEALLOCATE @D90T4222Cursor


SET @D90T4222Cursor = CURSOR SCROLL KEYSET FOR
	SELECT	T22.LineCode, 		T22.AccountIDFrom ,	T22.AccountIDTo,	T22.CorAccountIDFrom,
			T22.CorAccountIDTo,	T22.D_C,			T22.AmountSign,		T22.AccuSign,
			T22.Accumulator	
	FROM	AT7602 AS T22
	WHERE	T22.ReportCode = @ReportCode AND
			T22.Type = '01'		-- Part I of the report
			and DivisionID = @DivisionID
OPEN @D90T4222Cursor
FETCH NEXT FROM @D90T4222Cursor INTO
			@LineCode,		@AccountIDFrom,	@AccountIDTo,		@CorAccountIDFrom,	
			@CorAccountIDTo,	@D_C,			@AmountSign,		@AccuSign,
			@Accumulator
WHILE @@FETCH_STATUS = 0
    BEGIN
	SET @Amount1 = 0
	SET @Amount2 = 0
	SET @Amount3 = 0
	
	IF @AmountSign = 0 
	    BEGIN
			---- Chi lay Luy ke phat sinh Co	
		EXEC AP7603	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
					@LastTranMonthFrom, @LastTranYearFrom, @LastTranMonthTo, @LastTranYearTo, 
					5, @D_C, @OutputAmount = @Amount1 OUTPUT ,@StrDivisionID = @StrDivisionID	---- So sÃ¨ trÂ­Ã­c
		EXEC AP7603	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
					@TranMonthFrom, @TranYearFrom, @TranMonthTo, @TranYearTo, 
					5, @D_C, @OutputAmount = @Amount2 OUTPUT ,@StrDivisionID = @StrDivisionID		---- SÃ¨ kÃº  nÂµy
					------ Luy ke tu dau nam
		EXEC AP7603	@DivisionID, @AccountIDFrom, @AccountIDTo,@CorAccountIDFrom, @CorAccountIDTo, 
					1, @TranYearFrom, @TranMonthTo, @TranYearTo, 
					5, @D_C, @OutputAmount = @Amount3 OUTPUT,@StrDivisionID = @StrDivisionID		----- LuÃ¼ kÃ• Â®Ã‡u nÂ¨m
	    END
	
	IF @AmountSign = 1 
	    BEGIN	---- Chi lay luy  ke phat sinh No
		--- Print @AccountIDFrom+ 'To '+ @AccountIDTo +' Cor '+@CorAccountIDFrom+@CorAccountIDTo+' @D_C ='+str(@D_C)
		EXEC AP7603	 	@DivisionID, @AccountIDFrom, @AccountIDTo , @CorAccountIDFrom , @CorAccountIDTo, 
					@LastTranMonthFrom, @LastTranYearFrom, @LastTranMonthTo, @LastTranYearTo, 
					4, @D_C , @OutputAmount = @Amount1 OUTPUT,@StrDivisionID = @StrDivisionID	
		EXEC AP7603	 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
					@TranMonthFrom, @TranYearFrom, @TranMonthTo, @TranYearTo,
					 4, @D_C, @OutputAmount = @Amount2 OUTPUT,@StrDivisionID = @StrDivisionID	
		EXEC AP7603	 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
					1, @TranYearFrom, @TranMonthTo, @TranYearTo, 
					4, @D_C, @OutputAmount = @Amount3 OUTPUT,@StrDivisionID = @StrDivisionID	
	    END

	IF @AmountSign = 2 ---- Ca hai
	    BEGIN	------ Lay so du
		EXEC AP7603	 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
					@LastTranMonthFrom, @LastTranYearFrom, @LastTranMonthTo, @LastTranYearTo, 
					3, @D_C, @OutputAmount = @Amount1 OUTPUT,@StrDivisionID = @StrDivisionID	
		EXEC AP7603	 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, @TranMonthFrom, 
					@TranYearFrom, @TranMonthTo, @TranYearTo, 
					3, @D_C, @OutputAmount = @Amount2 OUTPUT,@StrDivisionID = @StrDivisionID	
		EXEC AP7603	 	@DivisionID, @AccountIDFrom, @AccountIDTo, @CorAccountIDFrom, @CorAccountIDTo, 
					1, @TranYearFrom, @TranMonthTo, @TranYearTo, 
					3, @D_C, @OutputAmount = @Amount3 OUTPUT,@StrDivisionID = @StrDivisionID	
	    END

	
	
	SET @Amount1 = @Amount1/@ConvertAmountUnit
	SET @Amount2 = @Amount2/@ConvertAmountUnit
	SET @Amount3 = @Amount3/@ConvertAmountUnit

	IF (@Amount1<>0 OR @Amount2<>0 OR @Amount3<>0)  ---- cap nhat vao bang luu ket qua
		EXEC AP7602 @DivisionID, @ReportCode, @LineCode, @Amount1, @Amount2, @Amount3, '+', @LineCode	

	FETCH NEXT FROM @D90T4222Cursor INTO
			@LineCode,		@AccountIDFrom,	@AccountIDTo,		@CorAccountIDFrom,	
			@CorAccountIDTo,	@D_C,			@AmountSign,		@AccuSign,
			@Accumulator
    END
CLOSE @D90T4222Cursor

DEALLOCATE @D90T4222Cursor

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

