IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP6510]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP6510]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--Create by: Dang Le Bao Quynh, date: 22/07/2011
--Purpose: Xu ly du lieu in bao cao cashflow
---- Modified on 16/01/2012 by Le Thi Thu Hien : Sua dieu kien loc theo ngay
---- Modified on 22/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị
---- Modified by on 02/01/2013 by Lê Thị Thu Hiền : Thay đổi INSERT #DivisionID bằng Bảng tạm A00007
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần tiền hạch toán theo thiết lập đơn vị-chi nhánh

CREATE PROCEDURE [dbo].[AP6510] 
				@DivisionID as nvarchar(50),
				@Date as datetime,
				@Type as tinyint,
				@ColNumber as TINYINT,
				@StrDivisionID AS NVARCHAR(4000) = ''

AS
Declare @TransactionID as nvarchar(50),
		@BaseCurrencyID as nvarchar(50),
		@CurrencyID as nvarchar(50),
		@ExchangeRate as decimal(28,8),
		@ContractNo as nvarchar(50),
		@ObjectID as nvarchar(50),
		@Description as nvarchar(250),
		@DueDate as Datetime,
		@Amount	as Decimal(28,8),
		@FlowType as tinyint, --1: Hop dong ban, 2: Hop dong mua, 3: Chi phi hoat dong, 4: Chi phi khac	
		@Year as int,	
		@Cursor as cursor

--------------->>>> Chuỗi DivisionID
DECLARE @StrDivisionID_New AS NVARCHAR(4000)
	
SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END
		
DELETE FROM	A00007 WHERE SPID = @@SPID
INSERT INTO A00007(SPID, DivisionID) 
EXEC('SELECT '''+@@SPID+''', DivisionID FROM AT1101 WHERE DivisionID '+@StrDivisionID_New+'')
---------------------<<<<<<<<<< Chuỗi DivisionID			
		
--Xoa du lieu truoc luc xu ly
Delete From AT6510 
--Where DivisionID = @DivisionID
--Lay thong tin dong tien hach toan
Select Top 1 @BaseCurrencyID = BaseCurrencyID From AT1101 WHERE DivisionID = @DivisionID
Set @Year = YEAR(@Date)	
/*
Chuyen dong tien tu hop dong ban sang bang du lieu in
Lay du lieu tu bang AT1020 va AT1021 voi dieu kien
AT1020.ContractType = 1
And (Case when AT1021.CorrectDate is null Then AT1021.PaymentDate Else AT1021.CorrectDate End)>=@Date
And AT1021.StepStatus = 1 And AT1021.PaymentStatus=0
*/
--Xu ly du lieu hop dong ban
Set @FlowType = 1

Set @cursor = cursor static for
Select	AT1020.ContractNo, AT1020.CurrencyID, isnull(AT6511.ExchangeRate,0), AT1020.ObjectID,
		AT1021.Notes, (Case When AT1021.CorrectDate is null Then AT1021.PaymentDate Else AT1021.CorrectDate End) As DueDate,
		(isnull(AT1021.PaymentAmount,0)-isnull(AT1021.Paymented,0)) As Amount
From	AT1020 
Inner Join AT1021 On AT1020.ContractID = AT1021.ContractID AND AT1020.DivisionID = AT1021.DivisionID
Left Join AT6511 On AT1020.CurrencyID = AT6511.CurrencyID And AT1020.DivisionID = AT6511.DivisionID
Where AT1020.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) And AT1020.ContractType = 1 And 
		(Case when AT1021.CorrectDate is null Then CONVERT(DATETIME,CONVERT(VARCHAR(10),AT1021.PaymentDate,101),101) Else CONVERT(DATETIME,CONVERT(VARCHAR(10),AT1021.CorrectDate, 101),101) End) >= CONVERT(VARCHAR(10),@Date, 101)
		And AT1021.StepStatus = 1 And AT1021.PaymentStatus=0

Open @cursor
Fetch Next From @cursor Into	@ContractNo, @CurrencyID, @ExchangeRate, @ObjectID,
								@Description, @DueDate, @Amount
While @@FETCH_STATUS = 0
Begin
	EXEC AP0000 @DivisionID, @TransactionID OUTPUT,'AT6510','CFT',@Year,'',20,3,0,'-'
	Insert Into AT6510 (TransactionID, DivisionID, BaseCurrencyID, CurrencyID, ExchangeRate,
						ObjectID, Description, DueDate, Amount, FlowType)
	Values (@TransactionID, @DivisionID, @BaseCurrencyID, @CurrencyID, @ExchangeRate,
						@ObjectID, @ContractNo + '-' + @Description, @DueDate, @Amount, @FlowType) 
	Fetch Next From @cursor Into	@ContractNo, @CurrencyID, @ExchangeRate, @ObjectID,
								@Description, @DueDate, @Amount
End

Close @cursor

--Xu ly du lieu hop dong mua
Set @FlowType = 2

Set @cursor = cursor static for
Select	AT1020.ContractNo, AT1020.CurrencyID, isnull(AT6511.ExchangeRate,0), AT1020.ObjectID,
		AT1021.Notes, (Case When AT1021.CorrectDate is null Then AT1021.PaymentDate Else AT1021.CorrectDate End) As DueDate,
		(isnull(AT1021.PaymentAmount,0)-isnull(AT1021.Paymented,0)) As Amount
From AT1020 Inner Join AT1021 
On AT1020.ContractID = AT1021.ContractID AND AT1020.DivisionID = AT1021.DivisionID
Left Join AT6511 On AT1020.CurrencyID = AT6511.CurrencyID And AT1020.DivisionID = AT6511.DivisionID
Where AT1020.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) And AT1020.ContractType = 0 And 
(Case when AT1021.CorrectDate is null Then CONVERT(DATETIME,CONVERT(VARCHAR(10),AT1021.PaymentDate,101),101) Else CONVERT(DATETIME,CONVERT(VARCHAR(10),AT1021.CorrectDate, 101),101) End) >= CONVERT(VARCHAR(10),@Date, 101)
And AT1021.StepStatus = 1 And AT1021.PaymentStatus=0

Open @cursor
Fetch Next From @cursor Into	@ContractNo, @CurrencyID, @ExchangeRate, @ObjectID,
								@Description, @DueDate, @Amount
While @@FETCH_STATUS = 0
Begin
	EXEC AP0000 @DivisionID, @TransactionID OUTPUT,'AT6510','CFT',@Year,'',20,3,0,'-'
	Insert Into AT6510 (TransactionID, DivisionID, BaseCurrencyID, CurrencyID, ExchangeRate,
						ObjectID, Description, DueDate, Amount, FlowType)
	Values (@TransactionID, @DivisionID, @BaseCurrencyID, @CurrencyID, @ExchangeRate,
						@ObjectID, @ContractNo + '-' + @Description, @DueDate, @Amount, @FlowType) 
	Fetch Next From @cursor Into	@ContractNo, @CurrencyID, @ExchangeRate, @ObjectID,
								@Description, @DueDate, @Amount
End

Close @cursor

--Xu ly chi phi hoat dong, ngan sach chi phi 4
Set @FlowType = 3

Set @cursor = cursor static for
Select	AT9090.CurrencyID, isnull(AT6511.ExchangeRate,0), AT9090.ObjectID,
		AT9090.TDescription, AT9090.DueDate,
		isnull(AT9090.OriginalAmount,0) As Amount
From	AT9090 
Left Join AT6511 On	AT9090.CurrencyID = AT6511.CurrencyID And AT6511.DivisionID = AT9090.DivisionID		
Where AT9090.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) And AT9090.BudgetType = 'P4' And Isnull(AT9090.DebitAccountID,'')<>'' 
	AND CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9090.DueDate,101),101) >= CONVERT(VARCHAR(10),@Date,101)

Open @cursor
Fetch Next From @cursor Into	@CurrencyID, @ExchangeRate, @ObjectID,
								@Description, @DueDate, @Amount
While @@FETCH_STATUS = 0
Begin
	EXEC AP0000 @DivisionID, @TransactionID OUTPUT,'AT6510','CFT',@Year,'',20,3,0,'-'
	Insert Into AT6510 (TransactionID, DivisionID, BaseCurrencyID, CurrencyID, ExchangeRate,
						ObjectID, Description, DueDate, Amount, FlowType)
	Values (@TransactionID, @DivisionID, @BaseCurrencyID, @CurrencyID, @ExchangeRate,
						@ObjectID, @Description, @DueDate, @Amount, @FlowType) 
	Fetch Next From @cursor Into	@CurrencyID, @ExchangeRate, @ObjectID,
								@Description, @DueDate, @Amount
End

Close @cursor

--Xu ly chi phi khac, ngan sach chi phi 5
Set @FlowType = 4

Set @cursor = cursor static for
Select	AT9090.CurrencyID, isnull(AT6511.ExchangeRate,0), AT9090.ObjectID,
		AT9090.TDescription, AT9090.DueDate,
		isnull(AT9090.OriginalAmount,0) As Amount
From AT9090 Left Join AT6511 
On AT9090.CurrencyID = AT6511.CurrencyID And AT9090.DivisionID = AT6511.DivisionID
Where AT9090.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) And AT9090.BudgetType = 'P5' And Isnull(AT9090.DebitAccountID,'')<>''
And CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9090.DueDate,101),101) >= CONVERT(VARCHAR(10),@Date,101)

Open @cursor
Fetch Next From @cursor Into	@CurrencyID, @ExchangeRate, @ObjectID,
								@Description, @DueDate, @Amount
While @@FETCH_STATUS = 0
Begin
	EXEC AP0000 @DivisionID, @TransactionID OUTPUT,'AT6510','CFT',@Year,'',20,3,0,'-'
	Insert Into AT6510 (TransactionID, DivisionID, BaseCurrencyID, CurrencyID, ExchangeRate,
						ObjectID, Description, DueDate, Amount, FlowType)
	Values (@TransactionID, @DivisionID, @BaseCurrencyID, @CurrencyID, @ExchangeRate,
						@ObjectID, @Description, @DueDate, @Amount, @FlowType) 
	Fetch Next From @cursor Into	@CurrencyID, @ExchangeRate, @ObjectID,
								@Description, @DueDate, @Amount
End

Close @cursor

--Xu ly thu chua ky HD, ngan sach doanh thu 4
Set @FlowType = 5

Set @cursor = cursor static for
Select	AT9090.CurrencyID, isnull(AT6511.ExchangeRate,0), AT9090.ObjectID,
		AT9090.TDescription, AT9090.DueDate,
		isnull(AT9090.OriginalAmount,0) As Amount
From AT9090 
Left Join AT6511 On AT9090.CurrencyID = AT6511.CurrencyID And AT6511.DivisionID = AT9090.DivisionID		
Where AT9090.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) And AT9090.BudgetType = 'P4' And Isnull(AT9090.CreditAccountID,'')<>''
And CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9090.DueDate,101),101) >= CONVERT(VARCHAR(10),@Date,101)

Open @cursor
Fetch Next From @cursor Into	@CurrencyID, @ExchangeRate, @ObjectID,
								@Description, @DueDate, @Amount
While @@FETCH_STATUS = 0
Begin
	EXEC AP0000 @DivisionID, @TransactionID OUTPUT,'AT6510','CFT',@Year,'',20,3,0,'-'
	Insert Into AT6510 (TransactionID, DivisionID, BaseCurrencyID, CurrencyID, ExchangeRate,
						ObjectID, Description, DueDate, Amount, FlowType)
	Values (@TransactionID, @DivisionID, @BaseCurrencyID, @CurrencyID, @ExchangeRate,
						@ObjectID, @Description, @DueDate, @Amount, @FlowType) 
	Fetch Next From @cursor Into	@CurrencyID, @ExchangeRate, @ObjectID,
								@Description, @DueDate, @Amount
End

Close @cursor

--Xu ly thu khac, ngan sach doanh thu 5
Set @FlowType = 6

Set @cursor = cursor static for
Select	AT9090.CurrencyID, isnull(AT6511.ExchangeRate,0), AT9090.ObjectID,
		AT9090.TDescription, AT9090.DueDate,
		isnull(AT9090.OriginalAmount,0) As Amount
From AT9090 Left Join AT6511 
On AT9090.CurrencyID = AT6511.CurrencyID And AT6511.DivisionID = AT9090.DivisionID		
Where AT9090.DivisionID IN (SELECT DivisionID FROM A00007 WHERE SPID = @@SPID) And AT9090.BudgetType = 'P5' And Isnull(AT9090.CreditAccountID,'')<>''
And CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9090.DueDate,101),101) >= CONVERT(VARCHAR(10),@Date,101)

Open @cursor
Fetch Next From @cursor Into	@CurrencyID, @ExchangeRate, @ObjectID,
								@Description, @DueDate, @Amount
While @@FETCH_STATUS = 0
Begin
	EXEC AP0000 @DivisionID, @TransactionID OUTPUT,'AT6510','CFT',@Year,'',20,3,0,'-'
	Insert Into AT6510 (TransactionID, DivisionID, BaseCurrencyID, CurrencyID, ExchangeRate,
						ObjectID, Description, DueDate, Amount, FlowType)
	Values (@TransactionID, @DivisionID, @BaseCurrencyID, @CurrencyID, @ExchangeRate,
						@ObjectID, @Description, @DueDate, @Amount, @FlowType) 
	Fetch Next From @cursor Into	@CurrencyID, @ExchangeRate, @ObjectID,
								@Description, @DueDate, @Amount
End

Close @cursor

-- Goi Store AP6511 de tao view AV6510, AV6511 de in bao cao
EXEC AP6511 @DivisionID , @Date , @Type , @ColNumber

DELETE FROM	A00007 WHERE SPID = @@SPID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

