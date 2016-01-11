IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4914]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP4914]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


------ Created by Dang Le Bao Quynh. Date 23/05/2007
------ Tinh toan du lieu Insert vao cac dong
---- Modified by on 11/10/2012 by Lê Thị Thu Hiền : Bổ sung thêm strDivisionID
---- Modified by on 02/01/2013 by Lê Thị Thu Hiền : Thay đổi INSERT #DivisionID bằng Bảng tạm A00007
---- Modified on 11/06/2015 by Bảo Anh : Lấy dữ liệu theo thời gian bắt đầu niên độ TC do người dùng định nghĩa

CREATE PROCEDURE [dbo].[AP4914]
		@DivisionID NVARCHAR(50), 
		@AccountIDFrom AS nvarchar(50),
		@AccountIDTo AS nvarchar(50),
		@CorAccountIDFrom AS nvarchar(50),
		@CorAccountIDTo AS nvarchar(50),
		@TranMonthFrom AS int,
		@TranYearFrom AS int,
		@TranMonthTo AS int,
		@TranYearTo AS int,
		@FromDate as datetime,
		@ToDate as datetime,
		@IsDate as tinyint,
		@Level01ID AS nvarchar(50),
		@Level02ID AS nvarchar(50),	
		@BudgetID AS nvarchar(50),
		@PeriodTypeID AS nvarchar(50),
		@Mode AS nvarchar(20),
		@Sign AS nvarchar(20),				
		@OutputAmount AS decimal(28,8) OUTPUT,
		@StrDivisionID AS NVARCHAR(4000) = ''

AS


DECLARE 	@PeriodFrom int,	
			@PeriodTo int,
			@Amount as decimal(28,8)


DECLARE	@CorAccountIDFrom1 AS nvarchar(50),
		@CorAccountIDTo1 AS nvarchar(50)

DECLARE	@DateOfPeriod_Begin as Datetime,
		@DateOfPeriod_End as Datetime

--------------->>>> Chuỗi DivisionID
DECLARE @StrDivisionID_New AS NVARCHAR(4000)
	
SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END
		
DELETE FROM	A00007 WHERE SPID = @@SPID
INSERT INTO A00007(SPID, DivisionID) 
EXEC('SELECT '''+@@SPID+''', DivisionID FROM AT1101 WHERE DivisionID '+@StrDivisionID_New+'')

---------------------<<<<<<<<<< Chuỗi DivisionID

--------------->>>> Các giá trị khai báo cho niên độ TC
DECLARE	@PeriodNum AS int,
		@BeginMonth as int,
		@Month as int,
		@Month1 as int

SELECT @PeriodNum = PeriodNum, @BeginMonth = MONTH(StartDate) FROM AT1101 WHERE DivisionID = @DivisionID
IF ISNULL(@PeriodNum,0) = 0	SET @PeriodNum = 12
IF ISNULL(@BeginMonth,0) = 0	SET @BeginMonth = 1

SELECT top 1 @Month = TranMonth from AV9999 Where DivisionID = @DivisionID
and Quarter = (select Quarter From AV9999 Where DivisionID = @DivisionID and TranMonth = @TranMonthTo and TranYear = @TranYearTo)
Order by TranMonth

SELECT top 1 @Month1 = TranMonth from AV9999 Where DivisionID = @DivisionID
and Quarter = (select Quarter From AV9999 Where DivisionID = @DivisionID and TranMonth = Month(@ToDate) and TranYear = Year(@ToDate))
Order by TranMonth
---------------------<<<<<<<<<< Các giá trị khai báo cho niên độ TC

If @IsDate = 0
	BEGIN
		IF @PeriodTypeID = 'IP' -- Trong ky
			BEGIN
				SET @PeriodFrom = @TranYearFrom*@PeriodNum+@TranMonthFrom
				SET @PeriodTo = @TranYearTo*@PeriodNum+@TranMonthTo
			END
		IF @PeriodTypeID = 'MP' -- Cung ky thang truoc
			BEGIN
				SET @PeriodFrom = ((@TranYearFrom*@PeriodNum+@TranMonthFrom) - 1) - ((@TranYearTo*@PeriodNum+@TranMonthTo) - (@TranYearFrom*@PeriodNum+@TranMonthFrom))
				SET @PeriodTo = (@TranYearFrom*@PeriodNum+@TranMonthFrom) - 1
			END
		IF @PeriodTypeID = 'YP' -- Cung ky nam truoc
			BEGIN
				SET @PeriodFrom = (@TranYearFrom-1)*@PeriodNum+@TranMonthFrom
				SET @PeriodTo = (@TranYearTo-1)*@PeriodNum+@TranMonthTo
			END
		IF @PeriodTypeID = 'TM' -- Luy ke den dau thang (nam nay)
			BEGIN
				SET @PeriodFrom = @TranYearTo*@PeriodNum+@TranMonthTo
				SET @PeriodTo = @TranYearTo*@PeriodNum+@TranMonthTo
			END
		IF @PeriodTypeID = 'TQ' -- Luy ke den dau Quy (nam nay)
			BEGIN
				/*
				IF @TranMonthTo<=3
					SET @PeriodFrom = @TranYearTo*12+1
				IF @TranMonthTo>3 AND @TranMonthTo<=6
					SET @PeriodFrom = @TranYearTo*12+4
				IF @TranMonthTo>6 AND @TranMonthTo<=9
					SET @PeriodFrom = @TranYearTo*12+7
				IF @TranMonthTo>9 AND @TranMonthTo<=12
					SET @PeriodFrom = @TranYearTo*12+10
				*/
				SET @PeriodFrom = @TranYearTo*@PeriodNum+@Month
				SET @PeriodTo = @TranYearTo*@PeriodNum+@TranMonthTo
			END
		IF @PeriodTypeID = 'TY' -- Luy ke den dau nam (nam nay)
			BEGIN
				SET @PeriodFrom = @TranYearTo*@PeriodNum+@BeginMonth
				SET @PeriodTo = @TranYearTo*@PeriodNum+@TranMonthTo
			END
		IF @PeriodTypeID = 'LM' -- Luy ke den dau thang (nam truoc)
			BEGIN
				SET @PeriodFrom = (@TranYearTo-1)*@PeriodNum+@TranMonthTo
				SET @PeriodTo = (@TranYearTo-1)*@PeriodNum+@TranMonthTo
			END
		IF @PeriodTypeID = 'LQ' -- Luy ke den dau quy (nam truoc)
			BEGIN
				/*
				IF @TranMonthTo<=3
					SET @PeriodFrom = (@TranYearTo-1)*12+1
				IF @TranMonthTo>3 AND @TranMonthTo<=6
					SET @PeriodFrom = (@TranYearTo-1)*12+4
				IF @TranMonthTo>6 AND @TranMonthTo<=9
					SET @PeriodFrom = (@TranYearTo-1)*12+7
				IF @TranMonthTo>9 AND @TranMonthTo<=12
					SET @PeriodFrom = (@TranYearTo-1)*12+10
				*/
				SET @PeriodFrom = (@TranYearTo-1)*@PeriodNum+@Month
				SET @PeriodTo = (@TranYearTo-1)*@PeriodNum+@TranMonthTo
			END
		IF @PeriodTypeID = 'LY' -- Luy ke den dau nam (nam truoc)
			BEGIN
				SET @PeriodFrom = (@TranYearTo-1)*@PeriodNum+@BeginMonth
				SET @PeriodTo = (@TranYearTo-1)*@PeriodNum+@TranMonthTo
			END
	END
Else
	BEGIN
		IF @PeriodTypeID = 'IP' -- Trong ky
			BEGIN
				SET @PeriodFrom = (Year(@FromDate)*@PeriodNum+Month(@FromDate))*31+Day(@FromDate)
				SET @PeriodTo = (Year(@ToDate)*@PeriodNum+Month(@ToDate))*31+Day(@ToDate)
			END
		IF @PeriodTypeID = 'MP' -- Cung ky thang truoc
			BEGIN
				SET @PeriodFrom = (Year(@FromDate)*@PeriodNum+(Month(@FromDate)-1))*31+Day(@FromDate)
				SET @PeriodTo = (Year(@ToDate)*@PeriodNum+(Month(@ToDate)-1))*31+Day(@ToDate)
			END
		IF @PeriodTypeID = 'YP' -- Cung ky nam truoc
			BEGIN
				SET @PeriodFrom = ((Year(@FromDate)-1)*@PeriodNum+Month(@FromDate))*31+Day(@FromDate)
				SET @PeriodTo = ((Year(@ToDate)-1)*@PeriodNum+Month(@ToDate))*31+Day(@ToDate)
			END
		IF @PeriodTypeID = 'TM' -- Luy ke den dau thang (nam nay)
			BEGIN
				SET @PeriodFrom = (Year(@ToDate)*@PeriodNum+Month(@ToDate))*31+1
				SET @PeriodTo = (Year(@ToDate)*@PeriodNum+Month(@ToDate))*31+Day(@ToDate)
			END
		IF @PeriodTypeID = 'TQ' -- Luy ke den dau Quy (nam nay)
			BEGIN
				/*
				IF Month(@ToDate)<=3
					SET @PeriodFrom = (Year(@ToDate)*12+1)*31+1
				IF Month(@ToDate)>3 AND Month(@ToDate)<=6
					SET @PeriodFrom = (Year(@ToDate)*12+4)*31+1
				IF Month(@ToDate)>6 AND Month(@ToDate)<=9
					SET @PeriodFrom = (Year(@ToDate)*12+7)*31+1
				IF Month(@ToDate)>9 AND Month(@ToDate)<=12
					SET @PeriodFrom = (Year(@ToDate)*12+10)*31+1
				*/
				SET @PeriodFrom = (Year(@ToDate)*@PeriodNum+@Month1)*31+1
				SET @PeriodTo = (Year(@ToDate)*@PeriodNum+Month(@ToDate))*31+Day(@ToDate)
			END
		IF @PeriodTypeID = 'TY' -- Luy ke den dau nam (nam nay)
			BEGIN
				SET @PeriodFrom = (Year(@ToDate)*@PeriodNum+@BeginMonth)*31+1
				SET @PeriodTo = (Year(@ToDate)*@PeriodNum+Month(@ToDate))*31+Day(@ToDate)
			END
		IF @PeriodTypeID = 'LM' -- Luy ke den dau thang (nam truoc)
			BEGIN
				SET @PeriodFrom = ((Year(@ToDate)-1)*@PeriodNum+Month(@ToDate))*31+1
				SET @PeriodTo = ((Year(@ToDate)-1)*@PeriodNum+Month(@ToDate))*31+Day(@ToDate)
			END
		IF @PeriodTypeID = 'LQ' -- Luy ke den dau quy (nam truoc)
			BEGIN
				/*
				IF Month(@ToDate)<=3
					SET @PeriodFrom = ((Year(@ToDate)-1)*12+1)*31+1
				IF Month(@ToDate)>3 AND Month(@ToDate)<=6
					SET @PeriodFrom = ((Year(@ToDate)-1)*12+4)*31+1
				IF Month(@ToDate)>6 AND Month(@ToDate)<=9
					SET @PeriodFrom = ((Year(@ToDate)-1)*12+7)*31+1
				IF Month(@ToDate)>9 AND Month(@ToDate)<=12
					SET @PeriodFrom = ((Year(@ToDate)-1)*12+10)*31+1
				*/
				SET @PeriodFrom = ((Year(@ToDate)-1)*@PeriodNum+@Month1)*31+1
				SET @PeriodTo = ((Year(@ToDate)-1)*@PeriodNum+Month(@ToDate))*31+Day(@ToDate)
			END
		IF @PeriodTypeID = 'LY' -- Luy ke den dau nam (nam truoc)
			BEGIN
				SET @PeriodFrom = ((Year(@ToDate)-1)*@PeriodNum+@BeginMonth)*31+1
				SET @PeriodTo = ((Year(@ToDate)-1)*@PeriodNum+Month(@ToDate))*31+Day(@ToDate)
			END
	END


SET @CorAccountIDFrom1 = @CorAccountIDFrom
SET @CorAccountIDTo1 = @CorAccountIDTo

IF (@CorAccountIDTo1 = '' OR @CorAccountIDTo1 IS NULL)
	SET @CorAccountIDTo1 = @CorAccountIDFrom1

IF @IsDate = 0 -- In theo ky
	BEGIN
		IF @Mode = 'DB'	-- Du No
			BEGIN
				IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
					BEGIN
						IF @BudgetID = 'BB' -- So du dau
						BEGIN
							
							Set @Amount = (
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)  
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(V01.TranYear*@PeriodNum+V01.TranMonth < @PeriodFrom) 
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)   
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) 
									)
							
				
						END
						
						IF @BudgetID = 'AI' -- So phat sinh tang 
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)  
								and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount>=0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo)
						END
				
						IF @BudgetID = 'AD' -- So phat sinh giam
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)  
								and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount<0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo)
						END
				
						IF @BudgetID = 'EB' -- So du cuoi
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)  
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth  <= @PeriodTo)
						END
				
						IF @BudgetID = 'BQ' -- So du dau so luong
						BEGIN
							Set @Amount = (
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)  
										and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(V01.TransactionTypeID <> 'T03' ) AND
										(V01.TransactionTypeID <> 'T04' ) AND
										(V01.TranYear*@PeriodNum+V01.TranMonth < @PeriodFrom) 
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)  
										and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) 
									)
						END
		
						IF @BudgetID = 'QI' -- So phat sinh tang so luong
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)  
								and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity>=0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo)
						END
				
						IF @BudgetID = 'QD' -- So phat sinh giam so luong
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity<0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo)
						END
				
						IF @BudgetID = 'EQ' -- So du cuoi so luong
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth  <= @PeriodTo)
						END
					END
				ELSE
					BEGIN
						IF @BudgetID = 'BB'
						BEGIN
							Set @Amount = (
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)
										and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(V01.TranYear*@PeriodNum+V01.TranMonth < @PeriodFrom) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1) 
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)
										and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1) 
									)
		
						END
						
						IF @BudgetID = 'AI'
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)
								and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount>=0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
		
						END
				
						IF @BudgetID = 'AD'
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount<0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
				
						IF @BudgetID = 'EB'
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth  <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
							
						END
				
						IF @BudgetID = 'BQ' -- So du dau so luong
						BEGIN
							Set @Amount = (
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
										and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(V01.TransactionTypeID <> 'T03' ) AND
										(V01.TransactionTypeID <> 'T04' ) AND
										(V01.TranYear*@PeriodNum+V01.TranMonth < @PeriodFrom) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01

									WHERE V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
										and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
									)
						END
				
		
						IF @BudgetID = 'QI' -- So phat sinh tang so luong
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity>=0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
				
						IF @BudgetID = 'QD' -- So phat sinh giam so luong
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity<0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
				
						IF @BudgetID = 'EQ' -- So du cuoi so luong
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth  <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
					END
		
				IF @Amount IS NULL
					SET @Amount = 0
				
				SET @OutputAmount = @Amount
				
				RETURN
		
			END
		
		--********************************************************************************
		
		IF @Mode = 'CB'	-- Du Co
			BEGIN
				IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
					BEGIN
						IF @BudgetID = 'BB' -- So du dau
						BEGIN
							Set @Amount = -((
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)
										and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(V01.TranYear*@PeriodNum+V01.TranMonth < @PeriodFrom) 
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)
										and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) 
									))
				
						END
						
						IF @BudgetID = 'AI' -- So phat sinh tang 
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)
									and 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount<0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo)
						END
				
						IF @BudgetID = 'AD' -- So phat sinh giam
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount>=0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo)
						END
				
						IF @BudgetID = 'EB' -- So du cuoi
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth  <= @PeriodTo)
						END
				
						IF @BudgetID = 'BQ' -- So du dau so luong
						BEGIN
							Set @Amount =- ((
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)
										and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(V01.TransactionTypeID <> 'T03' ) AND
										(V01.TransactionTypeID <> 'T04' ) AND
										(V01.TranYear*@PeriodNum+V01.TranMonth < @PeriodFrom) 
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)
										 and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) 
									))
						END
				
		
						IF @BudgetID = 'QI' -- So phat sinh tang so luong
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity<0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo)
						END
				
						IF @BudgetID = 'QD' -- So phat sinh giam so luong
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity>=0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo)
						END
				
						IF @BudgetID = 'EQ' -- So du cuoi so luong
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth  <= @PeriodTo)
						END
					END
				ELSE
					BEGIN
						IF @BudgetID = 'BB'
						BEGIN
							Set @Amount =- ((
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
										and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(V01.TranYear*@PeriodNum+V01.TranMonth < @PeriodFrom) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1) 
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
										and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1) 
									))
		
						END
						
						IF @BudgetID = 'AI'
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
									and 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount<0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
		
						END
				
						IF @BudgetID = 'AD'
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
									and 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND

									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount>=0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
				
						IF @BudgetID = 'EB'
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) 
									and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth  <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
							
						END
				
						IF @BudgetID = 'BQ' -- So du dau so luong
						BEGIN
							Set @Amount =- ((
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(V01.TransactionTypeID <> 'T03' ) AND
										(V01.TransactionTypeID <> 'T04' ) AND
										(V01.TranYear*@PeriodNum+V01.TranMonth < @PeriodFrom) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
									))
						END
				
		
						IF @BudgetID = 'QI' -- So phat sinh tang so luong
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity<0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
				
						IF @BudgetID = 'QD' -- So phat sinh giam so luong
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity>=0) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth >= @PeriodFrom AND V01.TranYear*@PeriodNum+V01.TranMonth <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
				
						IF @BudgetID = 'EQ' -- So du cuoi so luong
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.TranYear*@PeriodNum+V01.TranMonth  <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
					END
		
				IF @Amount IS NULL
					SET @Amount = 0
				
				SET @OutputAmount = @Amount
				
				RETURN
		
			END
	END

Else -- In theo ngay

	BEGIN
		IF @Mode = 'DB'	-- Du No
			BEGIN
				IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
					BEGIN
						IF @BudgetID = 'BB' -- So du dau
						BEGIN
							
							Set @Amount = (
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and  (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) < @PeriodFrom) 
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) 
									)
							
				
						END
						
						IF @BudgetID = 'AI' -- So phat sinh tang 
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount>=0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo)
						END
				
						IF @BudgetID = 'AD' -- So phat sinh giam
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount<0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo)
						END
				
						IF @BudgetID = 'EB' -- So du cuoi
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate))  <= @PeriodTo)
						END
				
						IF @BudgetID = 'BQ' -- So du dau so luong
						BEGIN
							Set @Amount = (
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(V01.TransactionTypeID <> 'T03' ) AND
										(V01.TransactionTypeID <> 'T04' ) AND
										(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) < @PeriodFrom) 
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) 
									)
						END
				
		
						IF @BudgetID = 'QI' -- So phat sinh tang so luong
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity>=0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo)
						END
				
						IF @BudgetID = 'QD' -- So phat sinh giam so luong
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity<0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo)
						END
				
						IF @BudgetID = 'EQ' -- So du cuoi so luong
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate))  <= @PeriodTo)
						END
					END
				ELSE
					BEGIN
						IF @BudgetID = 'BB'
						BEGIN
							Set @Amount = (
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) < @PeriodFrom) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1) 
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1) 
									)
		
						END
						
						IF @BudgetID = 'AI'
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount>=0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
		
						END
				
						IF @BudgetID = 'AD'
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount<0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
				
						IF @BudgetID = 'EB'
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate))  <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
							
						END
				
						IF @BudgetID = 'BQ' -- So du dau so luong
						BEGIN
							Set @Amount = (
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(V01.TransactionTypeID <> 'T03' ) AND
										(V01.TransactionTypeID <> 'T04' ) AND
										(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) < @PeriodFrom) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01

									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
									)
						END
				
		
						IF @BudgetID = 'QI' -- So phat sinh tang so luong
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity>=0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
				
						IF @BudgetID = 'QD' -- So phat sinh giam so luong
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity<0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
				
						IF @BudgetID = 'EQ' -- So du cuoi so luong
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate))  <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
					END
		
				IF @Amount IS NULL
					SET @Amount = 0
				
				SET @OutputAmount = @Amount
				
				RETURN
		
			END
		
		--********************************************************************************
		
		IF @Mode = 'CB'	-- Du Co
			BEGIN
				IF (@CorAccountIDFrom1 ='%' OR @CorAccountIDFrom1 ='' OR @CorAccountIDFrom1 IS NULL)
					BEGIN
						IF @BudgetID = 'BB' -- So du dau
						BEGIN
							Set @Amount = -((
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) < @PeriodFrom) 
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) 
									))
				
						END
						
						IF @BudgetID = 'AI' -- So phat sinh tang 
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount<0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo)
						END
				
						IF @BudgetID = 'AD' -- So phat sinh giam
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount>=0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo)
						END
				
						IF @BudgetID = 'EB' -- So du cuoi
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate))  <= @PeriodTo)
						END
				
						IF @BudgetID = 'BQ' -- So du dau so luong
						BEGIN
							Set @Amount =- ((
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(V01.TransactionTypeID <> 'T03' ) AND
										(V01.TransactionTypeID <> 'T04' ) AND
										(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) < @PeriodFrom) 
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) 
									))
						END
				
		
						IF @BudgetID = 'QI' -- So phat sinh tang so luong
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity<0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo)
						END
				
						IF @BudgetID = 'QD' -- So phat sinh giam so luong
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity>=0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo)
						END
				
						IF @BudgetID = 'EQ' -- So du cuoi so luong
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate))  <= @PeriodTo)
						END
					END
				ELSE
					BEGIN
						IF @BudgetID = 'BB'
						BEGIN
							Set @Amount =- ((
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) < @PeriodFrom) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1) 
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignAmount,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1) 
									))
		
						END
						
						IF @BudgetID = 'AI'
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount<0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
		
						END
				
						IF @BudgetID = 'AD'
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.SignAmount>=0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
				
						IF @BudgetID = 'EB'
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignAmount,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate))  <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
							
						END
				
						IF @BudgetID = 'BQ' -- So du dau so luong
						BEGIN
							Set @Amount =- ((
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID <> 'T00' ) AND
										(V01.TransactionTypeID <> 'T03' ) AND
										(V01.TransactionTypeID <> 'T04' ) AND
										(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) < @PeriodFrom) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
									)
									+
									(
									SELECT Isnull(SUM(isnull(V01.SignQuantity,0)),0)
									FROM	Av4910 AS V01
									WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
										(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
										(V01.TransactionTypeID = 'T00' ) AND
										(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
									))
						END
				
		
						IF @BudgetID = 'QI' -- So phat sinh tang so luong
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE 	 V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and (V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity<0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
				
						IF @BudgetID = 'QD' -- So phat sinh giam so luong
						BEGIN
							SELECT 	@Amount = Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(V01.SignQuantity>=0) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) >= @PeriodFrom AND ((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate)) <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
				
						IF @BudgetID = 'EQ' -- So du cuoi so luong
						BEGIN
							SELECT 	@Amount = - Isnull(SUM(isnull(V01.SignQuantity,0)),0)
							FROM		Av4910 AS V01
							WHERE  V01.DivisionID IN ( SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) and 	(V01.AccountID >=@AccountIDFrom AND V01.AccountID <=@AccountIDTo) AND
									(V01.Level01 = @Level01ID AND V01.Level02 = @Level02ID) AND
									--(V01.TransactionTypeID <> 'T00' ) AND
									(V01.TransactionTypeID <> 'T03' ) AND
									(V01.TransactionTypeID <> 'T04' ) AND
									(((Year(V01.VoucherDate)*@PeriodNum + Month(V01.VoucherDate))*31 + Day(V01.VoucherDate))  <= @PeriodTo) AND
									(V01.CorAccountID >=@CorAccountIDFrom1 AND V01.CorAccountID <=@CorAccountIDTo1)
						END
					END
		
				IF @Amount IS NULL
					SET @Amount = 0
				
				SET @OutputAmount = @Amount
				
				RETURN
		
			END
	END

DELETE FROM	A00007 WHERE SPID = @@SPID
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON