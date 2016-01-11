IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0124]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0124]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bảo Anh	Date: 30/10/2013
---- Purpose : Hiển thị danh sách tiền thưởng hoa hồng
---- Modify on 08/12/2013 by Bảo Anh: Bổ sung từ đơn hàng, đến đơn hàng
---- Modify on 09/12/2013 by Bảo Anh: Sửa cách lấy số liệu khi bảng OT0123 tách đơn hàng theo từng hợp đồng
---- Modify on 01/07/2014 by Bảo Anh: Lấy cấp hiện tại
---- OP0124 'AS',3,2012,'03/01/2012','03/04/2012',1,'%','%','SO/03/2012/0001','SO/03/2012/0001'

CREATE PROCEDURE [dbo].[OP0124]
	@DivisionID nvarchar(50),
	@TranMonth int,
	@TranYear int,
	@FromDate datetime,
	@ToDate datetime,
	@IsDate tinyint,
	@ObjectID varchar(50),
	@SalesmanID varchar(50),
	@FromSOrderID nvarchar(50),
	@ToSOrderID nvarchar(50)
	
AS

DECLARE @SQL nvarchar(4000),
		@ContractAnaTypeID AS NVARCHAR(50),
		@sWhere  as nvarchar(4000)

SET @ContractAnaTypeID = ISNULL((SELECT TOP 1 SalesContractAnaTypeID FROM AT0000 WHERE DefDivisionID = @DivisionID), 'A03')

IF @IsDate = 0
	Set  @sWhere = 'And (OT2001.TranMonth + OT2001.TranYear*100 = ' + cast(@TranMonth + @TranYear*100 as nvarchar(50)) + ')'
else
	Set  @sWhere = 'And (OT2001.OrderDate Between '''+Convert(nvarchar(10),@FromDate,21)+''' and '''+convert(nvarchar(10), @ToDate,21)+''')'

SET @SQL = 'SELECT distinct * FROM (
			SELECT T23.OrderID, T23.SalesmanID as EmployeeID, T02.ObjectName as EmployeeName,
					---(case when T23.UpLevelNo is NULL then T23.PreLevelNo else T23.UpLevelNo end) as LevelNo,
					T02.LevelNo, T23.OrderNo,
					T23.ContractNo, OT2001.VoucherNo, OT2001.OrderDate, OT2001.ObjectID, AT1202.ObjectName,
					T23.OrderAmount, T23.AccAmount, T23.SalesPercent, T23.SamePercent, T23.ExtendPercent,
					T23.SalesAmount, T23.SameAmount, T23.ExtendAmount
			
			FROM OT0123 T23
			INNER JOIN OT2001 On T23.DivisionID = OT2001.DivisionID And T23.OrderID = OT2001.SOrderID
			LEFT JOIN AT1202 On OT2001.DivisionID = AT1202.DivisionID And OT2001.ObjectID = AT1202.ObjectID
			LEFT JOIN AT1202 T02 On T23.DivisionID = T02.DivisionID And T23.SalesmanID = T02.ObjectID And T02.ObjectTypeID = ''NV''
			
			WHERE T23.DivisionID = ''' + @DivisionID + ''' AND T23.SalesmanID like ''' + @SalesmanID + '''
			AND OT2001.ObjectID like ''' + @ObjectID + ''' ' + @sWhere + '
			AND (T23.OrderID between ''' + @FromSOrderID + ''' And ''' + @ToSOrderID + ''')
	
			) A
			ORDER BY OrderDate, OrderID, ContractNo, OrderNo, LevelNo, EmployeeID'
			
EXEC (@SQL)