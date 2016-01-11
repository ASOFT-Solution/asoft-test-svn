IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7809]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7809]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Insert but toan phan bo
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 20/08/2003 by Nguyễn Văn Nhân
----
---- Edit by: Dang Le Bao Quynh; Date: 18/06/2007 
---- Purpose: Bo sung cap nhat ma phan tich
---- Edit By: Dang Le Bao Quynh; Date 11/01/2008
---- Purpose: Bo sung ket chuyen chi tiet theo doi tuong
---- Modified on 19/11/2011 by Le Thi Thu Hien : Bo sung check @IsTransferGeneral
---- Modified on 04/01/2012 by Lê Thị Thu Hiền : Bổ sung format số lẻ
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ, tiền hạch toán theo thiết lập đơn vị-chi nhánh

-- <Example>
----

CREATE PROCEDURE [dbo].[AP7809]
       @DivisionID nvarchar(50) ,
       @TranMonth tinyint ,
       @TranYear int ,
       @VoucherID nvarchar(50) ,
       @VoucherTypeID nvarchar(50) ,
       @VoucherNo nvarchar(50) ,
       @VoucherDate AS datetime ,
       @VDescription AS nvarchar(250) ,
       @BDescription AS nvarchar(250) ,
       @TDescription AS nvarchar(250) ,
       @DebitAccountID nvarchar(50) ,
       @CreditAccountID nvarchar(50) ,
       @ConvertedAmount decimal(28,8) ,
       @CreateUserID nvarchar(50) ,
       @LastModifyUserID nvarchar(50) ,
       @Ana01ID AS nvarchar(50) ,
       @Ana02ID AS nvarchar(50) ,
       @Ana03ID AS nvarchar(50) ,
       @Ana04ID AS nvarchar(50) ,
       @Ana05ID AS nvarchar(50) ,
       @Ana06ID AS nvarchar(50) ,
       @Ana07ID AS nvarchar(50) ,
       @Ana08ID AS nvarchar(50) ,
       @Ana09ID AS nvarchar(50) ,
       @Ana10ID AS nvarchar(50) ,
       @ObjectID AS nvarchar(50) = NULL,
       @IsTransferGeneral AS TINYINT = 0
AS --Print 	'@DebitAccountID '+@DebitAccountID+' @CreditAccountID :'+@CreditAccountID+' @ConvertedAmount+ '+str(@ConvertedAmount)
SET NOCOUNT ON
DECLARE @BatchID AS nvarchar(50) ,
        @TransactionID AS nvarchar(50) ,
        @CurrencyID AS nvarchar(50)

SELECT	@CurrencyID = BaseCurrencyID FROM AT1101 WHERE DivisionID = @DivisionID

-------------->> FORMAT số lẻ
DECLARE @OriginalDecimal AS int,
        @ConvertedDecimal AS int  
           
SELECT @OriginalDecimal = ExchangeRateDecimal FROM AT1004 WHERE CurrencyID = @CurrencyID AND DivisionID = @DivisionID	

SELECT @ConvertedDecimal = (SELECT TOP 1 ConvertedDecimals FROM AT1101 WHERE DivisionID = @DivisionID)
SET @ConvertedDecimal = ISNULL(@ConvertedDecimal,0)

-----------------<< FORMAT số lẻ	

EXEC AP0000 @DivisionID, @TransactionID OUTPUT , 'AT9000' , 'AT' , @TranYear , '' , 15 , 3 , 0 , '-'
SET @BatchID = @TransactionID
WHILE EXISTS ( SELECT 1 FROM AT9000 WHERE TableID = 'AT9000' AND TransactionID = @TransactionID )
      BEGIN
            EXEC AP0000 @DivisionID, @TransactionID OUTPUT , 'AT9000' , 'AT' , @TranYear , '' , 15 , 3 , 0 , '-'
            SET @BatchID = @TransactionID
      END
INSERT INTO AT9000 (VoucherID, TransactionID, TableID, LastModifyDate, BatchID, TransactionTypeID, CreateUserID,
	LastModifyUserID, TranMonth, TranYear, Status, DebitAccountID, CreditAccountID, CurrencyID, VoucherNo, VoucherTypeID,
	ObjectID, VDescription, BDescription, TDescription, ConvertedAmount, ExchangeRate, OriginalAmount, DivisionID,
	VoucherDate, Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, RefVoucherNo)
VALUES (@VoucherID, @TransactionID, 'AT9000', CONVERT(char, getdate(), 101), @BatchID, CASE WHEN @IsTransferGeneral = 1 THEN 'T99' ELSE 'T98' END,	---- 'T98' : But toan ket chuyen
	@CreateUserID, @LastModifyUserID, @TranMonth, @TranYear, 0, @DebitAccountID, @CreditAccountID, @CurrencyID,
	@VoucherNo, @VoucherTypeID, @ObjectID, @VDescription, @BDescription, @TDescription, ROUND (@ConvertedAmount, @ConvertedDecimal), 1,
	ROUND(@ConvertedAmount, @ConvertedDecimal), @DivisionID, @VoucherDate,
	@Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, @Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID, CASE WHEN @IsTransferGeneral = 1 THEN 'T99' ELSE 'T98' END )


SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

