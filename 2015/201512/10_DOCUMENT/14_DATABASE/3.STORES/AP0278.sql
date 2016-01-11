IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0278]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0278]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by: Bao Anh		Date: 31/10/2013
--- Purpose: load detail cho màn hình kế thừa hợp đồng (AF0277)
--- EXEC AP0278 'AS','CT20120000000003,CT20120000000004','AV20120000000028'
--- Modify on 05/11/2013 by Bảo Anh: Bổ sung đối tượng chuyển nhượng
--- Modify on 14/03/2014 by Bảo Anh: Bổ sung Ana08ID, Ana08Name lấy từ đơn hàng bán (Sinolife)

CREATE PROCEDURE [dbo].[AP0278] @DivisionID nvarchar(50),				
				@lstContractID nvarchar(4000),
				@VoucherID nvarchar(50) --- Addnew   truyen ''; Load Edit :  so chung tu vua duoc chon sua			
				
AS
Declare @sSQL  nvarchar(4000),
		@sSQL1 nvarchar(4000)

SET @sSQL1 = ''
Set  @lstContractID = 	Replace(@lstContractID, ',', ''',''')

IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#TAM')) 
	DROP TABLE #TAM

CREATE TABLE #TAM
(
	DivisionID nvarchar(50),
	ContractID nvarchar(50),
	ContractDetailID nvarchar(50),
	Amount decimal(28,8),
	EndAmount decimal(28,8)
)

Set  @sSQL = '
INSERT INTO #TAM (DivisionID, ContractID, ContractDetailID, Amount, EndAmount)
Select 
	AT1020.DivisionID, AT1020.ContractID, AT1021.ContractDetailID, AT1021.PaymentAmount,
	(isnull(PaymentAmount, 0) - isnull(PaymentAmountPT,0)) as EndAmount
	
From AT1020
inner join AT1021 on AT1020.DivisionID = AT1021.DivisionID and AT1020.ContractID = AT1021.ContractID

Left join (
	Select DivisionID, ContractDetailID, sum(OriginalAmount) As PaymentAmountPT
	From AT9000
	Where DivisionID = ''' + @DivisionID + '''
		and isnull(ContractDetailID,'''') <> '''' and TransactionTypeID IN (''T01'',''T21'')
	Group by DivisionID, ContractDetailID
	) as K  on AT1021.DivisionID = K.DivisionID and
			AT1021.ContractDetailID = K.ContractDetailID

WHERE AT1020.DivisionID = ''' + @DivisionID + ''' and AT1020.ContractID in (''' + @lstContractID + ''')
'
EXEC(@sSQL)

Set @sSQL ='
	Select	AT1021.ContractID, AT1021.ContractDetailID, AT1020.ContractNo, AT1021.TransferObjectID, AT1020.ObjectID, T02.ObjectName as TransferObjectName,
			AT1202.ObjectName as ObjectName, T02.VATNo as TransferVATNo, AT1202.VATNo,
			AT1020.CurrencyID, AT1004.ExchangeRate, AT1020.Description, AT1021.StepID, AT1021.StepName, AT1021.StepDays,
			AT1021.PaymentPercent, AT1021.PaymentAmount, AT1021.StepStatus, AT1021.CompleteDate, AT1021.PaymentDate,
			AT1021.PaymentStatus, AT1021.Paymented, AT1021.Notes, cast(1 as tinyint) as IsCheck, Isnull(AT1021.IsTransfer,0) as IsTransfer,
			(AT1021.PaymentAmount - Isnull(AT1021.Paymented,0)) as EndOAmount,
			((AT1021.PaymentAmount - Isnull(AT1021.Paymented,0)) * AT1004.ExchangeRate) as EndCAmount,
			ISNULL((SELECT TOP 1 SalesContractAnaTypeID FROM AT0000 WHERE DefDivisionID = ''' + @DivisionID + '''), ''A03'') as ContractAnaTypeID,
			(Select Ana08ID From OT2002 Where DivisionID = ''' + @DivisionID + '''  and SOrderID = AT1020.SOrderID and TransactionID = AT1020.STransactionID) as Ana08ID,
			(Select AnaName from AT1011 Where DivisionID = ''' + @DivisionID + ''' and AnaTypeID = ''A08''
			and AnaID = (Select Ana08ID From OT2002 Where DivisionID = ''' + @DivisionID + '''  and SOrderID = AT1020.SOrderID and TransactionID = AT1020.STransactionID)) as Ana08Name
	From AT9000
	Inner join AT1021 On AT1021.DivisionID = AT9000.DivisionID and AT1021.ContractDetailID = AT9000.ContractDetailID
	Inner join AT1020 On AT1021.DivisionID = AT1020.DivisionID and AT1021.ContractID = AT1020.ContractID
	Left join AT1202 On AT1020.DivisionID = AT1202.DivisionID And AT1020.ObjectID = AT1202.ObjectID
	Left join AT1202 T02 On AT1021.DivisionID = T02.DivisionID And AT1021.TransferObjectID = T02.ObjectID
	Left join AT1004 On AT1020.DivisionID = AT1004.DivisionID And AT1020.CurrencyID = AT1004.CurrencyID
	Where AT9000.DivisionID = ''' + @DivisionID + '''  and AT9000.VoucherID =  ''' + @VoucherID + '''
		and AT1020.ContractID in (''' + @lstContractID + ''')  
		and AT9000.TransactionTypeID in (''T01'',''T21'')
		and  isnull(AT9000.ContractDetailID,'''')  <> ''''
UNION '

SET @sSQL1 = '
	Select	AT1021.ContractID, AT1021.ContractDetailID, AT1020.ContractNo, AT1021.TransferObjectID, AT1020.ObjectID, T02.ObjectName as TransferObjectName,
			AT1202.ObjectName as ObjectName, T02.VATNo as TransferVATNo, AT1202.VATNo,
			AT1020.CurrencyID, AT1004.ExchangeRate, AT1020.Description,	AT1021.StepID, AT1021.StepName, AT1021.StepDays,
			AT1021.PaymentPercent, AT1021.PaymentAmount, AT1021.StepStatus, AT1021.CompleteDate, AT1021.PaymentDate,
			AT1021.PaymentStatus, AT1021.Paymented, AT1021.Notes, cast(0 as tinyint) as IsCheck, Isnull(AT1021.IsTransfer,0) as IsTransfer,
			(AT1021.PaymentAmount - Isnull(AT1021.Paymented,0)) as EndOAmount,
			((AT1021.PaymentAmount - Isnull(AT1021.Paymented,0)) * AT1004.ExchangeRate) as EndCAmount,
			ISNULL((SELECT TOP 1 SalesContractAnaTypeID FROM AT0000 WHERE DefDivisionID = ''' + @DivisionID + '''), ''A03'') as ContractAnaTypeID,
			(Select Ana08ID From OT2002 Where DivisionID = ''' + @DivisionID + '''  and SOrderID = AT1020.SOrderID and TransactionID = AT1020.STransactionID) as Ana08ID,
			(Select AnaName from AT1011 Where DivisionID = ''' + @DivisionID + ''' and AnaTypeID = ''A08''
			and AnaID = (Select Ana08ID From OT2002 Where DivisionID = ''' + @DivisionID + '''  and SOrderID = AT1020.SOrderID and TransactionID = AT1020.STransactionID)) as Ana08Name
	From AT1021
		Inner join AT1020 On AT1021.DivisionID = AT1020.DivisionID and AT1021.ContractID = AT1020.ContractID
		inner join #TAM V00 on AT1021.DivisionID = V00.DivisionID and AT1021.ContractID = V00.ContractID and AT1021.ContractDetailID = V00.ContractDetailID
		Left join AT1202 On AT1020.DivisionID = AT1202.DivisionID And AT1020.ObjectID = AT1202.ObjectID
		Left join AT1202 T02 On AT1021.DivisionID = T02.DivisionID And AT1021.TransferObjectID = T02.ObjectID
		Left join AT1004 On AT1020.DivisionID = AT1004.DivisionID And AT1020.CurrencyID = AT1004.CurrencyID
	Where  AT1021.DivisionID = ''' + @DivisionID + ''' and V00.EndAmount > 0'

If isnull (@VoucherID,'') <> '' --- truong hop edit
	EXEC('SELECT * FROM (' + @sSQL + @sSQL1 + ') A ' + 'Order by ContractNo, StepID')
Else 	--- truong hop add new
	EXEC('SELECT * FROM (' +@sSQL1 + ') A ' + 'Order by ContractNo, StepID')