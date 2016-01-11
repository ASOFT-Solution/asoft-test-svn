/****** Object:  StoredProcedure [dbo].[AP7901]    Script Date: 04/16/2013 14:25:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- <Summary>
---- In bang can doi ke toan
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 16/08/2002 by Nguyen Van Nhan
---- Modified on 02/10/2006 by Nguyen Quoc Huy
---- Modified on 29/07/2010 Minh Lâm
---- Modified on 21/12/2011 by Nguyễn Bình Minh: Bổ sung Amount3 (số đầu kỳ)
---- Modified on 25/05/2012 by Thiên Huỳnh: Bổ sung truyền biến @ReportCode vào AP7916
---- Last Edit by Thiên Huỳnh  on 21/06/2012: Gán lại theo @AmountUnit
---- Modified on 22/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị
---- Modified on 23/03/2013 by Bao Quynh : Them chi tieu Amount4, cung ky nam truoc
---- Modified on 15/04/2015 by Hoàng vũ : Duyệt thêm truong DisplayedMark để hiển thị dấu âm/dương trên báo có
-- <Example>
---- 

ALTER PROCEDURE [dbo].[AP7901]
(
       @DivisionID AS NVARCHAR(50) ,
       @TranMonthFrom AS INT ,
       @TranYearFrom AS INT ,
       @TranMonthTo AS INT ,
       @TranYearTo AS INT ,
       @ReportCode AS NVARCHAR(50) ,
       @AmountUnit AS TINYINT,
       @StrDivisionID AS NVARCHAR(4000) = ''
       
)       
AS

DECLARE @ConvertAmountUnit  AS DECIMAL(28, 8)
DECLARE @AT7902Cursor       AS CURSOR ,
        @LineCode           AS NVARCHAR(50) ,
        @LineDescription    AS NVARCHAR(250) ,
        @LineDescriptionE   AS NVARCHAR(250) ,
        @AccountIDFrom      AS NVARCHAR(50) ,
        @AccountIDTo        AS NVARCHAR(50) ,
        @D_C                AS TINYINT ,
        @Detail             AS TINYINT ,
        @Accumulator        AS NVARCHAR(50) ,
        @Level1             AS TINYINT ,
        @PrintStatus        AS TINYINT ,
        @Type               AS TINYINT ,
        @LineID             AS NVARCHAR(50) ,
        @Notes              AS NVARCHAR(250),
		@DisplayedMark      AS TINYINT 

SET NOCOUNT ON
DELETE AT7915

IF @AmountUnit = 1 SET @ConvertAmountUnit = 1
IF @AmountUnit = 2 SET @ConvertAmountUnit = 10
IF @AmountUnit = 3 SET @ConvertAmountUnit = 100
IF @AmountUnit = 4 SET @ConvertAmountUnit = 1000
IF @AmountUnit = 5 SET @ConvertAmountUnit = 10000
IF @AmountUnit = 6 SET @ConvertAmountUnit = 100000
IF @AmountUnit = 7 SET @ConvertAmountUnit = 1000000

SET @AT7902Cursor =  CURSOR SCROLL KEYSET FOR 
	SELECT T12.LineID,
		   T12.LineCode,
		   T12.LineDescription,
		   T12.LineDescriptionE,
		   T12.AccountIDFrom,
		   T12.AccountIDTo,
		   T12.Type,
		   T12.D_C,
		   T12.Accumulator,
		   T12.Level1,
		   T12.PrintStatus,
		   T12.Notes,
		   T12.DisplayedMark
	FROM   AT7902 AS T12
	WHERE  T12.ReportCode = @ReportCode --and Type<>9
		   AND DivisionID = @DivisionID

OPEN @AT7902Cursor
FETCH NEXT FROM @AT7902Cursor INTO	@LineID,		@LineCode,		@LineDescription,	@LineDescriptionE,
									@AccountIDFrom,	@AccountIDTo,	@Type,				@D_C,
									@Accumulator,	@Level1,		@PrintStatus,		@Notes, @DisplayedMark
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO AT7915
    (
        DivisionID,
        LineCode,
        LineID,
        LineDescription,
        LineDescriptionE,
        PrintStatus,
        Amount1,
        Amount2,
        Amount3,
        Amount4,
        Level1,
        TYPE,
        Accumulator,
        Notes,
		DisplayedMark
    )
    VALUES
    (
        @DivisionID,
        @LineCode,
        @LineID,
        @LineDescription,
        @LineDescriptionE,
        @PrintStatus,
        0,
        0,
        0,
        0,
        @Level1,
        @Type,
        @Accumulator,
        @Notes,
		@DisplayedMark
    )
	FETCH NEXT FROM @AT7902Cursor INTO	@LineID,		@LineCode,		@LineDescription,	@LineDescriptionE,
										@AccountIDFrom,	@AccountIDTo,	@Type,				@D_C,
										@Accumulator,	@Level1,		@PrintStatus,		@Notes, @DisplayedMark
END
CLOSE @AT7902Cursor
DEALLOCATE @AT7902Cursor

----------------- Xu ly chi tiet ----------------------------------------------------------------------
DECLARE @Amount1 AS DECIMAL(28, 8), -- So cuoi ky
        @Amount2 AS DECIMAL(28, 8), -- So dau nam
        @Amount3 AS DECIMAL(28, 8), -- So dau ky
		@Amount4 AS DECIMAL(28, 8), -- Cung ky nam truoc
		@TranYearFrom2 AS INT ,
		@TranYearTo2 AS INT

SET @TranYearFrom2 = @TranYearFrom - 1
SET @TranYearTo2 = @TranYearTo - 1

--Xu ly bien table de tang toc do xu ly
DECLARE @AV4201 As TypeOfAV4201
DECLARE @AV4202 As TypeOfAV4202

--AV4201
INSERT INTO @AV4201(DivisionID,AccountID,ConvertedAmount,TranMonth,TranYear,CorAccountID,D_C,TransactionTypeID)
SELECT DivisionID, DebitAccountID AS AccountID,   
 SUM(ConvertedAmount) AS ConvertedAmount,   
 TranMonth,TranYear,   
 CreditAccountID AS CorAccountID,   -- tai khoan doi ung  
 'D' AS D_C, TransactionTypeID  
FROM AT9000  
WHERE isnull(DebitAccountID,'') <> ''  
GROUP BY DivisionID, DebitAccountID, TranMonth, TranYear, CreditAccountID, TransactionTypeID       
UNION ALL  
------------------- So phat sinh co, lay am  
SELECT DivisionID, CreditAccountID AS AccountID,   
 SUM(ConvertedAmount*-1) AS ConvertedAmount,   
 TranMonth, TranYear,   
 DebitAccountID AS CorAccountID,   
 'C' AS D_C, TransactionTypeID   
FROM AT9000  
WHERE isnull(CreditAccountID,'')<> ''  
GROUP BY DivisionID, CreditAccountID, TranMonth, TranYear, DebitAccountID, TransactionTypeID

--AV4202
INSERT INTO @AV4202(ObjectID,CurrencyIDCN,VoucherDate,InvoiceDate,DueDate,
DivisionID,AccountID,InventoryID,ConvertedAmount,OriginalAmount,TranMonth,TranYear,
CorAccountID,D_C,TransactionTypeID)

SELECT  ObjectID,    ---- PHAT SINH NO  
  CurrencyIDCN,VoucherDate, InvoiceDate, DueDate,  
  AT9000.DivisionID, DebitAccountID AS AccountID, InventoryID,  
  SUM(isnull(ConvertedAmount,0)) AS ConvertedAmount,   
  sum(isnull(OriginalAmountCN,0)) AS OriginalAmount,  
  TranMonth,TranYear,   
  CreditAccountID AS CorAccountID,   -- tai khoan doi ung  
  'D' AS D_C, TransactionTypeID  
FROM AT9000 inner join AT1005 on AT1005.AccountID = AT9000.DebitAccountID and AT1005.DivisionID = AT9000.DivisionID  
WHERE DebitAccountID IS NOT NULL and AT1005.GroupID  in ('G03', 'G04')  
GROUP BY ObjectID, Ana01ID, CurrencyIDCN, VoucherDate, InvoiceDate, DueDate, AT9000.DivisionID, DebitAccountID,   
 TranMonth, TranYear, CreditAccountID, TransactionTypeID, InventoryID       
UNION ALL  
------------------- So phat sinh co, lay am  
SELECT    ---- PHAT SINH CO   
 (Case when TransactionTypeID ='T99' then CreditObjectID else ObjectID end) as ObjectID,   
 CurrencyIDCN,VoucherDate, InvoiceDate, DueDate,  
 AT9000.DivisionID, CreditAccountID AS AccountID, InventoryID,  
 SUM(isnull(ConvertedAmount,0)*-1) AS ConvertedAmount,   
 sum(isnull(OriginalAmountCN,0)*-1) AS OriginalAmount,  
 TranMonth, TranYear,   
 DebitAccountID AS CorAccountID,   
 'C' AS D_C, TransactionTypeID   
FROM AT9000 inner join AT1005 on AT1005.AccountID = AT9000.CreditAccountID and AT1005.DivisionID = AT9000.DivisionID  
WHERE CreditAccountID IS NOT NULL  and AT1005.GroupID in ('G03', 'G04')  
GROUP BY (Case when TransactionTypeID ='T99' then CreditObjectID else ObjectID end), Ana01ID,  
 CurrencyIDCN, VoucherDate, InvoiceDate, DueDate, AT9000.DivisionID, CreditAccountID,   
 TranMonth, TranYear, DebitAccountID, TransactionTypeID, InventoryID
 

-----------------------------------------------------------------
SET @AT7902Cursor =  CURSOR SCROLL KEYSET FOR 
	SELECT	T12.Type,
			   T12.LineID,
			   T12.LineCode,
			   T12.LineDescription,
			   T12.LineDescriptionE,
			   T12.AccountIDFrom,
			   T12.AccountIDTo,
			   T12.Detail,
			   T12.D_C,
			   T12.Accumulator,
			   T12.Level1,
			   T12.PrintStatus
	FROM		AT7902 AS T12
	WHERE		T12.ReportCode = @ReportCode
				AND DivisionID = @DivisionID
	ORDER BY	T12.LineCode

OPEN @AT7902Cursor
FETCH NEXT FROM @AT7902Cursor INTO	@Type,			@LineID,		@LineCode,	@LineDescription,	@LineDescriptionE,
									@AccountIDFrom,	@AccountIDTo,	@Detail,	@D_C,				@Accumulator,		@Level1,	@PrintStatus
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Amount1 = 0
    SET @Amount2 = 0
    SET @Amount3 = 0
    SET @Amount4 = 0
    IF (@AccountIDTo IS NULL) OR (@AccountIDTO = '')
        SET @AccountIDTo = @AccountIDFrom
    
    IF (@AccountIDFrom IS NOT NULL) AND (@AccountIDFrom <> '')
    BEGIN
        --Print 'ZO'+str(@Detail)+'    '+str(@D_C)+'  '+str(@Type)
        
        IF @Detail = 0 AND @D_C = 1 ---- Truong hop lay tong hop, Lay so du No
        BEGIN
            IF @Type IN (1, 2)
            BEGIN
               EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 1 , @Amount2 OUTPUT,@StrDivisionID, @AV4201  ---- So cuoi ky
               EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 2 , @Amount1 OUTPUT ,@StrDivisionID, @AV4201  -- So dau nam
               EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 102 , @Amount3 OUTPUT ,@StrDivisionID, @AV4201   -- So dau ky
               EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom2 , @TranMonthTo , @TranYearTo2 , 1 , @Amount4 OUTPUT,@StrDivisionID, @AV4201  ---- Cung ky nam truoc
            END
            ELSE
            BEGIN
                IF @Type = 9
                BEGIN
                   EXEC AP7913 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 1 , @Amount2 OUTPUT,@StrDivisionID    ---- So cuoi ky
                   EXEC AP7913 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 2 , @Amount1 OUTPUT,@StrDivisionID    ---- So dau nam 
                   EXEC AP7913 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 102 , @Amount3 OUTPUT,@StrDivisionID  -- So dau ky
                   EXEC AP7913 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom2 , @TranMonthTo , @TranYearTo2 , 1 , @Amount4 OUTPUT,@StrDivisionID    ---- Cung ky nam truoc
                END
            END
        END
        
        IF @Detail = 0 AND @D_C = 2 ---- Truong hop lay tong hop, Lay so du Co
        BEGIN
			EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 3 , @Amount2 OUTPUT ,@StrDivisionID, @AV4201   ---- So cuoi ky
			EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 4 , @Amount1 OUTPUT ,@StrDivisionID, @AV4201 ---- So dau nam 
			EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 104 , @Amount3 OUTPUT ,@StrDivisionID, @AV4201   ---- So dau ky
			EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom2 , @TranMonthTo , @TranYearTo2 , 3 , @Amount4 OUTPUT ,@StrDivisionID, @AV4201   ---- Cung ky nam truoc
        END        
        
        IF @Detail = 1 AND @D_C = 1 --'D'   ---- So du No, lay chi tiet theo tai khoan
        BEGIN
			EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 11 , @Amount2 OUTPUT ,@StrDivisionID, @AV4201 
			EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 21 , @Amount1 OUTPUT ,@StrDivisionID, @AV4201 
			EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 121 , @Amount3 OUTPUT ,@StrDivisionID, @AV4201  -- So dau ky
			EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom2 , @TranMonthTo , @TranYearTo2 , 11 , @Amount4 OUTPUT ,@StrDivisionID, @AV4201 -- Cung ky nam truoc
        END
        
        IF @Detail = 1 AND @D_C = 2 --'C'  -- So du Co, lay chi tiet theo tai khoan
        BEGIN
			EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 12 , @Amount2 OUTPUT ,@StrDivisionID, @AV4201 
            EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 22 , @Amount1 OUTPUT ,@StrDivisionID, @AV4201 
			EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 122 , @Amount3 OUTPUT ,@StrDivisionID, @AV4201  -- So dau ky
			EXEC AP7911 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom2 , @TranMonthTo , @TranYearTo2 , 12 , @Amount4 OUTPUT ,@StrDivisionID, @AV4201 -- Cung ky nam truoc 
        END
        
        IF @Detail = 2 AND @D_C = 1-- 'D'   ---- So du No, lay chi tiet theo tai khoan va theo doi tuong
        BEGIN
			EXEC AP7912 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 11 , @Amount2 OUTPUT,@StrDivisionID, @AV4202 
			EXEC AP7912 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 21 , @Amount1 OUTPUT,@StrDivisionID, @AV4202  
			EXEC AP7912 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 121 , @Amount3 OUTPUT ,@StrDivisionID, @AV4202  -- So dau ky
			EXEC AP7912 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom2 , @TranMonthTo , @TranYearTo2 , 11 , @Amount4 OUTPUT,@StrDivisionID, @AV4202  -- Cung ky nam truoc
        END
        
        IF @Detail = 2 AND @D_C = 2 --'C'   ---- So du Co, lay chi tiet theo tai khoan va theo doi tuong
        BEGIN
			EXEC AP7912 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 12 , @Amount2 OUTPUT,@StrDivisionID, @AV4202  
			EXEC AP7912 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 22 , @Amount1 OUTPUT,@StrDivisionID, @AV4202  
			EXEC AP7912 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom , @TranMonthTo , @TranYearTo , 122 , @Amount3 OUTPUT ,@StrDivisionID, @AV4202  -- So dau ky
			EXEC AP7912 @DivisionID , @AccountIDFrom , @AccountIDTo , @TranMonthFrom , @TranYearFrom2 , @TranMonthTo , @TranYearTo2 , 12 , @Amount4 OUTPUT,@StrDivisionID, @AV4202  -- Cung ky nam truoc
        END
    END
    
    SET @Amount1 = @Amount1 / @ConvertAmountUnit
    SET @Amount2 = @Amount2 / @ConvertAmountUnit
    SET @Amount3 = @Amount3 / @ConvertAmountUnit
    SET @Amount4 = @Amount4 / @ConvertAmountUnit
    ---Print ' @LineID '+@LineID
    IF (@Amount1 <> 0 OR @Amount2 <> 0 OR @Amount3 <> 0 OR @Amount4 <> 0) -- Cộng dồn vào chỉ tiêu cha
		EXEC AP7916 @DivisionID, @LineID , @Amount1 , @Amount2, @Amount3, @Amount4, @ReportCode
    
	FETCH NEXT FROM @AT7902Cursor INTO	@Type,			@LineID,		@LineCode,	@LineDescription,	@LineDescriptionE,
										@AccountIDFrom,	@AccountIDTo,	@Detail,	@D_C,				@Accumulator,		@Level1,	@PrintStatus
END
CLOSE @AT7902Cursor

DEALLOCATE @AT7902Cursor

SET NOCOUNT OFF

