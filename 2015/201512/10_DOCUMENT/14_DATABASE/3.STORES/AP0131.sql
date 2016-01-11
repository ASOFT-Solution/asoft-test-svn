IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0131]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0131]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Created by Nguyen Van Nhan
--Date 11/01/2006
--Purpose: Lay so du cong no len bao man hinh
---- Modified on 20/11/2011 by Le Thi Thu Hien : Bo sung format so le
---- Modified on 08/02/2012 by Le Thi Thu Hien : Bo sung them JOIN DivisionID

/********************************************
'* Edited by: [GS] [To Oanh] [28/07/2010]
'********************************************/

CREATE PROCEDURE  [dbo].[AP0131] 	
					@DivisionID nvarchar(50), 
					@ObjectID AS nvarchar(50),	
					@VoucherDate AS Datetime,
					@CurrencyID AS  nvarchar(50),
					@IsSales AS tinyint ---- =0 la mua hang; =1 la ban hang


AS
SET NOCOUNT ON
DECLARE @ReAccountID AS nvarchar(50),
		@PaAccountID AS  nvarchar(50),
		@ReceivedAmount AS decimal(28,8),
		@PaymentAmount AS decimal(28,8),
		@OverDueAmount AS decimal(28,8),
		@ExchangeRateDecimal AS TINYINT

SET @ExchangeRateDecimal =( SELECT TOP 1 ExchangeRateDecimal FROM AT1004 WHERE CurrencyID = @CurrencyID)

SELECT	@ReAccountID = ReAccountID, 
		@PaAccountID = PaAccountID
FROM	AT1202 
WHERE	ObjectID = @ObjectID

---Step1:Lay no  phai thu 
SELECT	@ReceivedAmount = sum(OriginalAmount) 
FROM	AV4202
WHERE 	AccountID LIKE @ReAccountID 
		AND ObjectID = @ObjectID 
		AND DivisionID = @DivisionID 
		AND VoucherDate <= @VoucherDate 
		AND CurrencyIDCN =@CurrencyID

---Step2:Lay no  phai tra
SELECT	@PaymentAmount = - sum(OriginalAmount) 
FROM	AV4202
WHERE 	AccountID like @PaAccountID 
		AND ObjectID = @ObjectID 
		AND DivisionID =@DivisionID 
		AND VoucherDate <= @VoucherDate 
		AND CurrencyIDCN =@CurrencyID

---Step3:Lay no  phai thu qua han
SELECT  @OverDueAmount  =   sum(ISNULL( OriginalAmount,0)- ISNULL (GivedOriginalAmount,0))  
FROM	AV0301
WHERE 	DebitAccountID like @ReAccountID 
		AND ObjectID = @ObjectID 
		AND DivisionID = @DivisionID 
		AND (DueDate < = case when DueDate <> '01/01/1900' then @VoucherDate end ) 
		AND CurrencyIDCN = @CurrencyID
								
				
SET NOCOUNT OFF

IF @IsSales = 1--- Phai thu
SELECT 	ReCreditLimit,
		RePaymentTermID,PaymentTermName, 
		ReDueDays, Redays, 
		ROUND(ISNULL(@ReceivedAmount,0), @ExchangeRateDecimal)  AS ReceivedAmount, 
		ROUND(ISNULL(@PaymentAmount,0), @ExchangeRateDecimal)  AS PaymentAmount,
		ROUND(ISNULL(@OverDueAmount,0), @ExchangeRateDecimal) AS  OverDueAmount
FROM		AT1202 
LEFT JOIN	AT1208 
	ON		AT1208.PaymentTermID = AT1202.RePaymentTermID 
			AND AT1208.DivisionID = AT1202.DivisionID
WHERE	ObjectID = @ObjectID
ELSE   --- Phai tra
SELECT 	PaCreditLimit AS ReCreditLimit, 
		RePaymentTermID, PaymentTermName, 
		PaDueDays AS ReDueDays, ReDays AS Redays,
		ROUND(ISNULL(@ReceivedAmount,0),@ExchangeRateDecimal)  AS ReceivedAmount, 
		ROUND(ISNULL(@PaymentAmount,0), @ExchangeRateDecimal)  AS PaymentAmount,
		ROUND(ISNULL(@OverDueAmount,0),@ExchangeRateDecimal) AS  OverDueAmount
FROM		AT1202 
LEFT JOIN	AT1208 
	ON		AT1208.PaymentTermID = AT1202.PaPaymentTermID 
			AND AT1208.DivisionID = AT1202.DivisionID
WHERE	ObjectID = @ObjectID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

