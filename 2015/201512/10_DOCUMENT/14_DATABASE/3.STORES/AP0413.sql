IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0413]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0413]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Xử lý bút toán CLTG
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 31/10/2003 by Nguyen Van Nhan
---- Modified on 28/07/2010 by Mỹ Tuyền
---- Modified on 06/12/2011 by Nguyễn Bình Minh: Bổ sung xử lý đi chênh lệch trực tiếp
-- <Example>
CREATE PROCEDURE [dbo].[AP0413] 
(
	@DivisionID AS nvarchar(50), 
	@TranMonth as int, 
	@TranYear as int, 
	@UserID as nvarchar(50)
)
 AS

DECLARE @sSQL				AS NVARCHAR(4000),
        @VoucherDate		AS DATETIME,
        @VoucherTypeID		AS NVARCHAR(50),
        @VoucherNo			AS NVARCHAR(50),
        @UnequalAccountID	AS NVARCHAR(50),
        @DebitAccountID		AS NVARCHAR(50),
        @CreditAccountID	AS NVARCHAR(50),
        @Acc_cur			AS CURSOR ,
        @Curr_cur			AS CURSOR,
		@AccountID			AS NVARCHAR(50),
		@GroupID			AS NVARCHAR(50),
		@IsProfitCost		AS TINYINT,
		@IsDirectProfitCost	AS TINYINT,
		@CurrencyID			AS NVARCHAR(50),
		@ExchangeRate		AS DECIMAL(28, 8),
		@VoucherID			AS NVARCHAR(50),
		@BankAccountID		AS NVARCHAR(50),
		@Description		AS NVARCHAR(250),
		@Operator			AS TINYINT
	
EXEC AP0000 @DivisionID,	@VoucherID OUTPUT,	'AT9000',     'AV',     @TranYear,    '',     15,     3,     0,	'-'

SELECT @VoucherDate = VoucherDate,
       @VoucherTypeID = VoucherTypeID,
       @VoucherNo = VoucherNo,
       @UnequalAccountID = UnequalAccountID,
       @DebitAccountID = DebitAccountID,
       @CreditAccountID = CreditAccountID,
       @Description = DESCRIPTION
FROM   AT0003 

---Print @UnequalAccountID	
SET @Acc_cur =  CURSOR SCROLL KEYSET FOR 
SELECT		ID AS AccountID,
			IsProfitCost,
			IsDirectProfitCost,
			GroupID,
			ISNULL(AT1016.BankAccountID, '')
FROM		AT0004
INNER JOIN	AT1005
		ON  AT1005.AccountID = AT0004.ID AND AT1005.DivisionID = AT0004.DivisionID
LEFT JOIN	AT1016
		ON  AT1016.AccountID = AT0004.ID AND AT1016.DivisionID = AT0004.DivisionID
WHERE		TYPE = 0

OPEN	@Acc_cur
FETCH NEXT FROM @Acc_cur  INTO  @AccountID , @IsProfitCost , @IsDirectProfitCost, @GroupID, @BankAccountID
WHILE @@Fetch_Status = 0
BEGIN
    --- Lay tat ca loai tien
    
    SET @Curr_cur =  CURSOR SCROLL KEYSET FOR 		
    SELECT ID AS CurrencyID, AT0004.ExchangeRate,	AT1004.Operator
    FROM   AT0004
           INNER JOIN AT1004
                ON  At0004.ID = AT1004.CurrencyID AND At0004.DivisionID = AT1004.DivisionID
    WHERE  AT0004.Type = 1
    
    OPEN @Curr_cur
    FETCH NEXT FROM @Curr_cur INTO @CurrencyID, @ExchangeRate, @Operator
    WHILE @@Fetch_Status = 0
    BEGIN
        EXEC AP0412		@DivisionID,
						@TranMonth,			@TranYear,
						@VoucherDate,		@VoucherTypeID,		@VoucherNo,
						@UnequalAccountID,	@DebitAccountID,	@CreditAccountID,	@AccountID,
						@IsProfitCost,		@GroupID,			
						@CurrencyID,		@ExchangeRate,		@VoucherID,			@UserID,
						@BankAccountID,		@Description,		@Operator,			@IsDirectProfitCost
        
        FETCH NEXT FROM @Curr_cur INTO @CurrencyID, @ExchangeRate, @Operator
    END
    CLOSE @Curr_cur
    FETCH NEXT FROM @Acc_cur  INTO  @AccountID , @IsProfitCost , @IsDirectProfitCost, @GroupID, @BankAccountID
END
CLOSE @Acc_cur