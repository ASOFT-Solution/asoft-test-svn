IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP5569]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP5569]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Import tu file excel 04_Salary-PIT
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 03/08/2011 by Le Thi Thu Hien : 
---- 
---- Modified on 30/08/2011 by Le Thi Thu Hien : Bo phan Import SALARY
-- <Example>
---- 

CREATE PROCEDURE [dbo].[AP5569] 
	@xml XML,
	@DivisionID nvarchar(50), 
	@TranMonth int , 
	@TranYear int, 
	@EmployeeID nvarchar(50)
AS

DECLARE @sql nvarchar(4000)

IF NOT @xml IS NULL
BEGIN	
	DECLARE @AT5561 TABLE 
	(
		ObjectID nvarchar(50),
		TranDate DateTime,
		CurrencyID nvarchar(50),
		ExchangeRate decimal(28,8),
		Salary decimal(28,8),
		PIT DECIMAL(28,8)

	);
		
	SET ARITHABORT ON

	INSERT INTO @AT5561 (ObjectID,Salary,PIT,CurrencyID,ExchangeRate,TranDate)	
	SELECT DISTINCT *
	FROM (
	SELECT 	X.AT5561.query('ObjectID').value('.','nvarchar(50)') as ObjectID
		  , X.AT5561.query('Salary').value('.','decimal(28,8)') as Salary
		  , X.AT5561.query('PIT').value('.','decimal(28,8)') as PIT		  
		  , X.AT5561.query('CurrencyID').value('.','nvarchar(50)') as CurrencyID
		  , X.AT5561.query('ExchangeRate').value('.','decimal(28,8)') as ExchangeRate		  
		  , X.AT5561.query('TranDate').value('.','datetime') as TranDate
		  
	FROM @xml.nodes('//AT5561') AS X(AT5561)
	) as XX
	
	SET ARITHABORT OFF


	-- Nếu không có dữ liệu thì không xử lý tiếp
	IF(SELECT COUNT(*) FROM @AT5561) = 0 GOTO Exist

-- Biến cố định không có trong XML
	

DECLARE	@OrderCur as cursor,
		@ObjectID nvarchar(50),
		@TranDate DateTime,
		@CurrencyID nvarchar(50),
		@ExchangeRate decimal(28,8),
		@Salary decimal(28,8),
		@SUMSalary decimal(28,8),
		@PIT decimal(28,8),
		@ReVoucherID NVARCHAR(50)

SET @SUMSalary = 0
		
SET @OrderCur = CURSOR STATIC FOR
SELECT	ObjectID,TranDate,CurrencyID,ExchangeRate,Salary, PIT
FROM	@AT5561 

BEGIN TRAN
OPEN @OrderCur
FETCH NEXT FROM @OrderCur Into  @ObjectID,@TranDate,@CurrencyID,@ExchangeRate,@Salary, @PIT
WHILE @@Fetch_Status = 0
BEGIN

	EXEC AP0000 @DivisionID, @ReVoucherID OUTPUT, 'AT9000', 'PA', @TranYear, '', 16, 3, 0, '-'
	INSERT INTO AT5567
	(	TransactionTypeID, TransactionID, ObjectID,TranDate,CurrencyID,ExchangeRate,Amount,EndAmount,
		ReVoucherID,
		DivisionID,	TranMonth,	TranYear
	)
	VALUES
	(	'PIT','', @ObjectID, @TranDate, @CurrencyID, @ExchangeRate, @PIT, @PIT , 
		@ReVoucherID, 
		@DivisionID, @TranMonth, @TranYear
	)
	SET @SUMSalary = @SUMSalary + @Salary
																		
	FETCH NEXT FROM @OrderCur INTO @ObjectID,@TranDate,@CurrencyID,@ExchangeRate,@Salary, @PIT
END

	--EXEC AP0000 @DivisionID,  @ReVoucherID Output, 'AT9000', 'PA', @TranYear, '', 16, 3, 0, '-'
	--INSERT INTO AT5567
	--(	TransactionTypeID, TransactionID , ObjectID, TranDate,CurrencyID,ExchangeRate,Amount,EndAmount,
	--	ReVoucherID,
	--	DivisionID,	TranMonth,	TranYear
	--)
	--SELECT	TOP 1 'SALARY','' , '',TranDate, CurrencyID, ExchangeRate, @SUMSalary, @SUMSalary , 
	--		@ReVoucherID, 
	--		@DivisionID, @TranMonth, @TranYear
	--FROM	@AT5561 
	
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

