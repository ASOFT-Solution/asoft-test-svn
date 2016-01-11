IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7603]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7603]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


------	Xu ly so lieu; tinh toan len bang ke qua kinh doanh; phan lai+lo. 
------ 	Duoc goi tu AP7604
------ 	Created by Nguyen Van Nhan, Date 12.09.2003.
-------	Last Update 25.02.2005

/**********************************************
** Edited by: [GS] [Cáº©m Loan] [30/07/2010]
***********************************************/
---- Modified on 22/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị
---- Modified by on 02/01/2013 by Lê Thị Thu Hiền : Thay đổi INSERT #DivisionID bằng Bảng tạm A00007
---- Modified by on 08/05/2013 by Bao Quynh : Bo sung chi tiet theo doi tuong, @Sign=2: Ben No, @Sign=3: Ben Co
CREATE PROCEDURE [dbo].[AP7603]
				@DivisionID AS nvarchar(50),			
				@AccountIDFrom AS nvarchar(50),		
				@AccountIDTo AS nvarchar(50),	
				@CorAccountIDFrom AS nvarchar(50),		
				@CorAccountIDTo AS nvarchar(50),
				@TranMonthFrom AS INT,			
				@TranYearFrom AS INT,				
				@TranMonthTo AS INT,				
				@TranYearTo AS INT,	
				@Mode AS INT,
				@Sign AS TINYINT,				
				@OutputAmount AS decimal(28,8) OUTPUT,
				@StrDivisionID AS NVARCHAR(4000) = ''
				
AS
DECLARE @PeriodFrom INT,	
		@PeriodTo INT

DECLARE	@CorAccountIDFrom1 AS nvarchar(50),
		@CorAccountIDTo1 AS nvarchar(50)
DECLARE	@Amount AS decimal(28,8)


SET @PeriodFrom = @TranYearFrom*100+@TranMonthFrom
SET @PeriodTo = @TranYearTo*100+@TranMonthTo

--------------->>>> Chuỗi DivisionID
DECLARE @StrDivisionID_New AS NVARCHAR(4000)
	
SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END
		
DELETE FROM	A00007 WHERE SPID = @@SPID
INSERT INTO A00007(SPID, DivisionID) 
EXEC('SELECT '''+@@SPID+''', DivisionID FROM AT1101 WHERE DivisionID '+@StrDivisionID_New+'')

---------------------<<<<<<<<<< Chuỗi DivisionID
SET @CorAccountIDFrom1 = @CorAccountIDFrom
SET @CorAccountIDTo1 = @CorAccountIDTo
IF (@CorAccountIDTo1 = '' OR @CorAccountIDTo1 IS NULL)
	SET @CorAccountIDTo1 = @CorAccountIDFrom1

SET @Amount = 0

IF @Mode = 1 		----- So du dau nam
BEGIN
		BEGIN
			IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
				SELECT 	@Amount = SUM(V01.ConvertedAmount)
				FROM	AV4201 AS V01
				WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
						(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
						( V01.TransactionTypeID='T00' or  (V01.TranYear*100+V01.TranMonth < @PeriodFrom) )
			ELSE
				SELECT 	@Amount = SUM(V01.ConvertedAmount)
				FROM		AV4201 AS V01
				WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
						(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
						( V01.TransactionTypeID='T00' or  (V01.TranYear*100+V01.TranMonth < @PeriodFrom) ) AND
						(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
		END
	
	GOTO RETURN_VALUES
END

IF @Mode = 3 		----- truong hop lay ca hai ben;  
BEGIN
	IF @Sign<=1
		BEGIN
			IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
				SELECT 	@Amount = SUM(isnull(V01.ConvertedAmount,0))
				FROM		AV4201 AS V01
				WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
						(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
						(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo)
			ELSE
				SELECT 	@Amount = SUM(Isnull(V01.ConvertedAmount,0))
				FROM		AV4201 AS V01
				WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
						(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
						(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
						(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
		END
	ELSE
		BEGIN
			IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
				SELECT	@Amount = SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										V02.ObjectID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TranYear*100+V02.TranMonth >= @PeriodFrom AND V02.TranYear*100+V02.TranMonth <= @PeriodTo)
        	 				GROUP BY	V02.AccountID, V02.ObjectID
						) AS E
				WHERE (@Sign=2 AND ConvertedClosing>=0) OR (@Sign=3 AND ConvertedClosing<0)
			ELSE
				SELECT	@Amount = SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										V02.ObjectID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TranYear*100+V02.TranMonth >= @PeriodFrom AND V02.TranYear*100+V02.TranMonth <= @PeriodTo)
										AND (V02.CorAccountID >=@CorAccountIDFrom1 AND V02.CorAccountID <=@CorAccountIDTo1)
        	 				GROUP BY	V02.AccountID, V02.ObjectID
						) AS E
				WHERE (@Sign=2 AND ConvertedClosing>=0) OR (@Sign=3 AND ConvertedClosing<0)		
		END				
	GOTO RETURN_VALUES
END

IF @Mode = 4 		-------Lay so phat sinh No
BEGIN
	IF @Sign<=1
		BEGIN
			IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
				SELECT 	@Amount = SUM(V01.ConvertedAmount)
				FROM		AV4201 AS V01
				WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
						(V01.TransactionTypeID <>'T00') AND
						(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND				
						(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
						(V01.D_C = 'D')
			ELSE
				SELECT 	@Amount = SUM(V01.ConvertedAmount)
				FROM		AV4201 AS V01
				WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
						(V01.TransactionTypeID <>'T00') AND
						(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
						(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
						(V01.D_C = 'D') AND
						(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
		END
	ELSE
		BEGIN
			IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
				SELECT	@Amount = SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										V02.ObjectID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TranYear*100+V02.TranMonth >= @PeriodFrom AND V02.TranYear*100+V02.TranMonth <= @PeriodTo)
										AND (V02.D_C = 'D')
        	 				GROUP BY	V02.AccountID, V02.ObjectID
						) AS E

			ELSE
				SELECT	@Amount = SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										V02.ObjectID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TranYear*100+V02.TranMonth >= @PeriodFrom AND V02.TranYear*100+V02.TranMonth <= @PeriodTo)
										AND (V02.D_C = 'D')
										AND (V02.CorAccountID >=@CorAccountIDFrom1 AND V02.CorAccountID <=@CorAccountIDTo1)
        	 				GROUP BY	V02.AccountID, V02.ObjectID
						) AS E
		END			
	GOTO RETURN_VALUES
END

IF @Mode = 5 		------ Lay so phat sinh co
BEGIN
	IF @Sign<=1
		BEGIN
			IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
				SELECT 	@Amount = SUM(V01.ConvertedAmount)
				FROM		AV4201 AS V01
				WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
						(V01.TransactionTypeID <>'T00') AND
						(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
						(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
						(V01.D_C = 'C')
			ELSE
				SELECT 	@Amount = SUM(V01.ConvertedAmount)
				FROM		AV4201 AS V01
				WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
						(V01.TransactionTypeID <>'T00') AND
						(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
						(V01.TranYear*100+V01.TranMonth >= @PeriodFrom AND V01.TranYear*100+V01.TranMonth <= @PeriodTo) AND
						(V01.D_C = 'C') AND
						(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)

		END
	ELSE
		BEGIN
			IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
				SELECT	@Amount = SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										V02.ObjectID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TranYear*100+V02.TranMonth >= @PeriodFrom AND V02.TranYear*100+V02.TranMonth <= @PeriodTo)
										AND (V02.D_C = 'C')
        	 				GROUP BY	V02.AccountID, V02.ObjectID
						) AS E

			ELSE
				SELECT	@Amount = SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										V02.ObjectID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TranYear*100+V02.TranMonth >= @PeriodFrom AND V02.TranYear*100+V02.TranMonth <= @PeriodTo)
										AND (V02.D_C = 'C')
										AND (V02.CorAccountID >=@CorAccountIDFrom1 AND V02.CorAccountID <=@CorAccountIDTo1)
        	 				GROUP BY	V02.AccountID, V02.ObjectID
						) AS E
		END
	GOTO RETURN_VALUES
END

IF @Mode = 6 		
BEGIN
	IF @Sign <= 1
	BEGIN
		IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
			SELECT 	@Amount = SUM(V01.ConvertedAmount)
			FROM		AV4201 AS V01
			WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
					(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
					((V01.TranYear*100+V01.TranMonth <= @TranYearTo*100+@TranMonthTo) OR 
					V01.TransactionTypeID = 'T00' )
		ELSE
			SELECT 	@Amount = SUM(V01.ConvertedAmount)
			FROM		AV4201 AS V01
			WHERE 	(V01.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) AND
					(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
							 ((V01.TranYear*100+V01.TranMonth <= @TranYearTo*100+@TranMonthTo) OR 
					V01.TransactionTypeID = 'T00') AND
					(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
	END
	ELSE
	BEGIN
		IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
				SET @Amount = 
				(SELECT	SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										V02.ObjectID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TransactionTypeID='T00' or (V02.TranYear * 100 + V02.TranMonth <= @TranYearTo*100+@TranMonthTo))
        	 				GROUP BY	V02.AccountID, V02.ObjectID
						) AS E
				WHERE (@Sign=2 AND ConvertedClosing>=0) OR (@Sign=3 AND ConvertedClosing<0))
				-
				(SELECT	SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										V02.ObjectID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TransactionTypeID='T00' or (V02.TranYear * 100 + V02.TranMonth < @TranYearFrom*100+@TranMonthFrom))
        	 				GROUP BY	V02.AccountID, V02.ObjectID
						) AS E
				WHERE (@Sign=2 AND ConvertedClosing>=0) OR (@Sign=3 AND ConvertedClosing<0))		
			ELSE
				SET @Amount = 
				(SELECT	SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										V02.ObjectID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TransactionTypeID='T00' or (V02.TranYear * 100 + V02.TranMonth <= @TranYearTo*100+@TranMonthTo))
										AND (V02.CorAccountID >=@CorAccountIDFrom1 AND V02.CorAccountID <=@CorAccountIDTo1)
        	 				GROUP BY	V02.AccountID, V02.ObjectID
						) AS E
				WHERE (@Sign=2 AND ConvertedClosing>=0) OR (@Sign=3 AND ConvertedClosing<0))
				-
				(SELECT	SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										V02.ObjectID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TransactionTypeID='T00' or (V02.TranYear * 100 + V02.TranMonth < @TranYearFrom*100+@TranMonthFrom))
										AND (V02.CorAccountID >=@CorAccountIDFrom1 AND V02.CorAccountID <=@CorAccountIDTo1)
        	 				GROUP BY	V02.AccountID, V02.ObjectID
						) AS E
				WHERE (@Sign=2 AND ConvertedClosing>=0) OR (@Sign=3 AND ConvertedClosing<0))		
	END			
	GOTO RETURN_VALUES
END

--Chi tiet theo tai khoan
IF @Mode = 7 		
BEGIN
	IF @Sign <= 1
	BEGIN
		IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
				SET @Amount = 
				(SELECT	SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TransactionTypeID='T00' or (V02.TranYear * 100 + V02.TranMonth <= @TranYearTo*100+@TranMonthTo))
        	 				GROUP BY	V02.AccountID
						) AS E
				WHERE (@Sign=0 AND ConvertedClosing>=0) OR (@Sign=1 AND ConvertedClosing<0))
				-
				(SELECT	SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TransactionTypeID='T00' or (V02.TranYear * 100 + V02.TranMonth < @TranYearFrom*100+@TranMonthFrom))
        	 				GROUP BY	V02.AccountID
						) AS E
				WHERE (@Sign=0 AND ConvertedClosing>=0) OR (@Sign=1 AND ConvertedClosing<0))		
			ELSE
				SET @Amount = 
				(SELECT	SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TransactionTypeID='T00' or (V02.TranYear * 100 + V02.TranMonth <= @TranYearTo*100+@TranMonthTo))
										AND (V02.CorAccountID >=@CorAccountIDFrom1 AND V02.CorAccountID <=@CorAccountIDTo1)
        	 				GROUP BY	V02.AccountID
						) AS E
				WHERE (@Sign=0 AND ConvertedClosing>=0) OR (@Sign=1 AND ConvertedClosing<0))
				-
				(SELECT	SUM(isnull(ConvertedClosing,0))
				FROM	(	SELECT		V02.AccountID,
										SUM(ConvertedAmount) AS ConvertedClosing
        	 				FROM		AV4202 V02
							WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
										AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
										AND (V02.TransactionTypeID='T00' or (V02.TranYear * 100 + V02.TranMonth < @TranYearFrom*100+@TranMonthFrom))
										AND (V02.CorAccountID >=@CorAccountIDFrom1 AND V02.CorAccountID <=@CorAccountIDTo1)
        	 				GROUP BY	V02.AccountID
						) AS E
				WHERE (@Sign=0 AND ConvertedClosing>=0) OR (@Sign=1 AND ConvertedClosing<0))		
	END			
	GOTO RETURN_VALUES
END

RETURN_VALUES:
				
IF @Amount IS NULL
	SET @Amount = 0

IF @Sign In (1,3)
	SET @Amount = @Amount*-1


SET @OutputAmount = @Amount
RETURN


DELETE FROM	A00007 WHERE SPID = @@SPID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

