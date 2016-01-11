IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0125]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0125]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bảo Anh	Date: 25/11/2013
---- Purpose : In danh sách tiền thưởng hoa hồng (customize Sinolife)
---- Modify on 08/12/2013 by Bảo Anh: Bổ sung từ đơn hàng, đến đơn hàng
---- Modify on 09/12/2013 by Bảo Anh: Sửa cách lấy số liệu khi bảng OT0123 tách đơn hàng theo từng hợp đồng
---- Modify on 10/12/2013 by Bảo Anh: Where thêm điều kiện hợp đồng khi lấy trường thực chi ActualPayAmount
---- OP0125 'AS',3,2012,'02/01/2012','03/04/2012',1,'%','%','SO/03/2012/0001','SO/03/2012/0001','','Order by SalesmanID'

CREATE PROCEDURE [dbo].[OP0125]
	@DivisionID nvarchar(50),
	@TranMonth int,
	@TranYear int,
	@FromDate datetime,
	@ToDate datetime,
	@IsDate tinyint,
	@ObjectID varchar(50),
	@SalesmanID varchar(50),
	@FromSOrderID nvarchar(50),
	@ToSOrderID nvarchar(50),
	@Where varchar(4000) = '',
	@Orderby varchar(4000) = ''
	
AS

DECLARE @SQL nvarchar(4000),
		@sWhereTime nvarchar(4000)
	
IF @IsDate = 0
	Set  @sWhereTime = ' And (OT01.TranMonth + OT01.TranYear*100 = ' + cast(@TranMonth + @TranYear*100 as nvarchar(50)) + ')'
ELSE
	Set  @sWhereTime = ' And (OT01.OrderDate Between ''' + Convert(nvarchar(10),@FromDate,21) + ''' and ''' + convert(nvarchar(10), @ToDate,21)+''')'
	
SET @SQL = 'SELECT * FROM (
SELECT distinct	OT23.DivisionID, OT23.OrderID,OT01.OrderDate, OT23.SalesmanID, AT1202.ObjectName as SalesmanName, AT1202.AccAmount as SalesmanAmount, (case when Isnull(AT1202.VATNo,'''') = '''' then 20 else 10 end) as VATPercent,
		OT01.ObjectID, T02.ObjectName, OT23.ContractNo,
		(Select Sum(ConvertedAmount) From AT9000 Where DivisionID = OT23.DivisionID And TransactionTypeID = ''T22'' And Isnull(Ana03ID,'''') = ''PCK'' AND Isnull(ObjectID,'''') = OT23.SalesmanID) as TransferAmount,  
		(Select Sum(ConvertedAmount) From AT9000 Where DivisionID = OT23.DivisionID And TransactionTypeID = ''T22'' And Isnull(Ana03ID,'''') <> ''PCK'' AND Isnull(ObjectID,'''') = OT23.SalesmanID AND Isnull(Ana02ID,'''') = OT23.ContractNo) as ActualPayAmount,  
		Sum(OT23.SalesAmount) as SalesAmount, Sum(OT23.SameAmount) as SameAmount, Sum(OT23.ExtendAmount) as ExtendAmount

FROM OT0123 OT23
LEFT JOIN AT1202 on OT23.DivisionID = AT1202.DivisionID And OT23.SalesmanID = AT1202.ObjectID And AT1202.ObjectTypeID = ''NV''
INNER JOIN OT2001 OT01 ON OT23.DivisionID = OT01.DivisionID And OT23.OrderID = OT01.SOrderID
LEFT JOIN AT1202 T02 on OT01.DivisionID = T02.DivisionID And OT01.ObjectID = T02.ObjectID

WHERE OT23.DivisionID = ''' + @DivisionID + ''' AND OT01.ObjectID like ''' + @ObjectID + '''
AND OT23.SalesmanID like ''' + @SalesmanID + '''' + @sWhereTime + '
AND (OT23.OrderID between ''' + @FromSOrderID + ''' And ''' + @ToSOrderID + ''')

GROUP BY OT23.DivisionID, OT23.OrderID, OT23.SalesmanID, AT1202.ObjectName, AT1202.AccAmount, (case when Isnull(AT1202.VATNo,'''') = '''' then 20 else 10 end),
		OT01.ObjectID, T02.ObjectName, OT23.ContractNo,OT01.OrderDate
) A'

IF ltrim(rtrim(@Where)) <> ''
	SET @SQL = @SQL + ' WHERE ' + @Where
	
IF ltrim(rtrim(@Orderby)) <> ''
	SET @SQL = @SQL + ' ' + @Orderby
	
EXEC(@SQL)