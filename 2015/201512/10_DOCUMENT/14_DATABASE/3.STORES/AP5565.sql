IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP5565]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP5565]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Purpose: Import danh sách phiếu chi
--Customize theo khách hàng MVI
-- File import 03_Template_PayableEntry.xls
/********************************************
'* Created by: [GS] [Trung Dung] [11/07/2011]
Modified on 26/07/2011 by Le Thi Thu Hien : Sua Ana05ID thanh RefNo02
'********************************************/

CREATE PROCEDURE [dbo].[AP5565] 
	@xml XML,
	@DivisionID nvarchar(50), 
	@TranMonth int , 
	@TranYear int, 
	@EmployeeID nvarchar(50)
AS

Declare @sql nvarchar(4000)

If not @xml IS NULL
Begin	
	declare @AT5561 table 
	(
		TransactionID nvarchar(50),
		ObjectID nvarchar(50),
		AgentStatus nvarchar(50),
		TranDate DateTime,
		CurrencyID nvarchar(50),
		ExchangeRate decimal(28,8),
		ContractAmount decimal(28,8),
		BankAccountNo nvarchar(50),
		TranNotes nvarchar(250)
	);
		
	SET ARITHABORT ON

	Insert Into @AT5561 (TransactionID,ObjectID,AgentStatus,TranDate,
	CurrencyID,ExchangeRate,ContractAmount,BankAccountNo,TranNotes)	
	select distinct *
	from (
	Select 	X.AT5561.query('TransactionID').value('.','nvarchar(50)') as TransactionID
		  , X.AT5561.query('ObjectID').value('.','nvarchar(50)') as ObjectID
		  , X.AT5561.query('AgentStatus').value('.','nvarchar(50)') as AgentStatus
		  , X.AT5561.query('TranDate').value('.','datetime') as TranDate
		  , X.AT5561.query('CurrencyID').value('.','nvarchar(50)') as CurrencyID
		  , X.AT5561.query('ExchangeRate').value('.','decimal(28,8)') as ExchangeRate
		  , X.AT5561.query('Amount').value('.','decimal(28,8)') as ContractAmount
		  , X.AT5561.query('BankAccountNo').value('.','nvarchar(50)') as BankAccountNo
		  , X.AT5561.query('TranNotes').value('.','nvarchar(250)') as TranNotes
		  
	From @xml.nodes('//AT5561') AS X(AT5561)
	) as XX
	
	SET ARITHABORT OFF

	--drop table AT5564
	--select * into AT5564 from @AT5561
	-- Nếu không có dữ liệu thì không xử lý tiếp
	IF(SELECT COUNT(*) FROM @AT5561) = 0 GOTO Exist

-- Biến cố định không có trong XML
	

Declare	@OrderCur as cursor,
		@TransactionID nvarchar(50),
		@RefNo02 nvarchar(50), ---TransactionID ben MVI
		@ObjectID nvarchar(50),
		@AgentStatus nvarchar(50),
		@TranDate DateTime,
		@CurrencyID nvarchar(50),
		@ExchangeRate decimal(28,8),
		@Amount decimal(28,8),
		@BankAccountNo nvarchar(50),
		@TranNotes nvarchar(250),
		@ReVoucherID NVARCHAR(50)


		
Set @OrderCur = cursor static for
SELECT	TransactionID,ObjectID,AgentStatus,TranDate,CurrencyID,ExchangeRate,ContractAmount,
		BankAccountNo,TranNotes From @AT5561 
BEGIN TRAN
OPEN @OrderCur
FETCH NEXT FROM @OrderCur Into  @RefNo02,@ObjectID,@AgentStatus,@TranDate,@CurrencyID,@ExchangeRate,@Amount,@BankAccountNo,@TranNotes
WHILE @@Fetch_Status = 0
BEGIN

	EXEC AP0000 @DivisionID, @ReVoucherID Output, 'AT9000', 'PA', @TranYear, '', 16, 3, 0, '-'
	INSERT INTO AT5567
	(	TransactionTypeID, TransactionID,ObjectID,TranDate,CurrencyID,ExchangeRate,Amount,
		BankAccountNo,	EndAmount,ReVoucherID,TranNotes,
		DivisionID,	TranMonth,	TranYear,	AgentStatus
	)
	VALUES
	(	'T02', @RefNo02, @ObjectID, @TranDate, @CurrencyID, @ExchangeRate, @Amount,
		@BankAccountNo, @Amount, @ReVoucherID, @TranNotes,
		@DivisionID, @TranMonth, @TranYear, @AgentStatus
	)
																		
	Fetch Next From @OrderCur Into @RefNo02,@ObjectID,@AgentStatus,@TranDate,@CurrencyID,@ExchangeRate,@Amount,@BankAccountNo,@TranNotes
End


IF @@ERROR = 0
	COMMIT TRAN
ELSE
	ROLLBACK TRAN
		
Close @OrderCur
End
Exist:
SET NOCOUNT OFF



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

