/****** Object:  StoredProcedure [dbo].[AP0255]    Script Date: 11/10/2011 17:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP0255]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP0255]
GO


/****** Object:  StoredProcedure [dbo].[AP0255]    Script Date: 11/10/2011 17:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
Created by: Đặng Lê Bảo Quỳnh; Date: 8/11/2011
Purpose: In báo cáo AR0255: Báo cáo theo dõi chi tiết đơn hàng
*/
CREATE PROCEDURE [dbo].[AP0255]
	@DivisionID nvarchar(50),
	@IsPeriod bit, @FromPeriodIntType int, @ToPeriodIntType int, 
	@FromDate datetime, @ToDate datetime, 
	@IsAll bit, @SOrderID nvarchar(50),
	@FromAccountIDPA nvarchar(50), @ToAccountIDPA nvarchar(50), 
	@FromAccountIDRE nvarchar(50), @ToAccountIDRE nvarchar(50), 
	@FromAccountIDCO nvarchar(50), @ToAccountIDCO nvarchar(50),
	@Filter nvarchar(4000) = ''

	
AS
DECLARE @SQL1 as nvarchar(4000),
		@SQL2 as nvarchar(4000),
		@SQL3 as nvarchar(4000),
		@SQL4 as nvarchar(4000)
		
--Xử lý nhóm G01, Expenses
Set @SQL1 =
'Select 
OT2001.DivisionID, OT2001.OrderDate, OT2001.SOrderID, OT2001.Notes, OT2001.ShipDate As DeliveryDate, 
OT2001.EmployeeID, AT1103.FullName, 
OT2001.Varchar01,
OT2001.Varchar02,
OT2001.Varchar03,
OT2001.Varchar04,
OT2001.Varchar05,
OT2001.Varchar06,
OT2001.Varchar07,
OT2001.Varchar08,
OT2001.Varchar09,
OT2001.Varchar10,
OT2001.Varchar11,
OT2001.Varchar12,
OT2001.Varchar13,
OT2001.Varchar14,
OT2001.Varchar15,
OT2001.Varchar16,
OT2001.Varchar17,
OT2001.Varchar18,
OT2001.Varchar19,
OT2001.Varchar20,
''G01'' As GroupID,
0 As GroupID2,
G01.ObjectID,
G01.ObjectName,
G01.O01Name As [Type],
G01.VoucherNo As VoucherNo,
G01.VoucherDate As [Date],
G01.OriginalAmount,
G01.ConvertedAmount  
From OT2001 
Left Join AT1103 On OT2001.DivisionID = AT1103.DivisionID And OT2001.EmployeeID = AT1103.EmployeeID
Inner Join 
(Select AT9000.DivisionID, AT9000.Ana01ID, AT9000.ObjectID, AT1202.ObjectName, AT1015.AnaName As O01Name, AT9000.VoucherNo, AT9000.VoucherDate, Sum(isnull(AT9000.OriginalAmount,0)) As OriginalAmount, Sum(isnull(AT9000.ConvertedAmount,0)) As ConvertedAmount
 From AT9000 Left Join AT1202 On AT9000.DivisionID = AT1202.DivisionID And AT9000.ObjectID = AT1202.ObjectID
 Left Join AT1015 on AT1202.DivisionID = AT1015.DivisionID And AT1202.O01ID = AT1015.AnaID And AT1015.AnaTypeID = ''O01''  
 Where TransactionTypeID = ''T03'' And isnull(OrderID,'''')<>'''' And Isnull(InvoiceNo,'''')<>''''
  Group By AT9000.DivisionID, AT9000.Ana01ID, AT9000.ObjectID, AT1202.ObjectName, AT1015.AnaName, AT9000.VoucherNo, AT9000.VoucherDate
 ) G01 On OT2001.DivisionID = G01.DivisionID And OT2001.SOrderID = G01.Ana01ID
Where OT2001.DivisionID = ''' + @DivisionID + ''' And OT2001.OrderType = 0 And OT2001.OrderStatus In (1,2,3,4,5) '

If @IsAll = 0
	Set @SQL1 = @SQL1 + ' And SOrderID = ''' + @SOrderID + ''''
If @IsPeriod = 1
	Set @SQL1 = @SQL1 + ' And (OT2001.TranMonth + OT2001.TranYear*12 Between ' + LTRIM(@FromPeriodIntType) + ' And ' + LTRIM(@ToPeriodIntType) + ') ' 
Else
	Set @SQL1 = @SQL1 + ' And (OT2001.OrderDate Between ''' + LTRIM(@FromDate) + ''' And ''' + LTRIM(@ToDate) + ''') ' 

If ISNULL(@Filter,'')<>''
	Set @SQL1 = @SQL1 + ' And ' + @Filter

Set @SQL1 = @SQL1 + 
'
Union All

Select 
OT2001.DivisionID, OT2001.OrderDate, OT2001.SOrderID, OT2001.Notes, OT2001.ShipDate As DeliveryDate, 
OT2001.EmployeeID, AT1103.FullName, 
OT2001.Varchar01,
OT2001.Varchar02,
OT2001.Varchar03,
OT2001.Varchar04,
OT2001.Varchar05,
OT2001.Varchar06,
OT2001.Varchar07,
OT2001.Varchar08,
OT2001.Varchar09,
OT2001.Varchar10,
OT2001.Varchar11,
OT2001.Varchar12,
OT2001.Varchar13,
OT2001.Varchar14,
OT2001.Varchar15,
OT2001.Varchar16,
OT2001.Varchar17,
OT2001.Varchar18,
OT2001.Varchar19,
OT2001.Varchar20,
''G01'' As GroupID,
1 As GroupID2,
G01.ObjectID,
G01.ObjectName,
G01.O01Name As [Type],
G01.VoucherNo As VoucherNo,
G01.VoucherDate As [Date],
G01.OriginalAmount,
G01.ConvertedAmount  
From OT2001 
Left Join AT1103 On OT2001.DivisionID = AT1103.DivisionID And OT2001.EmployeeID = AT1103.EmployeeID
Inner Join 
(Select AT9000.DivisionID, AT9000.Ana01ID, AT9000.ObjectID, AT1202.ObjectName, AT1015.AnaName As O01Name, AT9000.VoucherNo, AT9000.VoucherDate, Sum(isnull(AT9000.OriginalAmount,0)) As OriginalAmount, Sum(isnull(AT9000.ConvertedAmount,0)) As ConvertedAmount
 From AT9000 Left Join AT1202 On AT9000.DivisionID = AT1202.DivisionID And AT9000.ObjectID = AT1202.ObjectID
 Left Join AT1015 on AT1202.DivisionID = AT1015.DivisionID And AT1202.O01ID = AT1015.AnaID And AT1015.AnaTypeID = ''O01''  
 Where TransactionTypeID = ''T03'' And isnull(OrderID,'''')<>'''' And Isnull(InvoiceNo,'''')='''' 
  Group By AT9000.DivisionID, AT9000.Ana01ID, AT9000.ObjectID, AT1202.ObjectName, AT1015.AnaName, AT9000.VoucherNo, AT9000.VoucherDate
 ) G01 On OT2001.DivisionID = G01.DivisionID And OT2001.SOrderID = G01.Ana01ID
Where OT2001.DivisionID = ''' + @DivisionID + ''' And OT2001.OrderType = 0 And OT2001.OrderStatus In (1,2,3,4,5) '

If @IsAll = 0
	Set @SQL1 = @SQL1 + ' And SOrderID = ''' + @SOrderID + ''''
If @IsPeriod = 1
	Set @SQL1 = @SQL1 + ' And (OT2001.TranMonth + OT2001.TranYear*12 Between ' + LTRIM(@FromPeriodIntType) + ' And ' + LTRIM(@ToPeriodIntType) + ') ' 
Else
	Set @SQL1 = @SQL1 + ' And (OT2001.OrderDate Between ''' + LTRIM(@FromDate) + ''' And ''' + LTRIM(@ToDate) + ''') ' 
	
If ISNULL(@Filter,'')<>''
	Set @SQL1 = @SQL1 + ' And ' + @Filter

--Xử lý nhóm G02, Sales Invoice
Set @SQL2 =
'Select 
OT2001.DivisionID, OT2001.OrderDate, OT2001.SOrderID, OT2001.Notes, OT2001.ShipDate As DeliveryDate, 
OT2001.EmployeeID, AT1103.FullName, 
OT2001.Varchar01,
OT2001.Varchar02,
OT2001.Varchar03,
OT2001.Varchar04,
OT2001.Varchar05,
OT2001.Varchar06,
OT2001.Varchar07,
OT2001.Varchar08,
OT2001.Varchar09,
OT2001.Varchar10,
OT2001.Varchar11,
OT2001.Varchar12,
OT2001.Varchar13,
OT2001.Varchar14,
OT2001.Varchar15,
OT2001.Varchar16,
OT2001.Varchar17,
OT2001.Varchar18,
OT2001.Varchar19,
OT2001.Varchar20,
''G02'' As GroupID,
0 As GroupID2,
G01.ObjectID,
G01.ObjectName,
G01.O01Name As [Type],
G01.VoucherNo As VoucherNo,
G01.VoucherDate As [Date],
G01.OriginalAmount,
G01.ConvertedAmount  
From OT2001 
Left Join AT1103 On OT2001.DivisionID = AT1103.DivisionID And OT2001.EmployeeID = AT1103.EmployeeID
Inner Join 
(Select AT9000.DivisionID, AT9000.Ana01ID, AT9000.ObjectID, AT1202.ObjectName, AT1015.AnaName As O01Name, AT9000.VoucherNo, AT9000.VoucherDate, Sum(isnull(AT9000.OriginalAmount,0)) As OriginalAmount, Sum(isnull(AT9000.ConvertedAmount,0)) As ConvertedAmount
 From AT9000 Left Join AT1202 On AT9000.DivisionID = AT1202.DivisionID And AT9000.ObjectID = AT1202.ObjectID
 Left Join AT1015 on AT1202.DivisionID = AT1015.DivisionID And AT1202.O01ID = AT1015.AnaID And AT1015.AnaTypeID = ''O01''  
 Where TransactionTypeID = ''T04'' 
  Group By AT9000.DivisionID, AT9000.Ana01ID, AT9000.ObjectID, AT1202.ObjectName, AT1015.AnaName, AT9000.VoucherNo, AT9000.VoucherDate
 ) G01 On OT2001.DivisionID = G01.DivisionID And OT2001.SOrderID = G01.Ana01ID
Where OT2001.DivisionID = ''' + @DivisionID + ''' And OT2001.OrderType = 0 And OT2001.OrderStatus In (1,2,3,4,5) '

If @IsAll = 0
	Set @SQL2 = @SQL2 + ' And SOrderID = ''' + @SOrderID + ''''
If @IsPeriod = 1
	Set @SQL2 = @SQL2 + ' And (OT2001.TranMonth + OT2001.TranYear*12 Between ' + LTRIM(@FromPeriodIntType) + ' And ' + LTRIM(@ToPeriodIntType) + ') ' 
Else
	Set @SQL2 = @SQL2 + ' And (OT2001.OrderDate Between ''' + LTRIM(@FromDate) + ''' And ''' + LTRIM(@ToDate) + ''') ' 

If ISNULL(@Filter,'')<>''
	Set @SQL2 = @SQL2 + ' And ' + @Filter

--Xử lý nhóm G03, Gen Jnl Entries, lấy từ bút toán phân bổ chi phí theo mã phân tích AT9001
Set @SQL3 =
'Select 
OT2001.DivisionID, OT2001.OrderDate, OT2001.SOrderID, OT2001.Notes, OT2001.ShipDate As DeliveryDate, 
OT2001.EmployeeID, AT1103.FullName, 
OT2001.Varchar01,
OT2001.Varchar02,
OT2001.Varchar03,
OT2001.Varchar04,
OT2001.Varchar05,
OT2001.Varchar06,
OT2001.Varchar07,
OT2001.Varchar08,
OT2001.Varchar09,
OT2001.Varchar10,
OT2001.Varchar11,
OT2001.Varchar12,
OT2001.Varchar13,
OT2001.Varchar14,
OT2001.Varchar15,
OT2001.Varchar16,
OT2001.Varchar17,
OT2001.Varchar18,
OT2001.Varchar19,
OT2001.Varchar20,
''G03'' As GroupID,
0 As GroupID2,
G01.ObjectID,
G01.ObjectName,
G01.AccountName As [Type],
G01.VoucherNo As VoucherNo,
G01.VoucherDate As [Date],
G01.OriginalAmount,
G01.ConvertedAmount  
From OT2001 
Left Join AT1103 On OT2001.DivisionID = AT1103.DivisionID And OT2001.EmployeeID = AT1103.EmployeeID
Inner Join 
(Select AT9000.DivisionID, AT9000.Ana01ID, Null As ObjectID, Null As ObjectName, AT1015.AnaName As O01Name, Null As VoucherNo, Null As VoucherDate,
(Case When AT9000.DebitAccountID like ''622%'' Or AT9000.DebitAccountID like ''627%'' Then AT9000.DebitAccountID Else AT9000.CreditAccountID End) As AccountID,
(Case When AT9000.DebitAccountID like ''622%'' Or AT9000.DebitAccountID like ''627%'' Then DAcc.AccountName Else CAcc.AccountName End) As AccountName, 
Sum(isnull((Case When AT9000.DebitAccountID like ''622%'' Or AT9000.DebitAccountID like ''627%'' Then AT9000.OriginalAmount Else -AT9000.OriginalAmount End),0)) As OriginalAmount, 
Sum(isnull((Case When AT9000.DebitAccountID like ''622%'' Or AT9000.DebitAccountID like ''627%'' Then AT9000.ConvertedAmount Else -AT9000.ConvertedAmount End),0)) As ConvertedAmount
 From AT9001 AT9000 Left Join AT1202 On AT9000.DivisionID = AT1202.DivisionID And AT9000.ObjectID = AT1202.ObjectID
 Left Join AT1015 on AT1202.DivisionID = AT1015.DivisionID And AT1202.O01ID = AT1015.AnaID And AT1015.AnaTypeID = ''O01''
 Left Join AT1005 DAcc On AT9000.DivisionID = DAcc.DivisionID And AT9000.DebitAccountID = DAcc.AccountID
 Left Join AT1005 CAcc On AT9000.DivisionID = CAcc.DivisionID And AT9000.CreditAccountID = CAcc.AccountID  
 Where (AT9000.DebitAccountID like ''622%'' Or AT9000.DebitAccountID like ''627%'' Or AT9000.CreditAccountID like ''622%'' Or AT9000.CreditAccountID like ''627%'')
  Group By AT9000.DivisionID, AT9000.Ana01ID, AT1015.AnaName, 
  (Case When AT9000.DebitAccountID like ''622%'' Or AT9000.DebitAccountID like ''627%'' Then AT9000.DebitAccountID Else AT9000.CreditAccountID End),
  (Case When AT9000.DebitAccountID like ''622%'' Or AT9000.DebitAccountID like ''627%'' Then DAcc.AccountName Else CAcc.AccountName End)
 ) G01 On OT2001.DivisionID = G01.DivisionID And OT2001.SOrderID = G01.Ana01ID
Where OT2001.DivisionID = ''' + @DivisionID + ''' And OT2001.OrderType = 0 And OT2001.OrderStatus In (1,2,3,4,5) '

If @IsAll = 0
	Set @SQL3 = @SQL3 + ' And SOrderID = ''' + @SOrderID + ''''
If @IsPeriod = 1
	Set @SQL3 = @SQL3 + ' And (OT2001.TranMonth + OT2001.TranYear*12 Between ' + LTRIM(@FromPeriodIntType) + ' And ' + LTRIM(@ToPeriodIntType) + ') ' 
Else
	Set @SQL3 = @SQL3 + ' And (OT2001.OrderDate Between ''' + LTRIM(@FromDate) + ''' And ''' + LTRIM(@ToDate) + ''') ' 

If ISNULL(@Filter,'')<>''
	Set @SQL3 = @SQL3 + ' And ' + @Filter	

--Xử lý nhóm G04, Chi phí bán hàng
Set @SQL4 =
'Select 
OT2001.DivisionID, OT2001.OrderDate, OT2001.SOrderID, OT2001.Notes, OT2001.ShipDate As DeliveryDate, 
OT2001.EmployeeID, AT1103.FullName, 
OT2001.Varchar01,
OT2001.Varchar02,
OT2001.Varchar03,
OT2001.Varchar04,
OT2001.Varchar05,
OT2001.Varchar06,
OT2001.Varchar07,
OT2001.Varchar08,
OT2001.Varchar09,
OT2001.Varchar10,
OT2001.Varchar11,
OT2001.Varchar12,
OT2001.Varchar13,
OT2001.Varchar14,
OT2001.Varchar15,
OT2001.Varchar16,
OT2001.Varchar17,
OT2001.Varchar18,
OT2001.Varchar19,
OT2001.Varchar20,
''G04'' As GroupID,
0 As GroupID2,
G01.ObjectID,
G01.ObjectName,
G01.AccountName As [Type],
G01.VoucherNo As VoucherNo,
G01.VoucherDate As [Date],
G01.OriginalAmount,
G01.ConvertedAmount  
From OT2001 
Left Join AT1103 On OT2001.DivisionID = AT1103.DivisionID And OT2001.EmployeeID = AT1103.EmployeeID
Left Join 
(Select AT9000.DivisionID, AT9000.Ana01ID, Null As ObjectID, Null As ObjectName, AT1015.AnaName As O01Name, Null As VoucherNo, AT9000.VoucherDate,
(Case When AT9000.DebitAccountID like ''641%'' Then AT9000.DebitAccountID Else AT9000.CreditAccountID End) As AccountID,
(Case When AT9000.DebitAccountID like ''641%'' Then DAcc.AccountName Else CAcc.AccountName End) As AccountName, 
Sum(isnull((Case When DebitAccountID Like ''641%'' Then AT9000.OriginalAmount Else -AT9000.OriginalAmount End),0)) As OriginalAmount, 
Sum(isnull((Case When DebitAccountID Like ''641%'' Then AT9000.ConvertedAmount Else -AT9000.ConvertedAmount End),0)) As ConvertedAmount
 From AT9000 Left Join AT1202 On AT9000.DivisionID = AT1202.DivisionID And AT9000.ObjectID = AT1202.ObjectID
 Left Join AT1015 on AT1202.DivisionID = AT1015.DivisionID And AT1202.O01ID = AT1015.AnaID And AT1015.AnaTypeID = ''O01''
 Left Join AT1005 DAcc On AT9000.DivisionID = DAcc.DivisionID And AT9000.DebitAccountID = DAcc.AccountID
 Left Join AT1005 CAcc On AT9000.DivisionID = CAcc.DivisionID And AT9000.CreditAccountID = CAcc.AccountID  
 Where (AT9000.DebitAccountID Like ''641%'' Or AT9000.CreditAccountID Like ''641%'')
  Group By AT9000.DivisionID, AT9000.Ana01ID, AT1015.AnaName, AT9000.VoucherDate, 
  (Case When AT9000.DebitAccountID like ''641%'' Then AT9000.DebitAccountID Else AT9000.CreditAccountID End),
  (Case When AT9000.DebitAccountID like ''641%'' Then DAcc.AccountName Else CAcc.AccountName End)
 ) G01 On OT2001.DivisionID = G01.DivisionID And OT2001.SOrderID = G01.Ana01ID
Where OT2001.DivisionID = ''' + @DivisionID + ''' And OT2001.OrderType = 0 And OT2001.OrderStatus In (1,2,3,4,5) '

If @IsAll = 0
	Set @SQL4 = @SQL4 + ' And SOrderID = ''' + @SOrderID + ''''
If @IsPeriod = 1
	Set @SQL4 = @SQL4 + ' And (OT2001.TranMonth + OT2001.TranYear*12 Between ' + LTRIM(@FromPeriodIntType) + ' And ' + LTRIM(@ToPeriodIntType) + ') ' 
Else
	Set @SQL4 = @SQL4 + ' And (OT2001.OrderDate Between ''' + LTRIM(@FromDate) + ''' And ''' + LTRIM(@ToDate) + ''') ' 

If ISNULL(@Filter,'')<>''
	Set @SQL4 = @SQL4 + ' And ' + @Filter	
		
PRINT (@SQL4)
EXEC (@SQL1 + ' Union All ' + @SQL2 + ' Union All ' + @SQL3 + ' Union All ' + @SQL4)


GO

