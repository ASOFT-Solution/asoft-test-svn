IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4714]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP4714]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


------ Created by Nguyen Van Nhan. Date 13/03/2004
------ Tinh toan du lieu Insert vao cac dong
---- Modified on 13/03/2012 by Lê Thị Thu Hiền : Bổ sung thêm 1 số tiêu thức
---- Modified on 14/01/2013 by Lê Thị Thu Hiền : Bổ sung AND V01.BudgetID = @BudgetID
---- Modified on 11/06/2015 by Bảo Anh : Lấy dữ liệu năm từ tháng bắt đầu niên độ TC
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP4714]
		@DivisionID as nvarchar(50),
		@AccountIDFrom AS nvarchar(50),
		@AccountIDTo AS nvarchar(50),
		@CorAccountIDFrom AS nvarchar(50),
		@CorAccountIDTo AS nvarchar(50),
		@TranMonthFrom AS int,
		@TranYearFrom AS int,
		@TranMonthTo AS int,
		@TranYearTo AS int,
		@Level01ID AS nvarchar(50),
		@Level02ID AS nvarchar(50),	
		@BudgetID AS nvarchar(50),
		@Mode AS nvarchar(20),
		@Sign AS nvarchar(20),				
		@OutputAmount AS decimal(28,8) OUTPUT

AS


DECLARE 	@PeriodFrom INT,
			@PeriodTo INT,
			@Amount as decimal(28,8)


DECLARE	@CorAccountIDFrom1 AS nvarchar(20),
		@CorAccountIDTo1 AS nvarchar(20)

SET @PeriodFrom = @TranYearFrom*100+@TranMonthFrom
SET @PeriodTo = @TranYearTo*100+@TranMonthTo

SET @CorAccountIDFrom1 = @CorAccountIDFrom
SET @CorAccountIDTo1 = @CorAccountIDTo

IF (@CorAccountIDTo1 = '' OR @CorAccountIDTo1 IS NULL)
	SET @CorAccountIDTo1 = @CorAccountIDFrom1

--Print '  @Mode ='+@Mode
--Print ' @Sign = '+@Sign

IF @Mode = 'PA'	-- Period Actual ---So trong ky
    BEGIN
	IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
		SELECT 	@Amount = SUM(V01.SignAmount)
		FROM		AV4710 AS V01
		WHERE 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
				(V01.TransactionTypeID <> 'T00' ) AND
				(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo)
				AND V01.BudgetID = @BudgetID
	ELSE
		SELECT 	@Amount = SUM(V01.SignOriginal)
		FROM		AV4710 AS V01
		WHERE 	(V01.AccountID >= @AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
				(V01.TransactionTypeID <> 'T00' OR V01.TransactionTypeID IS NULL) AND
				(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
				(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
				AND V01.BudgetID = @BudgetID
	IF @Amount IS NULL
		SET @Amount = 0
	
	--IF @Sign = 0 
		--SET @Amount = @Amount*-1
	SET @OutputAmount = @Amount
	RETURN
    END

IF @Mode ='PD'   ---- Lay so phat sinh No
  BEGIN	
	IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
		SELECT 	@Amount = SUM(V01.SignAmount)
		FROM		AV4710 AS V01
		WHERE 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
				(V01.BudgetID = @BudgetID and V01.D_C = 'D') AND				
				(V01.TransactionTypeID <> 'T00' ) AND
				(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo)
				AND V01.BudgetID = @BudgetID
	ELSE
		SELECT 	@Amount = SUM(V01.SignAmount)
		FROM		AV4710 AS V01
		WHERE 	(V01.AccountID >= @AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
				(V01.BudgetID = @BudgetID and V01.D_C = 'D') AND		
				(V01.TransactionTypeID <> 'T00' OR V01.TransactionTypeID IS NULL) AND
				(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
				(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
				AND V01.BudgetID = @BudgetID
	
	IF @Amount IS NULL
		SET @Amount = 0
	--IF @Sign <> 0 
		--SET @Amount = @Amount*-1
	--SET @OutputAmount = @Amount

	SET @OutputAmount = @Amount

	RETURN
  END	

IF @Mode ='PC'   ---- Lay so phat sinh Co
  BEGIN	
	IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
		SELECT 	@Amount = -SUM(V01.SignAmount)
		FROM		AV4710 AS V01
		WHERE 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
				(V01.BudgetID = @BudgetID and V01.D_C = 'C') AND				
				(V01.TransactionTypeID <> 'T00' ) AND
				(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo)
				AND V01.BudgetID = @BudgetID
	ELSE

		SELECT 	@Amount = -SUM(V01.SignAmount)
		FROM		AV4710 AS V01
		WHERE 	(V01.AccountID >= @AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
				(V01.BudgetID = @BudgetID and V01.D_C = 'C') AND		
				(V01.TransactionTypeID <> 'T00' OR V01.TransactionTypeID IS NULL) AND
				(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
				(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
				AND V01.BudgetID = @BudgetID

	IF @Amount IS NULL
		SET @Amount = 0
	--IF @Sign = 0 
	--	SET @Amount = @Amount*-1
	SET @OutputAmount = @Amount
	RETURN
  END	
IF @Mode = 'BA'	-- Period Balance  --- So du No 
    BEGIN
	IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
		SELECT 	@Amount = SUM( V01.SignAmount)
		FROM		AV4710 AS V01
		WHERE 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
				(V01.TranYear*100+V01.TranMonth <= @PeriodTo)
				AND V01.BudgetID = @BudgetID
	ELSE
		SELECT 	@Amount = SUM( V01.SignAmount)
		FROM		AV4710 AS V01
		WHERE 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
				(V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
				(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
				AND V01.BudgetID = @BudgetID
	IF @Amount IS NULL
		SET @Amount = 0
	--IF @Sign = 0 
	--	SET @Amount = @Amount*-1
	SET @OutputAmount = @Amount
	RETURN
    END

IF @Mode = 'BL'	-- Period Balance  --- So du kỳ trước
    BEGIN
	IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
		SELECT 	@Amount = SUM( V01.SignAmount)
		FROM		AV4710 AS V01
		WHERE 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
				(V01.TranYear*100+V01.TranMonth < @PeriodTo)
				AND V01.BudgetID = @BudgetID
	ELSE
		SELECT 	@Amount = SUM( V01.SignAmount)
		FROM		AV4710 AS V01
		WHERE 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
				(V01.TranYear*100+V01.TranMonth < @PeriodTo) AND
				(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
				AND V01.BudgetID = @BudgetID
	IF @Amount IS NULL
		SET @Amount = 0
	--IF @Sign = 0 
	--	SET @Amount = @Amount*-1
	SET @OutputAmount = @Amount
	RETURN
    END

IF @Mode = 'BC'	-- Period Balance  --- So du co 
    BEGIN
	IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
		SELECT 	@Amount = -SUM( V01.SignAmount)
		FROM		AV4710 AS V01
		WHERE 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
				(V01.TranYear*100+V01.TranMonth <= @PeriodTo)
				AND V01.BudgetID = @BudgetID
	ELSE
		SELECT 	@Amount =- SUM( V01.SignAmount)
		FROM		AV4710 AS V01
		WHERE 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
				(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
				(V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
				(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
				AND V01.BudgetID = @BudgetID
	IF @Amount IS NULL
		SET @Amount = 0
	--IF @Sign = 0 
	--	SET @Amount = @Amount*-1
	SET @OutputAmount = @Amount
	RETURN
    END



IF @Mode IN ('YA', 'YC', 'YD')	-- Year To Date
    BEGIN
		Declare @BeginMonth as int
		SELECT @BeginMonth = Month(StartDate) FROM AT1101 WHERE DivisionID = @DivisionID
		IF Isnull(@BeginMonth,0) = 0
			SET @BeginMonth = 1

		IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
			SELECT 	@Amount = SUM( V01.SignAmount)
			FROM		AV4710 AS V01
			WHERE 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
					(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
					(V01.TransactionTypeID <> 'T00' OR V01.TransactionTypeID IS NULL) AND
					(V01.TranYear*100+V01.TranMonth >= @TranYearFrom*100+@BeginMonth AND V01.TranYear*100+V01.TranMonth <= @PeriodTo)
					AND V01.BudgetID = @BudgetID
		ELSE
			SELECT 	@Amount = SUM( V01.SignAmount)
			FROM		AV4710 AS V01
			WHERE 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
					(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
					(V01.TransactionTypeID <> 'T00' OR V01.TransactionTypeID IS NULL) AND
					(V01.TranYear*100+V01.TranMonth >= @TranYearFrom*100+@BeginMonth AND V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
					(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
					AND V01.BudgetID = @BudgetID

		IF @Amount IS NULL
			SET @Amount = 0
		SET @OutputAmount = @Amount
		RETURN
    END






 -- @AccountIDFrom 5111 @AccountIDTo 51Z @ColumnABudget AA @ColumnAType  PC


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON