/****** Object:  StoredProcedure [dbo].[AP7912]    Script Date: 04/16/2013 14:38:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- <Summary>
---- Lấy số liệu tính toán lên BCĐKT
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 19.08.2003 by Nguyen Van Nhan
---- Modified on 29/07/2010 by Hoàng Phước
---- Modified on 23/12/2011 by Nguyễn Bình Minh: bổ sung các mode
---- Modified on 22/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị
---- Modified by on 02/01/2013 by Lê Thị Thu Hiền : Thay đổi INSERT #DivisionID bằng Bảng tạm A00007
-- <Example>
---- 
ALTER PROCEDURE [dbo].[AP7912]
(
	@DivisionID AS NVARCHAR(50),
	@AccountIDFrom AS NVARCHAR(50),
	@AccountIDTo AS NVARCHAR(50),
	@TranMonthFrom AS INT,
	@TranYearFrom AS INT,
	@TranMonthTo AS INT,
	@TranYearTo AS INT,
	@Mode AS INT, 
	@OutputAmount AS DECIMAL(28, 8) OUTPUT,
	@StrDivisionID AS NVARCHAR(4000) = '',
	@AV4202 As TypeOfAV4202 READONLY
)	
AS
	
DECLARE @PeriodFrom  INT,
        @PeriodTo    INT
	
DECLARE @Amount AS DECIMAL(28, 8)

--------------->>>> Chuỗi DivisionID
DECLARE @StrDivisionID_New AS NVARCHAR(4000)

SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END
		
DELETE FROM	A00007 WHERE SPID = @@SPID
INSERT INTO A00007(SPID, DivisionID) 
EXEC('SELECT '''+@@SPID+''', DivisionID FROM AT1101 WHERE DivisionID '+@StrDivisionID_New+'')

---------------------<<<<<<<<<< Chuỗi DivisionID
	
SET @PeriodFrom = @TranYearFrom * 100 + @TranMonthFrom
SET @PeriodTo = @TranYearTo * 100 + @TranMonthTo	
	
SET @Amount = 0
	--- Print ' Hello Thuy'+@AccountIDFrom
	--If @AccountIDFrom ='334'
	--   Print ' Van Nhan test'
	
IF @Mode = 11
    ------- Lay so cuoi ky (chi tiet theo doi tuong), So du ben No, So cuoi ky	
    SELECT	@Amount = SUM(ConvertedClosing)
    FROM	(	SELECT		V02.AccountID,
							V02.ObjectID,
							SUM(ConvertedAmount) AS ConvertedClosing
        	 	FROM		@AV4202 V02
				WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
							AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
							AND (V02.TranYear * 100 + V02.TranMonth <= @PeriodTo)
        	 	GROUP BY	V02.DivisionID, V02.AccountID,
							V02.ObjectID
			) AS E
           ---Having sum(ConvertedAmount)>=0) as E
    WHERE	E.ConvertedClosing >= 0
	
IF @Mode = 21
    ---------- Lay so du dau nam (chi tiet theo doi tuong), So du ben No, 		
    SELECT	@Amount = SUM(B.ConvertedAmount)
    FROM	(	SELECT		V02.AccountID,
							ObjectID,
							SUM(V02.ConvertedAmount) AS ConvertedAmount
               FROM			@AV4202 AS V02
               WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) 
							AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
							AND ((V02.TranYear < @TranYearFrom) OR (TransactionTypeID = 'T00'))
            	GROUP BY	V02.DivisionID, V02.AccountID,
							V02.ObjectID
			) AS B
           ---Having  SUM(V02.ConvertedAmount) >=0
    WHERE	B.ConvertedAmount >= 0 --- Phai la du No

IF @Mode = 121
    ---------- Lấy số dư đầu kỳ (chi tiết theo đối tượng), dư Nợ
    SELECT	@Amount = SUM(B.ConvertedAmount)
    FROM	(	SELECT		V02.AccountID,
							ObjectID,
							SUM(V02.ConvertedAmount) AS ConvertedAmount
               FROM			@AV4202 AS V02
               WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID)) 
							AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
							AND ((V02.TranYear * 100 + V02.TranMonth < @PeriodFrom) OR (TransactionTypeID = 'T00'))
            	GROUP BY	V02.DivisionID, V02.AccountID,
							V02.ObjectID
			) AS B
           ---Having  SUM(V02.ConvertedAmount) >=0
    WHERE	B.ConvertedAmount >= 0 --- Phai la du No
         	                       --	
IF @Mode = 12 ------------- lay so du cuoi ky ( chi tiet theo doi tuong va theo tai khoan), So du ben Co
BEGIN
    SELECT	@Amount = SUM(ConvertedClosing)
    FROM	(	SELECT		V02.AccountID,
							V02.ObjectID,
							SUM(ConvertedAmount) AS ConvertedClosing
               FROM			@AV4202 V02
               WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))	
							AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
							AND (V02.TranYear * 100 + V02.TranMonth <= @PeriodTo)
            	GROUP BY	V02.DivisionID, V02.AccountID,
							V02.ObjectID
			) AS E
           ---Having sum(ConvertedAmount)>=0) as E
    WHERE	E.ConvertedClosing < 0 --- So du co
    SET @Amount = @Amount * (-1)
END	
	
IF @Mode = 22 -- So du dau nam So du Co, lay chi tiet theo tai khoan va theo doi tuong
BEGIN
    SELECT	@Amount = SUM(B.ConvertedAmount)
    FROM	(	SELECT		V02.AccountID,
							ObjectID,
							SUM(V02.ConvertedAmount) AS ConvertedAmount
               FROM			@AV4202 AS V02
               WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
							AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
							AND ((V02.TranYear < @TranYearFrom) OR (TransactionTypeID = 'T00'))
            	GROUP BY	V02.DivisionID, V02.AccountID,
            				V02.ObjectID
			) AS B
           ---Having  SUM(V02.ConvertedAmount) >=0
    WHERE	B.ConvertedAmount < 0 --- Phai la du Co
    
    SET @Amount = @Amount * (-1)
END

IF @Mode = 122 -- Lấy số dư đầu kỳ (chi tiết theo tài khoản và đối tượng), Dư Có
BEGIN
    SELECT	@Amount = SUM(B.ConvertedAmount)
    FROM	(	SELECT		V02.AccountID,
							ObjectID,
							SUM(V02.ConvertedAmount) AS ConvertedAmount
               FROM			@AV4202 AS V02
               WHERE		(V02.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID))
							AND (V02.AccountID >= @AccountIDFrom AND V02.AccountID <= @AccountIDTo)
							AND ((V02.TranYear * 100 + V02.TranMonth < @PeriodFrom) OR (TransactionTypeID = 'T00'))
            	GROUP BY	V02.DivisionID, V02.AccountID,
            				V02.ObjectID
			) AS B
           ---Having  SUM(V02.ConvertedAmount) >=0
    WHERE	B.ConvertedAmount < 0 --- Phai la du Co
    
    SET @Amount = @Amount * (-1)
END

IF @Amount IS NULL
    SET @Amount = 0

SET @OutputAmount = @Amount
	RETURN
DELETE FROM	A00007 WHERE SPID = @@SPID
