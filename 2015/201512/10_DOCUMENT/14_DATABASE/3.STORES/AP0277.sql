IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0277]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0277]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by: Bao Anh	Date: 30/10/2013
---- Purpose: Trả ra dữ liệu cho lưới Master (kế thừa hợp đồng - AF0277)
---- AP0277 N'AS','2012-05-04 00:00:00','2012-05-31 00:00:00',N'%',N'AV20120000000028','((''''))', '((0 = 0))'
---- Modify on 04/11/2013 by Bảo Anh: Sửa cách lấy đối tượng trong trường hợp chuyển nhượng

CREATE PROCEDURE [dbo].[AP0277] @DivisionID nvarchar(50),
								@FromDate as datetime,
								@ToDate as Datetime,				  
								@ObjectID nvarchar(50),				    
								@VoucherID nvarchar(50), --- Addnew   truyen ''; Load Edit :  so chung tu vua duoc chon sua						
								@ConditionOB nvarchar(max),
								@IsUsedConditionOB nvarchar(20)

AS
Declare
 @sSQL as varchar(max),
 @sWhere  as nvarchar(4000)
 
Set  @sWhere = ' And (SignDate Between ''' + Convert(nvarchar(10),@FromDate,21) + ''' and ''' + convert(nvarchar(10), @ToDate,21)+''')'

IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#TAM')) 
	DROP TABLE #TAM

CREATE TABLE #TAM
(
	ContractID nvarchar(50),
	EndAmount decimal(28,8)
)

Set  @sSQL = '
INSERT INTO #TAM (ContractID, EndAmount)
Select Top 100 percent ContractID, sum(isnull(EndAmount,0))
FROM (
Select 
	AT1020.DivisionID, AT1020.ContractID, AT1020.ContractType,
	AT1021.ContractDetailID, AT1021.PaymentAmount,
	(isnull(AT1021.PaymentAmount, 0) - isnull(K.AmountPT,0)) as EndAmount
From AT1020
inner join AT1021 on AT1020.DivisionID = AT1021.DivisionID and AT1020.ContractID = AT1021.ContractID

Left join (
	Select DivisionID, ContractDetailID, sum(OriginalAmount) As AmountPT
	From AT9000
	Where DivisionID = ''' + @DivisionID + ''' and Isnull(ObjectID,'''') like ''' + @ObjectID + '''
		and isnull(ContractDetailID,'''') <> '''' and TransactionTypeID IN (''T01'',''T21'')
		And (ISNULL(ObjectID, ''#'') IN (' + @ConditionOB + ') Or ' + @IsUsedConditionOB + ')
	Group by DivisionID, ContractDetailID
	) as K  on AT1021.DivisionID = K.DivisionID and
			AT1021.ContractDetailID = K.ContractDetailID

WHERE AT1020.DivisionID = ''' + @DivisionID + ''' and (Isnull(AT1020.ObjectID,'''') like ''' + @ObjectID + ''' or Isnull(AT1021.TransferObjectID,'''') like ''' + @ObjectID + ''')' + @sWhere + '
	And (ISNULL(AT1020.ObjectID, ''#'') IN (' + @ConditionOB + ') Or ' + @IsUsedConditionOB + ')) A
Where ContractType = 1 And EndAmount > 0
Group by ContractID'
---print @sSQL
EXEC(@sSQL)

if isnull(@VoucherID,'')<> ''	--- khi load edit

	Set  @sSQL ='SELECT * FROM ( 
	Select distinct top 100 percent AT1020.ContractID, ContractNo, ContractName, SignDate, AT1020.CurrencyID, AT1020.ObjectID, AT1202.ObjectName,
			AT1020.Description,cast(1 as tinyint) as IsCheck, AT1020.Amount---, (Select EndAmount From #TAM Where ContractID = AT1020.ContractID) as EndAmount
	From AT1020
	Inner Join AT1021 on AT1021.DivisionID = AT1020.DivisionID and AT1021.ContractID = AT1020.ContractID
	Inner join AT9000 on AT1021.DivisionID = AT9000.DivisionID and AT1021.ContractDetailID = AT9000.ContractDetailID
	Left Join AT1202 on AT1202.DivisionID = AT1020.DivisionID and AT1202.ObjectID = AT1020.ObjectID
	Where AT1020.DivisionID = ''' + @DivisionID + ''' And AT9000.VoucherID = ''' + @VoucherID + '''
	union

	Select distinct AT1020.ContractID, ContractNo, ContractName, SignDate, AT1020.CurrencyID, AT1020.ObjectID, AT1202.ObjectName,AT1020.Description,cast(0 as tinyint) as IsCheck, Amount---,(Select EndAmount From #TAM Where ContractID = AT1020.ContractID) as EndAmount
	From AT1020
	Left Join AT1202 on AT1202.DivisionID = AT1020.DivisionID and AT1202.ObjectID = AT1020.ObjectID
	Where		
		AT1020.ContractID In (Select ContractID From #TAM Where EndAmount > 0) 
		And AT1020.ContractID not in (Select top 1 ContractID From AT1021 Inner join AT9000 On AT1021.DivisionID = AT9000.DivisionID and AT1021.ContractDetailID = AT9000.ContractDetailID
								Where AT1021.DivisionID = ''' + @DivisionID + ''' And VoucherID = ''' + @VoucherID + ''')' + @sWhere + '
	) A'

else --- khi load add new

	Set @sSQL ='SELECT * FROM ( 
	Select ContractID, ContractNo, ContractName, SignDate, AT1020.CurrencyID, AT1020.ObjectID, AT1202.ObjectName,AT1020.Description,cast(0 as tinyint) as IsCheck, Amount---,(Select EndAmount From #TAM Where ContractID = AT1020.ContractID) as EndAmount
	From AT1020
	Left Join AT1202 on AT1202.DivisionID = AT1020.DivisionID and AT1202.ObjectID = AT1020.ObjectID
	Where		
		ContractID In (Select ContractID From #TAM Where EndAmount > 0)' + @sWhere + '
	) A'

SET @sSQL = @sSQL + ' ' + 'Order by SignDate, ContractNo'
---print @sSQL
EXEC(@sSQL)